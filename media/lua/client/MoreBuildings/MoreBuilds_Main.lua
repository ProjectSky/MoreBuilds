--
-- Created by IntelliJ IDEA.
-- User: ProjectSky
-- Date: 2017/7/11
-- Time: 13:10
-- Project Zomboid More Builds Mod
--

-- pull global functions to local
local getSpecificPlayer = getSpecificPlayer
local pairs = pairs
local split = string.split
local getItemNameFromFullType = getItemNameFromFullType
local PerkFactory = PerkFactory
local getMoveableDisplayName = Translator.getMoveableDisplayName
local getSprite = getSprite
local getFirstTypeEval = getFirstTypeEval
local getItemCountFromTypeRecurse = getItemCountFromTypeRecurse
local getText = getText

local MoreBuild = {}
MoreBuild.NAME = 'More Builds'
MoreBuild.AUTHOR = 'ProjectSky, SiderisAnon'
MoreBuild.VERSION = '1.1.8a'

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

--- 工具列表定义
--- 多个工具在表内添加即可 [类型] {工具1, 工具2, ...}
MoreBuild.toolsList['Hammer'] = {'Base.Hammer', 'Base.HammerStone', 'Base.BallPeenHammer', 'Base.WoodenMallet', 'Base.ClubHammer'}
MoreBuild.toolsList['Screwdriver'] = {'Base.Screwdriver'}
MoreBuild.toolsList['HandShovel'] = {'farming.HandShovel'}
MoreBuild.toolsList['Saw'] = {'Base.Saw'}
MoreBuild.toolsList['Shovel'] = {'Base.Shovel', 'Base.Shovel2'}
MoreBuild.toolsList['BlowTorch'] = {'Base.BlowTorch'}

--- 建筑技能需求定义
--- @todo: 优化结构
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

--- 建筑耐久定义
--- @todo: 优化结构
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

--- 权限等级定义
MoreBuild.AccessLevel = {
  None = 1,
  Observer = 2,
  GM = 3,
  Overseer = 4,
  Moderator = 5,
  Admin = 6
}

--- OnFillWorldObjectContextMenu回调
--- @param player number: IsoPlayer索引
--- @param context ISContextMenu: 上下文菜单实例
--- @param worldobjects table: 世界对象表
--- @param test boolean: 如果是测试附近对象则返回true, 否则返回false
--- @todo 优化性能, ISContextMenu性能过差, 经测试, 注册300+ISContextMenu实例会导致游戏主线程冻结0.24秒左右, 这是非常严重的性能问题, 需要官方解决
MoreBuild.OnFillWorldObjectContextMenu = function(player, context, worldobjects, test)
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

  if MoreBuild.checkPermission(playerObj) then return end

  local inv = playerObj:getInventory()

  if MoreBuild.haveAToolToBuild(inv) then

    MoreBuild.buildSkillsList(playerObj)

    if MoreBuild.playerSkills["Woodwork"] > 6 or ISBuildMenu.cheat then
      MoreBuild.playerCanPlaster = true
    else
      MoreBuild.playerCanPlaster = false
    end

    local _firstTierMenu = context:addOption(getText('ContextMenu_MoreBuild'))
    local _secondTierMenu = ISContextMenu:getNew(context)
    context:addSubMenu(_firstTierMenu, _secondTierMenu)

    local _architectureOption = _secondTierMenu:addOption(getText('ContextMenu_Builds_Menu'))
    local _architectureThirdTierMenu = _secondTierMenu:getNew(_secondTierMenu)
    context:addSubMenu(_architectureOption, _architectureThirdTierMenu)

    local _wallsOption = _architectureThirdTierMenu:addOption(getText('ContextMenu_Wall_Menu'))
    local _wallsSubMenu = _architectureThirdTierMenu:getNew(_architectureThirdTierMenu)

    context:addSubMenu(_wallsOption, _wallsSubMenu)
    MoreBuild.wallStylesMenuBuilder(_wallsSubMenu, player, context)

    local _doorsOption = _architectureThirdTierMenu:addOption(getText('ContextMenu_Door'))
    local _doorsSubMenu = _architectureThirdTierMenu:getNew(_architectureThirdTierMenu)

    context:addSubMenu(_doorsOption, _doorsSubMenu)
    MoreBuild.doorsMenuBuilder(_doorsSubMenu, player, context)

    local _WindowsOption = _architectureThirdTierMenu:addOption(getText('ContextMenu_Windows_Menu'))
    local _WindowsSubMenu = _architectureThirdTierMenu:getNew(_architectureThirdTierMenu)

    context:addSubMenu(_WindowsOption, _WindowsSubMenu)
    MoreBuild.WindowsMenuBuilder(_WindowsSubMenu, player, context)

    local _HighMetalFenceOption = _architectureThirdTierMenu:addOption(getText('ContextMenu_HighMetal_Fence'))
    local _HighMetalFenceSubMenu = _architectureThirdTierMenu:getNew(_architectureThirdTierMenu)

    context:addSubMenu(_HighMetalFenceOption, _HighMetalFenceSubMenu)
    MoreBuild.highMetalFenceMenuBuilder(_HighMetalFenceSubMenu, player, context)

    local _moreFencesOption = _architectureThirdTierMenu:addOption(getText('ContextMenu_Fences_Menu'))
    local _moreFencesSubMenu = _architectureThirdTierMenu:getNew(_architectureThirdTierMenu)

    context:addSubMenu(_moreFencesOption, _moreFencesSubMenu)
    MoreBuild.moreFencesMenuBuilder(_moreFencesSubMenu, player)

    local _moreFencePostsOption = _architectureThirdTierMenu:addOption(getText('ContextMenu_FencePosts_Menu'))
    local _moreFencePostsSubMenu = _architectureThirdTierMenu:getNew(_architectureThirdTierMenu)

    context:addSubMenu(_moreFencePostsOption, _moreFencePostsSubMenu)
    MoreBuild.moreFencePostsMenuBuilder(_moreFencePostsSubMenu, player)

    local _stairsOption = _architectureThirdTierMenu:addOption(getText('ContextMenu_Stairs'))
    local _stairsSubMenu = _architectureThirdTierMenu:getNew(_architectureThirdTierMenu)

    context:addSubMenu(_stairsOption, _stairsSubMenu)
    MoreBuild.stairsMenuBuilder(_stairsSubMenu, player)

    local _floorsOption = _architectureThirdTierMenu:addOption(getText('ContextMenu_Floor'))
    local _floorsSubMenu = _architectureThirdTierMenu:getNew(_architectureThirdTierMenu)

    context:addSubMenu(_floorsOption, _floorsSubMenu)
    MoreBuild.floorsMenuBuilder(_floorsSubMenu, player, context)

    local _furnitureOption = _secondTierMenu:addOption(getText('ContextMenu_Furniture'))
    local _furnitureThirdTierMenu = _secondTierMenu:getNew(_secondTierMenu)
    context:addSubMenu(_furnitureOption, _furnitureThirdTierMenu)

    local _smallTablesOption = _furnitureThirdTierMenu:addOption(getText('ContextMenu_SmallTable_Menu'))
    local _smallTablesSubMenu = _furnitureThirdTierMenu:getNew(_furnitureThirdTierMenu)

    context:addSubMenu(_smallTablesOption, _smallTablesSubMenu)
    MoreBuild.smallTablesMenuBuilder(_smallTablesSubMenu, player)

    local _largeTablesOption = _furnitureThirdTierMenu:addOption(getText('ContextMenu_LargeTable_Menu'))
    local _largeTablesSubMenu = _furnitureThirdTierMenu:getNew(_furnitureThirdTierMenu)

    context:addSubMenu(_largeTablesOption, _largeTablesSubMenu)
    MoreBuild.largeTablesMenuBuilder(_largeTablesSubMenu, player)

    local _chairsOption = _furnitureThirdTierMenu:addOption(getText('ContextMenu_Chairs_Menu'))
    local _chairsSubMenu = _furnitureThirdTierMenu:getNew(_furnitureThirdTierMenu)

    context:addSubMenu(_chairsOption, _chairsSubMenu)
    MoreBuild.chairsMenuBuilder(_chairsSubMenu, player, context)

    local _couchesOption = _furnitureThirdTierMenu:addOption(getText('ContextMenu_Couches_Menu'))
    local _couchesSubMenu = _furnitureThirdTierMenu:getNew(_furnitureThirdTierMenu)

    context:addSubMenu(_couchesOption, _couchesSubMenu)
    MoreBuild.couchesMenuBuilder(_couchesSubMenu, player, context)

    local _bedsOption = _furnitureThirdTierMenu:addOption(getText('ContextMenu_Bed'))
    local _bedsSubMenu = _furnitureThirdTierMenu:getNew(_furnitureThirdTierMenu)

    context:addSubMenu(_bedsOption, _bedsSubMenu)
    MoreBuild.bedsMenuBuilder(_bedsSubMenu, player)

    local _containersOption = _secondTierMenu:addOption(getText('ContextMenu_Container_Menu'))
    local _containersThirdTierMenu = _secondTierMenu:getNew(_secondTierMenu)
    context:addSubMenu(_containersOption, _containersThirdTierMenu)

    local _dressersOption = _containersThirdTierMenu:addOption(getText('ContextMenu_Dressers_Menu'))
    local _dressersSubMenu = _containersThirdTierMenu:getNew(_containersThirdTierMenu)

    context:addSubMenu(_dressersOption, _dressersSubMenu)
    MoreBuild.dressersMenuBuilder(_dressersSubMenu, player)

    local _bookshelfOption = _containersThirdTierMenu:addOption(getText('ContextMenu_BookShelf_Menu'))
    local _bookshelfSubMenu = _containersThirdTierMenu:getNew(_containersThirdTierMenu)

    context:addSubMenu(_bookshelfOption, _bookshelfSubMenu)
    MoreBuild.BookShelfMenuBuilder(_bookshelfSubMenu, player)

    local _counterElementsOption = _containersThirdTierMenu:addOption(getText 'ContextMenu_Cabinets_Menu')
    local _counterElementsSubMenu = _containersThirdTierMenu:getNew(_containersThirdTierMenu)

    context:addSubMenu(_counterElementsOption, _counterElementsSubMenu)
    MoreBuild.counterElementsMenuBuilder(_counterElementsSubMenu, player, context)

    local _otherFurnitureOption = _containersThirdTierMenu:addOption(getText 'ContextMenu_OtherFurniture_Menu')
    local _otherFurnitureSubMenu = _containersThirdTierMenu:getNew(_containersThirdTierMenu)

    context:addSubMenu(_otherFurnitureOption, _otherFurnitureSubMenu)
    MoreBuild.otherFurnitureMenuBuilder(_otherFurnitureSubMenu, player)

    local _metalLockersOption = _containersThirdTierMenu:addOption(getText 'ContextMenu_MetalLocker_Menu')
    local _metalLockersSubMenu = _containersThirdTierMenu:getNew(_containersThirdTierMenu)

    context:addSubMenu(_metalLockersOption, _metalLockersSubMenu)
    MoreBuild.metalLockersMenuBuilder(_metalLockersSubMenu, player)

    local _cratesOption = _containersThirdTierMenu:addOption(getText 'ContextMenu_Crates_Menu')
    local _cratesSubMenu = _containersThirdTierMenu:getNew(_containersThirdTierMenu)

    context:addSubMenu(_cratesOption, _cratesSubMenu)
    MoreBuild.cratesMenuBuilder(_cratesSubMenu, player)

    local _improvisedOption = _containersThirdTierMenu:addOption(getText 'ContextMenu_Improvised_Menu')
    local _improvisedSubMenu = _containersThirdTierMenu:getNew(_containersThirdTierMenu)

    context:addSubMenu(_improvisedOption, _improvisedSubMenu)
    MoreBuild.improvisedMenuBuilder(_improvisedSubMenu, player)

    local _trashOption = _containersThirdTierMenu:addOption(getText 'ContextMenu_Recycling_Bin')
    local _trashSubMenu = _containersThirdTierMenu:getNew(_containersThirdTierMenu)

    context:addSubMenu(_trashOption, _trashSubMenu)
    MoreBuild.trashMenuBuilder(_trashSubMenu, player)

    local _decorationOption = _secondTierMenu:addOption(getText 'ContextMenu_Decoration_Menu')
    local _decorationThirdTierMenu = _secondTierMenu:getNew(_secondTierMenu)
    context:addSubMenu(_decorationOption, _decorationThirdTierMenu)

    local _roadwayOption = _decorationThirdTierMenu:addOption(getText 'ContextMenu_Roadway_Menu')
    local _roadwaySubMenu = _decorationThirdTierMenu:getNew(_decorationThirdTierMenu)

    context:addSubMenu(_roadwayOption, _roadwaySubMenu)
    MoreBuild.roadwayMenuBuilder(_roadwaySubMenu, player)

    local _signsOption = _decorationThirdTierMenu:addOption(getText 'ContextMenu_Sign_Menu')
    local _signsSubMenu = _decorationThirdTierMenu:getNew(_decorationThirdTierMenu)

    context:addSubMenu(_signsOption, _signsSubMenu)
    MoreBuild.signsMenuBuilder(_signsSubMenu, player)

    local _wallHangingsInsideOption = _decorationThirdTierMenu:addOption(getText 'ContextMenu_Decoration_Menu')
    local _wallHangingsInsideSubMenu = _decorationThirdTierMenu:getNew(_decorationThirdTierMenu)

    context:addSubMenu(_wallHangingsInsideOption, _wallHangingsInsideSubMenu)
    MoreBuild.wallDecorationsMenuBuilder(_wallHangingsInsideSubMenu, player, context)

    local _otherOption = _secondTierMenu:addOption(getText 'ContextMenu_Other_Menu')
    local _otherThirdTierMenu = _secondTierMenu:getNew(_secondTierMenu)
    context:addSubMenu(_otherOption, _otherThirdTierMenu)

    local _flowerBedsOption = _otherThirdTierMenu:addOption(getText 'ContextMenu_FlowerBed_Menu')
    local _flowerBedsSubMenu = _otherThirdTierMenu:getNew(_otherThirdTierMenu)

    context:addSubMenu(_flowerBedsOption, _flowerBedsSubMenu)
    MoreBuild.flowerBedsMenuBuilder(_flowerBedsSubMenu, player, context)

    local _lightPostOption = _otherThirdTierMenu:addOption(getText 'ContextMenu_LightPost_Menu')
    local _lightPostSubMenu = _otherThirdTierMenu:getNew(_otherThirdTierMenu)

    context:addSubMenu(_lightPostOption, _lightPostSubMenu)
    MoreBuild.lightPostMenuBuilder(_lightPostSubMenu, player)

    local _missingPostsOption = _otherThirdTierMenu:addOption(getText 'ContextMenu_Other_Menu')
    local _missingPostsSubMenu = _otherThirdTierMenu:getNew(_otherThirdTierMenu)

    context:addSubMenu(_missingPostsOption, _missingPostsSubMenu)
    MoreBuild.missingPostsMenuBuilder(_missingPostsSubMenu, player)

    local _SurvivalOption = _secondTierMenu:addOption(getText 'ContextMenu_Survival_Menu')
    local _SurvivalThirdTierMenu = _secondTierMenu:getNew(_secondTierMenu)

    context:addSubMenu(_SurvivalOption, _SurvivalThirdTierMenu)
    MoreBuild.SurvivalMenuBuilder(_SurvivalThirdTierMenu, player)

    --MoreBuild.doWaterWellInfo(player, context, worldobjects)
  end
end

--- 检查物品是否损坏
--- @param item string: 需检查的物品名称
--- @return boolean: 如果物品未损坏返回true, 否则返回false
local function predicateNotBroken(item)
  return not item:isBroken()
end

--- 获取可移动家具本地化字符串
--- @param sprite string: Sprite名称
--- @return string: 获取的本地化字符串
MoreBuild.getMoveableDisplayName = function(sprite)
  local props = getSprite(sprite):getProperties()
  if props:Is('CustomName') then
    local name = props:Val('CustomName')
    if props:Is('GroupName') then
      name = props:Val('GroupName') .. ' ' .. name
    end
    return getMoveableDisplayName(name)
  end
end

--- 检查玩家是否拥有某些工具
--- @param inv ItemContainer: 玩家ItemContainer实例
--- @return boolean: 如果满足工具条件需求则返回true否则返回false
MoreBuild.haveAToolToBuild = function(inv)
  local havaTools = nil

  havaTools = MoreBuild.getAvailableTools(inv, 'Hammer')

  return havaTools or ISBuildMenu.cheat
end

--- 检查玩家建筑权限, 仅在多人模式中使用
--- @param player IsoPlayer: IsoPlayer实例
--- @return boolean: 如果权限符合返回true否则返回false
MoreBuild.checkPermission = function(player)
  local level = player:getAccessLevel()
  local permission = SandboxVars.MoreBuilds.BuildingPermission
  return isClient() and not ISBuildMenu.cheat and MoreBuild.AccessLevel[level] < permission
end

--- 获取玩家库存内的可用工具
--- @param inv ItemContainer: 玩家ItemContainer实例
--- @param tool string: 工具类型
--- @return InventoryItem: 获取的工具实例, 如空或已损坏返回nil
MoreBuild.getAvailableTools = function(inv, tool)
  local tools = nil
  local toolList = MoreBuild.toolsList[tool]
  for _, type in pairs (toolList) do
    tools = inv:getFirstTypeEval(type, predicateNotBroken)
    if tools then
      return tools
    end
  end
end

--- 装备主要工具
--- @param object IsoObject: IsoObject实例
--- @param player number: IsoPlayer索引
--- @param tool string: 工具类型
MoreBuild.equipToolPrimary = function(object, player, tool)
  local tools = nil
  local inv = getSpecificPlayer(player):getInventory()
  tools = MoreBuild.getAvailableTools(inv, tool)
  if tools then
    ISInventoryPaneContextMenu.equipWeapon(tools, true, false, player)
    object.noNeedHammer = true
  end
end

--- 装备次要工具
--- @param object Isoobject: Isoobject实例
--- @param player number: IsoPlayer索引
--- @param tool string: 工具类型
--- @info 未使用
MoreBuild.equipToolSecondary = function(object, player, tool)
  local tools = nil
  local inv = getSpecificPlayer(player):getInventory()
  tools = MoreBuild.getAvailableTools(inv, tool)
  if tools then
    ISInventoryPaneContextMenu.equipWeapon(tools, false, false, player)
  end
end

--- 构造技能文本
--- @param player IsoPlayer: IsoPlayer实例
MoreBuild.buildSkillsList = function(player)
  local perks = PerkFactory.PerkList
  local perkID = nil
  local perkType = nil
  for i = 0, perks:size() - 1 do
    perkID = perks:get(i):getId()
    perkType = perks:get(i):getType()
    MoreBuild.playerSkills[perkID] = player:getPerkLevel(perks:get(i))
    MoreBuild.textSkillsRed[perkID] = ' <RGB:1,0,0>' .. PerkFactory.getPerkName(perkType) .. ' ' .. MoreBuild.playerSkills[perkID] .. '/'
    MoreBuild.textSkillsGreen[perkID] = ' <RGB:1,1,1>' .. PerkFactory.getPerkName(perkType) .. ' '
  end
end

--- 检查&构造材料提示文本
--- @param inv ItemContainer: 玩家ItemContainer实例
--- @param material string: 材料类型
--- @param amount number: 需要的材料数量
--- @param tooltip ISToolTip: 工具提示实例
--- @return boolean: 如果满足检查条件则返回true否则返回false
--- @info ISBuildMenu.countMaterial性能过低, 如果玩家库存中物品过多会卡游戏主线程, 不建议使用
MoreBuild.tooltipCheckForMaterial = function(inv, material, amount, tooltip)
  local type = split(material, '\\.')[2]
  local invItemCount = 0
  local groundItem = ISBuildMenu.materialOnGround
  if amount > 0 then
    invItemCount = inv:getItemCountFromTypeRecurse(material)

    if material == "Base.Nails" then
      invItemCount = invItemCount + inv:getItemCountFromTypeRecurse("Base.NailsBox") * 100
      if groundItem["Base.NailsBox"] then
        invItemCount = invItemCount + groundItem["Base.NailsBox"] * 100
      end
    end

    -- ISBuildUtil not support boxed screws, later solve it
    --[[
    if material == "Base.Screws" then
      invItemCount = invItemCount + inv:getItemCountFromTypeRecurse("Base.ScrewsBox") * 100
      if groundItem["Base.ScrewsBox"] then
        invItemCount = invItemCount + groundItem["Base.ScrewsBox"] * 100
      end
    end
    --]]

    -- why #groundItem 0?
    for groundItemType, groundItemCount in pairs(groundItem) do
      if groundItemType == type then
        invItemCount = invItemCount + groundItemCount
      end
    end

    if invItemCount < amount then
      tooltip.description = tooltip.description .. ' <RGB:1,0,0>' .. getItemNameFromFullType(material) .. ' ' .. invItemCount .. '/' .. amount .. ' <LINE>'
      return false
    else
      tooltip.description = tooltip.description .. ' <RGB:1,1,1>' .. getItemNameFromFullType(material) .. ' ' .. invItemCount .. '/' .. amount .. ' <LINE>'
      return true
    end
  end
end

--- 检查&构造工具提示文本
--- @param inv ItemContainer: 玩家ItemContainer实例
--- @param tool string: 工具类型
--- @param tooltip ISToolTip: 工具提示实例
--- @return boolean: 如果满足检查条件则返回true否则返回false
MoreBuild.tooltipCheckForTool = function(inv, tool, tooltip)
  local tools = MoreBuild.getAvailableTools(inv, tool)
  if tools then
    tooltip.description = tooltip.description .. ' <RGB:1,1,1>' .. tools:getName() .. ' <LINE>'
    return true
  else
    for _, type in pairs (MoreBuild.toolsList[tool]) do
      tooltip.description = tooltip.description .. ' <RGB:1,0,0>' .. getItemNameFromFullType(type) .. ' <LINE>'
      return false
    end
  end
end

--- 检查是否满足建造条件
--- @param skills table: 技能等级需求表, 支持被动技能 {Woodwork = 1, Strength = 2, ...}
--- @param option ISContextMenu: 上下文菜单实例
--- @return ISToolTip: 返回工具提示实例
MoreBuild.canBuildObject = function(skills, option, player)
  local _tooltip = ISToolTip:new()
  _tooltip:initialise()
  _tooltip:setVisible(false)
  option.toolTip = _tooltip

  local inv = getSpecificPlayer(player):getInventory()

  local _canBuildResult = true

  _tooltip.description = MoreBuild.textTooltipHeader

  local _currentResult = true

  for _, _currentMaterial in pairs(MoreBuild.neededMaterials) do
    if _currentMaterial['Material'] and _currentMaterial['Amount'] then
      _currentResult = MoreBuild.tooltipCheckForMaterial(inv, _currentMaterial['Material'], _currentMaterial['Amount'], _tooltip)
    else
      _tooltip.description = _tooltip.description .. ' <RGB:1,0,0> Error in required material definition. <LINE>'
      _canBuildResult = false
    end

    if not _currentResult then
      _canBuildResult = false
    end
  end

  for _, _currentTool in pairs(MoreBuild.neededTools) do
    _currentResult = MoreBuild.tooltipCheckForTool(inv, _currentTool, _tooltip)

    if not _currentResult then
      _canBuildResult = false
    end
  end

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
--- @return table: MoreBuild table
function getMoreBuildInstance()
  return MoreBuild
end

--- 注册OnFillWorldObjectContextMenu事件
-- @callback1 player number: 调用的IsoPlayer索引
-- @callback2 context ISContextMenu: 上下文菜单实例
-- @callback3 worldobjects table: 世界对象表
-- @callback4 test Boolean: 如果是测试附近对象则返回true, 否则返回false
Events.OnFillWorldObjectContextMenu.Add(MoreBuild.OnFillWorldObjectContextMenu)