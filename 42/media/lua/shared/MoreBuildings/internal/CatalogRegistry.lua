local TableUtil = require('MoreBuildings/internal/TableUtil')

local CatalogRegistry = {
  groupsById = {},
  groupSortKeysByProvider = {},
  categoriesById = {},
  categorySortKeysByProvider = {},
  groups = {},
  categories = {},
  sealed = false,
}

local function assertFields(value, fields, path)
  assert(type(value) == 'table', 'expected table: ' .. path)
  for field in pairs(value) do
    assert(fields[field] == true, 'unsupported field: ' .. path .. '.' .. tostring(field))
  end
end

local function assertId(value, path)
  assert(type(value) == 'string' and value:match('^[%w_.:-]+$') ~= nil, 'invalid id: ' .. path)
end

local function assertSortKey(value, path)
  assert(type(value) == 'number' and value == math.floor(value), 'expected integer sortKey: ' .. path)
end

local function compareEntries(first, second)
  if first.sortKey ~= second.sortKey then
    return first.sortKey < second.sortKey
  end
  return first.id < second.id
end

function CatalogRegistry.validateGroup(group, providerId)
  assertFields(group, { id = true, nameKey = true, sortKey = true }, providerId .. '.group')
  assertId(group.id, providerId .. '.group.id')
  assert(type(group.nameKey) == 'string' and group.nameKey ~= '', 'missing group nameKey: ' .. group.id)
  assertSortKey(group.sortKey, group.id .. '.sortKey')
end

function CatalogRegistry.validateCategory(category, providerId)
  assertFields(category, { groupId = true, id = true, nameKey = true, sortKey = true }, providerId .. '.category')
  assertId(category.id, providerId .. '.category.id')
  assertId(category.groupId, category.id .. '.groupId')
  assert(type(category.nameKey) == 'string' and category.nameKey ~= '', 'missing category nameKey: ' .. category.id)
  assertSortKey(category.sortKey, category.id .. '.sortKey')
end

function CatalogRegistry.addGroup(group, providerId)
  assert(not CatalogRegistry.sealed, 'MoreBuilds catalog registry is sealed')
  CatalogRegistry.validateGroup(group, providerId)
  assert(CatalogRegistry.groupsById[group.id] == nil, 'duplicate MoreBuilds group: ' .. group.id)
  local sortKeys = CatalogRegistry.groupSortKeysByProvider[providerId]
  if sortKeys == nil then
    sortKeys = {}
    CatalogRegistry.groupSortKeysByProvider[providerId] = sortKeys
  end
  assert(sortKeys[group.sortKey] == nil,
    'duplicate MoreBuilds group sortKey: ' .. group.id .. '.sortKey=' .. group.sortKey
      .. ' already used by ' .. tostring(sortKeys[group.sortKey]))

  local stored = TableUtil.copy(group)
  stored.providerId = providerId
  CatalogRegistry.groupsById[stored.id] = stored
  sortKeys[stored.sortKey] = stored.id
  CatalogRegistry.groups[#CatalogRegistry.groups + 1] = stored
end

function CatalogRegistry.addCategory(category, providerId)
  assert(not CatalogRegistry.sealed, 'MoreBuilds catalog registry is sealed')
  CatalogRegistry.validateCategory(category, providerId)
  assert(CatalogRegistry.categoriesById[category.id] == nil, 'duplicate MoreBuilds category: ' .. category.id)
  assert(CatalogRegistry.groupsById[category.groupId] ~= nil, 'unknown MoreBuilds group: ' .. category.groupId)
  local providerSortKeys = CatalogRegistry.categorySortKeysByProvider[providerId]
  if providerSortKeys == nil then
    providerSortKeys = {}
    CatalogRegistry.categorySortKeysByProvider[providerId] = providerSortKeys
  end
  local sortKeys = providerSortKeys[category.groupId]
  if sortKeys == nil then
    sortKeys = {}
    providerSortKeys[category.groupId] = sortKeys
  end
  assert(sortKeys[category.sortKey] == nil,
    'duplicate MoreBuilds category sortKey: ' .. category.id .. '.sortKey=' .. category.sortKey
      .. ' already used by ' .. tostring(sortKeys[category.sortKey]))

  local stored = TableUtil.copy(category)
  stored.providerId = providerId
  CatalogRegistry.categoriesById[stored.id] = stored
  sortKeys[stored.sortKey] = stored.id
  CatalogRegistry.categories[#CatalogRegistry.categories + 1] = stored
end

function CatalogRegistry.seal()
  assert(not CatalogRegistry.sealed, 'MoreBuilds catalog registry is already sealed')
  TableUtil.stableMergeSort(CatalogRegistry.groups, compareEntries)
  TableUtil.stableMergeSort(CatalogRegistry.categories, function(first, second)
    if first.groupId ~= second.groupId then
      local firstGroup = CatalogRegistry.groupsById[first.groupId]
      local secondGroup = CatalogRegistry.groupsById[second.groupId]
      if firstGroup.sortKey ~= secondGroup.sortKey then
        return firstGroup.sortKey < secondGroup.sortKey
      end
      return first.groupId < second.groupId
    end
    return compareEntries(first, second)
  end)
  CatalogRegistry.groupSortKeysByProvider = nil
  CatalogRegistry.categorySortKeysByProvider = nil
  CatalogRegistry.sealed = true
end

function CatalogRegistry.getCategoryInternal(categoryId)
  return CatalogRegistry.categoriesById[categoryId]
end

function CatalogRegistry.getGroupInternal(groupId)
  return CatalogRegistry.groupsById[groupId]
end

function CatalogRegistry.listGroupsInternal()
  return CatalogRegistry.groups
end

function CatalogRegistry.listCategoriesInternal()
  return CatalogRegistry.categories
end

function CatalogRegistry.validateRuntime()
  if isServer() then
    return
  end
  for _, group in ipairs(CatalogRegistry.groups) do
    assert(getText(group.nameKey) ~= group.nameKey, 'missing group text: ' .. group.id .. '.nameKey=' .. group.nameKey)
  end
  for _, category in ipairs(CatalogRegistry.categories) do
    assert(getText(category.nameKey) ~= category.nameKey, 'missing category text: ' .. category.id .. '.nameKey=' .. category.nameKey)
  end
end

return CatalogRegistry
