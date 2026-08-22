local CatalogService = require('MoreBuildings/internal/CatalogService')
local CatalogRegistry = require('MoreBuildings/internal/CatalogRegistry')
local DefinitionRegistry = require('MoreBuildings/internal/DefinitionRegistry')
local DefinitionValidator = require('MoreBuildings/internal/DefinitionValidator')
local EntityScriptRegistry = require('MoreBuildings/internal/EntityScriptRegistry')
local PlacementKindRegistry = require('MoreBuildings/internal/PlacementKindRegistry')
local TableUtil = require('MoreBuildings/internal/TableUtil')

local RegistrationCoordinator = {
  API_VERSION = 1,
  REGISTRY_SCHEMA = 'transaction-v1',
  phase = 'registration',
  providers = {},
  catalog = nil,
  disabledDefinitionIds = {},
  digest = nil,
  entityScripts = {},
  failure = nil,
  manifest = nil,
  runtimeValidated = false,
}

local function assertProviderId(providerId)
  assert(type(providerId) == 'string' and providerId:match('^[a-z][a-z0-9_.-]*$') ~= nil, 'invalid MoreBuilds provider id: ' .. tostring(providerId))
end

local function compareById(first, second)
  return first.id < second.id
end

local function compareStrings(first, second)
  return first < second
end

local function compareCanonicalKeys(first, second)
  local firstType = type(first)
  local secondType = type(second)
  if firstType ~= secondType then
    return firstType < secondType
  end
  return first < second
end

local function failEarlier()
  error('MoreBuilds registry failed earlier:\n' .. tostring(RegistrationCoordinator.failure or '<unknown failure>'))
end

local function assertArray(entries, path)
  local count = #entries
  for index = 1, count do
    assert(entries[index] ~= nil, 'sparse array: ' .. path)
  end
  for key in pairs(entries) do
    assert(type(key) == 'number' and key >= 1 and key <= count and key == math.floor(key), 'expected array: ' .. path)
  end
end

local function assertUnique(entries, path)
  local ids = {}
  for index, entry in ipairs(entries) do
    assert(type(entry) == 'table', 'expected table: ' .. path .. '[' .. tostring(index) .. ']')
    assert(type(entry.id) == 'string' and entry.id ~= '', 'missing id: ' .. path .. '[' .. tostring(index) .. ']')
    assert(ids[entry.id] == nil, 'duplicate id: ' .. path .. '[' .. tostring(index) .. '].id=' .. entry.id)
    ids[entry.id] = entry
  end
  return ids
end

local function sortedEntries(entries)
  local sorted = {}
  for index = 1, #entries do
    sorted[index] = entries[index]
  end
  TableUtil.stableMergeSort(sorted, compareById)
  return sorted
end

local function sortedProviders()
  local providers = {}
  for _, provider in pairs(RegistrationCoordinator.providers) do
    providers[#providers + 1] = provider
  end
  TableUtil.stableMergeSort(providers, compareById)
  return providers
end

local function placementKindManifestValue(kind)
  local dataFields = {}
  for field in pairs(kind.dataFields) do
    dataFields[#dataFields + 1] = field
  end
  TableUtil.stableMergeSort(dataFields, compareStrings)
  return {
    dataFields = dataFields,
    id = kind.id,
    manifest = kind.manifest,
    salvage = kind.salvage or { groupRemoval = 'remaining-parts' },
  }
end

local function withProviderContext(provider, callback)
  local ok, result = pcall(callback)
  assert(ok, 'MoreBuilds provider ' .. provider.id .. ' (' .. provider.source .. '): ' .. tostring(result))
  return result
end

local function validateRuntimeDefinitions()
  local errors = {}
  for _, definition in ipairs(DefinitionRegistry.listInternal()) do
    local provider = RegistrationCoordinator.providers[definition.providerId]
    local ok, message = pcall(function()
      withProviderContext(provider, function()
        DefinitionValidator.validateRuntime(definition, PlacementKindRegistry)
      end)
    end)
    if not ok then
      errors[#errors + 1] = definition.id .. ': ' .. tostring(message)
    end
  end
  for _, entityScript in pairs(RegistrationCoordinator.entityScripts) do
    local ok, message = pcall(function()
      EntityScriptRegistry.get(entityScript.scriptName)
    end)
    if not ok then
      errors[#errors + 1] = entityScript.scriptName .. ': ' .. tostring(message)
    end
  end
  if #errors > 0 then
    error('MoreBuilds runtime validation failed for ' .. tostring(#errors) .. ' definition(s):\n' .. table.concat(errors, '\n'))
  end
end

local function canonicalValue(value, output)
  local stack = { { value = value } }
  local seen = {}
  while #stack > 0 do
    local frame = stack[#stack]
    stack[#stack] = nil
    if frame.leave then
      output[#output + 1] = '}'
      seen[frame.value] = nil
    else
      local valueType = type(frame.value)
      if valueType == 'nil' then
        output[#output + 1] = 'n'
      elseif valueType == 'boolean' then
        output[#output + 1] = frame.value and 't' or 'f'
      elseif valueType == 'number' then
        output[#output + 1] = 'd' .. string.format('%.17g', frame.value) .. ';'
      elseif valueType == 'string' then
        output[#output + 1] = 's' .. #frame.value .. ':' .. frame.value
      else
        assert(valueType == 'table', 'non-static registry value')
        assert(seen[frame.value] == nil, 'cyclic registry value')
        seen[frame.value] = true
        local keys = {}
        for key in pairs(frame.value) do
          keys[#keys + 1] = key
        end
        TableUtil.stableMergeSort(keys, compareCanonicalKeys)
        output[#output + 1] = '{'
        stack[#stack + 1] = { value = frame.value, leave = true }
        for index = #keys, 1, -1 do
          local key = keys[index]
          stack[#stack + 1] = { value = frame.value[key] }
          stack[#stack + 1] = { value = key }
        end
      end
    end
  end
end


local function hashOutput(output)
  local serialized = table.concat(output)
  local hash = 7
  for index = 1, #serialized do
    hash = (hash * 31 + string.byte(serialized, index)) % 2147483647
  end
  return string.format('%08x', hash)
end

local function calculateDigest()
  local output = {
    'api:', tostring(RegistrationCoordinator.API_VERSION), ';',
    'schema:', RegistrationCoordinator.REGISTRY_SCHEMA, ';',
  }
  for _, provider in ipairs(sortedProviders()) do
    output[#output + 1] = 'provider:' .. provider.id .. ';'
    local kinds = sortedEntries(provider.placementKinds)
    for _, kind in ipairs(kinds) do
      output[#output + 1] = 'kind:'
      canonicalValue(placementKindManifestValue(kind), output)
    end
    for _, entityScript in ipairs(sortedEntries(provider.entityScripts)) do
      output[#output + 1] = 'entity-script:'
      canonicalValue(entityScript, output)
    end
  end
  for _, group in ipairs(CatalogRegistry.listGroupsInternal()) do
    output[#output + 1] = 'group:'
    canonicalValue(group, output)
  end
  for _, category in ipairs(CatalogRegistry.listCategoriesInternal()) do
    output[#output + 1] = 'category:'
    canonicalValue(category, output)
  end
  for _, definition in ipairs(DefinitionRegistry.listInternal()) do
    if not RegistrationCoordinator.disabledDefinitionIds[definition.id] then
      output[#output + 1] = 'definition:'
      canonicalValue(definition, output)
    end
  end

  return 'morebuilds-v1-' .. hashOutput(output)
end

local function digestValue(prefix, value)
  local output = { prefix }
  canonicalValue(value, output)
  return hashOutput(output)
end

local function buildManifest()
  local manifest = {
    apiVersion = RegistrationCoordinator.API_VERSION,
    categories = {},
    definitions = {},
    entityScripts = {},
    groups = {},
    placementKinds = {},
    providers = {},
    schema = RegistrationCoordinator.REGISTRY_SCHEMA,
  }
  for _, provider in ipairs(sortedProviders()) do
    manifest.providers[#manifest.providers + 1] = provider.id
    for _, kind in ipairs(sortedEntries(provider.placementKinds)) do
      manifest.placementKinds[kind.id] = digestValue('placement-kind:', placementKindManifestValue(kind))
    end
    for _, entityScript in ipairs(sortedEntries(provider.entityScripts)) do
      manifest.entityScripts[entityScript.scriptName] = digestValue('entity-script:', entityScript)
    end
  end
  for _, group in ipairs(CatalogRegistry.listGroupsInternal()) do
    manifest.groups[group.id] = digestValue('group:', group)
  end
  for _, category in ipairs(CatalogRegistry.listCategoriesInternal()) do
    manifest.categories[category.id] = digestValue('category:', category)
  end
  for _, definition in ipairs(DefinitionRegistry.listInternal()) do
    if not RegistrationCoordinator.disabledDefinitionIds[definition.id] then
      manifest.definitions[definition.id] = digestValue('definition:', definition)
    end
  end
  return manifest
end

local function releaseProviderPayloads()
  for _, provider in pairs(RegistrationCoordinator.providers) do
    provider.groups = nil
    provider.categories = nil
    provider.definitions = nil
    provider.entityScripts = nil
    provider.placementKinds = nil
  end
end

local function completeSeal()
  CatalogRegistry.validateRuntime()
  for definitionId in pairs(RegistrationCoordinator.disabledDefinitionIds) do
    assert(DefinitionRegistry.getInternal(definitionId) ~= nil, 'unknown disabled MoreBuilds definition: ' .. definitionId)
  end
  local enabledDefinitions = {}
  for _, definition in ipairs(DefinitionRegistry.listInternal()) do
    if not RegistrationCoordinator.disabledDefinitionIds[definition.id] then
      enabledDefinitions[#enabledDefinitions + 1] = definition
    end
  end
  RegistrationCoordinator.catalog = CatalogService.build(
    CatalogRegistry.listGroupsInternal(),
    CatalogRegistry.listCategoriesInternal(),
    enabledDefinitions
  )
  RegistrationCoordinator.digest = calculateDigest()
  RegistrationCoordinator.manifest = buildManifest()
  for _, provider in ipairs(sortedProviders()) do
    for _, entityScript in ipairs(provider.entityScripts) do
      RegistrationCoordinator.entityScripts[entityScript.scriptName] = TableUtil.copy(entityScript)
    end
  end
  releaseProviderPayloads()
  RegistrationCoordinator.phase = 'sealed'
end

local function collectEntries(field)
  local entries = {}
  for _, provider in pairs(RegistrationCoordinator.providers) do
    for _, entry in ipairs(provider[field]) do
      entries[entry.id] = entry
    end
  end
  return entries
end

function RegistrationCoordinator.validateProvider(provider)
  assert(RegistrationCoordinator.phase == 'registration', 'MoreBuilds registration phase is closed')
  assert(type(provider) == 'table', 'MoreBuilds provider transaction is required')
  assertProviderId(provider.id)
  assert(RegistrationCoordinator.providers[provider.id] == nil, 'duplicate MoreBuilds provider: ' .. provider.id)
  assert(type(provider.source) == 'string' and provider.source ~= '', 'provider source is required: ' .. provider.id)

  for _, field in ipairs({ 'groups', 'categories', 'definitions', 'entityScripts', 'placementKinds' }) do
    assert(type(provider[field]) == 'table', 'provider ' .. field .. ' must be a table: ' .. provider.id)
    assertArray(provider[field], provider.id .. '.' .. field)
  end

  local groups = collectEntries('groups')
  local categories = collectEntries('categories')
  local kinds = collectEntries('placementKinds')
  local definitions = collectEntries('definitions')
  local entityScripts = collectEntries('entityScripts')

  for id, kind in pairs(kinds) do
    local fieldSet = {}
    for _, field in ipairs(kind.dataFields) do
      fieldSet[field] = true
    end
    kinds[id] = { dataFields = fieldSet, getRecipe = kind.getRecipe }
  end

  local providerGroups = assertUnique(provider.groups, provider.id .. '.groups')
  local providerCategories = assertUnique(provider.categories, provider.id .. '.categories')
  local providerKinds = assertUnique(provider.placementKinds, provider.id .. '.placementKinds')
  local providerDefinitions = assertUnique(provider.definitions, provider.id .. '.definitions')
  local providerEntityScripts = assertUnique(provider.entityScripts, provider.id .. '.entityScripts')

  for id, group in pairs(providerGroups) do
    assert(groups[id] == nil, 'duplicate MoreBuilds group: ' .. id)
    CatalogRegistry.validateGroup(group, provider.id)
    groups[id] = group
  end
  for id, kind in pairs(providerKinds) do
    assert(kinds[id] == nil, 'duplicate MoreBuilds placement kind: ' .. id)
    PlacementKindRegistry.validate(kind, provider.id)
    local fieldSet = {}
    for _, field in ipairs(kind.dataFields) do
      fieldSet[field] = true
    end
    kinds[id] = { dataFields = fieldSet, getRecipe = kind.getRecipe }
  end
  for id, entityScript in pairs(providerEntityScripts) do
    assert(entityScripts[id] == nil, 'duplicate MoreBuilds entity script: ' .. id)
    assert(type(entityScript.scriptName) == 'string' and entityScript.scriptName ~= '',
      'invalid entity script name: ' .. provider.id .. '.entityScripts.' .. id)
    entityScripts[id] = entityScript
  end
  for id, category in pairs(providerCategories) do
    assert(categories[id] == nil, 'duplicate MoreBuilds category: ' .. id)
    CatalogRegistry.validateCategory(category, provider.id)
    assert(groups[category.groupId] ~= nil, 'unknown MoreBuilds group: ' .. category.groupId)
    categories[id] = category
  end

  local categoryRegistry = { getCategoryInternal = function(categoryId)
    return categories[categoryId]
  end }
  local kindRegistry = { getInternal = function(kindId)
    return kinds[kindId]
  end }
  local sortKeys = {}
  for id, definition in pairs(providerDefinitions) do
    assert(definitions[id] == nil, 'duplicate MoreBuilds definition: ' .. id)
    DefinitionValidator.validateDefinition(definition, provider.id, kindRegistry, categoryRegistry)
    assert(sortKeys[definition.sortKey] == nil,
      'duplicate MoreBuilds definition sortKey: ' .. id .. '.sortKey=' .. definition.sortKey
        .. ' already used by ' .. tostring(sortKeys[definition.sortKey]))
    sortKeys[definition.sortKey] = id
  end
  return true
end

function RegistrationCoordinator.commitProvider(provider)
  RegistrationCoordinator.validateProvider(provider)
  RegistrationCoordinator.providers[provider.id] = provider
end

function RegistrationCoordinator.disableDefinitions(definitionIds)
  assert(RegistrationCoordinator.phase == 'registration', 'MoreBuilds registration phase is closed')
  for _, definitionId in ipairs(definitionIds) do
    RegistrationCoordinator.disabledDefinitionIds[definitionId] = true
  end
end

function RegistrationCoordinator.hasProvider(providerId)
  return RegistrationCoordinator.providers[providerId] ~= nil
end

function RegistrationCoordinator.hasProviderEntry(field, entryId)
  for _, provider in pairs(RegistrationCoordinator.providers) do
    for _, entry in ipairs(provider[field]) do
      if entry.id == entryId then
        return true
      end
    end
  end
  return false
end

function RegistrationCoordinator.isSealed()
  return RegistrationCoordinator.phase == 'sealed'
end

function RegistrationCoordinator.seal()
  if RegistrationCoordinator.phase == 'sealed' then
    return true
  end
  if RegistrationCoordinator.phase == 'failed' then
    failEarlier()
  end
  assert(RegistrationCoordinator.phase == 'registration',
    'MoreBuilds registry sealing was reentered while registration is being sealed')
  RegistrationCoordinator.phase = 'sealing'

  local ok, message = pcall(function()
    local providers = sortedProviders()

    for _, provider in ipairs(providers) do
      for _, kind in ipairs(sortedEntries(provider.placementKinds)) do
        withProviderContext(provider, function()
          PlacementKindRegistry.add(kind, provider.id)
        end)
      end
    end

    for _, provider in ipairs(providers) do
      for _, group in ipairs(sortedEntries(provider.groups)) do
        withProviderContext(provider, function()
          CatalogRegistry.addGroup(group, provider.id)
        end)
      end
    end

    for _, provider in ipairs(providers) do
      for _, category in ipairs(sortedEntries(provider.categories)) do
        withProviderContext(provider, function()
          CatalogRegistry.addCategory(category, provider.id)
        end)
      end
    end

    for _, provider in ipairs(providers) do
      for _, definition in ipairs(provider.definitions) do
        withProviderContext(provider, function()
          DefinitionValidator.validateDefinition(definition, provider.id, PlacementKindRegistry, CatalogRegistry)
          DefinitionRegistry.add(definition, provider.id)
        end)
      end
    end

    PlacementKindRegistry.seal()
    CatalogRegistry.seal()
    DefinitionRegistry.seal()
    completeSeal()
  end)
  if not ok then
    RegistrationCoordinator.phase = 'failed'
    RegistrationCoordinator.failure = 'MoreBuilds registry sealing failed:\n' .. tostring(message)
    error(RegistrationCoordinator.failure)
  end
  return true
end

local function assertSealed()
  if RegistrationCoordinator.phase == 'failed' then
    failEarlier()
  end
  if RegistrationCoordinator.phase == 'sealing' then
    error('MoreBuilds registry is currently sealing')
  end
  assert(RegistrationCoordinator.phase == 'sealed', 'MoreBuilds registry is not sealed')
end

function RegistrationCoordinator.validateRuntime()
  assertSealed()
  if RegistrationCoordinator.runtimeValidated then
    return true
  end
  local ok, message = pcall(validateRuntimeDefinitions)
  if not ok then
    RegistrationCoordinator.phase = 'failed'
    RegistrationCoordinator.failure = 'MoreBuilds runtime validation failed:\n' .. tostring(message)
    error(RegistrationCoordinator.failure)
  end
  RegistrationCoordinator.runtimeValidated = true
  return true
end

function RegistrationCoordinator.getDefinition(definitionId)
  assertSealed()
  if RegistrationCoordinator.disabledDefinitionIds[definitionId] then
    return nil
  end
  return DefinitionRegistry.get(definitionId)
end

function RegistrationCoordinator.getGroup(groupId)
  assertSealed()
  local group = CatalogRegistry.getGroupInternal(groupId)
  return group and TableUtil.copy(group) or nil
end

function RegistrationCoordinator.getCategory(categoryId)
  assertSealed()
  local category = CatalogRegistry.getCategoryInternal(categoryId)
  return category and TableUtil.copy(category) or nil
end

function RegistrationCoordinator.listGroups()
  assertSealed()
  return TableUtil.copy(CatalogRegistry.listGroupsInternal())
end

function RegistrationCoordinator.listCategories(filter)
  assertSealed()
  local categories = {}
  for _, category in ipairs(CatalogRegistry.listCategoriesInternal()) do
    if filter == nil
      or (filter.groupId == nil or filter.groupId == category.groupId)
      and (filter.providerId == nil or filter.providerId == category.providerId) then
      categories[#categories + 1] = TableUtil.copy(category)
    end
  end
  return categories
end

function RegistrationCoordinator.getStatus()
  return {
    apiVersion = RegistrationCoordinator.API_VERSION,
    digest = RegistrationCoordinator.digest,
    phase = RegistrationCoordinator.phase,
    sealed = RegistrationCoordinator.phase == 'sealed',
  }
end

function RegistrationCoordinator.getInternalDefinition(definitionId)
  assertSealed()
  return DefinitionRegistry.getInternal(definitionId)
end

function RegistrationCoordinator.isDefinitionEnabled(definitionId)
  assertSealed()
  return DefinitionRegistry.getInternal(definitionId) ~= nil
    and not RegistrationCoordinator.disabledDefinitionIds[definitionId]
end

function RegistrationCoordinator.getInternalPlacementKind(kindId)
  assertSealed()
  return PlacementKindRegistry.getInternal(kindId)
end

function RegistrationCoordinator.listDefinitions(filter)
  assertSealed()
  return DefinitionRegistry.list(filter, CatalogRegistry, RegistrationCoordinator.disabledDefinitionIds)
end

function RegistrationCoordinator.getCatalog()
  assertSealed()
  return TableUtil.copy(RegistrationCoordinator.catalog)
end

function RegistrationCoordinator.getInternalCatalog()
  assertSealed()
  return RegistrationCoordinator.catalog
end

function RegistrationCoordinator.getRegistryDigest()
  assertSealed()
  return RegistrationCoordinator.digest
end

function RegistrationCoordinator.getInternalManifest()
  assertSealed()
  return RegistrationCoordinator.manifest
end

function RegistrationCoordinator.listEntityScripts()
  assertSealed()
  local entries = {}
  for _, entityScript in pairs(RegistrationCoordinator.entityScripts) do
    entries[#entries + 1] = TableUtil.copy(entityScript)
  end
  TableUtil.stableMergeSort(entries, compareById)
  return entries
end

return RegistrationCoordinator
