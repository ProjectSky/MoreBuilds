local TableUtil = require('MoreBuildings/internal/TableUtil')

local CatalogService = {}

function CatalogService.build(groups, categories, definitions)
  local groupsById = {}
  local categoriesById = {}
  local catalogGroups = {}
  local entries = {}

  for _, group in ipairs(groups) do
    local catalogGroup = TableUtil.copy(group)
    catalogGroup.categories = {}
    groupsById[group.id] = catalogGroup
    catalogGroups[#catalogGroups + 1] = catalogGroup
  end

  for _, category in ipairs(categories) do
    local catalogCategory = TableUtil.copy(category)
    catalogCategory.definitionIds = {}
    categoriesById[category.id] = catalogCategory
    local group = assert(groupsById[category.groupId], 'unknown catalog group: ' .. category.groupId)
    group.categories[#group.categories + 1] = catalogCategory
  end

  for _, definition in ipairs(definitions) do
    local category = assert(categoriesById[definition.categoryId], 'unknown catalog category: ' .. definition.categoryId)
    category.definitionIds[#category.definitionIds + 1] = definition.id
    entries[#entries + 1] = definition
  end

  local visibleGroups = {}
  for _, group in ipairs(catalogGroups) do
    local visibleCategories = {}
    for _, category in ipairs(group.categories) do
      if #category.definitionIds > 0 then
        visibleCategories[#visibleCategories + 1] = category
      end
    end
    if #visibleCategories > 0 then
      group.categories = visibleCategories
      visibleGroups[#visibleGroups + 1] = group
    end
  end

  return {
    definitions = entries,
    groups = visibleGroups,
  }
end

return CatalogService
