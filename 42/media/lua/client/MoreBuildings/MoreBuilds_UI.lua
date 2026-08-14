local Bootstrap = require('MoreBuildings/Bootstrap')
local ConstructionClient = require('MoreBuildings/ConstructionClient')
local PopularBuildings = require('MoreBuildings/PopularBuildingsClient')
local RegistryClient = require('MoreBuildings/RegistryClient')
local MoreBuilds = require('MoreBuildings/API')
local ConstructionService = require('MoreBuildings/internal/ConstructionService')
local TableUtil = require('MoreBuildings/internal/TableUtil')

require 'ISUI/ISCollapsableWindow'
require 'ISUI/ISScrollingListBox'
require 'ISUI/ISTextEntryBox'
require 'ISUI/ISLabel'
require 'ISUI/ISPanel'
require 'ISUI/ISXuiSkin'
require 'Entity/ISUI/Controls/ISWidgetTitleHeader'
require 'Entity/ISUI/CraftRecipe/ISWidgetInput'

local ROOT_CATEGORY = '__morebuilds_all__'
local FAVOURITES_CATEGORY = '__morebuilds_favourites__'
local POPULAR_CATEGORY = '__morebuilds_popular__'
local CATEGORY_SEPARATOR = '\30'
local FONT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)
local SEARCH_DELAY_MS = 150
local REQUIREMENT_COLUMNS = 4
local REQUIREMENT_GAP = 6
local REQUIREMENT_STATUS_ICON_SIZE = 14
local CONTENT_MARGIN = 10
local CONTENT_GAP = 10
local PANEL_HEADER_HEIGHT = 28
local CATALOG_TOOLBAR_HEIGHT = 36
local SIDEBAR_MIN_WIDTH = 180
local SIDEBAR_MAX_WIDTH = 230
local DETAILS_MIN_WIDTH = 310
local DETAILS_MAX_WIDTH = 440
local CATALOG_MIN_WIDTH = 340
local LIST_PREVIEW_WIDTH = 64
local LIST_PREVIEW_HEIGHT = 64
local DETAIL_PREVIEW_WIDTH = 144
local DETAIL_PREVIEW_HEIGHT = 80
local FAVOURITES_MOD_DATA_KEY = 'MoreBuildsFavorites'
local ICON_SCALE = math.max(1, math.floor(getTextManager():getFontHeight(UIFont.Small) / 19 + 0.5))
local LIST_FAVOURITE_ICON_SIZE = 14 * ICON_SCALE
local FAVOURITE_YES_TEXTURE = getTexture('media/ui/inventoryPanes/FavouriteYes.png')
local FAVOURITE_NO_TEXTURE = getTexture('media/ui/inventoryPanes/FavouriteNo.png')
local catalogCache

local function comparePreviewParts(left, right)
  return left.x + left.y < right.x + right.y
end

local function categoryKey(groupId, subcategoryId)
  if subcategoryId == nil then
    return groupId
  end
  return groupId .. CATEGORY_SEPARATOR .. subcategoryId
end

local function categoryGroupId(key)
  if key == ROOT_CATEGORY or key == FAVOURITES_CATEGORY or key == POPULAR_CATEGORY then
    return key
  end
  local separatorIndex = string.find(key, CATEGORY_SEPARATOR, 1, true)
  if separatorIndex then
    return string.sub(key, 1, separatorIndex - 1)
  end
  return key
end

local function layoutListScrollBar(list)
  list.vscroll:setX(list:getWidth() - list.vscroll:getWidth())
  list.vscroll:setY(0)
  list.vscroll:setHeight(list:getHeight())
end

local function clearList(list)
  list:clear()
  list:setScrollHeight(0)
  list:setYScroll(0)
  list.smoothScrollTargetY = nil
  list.smoothScrollY = nil
  list.listHeight = nil
end

local function previewTextures(definition)
  local textures = {}
  for _, part in ipairs(ConstructionClient.getPreviewParts(definition)) do
    local texture = getTexture(part.sprite)
    if texture then
      textures[#textures + 1] = {
        texture = texture,
        x = part.x,
        y = part.y,
      }
    end
  end
  TableUtil.stableMergeSort(textures, comparePreviewParts)
  return textures
end

local function previewLayout(textures, maximumWidth, maximumHeight)
  if #textures == 0 then
    return 0, 0, 0, 0, 0, 0
  end
  local cellWidth = textures[1].texture:getWidthOrig()
  local minX = math.huge
  local minY = math.huge
  local maxX = -math.huge
  local maxY = -math.huge
  for _, part in ipairs(textures) do
    local texture = part.texture
    local originX = (part.x - part.y) * cellWidth / 2
    local originY = (part.x + part.y) * cellWidth / 4
    local textureX = originX + texture:getOffsetX()
    local textureY = originY + texture:getOffsetY()
    minX = math.min(minX, textureX)
    minY = math.min(minY, textureY)
    maxX = math.max(maxX, textureX + texture:getWidth())
    maxY = math.max(maxY, textureY + texture:getHeight())
  end
  local scale = math.min(1, maximumWidth / (maxX - minX), maximumHeight / (maxY - minY))
  local width = math.floor((maxX - minX) * scale + 0.5)
  local height = math.floor((maxY - minY) * scale + 0.5)
  return width, height, scale, minX, minY, cellWidth
end

local function drawPreview(target, textures, x, y, maximumWidth, maximumHeight, alpha, layout)
  if #textures == 0 then
    return
  end
  local width, height, scale, minX, minY, cellWidth
  if layout then
    width = layout[1]
    height = layout[2]
    scale = layout[3]
    minX = layout[4]
    minY = layout[5]
    cellWidth = layout[6]
  else
    width, height, scale, minX, minY, cellWidth = previewLayout(textures, maximumWidth, maximumHeight)
  end
  local previewX = x + (maximumWidth - width) / 2
  local previewY = y + (maximumHeight - height) / 2
  for _, part in ipairs(textures) do
    local texture = part.texture
    local originX = (part.x - part.y) * cellWidth / 2
    local originY = (part.x + part.y) * cellWidth / 4
    local textureX = previewX + (originX + texture:getOffsetX() - minX) * scale
    local textureY = previewY + (originY + texture:getOffsetY() - minY) * scale
    local textureWidth = texture:getWidth() * scale
    local textureHeight = texture:getHeight() * scale
    target:drawPolygon(
      texture,
      textureX, textureY,
      textureX + textureWidth, textureY,
      textureX + textureWidth, textureY + textureHeight,
      textureX, textureY + textureHeight,
      1, 1, 1, alpha
    )
  end
end

local function createEntry(definition, category, group)
  local groupId = category.groupId
  local subcategoryId = category.id
  local path = {
    getText(group.nameKey),
    getText(category.nameKey),
  }
  local categoryKeys = {}
  categoryKeys[categoryKey(groupId)] = true
  categoryKeys[categoryKey(groupId, subcategoryId)] = true
  return {
    definitionId = definition.id,
    definition = definition,
    groupId = groupId,
    path = path,
    pathText = table.concat(path, ' / '),
    categoryKeys = categoryKeys,
    searchBase = string.lower(definition.id .. ' ' .. table.concat(path, ' ')),
  }
end

local function ensureEntryName(entry)
  if entry.name == nil then
    entry.name = getText(entry.definition.nameKey)
    entry.search = string.lower(entry.name .. ' ' .. entry.searchBase)
  end
end

local function ensureEntryPreview(entry)
  if entry.previewTextures then
    return
  end
  local textures = previewTextures(entry.definition)
  entry.texture = getTexture(entry.definition.previewSprite)
  entry.previewTextures = textures
  entry.listPreviewLayout = { previewLayout(textures, LIST_PREVIEW_WIDTH, LIST_PREVIEW_HEIGHT) }
  entry.detailPreviewLayout = { previewLayout(textures, DETAIL_PREVIEW_WIDTH - 6, DETAIL_PREVIEW_HEIGHT - 6) }
end

local function ensureEntryDescription(entry)
  if entry.tooltip == nil then
    entry.tooltip = getText(entry.definition.descriptionKey)
    entry.descriptionSearch = string.lower(entry.tooltip)
  end
end

local function matchesSearch(entry, query)
  if query == '' then
    return true
  end
  ensureEntryName(entry)
  if string.find(entry.search, query, 1, true) then
    return true
  end
  ensureEntryDescription(entry)
  return string.find(entry.descriptionSearch, query, 1, true) ~= nil
end

local function cacheListText(entry, width)
  ensureEntryName(entry)
  width = math.max(1, math.floor(width))
  if entry.listTextWidth == width then
    return
  end
  entry.listTextWidth = width
  entry.listName = getTextManager():WrapText(UIFont.Medium, entry.name, width, 1, '...')
  entry.listPath = getTextManager():WrapText(UIFont.Small, entry.pathText, width, 1, '...')
end

local function getCatalogCache()
  if catalogCache then
    return catalogCache
  end

  Bootstrap.ensureSealed()

  local entries = {}
  local entriesByDefinitionId = {}
  local categories = {
    {
      key = ROOT_CATEGORY,
      groupId = ROOT_CATEGORY,
      name = getText('UI_MoreBuild_AllCategories'),
      isPrimary = true,
      count = 0,
    },
    {
      key = FAVOURITES_CATEGORY,
      groupId = FAVOURITES_CATEGORY,
      name = getText('UI_MoreBuild_Favourites'),
      isPrimary = true,
      count = 0,
    },
  }
  if PopularBuildings.isAvailable() then
    categories[#categories + 1] = {
      key = POPULAR_CATEGORY,
      groupId = POPULAR_CATEGORY,
      name = getText('UI_MoreBuild_Popular'),
      isPrimary = true,
      count = 0,
    }
  end
  local catalog = MoreBuilds.getCatalog()
  local firstGroupCategoryIndex = #categories + 1
  local categoriesByKey = {}
  local catalogCategoriesById = {}
  local catalogGroupsById = {}
  local groupsById = {}
  local subcategoriesByGroup = {}
  for _, group in ipairs(catalog.groups) do
    catalogGroupsById[group.id] = group
    local category = {
      key = categoryKey(group.id),
      groupId = group.id,
      name = getText(group.nameKey),
      isPrimary = true,
      count = 0,
    }
    groupsById[group.id] = true
    categoriesByKey[category.key] = category
    categories[#categories + 1] = category

    local subcategories = {
      {
        key = category.key,
        groupId = group.id,
        name = getText('UI_MoreBuild_AllInGroup'),
        count = 0,
      },
    }
    for _, subcategory in ipairs(group.categories) do
      catalogCategoriesById[subcategory.id] = subcategory
      local subcategoryItem = {
        key = categoryKey(group.id, subcategory.id),
        groupId = group.id,
        name = getText(subcategory.nameKey),
        count = 0,
      }
      categoriesByKey[subcategoryItem.key] = subcategoryItem
      subcategories[#subcategories + 1] = subcategoryItem
    end
    subcategoriesByGroup[group.id] = subcategories
  end
  for _, definition in ipairs(catalog.definitions) do
    local category = assert(catalogCategoriesById[definition.categoryId], 'unknown catalog category: ' .. definition.categoryId)
    local entry = createEntry(definition, category, catalogGroupsById[category.groupId])
    entries[#entries + 1] = entry
    entriesByDefinitionId[entry.definitionId] = entry
    local groupId = entry.groupId
    for key in pairs(entry.categoryKeys) do
      local category = categoriesByKey[key]
      if category then
        category.count = category.count + 1
        groupId = category.groupId
      end
    end
    subcategoriesByGroup[groupId][1].count = subcategoriesByGroup[groupId][1].count + 1
  end
  local entriesByCategoryKey = { [ROOT_CATEGORY] = entries }
  for _, entry in ipairs(entries) do
    for key in pairs(entry.categoryKeys) do
      local categoryEntries = entriesByCategoryKey[key]
      if categoryEntries == nil then
        categoryEntries = {}
        entriesByCategoryKey[key] = categoryEntries
      end
      categoryEntries[#categoryEntries + 1] = entry
    end
  end
  categories[1].count = #entries

  local visibleCategories = {}
  for index = 1, firstGroupCategoryIndex - 1 do
    visibleCategories[#visibleCategories + 1] = categories[index]
  end
  for index = firstGroupCategoryIndex, #categories do
    local category = categories[index]
    if category.count > 0 then
      visibleCategories[#visibleCategories + 1] = category
      local visibleSubcategories = { subcategoriesByGroup[category.groupId][1] }
      for subcategoryIndex = 2, #subcategoriesByGroup[category.groupId] do
        local subcategory = subcategoriesByGroup[category.groupId][subcategoryIndex]
        if subcategory.count > 0 then
          visibleSubcategories[#visibleSubcategories + 1] = subcategory
        end
      end
      subcategoriesByGroup[category.groupId] = visibleSubcategories
    end
  end
  catalogCache = {
    entries = entries,
    entriesByCategoryKey = entriesByCategoryKey,
    entriesByDefinitionId = entriesByDefinitionId,
    categories = visibleCategories,
    groupsById = groupsById,
    subcategoriesByGroup = subcategoriesByGroup,
  }
  return catalogCache
end

ISMoreBuildVirtualList = ISScrollingListBox:derive('ISMoreBuildVirtualList')

function ISMoreBuildVirtualList:rowAt(x, y)
  local index = math.floor(y / self.itemheight) + 1
  if index > 0 and index <= #self.items then
    return index
  end
  return -1
end

function ISMoreBuildVirtualList:topOfItem(index)
  if index > 0 and index <= #self.items then
    return (index - 1) * self.itemheight
  end
  return -1
end

function ISMoreBuildVirtualList:prevVisibleIndex(index)
  if index > 1 then
    return index - 1
  end
  return -1
end

function ISMoreBuildVirtualList:nextVisibleItem(index)
  if index < #self.items then
    return index + 1
  end
  return -1
end

ISMoreBuildVirtualList.nextVisibleIndex = ISMoreBuildVirtualList.nextVisibleItem

function ISMoreBuildVirtualList:ensureVisible(index)
  if index < 1 or index > #self.items then
    return
  end
  local y = self:topOfItem(index)
  if not self.smoothScrollTargetY then
    self.smoothScrollY = self:getYScroll()
  end
  if y <= -self:getYScroll() then
    self.smoothScrollTargetY = -y
  elseif y + self.itemheight > -self:getYScroll() + self.height then
    self.smoothScrollTargetY = -(y + self.itemheight - self.height)
  end
end

function ISMoreBuildVirtualList:prerender()
  if self.items == nil then
    return
  end

  local listHeight = #self.items * self.itemheight
  if self.listHeight ~= listHeight then
    self.listHeight = listHeight
    self:setScrollHeight(listHeight)
  end

  local stencilX = 0
  local stencilY = 0
  local stencilX2 = self.width
  local stencilY2 = self.height
  self:drawRect(0, -self:getYScroll(), self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b)
  if self.drawBorder then
    self:drawRectBorder(0, -self:getYScroll(), self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b)
    stencilX = 1
    stencilY = 1
    stencilX2 = self.width - 1
    stencilY2 = self.height - 1
  end
  if self:isVScrollBarVisible() then
    stencilX2 = self.vscroll.x + 3
  end
  if self:parentsHaveScrollChildren() then
    stencilX = self.javaObject:clampToParentX(self:getAbsoluteX() + stencilX) - self:getAbsoluteX()
    stencilX2 = self.javaObject:clampToParentX(self:getAbsoluteX() + stencilX2) - self:getAbsoluteX()
    stencilY = self.javaObject:clampToParentY(self:getAbsoluteY() + stencilY) - self:getAbsoluteY()
    stencilY2 = self.javaObject:clampToParentY(self:getAbsoluteY() + stencilY2) - self:getAbsoluteY()
  end
  self:setStencilRect(stencilX, stencilY, stencilX2 - stencilX, stencilY2 - stencilY)

  if self.selected ~= -1 and self.selected > #self.items then
    self.selected = #self.items
  end

  local top = math.max(0, -self:getYScroll())
  local firstIndex = math.floor(top / self.itemheight) + 1
  local lastIndex = math.min(#self.items, math.ceil((top + self.height) / self.itemheight) + 1)
  if self.onVisibleRangeChanged
    and (self.visibleFirstIndex ~= firstIndex or self.visibleLastIndex ~= lastIndex) then
    self.visibleFirstIndex = firstIndex
    self.visibleLastIndex = lastIndex
    self:onVisibleRangeChanged(firstIndex, lastIndex)
  end
  local y = (firstIndex - 1) * self.itemheight
  for index = firstIndex, lastIndex do
    local item = self.items[index]
    item.index = index
    item.height = self.itemheight
    local alt = index % 2 == 0
    if alt and self.altBgColor then
      self:drawRect(0, y, self:getWidth(), self.itemheight - 1, self.altBgColor.r, self.altBgColor.g, self.altBgColor.b, self.altBgColor.a)
    end
    self:doDrawItem(y, item, alt)
    y = y + self.itemheight
  end

  self:clearStencilRect()
  if self.doRepaintStencil then
    self:repaintStencilRect(stencilX, stencilY, stencilX2 - stencilX, stencilY2 - stencilY)
  end
  local mouseY = self:getMouseY()
  self:updateSmoothScrolling()
  if mouseY ~= self:getMouseY() and self:isMouseOver() then
    self:onMouseMove(0, self:getMouseY() - mouseY)
  end
  self:updateTooltip()
  if self.useStencilForChildren then
    self:setStencilRect(0, 0, self.width, self.height)
  end
end

function ISMoreBuildVirtualList:new(x, y, width, height)
  return ISScrollingListBox.new(self, x, y, width, height)
end

ISMoreBuildWindow = ISCollapsableWindow:derive('ISMoreBuildWindow')

function ISMoreBuildWindow:drawCategoryItem(list, y, item, alt)
  local row = item.item
  local category = row.category
  local height = item.height or list.itemheight
  local selected = list.selected == item.index
  local indent = row.depth == 1 and 22 or 10
  local nameColor = row.depth == 0 and 0.96 or 0.82
  local rowWidth = list:isVScrollBarVisible() and list.vscroll.x - 2 or list:getWidth()
  if list.selected == item.index then
    list:drawRect(0, y, rowWidth, height, 0.78, 0.21, 0.43, 0.62)
    list:drawRect(0, y, 3, height, 1, 0.31, 0.76, 0.96)
  elseif alt then
    list:drawRect(0, y, rowWidth, height, 0.18, 0.08, 0.11, 0.15)
  end
  if row.depth == 0 and not selected then
    list:drawRect(0, y + height - 1, rowWidth, 1, 0.32, 0.24, 0.34, 0.44)
  end
  local count = category.count
  if category.key == FAVOURITES_CATEGORY then
    count = self.favouriteCategoryCounts[FAVOURITES_CATEGORY] or 0
  elseif category.key == POPULAR_CATEGORY then
    count = #self.popularEntries
  end
  count = tostring(count)
  local countWidth = getTextManager():MeasureStringX(UIFont.Small, count) + 12
  local countX = rowWidth - countWidth - 7
  local nameWidth = math.max(1, countX - indent - 5)
  local nameFont = row.depth == 0 and UIFont.Small or UIFont.NewSmall
  if row.nameWidth ~= nameWidth then
    row.nameWidth = nameWidth
    row.displayName = getTextManager():WrapText(nameFont, category.name, nameWidth, 1, '...')
  end
  list:drawRect(countX, y + (height - 17) / 2, countWidth, 17, selected and 0.72 or 0.38, 0.12, 0.19, 0.29)
  list:drawText(count, countX + 6, y + (height - FONT_SMALL) / 2, nameColor, nameColor, nameColor, 1, UIFont.Small)
  list:drawText(row.displayName, indent, y + (height - FONT_SMALL) / 2, nameColor, nameColor, nameColor, 1, nameFont)
  return y + height
end

function ISMoreBuildWindow:drawBuildingItem(list, y, item, alt)
  local entry = item.item
  ensureEntryName(entry)
  ensureEntryPreview(entry)
  local height = item.height or list.itemheight
  local availability = self.recipeAvailability[entry.definitionId]
  local available = availability == true
  local nameColor = available and 0.96 or 0.54
  local pathColor = available and 0.72 or 0.4
  local iconColor = available and 1 or 0.52
  if list.selected == item.index then
    list:drawRect(0, y, list:getWidth(), height, 0.78, 0.18, 0.36, 0.54)
    list:drawRect(0, y, 3, height, 1, 0.31, 0.76, 0.96)
  elseif alt then
    list:drawRect(0, y, list:getWidth(), height, 0.16, 0.08, 0.1, 0.14)
  end
  list:drawRect(0, y + height - 1, list:getWidth(), 1, 0.22, 0.22, 0.28, 0.34)
  if #entry.previewTextures > 0 then
    drawPreview(list, entry.previewTextures, 7, y + 4, LIST_PREVIEW_WIDTH, LIST_PREVIEW_HEIGHT, iconColor, entry.listPreviewLayout)
  end
  local textX = LIST_PREVIEW_WIDTH + 16
  local contentRight = list:isVScrollBarVisible() and list.vscroll.x - 6 or list:getWidth() - 8
  local favouriteX = contentRight - LIST_FAVOURITE_ICON_SIZE
  if self:isFavourite(entry) then
    local colour = getCore():getGoodHighlitedColor()
    list:drawTextureScaledAspect(
      FAVOURITE_YES_TEXTURE,
      favouriteX,
      y + 8,
      LIST_FAVOURITE_ICON_SIZE,
      LIST_FAVOURITE_ICON_SIZE,
      iconColor,
      colour:getR(),
      colour:getG(),
      colour:getB()
    )
  end
  cacheListText(entry, favouriteX - textX - 6)
  list:drawText(entry.listName, textX, y + 8, nameColor, nameColor, nameColor, 1, UIFont.Medium)
  list:drawText(entry.listPath, textX, y + height - FONT_SMALL - 8, pathColor, pathColor, pathColor, 1, UIFont.Small)
  return y + height
end

function ISMoreBuildWindow:drawRecipePreview(panel, entry)
  ensureEntryPreview(entry)
  drawPreview(panel, entry.previewTextures, 3, 3, panel:getWidth() - 6, panel:getHeight() - 6, 1, entry.detailPreviewLayout)
end

function ISMoreBuildWindow:drawDetails(panel)
  panel:drawRect(0, 0, panel:getWidth(), panel:getHeight(), 0.92, 0.045, 0.055, 0.075)
  panel:drawRectBorder(0, 0, panel:getWidth(), panel:getHeight(), 0.65, 0.27, 0.42, 0.6)
  panel:drawText(getText('UI_MoreBuild_Details'), 10, 7, 0.94, 0.94, 0.96, 1, UIFont.Small)
  panel:drawRect(8, PANEL_HEADER_HEIGHT - 1, panel:getWidth() - 16, 1, 0.45, 0.23, 0.38, 0.55)
  if self.selectedEntry == nil then
    panel:drawText(getText('UI_MoreBuild_NoSelection'), 12, PANEL_HEADER_HEIGHT + 10, 0.68, 0.7, 0.74, 1, UIFont.Small)
  end
end

function ISMoreBuildWindow:clearRecipeDetails()
  self.recipeDetailsElements:clearChildren()
  self.recipeDetailsContent:setScrollHeight(0)
  self.recipeDetailsContent:setYScroll(0)
  self.recipeHeader = nil
  self.recipePreview = nil
  self.recipeInputCards = {}
  self.recipeDetailsLogic = nil
  self.recipeMaterialInputCounts = nil
  self.requirementsY = nil
  self.requirementsHeight = nil
  self.buildAvailable = false
end

function ISMoreBuildWindow:hasMissingRecipeInput(recipe, logic)
  for index = 0, recipe:getInputs():size() - 1 do
    local input = recipe:getInputs():get(index)
    if input:getResourceType() == ResourceType.Item then
      local count = self.recipeMaterialInputCounts and self.recipeMaterialInputCounts[input] or 0
      if count < input:getIntAmount() then
        return true
      end
    elseif not logic:isInputSatisfied(input) then
      return true
    end
  end
  return false
end

function ISMoreBuildWindow:updateRecipeHeaderError(header)
  local logic = header.logic
  local player = header.player
  if logic == nil or ConstructionClient.canPerform(logic, player) then
    header.errorLabel:setVisible(false)
    return
  end

  local errors = {}
  if self:hasMissingRecipeInput(header.recipe, logic) then
    errors[#errors + 1] = getText('IGUI_CraftingWindow_Error_Inputs')
  end
  if not header.isCanWalk and player:isPlayerMoving() then
    errors[#errors + 1] = getText('IGUI_CraftingWindow_Error_Moving')
  end
  if header.needToBeLearn and not player:isRecipeKnown(header.recipe, true) then
    errors[#errors + 1] = getText('IGUI_CraftingWindow_Error_NotLearn')
  end
  if not header.canBeDoneInDark and player:tooDarkToRead() then
    errors[#errors + 1] = getText('IGUI_CraftingWindow_Error_TooDark')
  end
  if header.requiresSurface and not logic:isCharacterInRangeOfWorkbench() then
    errors[#errors + 1] = getText('IGUI_CraftingWindow_Error_Workbench')
  end

  if #errors == 0 then
    header.errorLabel:setVisible(false)
    return
  end
  header.errorLabel.errorText = getText('IGUI_CraftingWindow_Error_NotAvailable') .. table.concat(errors, ', ')
  header.errorLabel:setVisible(true)
end

local function getRecipeHeaderTextWidth(header, width)
  local propertyIconWidth = 0
  local favouriteIconWidth = header.favouritesIcon and header.favouritesIcon:getWidth() / 3 or 0
  local propertyIcons = {
    header.isCanWalkIcon,
    header.canBeDoneInDarkIcon,
    header.needToBeLearnIcon,
    header.requiresSurfaceIcon,
    header.timeIcon,
  }
  for _, icon in pairs(propertyIcons) do
    if icon then
      propertyIconWidth = propertyIconWidth + icon:getWidth() + 5
    end
  end

  local iconWidth = header.icon and header.icon:getWidth() or 0
  return math.max(
    1,
    width
      - header.paddingLeft
      - header.marginLeft
      - header.paddingRight
      - header.marginRight
      - iconWidth
      - favouriteIconWidth
      - propertyIconWidth
      - 45
  )
end

local function wrapDetailText(font, text, width)
  text = tostring(text or '')
  width = math.max(1, math.floor(width or 1))

  local lines = {}
  local line = ''
  local lineWidth = 0
  local index = 1
  local length = #text

  local function pushLine()
    lines[#lines + 1] = line
    line = ''
    lineWidth = 0
  end

  while index <= length do
    local byte = string.byte(text, index)
    if byte == 10 then
      pushLine()
      index = index + 1
    else
      local charLength = 1
      if byte >= 240 then
        charLength = 4
      elseif byte >= 224 then
        charLength = 3
      elseif byte >= 192 then
        charLength = 2
      end
      local char = string.sub(text, index, index + charLength - 1)
      local charWidth = getTextManager():MeasureStringX(font, char)
      if line ~= '' and lineWidth + charWidth > width then
        pushLine()
      end
      line = line .. char
      lineWidth = lineWidth + charWidth
      index = index + charLength
    end
  end

  if line ~= '' or #lines == 0 then
    pushLine()
  end
  return table.concat(lines, '\n')
end

local function getToolChoiceText(input)
  if input:getResourceType() ~= ResourceType.Item or not input:isKeep() then
    return nil
  end

  local possibleItems = input:getPossibleInputItems()
  local names = {}
  local seen = {}
  for index = 0, possibleItems:size() - 1 do
    local name = possibleItems:get(index):getDisplayName()
    if name ~= nil and name ~= '' and not seen[name] then
      seen[name] = true
      names[#names + 1] = name
    end
  end
  if #names < 2 then
    return nil
  end
  return getText('UI_MoreBuild_ToolChoices') .. ': ' .. table.concat(names, ' / ')
end

local function exposeToolChoices(card, input)
  local choiceText = getToolChoiceText(input)
  if choiceText == nil then
    return
  end

  -- Keep the native card layout and expose the complete list only on hover.
  card.primary.icon:setMouseOverText(choiceText)

  local originalUpdateScriptValues = card.updateScriptValues
  card.updateScriptValues = function(self, values)
    originalUpdateScriptValues(self, values)
    if values == self.primary then
      values.tooltipText = choiceText
      self.primary.icon:setMouseOverText(choiceText)
    end
  end
end

function ISMoreBuildWindow:layoutRecipeElements(width)
  local panel = self.recipeDetailsElements
  local panelWidth = width
  width = width - REQUIREMENT_GAP * 2
  local y = REQUIREMENT_GAP

  local textWidth = getRecipeHeaderTextWidth(self.recipeHeader, width)
  local title = wrapDetailText(
    self.recipeHeader.titleLabel.font,
    self.recipeHeader.titleLabel.origTitleStr,
    textWidth
  )
  self.recipeHeader.titleLabel:setName(title)
  self.recipeHeader.titleLabel:setHeightToName(0)
  if self.recipeHeader.tooltipLabel then
    local tooltip = wrapDetailText(
      self.recipeHeader.tooltipLabel.font,
      self.recipeHeader.tooltipLabel.origText,
      textWidth
    )
    self.recipeHeader.tooltipLabel:setName(tooltip)
    self.recipeHeader.tooltipLabel:setHeightToName(0)
  end
  self.recipeHeader:calculateLayout(width, 0)
  self.recipeHeader:setX(REQUIREMENT_GAP)
  self.recipeHeader:setY(y)
  self.recipeHeader:setWidth(width)
  if self.recipePreview then
    self.recipePreview:setX(self.recipeHeader.icon:getX())
    self.recipePreview:setY(self.recipeHeader.icon:getY())
  end
  y = y + self.recipeHeader:getHeight() + REQUIREMENT_GAP

  local requirementsY = y
  y = y + FONT_SMALL + REQUIREMENT_GAP * 2
  local sectionPadding = REQUIREMENT_GAP
  local cardAreaWidth = width - sectionPadding * 2

  local minimumCardWidth = 0
  for _, card in ipairs(self.recipeInputCards) do
    card:calculateLayout(0, 0)
    minimumCardWidth = math.max(minimumCardWidth, card:getWidth())
  end
  local columns = math.min(REQUIREMENT_COLUMNS, #self.recipeInputCards)
  if columns > 0 then
    columns = math.max(1, math.floor((cardAreaWidth + REQUIREMENT_GAP) / (minimumCardWidth + REQUIREMENT_GAP)))
    columns = math.min(columns, REQUIREMENT_COLUMNS, #self.recipeInputCards)
  end
  local cardWidth = columns > 0 and math.floor((cardAreaWidth - REQUIREMENT_GAP * (columns - 1)) / columns) or 0
  local rowHeight = 0
  local column = 0
  for _, card in ipairs(self.recipeInputCards) do
    -- ISWidgetInput does not recalculate its child positions from onResize().
    -- Give it the final card width before recalculating its internal layout.
    card:setWidth(cardWidth)
    card:calculateLayout(cardWidth, 0)
    card:setX(REQUIREMENT_GAP + sectionPadding + column * (cardWidth + REQUIREMENT_GAP))
    card:setY(y)
    rowHeight = math.max(rowHeight, card:getHeight())
    column = column + 1
    if column == columns then
      column = 0
      y = y + rowHeight + REQUIREMENT_GAP
      rowHeight = 0
    end
  end
  if column ~= 0 then
    y = y + rowHeight + REQUIREMENT_GAP
  end
  self.requirementsY = requirementsY
  self.requirementsHeight = y - requirementsY
  panel:setWidth(panelWidth)
  panel:setHeight(y)
  return y
end

function ISMoreBuildWindow:layoutRecipeDetails()
  if self.recipeHeader == nil then
    return
  end

  local viewport = self.recipeDetailsContent
  local width = viewport:getWidth()
  local height = self:layoutRecipeElements(width)
  if height > viewport:getHeight() then
    height = self:layoutRecipeElements(width - viewport.vscroll:getWidth())
  end
  viewport.vscroll:setX(width - viewport.vscroll:getWidth())
  viewport.vscroll:setY(0)
  viewport.vscroll:setHeight(viewport:getHeight())
  viewport:setScrollHeight(height)
  self.recipeDetailsHeight = height
end

function ISMoreBuildWindow:isFavourite(entry)
  return self.favourites[entry.definitionId] == true
end

function ISMoreBuildWindow:refreshFavouriteCategoryCounts()
  local player = getSpecificPlayer(self.playerIndex)
  self.favourites = player:getModData()[FAVOURITES_MOD_DATA_KEY] or {}
  self.favouriteEntries = {}
  for _, entry in ipairs(self.entries) do
    if self:isFavourite(entry) then
      self.favouriteEntries[#self.favouriteEntries + 1] = entry
    end
  end
  self.favouriteCategoryCounts = { [FAVOURITES_CATEGORY] = #self.favouriteEntries }
end

function ISMoreBuildWindow:refreshPopularEntries()
  self.popularEntries = {}
  if not PopularBuildings.isAvailable() then
    return
  end

  local scores = PopularBuildings.getVisibleScores()
  if scores == nil then
    return
  end
  for definitionId in pairs(scores) do
    local entry = self.entriesByDefinitionId[definitionId]
    if entry then
      self.popularEntries[#self.popularEntries + 1] = entry
    end
  end
  TableUtil.stableMergeSort(self.popularEntries, function(left, right)
    local leftScore = scores[left.definitionId]
    local rightScore = scores[right.definitionId]
    if leftScore == rightScore then
      ensureEntryName(left)
      ensureEntryName(right)
      return left.name < right.name
    end
    return leftScore > rightScore
  end)
end

function ISMoreBuildWindow:toggleFavourite(entry)
  local player = getSpecificPlayer(self.playerIndex)
  local modData = player:getModData()
  local favourites = self.favourites
  local favourite = not self:isFavourite(entry)
  if favourite then
    if modData[FAVOURITES_MOD_DATA_KEY] == nil then
      modData[FAVOURITES_MOD_DATA_KEY] = favourites
    end
    favourites[entry.definitionId] = true
  else
    favourites[entry.definitionId] = nil
  end
  player:transmitModData()

  if self.selectedEntry == entry and self.recipeHeader and self.recipeHeader.favouritesIcon then
    self.recipeHeader.isFavourite = favourite
    if favourite then
      local colour = getCore():getGoodHighlitedColor()
      self.recipeHeader.favouritesIcon.image = FAVOURITE_YES_TEXTURE
      self.recipeHeader.favouritesIcon.textureColor = { r = colour:getR(), g = colour:getG(), b = colour:getB(), a = 1 }
    else
      self.recipeHeader.favouritesIcon.image = FAVOURITE_NO_TEXTURE
      self.recipeHeader.favouritesIcon.textureColor = { r = 1, g = 1, b = 1, a = 1 }
    end
  end

  self:refreshFavouriteCategoryCounts()
  if self.selectedCategory == FAVOURITES_CATEGORY or self.selectedCategory == POPULAR_CATEGORY then
    self:applyFilters()
  end
end

function ISMoreBuildWindow:onFavouriteClick(button, entry)
  self:toggleFavourite(entry)
end

function ISMoreBuildWindow:buildRecipeDetails()
  local entry = self.selectedEntry
  if entry == nil then
    return
  end
  ensureEntryName(entry)
  ensureEntryPreview(entry)
  ensureEntryDescription(entry)

  local player = getSpecificPlayer(self.playerIndex)
  local recipe = ConstructionService.getRecipe(entry.definitionId)
  self.recipeInputCards = {}
  self.recipeHeader = ISXuiSkin.build(nil, 'S_NeedsAStyle', ISWidgetTitleHeader, 0, 0, 10, 10, recipe, player, self.recipeDetailsLogic, self:isFavourite(entry))
  self.recipeHeader.title = entry.name
  self.recipeHeader.iconTex = entry.texture
  self.recipeHeader.ignoreSurface = true
  self.recipeHeader.isCanWalk = true
  self.recipeHeader:initialise()
  self.recipeHeader:instantiate()
  self.recipeHeader.favouritesIcon.target = self
  self.recipeHeader.favouritesIcon:setOnClick(ISMoreBuildWindow.onFavouriteClick, entry)
  self.recipeHeader:removeChild(self.recipeHeader.isCanWalkIcon)
  self.recipeHeader.isCanWalkIcon = nil
  local updateLabels = self.recipeHeader.updateLabels
  self.recipeHeader.updateLabels = function(header)
    updateLabels(header)
    self:updateRecipeHeaderError(header)
  end
  self.recipeHeader:updateLabels()
  if #entry.previewTextures > 0 then
    local previewWidth = entry.detailPreviewLayout[1]
    local previewHeight = entry.detailPreviewLayout[2]
    self.recipeHeader.icon:setWidth(previewWidth + 6)
    self.recipeHeader.icon:setHeight(previewHeight + 6)
    self.recipeHeader.icon:setVisible(false)
    self.recipePreview = ISPanel:new(0, 0, previewWidth + 6, previewHeight + 6)
    self.recipePreview:initialise()
    self.recipePreview:instantiate()
    self.recipePreview:noBackground()
    self.recipePreview.render = function(panel)
      ISPanel.render(panel)
      self:drawRecipePreview(panel, entry)
    end
    self.recipeHeader:addChild(self.recipePreview)
    self.recipeHeader.favouritesIcon:bringToTop()
  end
  local tooltipColor = { r = 0.5, g = 0.5, b = 0.5, a = 1.0 }
  local tooltipLabel = ISXuiSkin.build(self.recipeHeader.xuiSkin, 'S_NeedsAStyle', ISLabel, 0, 0, -1, entry.tooltip, tooltipColor.r, tooltipColor.g, tooltipColor.b, tooltipColor.a, UIFont.NewSmall, true)
  tooltipLabel:initialise()
  tooltipLabel:instantiate()
  tooltipLabel.origText = entry.tooltip
  tooltipLabel:setHeightToName(0)
  self.recipeHeader.tooltipLabel = tooltipLabel
  self.recipeHeader:addChild(tooltipLabel)
  self.recipeDetailsElements:addChild(self.recipeHeader)

  for index = 0, recipe:getInputs():size() - 1 do
    local input = recipe:getInputs():get(index)
    if not input:isAutomationOnly() then
      local card = ISXuiSkin.build(nil, 'S_NeedsAStyle', ISWidgetInput, 0, 0, 10, 10, player, self.recipeDetailsLogic, input)
      card.labelIconSize = REQUIREMENT_STATUS_ICON_SIZE
      card.isBuildMenu = true
      card.interactiveMode = true
      if input:getResourceType() == ResourceType.Item then
        local updateValues = card.updateValues
        card.updateValues = function(requirementCard)
          updateValues(requirementCard)
          local count = self.recipeMaterialInputCounts and self.recipeMaterialInputCounts[requirementCard.inputScript]
          if count == nil then
            return
          end
          local required = requirementCard.inputScript:getIntMaxAmount()
          requirementCard.primary.label:setName(tostring(count) .. '/' .. tostring(required))
          if count >= required then
            requirementCard.primary.label.textColor = requirementCard.textColor
            requirementCard.primary.icon.backgroundColor.a = 1
            requirementCard.borderColor = requirementCard.normalBorderColor
          elseif count > 0 then
            requirementCard.primary.label.textColor = requirementCard.colPartial
            requirementCard.borderColor = requirementCard.colPartial
          else
            requirementCard.primary.label.textColor = requirementCard.colBad
            requirementCard.primary.icon.backgroundColor.a = 0.25
            requirementCard.borderColor = requirementCard.colBad
          end
        end
      end
      card.onMouseDown = function()
      end
      card.onMouseDownOutside = function()
      end
      card:initialise()
      card:instantiate()
      card.primary.selectInputButton:setVisible(false)
      exposeToolChoices(card, input)
      self.recipeDetailsElements:addChild(card)
      self.recipeInputCards[#self.recipeInputCards + 1] = card
    end
  end
  self:layoutRecipeDetails()
end

function ISMoreBuildWindow:updateRecipeDetails()
  self:clearRecipeDetails()
  if self.selectedEntry == nil then
    return
  end

  self:refreshAvailability(false, true)
  self:buildRecipeDetails()
end

function ISMoreBuildWindow:rebuildCategories()
  local cache = getCatalogCache()
  self.entries = cache.entries
  self.entriesByDefinitionId = cache.entriesByDefinitionId
  self.categories = cache.categories
  clearList(self.categoryList)
  self.selectedGroup = categoryGroupId(self.selectedCategory)
  if self.selectedGroup ~= ROOT_CATEGORY and self.selectedGroup ~= FAVOURITES_CATEGORY and self.selectedGroup ~= POPULAR_CATEGORY and cache.groupsById[self.selectedGroup] == nil then
    self.selectedGroup = ROOT_CATEGORY
    self.selectedCategory = ROOT_CATEGORY
  end

  self.categoryItems = {}
  local selectedIndex = 1
  local function addCategory(category, depth)
    local row = {
      category = category,
      depth = depth,
    }
    self.categoryItems[#self.categoryItems + 1] = row
    self.categoryList:addItem(category.name, row)
    if category.key == self.selectedCategory then
      selectedIndex = #self.categoryItems
    end
  end

  addCategory(self.categories[1], 0)
  for index = 2, #self.categories do
    local category = self.categories[index]
    addCategory(category, 0)
    if category.key == self.selectedGroup then
      local subcategories = cache.subcategoriesByGroup[category.groupId]
      if subcategories then
        for subcategoryIndex = 1, #subcategories do
          addCategory(subcategories[subcategoryIndex], 1)
        end
      end
    end
  end

  self.categoryList.selected = selectedIndex
  local selectedRow = self.categoryItems[selectedIndex]
  if selectedRow then
    self.selectedCategory = selectedRow.category.key
    self.selectedGroup = categoryGroupId(self.selectedCategory)
  end
  self:layoutCategoryLists()
end

function ISMoreBuildWindow:applyFilters()
  local query = string.lower(self.searchBox:getInternalText())
  local selectedDefinitionId = self.selectedEntry and self.selectedEntry.definitionId or nil
  local selectedIndex = nil
  self.filteredEntries = {}
  self.filteredDefinitionIds = {}
  clearList(self.buildList)
  self.buildList.visibleFirstIndex = nil
  self.buildList.visibleLastIndex = nil
  self.visibleAvailabilityFirstIndex = -1
  self.visibleAvailabilityLastIndex = -1
  local cache = getCatalogCache()
  local entries
  if self.selectedCategory == POPULAR_CATEGORY then
    entries = self.popularEntries
  elseif self.selectedCategory == FAVOURITES_CATEGORY then
    entries = self.favouriteEntries
  elseif query ~= '' then
    entries = self.entries
  else
    entries = cache.entriesByCategoryKey[self.selectedCategory] or {}
  end
  for _, entry in ipairs(entries) do
    if matchesSearch(entry, query) then
      self.filteredEntries[#self.filteredEntries + 1] = entry
      self.filteredDefinitionIds[#self.filteredDefinitionIds + 1] = entry.definitionId
      self.buildList:addItem(entry.name or entry.definitionId, entry)
      if entry.definitionId == selectedDefinitionId then
        selectedIndex = #self.filteredEntries
      end
    end
  end
  if #self.filteredEntries == 0 then
    self.buildList.selected = 0
    self.selectedEntry = nil
    self:clearRecipeDetails()
  else
    selectedIndex = selectedIndex or 1
    self.buildList.selected = selectedIndex
    self.selectedEntry = self.filteredEntries[selectedIndex]
    self:updateRecipeDetails()
  end
  self.filtersDirty = false
end

function ISMoreBuildWindow:scheduleFilters()
  self.filtersDirty = true
  self.filterDeadline = getTimestampMs() + SEARCH_DELAY_MS
end

function ISMoreBuildWindow:updateDeferredFilters()
  if self.filtersDirty and getTimestampMs() >= self.filterDeadline then
    self:applyFilters()
  end
end

function ISMoreBuildWindow:updateRequiredSkillColors()
  if self.recipeHeader == nil then
    return
  end

  local recipe = self.recipeHeader.recipe
  local player = getSpecificPlayer(self.playerIndex)
  for index, label in ipairs(self.recipeHeader.requiredSkillList) do
    local requiredSkill = recipe:getRequiredSkill(index - 1)
    label.textColor = CraftRecipeManager.hasPlayerRequiredSkill(requiredSkill, player)
      and self.recipeHeader.colGood
      or self.recipeHeader.colBad
  end
end

function ISMoreBuildWindow:refreshAvailability(force, immediate)
  if self.selectedEntry == nil then
    self.buildAvailable = false
    return
  end

  local now = getTimestampMs()
  if not force and not immediate and now < self.nextAvailabilityRefreshAt then
    return
  end
  self.nextAvailabilityRefreshAt = now + 100

  local availability, logic, materialInputCounts, refreshed, revision, characterChanged = ConstructionClient.refreshAvailability(
    getSpecificPlayer(self.playerIndex),
    self.selectedEntry.definitionId,
    force
  )
  local previousRevision = self.availabilityRevision
  self.recipeAvailability = availability
  self.recipeDetailsLogic = logic
  self.recipeMaterialInputCounts = materialInputCounts
  self.availabilityRevision = revision
  self.buildAvailable = availability[self.selectedEntry.definitionId] == true
  if previousRevision ~= revision and self.buildList.visibleFirstIndex then
    self:ensureVisibleAvailability(self.buildList.visibleFirstIndex, self.buildList.visibleLastIndex)
  end
  if refreshed and self.recipeHeader then
    if characterChanged then
      self:updateRequiredSkillColors()
    end
    self.recipeHeader:updateLabels()
    self:layoutRecipeDetails()
  end
end

function ISMoreBuildWindow:ensureVisibleAvailability(firstIndex, lastIndex)
  if self.selectedEntry == nil then
    return
  end
  if self.visibleAvailabilityRevision == self.availabilityRevision
    and self.visibleAvailabilityFirstIndex == firstIndex
    and self.visibleAvailabilityLastIndex == lastIndex then
    return
  end

  self.recipeAvailability = ConstructionClient.ensureAvailability(
    getSpecificPlayer(self.playerIndex),
    self.filteredDefinitionIds,
    firstIndex,
    lastIndex
  )
  self.buildAvailable = self.recipeAvailability[self.selectedEntry.definitionId] == true
  self.visibleAvailabilityRevision = self.availabilityRevision
  self.visibleAvailabilityFirstIndex = firstIndex
  self.visibleAvailabilityLastIndex = lastIndex
end

function ISMoreBuildWindow:refresh()
  self:rebuildCategories()
  self:refreshFavouriteCategoryCounts()
  self:refreshPopularEntries()
  self:applyFilters()
end

function ISMoreBuildWindow:onCategoryMouseDown(list, x, y)
  ISScrollingListBox.onMouseDown(list, x, y)
  local row = list.items[list.selected]
  if row == nil then
    return true
  end
  self.selectedCategory = row.item.category.key
  self.selectedGroup = categoryGroupId(self.selectedCategory)
  self:rebuildCategories()
  self:applyFilters()
  return true
end

function ISMoreBuildWindow:onBuildingMouseDown(list, x, y)
  ISScrollingListBox.onMouseDown(list, x, y)
  local row = list.items[list.selected]
  self.selectedEntry = row and row.item or nil
  self:updateRecipeDetails()
  return true
end

function ISMoreBuildWindow:onBuildingDoubleClick(entry)
  self.selectedEntry = entry
  self:onBuild()
end

function ISMoreBuildWindow:onBuild()
  if self.selectedEntry and self.startBuild(self.selectedEntry.definitionId, self.playerIndex) then
    self:setVisible(false)
  end
end

function ISMoreBuildWindow:createChildren()
  ISCollapsableWindow.createChildren(self)
  self:setTitle(getText('UI_MoreBuild_Title'))

  self.catalogPanel = ISPanel:new(0, 0, 100, 100)
  self.catalogPanel:initialise()
  self.catalogPanel:instantiate()
  self.catalogPanel:noBackground()
  self.catalogPanel.prerender = function(panel)
    ISPanel.prerender(panel)
    panel:drawRect(0, 0, panel:getWidth(), panel:getHeight(), 0.92, 0.045, 0.055, 0.075)
    panel:drawRectBorder(0, 0, panel:getWidth(), panel:getHeight(), 0.65, 0.27, 0.42, 0.6)
    panel:drawText(getText('UI_MoreBuild_Catalog'), 10, 7, 0.94, 0.94, 0.96, 1, UIFont.Small)
    local resultText = getText('UI_MoreBuild_Results') .. ': ' .. tostring(#self.filteredEntries)
    local resultWidth = getTextManager():MeasureStringX(UIFont.Small, resultText)
    panel:drawText(resultText, panel:getWidth() - resultWidth - 10, 7, 0.62, 0.7, 0.8, 1, UIFont.Small)
    panel:drawRect(8, PANEL_HEADER_HEIGHT - 1, panel:getWidth() - 16, 1, 0.45, 0.23, 0.38, 0.55)
    panel:drawRect(8, PANEL_HEADER_HEIGHT + 5, panel:getWidth() - 16, 24, 0.88, 0.09, 0.12, 0.17)
    panel:drawRectBorder(8, PANEL_HEADER_HEIGHT + 5, panel:getWidth() - 16, 24, 0.82, 0.26, 0.48, 0.72)
  end
  self:addChild(self.catalogPanel)

  self.searchBox = ISTextEntryBox:new('', 0, 0, 100, 24)
  self.searchBox.font = UIFont.Medium
  self.searchBox:initialise()
  self.searchBox:instantiate()
  self.searchBox:setClearButton(true)
  self.searchBox:setTextRGBA(0.94, 0.94, 0.96, 1)
  self.searchBox:setPlaceholderText(getText('UI_MoreBuild_SearchPlaceholder'))
  self.searchBox:setPlaceholderTextRGBA(0.62, 0.68, 0.76, 1)
  self.searchBox.backgroundColor = { r = 0.025, g = 0.035, b = 0.055, a = 1 }
  self.searchBox.borderColor = { r = 0.32, g = 0.52, b = 0.78, a = 1 }
  self.searchBox.target = self
  self.searchBox.onTextChangeFunction = function(target)
    target:scheduleFilters()
  end
  self.catalogPanel:addChild(self.searchBox)

  self.categoryPanel = ISPanel:new(0, 0, 100, 100)
  self.categoryPanel:initialise()
  self.categoryPanel:instantiate()
  self.categoryPanel:noBackground()
  self.categoryPanel.prerender = function(panel)
    ISPanel.prerender(panel)
    panel:drawRect(0, 0, panel:getWidth(), panel:getHeight(), 0.92, 0.045, 0.055, 0.075)
    panel:drawRectBorder(0, 0, panel:getWidth(), panel:getHeight(), 0.65, 0.27, 0.42, 0.6)
    panel:drawText(getText('UI_MoreBuild_Categories'), 10, 7, 0.94, 0.94, 0.96, 1, UIFont.Small)
    panel:drawRect(8, PANEL_HEADER_HEIGHT - 1, panel:getWidth() - 16, 1, 0.45, 0.23, 0.38, 0.55)
  end
  self:addChild(self.categoryPanel)

  self.categoryList = ISScrollingListBox:new(0, 0, 100, 100)
  self.categoryList:initialise()
  self.categoryList:instantiate()
  self.categoryList.itemheight = 28
  self.categoryList.drawBorder = false
  self.categoryList.backgroundColor = { r = 0.02, g = 0.02, b = 0.02, a = 0 }
  self.categoryList.borderColor = { r = 0.5, g = 0.5, b = 0.5, a = 0 }
  self.categoryList.doDrawItem = function(list, y, item, alt)
    return self:drawCategoryItem(list, y, item, alt)
  end
  self.categoryList.onMouseDown = function(list, x, y)
    return self:onCategoryMouseDown(list, x, y)
  end
  self.categoryPanel:addChild(self.categoryList)

  self.buildList = ISMoreBuildVirtualList:new(0, 0, 100, 100)
  self.buildList:initialise()
  self.buildList:instantiate()
  self.buildList.itemheight = 72
  self.buildList.drawBorder = false
  self.buildList.backgroundColor = { r = 0.02, g = 0.02, b = 0.02, a = 0 }
  self.buildList.borderColor = { r = 0.5, g = 0.5, b = 0.5, a = 0 }
  self.buildList.doDrawItem = function(list, y, item, alt)
    return self:drawBuildingItem(list, y, item, alt)
  end
  self.buildList.onVisibleRangeChanged = function(list, firstIndex, lastIndex)
    self:ensureVisibleAvailability(firstIndex, lastIndex)
  end
  self.buildList.onMouseDown = function(list, x, y)
    return self:onBuildingMouseDown(list, x, y)
  end
  self.buildList:setOnMouseDoubleClick(self, ISMoreBuildWindow.onBuildingDoubleClick)
  self.catalogPanel:addChild(self.buildList)

  self.detailsPanel = ISPanel:new(0, 0, 100, 100)
  self.detailsPanel:initialise()
  self.detailsPanel:instantiate()
  self.detailsPanel:noBackground()
  self.detailsPanel.prerender = function(panel)
    ISPanel.prerender(panel)
    self:drawDetails(panel)
  end
  self:addChild(self.detailsPanel)

  self.recipeDetailsContent = ISPanel:new(0, 0, 100, 100)
  self.recipeDetailsContent.prerender = function(panel)
    panel:setStencilRect(0, 0, panel:getWidth(), panel:getHeight())
    ISPanel.prerender(panel)
  end
  self.recipeDetailsContent.render = function(panel)
    ISPanel.render(panel)
    panel:clearStencilRect()
  end
  self.recipeDetailsContent.onMouseWheel = function(panel, del)
    if panel:getScrollHeight() > panel:getHeight() then
      panel:setYScroll(panel:getYScroll() - del * 40)
      return true
    end
    return false
  end
  self.recipeDetailsContent:initialise()
  self.recipeDetailsContent:instantiate()
  self.recipeDetailsContent:noBackground()
  self.recipeDetailsContent:setScrollChildren(true)
  self.recipeDetailsContent:addScrollBars()
  self.detailsPanel:addChild(self.recipeDetailsContent)

  self.recipeDetailsElements = ISPanel:new(0, 0, 100, 100)
  self.recipeDetailsElements:initialise()
  self.recipeDetailsElements:instantiate()
  self.recipeDetailsElements:noBackground()
  self.recipeDetailsElements.prerender = function(panel)
    ISPanel.prerender(panel)
    if self.requirementsY then
      local sectionX = REQUIREMENT_GAP
      local sectionWidth = panel:getWidth() - REQUIREMENT_GAP * 2
      panel:drawRect(sectionX, self.requirementsY, sectionWidth, self.requirementsHeight, 0.16, 0.02, 0.02, 0.02)
      panel:drawRectBorder(sectionX, self.requirementsY, sectionWidth, self.requirementsHeight, 0.7, 0.5, 0.5, 0.5)
      panel:drawText(getText('IGUI_CraftingWindow_Requires'), sectionX + REQUIREMENT_GAP, self.requirementsY + REQUIREMENT_GAP, 0.9, 0.9, 0.9, 1, UIFont.Small)
    end
  end
  self.recipeDetailsContent:addChild(self.recipeDetailsElements)

  self.buildButton = ISPanel:new(0, 0, 100, 36)
  self.buildButton:initialise()
  self.buildButton:instantiate()
  self.buildButton:noBackground()
  self.buildButton.enabled = false
  self.buildButton.render = function(button)
    ISPanel.render(button)
    local enabled = button.enabled
    local hovered = enabled and button:isMouseOver()
    local backgroundAlpha = 1
    local backgroundRed = enabled and (hovered and 0.12 or 0.08) or 0.15
    local backgroundGreen = enabled and (hovered and 0.52 or 0.38) or 0.17
    local backgroundBlue = enabled and (hovered and 0.82 or 0.66) or 0.21
    local textRed = enabled and 1 or 0.86
    local textGreen = enabled and 1 or 0.88
    local textBlue = enabled and 1 or 0.92
    local textY = (button:getHeight() - FONT_MEDIUM) / 2
    local title = getText('UI_MoreBuild_Build')
    button:drawRect(0, 0, button:getWidth(), button:getHeight(), backgroundAlpha, backgroundRed, backgroundGreen, backgroundBlue)
    button:drawRectBorder(0, 0, button:getWidth(), button:getHeight(), 1, enabled and 0.5 or 0.38, enabled and 0.82 or 0.42, enabled and 1 or 0.5)
    button:drawTextCentre(title, button:getWidth() / 2 - 1, textY, 0, 0, 0, 1, UIFont.Medium)
    button:drawTextCentre(title, button:getWidth() / 2 + 1, textY, 0, 0, 0, 1, UIFont.Medium)
    button:drawTextCentre(title, button:getWidth() / 2, textY - 1, 0, 0, 0, 1, UIFont.Medium)
    button:drawTextCentre(title, button:getWidth() / 2, textY + 1, 0, 0, 0, 1, UIFont.Medium)
    button:drawTextCentre(title, button:getWidth() / 2, textY, textRed, textGreen, textBlue, 1, UIFont.Medium)
  end
  self.buildButton.onMouseUp = function(button, x, y)
    if button.enabled then
      self:onBuild()
    end
    return true
  end
  self.buildButton.onMouseDown = function(button, x, y)
    return true
  end
  self.detailsPanel:addChild(self.buildButton)

  self:layoutChildren()
  self:refresh()
end

function ISMoreBuildWindow:layoutCategoryLists()
  self.categoryList:setX(6)
  self.categoryList:setY(PANEL_HEADER_HEIGHT + 4)
  self.categoryList:setWidth(self.categoryPanel:getWidth() - 12)
  self.categoryList:setHeight(self.categoryPanel:getHeight() - PANEL_HEADER_HEIGHT - 10)
  layoutListScrollBar(self.categoryList)
end

function ISMoreBuildWindow:layoutCatalogPanels(categoryX, categoryY, categoryWidth, catalogX, catalogY, catalogWidth, panelHeight)
  self.categoryPanel:setX(categoryX)
  self.categoryPanel:setY(categoryY)
  self.categoryPanel:setWidth(categoryWidth)
  self.categoryPanel:setHeight(panelHeight)
  self:layoutCategoryLists()

  self.catalogPanel:setX(catalogX)
  self.catalogPanel:setY(catalogY)
  self.catalogPanel:setWidth(catalogWidth)
  self.catalogPanel:setHeight(panelHeight)
  self.searchBox:setX(8)
  self.searchBox:setY(PANEL_HEADER_HEIGHT + 5)
  self.searchBox:setWidth(self.catalogPanel:getWidth() - 16)
  self.searchBox:setHeight(24)
  self.buildList:setX(6)
  self.buildList:setY(PANEL_HEADER_HEIGHT + CATALOG_TOOLBAR_HEIGHT)
  self.buildList:setWidth(self.catalogPanel:getWidth() - 12)
  self.buildList:setHeight(self.catalogPanel:getHeight() - PANEL_HEADER_HEIGHT - CATALOG_TOOLBAR_HEIGHT - 6)
  layoutListScrollBar(self.buildList)
end

function ISMoreBuildWindow:layoutDetailsPanel(x, y, width, height, buttonHeight, gap)
  self.detailsPanel:setX(x)
  self.detailsPanel:setY(y)
  self.detailsPanel:setWidth(width)
  self.detailsPanel:setHeight(height)
  self.recipeDetailsContent:setX(2)
  self.recipeDetailsContent:setY(PANEL_HEADER_HEIGHT + 2)
  self.recipeDetailsContent:setWidth(self.detailsPanel:getWidth() - 4)
  self.recipeDetailsContent:setHeight(self.detailsPanel:getHeight() - PANEL_HEADER_HEIGHT - buttonHeight - gap * 2 - 2)
  self.buildButton:setX(gap)
  self.buildButton:setY(self.detailsPanel:getHeight() - buttonHeight - gap)
  self.buildButton:setWidth(self.detailsPanel:getWidth() - gap * 2)
  self.buildButton:setHeight(buttonHeight)
end

function ISMoreBuildWindow:layoutChildren()
  local width = self:getWidth()
  local height = self:getHeight()
  local margin = CONTENT_MARGIN
  local gap = CONTENT_GAP
  local top = self:titleBarHeight() + margin
  local bottom = height - margin
  local contentHeight = bottom - top
  local buttonHeight = math.max(36, FONT_MEDIUM + 14)
  local availableWidth = width - margin * 2 - gap * 2
  local minimumThreeColumnWidth = SIDEBAR_MIN_WIDTH + CATALOG_MIN_WIDTH + DETAILS_MIN_WIDTH
  if availableWidth < minimumThreeColumnWidth then
    local rowWidth = width - margin * 2
    local categoryWidth = math.min(SIDEBAR_MIN_WIDTH, math.floor((rowWidth - gap) * 0.3))
    local catalogWidth = rowWidth - categoryWidth - gap
    local upperHeight = math.max(220, math.floor((contentHeight - gap) * 0.56))
    local detailsHeight = contentHeight - upperHeight - gap

    self:layoutCatalogPanels(
      margin,
      top,
      categoryWidth,
      margin + categoryWidth + gap,
      top,
      catalogWidth,
      upperHeight
    )
    self:layoutDetailsPanel(margin, top + upperHeight + gap, rowWidth, detailsHeight, buttonHeight, gap)
    return
  end

  local categoryWidth = math.max(SIDEBAR_MIN_WIDTH, math.min(SIDEBAR_MAX_WIDTH, math.floor(availableWidth * 0.2)))
  local detailsWidth = math.max(DETAILS_MIN_WIDTH, math.min(DETAILS_MAX_WIDTH, math.floor(availableWidth * 0.36)))
  local listWidth = availableWidth - categoryWidth - detailsWidth
  if listWidth < CATALOG_MIN_WIDTH then
    local deficit = CATALOG_MIN_WIDTH - listWidth
    local detailsReduction = math.min(deficit, detailsWidth - DETAILS_MIN_WIDTH)
    detailsWidth = detailsWidth - detailsReduction
    listWidth = listWidth + detailsReduction
  end
  if listWidth < CATALOG_MIN_WIDTH then
    local deficit = CATALOG_MIN_WIDTH - listWidth
    local categoryReduction = math.min(deficit, categoryWidth - SIDEBAR_MIN_WIDTH)
    categoryWidth = categoryWidth - categoryReduction
    listWidth = listWidth + categoryReduction
  end
  local categoryX = margin
  local catalogX = categoryX + categoryWidth + gap
  local rightX = catalogX + listWidth + gap

  self:layoutCatalogPanels(categoryX, top, categoryWidth, catalogX, top, listWidth, contentHeight)
  self:layoutDetailsPanel(rightX, top, detailsWidth, contentHeight, buttonHeight, gap)
end

function ISMoreBuildWindow:onResize()
  ISCollapsableWindow.onResize(self)
  self:layoutChildren()
  self:layoutRecipeDetails()
end

function ISMoreBuildWindow:prerender()
  ISCollapsableWindow.prerender(self)
  if PopularBuildings.isAvailable() and self.popularRevision ~= PopularBuildings.getRevision() then
    self.popularRevision = PopularBuildings.getRevision()
    self:refreshPopularEntries()
    if self.selectedCategory == POPULAR_CATEGORY then
      self:applyFilters()
    end
  end
  self:updateDeferredFilters()
  self:refreshAvailability(false)
  self.buildButton.enabled = self.selectedEntry ~= nil and self.buildAvailable and RegistryClient.isCompatible(self.playerIndex)
end

function ISMoreBuildWindow:new(x, y, width, height, playerIndex, startBuild)
  local window = ISCollapsableWindow.new(self, x, y, width, height)
  window:setWantKeyEvents(true)
  window.playerIndex = playerIndex
  window.startBuild = startBuild
  window.entries = {}
  window.entriesByDefinitionId = {}
  window.filteredEntries = {}
  window.filteredDefinitionIds = {}
  window.favouriteEntries = {}
  window.categories = {}
  window.selectedCategory = ROOT_CATEGORY
  window.selectedGroup = ROOT_CATEGORY
  window.selectedEntry = nil
  window.buildAvailable = false
  window.availabilityRevision = -1
  window.recipeAvailability = {}
  window.visibleAvailabilityFirstIndex = -1
  window.visibleAvailabilityLastIndex = -1
  window.visibleAvailabilityRevision = -1
  window.favouriteCategoryCounts = { [FAVOURITES_CATEGORY] = 0 }
  window.popularEntries = {}
  window.popularRevision = PopularBuildings.getRevision()
  window.favourites = {}
  window.filtersDirty = false
  window.filterDeadline = 0
  window.nextAvailabilityRefreshAt = 0
  window.minimumWidth = 900
  window.minimumHeight = 620
  window.resizable = true
  window.pin = true
  window.backgroundColor = { r = 0.04, g = 0.04, b = 0.04, a = 0.88 }
  window.borderColor = { r = 0.4, g = 0.4, b = 0.4, a = 1 }
  return window
end

function ISMoreBuildWindow:isKeyConsumed(key)
  return key == Keyboard.KEY_ESCAPE
end

function ISMoreBuildWindow:onKeyRelease(key)
  if self:isVisible() and key == Keyboard.KEY_ESCAPE then
    self:close()
    return
  end
end

local windows = {}

local UI = {}

function UI.isVisible(playerIndex)
  local window = windows[playerIndex]
  return window ~= nil and window:isVisible()
end

function UI.close(playerIndex)
  local window = windows[playerIndex]
  if window then
    window:close()
  end
end

function UI.open(playerIndex, startBuild)
  local window = windows[playerIndex]
  local created = false
  if window == nil then
    local screenWidth = getCore():getScreenWidth()
    local screenHeight = getCore():getScreenHeight()
    local width = math.min(1180, math.max(640, screenWidth - 40))
    local height = math.min(720, math.max(480, screenHeight - 40))
    window = ISMoreBuildWindow:new(math.max(0, (screenWidth - width) / 2), math.max(0, (screenHeight - height) / 2), width, height, playerIndex, startBuild)
    window.minimumWidth = math.min(window.minimumWidth, width)
    window.minimumHeight = math.min(window.minimumHeight, height)
    window:initialise()
    window:instantiate()
    window:addToUIManager()
    windows[playerIndex] = window
    created = true
  end
  window.playerIndex = playerIndex
  window.startBuild = startBuild
  PopularBuildings.request()
  window:setVisible(true)
  window:bringToTop()
  if not created then
    window:refreshAvailability(true)
  end
  return window
end

local function clearWindows()
  for _, window in pairs(windows) do
    window:close()
    window:removeFromUIManager()
  end
  windows = {}
  catalogCache = nil
end

Events.OnGameStart.Add(clearWindows)
Events.OnDisconnect.Add(clearWindows)

return UI
