require 'BuildingObjects/ISBuildIsoEntity'

local EntityScriptRegistry = require('MoreBuildings/internal/EntityScriptRegistry')
local RegistrationCoordinator = require('MoreBuildings/internal/RegistrationCoordinator')
local ConstructionService = require('MoreBuildings/internal/ConstructionService')
local MaterialSources = require('MoreBuildings/internal/MaterialSources')
local ConstructionClient
if not isServer() then
  ConstructionClient = require('MoreBuildings/ConstructionClient')
end

ISMoreBuildEntity = ISBuildIsoEntity:derive('ISMoreBuildEntity')

local function getDefinition(definitionId)
  local definition = RegistrationCoordinator.getInternalDefinition(definitionId)
  assert(definition ~= nil and definition.placement.kind == 'morebuilds:entity',
    'unknown MoreBuilds entity definition: ' .. tostring(definitionId))
  assert(RegistrationCoordinator.isDefinitionEnabled(definitionId),
    'disabled MoreBuilds entity definition: ' .. tostring(definitionId))
  return definition
end

function ISMoreBuildEntity:isValid(square)
  if not RegistrationCoordinator.isDefinitionEnabled(self.definitionId) then
    return false
  end
  if not isServer() and self.buildPanelLogic then
    self.blockBuild = not ConstructionClient.refreshTargetLogic(self, self.character, square)
  end
  return ISBuildIsoEntity.isValid(self, square)
end

function ISMoreBuildEntity:tryBuild(x, y, z)
  local action = ISBuildIsoEntity.tryBuild(self, x, y, z)
  if action and ConstructionClient then
    ConstructionClient.guardTimedAction(action, self, self.character)
  end
  return action
end

function ISMoreBuildEntity:create(x, y, z, north, sprite)
  if isServer() then
    local RegistryGuard = require('MoreBuildings/RegistryGuard')
    if ConstructionService.isBuildRestricted(self.character) or not RegistryGuard.isCompatible(self.character) then
      return false
    end
    if not self.character:isBuildCheat() then
      self.buildPanelLogic:setContainers(MaterialSources.getAccessibleContainers(self.character))
      self.buildPanelLogic:updateFloorContainer()
      self.buildPanelLogic:refresh()
      if not self.buildPanelLogic:canPerformCurrentRecipe() then
        return false
      end
    end
  end
  return ISBuildIsoEntity.create(self, x, y, z, north, sprite)
end

function ISMoreBuildEntity:new(character, definitionId, nSprite, containers, logic)
  local definition = getDefinition(definitionId)
  local descriptor = EntityScriptRegistry.requireBuildable(definition)
  local object = ISBuildIsoEntity.new(self, character, descriptor.objectInfo, nSprite, containers, logic)
  object.definitionId = definitionId
  object.moreBuildsEntityScript = descriptor.scriptName
  if ConstructionClient then
    ConstructionClient.initializeTargetMaterialLogic(object, character, object.buildPanelLogic:getRecipe())
  end
  return object
end

return ISMoreBuildEntity
