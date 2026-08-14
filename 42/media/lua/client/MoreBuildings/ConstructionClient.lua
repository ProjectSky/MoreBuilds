local ConstructionService = require('MoreBuildings/internal/ConstructionService')
local RegistrationCoordinator = require('MoreBuildings/internal/RegistrationCoordinator')
local NativePlacement = require('MoreBuildings/kinds/NativePlacement')
local Support = require('MoreBuildings/kinds/Support')

require 'ISUI/ISInventoryPaneContextMenu'

local ConstructionClient = {
  materialStateVersion = 0,
  characterStateVersion = 0,
}

local SELECTED_RESOURCE_POLL_MS = 1000
local CURSOR_REFRESH_INTERVAL_MS = 250
local CONTAINER_SOURCE_POLL_MS = 500
local ITEM_STATE_POLL_MS = 500
local availabilitySnapshots = {}
local materialSnapshots = {}
local previewSprites = {}

function ConstructionClient.isBuildCheatEnabled(player)
  return player ~= nil and player:isBuildCheat()
end

function ConstructionClient.isBuildRestricted(player)
  return not ConstructionClient.isBuildCheatEnabled(player)
    and ConstructionService.isBuildRestricted(player)
end

function ConstructionClient.canPerform(logic, player)
  return ConstructionClient.isBuildCheatEnabled(player) or logic:canPerformCurrentRecipe()
end

local function createBuildLogic(player)
  local logic = BuildLogic.new(player, nil, nil)
  logic:setManualSelectInputs(false)
  return logic
end

local function getMaterialSnapshot(player)
  local snapshot = materialSnapshots[player]
  if snapshot == nil then
    snapshot = {
      containers = nil,
      itemStateGeneration = 0,
      itemStates = {},
      materialVersion = -1,
      nextItemStatePoll = 0,
      nextSourcePoll = 0,
      revision = 0,
    }
    materialSnapshots[player] = snapshot
  end
  return snapshot
end

local function fluidState(fluidContainer)
  if fluidContainer == nil then
    return nil
  end

  local sample = fluidContainer:createFluidSample()
  local values = { tostring(sample:getAmount()) }
  for index = 0, sample:size() - 1 do
    values[#values + 1] = sample:getFluid(index):getFluidTypeString()
    values[#values + 1] = tostring(sample:getAmount() * sample:getPercentage(index))
  end
  sample:release()
  return table.concat(values, ':')
end

local function updateItemStates(snapshot, containers)
  snapshot.itemStateGeneration = snapshot.itemStateGeneration + 1
  local generation = snapshot.itemStateGeneration
  local states = snapshot.itemStates
  local changed = false

  for containerIndex = 0, containers:size() - 1 do
    local items = containers:get(containerIndex):getItems()
    for itemIndex = 0, items:size() - 1 do
      local item = items:get(itemIndex)
      local uses = item:getCurrentUsesFloat()
      local count = item:getCount()
      local condition = item:getCondition()
      local fluid = fluidState(item:getFluidContainer())
      local state = states[item]
      if state == nil then
        state = {}
        states[item] = state
        changed = true
      elseif state.uses ~= uses or state.count ~= count or state.condition ~= condition or state.fluid ~= fluid then
        changed = true
      end
      state.uses = uses
      state.count = count
      state.condition = condition
      state.fluid = fluid
      state.generation = generation
    end
  end

  for item, state in pairs(states) do
    if state.generation ~= generation then
      states[item] = nil
      changed = true
    end
  end
  return changed
end

local function sameContainers(first, second)
  if first == nil or second == nil or first:size() ~= second:size() then
    return false
  end
  for index = 0, first:size() - 1 do
    if first:get(index) ~= second:get(index) then
      return false
    end
  end
  return true
end

local function refreshMaterialSnapshot(player, force)
  local snapshot = getMaterialSnapshot(player)
  local now = getTimestampMs()
  local materialChanged = snapshot.materialVersion ~= ConstructionClient.materialStateVersion
  local pollSources = force or materialChanged or now >= snapshot.nextSourcePoll
  local containers = snapshot.containers
  local sourcesChanged = false

  if pollSources then
    containers = ISInventoryPaneContextMenu.getContainers(player)
    sourcesChanged = not sameContainers(snapshot.containers, containers)
    snapshot.nextSourcePoll = now + CONTAINER_SOURCE_POLL_MS
  end
  local itemStateChanged = false
  if containers and (force or materialChanged or sourcesChanged or now >= snapshot.nextItemStatePoll) then
    itemStateChanged = updateItemStates(snapshot, containers)
    snapshot.nextItemStatePoll = now + ITEM_STATE_POLL_MS
  end
  local changed = force or materialChanged or sourcesChanged or itemStateChanged

  if changed then
    snapshot.containers = containers
    snapshot.materialVersion = ConstructionClient.materialStateVersion
    snapshot.revision = snapshot.revision + 1
  end
  return snapshot, changed
end

local function previewSprite(spriteName)
  local sprite = previewSprites[spriteName]
  if sprite == nil then
    sprite = IsoSprite.new()
    sprite:LoadSingleTexture(spriteName)
    previewSprites[spriteName] = sprite
  end
  return sprite
end

local function getAvailabilitySnapshot(player)
  local snapshot = availabilitySnapshots[player]
  if snapshot == nil then
    snapshot = {
      availability = {},
      availabilityLogic = createBuildLogic(player),
      availabilityRevision = 0,
      characterStateVersion = -1,
      logic = createBuildLogic(player),
      materialInputCounts = {},
      materialInputCountsDefinitionId = nil,
      nextSelectedResourcePoll = 0,
    }
    availabilitySnapshots[player] = snapshot
  end
  return snapshot
end

local function getMaterialInputCounts(recipe, containers, player)
  local counts = {}
  local reservedItems = {}
  local items = CraftRecipeManager.getAllItemsFromContainers(containers, ArrayList.new())

  for inputIndex = 0, recipe:getInputs():size() - 1 do
    local input = recipe:getInputs():get(inputIndex)
    if input:getResourceType() == ResourceType.Item then
      local count = 0
      local maxAmount = input:getIntMaxAmount()
      for itemIndex = 0, items:size() - 1 do
        local item = items:get(itemIndex)
        if not reservedItems[item] and CraftRecipeManager.isItemValidForInputScript(input, item, player) then
          reservedItems[item] = true
          count = count + (input:isItemCount() and 1 or item:getCurrentUses())
          if count >= maxAmount then
            break
          end
        end
      end
      counts[input] = count
    end
  end
  return counts
end

local function invalidateAvailability(snapshot, player, materialSnapshot)
  snapshot.availability = {}
  -- CachedRecipeInfo only detects item identity changes. A fresh list logic is
  -- required for changed uses, fluid amounts and character skills.
  snapshot.availabilityLogic = createBuildLogic(player)
  snapshot.availabilityLogic:setContainers(materialSnapshot.containers)
  snapshot.availabilityLogic:updateFloorContainer()
end

local function ensureDefinitionAvailability(snapshot, player, definitionId)
  if snapshot.availability[definitionId] ~= nil then
    return
  end
  if ConstructionClient.isBuildCheatEnabled(player) then
    snapshot.availability[definitionId] = true
    return
  end

  local recipe = ConstructionService.getRecipe(definitionId)
  snapshot.availability[definitionId] = snapshot.availabilityLogic:getCachedRecipeInfo(recipe):isAvailable()
end

local function renderFloorGrid(cursor, definition, kind, footprint, x, y, z, square, context, canPerform)
  local floorCursorSprite = cursor:getFloorCursorSprite()
  local colorGood = getCore():getGoodHighlitedColor()
  local colorBad = getCore():getBadHighlitedColor()
  cursor:getSprite()
  local origin = square or getCell():getGridSquare(x, y, z)
  local permitted = origin ~= nil
    and ConstructionService.isPlacementPermitted(kind, definition, cursor, origin, context.player)
  local placementValid = permitted and kind.isValid(cursor, origin, context)
  local allTilesValid = permitted and canPerform
  local tileValidity = {}

  for index, offset in ipairs(footprint) do
    local target = getCell():getGridSquare(x + offset.x, y + offset.y, z)
    local valid = target ~= nil and permitted and canPerform
    if valid and kind.isPreviewTileValid then
      valid = kind.isPreviewTileValid(cursor, origin, offset, context)
    elseif valid and not placementValid then
      valid = false
    end
    tileValidity[index] = valid
    allTilesValid = allTilesValid and valid
    local color = valid and colorGood or colorBad
    floorCursorSprite:RenderGhostTileColor(x + offset.x, y + offset.y, z, color:getR(), color:getG(), color:getB(), 0.8)
  end
  return canPerform and placementValid and allTilesValid, tileValidity
end

local function renderGhostSprite(spriteName, x, y, z, valid)
  local sprite = previewSprite(spriteName)
  if valid then
    sprite:RenderGhostTile(x, y, z)
  else
    sprite:RenderGhostTileRed(x, y, z)
  end
end

local function renderTableTopPreview(cursor, x, y, z, square, valid)
  local spriteName = cursor:getSprite()
  local sprite = previewSprite(spriteName)
  local r, g, b = 0.65, 0.2, 0.2
  if valid then
    r, g, b = 1, 1, 1
  end
  local props = NativePlacement.getMoveableProps(spriteName)
  local offset = square and props:getTotalTableHeight(square) or 0
  if props.surface and props.surfaceIsOffset then
    offset = offset - props.surface
  end
  sprite:RenderGhostTileColor(x, y, z, 0, offset * Core.getTileScale(), r, g, b, 0.6)
end

local function renderObjectPreview(cursor, definition, footprint, x, y, z, square, valid, tileValidity)
  local data = definition.placement.data
  local moveableProps = NativePlacement.getMoveableProps(cursor:getSprite())
  if definition.placement.kind == 'morebuilds:table-decoration'
    or data.tableTop == true
    or (moveableProps and moveableProps.isTableTop) then
    renderTableTopPreview(cursor, x, y, z, square, valid)
    return
  end

  local spriteName = cursor:getSprite()
  local primaryValid = valid
  for index, part in ipairs(footprint) do
    if part.x == 0 and part.y == 0 then
      primaryValid = tileValidity and tileValidity[index] or valid
      break
    end
  end
  local sharedSprite = getSprite(spriteName)
  if square and sharedSprite and sharedSprite:getProperties():has('IsStackable') then
    local props = NativePlacement.getMoveableProps(spriteName)
    local offset = props:getTotalTableHeight(square)
    local r, g, b = 0.65, 0.2, 0.2
    if primaryValid then
      r, g, b = 1, 1, 1
    end
    previewSprite(spriteName):RenderGhostTileColor(x, y, z, 0, offset * Core.getTileScale(), r, g, b, 0.6)
  else
    renderGhostSprite(spriteName, x, y, z, primaryValid)
  end
  for index, part in ipairs(footprint) do
    if part.sprite and (part.x ~= 0 or part.y ~= 0) then
      renderGhostSprite(part.sprite, x + part.x, y + part.y, z, tileValidity and tileValidity[index] or valid)
    end
  end
end

function ConstructionClient.refreshLogic(logic, player, containers)
  logic:setContainers(containers or ISInventoryPaneContextMenu.getContainers(player))
  logic:updateFloorContainer()
  logic:refresh()
  return ConstructionClient.canPerform(logic, player)
end

function ConstructionClient.invalidateMaterialState()
  ConstructionClient.materialStateVersion = ConstructionClient.materialStateVersion + 1
end

function ConstructionClient.invalidateCharacterState()
  ConstructionClient.characterStateVersion = ConstructionClient.characterStateVersion + 1
end

function ConstructionClient.captureCursorMaterialState()
  return { materialRevision = -1, nextRefreshAt = 0 }
end

function ConstructionClient.refreshCursorLogic(logic, player, state)
  local materialSnapshot = refreshMaterialSnapshot(player, false)
  local now = getTimestampMs()
  if state.materialRevision ~= materialSnapshot.revision or now >= state.nextRefreshAt then
    state.materialRevision = materialSnapshot.revision
    state.nextRefreshAt = now + CURSOR_REFRESH_INTERVAL_MS
    return ConstructionClient.refreshLogic(logic, player, materialSnapshot.containers)
  end
  return ConstructionClient.canPerform(logic, player)
end

function ConstructionClient.refreshAvailability(player, selectedDefinitionId, force)
  local snapshot = getAvailabilitySnapshot(player)
  local materialSnapshot, materialChanged = refreshMaterialSnapshot(player, force)
  local characterChanged = snapshot.characterStateVersion ~= ConstructionClient.characterStateVersion
    or snapshot.buildCheat ~= ConstructionClient.isBuildCheatEnabled(player)
  local refreshed = materialChanged or characterChanged

  if refreshed then
    snapshot.characterStateVersion = ConstructionClient.characterStateVersion
    snapshot.buildCheat = ConstructionClient.isBuildCheatEnabled(player)
    snapshot.logic:setContainers(materialSnapshot.containers)
    invalidateAvailability(snapshot, player, materialSnapshot)
    snapshot.availabilityRevision = snapshot.availabilityRevision + 1
  end

  local now = getTimestampMs()
  local selectedDefinitionChanged = snapshot.selectedDefinitionId ~= selectedDefinitionId
  if selectedDefinitionId and (refreshed or selectedDefinitionChanged or now >= snapshot.nextSelectedResourcePoll) then
    local selectedRecipe = ConstructionService.getRecipe(selectedDefinitionId)
    if selectedDefinitionChanged and not refreshed then
      -- updateFloorContainer only restores nearby floor items after a recipe change.
      snapshot.logic:setContainers(materialSnapshot.containers)
    end
    snapshot.logic:setRecipe(selectedRecipe)
    snapshot.logic:updateFloorContainer()
    snapshot.logic:refresh()
    snapshot.availability[selectedDefinitionId] = ConstructionClient.canPerform(snapshot.logic, player)
    snapshot.selectedDefinitionId = selectedDefinitionId
    snapshot.nextSelectedResourcePoll = now + SELECTED_RESOURCE_POLL_MS
  end

  if selectedDefinitionId and (materialChanged or snapshot.materialInputCountsDefinitionId ~= selectedDefinitionId) then
    local selectedRecipe = ConstructionService.getRecipe(selectedDefinitionId)
    snapshot.materialInputCounts = getMaterialInputCounts(selectedRecipe, materialSnapshot.containers, player)
    snapshot.materialInputCountsDefinitionId = selectedDefinitionId
  end

  return snapshot.availability, snapshot.logic, snapshot.materialInputCounts, refreshed, snapshot.availabilityRevision, characterChanged
end

function ConstructionClient.ensureAvailability(player, definitionIds, firstIndex, lastIndex)
  local snapshot = getAvailabilitySnapshot(player)
  firstIndex = math.max(1, firstIndex)
  lastIndex = math.min(#definitionIds, lastIndex)
  for index = firstIndex, lastIndex do
    ensureDefinitionAvailability(snapshot, player, definitionIds[index])
  end
  return snapshot.availability
end

function ConstructionClient.getPreviewParts(definition)
  local kind = assert(
    RegistrationCoordinator.getInternalPlacementKind(definition.placement.kind),
    'unknown MoreBuilds placement kind: ' .. definition.id .. '.placement.kind=' .. definition.placement.kind
  )
  local footprint = kind.footprint(definition, { nSprite = 1, north = false })
  local parts = {}
  for index, part in ipairs(footprint) do
    parts[index] = {
      sprite = part.sprite or definition.previewSprite,
      x = part.x,
      y = part.y,
    }
  end
  return parts
end

function ConstructionClient.initializeCursor(cursor, definitionId, player)
  local definition = assert(
    RegistrationCoordinator.getInternalDefinition(definitionId),
    'unknown MoreBuilds definition: ' .. tostring(definitionId)
  )
  ConstructionService.configureCursor(cursor, definition, player, getText(definition.nameKey))
  cursor.maxTime = ConstructionService.getRecipe(definitionId):getTime()
  cursor.buildPanelLogic = ConstructionService.createLogicWithContainers(
    player,
    definitionId,
    ISInventoryPaneContextMenu.getContainers(player)
  )
  cursor.materialState = ConstructionClient.captureCursorMaterialState()
end

function ConstructionClient.isCursorValid(cursor, square, player)
  cursor:getSprite()
  if not ConstructionService.isCursorPlacementValid(cursor, square, player) then
    return false
  end
  return ConstructionClient.refreshCursorLogic(cursor.buildPanelLogic, player, cursor.materialState)
end

function ConstructionClient.renderCursorPreview(cursor, x, y, z, square, player)
  local definition = cursor.definition
  local kind = cursor.placementKind
  local context = ConstructionService.makeContext(definition, kind, cursor, player)
  local footprint = kind.footprint(definition, cursor)
  local canPerform = ConstructionClient.refreshCursorLogic(cursor.buildPanelLogic, player, cursor.materialState)
  local valid, tileValidity = renderFloorGrid(cursor, definition, kind, footprint, x, y, z, square, context, canPerform)
  return renderObjectPreview(cursor, definition, footprint, x, y, z, square, valid, tileValidity)
end

function ConstructionClient.completeCursorAction(cursor)
  cursor.buildPanelLogic:stopCraftAction()
  ConstructionClient.invalidateMaterialState()
  cursor.materialState = ConstructionClient.captureCursorMaterialState()
end

Events.OnContainerUpdate.Add(ConstructionClient.invalidateMaterialState)
Events.LevelPerk.Add(ConstructionClient.invalidateCharacterState)
Events.RefreshCheats.Add(ConstructionClient.invalidateCharacterState)
local function resetPlayerState()
  availabilitySnapshots = {}
  materialSnapshots = {}
  ConstructionClient.materialStateVersion = 0
  ConstructionClient.characterStateVersion = 0
end
Events.OnGameStart.Add(resetPlayerState)
Events.OnDisconnect.Add(resetPlayerState)

return ConstructionClient
