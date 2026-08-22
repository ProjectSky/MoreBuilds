require 'BuildingObjects/ISBuildIsoEntity'
if not isServer() then
  require 'ISUI/ISInventoryPaneContextMenu'
end

local EntityScriptRegistry = require('MoreBuildings/internal/EntityScriptRegistry')
local RegistrationCoordinator = require('MoreBuildings/internal/RegistrationCoordinator')
local ConstructionService = require('MoreBuildings/internal/ConstructionService')

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
    self.buildPanelLogic:setContainers(ISInventoryPaneContextMenu.getContainers(self.character))
    self.buildPanelLogic:updateFloorContainer()
    self.buildPanelLogic:refresh()
    self.blockBuild = not (self.character:isBuildCheat() or self.buildPanelLogic:canPerformCurrentRecipe())
  end
  return ISBuildIsoEntity.isValid(self, square)
end

function ISMoreBuildEntity:create(x, y, z, north, sprite)
  if isServer() then
    local RegistryGuard = require('MoreBuildings/RegistryGuard')
    if ConstructionService.isBuildRestricted(self.character) or not RegistryGuard.isCompatible(self.character) then
      return false
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
  return object
end

return ISMoreBuildEntity
