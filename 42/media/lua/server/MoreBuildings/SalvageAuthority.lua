if isClient() then
  return {}
end

local RegistrationCoordinator = require('MoreBuildings/internal/RegistrationCoordinator')
local ConstructionService = require('MoreBuildings/internal/ConstructionService')

local SalvageAuthority = {
  installed = false,
}

local DEFINITION_KEY = 'MoreBuildsDefinitionId'
local GROUP_KEY = 'MoreBuildsSalvageGroupId'
local MATERIALS_KEY = 'MoreBuildsSalvageMaterials'
local TRANSFER_TOKEN_KEY = 'MoreBuildsTransferToken'
local MODULE = 'MoreBuilds'

local movingObjects = {}
local activeTransfers = {}
local pendingGroupCleanup = {}
local pendingGroupIds = {}
local nextTransferId = 0

local function copyMaterials(materials)
  local copy = {}
  for itemType, count in pairs(materials or {}) do
    copy[itemType] = count
  end
  return copy
end

local function fillRecipeMaterialFallback(materials, definition)
  local recipe = ConstructionService.getRecipe(definition.id)
  for index = 0, recipe:getInputs():size() - 1 do
    local input = recipe:getInputs():get(index)
    if input:getResourceType() == ResourceType.Item and input:isRecordInput() and not input:isKeep() then
      local items = input:getItems()
      if items:size() == 1 then
        local itemType = items:get(0)
        if not string.find(itemType, '.', 1, true) then
          itemType = 'Base.' .. itemType
        end
        materials[itemType] = (materials[itemType] or 0) + input:getIntAmount()
      end
    end
  end
end

local function hasMaterials(materials)
  for _ in pairs(materials) do
    return true
  end
  return false
end

local function getRecipeMaterialLimits(definition)
  local limits = {}
  local recipe = ConstructionService.getRecipe(definition.id)
  for index = 0, recipe:getInputs():size() - 1 do
    local input = recipe:getInputs():get(index)
    if input:getResourceType() == ResourceType.Item and input:isRecordInput() and not input:isKeep() then
      local items = input:getPossibleInputItems()
      for itemIndex = 0, items:size() - 1 do
        local itemType = items:get(itemIndex):getFullName()
        limits[itemType] = (limits[itemType] or 0) + input:getIntAmount()
      end
    end
  end
  return limits
end

local function recordConsumedMaterials(definition, recordedItems)
  local limits = getRecipeMaterialLimits(definition)
  local materials = {}
  for index = 0, recordedItems:size() - 1 do
    local itemType = recordedItems:get(index):getFullType()
    local limit = limits[itemType]
    if limit and (materials[itemType] or 0) < limit then
      materials[itemType] = (materials[itemType] or 0) + 1
    end
  end
  return materials
end

local function clearTransferToken(modData)
  if modData.movableData then
    modData.movableData[TRANSFER_TOKEN_KEY] = nil
  end
end

local function clearManagedFields(modData)
  modData[DEFINITION_KEY] = nil
  modData[GROUP_KEY] = nil
  modData[MATERIALS_KEY] = nil
  clearTransferToken(modData)
end

local function setTransferToken(modData, token)
  modData.movableData = modData.movableData or {}
  modData.movableData[TRANSFER_TOKEN_KEY] = token
end

local function transferTokenFromItem(item)
  local modData = item:getModData()
  if modData.movableData and modData.movableData[TRANSFER_TOKEN_KEY] then
    return modData.movableData[TRANSFER_TOKEN_KEY]
  end
  local savedObjectData = modData.modData
  if savedObjectData and savedObjectData.movableData then
    return savedObjectData.movableData[TRANSFER_TOKEN_KEY]
  end
end

local function sanitizeTransferItem(item)
  local modData = item:getModData()
  clearManagedFields(modData)
  if modData.modData then
    clearManagedFields(modData.modData)
  end
end

local function groupIdForObjects(definitionId, objects)
  local anchor = objects[1]
  local square = anchor and anchor:getSquare()
  if square == nil then
    return nil
  end
  return 'g:' .. definitionId .. ':' .. tostring(square:getX()) .. ':' .. tostring(square:getY()) .. ':' .. tostring(square:getZ())
end

local function nativeAdditionalObjects(object)
  local objects = buildUtil.getStairObjects(object, true)
  if #objects == 0 then
    objects = buildUtil.getGarageDoorObjects(object)
  end
  if #objects == 0 then
    objects = buildUtil.getDoubleDoorObjects(object)
  end
  return objects
end

local function objectsWithGroupId(objects, groupId)
  local matching = {}
  for _, object in ipairs(objects) do
    if object and object:getModData()[GROUP_KEY] == groupId then
      matching[#matching + 1] = object
    end
  end
  return matching
end

local function nearbyGroupObjects(object, groupId)
  local square = object:getSquare()
  if square == nil then
    return {}
  end

  local objects = {}
  local seen = {}
  for x = square:getX() - 4, square:getX() + 4 do
    for y = square:getY() - 4, square:getY() + 4 do
      local candidate = getCell():getGridSquare(x, y, square:getZ())
      if candidate then
        for index = 0, candidate:getObjects():size() - 1 do
          local candidateObject = candidate:getObjects():get(index)
          if candidateObject:getModData()[GROUP_KEY] == groupId and not seen[candidateObject] then
            seen[candidateObject] = true
            objects[#objects + 1] = candidateObject
          end
        end
      end
    end
  end
  return objects
end

local function groupObjectsFor(object, groupId)
  local nativeObjects = nativeAdditionalObjects(object)
  if #nativeObjects > 0 then
    local matchingNativeObjects = objectsWithGroupId(nativeObjects, groupId)
    if #matchingNativeObjects > 0 then
      return matchingNativeObjects
    end
  end

  local sprite = object:getSprite()
  local props = sprite and ISMoveableSpriteProps.new(sprite) or nil
  if props and props.isMultiSprite then
    local grid = props:getSpriteGridInfo(object:getSquare(), true)
    if grid then
      local gridObjects = {}
      for _, member in ipairs(grid) do
        gridObjects[#gridObjects + 1] = member.object
      end
      local matchingGridObjects = objectsWithGroupId(gridObjects, groupId)
      if #matchingGridObjects > 0 then
        return matchingGridObjects
      end
    end
  end

  local nearbyObjects = nearbyGroupObjects(object, groupId)
  if #nearbyObjects > 0 then
    return nearbyObjects
  end
  return { object }
end

local function getGroupForObject(object)
  if object == nil then
    return nil
  end
  local modData = object:getModData()
  local definitionId = modData[DEFINITION_KEY]
  local groupId = modData[GROUP_KEY]
  if definitionId == nil or groupId == nil then
    return nil
  end

  local objects = groupObjectsFor(object, groupId)
  local materials
  for _, groupObject in ipairs(objects) do
    local objectMaterials = groupObject:getModData()[MATERIALS_KEY]
    if objectMaterials then
      materials = copyMaterials(objectMaterials)
      break
    end
  end
  return {
    id = groupId,
    definitionId = definitionId,
    materials = materials or {},
    objects = objects,
  }
end

local function applyObjectMetadata(object, group, isMaterialCarrier)
  local modData = object:getModData()
  clearManagedFields(modData)
  modData[DEFINITION_KEY] = group.definitionId
  modData[GROUP_KEY] = group.id
  if isMaterialCarrier then
    modData[MATERIALS_KEY] = copyMaterials(group.materials)
  end
  object:transmitModData()
end

local function updateWorldGroup(group, objects)
  group.id = groupIdForObjects(group.definitionId, objects)
  group.objects = objects
  for index, object in ipairs(objects) do
    applyObjectMetadata(object, group, index == 1)
  end
end

local function resolveGroupState(group)
  if group == nil then
    return nil
  end
  local definition = RegistrationCoordinator.getInternalDefinition(group.definitionId)
  if definition == nil then
    return nil
  end
  local kind = RegistrationCoordinator.getInternalPlacementKind(definition.placement.kind)
  return definition, kind
end

local function getDismantleSkill(definition, player)
  local recipe = ConstructionService.getRecipe(definition.id)
  local requiredSkill = recipe:getRequiredSkill(0)
  local skill = requiredSkill and requiredSkill:getPerk()
  if skill == nil then
    return nil, 100
  end
  return skill, math.min(100, 10 + player:getPerkLevel(skill) * 10)
end

local function giveDismantleXp(player, skill)
  if skill and player:getPerkLevel(skill) < SandboxVars.LevelForDismantleXPCutoff then
    addXp(player, skill, 5)
  end
end

local function claimDismantleMaterials(group, dropSquare, skillChance)
  local added = 0
  local chancePerItem = 80 * math.min(100, math.max(0, skillChance)) / 100
  for itemType, count in pairs(group.materials) do
    for _ = 1, count do
      if dropSquare and ZombRandFloat(0, 101) < chancePerItem then
        dropSquare:AddWorldInventoryItem(itemType, 0, 0, 0)
        added = added + 1
      end
    end
  end
  return added
end

local function claimDestroyedMaterials(group, dropSquare)
  local added = 0
  for itemType, count in pairs(group.materials) do
    for _ = 1, count do
      if dropSquare and ZombRand(2) ~= 0 then
        dropSquare:AddWorldInventoryItem(itemType, 0, 0, 0)
        added = added + 1
      end
    end
  end
  return added
end

local function notifyDestroyed(group, destroyedObject, player, definition, kind)
  if kind.onDestroyed then
    kind.onDestroyed(group.objects, {
      definition = definition,
      destroyedObject = destroyedObject,
      player = player,
    })
  end
end

local function clearObjectMetadata(object, transmit)
  clearManagedFields(object:getModData())
  if transmit then
    object:transmitModData()
  end
end

local function removeObject(object)
  local square = object:getSquare()
  if square == nil then
    return
  end
  if object.dumpContentsInSquare then
    object:dumpContentsInSquare()
  end
  clearObjectMetadata(object, false)
  square:transmitRemoveItemFromSquare(object)
end

local function removeGroupObjects(group, ignoredObject)
  for _, object in ipairs(group.objects) do
    if object ~= ignoredObject then
      removeObject(object)
    end
  end
end

local function clearRemainingGroupMetadata(group, ignoredObject)
  for _, object in ipairs(group.objects) do
    if object ~= ignoredObject then
      clearObjectMetadata(object, true)
    end
  end
end

local function queueDestroyedGroup(group, kind, ignoredObject)
  if pendingGroupIds[group.id] then
    return
  end
  pendingGroupIds[group.id] = true
  pendingGroupCleanup[#pendingGroupCleanup + 1] = {
    group = group,
    ignoredObject = ignoredObject,
    removeRemaining = kind.salvage.groupRemoval == 'remaining-parts',
  }
end

local function processPendingGroupCleanup()
  if #pendingGroupCleanup == 0 then
    return
  end
  local pending = pendingGroupCleanup
  pendingGroupCleanup = {}
  for _, cleanup in ipairs(pending) do
    if cleanup.removeRemaining then
      removeGroupObjects(cleanup.group, cleanup.ignoredObject)
    else
      clearRemainingGroupMetadata(cleanup.group, cleanup.ignoredObject)
    end
    pendingGroupIds[cleanup.group.id] = nil
  end
end

local function destroyWorldGroup(object, player)
  local group = getGroupForObject(object)
  local definition, kind = resolveGroupState(group)
  if definition == nil or kind == nil or pendingGroupIds[group.id] then
    return false
  end
  if definition.salvagePolicy == 'recipe-inputs' and not hasMaterials(group.materials) then
    fillRecipeMaterialFallback(group.materials, definition)
  end
  claimDestroyedMaterials(group, object:getSquare())
  notifyDestroyed(group, object, player, definition, kind)
  queueDestroyedGroup(group, kind, object)
  return true
end

local function dismantleManaged(self, player)
  local object = self.object
  local group = getGroupForObject(object)
  local definition, kind = resolveGroupState(group)
  if definition == nil or kind == nil then
    return false
  end
  local scrapResult = self:canScrapObject(player)
  if scrapResult == nil or not scrapResult.canScrap then
    return false
  end

  local skill, skillChance = getDismantleSkill(definition, player)
  local added = claimDismantleMaterials(group, object:getSquare(), skillChance)
  notifyDestroyed(group, object, player, definition, kind)
  if kind.salvage.groupRemoval == 'preserve' then
    local nativeObjects = nativeAdditionalObjects(object)
    if #nativeObjects > 0 then
      for _, nativeObject in ipairs(nativeObjects) do
        removeObject(nativeObject)
      end
    else
      removeObject(object)
    end
    clearRemainingGroupMetadata(group, nil)
  else
    removeGroupObjects(group, nil)
  end
  if player then
    if added > 0 then
      self:playScrapSuccessSound(player)
    end
    giveDismantleXp(player, skill)
    if player:getPrimaryHandType() == 'BlowTorch' then
      player:getPrimaryHandItem():UseAndSync()
    end
    self:scrapHaloNoteCheck(player, added)
  end
  return true
end

local function nextTransferToken()
  nextTransferId = nextTransferId + 1
  return 't:' .. tostring(nextTransferId)
end

local function createTransfer(group, character)
  local token = nextTransferToken()
  activeTransfers[token] = {
    definitionId = group.definitionId,
    materials = copyMaterials(group.materials),
    owner = character:getUsername(),
  }
  return token
end

local function restoreItemTransferToken(item, token)
  setTransferToken(item:getModData(), token)
end

local function inventoryItemWithTransferToken(inventory, token)
  local items = inventory:getItems()
  for index = 0, items:size() - 1 do
    local item = items:get(index)
    if transferTokenFromItem(item) == token then
      return item
    end
  end
end

local function squareItemWithTransferToken(square, token)
  if square == nil then
    return nil
  end
  local worldObjects = square:getWorldObjects()
  for index = 0, worldObjects:size() - 1 do
    local item = worldObjects:get(index):getItem()
    if transferTokenFromItem(item) == token then
      return item
    end
  end
end

local function findTransferItem(character, objects, token)
  local item = inventoryItemWithTransferToken(character:getInventory(), token)
  if item then
    return item
  end
  for _, object in ipairs(objects) do
    item = squareItemWithTransferToken(object:getSquare(), token)
    if item then
      return item
    end
  end
end

local function snapshotInventory(inventory)
  local snapshot = {}
  local items = inventory:getItems()
  for index = 0, items:size() - 1 do
    snapshot[items:get(index)] = true
  end
  return snapshot
end

local function tagNewInventoryItem(inventory, previousItems, token)
  local items = inventory:getItems()
  for index = 0, items:size() - 1 do
    local item = items:get(index)
    if not previousItems[item] then
      setTransferToken(item:getModData(), token)
      return item
    end
  end
end

local function pickupAnchor(self, square, groupObjects)
  if not self.isMultiSprite then
    return self.object or groupObjects[1]
  end
  local grid = self:getSpriteGridInfo(square, true)
  local spriteGrid = self.sprite and self.sprite:getSpriteGrid()
  local anchorSprite = spriteGrid and spriteGrid:getAnchorSprite()
  if grid and anchorSprite then
    for _, member in ipairs(grid) do
      if member.sprite == anchorSprite then
        return member.object
      end
    end
  end
  return self.object or groupObjects[1]
end

local function restoreRemainingWorldObjects(group, originalObjects)
  local objects = {}
  for _, object in ipairs(originalObjects) do
    if object:getSquare() then
      objects[#objects + 1] = object
    end
  end
  if #objects == 0 then
    return false
  end
  updateWorldGroup(group, objects)
  return true
end

local function installPickupHook()
  local originalPickup = ISMoveableSpriteProps.pickUpMoveable
  ISMoveableSpriteProps.pickUpMoveable = function(self, character, square, createItem, forceAllow)
    local object = self.object
    if object == nil then
      object = self:findOnSquare(square, self.spriteName)
    end
    local group = getGroupForObject(object)
    if group == nil or not createItem then
      return originalPickup(self, character, square, createItem, forceAllow)
    end

    local groupObjects = group.objects
    local anchor = pickupAnchor(self, square, groupObjects)
    local token = createTransfer(group, character)
    local previousInventoryItems = snapshotInventory(character:getInventory())
    for _, groupObject in ipairs(groupObjects) do
      movingObjects[groupObject] = true
      clearManagedFields(groupObject:getModData())
      if groupObject == anchor then
        setTransferToken(groupObject:getModData(), token)
      end
    end

    local ok, result = pcall(originalPickup, self, character, square, createItem, forceAllow)
    for _, groupObject in ipairs(groupObjects) do
      movingObjects[groupObject] = nil
    end

    local transferItem = findTransferItem(character, groupObjects, token)
    if not transferItem then
      transferItem = tagNewInventoryItem(character:getInventory(), previousInventoryItems, token)
    end
    if restoreRemainingWorldObjects(group, groupObjects) then
      activeTransfers[token] = nil
      if transferItem then
        sanitizeTransferItem(transferItem)
      end
    elseif not transferItem then
      activeTransfers[token] = nil
    end

    if not ok then
      error(result)
    end
    return result
  end
end

local function selectedPlacementItems(self, character, square, originalSpriteName)
  local items = {}
  if not self.isMultiSprite then
    local item = self:findInInventory(character, originalSpriteName)
    if item then
      items[1] = item
    end
    return items
  end

  local spriteGrid = self.sprite:getSpriteGrid()
  local grid = self:getSpriteGridInfo(square, false)
  if spriteGrid == nil or grid == nil then
    return items
  end
  if self.isForceSingleItem then
    local item = self:findInInventoryMultiSprite(character, self.name .. ' (1/1)')
    if item then
      items[1] = item
    end
    return items
  end

  local maximum = spriteGrid:getSpriteCount()
  for index = 1, #grid do
    local item = self:findInInventoryMultiSprite(character, self.name .. ' (' .. index .. '/' .. maximum .. ')')
    if item then
      items[#items + 1] = item
    end
  end
  return items
end

local function placedObjects(self, square)
  local objects = {}
  if self.isMultiSprite then
    local grid = self:getSpriteGridInfo(square, true)
    if grid then
      for _, member in ipairs(grid) do
        objects[#objects + 1] = member.object
      end
    end
    return objects
  end
  local object = self:findOnSquare(square, self.spriteName)
  if object then
    objects[1] = object
  end
  return objects
end

local function installRotationHook()
  local originalRotate = ISMoveableSpriteProps.rotateMoveable
  ISMoveableSpriteProps.rotateMoveable = function(self, character, square, originalSpriteName)
    if not self.isMultiSprite then
      return originalRotate(self, character, square, originalSpriteName)
    end

    local originalProps = ISMoveableSpriteProps.new(originalSpriteName)
    local originalObject = originalProps:findOnSquare(square, originalSpriteName)
    local group = getGroupForObject(originalObject)
    if group == nil then
      return originalRotate(self, character, square, originalSpriteName)
    end

    local originalObjects = group.objects
    local originalGrid = originalProps:getSpriteGridInfo(square, true)
    local anchorSquare = originalGrid and self:findOriginalSquare(originalGrid, self.sprite) or square
    for _, object in ipairs(originalObjects) do
      movingObjects[object] = true
    end

    local ok, result = pcall(originalRotate, self, character, square, originalSpriteName)

    for _, object in ipairs(originalObjects) do
      movingObjects[object] = nil
    end
    local objects = placedObjects(self, anchorSquare)
    if #objects > 0 then
      updateWorldGroup(group, objects)
    else
      restoreRemainingWorldObjects(group, originalObjects)
    end

    if not ok then
      error(result)
    end
    return result
  end
end

local function itemWasConsumed(item)
  return item:getContainer() == nil and item:getWorldItem() == nil
end

local function indexPlacementTransfers(items)
  local itemsByToken = {}
  local tokenCount = 0
  local singleToken
  for _, item in ipairs(items) do
    local token = transferTokenFromItem(item)
    if token then
      local tokenItems = itemsByToken[token]
      if tokenItems == nil then
        tokenItems = {}
        itemsByToken[token] = tokenItems
        tokenCount = tokenCount + 1
        singleToken = token
      end
      tokenItems[#tokenItems + 1] = item
    end
    sanitizeTransferItem(item)
  end
  return itemsByToken, tokenCount, singleToken
end

local function authorizePlacementTransfer(itemsByToken, token, character)
  local transfer = activeTransfers[token]
  if transfer == nil or transfer.owner ~= character:getUsername() then
    return nil
  end
  local items = itemsByToken[token]
  if items == nil or #items ~= 1 then
    return nil
  end
  return {
    id = nil,
    definitionId = transfer.definitionId,
    materials = copyMaterials(transfer.materials),
    item = items[1],
  }
end

local function installPlacementHook()
  local originalPlace = ISMoveableSpriteProps.placeMoveable
  ISMoveableSpriteProps.placeMoveable = function(self, character, square, originalSpriteName, forceAllow)
    local items = selectedPlacementItems(self, character, square, originalSpriteName)
    local itemsByToken, tokenCount, singleToken = indexPlacementTransfers(items)
    local transfer = tokenCount == 1 and authorizePlacementTransfer(itemsByToken, singleToken, character) or nil

    local ok, result = pcall(originalPlace, self, character, square, originalSpriteName, forceAllow)

    if transfer then
      if itemWasConsumed(transfer.item) then
        local objects = placedObjects(self, square)
        if #objects > 0 then
          updateWorldGroup(transfer, objects)
        end
        activeTransfers[singleToken] = nil
      else
        restoreItemTransferToken(transfer.item, singleToken)
      end
    end
    if not ok then
      error(result)
    end
    return result
  end
end

local function installScrapHooks()
  local originalScrap = ISMoveableSpriteProps.scrapObject
  ISMoveableSpriteProps.scrapObject = function(self, character)
    if self.object and getGroupForObject(self.object) then
      return dismantleManaged(self, character)
    end
    return originalScrap(self, character)
  end

  local function hookViaCursor(prototype)
    local original = prototype.scrapObjectViaCursor
    prototype.scrapObjectViaCursor = function(self, character, square, originalSpriteName, moveCursor)
      if self.object and getGroupForObject(self.object) then
        local result = dismantleManaged(self, character)
        if moveCursor then
          moveCursor:clearCache()
        end
        return result
      end
      return original(self, character, square, originalSpriteName, moveCursor)
    end
  end

  hookViaCursor(ISMoveableSpriteProps)
  hookViaCursor(ISThumpableSpriteProps)
end

local function onObjectAboutToBeRemoved(object)
  if movingObjects[object] then
    return
  end
  destroyWorldGroup(object, nil)
end

local function onDestroyIsoThumpable(object, player)
  destroyWorldGroup(object, player)
end

local function onClientCommand(module, command, player, args)
  if module ~= MODULE or command ~= 'dismantle' then
    return
  end

  local square = args and getCell():getGridSquare(args.x, args.y, args.z)
  local index = args and args.index
  if square == nil or index == nil or index < 0 or index >= square:getObjects():size() then
    return
  end
  if square:DistToProper(player) > 2.5 then
    return
  end

  local object = square:getObjects():get(index)
  if getGroupForObject(object) == nil then
    return
  end
  dismantleManaged(ISMoveableSpriteProps.fromObject(object), player)
end

function SalvageAuthority.markCreated(objects, definition, recordedItems)
  local materials = {}
  if definition.salvagePolicy == 'recipe-inputs' and recordedItems then
    materials = recordConsumedMaterials(definition, recordedItems)
  end
  updateWorldGroup({
    definitionId = definition.id,
    materials = materials,
  }, objects)
end

function SalvageAuthority.install()
  if SalvageAuthority.installed then
    return
  end
  assert(ISMoveableSpriteProps and ISThumpableSpriteProps, 'MoreBuilds requires the native Moveable API')
  installPickupHook()
  installPlacementHook()
  installRotationHook()
  installScrapHooks()
  Events.OnClientCommand.Add(onClientCommand)
  Events.OnDestroyIsoThumpable.Add(onDestroyIsoThumpable)
  Events.OnObjectAboutToBeRemoved.Add(onObjectAboutToBeRemoved)
  Events.OnTick.Add(processPendingGroupCleanup)
  SalvageAuthority.installed = true
end

return SalvageAuthority
