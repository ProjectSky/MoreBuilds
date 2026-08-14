local TableUtil = require('MoreBuildings/internal/TableUtil')

local DefinitionRegistry = {
  byId = {},
  sortKeysByProvider = {},
  order = {},
  sealed = false,
}

local function compareDefinitions(first, second)
  if first.sortKey ~= second.sortKey then
    return first.sortKey < second.sortKey
  end
  return first.id < second.id
end

function DefinitionRegistry.add(definition, providerId)
  assert(not DefinitionRegistry.sealed, 'MoreBuilds definition registry is sealed')
  assert(DefinitionRegistry.byId[definition.id] == nil, 'duplicate MoreBuilds definition: ' .. definition.id)
  local sortKeys = DefinitionRegistry.sortKeysByProvider[providerId]
  if sortKeys == nil then
    sortKeys = {}
    DefinitionRegistry.sortKeysByProvider[providerId] = sortKeys
  end
  local existingSortKey = sortKeys[definition.sortKey]
  assert(existingSortKey == nil,
    'duplicate MoreBuilds definition sortKey: ' .. definition.id .. '.sortKey=' .. definition.sortKey
      .. ' already used by ' .. tostring(existingSortKey))

  local stored = TableUtil.copy(definition)
  stored.providerId = providerId
  DefinitionRegistry.byId[stored.id] = stored
  sortKeys[stored.sortKey] = stored.id
  DefinitionRegistry.order[#DefinitionRegistry.order + 1] = stored
end

function DefinitionRegistry.seal()
  assert(not DefinitionRegistry.sealed, 'MoreBuilds definition registry is already sealed')
  TableUtil.stableMergeSort(DefinitionRegistry.order, compareDefinitions)
  DefinitionRegistry.sortKeysByProvider = nil
  DefinitionRegistry.sealed = true
end

function DefinitionRegistry.getInternal(definitionId)
  return DefinitionRegistry.byId[definitionId]
end

function DefinitionRegistry.listInternal()
  return DefinitionRegistry.order
end

function DefinitionRegistry.get(definitionId)
  local definition = DefinitionRegistry.byId[definitionId]
  return definition and TableUtil.copy(definition) or nil
end

function DefinitionRegistry.list(filter, catalogRegistry, disabledDefinitionIds)
  local definitions = {}
  for _, definition in ipairs(DefinitionRegistry.order) do
    local category = catalogRegistry.getCategoryInternal(definition.categoryId)
    if not disabledDefinitionIds[definition.id]
      and (filter == nil or filter.providerId == nil or filter.providerId == definition.providerId)
      and (filter == nil or filter.groupId == nil or filter.groupId == category.groupId)
      and (filter == nil or filter.categoryId == nil or filter.categoryId == definition.categoryId) then
      definitions[#definitions + 1] = TableUtil.copy(definition)
    end
  end
  return definitions
end

return DefinitionRegistry
