local Bootstrap = require('MoreBuildings/Bootstrap')
local MoreBuilds = require('MoreBuildings/API')
local ConstructionClient = require('MoreBuildings/ConstructionClient')
local MaterialSources = require('MoreBuildings/internal/MaterialSources')
local ConstructionService = require('MoreBuildings/internal/ConstructionService')
local RegistrationCoordinator = require('MoreBuildings/internal/RegistrationCoordinator')
local RegistryClient = require('MoreBuildings/RegistryClient')
local UI = require('MoreBuildings/MoreBuilds_UI')

require('MoreBuildings/SalvageClient')
require('MoreBuildings/DestroyActionCompatibility')

require 'keyBinding'
local KEYBIND_CATEGORY = '[MoreBuilds]'
local KEYBIND_OPEN_UI = 'MoreBuilds_OpenBuildUI'
local DEFINITION_KEY = 'MoreBuildsDefinitionId'

local MoreBuild = {}
local BuildObjectClass
local BuildEntityClass

function MoreBuild.startBuild(definitionId, playerIndex)
  local player = getSpecificPlayer(playerIndex)
  if not RegistryClient.isCompatible(playerIndex) then
    RegistryClient.request(player)
    return false
  end
  if ConstructionClient.isBuildRestricted(player) then
    return false
  end

  local definition = MoreBuilds.getDefinition(definitionId)
  if definition == nil then
    return false
  end
  local cursor
  if definition.placement.kind == 'morebuilds:entity' then
    if BuildEntityClass == nil then
      BuildEntityClass = require('BuildingObjects/ISMoreBuildEntity')
    end
    local containers = MaterialSources.getAccessibleContainers(player)
    local logic = ConstructionService.createLogicWithContainers(player, definitionId, containers)
    cursor = BuildEntityClass:new(player, definitionId, 1, containers, logic)
  else
    if BuildObjectClass == nil then
      BuildObjectClass = require('BuildingObjects/ISMoreBuildObject')
    end
    cursor = BuildObjectClass:new(player, definitionId, 1)
  end
  cursor.player = playerIndex
  if not ConstructionClient.canPerform(cursor.buildPanelLogic, player) then
    return false
  end
  getCell():setDrag(cursor, playerIndex)
  return true
end

function MoreBuild.openBuildWindow(playerIndex)
  RegistryClient.request(getSpecificPlayer(playerIndex))
  return UI.open(playerIndex, MoreBuild.startBuild)
end

function MoreBuild.registerKeybind()
  table.insert(keyBinding, { value = KEYBIND_CATEGORY })
  table.insert(keyBinding, { value = KEYBIND_OPEN_UI, key = Keyboard.KEY_B, ctrl = true })
end

function MoreBuild.handleOpenBuildWindowKeybind(key)
  if not getCore():isKey(KEYBIND_OPEN_UI, key) then
    return
  end
  if UI.isVisible(0) then
    UI.close(0)
    return
  end
  if getCore():getGameMode() == 'LastStand' then
    return
  end

  local player = getSpecificPlayer(0)
  if player == nil or player:getVehicle() or ConstructionClient.isBuildRestricted(player) then
    return
  end

  MoreBuild.openBuildWindow(0)
end

local function localizeLightSwitchOption(context)
  local lightSwitch = ISWorldObjectContextMenu.fetchVars.lightSwitch
  if lightSwitch == nil then
    return
  end

  local definitionId = lightSwitch:getModData()[DEFINITION_KEY]
  local definition = definitionId and RegistrationCoordinator.getInternalDefinition(definitionId)
  if definition == nil or definition.placement.kind ~= 'morebuilds:light' then
    return
  end

  local option = context:getOptionFromName(lightSwitch:getTileName())
  if option then
    option.name = getText(definition.nameKey)
  end
end

function MoreBuild.handleFillWorldObjectContextMenu(playerIndex, context, worldobjects, test)
  if getCore():getGameMode() == 'LastStand' then
    return
  end
  if test then
    return true
  end

  localizeLightSwitchOption(context)

  local player = getSpecificPlayer(playerIndex)
  if player:getVehicle() or ConstructionClient.isBuildRestricted(player) then
    return
  end

  context:addOption(getText('ContextMenu_MoreBuild_OpenUI'), playerIndex, MoreBuild.openBuildWindow)
end

Events.OnFillWorldObjectContextMenu.Add(MoreBuild.handleFillWorldObjectContextMenu)
Events.OnGameBoot.Add(MoreBuild.registerKeybind)
Events.OnKeyPressed.Add(MoreBuild.handleOpenBuildWindowKeybind)

return MoreBuild
