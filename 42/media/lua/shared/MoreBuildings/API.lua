local Coordinator = require('MoreBuildings/internal/RegistrationCoordinator')
local TableUtil = require('MoreBuildings/internal/TableUtil')
local PublicPlacementKinds = require('MoreBuildings/PublicPlacementKinds')

local API = {
  API_VERSION = 1,
  kinds = PublicPlacementKinds,
}

local DEFINITION_FIELDS = {
  categoryId = true,
  descriptionKey = true,
  id = true,
  nameKey = true,
  placement = true,
  previewSprite = true,
  recipeId = true,
  salvagePolicy = true,
  sortKey = true,
}

local function errorInfo(code, path, message)
  return {
    code = code,
    message = message,
    path = path,
  }
end

local function callerSource()
  if debug and debug.getinfo then
    local info = debug.getinfo(3, 'S')
    if info and info.source then
      return info.source
    end
  end
  return '<unknown>'
end

local function fail(transaction, code, path, message)
  transaction.failure = errorInfo(code, path, message)
  error(message)
end

local function assertFields(transaction, value, fields, path)
  if type(value) ~= 'table' then
    fail(transaction, 'invalid-value', path, 'expected table: ' .. path)
  end
  for field in pairs(value) do
    if fields[field] ~= true then
      fail(transaction, 'unsupported-field', path .. '.' .. tostring(field),
        'unsupported field: ' .. path .. '.' .. tostring(field))
    end
  end
end

local function assertId(transaction, value, path)
  if type(value) ~= 'string' or value == '' then
    fail(transaction, 'invalid-value', path, 'expected non-empty id: ' .. path)
  end
end

local function append(transaction, field, value, fields)
  local entries = transaction.provider[field]
  local path = transaction.provider.id .. '.' .. field .. '[' .. tostring(#entries + 1) .. ']'
  assertFields(transaction, value, fields, path)
  assertId(transaction, value.id, path .. '.id')
  if transaction.ids[field][value.id] then
    fail(transaction, 'duplicate-id', path .. '.id', 'duplicate ' .. field .. ' id: ' .. value.id)
  end
  if Coordinator.hasProviderEntry(field, value.id) then
    fail(transaction, 'duplicate-id', path .. '.id', 'duplicate MoreBuilds ' .. field .. ' id: ' .. value.id)
  end
  transaction.ids[field][value.id] = true
  entries[#entries + 1] = TableUtil.copy(value)
  return transaction
end

local Transaction = {}
Transaction.__index = Transaction

function Transaction:group(group)
  return append(self, 'groups', group, { id = true, nameKey = true, sortKey = true })
end

function Transaction:category(category)
  return append(self, 'categories', category, { groupId = true, id = true, nameKey = true, sortKey = true })
end

function Transaction:definition(definition)
  return append(self, 'definitions', definition, DEFINITION_FIELDS)
end

function Transaction:placementKind(kind)
  return append(self, 'placementKinds', kind, {
    configureCursor = true,
    create = true,
    dataFields = true,
    footprint = true,
    id = true,
    isValid = true,
    isPreviewTileValid = true,
    manifest = true,
    onCreated = true,
    onDestroyed = true,
    prepare = true,
    salvage = true,
    validate = true,
  })
end

local function createTransaction(providerId, source)
  return setmetatable({
    ids = {
      categories = {},
      definitions = {},
      groups = {},
      placementKinds = {},
    },
    provider = {
      categories = {},
      definitions = {},
      groups = {},
      id = providerId,
      placementKinds = {},
      source = source,
    },
  }, Transaction)
end

local function buildProvider(providerId, callback, source)
  if type(providerId) ~= 'string' or providerId:match('^[a-z][a-z0-9_.-]*$') == nil then
    return nil, errorInfo('invalid-provider-id', 'provider.id', 'invalid MoreBuilds provider id: ' .. tostring(providerId))
  end
  if type(callback) ~= 'function' then
    return nil, errorInfo('invalid-value', providerId .. '.callback', 'provider callback must be a function: ' .. providerId)
  end

  local transaction = createTransaction(providerId, source)
  local ok, message = pcall(callback, transaction)
  if not ok then
    return nil, transaction.failure or errorInfo('callback-failed', providerId, 'provider callback failed: ' .. tostring(message))
  end
  return transaction.provider
end

local function validateProvider(provider)
  local ok, message = pcall(Coordinator.validateProvider, provider)
  if ok then
    return true
  end
  return nil, errorInfo('invalid-provider', provider.id, tostring(message))
end

function API.register(providerId, callback)
  local status = Coordinator.getStatus()
  if status.phase ~= 'registration' then
    return nil, errorInfo('registration-closed', 'registry.phase', 'MoreBuilds registration is closed: ' .. status.phase)
  end
  if Coordinator.hasProvider(providerId) then
    return nil, errorInfo('duplicate-id', 'provider.id', 'duplicate MoreBuilds provider: ' .. tostring(providerId))
  end

  local provider, providerError = buildProvider(providerId, callback, callerSource())
  if provider == nil then
    return nil, providerError
  end
  local valid, validationError = validateProvider(provider)
  if not valid then
    return nil, validationError
  end

  local ok, message = pcall(Coordinator.commitProvider, provider)
  if not ok then
    return nil, errorInfo('registration-failed', providerId, tostring(message))
  end
  return true
end

function API.disableDefinitions(definitionIds)
  if Coordinator.getStatus().phase ~= 'registration' then
    return nil, errorInfo('registration-closed', 'registry.phase', 'MoreBuilds registration is closed')
  end
  if type(definitionIds) ~= 'table' then
    return nil, errorInfo('invalid-value', 'definitionIds', 'definitionIds must be an array')
  end
  for index, definitionId in ipairs(definitionIds) do
    if type(definitionId) ~= 'string' or definitionId == '' then
      return nil, errorInfo('invalid-value', 'definitionIds[' .. tostring(index) .. ']', 'definition id must be a non-empty string')
    end
  end
  Coordinator.disableDefinitions(definitionIds)
  return true
end

function API.validate(providerSpec)
  if type(providerSpec) ~= 'table' then
    return nil, errorInfo('invalid-value', 'provider', 'provider spec must be a table')
  end
  for field in pairs(providerSpec) do
    if field ~= 'callback' and field ~= 'id' then
      return nil, errorInfo('unsupported-field', 'provider.' .. tostring(field),
        'unsupported provider spec field: ' .. tostring(field))
    end
  end
  local provider, providerError = buildProvider(providerSpec.id, providerSpec.callback, '<validation>')
  if provider == nil then
    return nil, providerError
  end
  return validateProvider(provider)
end

function API.getStatus()
  return Coordinator.getStatus()
end

function API.getGroup(groupId)
  return Coordinator.getGroup(groupId)
end

function API.getCategory(categoryId)
  return Coordinator.getCategory(categoryId)
end

function API.getDefinition(definitionId)
  return Coordinator.getDefinition(definitionId)
end

function API.listGroups()
  return Coordinator.listGroups()
end

function API.listCategories(filter)
  return Coordinator.listCategories(filter)
end

function API.listDefinitions(filter)
  return Coordinator.listDefinitions(filter)
end

function API.getCatalog()
  return Coordinator.getCatalog()
end

function API.getRegistryDigest()
  return Coordinator.getRegistryDigest()
end

local CoreProvider = require('MoreBuildings/providers/CoreProvider')
local registered, registrationError = API.register('morebuilds', CoreProvider)
assert(registered, registrationError and registrationError.message or 'failed to register MoreBuilds core provider')

return API
