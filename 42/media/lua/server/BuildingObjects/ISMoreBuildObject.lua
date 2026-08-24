require 'BuildingObjects/ISBuildingObject'

local ConstructionClient
local ConstructionAuthority

if not isServer() then
  ConstructionClient = require('MoreBuildings/ConstructionClient')
end
if not isClient() then
  ConstructionAuthority = require('MoreBuildings/ConstructionAuthority')
end

ISMoreBuildObject = ISBuildingObject:derive('ISMoreBuildObject')

local function getPlayer(cursor)
  if isServer() then
    return cursor.player
  end
  return cursor.character
end

function ISMoreBuildObject:isValid(square)
  local player = getPlayer(self)
  if ConstructionClient then
    return ConstructionClient.isCursorValid(self, square, player)
  end
  return ConstructionAuthority.isCursorPlacementValid(self, player, square)
end

function ISMoreBuildObject:render(x, y, z, square)
  if ConstructionClient then
    ConstructionClient.renderCursorPreview(self, x, y, z, square, getPlayer(self))
  end
end

function ISMoreBuildObject:create(x, y, z)
  if ConstructionAuthority then
    return ConstructionAuthority.create(self, getPlayer(self), x, y, z)
  end
  return false
end

function ISMoreBuildObject:onActionComplete()
  if ConstructionClient then
    ConstructionClient.completeCursorAction(self)
  end
end

function ISMoreBuildObject:onTimedActionStart(action)
  ISBuildingObject.onTimedActionStart(self, action)

  local recipe = self.buildPanelLogic and self.buildPanelLogic:getRecipe() or nil
  local actionScript = recipe and recipe:getTimedActionScript() or nil
  if actionScript == nil then
    return
  end

  action:setActionAnim(actionScript:getActionAnim())
  if actionScript:getAnimVarKey() then
    action:setAnimVariable(actionScript:getAnimVarKey(), actionScript:getAnimVarVal())
  end
  action:setOverrideHandModels(
    self.buildPanelLogic:getModelHandOne(),
    self.buildPanelLogic:getModelHandTwo()
  )
end

function ISMoreBuildObject:tryBuild(x, y, z)
  local square = getCell():getGridSquare(x, y, z)
  if not self:isValid(square) then
    return nil
  end
  local action = ISBuildingObject.tryBuild(self, x, y, z)
  local kind = self.placementKind
  if action and kind and kind.timedActionOnIsValid then
    action.onIsValid = kind.timedActionOnIsValid(self.definition)
  end
  if action and ConstructionClient then
    ConstructionClient.guardTimedAction(action, self, self.character)
  end
  return action
end

function ISMoreBuildObject:new(character, definitionId, nSprite, mannequinPose)
  local object = {}
  setmetatable(object, self)
  self.__index = self
  object:init()
  object.character = character
  object.definitionId = definitionId
  object.nSprite = nSprite
  object.mannequinPose = mannequinPose
  if ConstructionClient then
    ConstructionClient.initializeCursor(object, definitionId, character)
  end
  return object
end

return ISMoreBuildObject
