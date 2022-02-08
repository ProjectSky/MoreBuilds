--
-- Created by IntelliJ IDEA.
-- User: ProjectSky
-- Date: 2017/7/11
-- Time: 13:10
-- Project Zomboid More Builds Mod
--

-- pull global functions to local
local instanceof = instanceof
local getSpecificPlayer = getSpecificPlayer
local pairs = pairs
local split = string.split
local getItemNameFromFullType = getItemNameFromFullType
local PerkFactory = PerkFactory
local getMoveableDisplayName = Translator.getMoveableDisplayName
local getSprite = getSprite
local getBestTypeEvalRecurse = getBestTypeEvalRecurse
local getItemCountFromTypeRecurse = getItemCountFromTypeRecurse
local addOption = addOption
local addSubMenu = addSubMenu
local getNew = getNew
local getText = getText

local MoreBuild = {}
MoreBuild.NAME = 'More Builds'
MoreBuild.AUTHOR = 'ProjectSky, SiderisAnon'
MoreBuild.VERSION = '1.1.5'

print('Mod Loaded: ' .. MoreBuild.NAME .. ' by ' .. MoreBuild.AUTHOR .. ' (v' .. MoreBuild.VERSION .. ')')

MoreBuild.neededMaterials = {}
MoreBuild.neededTools = {}
MoreBuild.toolsList = {}
MoreBuild.playerSkills = {}
MoreBuild.textSkillsRed = {}
MoreBuild.textSkillsGreen = {}
MoreBuild.playerCanPlaster = false
MoreBuild.textTooltipHeader = ' <RGB:2,2,2> <LINE> <LINE>' .. getText('Tooltip_craft_Needs') .. ' : <LINE> '
MoreBuild.textCanRotate = '<LINE> <RGB:1,1,1>' .. getText('Tooltip_craft_pressToRotate', Keyboard.getKeyName(getCore():getKey('Rotate building')))
MoreBuild.textPlasterRed = '<RGB:1,0,0> <LINE> <LINE>' .. getText('Tooltip_PlasterRed_Description')
MoreBuild.textPlasterGreen = '<RGB:1,1,1> <LINE> <LINE>' .. getText('Tooltip_PlasterGreen_Description')
MoreBuild.textPlasterNever = '<RGB:1,0,0> <LINE> <LINE>' .. getText('Tooltip_PlasterNever_Description')

MoreBuild.textWallDescription = getText('Tooltip_Wall_Description')
MoreBuild.textPillarDescription = getText('Tooltip_Pillar_Description')
MoreBuild.textDoorFrameDescription = getText('Tooltip_DoorFrame_Description')
MoreBuild.textWindowFrameDescription = getText('Tooltip_WindowFrame_Description')
MoreBuild.textFenceDescription = getText('Tooltip_Fence_Description')
MoreBuild.textFencePostDescription = getText('Tooltip_FencePost_Description')
MoreBuild.textDoorGenericDescription = getText('Tooltip_craft_woodenDoorDesc')
MoreBuild.textDoorIndustrial = getText('Tooltip_DoorIndustrial_Description')
MoreBuild.textDoorExterior = getText('Tooltip_DoorExterior_Description')
MoreBuild.textStairsDescription = getText('Tooltip_craft_stairsDesc')
MoreBuild.textFloorDescription = getText('Tooltip_Floor_Description')
MoreBuild.textBarElementDescription = getText('Tooltip_BarElement_Description')
MoreBuild.textBarCornerDescription = getText('Tooltip_BarCorner_Description')
MoreBuild.textTrashCanDescription = getText('Tooltip_TrashCan_Description')
MoreBuild.textLightPoleDescription = getText('Tooltip_LightPole_Description')
MoreBuild.textSmallTableDescription = getText('Tooltip_SmallTable_Description')
MoreBuild.textLargeTableDescription = getText('Tooltip_LargeTable_Description')
MoreBuild.textCouchFrontDescription = getText('Tooltip_CouchFront_Description')
MoreBuild.textCouchRearDescription = getText('Tooltip_CouchRear_Description')
MoreBuild.textDresserDescription = getText('Tooltip_Dresser_Description')
MoreBuild.textBedDescription = getText('Tooltip_Bed_Description')
MoreBuild.textFlowerBedDescription = getText('Tooltip_FlowerBed_Description')

MoreBuild.skillLevel = {
  simpleObject = 1,
  waterwellObject = 7,
  simpleDecoration = 1,
  landscaping = 1,
  lighting = 4,
  simpleContainer = 3,
  complexContainer = 5,
  advancedContainer = 7,
  simpleFurniture = 3,
  basicContainer = 1,
  basicFurniture = 1,
  moderateFurniture = 2,
  counterFurniture = 3,
  complexFurniture = 4,
  logObject = 0,
  floorObject = 1,
  wallObject = 2,
  doorObject = 3,
  garageDoorObject = 6,
  stairsObject = 6,
  stoneArchitecture = 5,
  metalArchitecture = 5,
  architecture = 5,
  complexArchitecture = 5,
  nearlyimpossible = 5,
  barbecueObject = 4,
  fridgeObject = 3,
  lightingObject = 2,
  generatorObject = 3,
  windowsObject = 2,
}

MoreBuild.healthLevel = {
  stoneWall = 300,
  metalWall = 700,
  metalStairs = 400,
  woodContainer = 200,
  stoneContainer = 250,
  metalContainer = 350,
  wallDecoration = 50,
  woodenFence = 100,
  metalDoor = 700
}

MoreBuild.getMoveableDisplayName = function(sprite)
  local props = getSprite(sprite):getProperties()
  if props:Is('CustomName') then
    local name = props:Val('CustomName')
    if props:Is('GroupName') then
      name = props:Val('GroupName') .. ' ' .. name
    end
    return getMoveableDisplayName(name)
  end
  return false
end

MoreBuild.doBuildMenu = function(player, context, worldobjects, test)
  if getCore():getGameMode() == 'LastStand' then
    return
  end

  if test and ISWorldObjectContextMenu.Test then
    return true
  end

  local playerObj = getSpecificPlayer(player)
  if playerObj:getVehicle() then
    return
  end

  if MoreBuild.haveAToolToBuild(player) then

    MoreBuild.buildSkillsList(player)

    if MoreBuild.playerSkills["Woodwork"] > 7 or ISBuildMenu.cheat then
      MoreBuild.playerCanPlaster = true
    else
      MoreBuild.playerCanPlaster = false
    end

    local _firstTierMenu = context:addOption(getText('ContextMenu_MoreBuild'), worldobjects, nil)
    local _secondTierMenu = ISContextMenu:getNew(context)
    context:addSubMenu(_firstTierMenu, _secondTierMenu)

    local _architectureOption = _secondTierMenu:addOption(getText('ContextMenu_Builds_Menu'), worldobjects, nil)
    local _architectureThirdTierMenu = _secondTierMenu:getNew(_secondTierMenu)
    context:addSubMenu(_architectureOption, _architectureThirdTierMenu)

    local _wallsOption = _architectureThirdTierMenu:addOption(getText('ContextMenu_Wall_Menu'), worldobjects, nil)
    local _wallsSubMenu = _architectureThirdTierMenu:getNew(_architectureThirdTierMenu)

    context:addSubMenu(_wallsOption, _wallsSubMenu)
    MoreBuild.wallStylesMenuBuilder(_wallsSubMenu, player, context, worldobjects)

    local _doorsOption = _architectureThirdTierMenu:addOption(getText('ContextMenu_Door'), worldobjects, nil)
    local _doorsSubMenu = _architectureThirdTierMenu:getNew(_architectureThirdTierMenu)

    context:addSubMenu(_doorsOption, _doorsSubMenu)
    MoreBuild.doorsMenuBuilder(_doorsSubMenu, player, context, worldobjects)

    local _WindowsOption = _architectureThirdTierMenu:addOption(getText('ContextMenu_Windows_Menu'), worldobjects, nil)
    local _WindowsSubMenu = _architectureThirdTierMenu:getNew(_architectureThirdTierMenu)

    context:addSubMenu(_WindowsOption, _WindowsSubMenu)
    MoreBuild.WindowsMenuBuilder(_WindowsSubMenu, player, context, worldobjects)

    local _HighMetalFenceOption = _architectureThirdTierMenu:addOption(getText('ContextMenu_HighMetal_Fence'), worldobjects, nil)
    local _HighMetalFenceSubMenu = _architectureThirdTierMenu:getNew(_architectureThirdTierMenu)

    context:addSubMenu(_HighMetalFenceOption, _HighMetalFenceSubMenu)
    MoreBuild.highMetalFenceMenuBuilder(_HighMetalFenceSubMenu, player, context, worldobjects)

    local _moreFencesOption = _architectureThirdTierMenu:addOption(getText('ContextMenu_Fences_Menu'), worldobjects, nil)
    local _moreFencesSubMenu = _architectureThirdTierMenu:getNew(_architectureThirdTierMenu)

    context:addSubMenu(_moreFencesOption, _moreFencesSubMenu)
    MoreBuild.moreFencesMenuBuilder(_moreFencesSubMenu, player)

    local _moreFencePostsOption = _architectureThirdTierMenu:addOption(getText('ContextMenu_FencePosts_Menu'), worldobjects, nil)
    local _moreFencePostsSubMenu = _architectureThirdTierMenu:getNew(_architectureThirdTierMenu)

    context:addSubMenu(_moreFencePostsOption, _moreFencePostsSubMenu)
    MoreBuild.moreFencePostsMenuBuilder(_moreFencePostsSubMenu, player)

    local _stairsOption = _architectureThirdTierMenu:addOption(getText('ContextMenu_Stairs'), worldobjects, nil)
    local _stairsSubMenu = _architectureThirdTierMenu:getNew(_architectureThirdTierMenu)

    context:addSubMenu(_stairsOption, _stairsSubMenu)
    MoreBuild.stairsMenuBuilder(_stairsSubMenu, player)

    local _floorsOption = _architectureThirdTierMenu:addOption(getText('ContextMenu_Floor'), worldobjects, nil)
    local _floorsSubMenu = _architectureThirdTierMenu:getNew(_architectureThirdTierMenu)

    context:addSubMenu(_floorsOption, _floorsSubMenu)
    MoreBuild.floorsMenuBuilder(_floorsSubMenu, player, context, worldobjects)

    local _furnitureOption = _secondTierMenu:addOption(getText('ContextMenu_Furniture'), worldobjects, nil)
    local _furnitureThirdTierMenu = _secondTierMenu:getNew(_secondTierMenu)
    context:addSubMenu(_furnitureOption, _furnitureThirdTierMenu)

    local _smallTablesOption = _furnitureThirdTierMenu:addOption(getText('ContextMenu_SmallTable_Menu'), worldobjects, nil)
    local _smallTablesSubMenu = _furnitureThirdTierMenu:getNew(_furnitureThirdTierMenu)

    context:addSubMenu(_smallTablesOption, _smallTablesSubMenu)
    MoreBuild.smallTablesMenuBuilder(_smallTablesSubMenu, player)

    local _largeTablesOption = _furnitureThirdTierMenu:addOption(getText('ContextMenu_LargeTable_Menu'), worldobjects, nil)
    local _largeTablesSubMenu = _furnitureThirdTierMenu:getNew(_furnitureThirdTierMenu)

    context:addSubMenu(_largeTablesOption, _largeTablesSubMenu)
    MoreBuild.largeTablesMenuBuilder(_largeTablesSubMenu, player)

    local _chairsOption = _furnitureThirdTierMenu:addOption(getText('ContextMenu_Chairs_Menu'), worldobjects, nil)
    local _chairsSubMenu = _furnitureThirdTierMenu:getNew(_furnitureThirdTierMenu)

    context:addSubMenu(_chairsOption, _chairsSubMenu)
    MoreBuild.chairsMenuBuilder(_chairsSubMenu, player, context, worldobjects)

    local _couchesOption = _furnitureThirdTierMenu:addOption(getText('ContextMenu_Couches_Menu'), worldobjects, nil)
    local _couchesSubMenu = _furnitureThirdTierMenu:getNew(_furnitureThirdTierMenu)

    context:addSubMenu(_couchesOption, _couchesSubMenu)
    MoreBuild.couchesMenuBuilder(_couchesSubMenu, player, context, worldobjects)

    local _bedsOption = _furnitureThirdTierMenu:addOption(getText('ContextMenu_Bed'), worldobjects, nil)
    local _bedsSubMenu = _furnitureThirdTierMenu:getNew(_furnitureThirdTierMenu)

    context:addSubMenu(_bedsOption, _bedsSubMenu)
    MoreBuild.bedsMenuBuilder(_bedsSubMenu, player)

    local _containersOption = _secondTierMenu:addOption(getText('ContextMenu_Container_Menu'), worldobjects, nil)
    local _containersThirdTierMenu = _secondTierMenu:getNew(_secondTierMenu)
    context:addSubMenu(_containersOption, _containersThirdTierMenu)

    local _dressersOption = _containersThirdTierMenu:addOption(getText('ContextMenu_Dressers_Menu'), worldobjects, nil)
    local _dressersSubMenu = _containersThirdTierMenu:getNew(_containersThirdTierMenu)

    context:addSubMenu(_dressersOption, _dressersSubMenu)
    MoreBuild.dressersMenuBuilder(_dressersSubMenu, player)

    local _bookshelfOption = _containersThirdTierMenu:addOption(getText('ContextMenu_BookShelf_Menu'), worldobjects, nil)
    local _bookshelfSubMenu = _containersThirdTierMenu:getNew(_containersThirdTierMenu)

    context:addSubMenu(_bookshelfOption, _bookshelfSubMenu)
    MoreBuild.BookShelfMenuBuilder(_bookshelfSubMenu, player)

    local _counterElementsOption = _containersThirdTierMenu:addOption(getText 'ContextMenu_Cabinets_Menu', worldobjects, nil)
    local _counterElementsSubMenu = _containersThirdTierMenu:getNew(_containersThirdTierMenu)

    context:addSubMenu(_counterElementsOption, _counterElementsSubMenu)
    MoreBuild.counterElementsMenuBuilder(_counterElementsSubMenu, player, context, worldobjects)

    local _otherFurnitureOption = _containersThirdTierMenu:addOption(getText 'ContextMenu_OtherFurniture_Menu', worldobjects, nil)
    local _otherFurnitureSubMenu = _containersThirdTierMenu:getNew(_containersThirdTierMenu)

    context:addSubMenu(_otherFurnitureOption, _otherFurnitureSubMenu)
    MoreBuild.otherFurnitureMenuBuilder(_otherFurnitureSubMenu, player)

    local _metalLockersOption = _containersThirdTierMenu:addOption(getText 'ContextMenu_MetalLocker_Menu', worldobjects, nil)
    local _metalLockersSubMenu = _containersThirdTierMenu:getNew(_containersThirdTierMenu)

    context:addSubMenu(_metalLockersOption, _metalLockersSubMenu)
    MoreBuild.metalLockersMenuBuilder(_metalLockersSubMenu, player)

    local _cratesOption = _containersThirdTierMenu:addOption(getText 'ContextMenu_Crates_Menu', worldobjects, nil)
    local _cratesSubMenu = _containersThirdTierMenu:getNew(_containersThirdTierMenu)

    context:addSubMenu(_cratesOption, _cratesSubMenu)
    MoreBuild.cratesMenuBuilder(_cratesSubMenu, player)

    local _improvisedOption = _containersThirdTierMenu:addOption(getText 'ContextMenu_Improvised_Menu', worldobjects, nil)
    local _improvisedSubMenu = _containersThirdTierMenu:getNew(_containersThirdTierMenu)

    context:addSubMenu(_improvisedOption, _improvisedSubMenu)
    MoreBuild.improvisedMenuBuilder(_improvisedSubMenu, player)

    local _trashOption = _containersThirdTierMenu:addOption(getText 'ContextMenu_Recycling_Bin', worldobjects, nil)
    local _trashSubMenu = _containersThirdTierMenu:getNew(_containersThirdTierMenu)

    context:addSubMenu(_trashOption, _trashSubMenu)
    MoreBuild.trashMenuBuilder(_trashSubMenu, player)

    local _decorationOption = _secondTierMenu:addOption(getText 'ContextMenu_Decoration_Menu', worldobjects, nil)
    local _decorationThirdTierMenu = _secondTierMenu:getNew(_secondTierMenu)
    context:addSubMenu(_decorationOption, _decorationThirdTierMenu)

    local _roadwayOption = _decorationThirdTierMenu:addOption(getText 'ContextMenu_Roadway_Menu', worldobjects, nil)
    local _roadwaySubMenu = _decorationThirdTierMenu:getNew(_decorationThirdTierMenu)

    context:addSubMenu(_roadwayOption, _roadwaySubMenu)
    MoreBuild.roadwayMenuBuilder(_roadwaySubMenu, player)

    local _signsOption = _decorationThirdTierMenu:addOption(getText 'ContextMenu_Sign_Menu', worldobjects, nil)
    local _signsSubMenu = _decorationThirdTierMenu:getNew(_decorationThirdTierMenu)

    context:addSubMenu(_signsOption, _signsSubMenu)
    MoreBuild.signsMenuBuilder(_signsSubMenu, player)

    local _wallHangingsInsideOption = _decorationThirdTierMenu:addOption(getText 'ContextMenu_Decoration_Menu', worldobjects, nil)
    local _wallHangingsInsideSubMenu = _decorationThirdTierMenu:getNew(_decorationThirdTierMenu)

    context:addSubMenu(_wallHangingsInsideOption, _wallHangingsInsideSubMenu)
    MoreBuild.wallDecorationsMenuBuilder(_wallHangingsInsideSubMenu, player, context, worldobjects)

    local _otherOption = _secondTierMenu:addOption(getText 'ContextMenu_Other_Menu', worldobjects, nil)
    local _otherThirdTierMenu = _secondTierMenu:getNew(_secondTierMenu)
    context:addSubMenu(_otherOption, _otherThirdTierMenu)

    local _flowerBedsOption = _otherThirdTierMenu:addOption(getText 'ContextMenu_FlowerBed_Menu', worldobjects, nil)
    local _flowerBedsSubMenu = _otherThirdTierMenu:getNew(_otherThirdTierMenu)

    context:addSubMenu(_flowerBedsOption, _flowerBedsSubMenu)
    MoreBuild.flowerBedsMenuBuilder(_flowerBedsSubMenu, player, context, worldobjects)

    local _lightPostOption = _otherThirdTierMenu:addOption(getText 'ContextMenu_LightPost_Menu', worldobjects, nil)
    local _lightPostSubMenu = _otherThirdTierMenu:getNew(_otherThirdTierMenu)

    context:addSubMenu(_lightPostOption, _lightPostSubMenu)
    MoreBuild.lightPostMenuBuilder(_lightPostSubMenu, player)

    local _missingPostsOption = _otherThirdTierMenu:addOption(getText 'ContextMenu_Other_Menu', worldobjects, nil)
    local _missingPostsSubMenu = _otherThirdTierMenu:getNew(_otherThirdTierMenu)

    context:addSubMenu(_missingPostsOption, _missingPostsSubMenu)
    MoreBuild.missingPostsMenuBuilder(_missingPostsSubMenu, player)

    local _SurvivalOption = _secondTierMenu:addOption(getText 'ContextMenu_Survival_Menu', worldobjects, nil)
    local _SurvivalThirdTierMenu = _secondTierMenu:getNew(_secondTierMenu)

    context:addSubMenu(_SurvivalOption, _SurvivalThirdTierMenu)
    MoreBuild.SurvivalPostsMenuBuilder(_SurvivalThirdTierMenu, player)

    --MoreBuild.doWaterWellInfo(player, context, worldobjects)
  end
end

local function predicateNotBroken(item)
	return not item:isBroken()
end

-- TODO: 添加多工具支持
MoreBuild.haveAToolToBuild = function(player)
  local inv = getSpecificPlayer(player):getInventory()
  
  MoreBuild.toolsList['Hammer'] = {"Base.Hammer", "Base.HammerStone", "Base.BallPeenHammer", "Base.WoodenMallet", "Base.ClubHammer"}
  MoreBuild.toolsList['Screwdriver'] = {"Base.Screwdriver"}
  MoreBuild.toolsList['HandShovel'] = {"farming.HandShovel"}
  MoreBuild.toolsList['Saw'] = {"Base.Saw"}
  MoreBuild.toolsList['Spade'] = {"Base.Shovel"}

  local havaTools = nil

  for _, type in pairs (MoreBuild.toolsList['Hammer']) do
    havaTools = inv:containsTypeEvalRecurse(type, predicateNotBroken)
    if havaTools then
      havaTools = true
      break
    end
  end

  return havaTools or ISBuildMenu.cheat
end

MoreBuild.equipToolPrimary = function(object, player, tool)
  local inv = getSpecificPlayer(player):getInventory()
  for _, type in pairs (MoreBuild.toolsList[tool]) do
    tools = inv:getBestTypeEvalRecurse(type, predicateNotBroken)
    if tools then
      ISInventoryPaneContextMenu.equipWeapon(tools, true, false, player)
      object.noNeedHammer = true
      break
    end
  end
end

-- 未使用
MoreBuild.equipToolSecondary = function(object, player, tool)
  local inv = getSpecificPlayer(player):getInventory()
  for _, type in pairs (MoreBuild.toolsList[tool]) do
    tools = inv:getBestTypeEvalRecurse(type, predicateNotBroken)
    if tools then
      ISInventoryPaneContextMenu.equipWeapon(tools, false, false, player)
      break
    end
  end
end

MoreBuild.buildSkillsList = function(player)
  local perks = PerkFactory.PerkList
  for i = 0, perks:size() - 1 do
    local perkID = perks:get(i):getId()
    local perkType = perks:get(i):getType()
    MoreBuild.playerSkills[perkID] = getSpecificPlayer(player):getPerkLevel(perks:get(i))
    MoreBuild.textSkillsRed[perkID] = ' <RGB:1,0,0>' .. PerkFactory.getPerkName(perkType) .. ' ' .. MoreBuild.playerSkills[perkID] .. '/'
    MoreBuild.textSkillsGreen[perkID] = ' <RGB:1,1,1>' .. PerkFactory.getPerkName(perkType) .. ' '
  end
end

-- ISBuildMenu.countMaterial性能过低，如果玩家库存中物品过多会卡游戏主线程，不使用
MoreBuild.tooltipCheckForMaterial = function(player, material, amount, tooltip)
  local inv = getSpecificPlayer(player):getInventory()
  local type = split(material, '\\.')[2]
  local _thisItemCount = 0
  local groundItem = ISBuildMenu.materialOnGround
  if amount > 0 then
    _thisItemCount = inv:getItemCountFromTypeRecurse(material) -- 统计玩家库存中指定类名的物品数量，含背包

    -- why #groundItem 0?
    for k, v in pairs(groundItem) do
      if k == type then
        _thisItemCount = _thisItemCount + v
      end
    end

    if _thisItemCount < amount then
      tooltip.description = tooltip.description .. ' <RGB:1,0,0>' .. getItemNameFromFullType(material) .. ' ' .. _thisItemCount .. '/' .. amount .. ' <LINE>'
      return false
    else
      tooltip.description = tooltip.description .. ' <RGB:1,1,1>' .. getItemNameFromFullType(material) .. ' ' .. _thisItemCount .. '/' .. amount .. ' <LINE>'
      return true
    end
  end
  return true
end

MoreBuild.getBestTools = function(player, tool)
  local tools = nil
  local toolList = MoreBuild.toolsList[tool]
  local inv = getSpecificPlayer(player):getInventory()
  for _, type in pairs (toolList) do
    tools = inv:getBestTypeEvalRecurse(type, predicateNotBroken)
    if tools then
      return tools;
    end
  end
end

-- TODO: 支持背包内工具
MoreBuild.tooltipCheckForTool = function(player, tool, tooltip)
  local tools = MoreBuild.getBestTools(player, tool)
  if tools then
    tooltip.description = tooltip.description .. ' <RGB:1,1,1>' .. getItemNameFromFullType(tools:getFullType()) .. ' <LINE>'
    return true
  else
    for _, type in pairs (MoreBuild.toolsList[tool]) do
      tooltip.description = tooltip.description .. ' <RGB:1,0,0>' .. getItemNameFromFullType(type) .. ' <LINE>'
      return false
    end
  end
end

--- 检查是否满足建造条件
-- @param skills table: 技能等级需求表
-- @param option ISContextMenu: ISContextMenu
-- @return Boolean: 如果满足建造条件则返回true否则返回false
MoreBuild.canBuildObject = function(skills, option, player)
  local _tooltip = ISToolTip:new()
  _tooltip:initialise()
  _tooltip:setVisible(false)
  option.toolTip = _tooltip

  local _canBuildResult = true

  _tooltip.description = MoreBuild.textTooltipHeader

  local _currentResult = true

  for _, _currentMaterial in pairs(MoreBuild.neededMaterials) do
    if _currentMaterial['Material'] and _currentMaterial['Amount'] then
      _currentResult = MoreBuild.tooltipCheckForMaterial(player, _currentMaterial['Material'], _currentMaterial['Amount'], _tooltip)
    else
      _tooltip.description = _tooltip.description .. ' <RGB:1,0,0> Error in required material definition. <LINE>'
      _canBuildResult = false
    end

    if not _currentResult then
      _canBuildResult = false
    end
  end

  for _, _currentTool in pairs(MoreBuild.neededTools) do
    _currentResult = MoreBuild.tooltipCheckForTool(player, _currentTool, _tooltip)

    if not _currentResult then
      _canBuildResult = false
    end
  end

  -- 已重写旧版技能需求代码，现在可支持游戏中所有技能
  for skill, level in pairs (skills) do
    if (MoreBuild.playerSkills[skill] < level) then
      _tooltip.description = _tooltip.description .. MoreBuild.textSkillsRed[skill]
      _canBuildResult = false
    else
      _tooltip.description = _tooltip.description .. MoreBuild.textSkillsGreen[skill]
    end
    _tooltip.description = _tooltip.description .. level .. ' <LINE>'
  end

  if not _canBuildResult and not ISBuildMenu.cheat then
    option.onSelect = nil
    option.notAvailable = true
  end
  return _tooltip
end

--- 获取MoreBuild实例
-- @return table: MoreBuild Instance
function getMoreBuildInstance()
  return MoreBuild
end

Events.OnFillWorldObjectContextMenu.Add(MoreBuild.doBuildMenu)