local TableUtil = require('MoreBuildings/internal/TableUtil')

local PlacementKindRegistry = {
  byId = {},
  order = {},
  sealed = false,
}

local REQUIRED_HANDLERS = {
  'validate',
  'footprint',
  'configureCursor',
  'isValid',
  'prepare',
  'create',
}

local OPTIONAL_HANDLERS = {
  isPreviewTileValid = true,
  onCreated = true,
  onDestroyed = true,
}

local SALVAGE_FIELDS = {
  groupRemoval = true,
}

local KIND_FIELDS = {
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
}

local function copyKind(kind)
  local stored = {
    dataFields = {},
    id = kind.id,
    manifest = TableUtil.copy(kind.manifest),
    salvage = {
      groupRemoval = kind.salvage and kind.salvage.groupRemoval or 'remaining-parts',
    },
  }
  for _, field in ipairs(kind.dataFields) do
    stored.dataFields[field] = true
  end
  for _, handlerName in ipairs(REQUIRED_HANDLERS) do
    stored[handlerName] = kind[handlerName]
  end
  for handlerName in pairs(OPTIONAL_HANDLERS) do
    stored[handlerName] = kind[handlerName]
  end
  return stored
end

local function assertStatic(value, path)
  local stack = { value }
  local seen = {}
  while #stack > 0 do
    local current = stack[#stack]
    stack[#stack] = nil
    local valueType = type(current)
    assert(valueType == 'boolean' or valueType == 'number' or valueType == 'string' or valueType == 'table',
      'non-static placement kind manifest value: ' .. path)
    if valueType == 'table' then
      assert(seen[current] == nil, 'cyclic placement kind manifest: ' .. path)
      seen[current] = true
      for key, nestedValue in pairs(current) do
        local keyType = type(key)
        assert(keyType == 'string' or keyType == 'number', 'invalid placement kind manifest key: ' .. path)
        stack[#stack + 1] = nestedValue
      end
    end
  end
end

function PlacementKindRegistry.validate(kind, providerId)
  assert(type(kind) == 'table', 'placement kind must be a table: ' .. providerId)
  assert(type(kind.id) == 'string' and kind.id ~= '', 'placement kind id is required: ' .. providerId)
  assert(kind.id:sub(1, #providerId + 1) == providerId .. ':', 'placement kind id must belong to provider: ' .. kind.id)
  assert(PlacementKindRegistry.byId[kind.id] == nil, 'duplicate MoreBuilds placement kind: ' .. kind.id)
  for field in pairs(kind) do
    assert(KIND_FIELDS[field] == true, 'unsupported placement kind field: ' .. kind.id .. '.' .. tostring(field))
  end
  for _, handlerName in ipairs(REQUIRED_HANDLERS) do
    assert(type(kind[handlerName]) == 'function', 'placement kind handler is required: ' .. kind.id .. '.' .. handlerName)
  end
  assert(type(kind.dataFields) == 'table', 'placement kind dataFields are required: ' .. kind.id)
  assert(type(kind.manifest) == 'table', 'placement kind manifest is required: ' .. kind.id)
  assertStatic(kind.manifest, kind.id .. '.manifest')
  local dataFieldCount = #kind.dataFields
  local dataFields = {}
  for index, field in ipairs(kind.dataFields) do
    assert(type(field) == 'string' and field ~= '', 'invalid placement kind data field: ' .. kind.id .. '[' .. tostring(index) .. ']')
    assert(dataFields[field] == nil, 'duplicate placement kind data field: ' .. kind.id .. '.' .. field)
    dataFields[field] = true
  end
  for key in pairs(kind.dataFields) do
    assert(type(key) == 'number' and key >= 1 and key <= dataFieldCount and key == math.floor(key), 'placement kind dataFields must be an array: ' .. kind.id)
  end
  for handlerName in pairs(OPTIONAL_HANDLERS) do
    assert(kind[handlerName] == nil or type(kind[handlerName]) == 'function', 'invalid placement kind handler: ' .. kind.id .. '.' .. handlerName)
  end
  if kind.salvage then
    assert(type(kind.salvage) == 'table', 'placement kind salvage must be a table: ' .. kind.id)
    for field in pairs(kind.salvage) do
      assert(SALVAGE_FIELDS[field] == true, 'unsupported placement kind salvage field: ' .. kind.id .. '.' .. tostring(field))
    end
    assert(
      kind.salvage.groupRemoval == 'remaining-parts' or kind.salvage.groupRemoval == 'preserve',
      'invalid placement kind salvage groupRemoval: ' .. kind.id
    )
  end
end

function PlacementKindRegistry.add(kind, providerId)
  assert(not PlacementKindRegistry.sealed, 'MoreBuilds placement kind registry is sealed')
  PlacementKindRegistry.validate(kind, providerId)
  local stored = copyKind(kind)
  PlacementKindRegistry.byId[stored.id] = stored
  PlacementKindRegistry.order[#PlacementKindRegistry.order + 1] = stored
end

function PlacementKindRegistry.seal()
  assert(not PlacementKindRegistry.sealed, 'MoreBuilds placement kind registry is already sealed')
  TableUtil.stableMergeSort(PlacementKindRegistry.order, function(first, second)
    return first.id < second.id
  end)
  PlacementKindRegistry.sealed = true
end

function PlacementKindRegistry.getInternal(kindId)
  return PlacementKindRegistry.byId[kindId]
end

return PlacementKindRegistry
