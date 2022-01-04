--
-- Created by IntelliJ IDEA.
-- User: ProjectSky
-- Date: 2017/7/11
-- Time: 13:10
-- Project Zomboid More Build Mod
--

MoreBuild = {}
MoreBuild.NAME = "More Build"
MoreBuild.AUTHOR = "ProjectSky"
MoreBuild.OriginalAUTHOR = "SiderisAnon"
MoreBuild.VERSION = "1.0.6"

print("Mod Loaded: " .. MoreBuild.NAME .. " by " .. MoreBuild.AUTHOR .. " Original AUTHOR: " .. MoreBuild.OriginalAUTHOR .. " (v" .. MoreBuild.VERSION .. ")")

MoreBuild.availableMaterialsList = {}
MoreBuild.neededMaterials = {}
MoreBuild.neededTools = {}
MoreBuild.toolsList = {}
MoreBuild.toolsText = {}
MoreBuild.playerCarpentrySkill = 0
MoreBuild.playerCanPlaster = false
MoreBuild.textTooltipHeader = " <RGB:2,2,2> <LINE> <LINE>" .. getText("Tooltip_craft_Needs") .. " : <LINE> "
MoreBuild.textCarpentryRed = ""
MoreBuild.textCarpentryGreen = ""
MoreBuild.textElectricityRed = ""
MoreBuild.textElectricityGreen = ""
MoreBuild.textCanRotate = "<LINE> <LINE> <RGB:1,1,1>" .. getText("Tooltip_tip1")
MoreBuild.textPlasterRed = "<RGB:1,0,0> <LINE> <LINE>" .. getText("Tooltip_tip2")
MoreBuild.textPlasterGreen = "<RGB:1,1,1> <LINE> <LINE>" .. getText("Tooltip_tip3")
MoreBuild.textPlasterNever = "<RGB:1,0,0> <LINE> <LINE>" .. getText("Tooltip_tip4")

MoreBuild.textWallDescription = getText("Tooltip_tip5")
MoreBuild.textPillarDescription = getText("Tooltip_tip6")
MoreBuild.textDoorFrameDescription = getText("Tooltip_tip7")
MoreBuild.textWindowFrameDescription = getText("Tooltip_tip8")
MoreBuild.textFenceDescription = getText("Tooltip_tip9")
MoreBuild.textFencePostDescription = getText("Tooltip_tip10")
MoreBuild.textDoorGeneric = getText("Tooltip_craft_woodenDoorDesc")
MoreBuild.textDoorIndustrial = getText("Tooltip_tip11")
MoreBuild.textDoorExterior = getText("Tooltip_tip12")
MoreBuild.textStairsDescription = getText("Tooltip_craft_stairsDesc")
MoreBuild.textFloorDescription = getText("Tooltip_tip13")
MoreBuild.textBarElementDescription = getText("Tooltip_tip14")
MoreBuild.textBarCornerDescription = getText("Tooltip_tip15")
MoreBuild.textTrashCanDescription = getText("Tooltip_tip16")
MoreBuild.textLightPoleDescription = getText("Tooltip_tip17")
MoreBuild.textSmallTableDescription = getText("Tooltip_tip18")
MoreBuild.textLargeTableDescription = getText("Tooltip_tip19")
MoreBuild.textCouchFrontDescription = getText("Tooltip_tip20")
MoreBuild.textCouchRearDescription = getText("Tooltip_tip21")
MoreBuild.textDresserDescription = getText("Tooltip_tip22")
MoreBuild.textBedDescription = getText("Tooltip_tip23")
MoreBuild.textFlowerBedDescription = getText("Tooltip_tip24")
ISBuildMenu.cheat = false
MoreBuild.skillLevel =
{
	simpleObject = 1,
	shuijinObject = 7,
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
	stairsObject = 6,
	stoneArchitecture = 5,
	metalArchitecture = 5,
	architecture = 5,
	complexArchitecture = 5,
	nearlyimpossible = 5,
	luzhnagObject = 1,
	shaokaojiaObject = 4,
}

MoreBuild.ElectricityskillLevel =
{
	fridge = 3,
	lighting = 2,
	none = 0,
	Generator = 3,
}

MoreBuild.healthLevel =
{
	stoneWall = 300,
	metalWall = 700,
	metalStairs = 400,
	woodContainer = 200,
	stoneContainer = 250,
	metalContainer = 350,
	wallDecoration = 50,
	WoodenFence = 100,
	TestFence = 50,
}

MoreBuild.doBuildMenu = function(player, context, worldobjects, test)
	if getCore():getGameMode() == "LastStand" then
		return
	end

	if test and ISWorldObjectContextMenu.Test then
		return true
	end

	if MoreBuild.haveAToolToBuildWithWith(player) then
		MoreBuild.playerCarpentrySkill = getSpecificPlayer(player):getPerkLevel(Perks.Woodwork)
		MoreBuild.playerelectricianSkill = getSpecificPlayer(player):getPerkLevel(Perks.Electricity)

		if MoreBuild.playerCarpentrySkill >= 8 or ISBuildMenu.cheat then
			MoreBuild.playerCanPlaster = true
		else
			MoreBuild.playerCanPlaster = false
		end

		MoreBuild.textCarpentryRed = " <RGB:1,0,0>" .. getText("IGUI_perks_Carpentry") .. " " .. MoreBuild.playerCarpentrySkill .. "/"
		MoreBuild.textCarpentryGreen = " <RGB:1,1,1>" .. getText("IGUI_perks_Carpentry") .. " "
		MoreBuild.textElectricityRed = " <RGB:1,0,0>" .. getText("IGUI_perks_Electricity") .. " " .. MoreBuild.playerelectricianSkill .. "/"
		MoreBuild.textElectricityGreen = " <RGB:1,1,1>" .. getText("IGUI_perks_Electricity") .. " "
		MoreBuild.buildMaterialsList(player)

		local _firstTierMenu = context:addOption(getText("ContextMenu_kuozhanjianzhu"), worldobjects, nil)
		local _secondTierMenu = ISContextMenu:getNew(context)
		context:addSubMenu(_firstTierMenu, _secondTierMenu)

		local _architectureOption = _secondTierMenu:addOption(getText("ContextMenu_jianzhu"), worldobjects, nil)
		local _architectureThirdTierMenu = _secondTierMenu:getNew(_secondTierMenu)
		context:addSubMenu(_architectureOption, _architectureThirdTierMenu)

		local _wallsOption = _architectureThirdTierMenu:addOption(getText("ContextMenu_qiangbi"), worldobjects, nil)
		local _wallsSubMenu = _architectureThirdTierMenu:getNew(_architectureThirdTierMenu)

		context:addSubMenu(_wallsOption, _wallsSubMenu)
		MoreBuild.wallStylesMenuBuilder(_wallsSubMenu, player, context, worldobjects)

		local _doorsOption = _architectureThirdTierMenu:addOption(getText("ContextMenu_Door"), worldobjects, nil)
		local _doorsSubMenu = _architectureThirdTierMenu:getNew(_architectureThirdTierMenu)

		context:addSubMenu(_doorsOption, _doorsSubMenu)
		MoreBuild.doorsMenuBuilder(_doorsSubMenu, player, context, worldobjects)

		local _WindowsOption = _architectureThirdTierMenu:addOption(getText("ContextMenu_Windows_Menu"), worldobjects, nil)
		local _WindowsSubMenu = _architectureThirdTierMenu:getNew(_architectureThirdTierMenu)

		context:addSubMenu(_WindowsOption, _WindowsSubMenu)
		MoreBuild.WindowsMenuBuilder(_WindowsSubMenu, player, context, worldobjects)

		local _moreFencesOption = _architectureThirdTierMenu:addOption(getText("ContextMenu_zhalan"), worldobjects, nil)
		local _moreFencesSubMenu = _architectureThirdTierMenu:getNew(_architectureThirdTierMenu)

		context:addSubMenu(_moreFencesOption, _moreFencesSubMenu)
		MoreBuild.moreFencesMenuBuilder(_moreFencesSubMenu, player)

		local _moreFencePostsOption = _architectureThirdTierMenu:addOption(getText("ContextMenu_zhalanzhu"), worldobjects, nil)
		local _moreFencePostsSubMenu = _architectureThirdTierMenu:getNew(_architectureThirdTierMenu)

		context:addSubMenu(_moreFencePostsOption, _moreFencePostsSubMenu)
		MoreBuild.moreFencePostsMenuBuilder(_moreFencePostsSubMenu, player)

		local _stairsOption = _architectureThirdTierMenu:addOption(getText("ContextMenu_Stairs"), worldobjects, nil)
		local _stairsSubMenu = _architectureThirdTierMenu:getNew(_architectureThirdTierMenu)

		context:addSubMenu(_stairsOption, _stairsSubMenu)
		MoreBuild.stairsMenuBuilder(_stairsSubMenu, player)

		local _floorsOption = _architectureThirdTierMenu:addOption(getText("ContextMenu_Floor"), worldobjects, nil)
		local _floorsSubMenu = _architectureThirdTierMenu:getNew(_architectureThirdTierMenu)

		context:addSubMenu(_floorsOption, _floorsSubMenu)
		MoreBuild.floorsMenuBuilder(_floorsSubMenu, player, context, worldobjects)

		local _furnitureOption = _secondTierMenu:addOption(getText("ContextMenu_Furniture"), worldobjects, nil)
		local _furnitureThirdTierMenu = _secondTierMenu:getNew(_secondTierMenu)
		context:addSubMenu(_furnitureOption, _furnitureThirdTierMenu)

		local _smallTablesOption = _furnitureThirdTierMenu:addOption(getText("ContextMenu_xiaozhuozi"), worldobjects, nil)
		local _smallTablesSubMenu = _furnitureThirdTierMenu:getNew(_furnitureThirdTierMenu)

		context:addSubMenu(_smallTablesOption, _smallTablesSubMenu)
		MoreBuild.smallTablesMenuBuilder(_smallTablesSubMenu, player)

		local _largeTablesOption = _furnitureThirdTierMenu:addOption(getText("ContextMenu_dazhuozi"), worldobjects, nil)
		local _largeTablesSubMenu = _furnitureThirdTierMenu:getNew(_furnitureThirdTierMenu)

		context:addSubMenu(_largeTablesOption, _largeTablesSubMenu)
		MoreBuild.largeTablesMenuBuilder(_largeTablesSubMenu, player)

		local _chairsOption = _furnitureThirdTierMenu:addOption(getText("ContextMenu_yizi"), worldobjects, nil)
		local _chairsSubMenu = _furnitureThirdTierMenu:getNew(_furnitureThirdTierMenu)

		context:addSubMenu(_chairsOption, _chairsSubMenu)
		MoreBuild.chairsMenuBuilder(_chairsSubMenu, player, context, worldobjects)

		local _couchesOption = _furnitureThirdTierMenu:addOption(getText("ContextMenu_shafa"), worldobjects, nil)
		local _couchesSubMenu = _furnitureThirdTierMenu:getNew(_furnitureThirdTierMenu)

		context:addSubMenu(_couchesOption, _couchesSubMenu)
		MoreBuild.couchesMenuBuilder(_couchesSubMenu, player, context, worldobjects)

		local _bedsOption = _furnitureThirdTierMenu:addOption(getText("ContextMenu_Bed"), worldobjects, nil)
		local _bedsSubMenu = _furnitureThirdTierMenu:getNew(_furnitureThirdTierMenu)

		context:addSubMenu(_bedsOption, _bedsSubMenu)
		MoreBuild.bedsMenuBuilder(_bedsSubMenu, player)

		local _containersOption = _secondTierMenu:addOption(getText("ContextMenu_rongqi"), worldobjects, nil)
		local _containersThirdTierMenu = _secondTierMenu:getNew(_secondTierMenu)
		context:addSubMenu(_containersOption, _containersThirdTierMenu)

		local _dressersOption = _containersThirdTierMenu:addOption(getText("ContextMenu_shuzhuangtai"), worldobjects, nil)
		local _dressersSubMenu = _containersThirdTierMenu:getNew(_containersThirdTierMenu)

		context:addSubMenu(_dressersOption, _dressersSubMenu)
		MoreBuild.dressersMenuBuilder(_dressersSubMenu, player)

		local _counterElementsOption = _containersThirdTierMenu:addOption(getText "ContextMenu_Cabinets", worldobjects, nil)
		local _counterElementsSubMenu = _containersThirdTierMenu:getNew(_containersThirdTierMenu)

		context:addSubMenu(_counterElementsOption, _counterElementsSubMenu)
		MoreBuild.counterElementsMenuBuilder(_counterElementsSubMenu, player, context, worldobjects)

		local _otherFurnitureOption = _containersThirdTierMenu:addOption(getText "ContextMenu_qitajiaju", worldobjects, nil)
		local _otherFurnitureSubMenu = _containersThirdTierMenu:getNew(_containersThirdTierMenu)

		context:addSubMenu(_otherFurnitureOption, _otherFurnitureSubMenu)
		MoreBuild.otherFurnitureMenuBuilder(_otherFurnitureSubMenu, player)

		local _metalLockersOption = _containersThirdTierMenu:addOption(getText "ContextMenu_jinshugui", worldobjects, nil)
		local _metalLockersSubMenu = _containersThirdTierMenu:getNew(_containersThirdTierMenu)

		context:addSubMenu(_metalLockersOption, _metalLockersSubMenu)
		MoreBuild.metalLockersMenuBuilder(_metalLockersSubMenu, player)

		local _cratesOption = _containersThirdTierMenu:addOption(getText "ContextMenu_xiangzi", worldobjects, nil)
		local _cratesSubMenu = _containersThirdTierMenu:getNew(_containersThirdTierMenu)

		context:addSubMenu(_cratesOption, _cratesSubMenu)
		MoreBuild.cratesMenuBuilder(_cratesSubMenu, player)

		local _improvisedOption = _containersThirdTierMenu:addOption(getText "ContextMenu_jianyixiangzi", worldobjects, nil)
		local _improvisedSubMenu = _containersThirdTierMenu:getNew(_containersThirdTierMenu)

		context:addSubMenu(_improvisedOption, _improvisedSubMenu)
		MoreBuild.improvisedMenuBuilder(_improvisedSubMenu, player)

		local _trashOption = _containersThirdTierMenu:addOption(getText "ContextMenu_Recycling_Bin", worldobjects, nil)
		local _trashSubMenu = _containersThirdTierMenu:getNew(_containersThirdTierMenu)

		context:addSubMenu(_trashOption, _trashSubMenu)
		MoreBuild.trashMenuBuilder(_trashSubMenu, player)

		local _decorationOption = _secondTierMenu:addOption(getText "ContextMenu_zhuangshipin", worldobjects, nil)
		local _decorationThirdTierMenu = _secondTierMenu:getNew(_secondTierMenu)
		context:addSubMenu(_decorationOption, _decorationThirdTierMenu)

		local _roadwayOption = _decorationThirdTierMenu:addOption(getText "ContextMenu_daoluzhihu", worldobjects, nil)
		local _roadwaySubMenu = _decorationThirdTierMenu:getNew(_decorationThirdTierMenu)

		context:addSubMenu(_roadwayOption, _roadwaySubMenu)
		MoreBuild.roadwayMenuBuilder(_roadwaySubMenu, player)

		local _signsOption = _decorationThirdTierMenu:addOption(getText "ContextMenu_biaozhi", worldobjects, nil)
		local _signsSubMenu = _decorationThirdTierMenu:getNew(_decorationThirdTierMenu)

		context:addSubMenu(_signsOption, _signsSubMenu)
		MoreBuild.signsMenuBuilder(_signsSubMenu, player)

		local _wallHangingsInsideOption = _decorationThirdTierMenu:addOption(getText "ContextMenu_qiangshi", worldobjects, nil)
		local _wallHangingsInsideSubMenu = _decorationThirdTierMenu:getNew(_decorationThirdTierMenu)

		context:addSubMenu(_wallHangingsInsideOption, _wallHangingsInsideSubMenu)
		MoreBuild.wallDecorationsMenuBuilder(_wallHangingsInsideSubMenu, player, context, worldobjects)

		local _otherOption = _secondTierMenu:addOption(getText "ContextMenu_qita", worldobjects, nil)
		local _otherThirdTierMenu = _secondTierMenu:getNew(_secondTierMenu)
		context:addSubMenu(_otherOption, _otherThirdTierMenu)

		local _flowerBedsOption = _otherThirdTierMenu:addOption(getText "ContextMenu_huacao", worldobjects, nil)
		local _flowerBedsSubMenu = _otherThirdTierMenu:getNew(_otherThirdTierMenu)

		context:addSubMenu(_flowerBedsOption, _flowerBedsSubMenu)
		MoreBuild.flowerBedsMenuBuilder(_flowerBedsSubMenu, player, context, worldobjects)

		local _lightPostOption = _otherThirdTierMenu:addOption(getText "ContextMenu_zhaoming", worldobjects, nil)
		local _lightPostSubMenu = _otherThirdTierMenu:getNew(_otherThirdTierMenu)

		context:addSubMenu(_lightPostOption, _lightPostSubMenu)
		MoreBuild.lightPostMenuBuilder(_lightPostSubMenu, player)

		local _missingPostsOption = _otherThirdTierMenu:addOption(getText "ContextMenu_qita", worldobjects, nil)
		local _missingPostsSubMenu = _otherThirdTierMenu:getNew(_otherThirdTierMenu)

		context:addSubMenu(_missingPostsOption, _missingPostsSubMenu)
		MoreBuild.missingPostsMenuBuilder(_missingPostsSubMenu, player)


		local _SurvivalOption = _secondTierMenu:addOption(getText "ContextMenu_BuildMenu_Survival", worldobjects, nil)
		local _SurvivalThirdTierMenu = _secondTierMenu:getNew(_secondTierMenu)

		context:addSubMenu(_SurvivalOption, _SurvivalThirdTierMenu)
		MoreBuild.SurvivalPostsMenuBuilder(_SurvivalThirdTierMenu, player)
	end
end

MoreBuild.haveAToolToBuildWithWith = function(player)

	local _inventory = getSpecificPlayer(player):getInventory()
	MoreBuild.toolsList = {}
	MoreBuild.toolsList["Hammer"] = _inventory:contains("Hammer") or _inventory:contains("HammerStone")
	MoreBuild.toolsList["Screwdriver"] = _inventory:contains("Screwdriver")
	MoreBuild.toolsList["HandShovel"] = _inventory:contains("HandShovel")
	MoreBuild.toolsList["Hammer"] = _inventory:contains("Hammer")
	MoreBuild.toolsList["Saw"] = _inventory:contains("Saw")
	MoreBuild.toolsList["Spade"] = _inventory:contains("Shovel")

	MoreBuild.toolsText["Hammer"] = getItemText "Hammer"
	MoreBuild.toolsText["Screwdriver"] = getItemText "Screwdriver"
	MoreBuild.toolsText["HandShovel"] = getItemText "Shovel"
	MoreBuild.toolsText["Saw"] = getItemText "Saw"
	MoreBuild.toolsText["Spade"] = getItemText "Spade"

	if MoreBuild.toolsList["Hammer"] or MoreBuild.toolsList["Screwdriver"] or ISBuildMenu.cheat then
		return true
	else
		return false
	end
end

MoreBuild.equipToolPrimary = function(object, player, tool)

	if MoreBuild.toolsList[tool] then

		ISInventoryPaneContextMenu.equipWeapon(getSpecificPlayer(player):getInventory():getItemFromType(tool), true, false, player)

		object.noNeedHammer = true
	end
end


MoreBuild.equipToolSecondary = function(object, player, tool)

	if MoreBuild.toolsList[tool] then

		ISInventoryPaneContextMenu.equipWeapon(getSpecificPlayer(player):getInventory():getItemFromType(tool), false, false, player)
	end
end

MoreBuild.buildMaterialsList = function(player)
	MoreBuild.availableMaterialsList = buildUtil.checkMaterialOnGround(getSpecificPlayer(player):getCurrentSquare())


	local _inventoryList = getSpecificPlayer(player):getInventory():getItems()
	local _size = _inventoryList:size()
	local _currentItemType = ""

	for i = 0, _size - 1 do
		_currentItemType = _inventoryList:get(i):getType()

		if MoreBuild.availableMaterialsList[_currentItemType] then
			MoreBuild.availableMaterialsList[_currentItemType] = MoreBuild.availableMaterialsList[_currentItemType] + 1
		else
			MoreBuild.availableMaterialsList[_currentItemType] = 1
		end
	end
end

MoreBuild.tooltipCheckForMaterial = function(materialRequired, amountNeeded, materialText, tooltip)
	if amountNeeded > 0 then
		local _thisItemCount = 0

		if MoreBuild.availableMaterialsList[materialRequired] then
			_thisItemCount = MoreBuild.availableMaterialsList[materialRequired]
		else
			_thisItemCount = 0
		end

		if _thisItemCount < amountNeeded then
			tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. materialText .. " " .. _thisItemCount .. "/" .. amountNeeded .. " <LINE>"
			return false
		else
			tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. materialText .. " " .. amountNeeded .. " <LINE>"
			return true
		end
	end

	return true
end

MoreBuild.tooltipCheckForTool = function(tool, tooltip)
	if MoreBuild.toolsList and MoreBuild.toolsList[tool] then
		tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. MoreBuild.toolsText[tool] .. " <LINE>"
		return true
	else
		tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. MoreBuild.toolsText[tool] .. " <LINE>"
		return false
	end
end

MoreBuild.canBuildObject = function(carpentrySkillRequired, ElectricianSkillRequired, option, player)

	local _tooltip = ISToolTip:new()
	_tooltip:initialise()
	_tooltip:setVisible(false)
	option.toolTip = _tooltip

	local _canBuildResult = true


	_tooltip.description = MoreBuild.textTooltipHeader

	local _currentResult = true

	for _, _currentMaterial in pairs(MoreBuild.neededMaterials) do
		if _currentMaterial["Material"] and _currentMaterial["Amount"] and _currentMaterial["Text"] then
			_currentResult = MoreBuild.tooltipCheckForMaterial(_currentMaterial["Material"], _currentMaterial["Amount"], _currentMaterial["Text"], _tooltip)
		else
			_tooltip.description = _tooltip.description .. " <RGB:1,0,0> Error in required material definition. <LINE>"
			_canBuildResult = false
		end

		if not _currentResult then
			_canBuildResult = false
		end
	end


	for _, _currentTool in pairs(MoreBuild.neededTools) do
		_currentResult = MoreBuild.tooltipCheckForTool(_currentTool, _tooltip)

		if not _currentResult then
			_canBuildResult = false
		end
	end


	if carpentrySkillRequired > 0 then
		if MoreBuild.playerCarpentrySkill < carpentrySkillRequired then
			_tooltip.description = _tooltip.description .. MoreBuild.textCarpentryRed
			_canBuildResult = false
		else
			_tooltip.description = _tooltip.description .. MoreBuild.textCarpentryGreen
		end

		_tooltip.description = _tooltip.description .. carpentrySkillRequired .. " <LINE>"
	end
	if ElectricianSkillRequired > 0 then
		if MoreBuild.playerelectricianSkill < ElectricianSkillRequired then
			_tooltip.description = _tooltip.description .. MoreBuild.textElectricityRed
			_canBuildResult = false
		else
			_tooltip.description = _tooltip.description .. MoreBuild.textElectricityGreen
		end

		_tooltip.description = _tooltip.description .. ElectricianSkillRequired .. " <LINE>"
	end

	if not _canBuildResult and not ISBuildMenu.cheat then
		option.onSelect = nil
		option.notAvailable = true
	end


	return _tooltip
end

local function func_Init()
	if getSteamModeActive() then
		Events.OnFillWorldObjectContextMenu.Add(MoreBuild.doBuildMenu)
	end
end

Events.OnGameStart.Add(func_Init)

MoreBuild.wallStylesMenuBuilder = function(subMenu, player, context, worldobjects)

	--Create the styles to be listed under the Walls submenu.  The table will be
	--       used so that each style has access to its particular submenu under Walls.
	local _stylesOptions = {}
	local _stylesSubMenus = {}
	local _styleList =
	{
		getText "ContextMenu_Light_BrownWood",
		getText "ContextMenu_Dark_BrownWood",
		getText "ContextMenu_Gray_Plaster",
		getText "ContextMenu_Gray_Wood",
		getText "ContextMenu_Red_Barnwood",
		getText "ContextMenu_White_Plaster",
		getText "ContextMenu_White_Wood",
		getText "ContextMenu_Brown_Cinder_Block",
		getText "ContextMenu_Gray_Cinder_Block",
		getText "ContextMenu_White_CinderBlock",
		getText "ContextMenu_hongzhuanqiang",
	}

	for _, _style in pairs(_styleList) do
		_stylesOptions[_style] = subMenu:addOption(_style, worldobjects, nil)
		_stylesSubMenus[_style] = subMenu:getNew(subMenu)
		context:addSubMenu(_stylesOptions[_style], _stylesSubMenus[_style])
	end

	--Build the individual submenus.  Each of these functions will fill in their
	--       specific world object type under the correct sytle.  So, under an entry listed
	--       in _styleList, you will have a wall, a pillar, a door frame, et cetera.
	--
	--       Some styles lack matching fence styles, so no fence or fence post will be added
	--       to that style's submenu.
	MoreBuild.wallsMenuBuilder(_stylesSubMenus, player)
	MoreBuild.pillarsMenuBuilder(_stylesSubMenus, player)
	MoreBuild.doorFramesMenuBuilder(_stylesSubMenus, player)
	MoreBuild.windowFramesMenuBuilder(_stylesSubMenus, player)
	MoreBuild.fencesMenuBuilder(_stylesSubMenus, player)
	MoreBuild.fencePostsMenuBuilder(_stylesSubMenus, player)
end

MoreBuild.wallsMenuBuilder = function(subMenu, player)
	local _sprite
	local _option
	local _tooltip
	local _name = ""

	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 3,
			Text = getItemText("Plank"),
		},

		{
			Material = "Nails",
			Amount = 3,
			Text = getItemText("Nails"),
		},
	}

	MoreBuild.neededTools = {"Hammer"}

	_sprite = {}
	_sprite.sprite = "location_restaurant_pileocrepe_01_0"
	_sprite.northSprite = "location_restaurant_pileocrepe_01_1"
	_sprite.corner = "location_restaurant_pileocrepe_01_3"

	_name = getText "ContextMenu_Light_Brown_WoodWall"

	_option = subMenu[getText "ContextMenu_Light_BrownWood"]:addOption(_name, nil, MoreBuild.onBuildWoodenWall, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textWallDescription .. _tooltip.description

	if MoreBuild.playerCanPlaster then
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
	else
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
	end

	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "location_shop_bargNclothes_01_24"
	_sprite.northSprite = "location_shop_bargNclothes_01_25"
	_sprite.corner = "location_shop_bargNclothes_01_27"

	_name = getText "ContextMenu_Dark_BrownWoodWal"

	_option = subMenu[getText "ContextMenu_Dark_BrownWood"]:addOption(_name, nil, MoreBuild.onBuildWoodenWall, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textWallDescription .. _tooltip.description

	if MoreBuild.playerCanPlaster then
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
	else
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
	end

	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "walls_garage_02_16"
	_sprite.northSprite = "walls_garage_02_17"
	_sprite.corner = "walls_garage_02_19"

	_name = getText "ContextMenu_Gray_Plaster_Wall"

	_option = subMenu[getText "ContextMenu_Gray_Plaster"]:addOption(_name, nil, MoreBuild.onBuildWoodenWall, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textWallDescription .. _tooltip.description

	if MoreBuild.playerCanPlaster then
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
	else
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
	end

	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "walls_exterior_wooden_01_28"
	_sprite.northSprite = "walls_exterior_wooden_01_29"
	_sprite.corner = "walls_exterior_wooden_01_31"

	_name = getText "ContextMenu_Gray_Wood"

	_option = subMenu[getText "ContextMenu_Gray_Wood"]:addOption(_name, nil, MoreBuild.onBuildWoodenWall, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textWallDescription .. _tooltip.description

	if MoreBuild.playerCanPlaster then
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
	else
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
	end

	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "walls_exterior_wooden_01_0"
	_sprite.northSprite = "walls_exterior_wooden_01_1"
	_sprite.corner = "walls_exterior_wooden_01_3"

	_name = getText "ContextMenu_Red_Barnwood"

	_option = subMenu[getText "ContextMenu_Red_Barnwood"]:addOption(_name, nil, MoreBuild.onBuildWoodenWall, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textWallDescription .. _tooltip.description

	if MoreBuild.playerCanPlaster then
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
	else
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
	end

	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "location_shop_mall_01_0"
	_sprite.northSprite = "location_shop_mall_01_1"
	_sprite.corner = "location_shop_mall_01_3"

	_name = getText "ContextMenu_White_Plaster"

	_option = subMenu[getText "ContextMenu_White_Plaster"]:addOption(_name, nil, MoreBuild.onBuildWoodenWall, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textWallDescription .. _tooltip.description

	if MoreBuild.playerCanPlaster then
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
	else
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
	end

	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "walls_exterior_wooden_02_0"
	_sprite.northSprite = "walls_exterior_wooden_02_1"
	_sprite.corner = "walls_exterior_wooden_02_3"

	_name = getText "ContextMenu_White_Wood"

	_option = subMenu[getText "ContextMenu_White_Wood"]:addOption(_name, nil, MoreBuild.onBuildWoodenWall, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textWallDescription .. _tooltip.description

	if MoreBuild.playerCanPlaster then
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
	else
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
	end

	_tooltip:setTexture(_sprite.sprite)

	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 6,
			Text = getItemText("Plank"),
		},

		{
			Material = "Nails",
			Amount = 3,
			Text = getItemText("Nails"),
		},
	}

	MoreBuild.neededTools = {"Hammer"}

	_sprite = {}
	_sprite.sprite = "walls_commercial_03_0"
	_sprite.northSprite = "walls_commercial_03_1"
	_sprite.corner = "walls_commercial_03_3"

	_name = getText "ContextMenu_Brown_Cinder_Block"

	_option = subMenu[getText "ContextMenu_Brown_Cinder_Block"]:addOption(_name, nil, MoreBuild.onBuildStoneWall, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.stoneArchitecture, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_zongsezhuanqiangtip" .. _tooltip.description

	if MoreBuild.playerCanPlaster then
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
	else
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
	end

	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "walls_commercial_03_32"
	_sprite.northSprite = "walls_commercial_03_33"
	_sprite.corner = "walls_commercial_03_35"

	_name = getText "ContextMenu_Gray_Cinder_Block"

	_option = subMenu[getText "ContextMenu_Gray_Cinder_Block"]:addOption(_name, nil, MoreBuild.onBuildStoneWall, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.stoneArchitecture, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_huisezhuanqiangtio" .. _tooltip.description

	if MoreBuild.playerCanPlaster then
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
	else
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
	end

	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "walls_commercial_01_48"
	_sprite.northSprite = "walls_commercial_01_49"
	_sprite.corner = "walls_commercial_01_51"

	_name = getText "ContextMenu_White_CinderBlock"

	_option = subMenu[getText "ContextMenu_White_CinderBlock"]:addOption(_name, nil, MoreBuild.onBuildStoneWall, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.stoneArchitecture, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_baisezhuanqiangtip" .. _tooltip.description

	if MoreBuild.playerCanPlaster then
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
	else
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
	end

	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "walls_exterior_house_01_4"
	_sprite.northSprite = "walls_exterior_house_01_5"
	_sprite.corner = "walls_exterior_house_01_7"

	_name = getText "ContextMenu_hongzhuanqiang"

	_option = subMenu[getText "ContextMenu_hongzhuanqiang"]:addOption(_name, nil, MoreBuild.onBuildStoneWall, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.stoneArchitecture, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_hongzhuanqiangtip" .. _tooltip.description

	if MoreBuild.playerCanPlaster then
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
	else
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
	end

	_tooltip:setTexture(_sprite.sprite)
end

MoreBuild.onBuildWoodenWall = function(ignoreThisArgument, sprite, player, name)
	local _wall = ISWoodenWall:new(sprite.sprite, sprite.northSprite, sprite.corner)

	_wall.canBePlastered = MoreBuild.playerCanPlaster
	_wall.canBarricade = false
	_wall.modData["wallType"] = "wall"
	_wall.player = player
	_wall.name = name

	_wall.modData["need:Base.Plank"] = "3"
	_wall.modData["need:Base.Nails"] = "3"
	_wall.modData["xp:Woodwork"] = "5"

	getCell():setDrag(_wall, player)
end


MoreBuild.onBuildStoneWall = function(ignoreThisArgument, sprite, player, name)
	local _wall = ISWoodenWall:new(sprite.sprite, sprite.northSprite, sprite.corner)

	_wall.canBePlastered = MoreBuild.playerCanPlaster
	_wall.canBarricade = false
	_wall.modData["wallType"] = "wall"
	_wall.player = player
	_wall.name = name

	_wall.modData["need:Base.Plank"] = "6"
	_wall.modData["need:Base.Nails"] = "3"
	_wall.modData["xp:Woodwork"] = "5"

	function _wall:getHealth()
		return MoreBuild.healthLevel.stoneWall + buildUtil.getWoodHealth(self)
	end

	MoreBuild.equipToolPrimary(_wall, player, "Trowel")

	getCell():setDrag(_wall, player)
end

MoreBuild.pillarsMenuBuilder = function(subMenu, player)
	local _sprite
	local _option
	local _tooltip
	local _name = ""

	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 2,
			Text = getItemText("Plank"),
		},

		{
			Material = "Nails",
			Amount = 3,
			Text = getItemText("Nails"),
		},
	}

	MoreBuild.neededTools = {"Hammer"}

	_sprite = {}
	_sprite.sprite = "location_restaurant_pileocrepe_01_3"
	_sprite.northSprite = "location_restaurant_pileocrepe_01_3"

	_name = getText "ContextMenu_Light_Brown_WoodPillar"

	_option = subMenu[getText "ContextMenu_Light_BrownWood"]:addOption(_name, nil, MoreBuild.onBuildWoodenPillar, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textPillarDescription .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "location_shop_bargNclothes_01_27"
	_sprite.northSprite = "location_shop_bargNclothes_01_27"

	_name = getText "ContextMenu_shenzongsemuzhizhu"

	_option = subMenu[getText "ContextMenu_Dark_BrownWood"]:addOption(_name, nil, MoreBuild.onBuildWoodenPillar, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textPillarDescription .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "walls_garage_02_19"
	_sprite.northSprite = "walls_garage_02_19"

	_name = getText "ContextMenu_Gray_Plaster_Pillar"

	_option = subMenu[getText "ContextMenu_Gray_Plaster"]:addOption(_name, nil, MoreBuild.onBuildWoodenPillar, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textPillarDescription .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)


	_sprite = {}
	_sprite.sprite = "walls_exterior_wooden_01_31"
	_sprite.northSprite = "walls_exterior_wooden_01_31"

	_name = getText "ContextMenu_Gray_Wood_Pillar"

	_option = subMenu[getText "ContextMenu_Gray_Wood"]:addOption(_name, nil, MoreBuild.onBuildWoodenPillar, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textPillarDescription .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "walls_exterior_wooden_01_3"
	_sprite.northSprite = "walls_exterior_wooden_01_3"

	_name = getText "ContextMenu_Red_Barnwood_Pillar"

	_option = subMenu[getText "ContextMenu_Red_Barnwood"]:addOption(_name, nil, MoreBuild.onBuildWoodenPillar, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textPillarDescription .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "location_shop_mall_01_3"
	_sprite.northSprite = "location_shop_mall_01_3"

	_name = getText "ContextMenu_White_Plaster_Pillar"

	_option = subMenu[getText "ContextMenu_White_Plaster"]:addOption(_name, nil, MoreBuild.onBuildWoodenPillar, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textPillarDescription .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "walls_exterior_wooden_02_3"
	_sprite.northSprite = "walls_exterior_wooden_02_3"

	_name = getText "ContextMenu_White_Wood_Pillar"

	_option = subMenu[getText "ContextMenu_White_Wood"]:addOption(_name, nil, MoreBuild.onBuildWoodenPillar, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textPillarDescription .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 2,
			Text = getItemText("Plank"),
		},

		{
			Material = "Nails",
			Amount = 3,
			Text = getItemText("Nails"),
		},
	}

	MoreBuild.neededTools = {"Hammer"}

	_sprite = {}
	_sprite.sprite = "walls_commercial_03_3"
	_sprite.northSprite = "walls_commercial_03_3"

	_name = getText "ContextMenu_Brown_Cinder_BlockPillar"

	_option = subMenu[getText "ContextMenu_Brown_Cinder_Block"]:addOption(_name, nil, MoreBuild.onBuildStonePillar, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.stoneArchitecture, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_zongsezhuanzhizhutip" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "walls_commercial_03_35"
	_sprite.northSprite = "walls_commercial_03_35"

	_name = getText "ContextMenu_Gray_Cinder_BlockPillar"

	_option = subMenu[getText "ContextMenu_Gray_Cinder_Block"]:addOption(_name, nil, MoreBuild.onBuildStonePillar, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.stoneArchitecture, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_huisezhuanzhizhutip" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "walls_commercial_01_51"
	_sprite.northSprite = "walls_commercial_01_51"

	_name = getText "ContextMenu_White_Cinder_BlockPillar"

	_option = subMenu[getText "ContextMenu_White_CinderBlock"]:addOption(_name, nil, MoreBuild.onBuildStonePillar, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.stoneArchitecture, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_baisezhuanzhizhutip" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "walls_exterior_house_01_7"
	_sprite.northSprite = "walls_exterior_house_01_7"

	_name = getText "ContextMenu_hongzhuanzhizhu"

	_option = subMenu[getText "ContextMenu_hongzhuanqiang"]:addOption(_name, nil, MoreBuild.onBuildStonePillar, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.stoneArchitecture, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_hongzhuanzhizhutip" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)
end

MoreBuild.onBuildWoodenPillar = function(ignoreThisArgument, sprite, player, name)
	local _pillar = ISWoodenWall:new(sprite.sprite, sprite.northSprite, nil)

	_pillar.canPassThrough = true
	_pillar.canBarricade = false
	_pillar.player = player
	_pillar.name = name

	_pillar.modData["need:Base.Plank"] = "2"
	_pillar.modData["need:Base.Nails"] = "3"
	_pillar.modData["xp:Woodwork"] = "5"

	getCell():setDrag(_pillar, player)
end


MoreBuild.onBuildStonePillar = function(ignoreThisArgument, sprite, player, name)
	local _pillar = ISWoodenWall:new(sprite.sprite, sprite.northSprite, nil)

	_pillar.canPassThrough = true
	_pillar.canBarricade = false
	_pillar.player = player
	_pillar.name = name

	_pillar.modData["need:Base.Plank"] = "2"
	_pillar.modData["need:Base.Nails"] = "3"
	_pillar.modData["xp:Woodwork"] = "5"

	function _pillar:getHealth()
		return MoreBuild.healthLevel.stoneWall + buildUtil.getWoodHealth(self)
	end

	MoreBuild.equipToolPrimary(_pillar, player, "Trowel")

	getCell():setDrag(_pillar, player)
end

MoreBuild.doorFramesMenuBuilder = function(subMenu, player)
	local _sprite
	local _option
	local _tooltip
	local _name = ""

	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 4,
			Text = getItemText("Plank"),
		},

		{
			Material = "Nails",
			Amount = 4,
			Text = getItemText("Nails"),
		},
	}

	MoreBuild.neededTools = {"Hammer"}

	_sprite = {}
	_sprite.sprite = "location_restaurant_pileocrepe_01_10"
	_sprite.northSprite = "location_restaurant_pileocrepe_01_11"
	_sprite.corner = "location_restaurant_pileocrepe_01_3"

	_name = getText "ContextMenu_Light_BrownWood_DoorFrame"

	_option = subMenu[getText "ContextMenu_Light_BrownWood"]:addOption(_name, nil, MoreBuild.onBuildWoodenDoorFrame, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textDoorFrameDescription .. _tooltip.description

	if MoreBuild.playerCanPlaster then
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
	else
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
	end

	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "location_shop_bargNclothes_01_34"
	_sprite.northSprite = "location_shop_bargNclothes_01_35"
	_sprite.corner = "location_shop_bargNclothes_01_27"

	_name = getText "ContextMenu_shenzongsemumenkuang"

	_option = subMenu[getText "ContextMenu_Dark_BrownWood"]:addOption(_name, nil, MoreBuild.onBuildWoodenDoorFrame, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textDoorFrameDescription .. _tooltip.description

	if MoreBuild.playerCanPlaster then
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
	else
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
	end

	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "walls_garage_02_26"
	_sprite.northSprite = "walls_garage_02_27"
	_sprite.corner = "walls_garage_02_19"

	_name = getText "ContextMenu_Gray_Plaster_DoorFrame"

	_option = subMenu[getText "ContextMenu_Gray_Plaster"]:addOption(_name, nil, MoreBuild.onBuildWoodenDoorFrame, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textDoorFrameDescription .. _tooltip.description

	if MoreBuild.playerCanPlaster then
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
	else
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
	end

	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "walls_exterior_wooden_01_38"
	_sprite.northSprite = "walls_exterior_wooden_01_39"
	_sprite.corner = "walls_exterior_wooden_01_31"

	_name = getText "ContextMenu_Gray_Wood_DoorFrame"

	_option = subMenu[getText "ContextMenu_Gray_Wood"]:addOption(_name, nil, MoreBuild.onBuildWoodenDoorFrame, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textDoorFrameDescription .. _tooltip.description

	if MoreBuild.playerCanPlaster then
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
	else
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
	end

	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "walls_exterior_wooden_01_10"
	_sprite.northSprite = "walls_exterior_wooden_01_11"
	_sprite.corner = "walls_exterior_wooden_01_3"

	_name = getText "ContextMenu_Red_Barnwood_DoorFrame"

	_option = subMenu[getText "ContextMenu_Red_Barnwood"]:addOption(_name, nil, MoreBuild.onBuildWoodenDoorFrame, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textDoorFrameDescription .. _tooltip.description

	if MoreBuild.playerCanPlaster then
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
	else
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
	end

	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "location_shop_mall_01_10"
	_sprite.northSprite = "location_shop_mall_01_11"
	_sprite.corner = "location_shop_mall_01_3"

	_name = getText "ContextMenu_White_Plaster_DoorFrame"

	_option = subMenu[getText "ContextMenu_White_Plaster"]:addOption(_name, nil, MoreBuild.onBuildWoodenDoorFrame, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textDoorFrameDescription .. _tooltip.description

	if MoreBuild.playerCanPlaster then
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
	else
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
	end

	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "walls_exterior_wooden_02_10"
	_sprite.northSprite = "walls_exterior_wooden_02_11"
	_sprite.corner = "walls_exterior_wooden_02_3"

	_name = getText "ContextMenu_White_Wood_DoorFrame"

	_option = subMenu[getText "ContextMenu_White_Wood"]:addOption(_name, nil, MoreBuild.onBuildWoodenDoorFrame, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textDoorFrameDescription .. _tooltip.description

	if MoreBuild.playerCanPlaster then
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
	else
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
	end

	_tooltip:setTexture(_sprite.sprite)

	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 2,
			Text = getItemText("Plank"),
		},

		{
			Material = "Nails",
			Amount = 3,
			Text = getItemText("Nails"),
		},
	}

	MoreBuild.neededTools = {"Hammer"}

	_sprite = {}
	_sprite.sprite = "walls_commercial_03_10"
	_sprite.northSprite = "walls_commercial_03_11"
	_sprite.corner = "walls_commercial_03_3"

	_name = getText "ContextMenu_Brown_Cinder_Block_DoorFrame"

	_option = subMenu[getText "ContextMenu_Brown_Cinder_Block"]:addOption(_name, nil, MoreBuild.onBuildStoneDoorFrame, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.stoneArchitecture, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)

	_tooltip.description = getText "Tooltip_zongsezhuangmenkuangtip" .. _tooltip.description

	if MoreBuild.playerCanPlaster then
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
	else
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
	end

	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "walls_commercial_03_42"
	_sprite.northSprite = "walls_commercial_03_43"
	_sprite.corner = "walls_commercial_03_35"

	_name = getText "ContextMenu_Gray_Cinder_Block_DoorFrame"

	_option = subMenu[getText "ContextMenu_Gray_Cinder_Block"]:addOption(_name, nil, MoreBuild.onBuildStoneDoorFrame, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.stoneArchitecture, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_huisezhuanmenkuangtip" .. _tooltip.description

	if MoreBuild.playerCanPlaster then
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
	else
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
	end

	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "walls_commercial_01_58"
	_sprite.northSprite = "walls_commercial_01_59"
	_sprite.corner = "walls_commercial_01_51"

	_name = getText "ContextMenu_White_Cinder_Block_DoorFrame"

	_option = subMenu[getText "ContextMenu_White_CinderBlock"]:addOption(_name, nil, MoreBuild.onBuildStoneDoorFrame, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.stoneArchitecture, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_baisezhuanmenkuangtip" .. _tooltip.description

	if MoreBuild.playerCanPlaster then
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
	else
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
	end

	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "walls_exterior_house_01_14"
	_sprite.northSprite = "walls_exterior_house_01_15"
	_sprite.corner = "walls_exterior_house_01_7"

	_name = getText "ContextMenu_hongzhuanmenkuang"

	_option = subMenu[getText "ContextMenu_hongzhuanqiang"]:addOption(_name, nil, MoreBuild.onBuildStoneDoorFrame, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.stoneArchitecture, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_hongzhuanmenkuangtip" .. _tooltip.description

	if MoreBuild.playerCanPlaster then
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
	else
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
	end

	_tooltip:setTexture(_sprite.sprite)
end

MoreBuild.onBuildWoodenDoorFrame = function(ignoreThisArgument, sprite, player, name)
	local _doorFrame = ISWoodenDoorFrame:new(sprite.sprite, sprite.northSprite, sprite.corner)

	_doorFrame.canBePlastered = MoreBuild.playerCanPlaster
	_doorFrame.modData["wallType"] = "doorframe"
	_doorFrame.player = player
	_doorFrame.name = name


	_doorFrame.modData["need:Base.Plank"] = "4"
	_doorFrame.modData["need:Base.Nails"] = "4"
	_doorFrame.modData["xp:Woodwork"] = "5"

	getCell():setDrag(_doorFrame, player)
end

MoreBuild.onBuildLowDoorFrame = function(ignoreThisArgument, sprite, player, name)
	local _LowdoorFrame = ISWoodenDoorFrame:new(sprite.sprite, sprite.northSprite, sprite.corner)

	_LowdoorFrame.canBePlastered = MoreBuild.playerCanPlaster
	_LowdoorFrame.modData["wallType"] = "doorframe"
	_LowdoorFrame.player = player
	_LowdoorFrame.name = name


	_LowdoorFrame.modData["need:Base.Plank"] = "1"
	_LowdoorFrame.modData["need:Base.Nails"] = "1"
	_LowdoorFrame.modData["xp:Woodwork"] = "5"

	getCell():setDrag(_LowdoorFrame, player)
end


MoreBuild.onBuildStoneDoorFrame = function(ignoreThisArgument, sprite, player, name)
	local _doorFrame = ISWoodenDoorFrame:new(sprite.sprite, sprite.northSprite, sprite.corner)

	_doorFrame.canBePlastered = MoreBuild.playerCanPlaster
	_doorFrame.modData["wallType"] = "doorframe"
	_doorFrame.player = player
	_doorFrame.name = name


	_doorFrame.modData["need:Base.Plank"] = "8"
	_doorFrame.modData["need:Base.Nails"] = "4"
	_doorFrame.modData["xp:Woodwork"] = "5"

	function _doorFrame:getHealth()
		return MoreBuild.healthLevel.stoneWall + buildUtil.getWoodHealth(self)
	end

	MoreBuild.equipToolPrimary(_doorFrame, player, "Trowel")

	getCell():setDrag(_doorFrame, player)
end

MoreBuild.windowFramesMenuBuilder = function(subMenu, player)
	local _sprite
	local _option
	local _tooltip
	local _name = ""

	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 4,
			Text = getItemText("Plank"),
		},

		{
			Material = "Nails",
			Amount = 4,
			Text = getItemText("Nails"),
		},
	}

	MoreBuild.neededTools = {"Hammer"}

	_sprite = {}
	_sprite.sprite = "location_restaurant_pileocrepe_01_8"
	_sprite.northSprite = "location_restaurant_pileocrepe_01_9"
	_sprite.corner = "location_restaurant_pileocrepe_01_3"

	_name = getText "ContextMenu_Light_BrownWood_WindowFrame"

	_option = subMenu[getText "ContextMenu_Light_BrownWood"]:addOption(_name, nil, MoreBuild.onBuildWoodenWindowFrame, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textWindowFrameDescription .. _tooltip.description

	if MoreBuild.playerCanPlaster then
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
	else
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
	end

	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "location_shop_bargNclothes_01_32"
	_sprite.northSprite = "location_shop_bargNclothes_01_33"
	_sprite.corner = "location_shop_bargNclothes_01_27"

	_name = getText "ContextMenu_shenzongsemuchuangkuang"

	_option = subMenu[getText "ContextMenu_Dark_BrownWood"]:addOption(_name, nil, MoreBuild.onBuildWoodenWindowFrame, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textWindowFrameDescription .. _tooltip.description

	if MoreBuild.playerCanPlaster then
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
	else
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
	end

	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "walls_garage_02_24"
	_sprite.northSprite = "walls_garage_02_25"
	_sprite.corner = "walls_garage_02_19"

	_name = getText "ContextMenu_Gray_Plaster_WindowFram"

	_option = subMenu[getText "ContextMenu_Gray_Plaster"]:addOption(_name, nil, MoreBuild.onBuildWoodenWindowFrame, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textWindowFrameDescription .. _tooltip.description

	if MoreBuild.playerCanPlaster then
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
	else
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
	end

	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "walls_exterior_wooden_01_36"
	_sprite.northSprite = "walls_exterior_wooden_01_37"
	_sprite.corner = "walls_exterior_wooden_01_31"

	_name = getText "ContextMenu_Gray_Wood_WindowFrame"

	_option = subMenu[getText "ContextMenu_Gray_Wood"]:addOption(_name, nil, MoreBuild.onBuildWoodenWindowFrame, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textWindowFrameDescription .. _tooltip.description

	if MoreBuild.playerCanPlaster then
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
	else
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
	end

	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "walls_exterior_wooden_01_8"
	_sprite.northSprite = "walls_exterior_wooden_01_9"
	_sprite.corner = "walls_exterior_wooden_01_3"

	_name = getText "ContextMenu_Red_Barnwood_WindowFrame"

	_option = subMenu[getText "ContextMenu_Red_Barnwood"]:addOption(_name, nil, MoreBuild.onBuildWoodenWindowFrame, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textWindowFrameDescription .. _tooltip.description

	if MoreBuild.playerCanPlaster then
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
	else
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
	end

	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "location_shop_mall_01_8"
	_sprite.northSprite = "location_shop_mall_01_9"
	_sprite.corner = "location_shop_mall_01_3"

	_name = getText "ContextMenu_White_Plaster_WindowFrame"

	_option = subMenu[getText "ContextMenu_White_Plaster"]:addOption(_name, nil, MoreBuild.onBuildWoodenWindowFrame, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textWindowFrameDescription .. _tooltip.description

	if MoreBuild.playerCanPlaster then
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
	else
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
	end

	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "walls_exterior_wooden_02_8"
	_sprite.northSprite = "walls_exterior_wooden_02_9"
	_sprite.corner = "walls_exterior_wooden_02_3"

	_name = getText "ContextMenu_White_Wood_WindowFrame"

	_option = subMenu[getText "ContextMenu_White_Wood"]:addOption(_name, nil, MoreBuild.onBuildWoodenWindowFrame, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textWindowFrameDescription .. _tooltip.description

	if MoreBuild.playerCanPlaster then
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
	else
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
	end

	_tooltip:setTexture(_sprite.sprite)

	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 2,
			Text = getItemText("Plank"),
		},

		{
			Material = "Nails",
			Amount = 3,
			Text = getItemText("Nails"),
		},
	}

	MoreBuild.neededTools = {"Hammer"}

	_sprite = {}
	_sprite.sprite = "walls_commercial_03_8"
	_sprite.northSprite = "walls_commercial_03_9"
	_sprite.corner = "walls_commercial_03_3"

	_name = getText "ContextMenu_Brown_Cinder_Block_DoorWindow"

	_option = subMenu[getText "ContextMenu_Brown_Cinder_Block"]:addOption(_name, nil, MoreBuild.onBuildStoneWindowFrame, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.stoneArchitecture, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_zongsezhuanchuangkuangtip" .. _tooltip.description

	if MoreBuild.playerCanPlaster then
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
	else
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
	end

	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "walls_commercial_03_40"
	_sprite.northSprite = "walls_commercial_03_41"
	_sprite.corner = "walls_commercial_03_35"

	_name = getText "ContextMenu_Gray_Cinder_Block_WindowFrame"

	_option = subMenu[getText "ContextMenu_Gray_Cinder_Block"]:addOption(_name, nil, MoreBuild.onBuildStoneWindowFrame, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.stoneArchitecture, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_huisezhuanchuangkuangtip" .. _tooltip.description

	if MoreBuild.playerCanPlaster then
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
	else
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
	end

	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "walls_commercial_01_56"
	_sprite.northSprite = "walls_commercial_01_57"
	_sprite.corner = "walls_commercial_01_51"

	_name = getText "ContextMenu_White_Cinder_Block_WindowFrame"

	_option = subMenu[getText "ContextMenu_White_CinderBlock"]:addOption(_name, nil, MoreBuild.onBuildStoneWindowFrame, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.stoneArchitecture, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_baisezhuanchuangkuangtip" .. _tooltip.description

	if MoreBuild.playerCanPlaster then
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
	else
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
	end

	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "walls_exterior_house_01_12"
	_sprite.northSprite = "walls_exterior_house_01_13"
	_sprite.corner = "walls_exterior_house_01_7"

	_name = getText "ContextMenu_hongzhuanchuangkuang"

	_option = subMenu[getText "ContextMenu_hongzhuanqiang"]:addOption(_name, nil, MoreBuild.onBuildStoneWindowFrame, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.stoneArchitecture, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_hongzhuanchuangkuangtip" .. _tooltip.description

	if MoreBuild.playerCanPlaster then
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
	else
		_tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
	end

	_tooltip:setTexture(_sprite.sprite)
end

MoreBuild.onBuildWoodenWindowFrame = function(ignoreThisArgument, sprite, player, name)
	local _windowFrame = ISWoodenWall:new(sprite.sprite, sprite.northSprite, sprite.corner)

	_windowFrame.canBePlastered = MoreBuild.playerCanPlaster
	_windowFrame.hoppable = true
	_windowFrame.isThumpable = false
	_windowFrame.player = player
	_windowFrame.name = name

	_windowFrame.modData["need:Base.Plank"] = "4"
	_windowFrame.modData["need:Base.Nails"] = "4"
	_windowFrame.modData["xp:Woodwork"] = "5"

	getCell():setDrag(_windowFrame, player)
end


MoreBuild.onBuildStoneWindowFrame = function(ignoreThisArgument, sprite, player, name)
	local _windowFrame = ISWoodenWall:new(sprite.sprite, sprite.northSprite, sprite.corner)

	_windowFrame.canBePlastered = MoreBuild.playerCanPlaster
	_windowFrame.hoppable = true
	_windowFrame.isThumpable = false
	_windowFrame.player = player
	_windowFrame.name = name

	_windowFrame.modData["need:Base.Plank"] = "8"
	_windowFrame.modData["need:Base.Nails"] = "4"
	_windowFrame.modData["xp:Woodwork"] = "5"

	function _windowFrame:getHealth()
		return MoreBuild.healthLevel.stoneWall + buildUtil.getWoodHealth(self)
	end

	MoreBuild.equipToolPrimary(_windowFrame, player, "Trowel")

	getCell():setDrag(_windowFrame, player)
end

MoreBuild.fencesMenuBuilder = function(subMenu, player)
	local _sprite
	local _option
	local _tooltip
	local _name = ""

	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 2,
			Text = getItemText("Plank"),
		},

		{
			Material = "Nails",
			Amount = 3,
			Text = getItemText("Nails"),
		},
	}

	MoreBuild.neededTools = {"Hammer"}

	_sprite = {}
	_sprite.sprite = "location_restaurant_pileocrepe_01_44"
	_sprite.northSprite = "location_restaurant_pileocrepe_01_45"
	_sprite.corner = "location_restaurant_pileocrepe_01_47"

	_name = getText "ContextMenu_Light_BrownWood_Fence"

	_option = subMenu[getText "ContextMenu_Light_BrownWood"]:addOption(_name, nil, MoreBuild.onBuildWoodenFence, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textFenceDescription .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "walls_garage_02_20"
	_sprite.northSprite = "walls_garage_02_21"
	_sprite.corner = "walls_garage_02_23"

	_name = getText "ContextMenu_Gray_Fence_WithRail"

	_option = subMenu[getText "ContextMenu_Gray_Plaster"]:addOption(_name, nil, MoreBuild.onBuildWoodenFence, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textFenceDescription .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "walls_exterior_wooden_01_60"
	_sprite.northSprite = "walls_exterior_wooden_01_61"
	_sprite.corner = "walls_exterior_wooden_01_63"

	_name = getText "ContextMenu_Gray_WoodFence"

	_option = subMenu[getText "ContextMenu_Gray_Wood"]:addOption(_name, nil, MoreBuild.onBuildWoodenFence, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textFenceDescription .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 2,
			Text = getItemText("Plank"),
		},

		{
			Material = "Nails",
			Amount = 3,
			Text = getItemText("Nails"),
		},
	}

	MoreBuild.neededTools = {"Hammer"}

	_sprite = {}
	_sprite.sprite = "walls_commercial_03_4"
	_sprite.northSprite = "walls_commercial_03_5"
	_sprite.corner = "walls_commercial_03_7"

	_name = getText "ContextMenu_Brown_Cinder_BlockFence"

	_option = subMenu[getText "ContextMenu_Brown_Cinder_Block"]:addOption(_name, nil, MoreBuild.onBuildWoodenFence, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.stoneArchitecture, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_zongsezhuanweilantip" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "walls_commercial_03_36"
	_sprite.northSprite = "walls_commercial_03_37"
	_sprite.corner = "walls_commercial_03_38"

	_name = getText "ContextMenu_Gray_Cinder_BlockFence"

	_option = subMenu[getText "ContextMenu_Gray_Cinder_Block"]:addOption(_name, nil, MoreBuild.onBuildWoodenFence, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.stoneArchitecture, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_huisezhuanweilantip" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "walls_commercial_01_52"
	_sprite.northSprite = "walls_commercial_01_53"
	_sprite.corner = "walls_commercial_01_55"

	_name = getText "ContextMenu_White_Cinder_BlockFence"

	_option = subMenu[getText "ContextMenu_White_CinderBlock"]:addOption(_name, nil, MoreBuild.onBuildWoodenFence, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.stoneArchitecture, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_baisezhuanweilan" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "walls_exterior_house_01_36"
	_sprite.northSprite = "walls_exterior_house_01_37"
	_sprite.corner = "walls_exterior_house_01_39"

	_name = getText "ContextMenu_hongzhuanzhalan"

	_option = subMenu[getText "ContextMenu_hongzhuanqiang"]:addOption(_name, nil, MoreBuild.onBuildStoneFence, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.stoneArchitecture, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_hongzhuanzhalantip" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)
end

MoreBuild.onBuildWoodenFence = function(ignoreThisArgument, sprite, player, name)
	local _fence = ISWoodenWall:new(sprite.sprite, sprite.northSprite, sprite.corner)

	_fence.hoppable = true
	_fence.isDestroyed = false
	_fence.player = player
	_fence.name = name

	_fence.modData["need:Base.Plank"] = "2"
	_fence.modData["need:Base.Nails"] = "3"
	_fence.modData["xp:Woodwork"] = "5"

	function _fence:getHealth()
		return MoreBuild.healthLevel.WoodenFence
	end

	getCell():setDrag(_fence, player)
end


MoreBuild.onBuildTestFence = function(ignoreThisArgument, sprite, player, name, worldobjects, item)
	local _Test = ISWoodenWall:new(sprite.sprite, sprite.northSprite, sprite.corner)
	_Test.hoppable = true
	_Test.isThumpable = true
	_Test.canPassThrough = true
	_Test.canBarricade = true
	_Test.thumpDmg = 5
	_Test.player = player
	_Test.name = name

	_Test.modData["need:Base.Plank"] = "1"
	_Test.modData["need:Base.Nails"] = "2"
	_Test.modData["xp:Woodwork"] = "5"

	function _Test:getHealth()
		return MoreBuild.healthLevel.TestFence
	end

	getCell():setDrag(_Test, player)
end

MoreBuild.onSurvivalItem = function(worldobjects, item, time)
	ISTimedActionQueue.add(ISCraftTime:new(getPlayer(), item))
end

MoreBuild.onBuildBarbecue = function(ignoreThisArgument, sprite, player, name)
	local _Barbecue = ISBarbecue:new(sprite.sprite, sprite.northSprite, sprite.corner)
	_Barbecue.player = player
	_Barbecue.name = name

	_Barbecue.modData["need:Base.Plank"] = "2"
	_Barbecue.modData["need:Base.SheetMetal"] = "2"
	_Barbecue.modData["need:Base.Screws"] = "3"
	_Barbecue.modData["xp:Woodwork"] = "5"
	getCell():setDrag(_Barbecue, player)
end

MoreBuild.onBuildGenerator = function(ignoreThisArgument, sprite, player, name)
	local _Generator = ISGenerator:new(sprite.sprite, sprite.northSprite, sprite.corner)
	_Generator.player = player
	_Generator.name = name

	_Generator.modData["need:Radio.ElectricWire"] = "2"
	_Generator.modData["need:Base.Aluminum"] = "10"
	_Generator.modData["need:Base.SheetMetal"] = "4"
	_Generator.modData["need:Base.Screws"] = "10"
	_Generator.modData["need:Base.ElectronicsScrap"] = "100"
	_Generator.modData["xp:Woodwork"] = "10"
	_Generator.modData["xp:Electricity"] = "50"
	getCell():setDrag(_Generator, player)
end

MoreBuild.onBuildWaterWell = function(ignoreThisArgument, sprite, player, name)
	local _WaterWell = ISWaterWell:new(sprite.sprite, sprite.northSprite, sprite.corner)
	_WaterWell.player = player
	_WaterWell.name = name

	_WaterWell.modData["need:Base.Plank"] = "20"
	_WaterWell.modData["need:Base.Nails"] = "10"
	_WaterWell.modData["need:Base.Rope"] = "5"
	_WaterWell.modData["need:Base.Plank"] = "5"
	_WaterWell.modData["need:Base.Gravelbag"] = "2"
	_WaterWell.modData["need:Base.BucketEmpty"] = "1"
	_WaterWell.modData["xp:Woodwork"] = "50"
	getCell():setDrag(_WaterWell, player)
end

MoreBuild.onBuildWaterPipe = function(ignoreThisArgument, sprite, player, name)
	local _WaterPipe = Pipe:new(player, pipeItem, spritea, pipeType)
	_WaterPipe.player = player
	_WaterPipe.name = name

	_WaterPipe.modData["need:Base.Plank"] = "1"
	_WaterPipe.modData["xp:Woodwork"] = "50"
	getCell():setDrag(_WaterPipe, player:getPlayerNum())
end

MoreBuild.onBuildfridge = function(ignoreThisArgument, sprite, player, name, icon)
	local _fridge = ISWoodenContainer:new(sprite.sprite, sprite.northSprite)

	_fridge.renderFloorHelper = false
	_fridge.canBeAlwaysPlaced = false
	_fridge.canBeLockedByPadlock = true
	_fridge.player = player
	_fridge.name = name

	if sprite.eastSprite then
		_fridge:setEastSprite(sprite.eastSprite)
	end

	if sprite.southSprite then
		_fridge:setSouthSprite(sprite.southSprite)
	end

	_fridge.modData["need:Base.SheetMetal"] = "4"
	_fridge.modData["need:Base.Screws"] = "5"
	_fridge.modData["need:Radio.ElectricWire"] = "2"
    _fridge.modData["need:Base.ElectronicsScrap"] = "10"
	_fridge.modData["xp:Woodwork"] = "30"
	_fridge.modData["xp:Electricity"] = "5"

	MoreBuild.equipToolPrimary(_fridge, player, "Screwdriver")

	function _fridge:getHealth()
		self.javaObject:getContainer():setType(icon)
		return MoreBuild.healthLevel.metalContainer + buildUtil.getWoodHealth(self)
	end

	getCell():setDrag(_fridge, player)
end

MoreBuild.onBuildStove = function(ignoreThisArgument, sprite, player, name)
	local _stove = ISStove:new(sprite.sprite, sprite.sprite, getSpecificPlayer(player))
	
	_stove.player = player
	_stove.name = name

	_stove:setSprite('appliances_cooking_01_16')
	_stove:setNorthSprite('appliances_cooking_01_17')

	_stove.modData["need:Base.SheetMetal"] = "6"
	_stove.modData["need:Base.Nails"] = "20"
	_stove.modData["need:Base.Screws"] = "10"
	_stove.modData["xp:Woodwork"] = "15"

	getCell():setDrag(_stove, player)
end

MoreBuild.onBuildStoneFence = function(ignoreThisArgument, sprite, player, name)
	local _fence = ISWoodenWall:new(sprite.sprite, sprite.northSprite, sprite.corner)

	_fence.hoppable = true
	_fence.isThumpable = false
	_fence.canBarricade = true
	_fence.player = player
	_fence.name = name

	_fence.modData["need:Base.Plank"] = "4"
	_fence.modData["need:Base.Nails"] = "3"
	_fence.modData["xp:Woodwork"] = "5"

	function _fence:getHealth()
		return MoreBuild.healthLevel.stoneWall + buildUtil.getWoodHealth(self)
	end

	MoreBuild.equipToolPrimary(_fence, player, "Trowel")

	getCell():setDrag(_fence, player)
end


MoreBuild.onBuildMetalFence = function(ignoreThisArgument, sprite, player, name)
	local _fence = ISWoodenWall:new(sprite.sprite, sprite.northSprite, sprite.corner)

	_fence.hoppable = false
	_fence.isThumpable = true
	_fence.player = player
	_fence.name = name

	_fence.modData["need:Base.SheetMetal"] = "2"
	_fence.modData["need:Base.Screws"] = "3"
	_fence.modData["xp:Woodwork"] = "5"

	function _fence:getHealth()
		return MoreBuild.healthLevel.metalWall + buildUtil.getWoodHealth(self)
	end

	MoreBuild.equipToolPrimary(_fence, player, "Screwdriver")

	getCell():setDrag(_fence, player)
end

MoreBuild.fencePostsMenuBuilder = function(subMenu, player)
	local _sprite
	local _option
	local _tooltip
	local _name = ""

	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 1,
			Text = getItemText("Plank"),
		},

		{
			Material = "Nails",
			Amount = 2,
			Text = getItemText("Nails"),
		},
	}

	MoreBuild.neededTools = {"Hammer"}

	_sprite = {}
	_sprite.sprite = "location_restaurant_pileocrepe_01_47"
	_sprite.northSprite = "location_restaurant_pileocrepe_01_47"

	_name = getText "ContextMenu_Light_BrownWood_FencePost"

	_option = subMenu[getText "ContextMenu_Light_BrownWood"]:addOption(_name, nil, MoreBuild.onBuildWoodenFencePost, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textFencePostDescription .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "walls_garage_02_23"
	_sprite.northSprite = "walls_garage_02_23"

	_name = getText "ContextMenu_Gray_Plaster_FencePost"

	_option = subMenu[getText "ContextMenu_Gray_Plaster"]:addOption(_name, nil, MoreBuild.onBuildWoodenFencePost, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textFencePostDescription .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "walls_exterior_wooden_01_63"
	_sprite.northSprite = "walls_exterior_wooden_01_63"

	_name = getText "ContextMenu_Gray_Wood_FencePost"

	_option = subMenu[getText "ContextMenu_Gray_Wood"]:addOption(_name, nil, MoreBuild.onBuildWoodenFencePost, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textFencePostDescription .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 2,
			Text = getItemText("Plank"),
		},

		{
			Material = "Nails",
			Amount = 3,
			Text = getItemText("Nails"),
		},
	}

	MoreBuild.neededTools = {"Hammer"}

	_sprite = {}
	_sprite.sprite = "walls_commercial_03_7"
	_sprite.northSprite = "walls_commercial_03_7"

	_name = getText "ContextMenu_Brown_Cinder_Block_FencePost"

	_option = subMenu[getText "ContextMenu_Brown_Cinder_Block"]:addOption(_name, nil, MoreBuild.onBuildStoneFencePost, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.stoneArchitecture, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_zongsezhalanzhuangtip" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "walls_commercial_03_39"
	_sprite.northSprite = "walls_commercial_03_39"

	_name = getText "ContextMenu_Gray_Cinder_Block_FencePost"

	_option = subMenu[getText "ContextMenu_Gray_Cinder_Block"]:addOption(_name, nil, MoreBuild.onBuildStoneFencePost, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.stoneArchitecture, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_huisezhuanlibatip" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "walls_commercial_01_55"
	_sprite.northSprite = "walls_commercial_01_55"

	_name = getText "ContextMenu_White_Cinder_Block_FencePost"

	_option = subMenu[getText "ContextMenu_White_CinderBlock"]:addOption(_name, nil, MoreBuild.onBuildStoneFencePost, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.stoneArchitecture, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_baisezhuanzhutip" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "walls_exterior_house_01_39"
	_sprite.northSprite = "walls_exterior_house_01_39"

	_name = getText "ContextMenu_hongzhuanweiqiangzhu"

	_option = subMenu[getText "ContextMenu_hongzhuanqiang"]:addOption(_name, nil, MoreBuild.onBuildStoneFencePost, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.stoneArchitecture, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_hongzhuanweiqiangzhutip" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)
end

MoreBuild.onBuildWoodenFencePost = function(ignoreThisArgument, sprite, player, name)
	local _fencePost = ISWoodenWall:new(sprite.sprite, sprite.northSprite, nil)

	_fencePost.canPassThrough = true
	_fencePost.canBarricade = false
	_fencePost.player = player
	_fencePost.name = name

	_fencePost.modData["need:Base.Plank"] = "1"
	_fencePost.modData["need:Base.Nails"] = "2"
	_fencePost.modData["xp:Woodwork"] = "5"

	getCell():setDrag(_fencePost, player)
end

MoreBuild.onBuildStoneFencePost = function(ignoreThisArgument, sprite, player, name)
	local _fencePost = ISWoodenWall:new(sprite.sprite, sprite.northSprite, nil)

	_fencePost.canPassThrough = true
	_fencePost.canBarricade = false
	_fencePost.player = player
	_fencePost.name = name

	_fencePost.modData["need:Base.Plank"] = "2"
	_fencePost.modData["need:Base.Nails"] = "2"
	_fencePost.modData["xp:Woodwork"] = "5"

	function _fencePost:getHealth()
		return MoreBuild.healthLevel.stoneWall + buildUtil.getWoodHealth(self)
	end

	MoreBuild.equipToolPrimary(_fencePost, player, "Trowel")

	getCell():setDrag(_fencePost, player)
end

MoreBuild.onBuildMetalFencePost = function(ignoreThisArgument, sprite, player, name)
	local _fencePost = ISWoodenWall:new(sprite.sprite, sprite.northSprite, nil)

	_fencePost.hoppable = false
	_fencePost.isThumpable = true
	_fencePost.canBarricade = true
	_fencePost.player = player
	_fencePost.name = name

	_fencePost.modData["need:Base.SheetMetal"] = "1"
	_fencePost.modData["need:Base.Screws"] = "2"
	_fencePost.modData["xp:Woodwork"] = "5"

	function _fencePost:getHealth()
		return MoreBuild.healthLevel.metalWall + buildUtil.getWoodHealth(self)
	end

	MoreBuild.equipToolPrimary(_fencePost, player, "Screwdriver")

	getCell():setDrag(_fencePost, player)
end

MoreBuild.doorsMenuBuilder = function(subMenu, player, context, worldobjects)
	local _woodenDoorsOption = subMenu:addOption(getText "ContextMenu_mumen", worldobjects, nil)
	local _woodenDoorsSubMenu = subMenu:getNew(subMenu)

	context:addSubMenu(_woodenDoorsOption, _woodenDoorsSubMenu)
	MoreBuild.woodenDoorsMenuBuilder(_woodenDoorsSubMenu, player)

	local _panelDoorsOption = subMenu:addOption(getText "ContextMenu_mianbanmen", worldobjects, nil)
	local _panelDoorsSubMenu = subMenu:getNew(subMenu)

	context:addSubMenu(_panelDoorsOption, _panelDoorsSubMenu)
	MoreBuild.panelDoorsMenuBuilder(_panelDoorsSubMenu, player)

	local _industrialDoorsOption = subMenu:addOption(getText "ContextMenu_gongyemen", worldobjects, nil)
	local _industrialDoorsSubMenu = subMenu:getNew(subMenu)

	context:addSubMenu(_industrialDoorsOption, _industrialDoorsSubMenu)
	MoreBuild.industrialDoorsMenuBuilder(_industrialDoorsSubMenu, player)

	local _exteriorDoorsOption = subMenu:addOption(getText "ContextMenu_waibumen", worldobjects, nil)
	local _exteriorDoorsSubMenu = subMenu:getNew(subMenu)

	context:addSubMenu(_exteriorDoorsOption, _exteriorDoorsSubMenu)
	MoreBuild.exteriorDoorsMenuBuilder(_exteriorDoorsSubMenu, player)

	local _LowDoorsOption = subMenu:addOption(getText "ContextMenu_Low_Door", worldobjects, nil)
	local _LowDoorsSubMenu = subMenu:getNew(subMenu)

	context:addSubMenu(_LowDoorsOption, _LowDoorsSubMenu)
	MoreBuild.lowDoorsMenuBuilder(_LowDoorsSubMenu, player)

	local _otherDoorsOption = subMenu:addOption(getText "ContextMenu_qitamen", worldobjects, nil)
	local _otherDoorsSubMenu = subMenu:getNew(subMenu)

	context:addSubMenu(_otherDoorsOption, _otherDoorsSubMenu)
	MoreBuild.otherDoorsMenuBuilder(_otherDoorsSubMenu, player)
end

MoreBuild.woodenDoorsMenuBuilder = function(subMenu, player)
	local _sprite
	local _option
	local _tooltip
	local _name = ""

	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 4,
			Text = getItemText("Plank"),
		},

		{
			Material = "Nails",
			Amount = 4,
			Text = getItemText("Nails"),
		},

		{
			Material = "Doorknob",
			Amount = 1,
			Text = getItemText("Doorknob"),
		},

		{
			Material = "Hinge",
			Amount = 2,
			Text = getItemText("Door Hinge"),
		},
	}

	MoreBuild.neededTools = {"Hammer"}

	_sprite = {}
	_sprite.sprite = "fixtures_doors_02_0"
	_sprite.northSprite = "fixtures_doors_02_1"
	_sprite.openSprite = "fixtures_doors_02_2"
	_sprite.openNorthSprite = "fixtures_doors_02_3"

	_name = getText "ContextMenu_lansemumen"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textDoorGeneric .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "fixtures_doors_01_4"
	_sprite.northSprite = "fixtures_doors_01_5"
	_sprite.openSprite = "fixtures_doors_01_6"
	_sprite.openNorthSprite = "fixtures_doors_01_7"

	_name = getText "ContextMenu_zongsemumen"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textDoorGeneric .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "fixtures_doors_01_12"
	_sprite.northSprite = "fixtures_doors_01_13"
	_sprite.openSprite = "fixtures_doors_01_14"
	_sprite.openNorthSprite = "fixtures_doors_01_15"

	_name = getText "ContextMenu_shenzongsemumen"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textDoorGeneric .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "location_community_church_small_01_64"
	_sprite.northSprite = "location_community_church_small_01_65"
	_sprite.openSprite = "location_community_church_small_01_66"
	_sprite.openNorthSprite = "location_community_church_small_01_67"

	_name = getText "ContextMenu_huashizongsemen"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textDoorGeneric .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "fixtures_doors_01_0"
	_sprite.northSprite = "fixtures_doors_01_1"
	_sprite.openSprite = "fixtures_doors_01_2"
	_sprite.openNorthSprite = "fixtures_doors_01_3"

	_name = getText "ContextMenu_baisemuzhimen"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textDoorGeneric .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)
end

MoreBuild.panelDoorsMenuBuilder = function(subMenu, player)
	local _sprite
	local _option
	local _tooltip
	local _name = ""

	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 4,
			Text = getItemText("Plank"),
		},

		{
			Material = "Nails",
			Amount = 4,
			Text = getItemText("Nails"),
		},

		{
			Material = "Doorknob",
			Amount = 1,
			Text = getItemText("Doorknob"),
		},

		{
			Material = "Hinge",
			Amount = 2,
			Text = getItemText("Door Hinge"),
		},
	}

	MoreBuild.neededTools = {"Hammer"}

	_sprite = {}
	_sprite.sprite = "fixtures_doors_02_16"
	_sprite.northSprite = "fixtures_doors_02_17"
	_sprite.openSprite = "fixtures_doors_02_18"
	_sprite.openNorthSprite = "fixtures_doors_02_19"

	_name = getText "ContextMenu_zongsemianbanmen"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_zongsemianbanmentip" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "fixtures_doors_02_24"
	_sprite.northSprite = "fixtures_doors_02_25"
	_sprite.openSprite = "fixtures_doors_02_26"
	_sprite.openNorthSprite = "fixtures_doors_02_27"

	_name = getText "ContextMenu_huisemianbanmen"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_zongsemianbanmentip" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "fixtures_doors_02_20"
	_sprite.northSprite = "fixtures_doors_02_21"
	_sprite.openSprite = "fixtures_doors_02_22"
	_sprite.openNorthSprite = "fixtures_doors_02_23"

	_name = getText "ContextMenu_baisemianbanmen"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_zongsemianbanmentip" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)
end

MoreBuild.industrialDoorsMenuBuilder = function(subMenu, player)
	local _sprite
	local _option
	local _tooltip
	local _name = ""

	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 4,
			Text = getItemText("Plank"),
		},

		{
			Material = "Nails",
			Amount = 4,
			Text = getItemText("Nails"),
		},

		{
			Material = "Doorknob",
			Amount = 1,
			Text = getItemText("Doorknob"),
		},

		{
			Material = "Hinge",
			Amount = 2,
			Text = getItemText("Door Hinge"),
		},
	}

	MoreBuild.neededTools = {"Hammer"}

	_sprite = {}
	_sprite.sprite = "fixtures_doors_02_12"
	_sprite.northSprite = "fixtures_doors_02_13"
	_sprite.openSprite = "fixtures_doors_02_14"
	_sprite.openNorthSprite = "fixtures_doors_02_15"

	_name = getText "ContextMenu_heisegongyemen"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textDoorIndustrial .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "fixtures_doors_01_24"
	_sprite.northSprite = "fixtures_doors_01_25"
	_sprite.openSprite = "fixtures_doors_01_26"
	_sprite.openNorthSprite = "fixtures_doors_01_27"

	_name = getText "ContextMenu_lansegongyemen"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textDoorIndustrial .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "location_restaurant_pizzawhirled_01_60"
	_sprite.northSprite = "location_restaurant_pizzawhirled_01_61"
	_sprite.openSprite = "location_restaurant_pizzawhirled_01_62"
	_sprite.openNorthSprite = "location_restaurant_pizzawhirled_01_63"

	_name = getText "ContextMenu_lvsegongyemen"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textDoorIndustrial .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "location_restaurant_pileocrepe_01_52"
	_sprite.northSprite = "location_restaurant_pileocrepe_01_53"
	_sprite.openSprite = "location_restaurant_pileocrepe_01_54"
	_sprite.openNorthSprite = "location_restaurant_pileocrepe_01_55"

	_name = getText "ContextMenu_chengsegongyemen"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textDoorIndustrial .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "fixtures_doors_02_8"
	_sprite.northSprite = "fixtures_doors_02_9"
	_sprite.openSprite = "fixtures_doors_02_10"
	_sprite.openNorthSprite = "fixtures_doors_02_11"

	_name = getText "ContextMenu_hongsegongyemen"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textDoorIndustrial .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "fixtures_doors_01_60"
	_sprite.northSprite = "fixtures_doors_01_61"
	_sprite.openSprite = "fixtures_doors_01_62"
	_sprite.openNorthSprite = "fixtures_doors_01_63"

	_name = getText "ContextMenu_baisegongyemen"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textDoorIndustrial .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)
end

MoreBuild.exteriorDoorsMenuBuilder = function(subMenu, player)
	local _sprite
	local _option
	local _tooltip
	local _name = ""

	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 4,
			Text = getItemText("Plank"),
		},

		{
			Material = "Nails",
			Amount = 4,
			Text = getItemText("Nails"),
		},

		{
			Material = "Doorknob",
			Amount = 1,
			Text = getItemText("Doorknob"),
		},

		{
			Material = "Hinge",
			Amount = 2,
			Text = getItemText("Door Hinge"),
		},
	}

	MoreBuild.neededTools = {"Hammer"}

	_sprite = {}
	_sprite.sprite = "fixtures_doors_01_56"
	_sprite.northSprite = "fixtures_doors_01_57"
	_sprite.openSprite = "fixtures_doors_01_58"
	_sprite.openNorthSprite = "fixtures_doors_01_59"

	_name = getText "ContextMenu_misewaibumen"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textDoorExterior .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "fixtures_doors_01_52"
	_sprite.northSprite = "fixtures_doors_01_53"
	_sprite.openSprite = "fixtures_doors_01_54"
	_sprite.openNorthSprite = "fixtures_doors_01_55"

	_name = getText "ContextMenu_huisewaibumen"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textDoorExterior .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "fixtures_doors_01_64"
	_sprite.northSprite = "fixtures_doors_01_65"
	_sprite.openSprite = "fixtures_doors_01_66"
	_sprite.openNorthSprite = "fixtures_doors_01_67"

	_name = getText "ContextMenu_chengsewaibumen"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textDoorExterior .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)
end

MoreBuild.otherDoorsMenuBuilder = function(subMenu, player)
	local _sprite
	local _option
	local _tooltip
	local _name = ""

	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 4,
			Text = getItemText("Plank"),
		},

		{
			Material = "Nails",
			Amount = 4,
			Text = getItemText("Nails"),
		},

		{
			Material = "Doorknob",
			Amount = 1,
			Text = getItemText("Doorknob"),
		},

		{
			Material = "Hinge",
			Amount = 2,
			Text = getItemText("Door Hinge"),
		},
	}

	MoreBuild.neededTools = {"Hammer"}

	_sprite = {}
	_sprite.sprite = "fixtures_doors_01_28"
	_sprite.northSprite = "fixtures_doors_01_29"
	_sprite.openSprite = "fixtures_doors_01_30"
	_sprite.openNorthSprite = "fixtures_doors_01_31"

	_name = getText "ContextMenu_chuchaodemutoumen"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_chuchaotip" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "fixtures_doors_fences_01_12"
	_sprite.northSprite = "fixtures_doors_fences_01_13"
	_sprite.openSprite = "fixtures_doors_fences_01_14"
	_sprite.openNorthSprite = "fixtures_doors_fences_01_15"

	_name = getText "ContextMenu_mubaomen"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_mubaomen" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "location_restaurant_spiffos_01_52"
	_sprite.northSprite = "location_restaurant_spiffos_01_53"
	_sprite.openSprite = "location_restaurant_spiffos_01_54"
	_sprite.openNorthSprite = "location_restaurant_spiffos_01_55"

	_name = getText "ContextMenu_Spiffo"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_Spiffo" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "fixtures_bathroom_02_26"
	_sprite.northSprite = "fixtures_bathroom_02_27"
	_sprite.openSprite = "fixtures_bathroom_02_28"
	_sprite.openNorthSprite = "fixtures_bathroom_02_29"

	_name = getText "ContextMenu_cesuomen"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_cesuomentip" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)
end

MoreBuild.lowDoorsMenuBuilder = function(subMenu, player)
	local _sprite
	local _option
	local _tooltip
	local _name = ""

	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 1,
			Text = getItemText("Plank"),
		},

		{
			Material = "Nails",
			Amount = 1,
			Text = getItemText("Nails"),
		},
	}

	MoreBuild.neededTools = {"Hammer"}

	_sprite = {}
	_sprite.sprite = "fixtures_doors_frames_01_0"
	_sprite.northSprite = "fixtures_doors_frames_01_1"
	_sprite.corner = ""

	_name = getText "ContextMenu_Low_DoorFrame"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildLowDoorFrame, _sprite, player, _name)
	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_lowDoorFrametip" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 4,
			Text = getItemText("Plank"),
		},

		{
			Material = "Nails",
			Amount = 4,
			Text = getItemText("Nails"),
		},

		{
			Material = "Doorknob",
			Amount = 1,
			Text = getItemText("Doorknob"),
		},

		{
			Material = "Hinge",
			Amount = 2,
			Text = getItemText("Door Hinge"),
		},
	}

	MoreBuild.neededTools = {"Hammer"}

	_sprite = {}
	_sprite.sprite = "fixtures_doors_fences_01_4"
	_sprite.northSprite = "fixtures_doors_fences_01_5"
	_sprite.openSprite = "fixtures_doors_fences_01_6"
	_sprite.openNorthSprite = "fixtures_doors_fences_01_7"

	_name = getText "ContextMenu_LowWoodendoor"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_LowWoodendoortip" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "fixtures_doors_fences_01_8"
	_sprite.northSprite = "fixtures_doors_fences_01_9"
	_sprite.openSprite = "fixtures_doors_fences_01_10"
	_sprite.openNorthSprite = "fixtures_doors_fences_01_11"

	_name = getText "ContextMenu_WhiteLowWoodendoor"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_WhiteLowWoodendoortip" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	MoreBuild.neededMaterials =
	{
		{
			Material = "Wire",
			Amount = 4,
			Text = getItemText("Wire"),
		},

		{
			Material = "Nails",
			Amount = 4,
			Text = getItemText("Nails"),
		},

		{
			Material = "Doorknob",
			Amount = 1,
			Text = getItemText("Doorknob"),
		},

		{
			Material = "Hinge",
			Amount = 2,
			Text = getItemText("Door Hinge"),
		},
	}

	MoreBuild.neededTools = {"Hammer"}

	_sprite = {}
	_sprite.sprite = "fixtures_doors_fences_01_16"
	_sprite.northSprite = "fixtures_doors_fences_01_17"
	_sprite.openSprite = "fixtures_doors_fences_01_18"
	_sprite.openNorthSprite = "fixtures_doors_fences_01_19"

	_name = getText "ContextMenu_MetalLowdoor"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildLowdoorframe, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_MetalLowdoorotip" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)
end

MoreBuild.onBuildWoodenDoor = function(ignoreThisArgument, sprite, player, name)
	local _door = ISWoodenDoor:new(sprite.sprite, sprite.northSprite, sprite.openSprite, sprite.openNorthSprite)

	_door.player = player
	_door.name = name

	_door.modData["need:Base.Plank"] = "4"
	_door.modData["need:Base.Nails"] = "4"
	_door.modData["need:Base.Hinge"] = "2"
	_door.modData["need:Base.Doorknob"] = "1"
	_door.modData["xp:Woodwork"] = "5"

	local _knob = getSpecificPlayer(player):getInventory():FindAndReturn("Base.Doorknob")
	if _knob and _knob:getKeyId() ~= -1 then
		_door.keyId = _knob:getKeyId()
	end

	getCell():setDrag(_door, player)
end

MoreBuild.onBuildLowdoorframe = function(ignoreThisArgument, sprite, player, name)
	local _lowdoorframe = ISWoodenDoor:new(sprite.sprite, sprite.northSprite, sprite.openSprite, sprite.openNorthSprite)

	_lowdoorframe.player = player
	_lowdoorframe.name = name

	_lowdoorframe.modData["need:Base.Wire"] = "4"
	_lowdoorframe.modData["need:Base.Nails"] = "4"
	_lowdoorframe.modData["need:Base.Hinge"] = "1"
	_lowdoorframe.modData["need:Base.Doorknob"] = "2"
	_lowdoorframe.modData["xp:Woodwork"] = "5"

	local _knob = getSpecificPlayer(player):getInventory():FindAndReturn("Base.Doorknob")
	if _knob and _knob:getKeyId() ~= -1 then
		_lowdoorframe.keyId = _knob:getKeyId()
	end

	getCell():setDrag(_lowdoorframe, player)
end

MoreBuild.moreFencesMenuBuilder = function(subMenu, player)
	local _sprite
	local _option
	local _tooltip
	local _name = ""


	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 2,
			Text = getItemText("Plank"),
		},

		{
			Material = "Nails",
			Amount = 3,
			Text = getItemText("Nails"),
		},
	}

	MoreBuild.neededTools = {"Hammer"}

	_sprite = {}
	_sprite.sprite = "fencing_01_4"
	_sprite.northSprite = "fencing_01_5"
	_sprite.corner = "fencing_01_7"

	_name = getText "ContextMenu_baisezhalan"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenFence, _sprite, player)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_baisezhanlantip" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "fixtures_railings_01_112"
	_sprite.northSprite = "fixtures_railings_01_113"
	_sprite.corner = "fixtures_railings_01_115"

	_name = getText "ContextMenu_misezhalan"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenFence, _sprite, player)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_misezhalantip" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "fixtures_railings_01_116"
	_sprite.northSprite = "fixtures_railings_01_117"
	_sprite.corner = "fixtures_railings_01_119"

	_name = getText "ContextMenu_Gray_Fence_WithRail"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenFence, _sprite, player)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_misezhalantip" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)


	MoreBuild.neededMaterials =
	{
		{
			Material = "SheetMetal",
			Amount = 2,
			Text = getItemText("Sheet Metal"),
		},

		{
			Material = "Screws",
			Amount = 3,
			Text = getItemText("Screws"),
		},
	}

	MoreBuild.neededTools = { "Screwdriver", }

	_sprite = {}
	_sprite.sprite = "industry_railroad_05_40"
	_sprite.northSprite = "industry_railroad_05_41"
	_sprite.corner = "industry_railroad_05_43"

	_name = getText "ContextMenu_zhalan1"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildMetalFence, _sprite, player)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.metalArchitecture, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_zhalan1tip" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "industry_bunker_01_24"
	_sprite.northSprite = "industry_bunker_01_25"
	_sprite.corner = "industry_bunker_01_27"

	_name = getText "ContextMenu_hongsejinshuzhalan"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenPillar, _sprite, player)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.metalArchitecture, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_zhalan1tip" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)



	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 2,
			Text = getItemText("Plank"),
		},

		{
			Material = "Nails",
			Amount = 3,
			Text = getItemText("Nails"),
		},
	}

	MoreBuild.neededTools = {"Hammer"}

	_sprite = {}
	_sprite.sprite = "construction_01_0"
	_sprite.northSprite = "construction_01_1"
	_sprite.corner = "construction_01_3"

	_name = getText "ContextMenu_zhuanhuilan"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildStoneFence, _sprite, player)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.stoneArchitecture, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_zhuanhuilan" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)
end

MoreBuild.moreFencePostsMenuBuilder = function(subMenu, player)
	local _sprite
	local _option
	local _tooltip
	local _name = ""


	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 1,
			Text = getItemText("Plank"),
		},

		{
			Material = "Nails",
			Amount = 2,
			Text = getItemText("Nails"),
		},
	}

	MoreBuild.neededTools = {"Hammer"}

	_sprite = {}
	_sprite.sprite = "fencing_01_7"
	_sprite.northSprite = "fencing_01_7"

	_name = getText "ContextMenu_baisezhanlanzhu"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenFencePost, _sprite, player)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_zhalan1tip" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "fixtures_railings_01_115"
	_sprite.northSprite = "fixtures_railings_01_115"

	_name = getText "ContextMenu_miseweilanzhu"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenFencePost, _sprite, player)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_miseweilanzhutip" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "fixtures_railings_01_119"
	_sprite.northSprite = "fixtures_railings_01_119"

	_name = getText "ContextMenu_huiselibazhu"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenFencePost, _sprite, player)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_miseweilanzhutip" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)



	MoreBuild.neededMaterials =
	{
		{
			Material = "SheetMetal",
			Amount = 1,
			Text = getItemText("Sheet Metal"),
		},

		{
			Material = "Screws",
			Amount = 2,
			Text = getItemText("Screws"),
		},
	}

	MoreBuild.neededTools = { "Screwdriver", }

	_sprite = {}
	_sprite.sprite = "industry_railroad_05_43"
	_sprite.northSprite = "industry_railroad_05_43"

	_name = getText "ContextMenu_lvsejinshuzhalan"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildStoneFence, _sprite, player)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.metalArchitecture, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_lvsejinshuzhanlantip" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "industry_bunker_01_27"
	_sprite.northSprite = "industry_bunker_01_27"

	_name = getText "ContextMenu_hongsejinshuzhalan"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildStoneFence, _sprite, player)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.metalArchitecture, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_lvsejinshuzhanlantip" .. _tooltip.description


	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 2,
			Text = getItemText("Plank"),
		},

		{
			Material = "Nails",
			Amount = 3,
			Text = getItemText("Nails"),
		},
	}

	MoreBuild.neededTools = {"Hammer"}

	_sprite = {}
	_sprite.sprite = "construction_01_3"
	_sprite.northSprite = "construction_01_3"

	_name = getText "ContextMenu_zhuanweiqiangzhu"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildStoneFencePost, _sprite, player)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.stoneArchitecture, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_zhuanweiqiangzhutip" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)
end

MoreBuild.stairsMenuBuilder = function(subMenu, player)
	local _sprite
	local _option
	local _tooltip
	local _name = ""

	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 8,
			Text = getItemText("Plank"),
		},

		{
			Material = "Nails",
			Amount = 8,
			Text = getItemText("Nails"),
		},
	}

	MoreBuild.neededTools = {"Hammer"}

	_sprite = {}
	_sprite.upToLeft01 = "fixtures_stairs_01_64"
	_sprite.upToLeft02 = "fixtures_stairs_01_65"
	_sprite.upToLeft03 = "fixtures_stairs_01_66"
	_sprite.upToRight01 = "fixtures_stairs_01_72"
	_sprite.upToRight02 = "fixtures_stairs_01_73"
	_sprite.upToRight03 = "fixtures_stairs_01_74"
	_sprite.pillar = "fixtures_stairs_01_70"
	_sprite.pillarNorth = "fixtures_stairs_01_70"

	_name = getText "ContextMenu_louti"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenStairs, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.stairsObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textStairsDescription .. _tooltip.description
	_tooltip:setTexture(_sprite.upToLeft01)

	_sprite = {}
	_sprite.upToLeft01 = "fixtures_stairs_01_32"
	_sprite.upToLeft02 = "fixtures_stairs_01_33"
	_sprite.upToLeft03 = "fixtures_stairs_01_34"
	_sprite.upToRight01 = "fixtures_stairs_01_40"
	_sprite.upToRight02 = "fixtures_stairs_01_41"
	_sprite.upToRight03 = "fixtures_stairs_01_42"
	_sprite.pillar = "fixtures_stairs_01_38"
	_sprite.pillarNorth = "fixtures_stairs_01_39"

	_name = getText "ContextMenu_louti1"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenStairs, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.complexArchitecture, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textStairsDescription .. _tooltip.description
	_tooltip:setTexture(_sprite.upToLeft01)

	_sprite = {}
	_sprite.upToLeft01 = "fixtures_stairs_01_16"
	_sprite.upToLeft02 = "fixtures_stairs_01_17"
	_sprite.upToLeft03 = "fixtures_stairs_01_18"
	_sprite.upToRight01 = "fixtures_stairs_01_24"
	_sprite.upToRight02 = "fixtures_stairs_01_25"
	_sprite.upToRight03 = "fixtures_stairs_01_26"
	_sprite.pillar = "fixtures_stairs_01_22"
	_sprite.pillarNorth = "fixtures_stairs_01_23"

	_name = getText "ContextMenu_louti2"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenStairs, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.complexArchitecture, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textStairsDescription .. _tooltip.description
	_tooltip:setTexture(_sprite.upToLeft01)

	_sprite = {}
	_sprite.upToLeft01 = "location_hospitality_sunstarmotel_01_40"
	_sprite.upToLeft02 = "location_hospitality_sunstarmotel_01_41"
	_sprite.upToLeft03 = "location_hospitality_sunstarmotel_01_42"
	_sprite.upToRight01 = "location_hospitality_sunstarmotel_01_48"
	_sprite.upToRight02 = "location_hospitality_sunstarmotel_01_49"
	_sprite.upToRight03 = "location_hospitality_sunstarmotel_01_50"
	_sprite.pillar = "location_hospitality_sunstarmotel_01_43"
	_sprite.pillarNorth = "location_hospitality_sunstarmotel_01_51"

	_name = getText "ContextMenu_louti3"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenStairs, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.stairsObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textStairsDescription .. _tooltip.description
	_tooltip:setTexture(_sprite.upToLeft01)

	_sprite = {}
	_sprite.upToLeft01 = "fixtures_stairs_01_48"
	_sprite.upToLeft02 = "fixtures_stairs_01_49"
	_sprite.upToLeft03 = "fixtures_stairs_01_50"
	_sprite.upToRight01 = "fixtures_stairs_01_56"
	_sprite.upToRight02 = "fixtures_stairs_01_57"
	_sprite.upToRight03 = "fixtures_stairs_01_58"
	_sprite.pillar = "location_hospitality_sunstarmotel_01_43"
	_sprite.pillarNorth = "location_hospitality_sunstarmotel_01_51"

	_name = getText "ContextMenu_louti4"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenStairs, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.stairsObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textStairsDescription .. _tooltip.description
	_tooltip:setTexture(_sprite.upToLeft01)

	_sprite = {}
	_sprite.upToLeft01 = "fixtures_stairs_01_19"
	_sprite.upToLeft02 = "fixtures_stairs_01_20"
	_sprite.upToLeft03 = "fixtures_stairs_01_21"
	_sprite.upToRight01 = "fixtures_stairs_01_27"
	_sprite.upToRight02 = "fixtures_stairs_01_28"
	_sprite.upToRight03 = "fixtures_stairs_01_29"
	_sprite.pillar = "fixtures_stairs_01_30"
	_sprite.pillarNorth = "fixtures_stairs_01_31"

	_name = getText "ContextMenu_louti5"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenStairs, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.stairsObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textStairsDescription .. _tooltip.description
	_tooltip:setTexture(_sprite.upToLeft01)



	MoreBuild.neededMaterials =
	{
		{
			Material = "SheetMetal",
			Amount = 4,
			Text = getItemText("Sheet Metal"),
		},

		{
			Material = "Screws",
			Amount = 8,
			Text = getItemText("Screws"),
		},
	}

	MoreBuild.neededTools = { "Screwdriver", }

	_sprite = {}
	_sprite.upToLeft01 = "fixtures_stairs_01_3"
	_sprite.upToLeft02 = "fixtures_stairs_01_4"
	_sprite.upToLeft03 = "fixtures_stairs_01_5"
	_sprite.upToRight01 = "fixtures_stairs_01_11"
	_sprite.upToRight02 = "fixtures_stairs_01_12"
	_sprite.upToRight03 = "fixtures_stairs_01_13"
	_sprite.pillar = "fixtures_stairs_01_14"
	_sprite.pillarNorth = "fixtures_stairs_01_14"

	_name = getText "ContextMenu_louti6"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildMetalStairs, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.stairsObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = MoreBuild.textStairsDescription .. _tooltip.description
	_tooltip:setTexture(_sprite.upToLeft01)
end

MoreBuild.onBuildWoodenStairs = function(ignoreThisArgument, sprite, player, name)
	local _stairs = ISWoodenStairs:new(sprite.upToLeft01, sprite.upToLeft02, sprite.upToLeft03, sprite.upToRight01, sprite.upToRight02, sprite.upToRight03, sprite.pillar, sprite.pillarNorth)

	_stairs.isThumpable = false
	_stairs.player = player
	_stairs.name = name

	_stairs.modData["need:Base.Plank"] = "8"
	_stairs.modData["need:Base.Nails"] = "8"
	_stairs.modData["xp:Woodwork"] = "5"

	getCell():setDrag(_stairs, player)
end


MoreBuild.onBuildMetalStairs = function(ignoreThisArgument, sprite, player, name)
	local _stairs = ISWoodenStairs:new(sprite.upToLeft01, sprite.upToLeft02, sprite.upToLeft03, sprite.upToRight01, sprite.upToRight02, sprite.upToRight03, sprite.pillar, sprite.pillarNorth)

	_stairs.isThumpable = false
	_stairs.player = player
	_stairs.name = name

	_stairs.modData["need:Base.SheetMetal"] = "4"
	_stairs.modData["need:Base.Screws"] = "8"
	_stairs.modData["xp:Woodwork"] = "5"

	function _stairs:getHealth()
		return MoreBuild.healthLevel.metalStairs + buildUtil.getWoodHealth(self)
	end

	MoreBuild.equipToolPrimary(_stairs, player, "Screwdriver")

	getCell():setDrag(_stairs, player)
end

MoreBuild.floorsMenuBuilder = function(subMenu, player, context, worldobjects)
	local _sprite
	local _option
	local _tooltip
	local _name = ""

	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 1,
			Text = getItemText("Plank"),
		},

		{
			Material = "Nails",
			Amount = 1,
			Text = getItemText("Nails"),
		},
	}

	MoreBuild.neededTools = {"Hammer"}


	local _floorData = MoreBuild.getFloorsData()
	local _currentOption
	local _currentSubMenu


	for _subsectionName, _subsectionData in pairs(_floorData) do

		_currentOption = subMenu:addOption(_subsectionName, worldobjects, nil)
		_currentSubMenu = subMenu:getNew(subMenu)
		context:addSubMenu(_currentOption, _currentSubMenu)

		for _, _currentList in pairs(_subsectionData) do
			_sprite = {}
			_sprite.sprite = _currentList[1]
			_sprite.northSprite = _currentList[2]

			_name = _currentList[3]

			_option = _currentSubMenu:addOption(_name, nil, MoreBuild.onBuildTwoSpriteFloor, _sprite, player, _name)

			_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.floorObject, MoreBuild.ElectricityskillLevel.none, _option, player)
			_tooltip:setName(_name)
			_tooltip:setTexture(_sprite.sprite)

			if _currentList[4] then
				_tooltip.description = MoreBuild.textFloorDescription .. _tooltip.description .. MoreBuild.textCanRotate
			else
				_tooltip.description = MoreBuild.textFloorDescription .. _tooltip.description
			end
		end
	end
end

MoreBuild.onBuildTwoSpriteFloor = function(ignoreThisArgument, sprite, player, name)
	local _floor = ISWoodenFloor:new(sprite.sprite, sprite.northSprite)

	_floor.player = player
	_floor.name = name

	_floor.modData["need:Base.Plank"] = "1"
	_floor.modData["need:Base.Nails"] = "1"
	_floor.modData["xp:Woodwork"] = "5"

	getCell():setDrag(_floor, player)
end


MoreBuild.onBuildFourSpriteFloor = function(ignoreThisArgument, sprite, player, name)
	local _floor = ISWoodenFloor:new(sprite.sprite, sprite.northSprite)

	_floor.player = player
	_floor.name = name
	_floor.eastSprite = sprite.eastSprite
	_floor.southSprite = sprite.southSprite

	_floor.modData["need:Base.Plank"] = "1"
	_floor.modData["need:Base.Nails"] = "1"
	_floor.modData["xp:Woodwork"] = "5"

	getCell():setDrag(_floor, player)
end

MoreBuild.getFloorsData = function()
	local _floorData =
	{
		[getText "ContextMenu_ditanl"] =
		{
			{ "location_hospitality_sunstarmotel_01_57", "location_hospitality_sunstarmotel_01_57", getText "ContextMenu_ditan", false },
			{ "location_hospitality_sunstarmotel_01_56", "location_hospitality_sunstarmotel_01_56", getText "ContextMenu_ditan1", false },
			{ "location_restaurant_pileocrepe_01_14", "location_restaurant_pileocrepe_01_14", getText "ContextMenu_ditan2", false },
			{ "location_shop_fossoil_01_39", "location_shop_fossoil_01_39", getText("ContextMenu_Blue_Gas_Station_Carpet"), false },
			{ "location_shop_fossoil_01_38", "location_shop_fossoil_01_38", getText "ContextMenu_ditan3", false },
			{ "location_shop_zippee_01_6", "location_shop_zippee_01_6", getText("ContextMenu_Blue_Gas_Station_Carpet"), false },
			{ "location_shop_zippee_01_7", "location_shop_zippee_01_7", getText "ContextMenu_ditan4", false },
		},
		[getText "ContextMenu_qitaditan"] =
		{
			{ "location_shop_greenes_01_32", "location_shop_greenes_01_33", getText "ContextMenu_ditan5", true },
			{ "floors_interior_carpet_01_7", "floors_interior_carpet_01_7", getText "ContextMenu_ditan6", false },
			{ "floors_interior_carpet_01_13", "floors_interior_carpet_01_13", getText "ContextMenu_ditan7", false },
			{ "floors_interior_carpet_01_2", "floors_interior_carpet_01_2", getText "ContextMenu_ditan8", false },
			{ "floors_interior_carpet_01_14", "floors_interior_carpet_01_14", getText "ContextMenu_ditan9", false },
			{ "floors_interior_carpet_01_11", "floors_interior_carpet_01_11", getText "ContextMenu_ditan10", false },
			{ "floors_interior_carpet_01_9", "floors_interior_carpet_01_9", getText "ContextMenu_ditan11", false },
			{ "floors_interior_carpet_01_8", "floors_interior_carpet_01_8", getText "ContextMenu_ditan12", false },
			{ "floors_interior_carpet_01_3", "floors_interior_carpet_01_3", getText "ContextMenu_ditan13", false },
			{ "floors_interior_carpet_01_10", "floors_interior_carpet_01_10", getText "ContextMenu_ditan14", false },
		},
		[getText "ContextMenu_qitaditan1"] =
		{
			{ "floors_interior_carpet_01_5", "floors_interior_carpet_01_5", getText "ContextMenu_ditan15", false },
			{ "floors_interior_carpet_01_0", "floors_interior_carpet_01_0", getText "ContextMenu_ditan16", false },
			{ "floors_interior_carpet_01_1", "floors_interior_carpet_01_1", getText "ContextMenu_ditan17", false },
			{ "floors_interior_carpet_01_6", "floors_interior_carpet_01_6", getText "ContextMenu_ditan18", false },
			{ "floors_interior_carpet_01_4", "floors_interior_carpet_01_4", getText "ContextMenu_ditan19", false },
			{ "floors_interior_tilesandwood_01_45", "floors_interior_tilesandwood_01_45", getText "ContextMenu_ditan20", false },
			{ "floors_interior_carpet_01_12", "floors_interior_carpet_01_12", getText "ContextMenu_ditan21", false },
		},
		[getText "ContextMenu_jinshu"] =
		{
			{ "industry_01_37", "industry_01_38", getText "ContextMenu_ditan22", true },
			{ "industry_01_39", "industry_01_39", getText "ContextMenu_ditan01", false },
			{ "industry_railroad_05_22", "industry_railroad_05_23", getText "ContextMenu_ditan23", true },
			{ "industry_railroad_05_38", "industry_railroad_05_39", getText "ContextMenu_ditan24", true },
			{ "location_sewer_01_40", "location_sewer_01_41", getText "ContextMenu_ditan25", true },
			{ "location_sewer_01_42", "location_sewer_01_42", getText "ContextMenu_ditan26", false },
		},
		[getText "ContextMenu_shizhi"] =
		{
			{ "floors_exterior_street_01_14", "floors_exterior_street_01_14", getText "ContextMenu_ditan27", false },
			{ "floors_exterior_street_01_17", "floors_exterior_street_01_17", getText "ContextMenu_ditan28", false },
			{ "floors_exterior_street_01_16", "floors_exterior_street_01_16", getText "ContextMenu_ditan29", false },
		},

		[getText "ContextMenu_wuding"] =
		{
			{ "roofs_01_22", "roofs_01_23", getText "ContextMenu_ditan30", true },
			{ "roofs_01_54", "roofs_01_55", getText "ContextMenu_ditan31", true },
			{ "roofs_03_22", "roofs_03_23", getText "ContextMenu_ditan32", true },
			{ "roofs_03_54", "roofs_03_55", getText "ContextMenu_ditan33", true },
			{ "roofs_04_22", "roofs_04_23", getText "ContextMenu_ditan34", true },
			{ "roofs_04_54", "roofs_04_55", getText "ContextMenu_ditan35", true },
			{ "roofs_burnt_01_22", "roofs_burnt_01_23", getText "ContextMenu_ditan36", true },
		},

		[getText "ContextMenu_shineicizhuan"] =
		{
			{ "location_hospitality_sunstarmotel_02_16", "location_hospitality_sunstarmotel_02_16", getText "ContextMenu_ditan37", false },
			{ "location_restaurant_diner_01_40", "location_restaurant_diner_01_40", getText "ContextMenu_ditan38", false },
			{ "location_restaurant_diner_01_41", "location_restaurant_diner_01_41", getText "ContextMenu_ditan39", false },
			{ "location_restaurant_pie_01_7", "location_restaurant_pie_01_7", getText "ContextMenu_ditan40", false },
			{ "location_restaurant_pizzawhirled_01_16", "location_restaurant_pizzawhirled_01_16", getText "ContextMenu_ditan41", false },
			{ "location_restaurant_spiffos_01_38", "location_restaurant_spiffos_01_38", getText "ContextMenu_ditan42", false },
			{ "location_shop_mall_01_20", "location_shop_mall_01_21", getText "ContextMenu_ditan43", true },
			{ "location_shop_mall_01_22", "location_shop_mall_01_22", getText "ContextMenu_ditan44", false },
			{ "location_shop_mall_01_23", "location_shop_mall_01_23", getText "ContextMenu_ditan45", false },
		},

		[getText "ContextMenu_qitacizhuan"] =
		{
			{ "location_restaurant_bar_01_24", "location_restaurant_bar_01_24", getText "ContextMenu_ditan46", false },
			{ "floors_interior_tilesandwood_01_0", "floors_interior_tilesandwood_01_0", getText "ContextMenu_ditan47", false },
			{ "floors_interior_tilesandwood_01_1", "floors_interior_tilesandwood_01_1", getText "ContextMenu_ditan48", false },
			{ "floors_interior_tilesandwood_01_2", "floors_interior_tilesandwood_01_2", getText "ContextMenu_ditan49", false },
			{ "floors_interior_tilesandwood_01_3", "floors_interior_tilesandwood_01_3", getText "ContextMenu_ditan50", false },
			{ "floors_interior_tilesandwood_01_4", "floors_interior_tilesandwood_01_4", getText "ContextMenu_ditan47", false },
			{ "floors_interior_tilesandwood_01_5", "floors_interior_tilesandwood_01_5", getText "ContextMenu_ditan51", false },
			{ "floors_interior_tilesandwood_01_6", "floors_interior_tilesandwood_01_6", getText "ContextMenu_ditan52", false },
			{ "floors_interior_tilesandwood_01_7", "floors_interior_tilesandwood_01_7", getText "ContextMenu_ditan53", false },
			{ "floors_interior_tilesandwood_01_8", "floors_interior_tilesandwood_01_8", getText "ContextMenu_ditan42", false },
		},

		[getText "ContextMenu_caisecizhuan"] =
		{
			{ "floors_interior_tilesandwood_01_9", "floors_interior_tilesandwood_01_9", getText "ContextMenu_ditan54", false },
			{ "floors_interior_tilesandwood_01_10", "floors_interior_tilesandwood_01_10", getText "ContextMenu_ditan55", false },
			{ "floors_interior_tilesandwood_01_11", "floors_interior_tilesandwood_01_11", getText "ContextMenu_ditan56", false },
			{ "floors_interior_tilesandwood_01_12", "floors_interior_tilesandwood_01_12", getText "ContextMenu_ditan57", false },
			{ "floors_interior_tilesandwood_01_13", "floors_interior_tilesandwood_01_13", getText "ContextMenu_ditan58", false },
			{ "floors_interior_tilesandwood_01_14", "floors_interior_tilesandwood_01_14", getText "ContextMenu_ditan59", false },
			{ "floors_interior_tilesandwood_01_16", "floors_interior_tilesandwood_01_17", getText "ContextMenu_ditan60", true },
			{ "floors_interior_tilesandwood_01_18", "floors_interior_tilesandwood_01_18", getText "ContextMenu_ditan61", false },
			{ "floors_interior_tilesandwood_01_19", "floors_interior_tilesandwood_01_19", getText "ContextMenu_ditan62", false },
			{ "floors_interior_tilesandwood_01_20", "floors_interior_tilesandwood_01_20", getText "ContextMenu_ditan63", false },
		},
		[getText "ContextMenu_shineicizhuan1"] =
		{
			{ "floors_interior_tilesandwood_01_21", "floors_interior_tilesandwood_01_21", getText "ContextMenu_ditan64", false },
			{ "floors_interior_tilesandwood_01_22", "floors_interior_tilesandwood_01_22", getText "ContextMenu_ditan65", false },
			{ "floors_interior_tilesandwood_01_23", "floors_interior_tilesandwood_01_23", getText "ContextMenu_ditan66", false },
			{ "floors_interior_tilesandwood_01_30", "floors_interior_tilesandwood_01_30", getText "ContextMenu_ditan67", false },
			{ "floors_interior_tilesandwood_01_31", "floors_interior_tilesandwood_01_31", getText "ContextMenu_ditan68", false },
		},
		[getText "ContextMenu_waiqiangcizhuan"] =
		{
			{ "floors_exterior_tilesandstone_01_7", "floors_exterior_tilesandstone_01_7", getText "ContextMenu_ditan69", false },
			{ "floors_exterior_tilesandstone_01_3", "floors_exterior_tilesandstone_01_3", getText "ContextMenu_ditan70", false },
			{ "floors_exterior_tilesandstone_01_2", "floors_exterior_tilesandstone_01_2", getText "ContextMenu_ditan71", false },
			{ "floors_exterior_tilesandstone_01_4", "floors_exterior_tilesandstone_01_4", getText "ContextMenu_ditan72", false },
			{ "floors_exterior_tilesandstone_01_5", "floors_exterior_tilesandstone_01_5", getText "ContextMenu_ditan73", false },
			{ "floors_exterior_tilesandstone_01_6", "floors_exterior_tilesandstone_01_6", getText "ContextMenu_ditan74", false },
			{ "floors_exterior_tilesandstone_01_1", "floors_exterior_tilesandstone_01_1", getText "ContextMenu_ditan75", false },
			{ "floors_exterior_tilesandstone_01_0", "floors_exterior_tilesandstone_01_0", getText "ContextMenu_ditan76", false },
		},
		[getText "ContextMenu_mudiban"] =
		{
			{ "construction_01_22", "construction_01_31", getText "ContextMenu_ditan77", true },
			{ "industry_railroad_05_44", "industry_railroad_05_47", getText "ContextMenu_ditan78", true },
			{ "floors_interior_tilesandwood_01_40", "floors_interior_tilesandwood_01_40", getText "ContextMenu_ditan79", false },
			{ "floors_interior_tilesandwood_01_41", "floors_interior_tilesandwood_01_41", getText "ContextMenu_ditan80", false },
			{ "location_shop_greenes_01_34", "location_shop_greenes_01_34", getText "ContextMenu_ditan81", false },
			{ "floors_interior_tilesandwood_01_42", "floors_interior_tilesandwood_01_42", getText "ContextMenu_ditan82", false },
			{ "floors_interior_tilesandwood_01_43", "floors_interior_tilesandwood_01_44", getText "ContextMenu_ditan83", true },
			{ "floors_interior_tilesandwood_01_46", "floors_interior_tilesandwood_01_46", getText "ContextMenu_ditan84", false },
		},
		[getText "ContextMenu_qita"] =
		{
			{ "floors_interior_tilesandwood_01_48", "floors_interior_tilesandwood_01_48", getText "ContextMenu_ditan85", },
			{ "floors_interior_tilesandwood_01_49", "floors_interior_tilesandwood_01_49", getText "ContextMenu_ditan86", false },
			{ "floors_interior_tilesandwood_01_50", "floors_interior_tilesandwood_01_50", getText "ContextMenu_ditan87", false },
			{ "recreational_sports_01_34", "recreational_sports_01_34", getText "ContextMenu_ditan88", false },
			{ "floors_burnt_01_0", "floors_burnt_01_0", getText "ContextMenu_ditan89", false },
		},
		[getText "ContextMenu_gongye"] =
		{
			{ "industry_01_7", "industry_01_7", getText "ContextMenu_ditan90", false },
			{ "industry_01_6", "industry_01_6", getText "ContextMenu_ditan91", false },
			{ "industry_trucks_01_47", "industry_trucks_01_47", getText "ContextMenu_ditan92", false },
			{ "industry_trucks_01_39", "industry_trucks_01_39", getText "ContextMenu_ditan92", false },
			{ "industry_trucks_01_38", "industry_trucks_01_38", getText "ContextMenu_ditan92", false },
			{ "industry_trucks_01_46", "industry_trucks_01_46", getText "ContextMenu_ditan92", false },
			{ "location_shop_generic_01_4", "location_shop_generic_01_4", getText "ContextMenu_ditan93", false },
			{ "location_trailer_02_28", "location_trailer_02_28", getText "ContextMenu_ditan94", false },
			{ "location_trailer_01_44", "location_trailer_01_44", getText "ContextMenu_ditan95", false },
		},
	}

	return _floorData
end

MoreBuild.cratesMenuBuilder = function(subMenu, player)
	local _sprite
	local _option
	local _tooltip
	local _name = ""
	local _icon = ""


	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 2,
			Text = getItemText("Plank"),
		},

		{
			Material = "Nails",
			Amount = 2,
			Text = getItemText("Nails"),
		},
	}

	MoreBuild.neededTools = {"Hammer"}

	_sprite = {}
	_sprite.sprite = "location_shop_greenes_01_35"
	_sprite.northSprite = "location_shop_greenes_01_36"

	_name = getText "ContextMenu_Half_Crate"
	_icon = "smallcrate"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenContainer, _sprite, player, _name, _icon)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.simpleContainer, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)

	_tooltip.description = getText "Tooltip_zhongxinxiangzitip" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "location_shop_greenes_01_37"
	_sprite.northSprite = "location_shop_greenes_01_38"

	_name = getText "ContextMenu_Grocery_Box"
	_icon = "smallbox"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildPassThroughContainer, _sprite, player, _name, _icon)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.simpleContainer, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)

	_tooltip.description = getText "Tooltip_zahuoxiang" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "fixtures_bathroom_02_24"
	_sprite.northSprite = "fixtures_bathroom_02_25"

	_name = getText "ContextMenu_Outhouse_Box"
	_icon = "bin"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildPassThroughContainer, _sprite, player, _name, _icon)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.simpleContainer, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_cesuohezitip" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "location_entertainment_theatre_01_16"
	_sprite.northSprite = "location_entertainment_theatre_01_16"

	_name = getText "ContextMenu_Theatre_Storage"
	_icon = "counter"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenContainer, _sprite, player, _name, _icon)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.simpleContainer, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_juyuantip" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "location_farm_accesories_01_8"
	_sprite.northSprite = "location_farm_accesories_01_9"
	_sprite.eastSprite = "location_farm_accesories_01_10"
	_sprite.southSprite = "location_farm_accesories_01_11"

	_name = getText "ContextMenu_Dog_House"
	_icon = "officedrawers"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenContainer, _sprite, player, _name, _icon)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.simpleContainer, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_gouwutip" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	local _cardboardBoxesData = MoreBuild.getCardboardBoxesData()

	for _, _currentList in pairs(_cardboardBoxesData) do
		_sprite = {}
		_sprite.sprite = _currentList[1]
		_sprite.northSprite = _currentList[2]

		_name = _currentList[3]

		_option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenContainer, _sprite, player, _name, _currentList[4])

		_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.simpleContainer, MoreBuild.ElectricityskillLevel.none, _option, player)
		_tooltip:setName(_name)
		_tooltip.description = _currentList[5] .. _tooltip.description
		_tooltip:setTexture(_sprite.sprite)
	end
end

MoreBuild.getCardboardBoxesData = function()
	cardboardBoxes =
	{
		{ "trashcontainers_01_24", "trashcontainers_01_25", getText "ContextMenu_Small_Cardboard_Box", "smallbox", getText "Tooltip_xiaozhixiangtip", }, --小纸箱
		{ "trashcontainers_01_26", "trashcontainers_01_27", getText "ContextMenu_Broken_Cardboard_Box", "smallbox", getText "Tooltip_pozhixiangtip", }, --破纸箱
		{ "furniture_storage_02_16", "furniture_storage_02_17", getText "ContextMenu_Big_Cardboard_Box", "garage_storage", getText "Tooltip_dazhixiangtip", }, --大纸箱
		{ "furniture_storage_02_18", "furniture_storage_02_19", getText "ContextMenu_Cardboard_Box", "garage_storage", getText "Tooltip_zhixiangtip", }, --纸箱
	}

	return cardboardBoxes
end

MoreBuild.improvisedMenuBuilder = function(subMenu, player)
	local _sprite
	local _option
	local _tooltip
	local _name = ""
	local _icon = ""

	MoreBuild.neededMaterials =
	{
		{
			Material = "Sheet",
			Amount = 1,
			Text = getItemText("Sheet"),
		},

		{
			Material = "Screws",
			Amount = 2,
			Text = getItemText("Screws"),
		},

		{
			Material = "SheetMetal",
			Amount = 1,
			Text = getItemText("Sheet Metal"),
		},
	}

	MoreBuild.neededTools = { "Screwdriver", }


	_sprite = {}
	_sprite.sprite = "appliances_laundry_01_24"
	_sprite.northSprite = "appliances_laundry_01_25"

	_name = getText "ContextMenu_Laundry_Cart"
	_icon = "officedrawers"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildLaundryCart, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.simpleContainer, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_xiyichetip" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 2,
			Text = getItemText("Plank"),
		},

		{
			Material = "Nails",
			Amount = 3,
			Text = getItemText("Nails"),
		},
	}

	MoreBuild.neededTools = {"Hammer"}

	_sprite = {}
	_sprite.sprite = "construction_01_4"
	_sprite.northSprite = "construction_01_4"

	_name = getText "ContextMenu_Pallet_of_Bricks"
	_icon = "fireplace"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildStoneContainer, _sprite, player, _name, _icon)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.complexContainer, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_zhuangban" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)


	MoreBuild.neededMaterials =
	{
		{
			Material = "SheetMetal",
			Amount = 2,
			Text = getItemText("Sheet Metal"),
		},

		{
			Material = "Screws",
			Amount = 2,
			Text = getItemText("Screws"),
		},
	}

	MoreBuild.neededTools = { "Screwdriver", }

	_sprite = {}
	_sprite.sprite = "industry_01_22"
	_sprite.northSprite = "industry_01_23"

	_name = getText "ContextMenu_Metal_Barrel"
	_icon = "bin"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildMetalContainer, _sprite, player, _name, _icon)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.advancedContainer, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_jinshutong" .. _tooltip.description .. MoreBuild.textCanRotate
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "street_decoration_01_8"
	_sprite.northSprite = "street_decoration_01_9"
	_sprite.eastSprite = "street_decoration_01_10"
	_sprite.southSprite = "street_decoration_01_11"

	_name = getText "ContextMenu_Post_Box"
	_icon = "vendingpop"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildMetalContainer, _sprite, player, _name, _icon)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.advancedContainer, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_xinxiang" .. _tooltip.description .. MoreBuild.textCanRotate
	_tooltip:setTexture(_sprite.sprite)

	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 2,
			Text = getItemText("Plank"),
		},

		{
			Material = "Nails",
			Amount = 2,
			Text = getItemText("Nails"),
		},
	}

	MoreBuild.neededTools = {"Hammer"}

	_sprite = {}
	_sprite.sprite = "trashcontainers_01_0"
	_sprite.northSprite = "trashcontainers_01_1"
	_sprite.eastSprite = "trashcontainers_01_2"
	_sprite.southSprite = "trashcontainers_01_3"

	_name = getText "ContextMenu_Recycling_Bin"
	_icon = "bin"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenContainer, _sprite, player, _name, _icon)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.simpleContainer, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_lajitong" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)
end

MoreBuild.trashMenuBuilder = function(subMenu, player)
	local _sprite
	local _option
	local _tooltip
	local _name = ""
	local _icon = "bin"

	local _trashCanData = MoreBuild.getTrashCanData()


	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 2,
			Text = getItemText("Plank"),
		},

		{
			Material = "Nails",
			Amount = 2,
			Text = getItemText("Nails"),
		},
	}

	MoreBuild.neededTools = {"Hammer"}

	for _, _currentList in pairs(_trashCanData["Wood"]) do
		_sprite = {}
		_sprite.sprite = _currentList[1]
		_sprite.northSprite = _currentList[2]

		_name = _currentList[3]

		_option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenContainer, _sprite, player, _name, _icon)

		_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.simpleContainer, MoreBuild.ElectricityskillLevel.none, _option, player)
		_tooltip.description = MoreBuild.textTrashCanDescription .. _tooltip.description
		_tooltip:setName(_name)
		_tooltip:setTexture(_sprite.sprite)
	end

	MoreBuild.neededMaterials =
	{
		{
			Material = "SheetMetal",
			Amount = 2,
			Text = getItemText("Sheet Metal"),
		},

		{
			Material = "Screws",
			Amount = 2,
			Text = getItemText("Screws"),
		},
	}

	MoreBuild.neededTools = { "Screwdriver", }

	for _, _currentList in pairs(_trashCanData["Metal"]) do
		_sprite = {}
		_sprite.sprite = _currentList[1]
		_sprite.northSprite = _currentList[2]

		_name = _currentList[3]

		_option = subMenu:addOption(_name, nil, MoreBuild.onBuildMetalContainer, _sprite, player, _name, _icon)

		_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.complexContainer, MoreBuild.ElectricityskillLevel.none, _option, player)
		_tooltip.description = MoreBuild.textTrashCanDescription .. _tooltip.description
		_tooltip:setName(_name)
		_tooltip:setTexture(_sprite.sprite)
	end

	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 2,
			Text = getItemText("Plank"),
		},

		{
			Material = "Nails",
			Amount = 3,
			Text = getItemText("Nails"),
		},
	}

	MoreBuild.neededTools = {"Hammer"}

	for _, _currentList in pairs(_trashCanData["Stone"]) do
		_sprite = {}
		_sprite.sprite = _currentList[1]
		_sprite.northSprite = _currentList[2]

		_name = _currentList[3]

		_option = subMenu:addOption(_name, nil, MoreBuild.onBuildStoneContainer, _sprite, player, _name, _icon)

		_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.complexContainer, MoreBuild.ElectricityskillLevel.none, _option, player)
		_tooltip.description = MoreBuild.textTrashCanDescription .. _tooltip.description
		_tooltip:setName(_name)
		_tooltip:setTexture(_sprite.sprite)
	end
end

MoreBuild.getTrashCanData = function()
	local _trashCanData =
	{
		["Wood"] =
		{
			{ "location_restaurant_pizzawhirled_01_17", "location_restaurant_pizzawhirled_01_18", getText "ContextMenu_Recycling_Bin", },
			{ "location_restaurant_spiffos_01_30", "location_restaurant_spiffos_01_31", getText "ContextMenu_Recycling_Bin", },
			{ "location_shop_fossoil_01_32", "location_shop_fossoil_01_33", getText "ContextMenu_Recycling_Bin", },
			{ "trashcontainers_01_18", "trashcontainers_01_19", getText "ContextMenu_Factory_Trash_Can", },
			{ "trashcontainers_01_20", "trashcontainers_01_20", getText "ContextMenu_Small_Waste_Basket", },
		},
		["Metal"] =
		{
			{ "trashcontainers_01_16", "trashcontainers_01_16", getText "ContextMenu_Steel_Trash_Can", },
			{ "trashcontainers_01_17", "trashcontainers_01_17", getText "ContextMenu_Recycling_Bin", },
		},
		["Stone"] =
		{
			{ "location_shop_mall_01_44", "location_shop_mall_01_44", getText "ContextMenu_Mall_Trash", },
		},
	}

	return _trashCanData
end

MoreBuild.onBuildWoodenContainer = function(ignoreThisArgument, sprite, player, name, icon)
	local _container = ISWoodenContainer:new(sprite.sprite, sprite.northSprite)

	_container.renderFloorHelper = true
	_container.canBeAlwaysPlaced = true
	_container.canBeLockedByPadlock = true
	_container.player = player
	_container.name = name

	if sprite.eastSprite then
		_container:setEastSprite(sprite.eastSprite)
	end

	if sprite.southSprite then
		_container:setSouthSprite(sprite.southSprite)
	end

	_container.modData["need:Base.Plank"] = "2"
	_container.modData["need:Base.Nails"] = "2"
	_container.modData["xp:Woodwork"] = "5"

	function _container:getHealth()
		self.javaObject:getContainer():setType(icon)
		return MoreBuild.healthLevel.woodContainer + buildUtil.getWoodHealth(self)
	end

	getCell():setDrag(_container, player)
end


MoreBuild.onBuildPassThroughContainer = function(ignoreThisArgument, sprite, player, name, icon)
	local _container = ISWoodenContainer:new(sprite.sprite, sprite.northSprite)

	_container.canPassThrough = true
	_container.renderFloorHelper = true
	_container.canBeAlwaysPlaced = true
	_container.canBeLockedByPadlock = true
	_container.player = player
	_container.name = name

	if sprite.eastSprite then
		_container:setEastSprite(sprite.eastSprite)
	end

	if sprite.southSprite then
		_container:setSouthSprite(sprite.southSprite)
	end

	_container.modData["need:Base.Plank"] = "2"
	_container.modData["need:Base.Nails"] = "2"
	_container.modData["xp:Woodwork"] = "5"

	function _container:getHealth()
		self.javaObject:getContainer():setType(icon)
		return MoreBuild.healthLevel.woodContainer + buildUtil.getWoodHealth(self)
	end

	getCell():setDrag(_container, player)
end


MoreBuild.onBuildStoneContainer = function(ignoreThisArgument, sprite, player, name, icon)
	local _container = ISWoodenContainer:new(sprite.sprite, sprite.northSprite)

	_container.renderFloorHelper = true
	_container.canBeAlwaysPlaced = true
	_container.canBeLockedByPadlock = true
	_container.player = player
	_container.name = name

	if sprite.eastSprite then
		_container:setEastSprite(sprite.eastSprite)
	end

	if sprite.southSprite then
		_container:setSouthSprite(sprite.southSprite)
	end

	_container.modData["need:Base.Plank"] = "4"
	_container.modData["need:Base.Nails"] = "2"
	_container.modData["xp:Woodwork"] = "5"

	function _container:getHealth()
		self.javaObject:getContainer():setType(icon)
		return MoreBuild.healthLevel.stoneContainer + buildUtil.getWoodHealth(self)
	end

	MoreBuild.equipToolPrimary(_container, player, "Trowel")

	getCell():setDrag(_container, player)
end


MoreBuild.onBuildMetalContainer = function(ignoreThisArgument, sprite, player, name, icon)
	local _container = ISWoodenContainer:new(sprite.sprite, sprite.northSprite)

	_container.renderFloorHelper = false
	_container.canBeAlwaysPlaced = false
	_container.canBeLockedByPadlock = true
	_container.player = player
	_container.name = name

	if sprite.eastSprite then
		_container:setEastSprite(sprite.eastSprite)
	end

	if sprite.southSprite then
		_container:setSouthSprite(sprite.southSprite)
	end

	_container.modData["need:Base.SheetMetal"] = "2"
	_container.modData["need:Base.Screws"] = "2"
	_container.modData["xp:Woodwork"] = "5"

	MoreBuild.equipToolPrimary(_container, player, "Screwdriver")

	function _container:getHealth()
		self.javaObject:getContainer():setType(icon)
		return MoreBuild.healthLevel.metalContainer + buildUtil.getWoodHealth(self)
	end

	getCell():setDrag(_container, player)
end


MoreBuild.onBuildLaundryCart = function(ignoreThisArgument, sprite, player, name)
	local _cart = ISWoodenContainer:new(sprite.sprite, sprite.northSprite)

	_cart.canPassThrough = true
	_cart.canBarricade = false
	_cart.canBeLockedByPadlock = true
	_cart.renderFloorHelper = true
	_cart.canBeAlwaysPlaced = true
	_cart.player = player
	_cart.name = name

	_cart.modData["need:Base.Sheet"] = "1"
	_cart.modData["need:Base.Screws"] = "2"
	_cart.modData["need:Base.SheetMetal"] = "1"
	_cart.modData["xp:Woodwork"] = "5"

	function _cart:getHealth()
		self.javaObject:getContainer():setType("officedrawers")
		return MoreBuild.healthLevel.woodContainer + buildUtil.getWoodHealth(self)
	end

	MoreBuild.equipToolPrimary(_cart, player, "Screwdriver")

	getCell():setDrag(_cart, player)
end

MoreBuild.dressersMenuBuilder = function(subMenu, player)
	local _sprite
	local _option
	local _tooltip
	local _name = ""

	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 4,
			Text = getItemText("Plank"),
		},

		{
			Material = "Nails",
			Amount = 4,
			Text = getItemText("Nails"),
		},

		{
			Material = "Drawer",
			Amount = 1,
			Text = getItemText("Drawer"),
		},
	}

	MoreBuild.neededTools = {"Hammer"}


	local _dresserData = MoreBuild.getDresserData()

	for _, _currentList in pairs(_dresserData) do
		_sprite = {}
		_sprite.sprite = _currentList[1]
		_sprite.northSprite = _currentList[2]
		_sprite.eastSprite = _currentList[3]
		_sprite.southSprite = _currentList[4]

		_name = _currentList[5]

		_option = subMenu:addOption(_name, nil, MoreBuild.onBuildDresser, _sprite, player, _name)

		_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.advancedContainer, MoreBuild.ElectricityskillLevel.none, _option, player)
		_tooltip:setName(_name)
		_tooltip.description = _currentList[6] .. _tooltip.description
		_tooltip:setTexture(_sprite.sprite)
	end
end

MoreBuild.getDresserData = function()
	local _dresserData =
	{
		{ "furniture_storage_01_46", "furniture_storage_01_47", "furniture_storage_01_44", "furniture_storage_01_45", getText "ContextMenu_Beige_Dresser", MoreBuild.textDresserDescription, },
		{ "furniture_storage_01_49", "furniture_storage_01_48", "furniture_storage_01_50", "furniture_storage_01_51", getText "ContextMenu_Beige_Nightstand", getText "Tooltip_misechuangtougui", },
		{ "furniture_storage_01_12", "furniture_storage_01_13", "furniture_storage_01_14", "furniture_storage_01_15", getText "ContextMenu_Dark_Brown_Dresser", MoreBuild.textDresserDescription, },
		{ "furniture_storage_01_32", "furniture_storage_01_33", "furniture_storage_01_34", "furniture_storage_01_35", getText "ContextMenu_Gray_Dresser", MoreBuild.textDresserDescription, },
		{ "furniture_storage_01_8", "furniture_storage_01_9", "furniture_storage_01_10", "furniture_storage_01_11", getText "ContextMenu_White_Dresser", MoreBuild.textDresserDescription, },
	}

	return _dresserData
end

MoreBuild.onBuildDresser = function(ignoreThisArgument, sprite, player, name)
	local _dresser = ISSimpleFurniture:new(name, sprite.sprite, sprite.northSprite)

	_dresser.isContainer = true
	_dresser.renderFloorHelper = true
	_dresser:setEastSprite(sprite.eastSprite)
	_dresser:setSouthSprite(sprite.southSprite)
	_dresser.player = player

	_dresser.modData["need:Base.Plank"] = "4"
	_dresser.modData["need:Base.Nails"] = "4"
	_dresser.modData["need:Base.Drawer"] = "1"
	_dresser.modData["xp:Woodwork"] = "5"

	function _dresser:getHealth()
		self.javaObject:getContainer():setType("wardrobe")
		return MoreBuild.healthLevel.woodContainer + buildUtil.getWoodHealth(self)
	end

	getCell():setDrag(_dresser, player)
end

MoreBuild.counterElementsMenuBuilder = function(subMenu, player, context, worldobjects)
	local _sprite
	local _option
	local _tooltip
	local _name = ""

	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 4,
			Text = getItemText("Plank"),
		},

		{
			Material = "Nails",
			Amount = 4,
			Text = getItemText("Nails"),
		},
	}

	MoreBuild.neededTools = {"Hammer"}


	local _counterData = MoreBuild.getBarElementData()
	local _currentOption
	local _currentSubMenu

	for _subsectionName, _subsectionData in pairs(_counterData) do

		_currentOption = subMenu:addOption(_subsectionName, worldobjects, nil)
		_currentSubMenu = subMenu:getNew(subMenu)
		context:addSubMenu(_currentOption, _currentSubMenu)

		for _, _currentList in pairs(_subsectionData) do
			_sprite = {}
			_sprite.sprite = _currentList[1]
			_sprite.northSprite = _currentList[2]
			_sprite.eastSprite = _currentList[3]
			_sprite.southSprite = _currentList[4]

			_name = _currentList[5]

			_option = _currentSubMenu:addOption(_name, nil, MoreBuild.onBuildBarElement, _sprite, player, _name)

			_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.advancedContainer, MoreBuild.ElectricityskillLevel.none, _option, player)
			_tooltip:setName(_name)
			_tooltip.description = _currentList[6] .. _tooltip.description
			_tooltip:setTexture(_sprite.sprite)
		end
	end
end

MoreBuild.onBuildBarElement = function(ignoreThisArgument, sprite, player, name)
	local _barElement = ISWoodenContainer:new(sprite.sprite, sprite.northSprite)

	_barElement:setEastSprite(sprite.eastSprite)
	_barElement:setSouthSprite(sprite.southSprite)
	_barElement.name = name
	_barElement.renderFloorHelper = true
	_barElement.canBeLockedByPadlock = true
	_barElement.player = player

	_barElement.modData["need:Base.Plank"] = "4"
	_barElement.modData["need:Base.Nails"] = "4"
	_barElement.modData["xp:Woodwork"] = "5"

	function _barElement:getHealth()
		self.javaObject:getContainer():setType("counter")
		return MoreBuild.healthLevel.woodContainer + buildUtil.getWoodHealth(self)
	end

	getCell():setDrag(_barElement, player)
end

MoreBuild.getBarElementData = function()
	local _barElementData =
	{
		[getText "ContextMenu_Cabinets"] =
		{
			{ "fixtures_counters_01_3", "fixtures_counters_01_5", "fixtures_counters_01_7", "fixtures_counters_01_1", getText "ContextMenu_guizi1", MoreBuild.textBarElementDescription, },
			{ "fixtures_counters_01_2", "fixtures_counters_01_4", "fixtures_counters_01_6", "fixtures_counters_01_0", getText "ContextMenu_guizi2", MoreBuild.textBarCornerDescription, },

			{ "fixtures_counters_01_43", "fixtures_counters_01_45", "fixtures_counters_01_47", "fixtures_counters_01_41", getText "ContextMenu_guizi3", MoreBuild.textBarElementDescription, },
			{ "fixtures_counters_01_42", "fixtures_counters_01_44", "fixtures_counters_01_46", "fixtures_counters_01_40", getText "ContextMenu_guizi4", MoreBuild.textBarCornerDescription, },

			{ "fixtures_counters_01_51", "fixtures_counters_01_53", "fixtures_counters_01_55", "fixtures_counters_01_49", getText "ContextMenu_guizi5", MoreBuild.textBarElementDescription, },
			{ "fixtures_counters_01_50", "fixtures_counters_01_52", "fixtures_counters_01_54", "fixtures_counters_01_48", getText "ContextMenu_guizi6", MoreBuild.textBarCornerDescription, },

			{ "fixtures_counters_01_59", "fixtures_counters_01_61", "fixtures_counters_01_63", "fixtures_counters_01_57", getText "ContextMenu_guizi7", MoreBuild.textBarElementDescription, },
			{ "fixtures_counters_01_58", "fixtures_counters_01_60", "fixtures_counters_01_62", "fixtures_counters_01_56", getText "ContextMenu_guizi8", MoreBuild.textBarCornerDescription, },

			{ "fixtures_counters_01_67", "fixtures_counters_01_69", "fixtures_counters_01_71", "fixtures_counters_01_65", getText "ContextMenu_guizi9", MoreBuild.textBarElementDescription, },
			{ "fixtures_counters_01_66", "fixtures_counters_01_68", "fixtures_counters_01_70", "fixtures_counters_01_64", getText "ContextMenu_guizi10", MoreBuild.textBarCornerDescription, },
		},
		[getText "ContextMenu_More_Cabinets"] =
		{
			{ "fixtures_counters_01_75", "fixtures_counters_01_77", "fixtures_counters_01_79", "fixtures_counters_01_73", getText "ContextMenu_guizi11", MoreBuild.textBarElementDescription, },
			{ "fixtures_counters_01_74", "fixtures_counters_01_76", "fixtures_counters_01_78", "fixtures_counters_01_72", getText "ContextMenu_guizi12", MoreBuild.textBarCornerDescription, },

			{ "location_trailer_02_19", "location_trailer_02_18", "location_trailer_02_21", "location_trailer_02_20", getText "ContextMenu_guizi13", MoreBuild.textBarElementDescription, },

			{ "location_hospitality_sunstarmotel_02_13", "location_hospitality_sunstarmotel_02_14", "location_hospitality_sunstarmotel_02_15", "location_hospitality_sunstarmotel_02_12", getText "ContextMenu_guizi14", MoreBuild.textBarElementDescription, },

			{ "fixtures_counters_01_11", "fixtures_counters_01_13", "fixtures_counters_01_15", "fixtures_counters_01_9", getText "ContextMenu_guizi15", MoreBuild.textBarElementDescription, },
			{ "fixtures_counters_01_10", "fixtures_counters_01_12", "fixtures_counters_01_14", "fixtures_counters_01_8", getText "ContextMenu_guizi16", MoreBuild.textBarCornerDescription, },

			{ "fixtures_counters_01_35", "fixtures_counters_01_37", "fixtures_counters_01_39", "fixtures_counters_01_33", getText "ContextMenu_guizi17", MoreBuild.textBarElementDescription, },
			{ "fixtures_counters_01_34", "fixtures_counters_01_36", "fixtures_counters_01_38", "fixtures_counters_01_32", getText "ContextMenu_guizi18", MoreBuild.textBarCornerDescription, },
		},
		[getText "ContextMenu_Business_Counters1"] =
		{
			{ "location_restaurant_bar_01_6", "location_restaurant_bar_01_4", "location_restaurant_bar_01_2", "location_restaurant_bar_01_0", getText "ContextMenu_guizi19", MoreBuild.textBarElementDescription, },
			{ "location_restaurant_bar_01_7", "location_restaurant_bar_01_5", "location_restaurant_bar_01_3", "location_restaurant_bar_01_1", getText "ContextMenu_guizi20", MoreBuild.textBarCornerDescription, },

			{ "location_restaurant_pie_01_43", "location_restaurant_pie_01_45", "location_restaurant_pie_01_47", "location_restaurant_pie_01_41", getText "ContextMenu_guizi21", MoreBuild.textBarElementDescription, },
			{ "location_restaurant_pie_01_42", "location_restaurant_pie_01_44", "location_restaurant_pie_01_46", "location_restaurant_pie_01_40", getText "ContextMenu_guizi22", MoreBuild.textBarCornerDescription, },

			{ "location_entertainment_theatre_01_11", "location_entertainment_theatre_01_13", "location_entertainment_theatre_01_15", "location_entertainment_theatre_01_9", getText "ContextMenu_guizi23", MoreBuild.textBarElementDescription, },
			{ "location_entertainment_theatre_01_10", "location_entertainment_theatre_01_12", "location_entertainment_theatre_01_14", "location_entertainment_theatre_01_8", getText "ContextMenu_guizi24", MoreBuild.textBarCornerDescription, },

			{ "location_shop_fossoil_01_19", "location_shop_fossoil_01_21", "location_shop_fossoil_01_23", "location_shop_fossoil_01_17", getText "ContextMenu_guizi25", MoreBuild.textBarElementDescription, },
			{ "location_shop_fossoil_01_18", "location_shop_fossoil_01_20", "location_shop_fossoil_01_22", "location_shop_fossoil_01_16", getText "ContextMenu_guizi26", MoreBuild.textBarCornerDescription, },

			{ "location_shop_gas2go_01_19", "location_shop_gas2go_01_21", "location_shop_gas2go_01_23", "location_shop_gas2go_01_17", getText "ContextMenu_guizi27", MoreBuild.textBarElementDescription, },
			{ "location_shop_gas2go_01_18", "location_shop_gas2go_01_20", "location_shop_gas2go_01_22", "location_shop_gas2go_01_16", getText "ContextMenu_guizi28", MoreBuild.textBarCornerDescription, },
		},
		[getText "ContextMenu_Business_Counters2"] =
		{
			{ "location_restaurant_pizzawhirled_01_35", "location_restaurant_pizzawhirled_01_37", "location_restaurant_pizzawhirled_01_39", "location_restaurant_pizzawhirled_01_33", getText "ContextMenu_guizi29", MoreBuild.textBarElementDescription, },
			{ "location_restaurant_pizzawhirled_01_32", "location_restaurant_pizzawhirled_01_36", "location_restaurant_pizzawhirled_01_38", "location_restaurant_pizzawhirled_01_34", getText "ContextMenu_guizi30", MoreBuild.textBarCornerDescription, },

			{ "location_restaurant_seahorse_01_43", "location_restaurant_seahorse_01_49", "location_restaurant_seahorse_01_51", "location_restaurant_seahorse_01_41", getText "ContextMenu_guizi31", MoreBuild.textBarElementDescription, },
			{ "location_restaurant_seahorse_01_42", "location_restaurant_seahorse_01_48", "location_restaurant_seahorse_01_50", "location_restaurant_seahorse_01_40", getText "ContextMenu_guizi32", MoreBuild.textBarCornerDescription, },

			{ "location_restaurant_spiffos_01_59", "location_restaurant_spiffos_01_61", "location_restaurant_spiffos_01_63", "location_restaurant_spiffos_01_57", getText "ContextMenu_guizi33", MoreBuild.textBarElementDescription, },
			{ "location_restaurant_spiffos_01_56", "location_restaurant_spiffos_01_60", "location_restaurant_spiffos_01_62", "location_restaurant_spiffos_01_58", getText "ContextMenu_guizi34", MoreBuild.textBarCornerDescription, },

			{ "location_restaurant_diner_01_27", "location_restaurant_diner_01_29", "location_restaurant_diner_01_31", "location_restaurant_diner_01_25", getText "ContextMenu_guizi35", MoreBuild.textBarElementDescription, },
			{ "location_restaurant_diner_01_26", "location_restaurant_diner_01_28", "location_restaurant_diner_01_30", "location_restaurant_diner_01_24", getText "ContextMenu_guizi36", MoreBuild.textBarCornerDescription, },

			{ "location_shop_zippee_01_19", "location_shop_zippee_01_21", "location_shop_zippee_01_23", "location_shop_zippee_01_17", getText "ContextMenu_guizi37", MoreBuild.textBarElementDescription, },
			{ "location_shop_zippee_01_18", "location_shop_zippee_01_20", "location_shop_zippee_01_22", "location_shop_zippee_01_16", getText "ContextMenu_guizi38", MoreBuild.textBarCornerDescription, },
		},
	}

	return _barElementData
end

MoreBuild.otherFurnitureMenuBuilder = function(subMenu, player)
	local _sprite
	local _option
	local _tooltip
	local _name = ""
	local _icon = ""

	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 4,
			Text = getItemText("Plank"),
		},

		{
			Material = "Nails",
			Amount = 4,
			Text = getItemText("Nails"),
		},

		{
			Material = "Drawer",
			Amount = 1,
			Text = getItemText("Drawer"),
		},
	}

	MoreBuild.neededTools = {"Hammer"}


	local _furnitureData = MoreBuild.getOtherFurnitureData()

	for _, _currentList in pairs(_furnitureData) do
		_sprite = {}
		_sprite.sprite = _currentList[1]
		_sprite.northSprite = _currentList[2]
		_sprite.eastSprite = _currentList[3]
		_sprite.southSprite = _currentList[4]

		_name = _currentList[5]
		_icon = _currentList[6]

		_option = subMenu:addOption(_name, nil, MoreBuild.onBuildDresser, _sprite, player, _name, _icon)

		_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.advancedContainer, MoreBuild.ElectricityskillLevel.none, _option, player)
		_tooltip.description = _currentList[7] .. _tooltip.description
		_tooltip:setName(_name)
		_tooltip:setTexture(_sprite.sprite)
	end
end

MoreBuild.getOtherFurnitureData = function()
	local _otherFurnitureData =
	{
		{
			"location_business_office_generic_01_16", "location_business_office_generic_01_17", "location_business_office_generic_01_24", "location_business_office_generic_01_25",

			getText "ContextMenu_huisewenjiangui", "officedrawers", getText "Tooltip_huisewenjianguitip",
		},
		{
			"location_business_office_generic_01_32", "location_business_office_generic_01_33", "location_business_office_generic_01_34", "location_business_office_generic_01_35",

			getText "ContextMenu_huangsewenjiangui", "officedrawers", getText "Tooltip_huangsewenjianguitip",
		},
		{
			"location_community_medical_01_36", "location_community_medical_01_37", "location_community_medical_01_38", "location_community_medical_01_39",

			getText "ContextMenu_yiyaogui", "medicine", getText "Tooltip_yiyaoguitip",
		},
		{
			"furniture_storage_01_53", "furniture_storage_01_52", "furniture_storage_01_54", "furniture_storage_01_55",

			getText "ContextMenu_choutichaji", "sidetable", getText "Tooltip_choutichajitip",
		},

		{
			"location_community_school_01_4", "location_community_school_01_5", "location_community_school_01_7", "location_community_school_01_6",

			getText "ContextMenu_zongsekezhuo", "officedrawers", getText "Tooltip_zongsekezhuotip",
		},
		{
			"location_community_school_01_12", "location_community_school_01_13", "location_community_school_01_15", "location_community_school_01_14",

			getText "ContextMenu_lvsekezhuo", "officedrawers", getText "Tooltip_zongsekezhuotip",
		},
		{
			"furniture_tables_low_01_12", "furniture_tables_low_01_13", "furniture_tables_low_01_12", "furniture_tables_low_01_13",

			getText "ContextMenu_kafeizhuo", "sidetable", getText "Tooltip_kafeizhuotip",
		},
	}

	return _otherFurnitureData
end

MoreBuild.metalLockersMenuBuilder = function(subMenu, player)
	local _sprite
	local _option
	local _tooltip
	local _name = ""

	MoreBuild.neededMaterials =
	{
		{
			Material = "SheetMetal",
			Amount = 2,
			Text = getItemText("Sheet Metal"),
		},

		{
			Material = "Screws",
			Amount = 6,
			Text = getItemText("Screws"),
		},

		{
			Material = "Hinge",
			Amount = 2,
			Text = getItemText("Door Hinge"),
		},
	}

	MoreBuild.neededTools = { "Screwdriver", }

	_sprite = {}
	_sprite.sprite = "furniture_storage_02_9"
	_sprite.northSprite = "furniture_storage_02_8"
	_sprite.southSprite = "furniture_storage_02_10"
	_sprite.eastSprite = "furniture_storage_02_11"

	_name = getText "ContextMenu_qianggui"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildMetalLocker, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.complexFurniture, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_qiangguitip" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "furniture_storage_02_1"
	_sprite.northSprite = "furniture_storage_02_0"
	_sprite.southSprite = "furniture_storage_02_2"
	_sprite.eastSprite = "furniture_storage_02_3"

	_name = getText "ContextMenu_jinshugui"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildMetalLocker, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.complexFurniture, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_jinshuguitip" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "location_business_bank_01_43"
	_sprite.northSprite = "location_business_bank_01_42"
	_sprite.southSprite = "location_business_bank_01_44"
	_sprite.eastSprite = "location_business_bank_01_45"

	_name = getText "ContextMenu_jinshuchuwugui"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildMetalLocker, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.complexFurniture, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_jinshuchuwuguitip" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "furniture_storage_02_4"
	_sprite.northSprite = "furniture_storage_02_5"
	_sprite.southSprite = "furniture_storage_02_7"
	_sprite.eastSprite = "furniture_storage_02_6"

	_name = getText "ContextMenu_lasechuwugui"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildHangingMetalLocker, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.complexFurniture, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_lansechuwuguitip" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	_sprite = {}
	_sprite.sprite = "furniture_storage_02_12"
	_sprite.northSprite = "furniture_storage_02_13"
	_sprite.southSprite = "furniture_storage_02_15"
	_sprite.eastSprite = "furniture_storage_02_14"

	_name = getText "ContextMenu_huangsechuwugui"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildHangingMetalLocker, _sprite, player, _name)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.complexFurniture, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_huangsechuwuguitip" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)
end

MoreBuild.onBuildMetalLocker = function(ignoreThisArgument, sprite, player, name)
	local _locker = ISSimpleFurniture:new(name, sprite.sprite, sprite.northSprite)

	_locker.canBeAlwaysPlaced = true
	_locker.isContainer = true
	_locker.canBeLockedByPadlock = true
	_locker.containerType = "shelves"
	_locker:setEastSprite(sprite.eastSprite)
	_locker:setSouthSprite(sprite.southSprite)
	_locker.player = player
	_locker.name = name

	_locker.modData["need:Base.SheetMetal"] = "2"
	_locker.modData["need:Base.Screws"] = "6"
	_locker.modData["need:Base.Hinge"] = "2"
	_locker.modData["xp:Woodwork"] = "5"

	function _locker:getHealth()
		self.javaObject:getContainer():setType("vendingsnack")
		return MoreBuild.healthLevel.metalContainer + buildUtil.getWoodHealth(self)
	end

	MoreBuild.equipToolPrimary(_locker, player, "Screwdriver")

	getCell():setDrag(_locker, player)
end

MoreBuild.onBuildHangingMetalLocker = function(ignoreThisArgument, sprite, player, name)
	local _locker = ISSimpleFurniture:new(name, sprite.sprite, sprite.northSprite)

	_locker.canBeAlwaysPlaced = true
	_locker.isContainer = true
	_locker.canBeLockedByPadlock = true
	_locker.containerType = "shelves"
	_locker:setEastSprite(sprite.eastSprite)
	_locker:setSouthSprite(sprite.southSprite)
	_locker.player = player
	_locker.name = name

	_locker.modData["need:Base.SheetMetal"] = "2"
	_locker.modData["need:Base.Screws"] = "6"
	_locker.modData["need:Base.Hinge"] = "2"
	_locker.modData["xp:Woodwork"] = "5"

	function _locker:getHealth()
		self.javaObject:getContainer():setType("filingcabinet")
		return MoreBuild.healthLevel.metalContainer + buildUtil.getWoodHealth(self)
	end

	getCell():setDrag(_locker, player)
end

MoreBuild.smallTablesMenuBuilder = function(subMenu, player)
	local _sprite
	local _option
	local _tooltip
	local _name = ""


	local _tableData = MoreBuild.getSmallTableData()

	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 5,
			Text = getItemText("Plank"),
		},

		{
			Material = "Nails",
			Amount = 4,
			Text = getItemText("Nails"),
		},
	}

	MoreBuild.neededTools = {"Hammer"}

	for _, _currentList in pairs(_tableData) do
		_sprite = {}
		_sprite.sprite = _currentList[1]
		_sprite.northSprite = _currentList[2]

		_name = _currentList[3]

		_option = subMenu:addOption(_name, nil, MoreBuild.onBuildSingleTileWoodenTable, _sprite, player, _name)

		_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.simpleFurniture, MoreBuild.ElectricityskillLevel.none, _option, player)
		_tooltip.description = _currentList[4] .. _tooltip.description
		_tooltip:setName(_name)
		_tooltip:setTexture(_sprite.sprite)
	end
end

MoreBuild.getSmallTableData = function()
	local _smallTableData =
	{
		{ "furniture_tables_high_01_15", "furniture_tables_high_01_15", getText "ContextMenu_zhuozi", MoreBuild.textSmallTableDescription, },
		{ "location_restaurant_pileocrepe_01_37", "location_restaurant_pileocrepe_01_36", getText "ContextMenu_zhuozi1", MoreBuild.textSmallTableDescription, },
		{ "furniture_tables_high_01_16", "furniture_tables_high_01_16", getText "ContextMenu_zhuozi2", MoreBuild.textSmallTableDescription, },

		{ "furniture_tables_high_01_7", "furniture_tables_high_01_7", getText "ContextMenu_zhuozi3", MoreBuild.textSmallTableDescription, },
		{ "furniture_tables_high_01_6", "furniture_tables_high_01_6", getText "ContextMenu_zhuozi4", MoreBuild.textSmallTableDescription, },

		{ "furniture_tables_high_01_13", "furniture_tables_high_01_12", getText "ContextMenu_zhuozi5", MoreBuild.textSmallTableDescription, },
		{ "furniture_tables_high_01_21", "furniture_tables_high_01_22", getText "ContextMenu_zhuozi6", MoreBuild.textSmallTableDescription, },
		{ "furniture_tables_high_01_4", "furniture_tables_high_01_5", getText "ContextMenu_zhuozi7", MoreBuild.textSmallTableDescription, },

		{ "furniture_tables_low_01_16", "furniture_tables_low_01_17", getText "ContextMenu_zhuozi8", MoreBuild.textSmallTableDescription, },
		{ "furniture_tables_low_01_2", "furniture_tables_low_01_3", getText "ContextMenu_zhuozi9", MoreBuild.textSmallTableDescription, },
		{ "furniture_tables_low_01_21", "furniture_tables_low_01_20", getText "ContextMenu_zhuozi10", MoreBuild.textSmallTableDescription, },
	}

	return _smallTableData
end

MoreBuild.onBuildSingleTileWoodenTable = function(ignoreThisArgument, sprite, player, name)
	local _table = ISSimpleFurniture:new(name, sprite.sprite, sprite.northSprite)

	_table.player = player
	_table.name = name

	_table.modData["need:Base.Plank"] = "5"
	_table.modData["need:Base.Nails"] = "4"
	_table.modData["xp:Woodwork"] = "5"

	getCell():setDrag(_table, player)
end

MoreBuild.largeTablesMenuBuilder = function(subMenu, player)
	local _sprite
	local _option
	local _tooltip
	local _name = ""


	local _tableData = MoreBuild.getLargeTableData()

	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 6,
			Text = getItemText("Plank"),
		},

		{
			Material = "Nails",
			Amount = 4,
			Text = getItemText("Nails"),
		},
	}

	MoreBuild.neededTools = {"Hammer"}

	for _, _currentList in pairs(_tableData) do
		_sprite = {}
		_sprite.sprite = _currentList[1]
		_sprite.sprite2 = _currentList[2]
		_sprite.northSprite = _currentList[3]
		_sprite.northSprite2 = _currentList[4]

		_name = _currentList[5]

		_option = subMenu:addOption(_name, nil, MoreBuild.onBuildDoubleTileWoodenTable, _sprite, player, _name)

		_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.complexFurniture, MoreBuild.ElectricityskillLevel.none, _option, player)
		_tooltip.description = _currentList[6] .. _tooltip.description
		_tooltip:setName(_name)
		_tooltip:setTexture(_sprite.sprite)
	end
end

MoreBuild.getLargeTableData = function()
	local _largeTableData =
	{
		{ "location_restaurant_pileocrepe_01_33", "location_restaurant_pileocrepe_01_32", "location_restaurant_pileocrepe_01_34", "location_restaurant_pileocrepe_01_35", getText "ContextMenu_zhuozi11", MoreBuild.textLargeTableDescription, },
		{ "furniture_tables_high_01_9", "furniture_tables_high_01_8", "furniture_tables_high_01_10", "furniture_tables_high_01_11", getText "ContextMenu_zhuozi12", MoreBuild.textLargeTableDescription, },
		{ "furniture_tables_high_01_1", "furniture_tables_high_01_0", "furniture_tables_high_01_2", "furniture_tables_high_01_3", getText "ContextMenu_zhuozi13", MoreBuild.textLargeTableDescription, },
		{ "furniture_tables_high_01_41", "furniture_tables_high_01_40", "furniture_tables_high_01_42", "furniture_tables_high_01_43", getText "ContextMenu_zhuozi14", MoreBuild.textLargeTableDescription, },
		{ "furniture_tables_high_01_37", "furniture_tables_high_01_36", "furniture_tables_high_01_38", "furniture_tables_high_01_39", getText "ContextMenu_zhuozi15", MoreBuild.textLargeTableDescription, },

		{ "furniture_tables_high_01_35", "furniture_tables_high_01_34", "furniture_tables_high_01_32", "furniture_tables_high_01_33", getText "ContextMenu_zhuozi16", getText "Tooltip_bangongshitip", },
		{ "furniture_tables_high_01_45", "furniture_tables_high_01_44", "furniture_tables_high_01_46", "furniture_tables_high_01_47", getText "ContextMenu_zhuozi17", getText "Tooltip_chuftip", },

		{ "furniture_tables_high_01_53", "furniture_tables_high_01_52", "furniture_tables_high_01_54", "furniture_tables_high_01_55", getText "ContextMenu_zhuozi18", getText "Tooltip_chucunyunshutip", },
		{ "furniture_tables_high_01_51", "furniture_tables_high_01_50", "furniture_tables_high_01_48", "furniture_tables_high_01_49", getText "ContextMenu_zhuozi19", getText "Tooltip_chucunyunshutip", },
		{ "furniture_tables_high_01_57", "furniture_tables_high_01_56", "furniture_tables_high_01_58", "furniture_tables_high_01_59", getText "ContextMenu_zhuozi20", getText "Tooltip_chucunyunshutip", },

		{ "furniture_tables_low_01_15", "furniture_tables_low_01_14", "furniture_tables_low_01_0", "furniture_tables_low_01_1", getText "ContextMenu_zhuozi21", getText "Tooltip_chajishafatip", },
	}

	return _largeTableData
end

MoreBuild.onBuildDoubleTileWoodenTable = function(ignoreThisArgument, sprite, player, name)
	local _table = ISDoubleTileFurniture:new(name, sprite.sprite, sprite.sprite2, sprite.northSprite, sprite.northSprite2)

	_table.player = player
	_table.name = name

	_table.modData["need:Base.Plank"] = "6"
	_table.modData["need:Base.Nails"] = "4"
	_table.modData["xp:Woodwork"] = "5"

	getCell():setDrag(_table, player)
end

MoreBuild.chairsMenuBuilder = function(subMenu, player, context, worldobjects)
	local _sprite
	local _option
	local _tooltip
	local _name = ""

	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 5,
			Text = getItemText("Plank"),
		},

		{
			Material = "Nails",
			Amount = 4,
			Text = getItemText("Nails"),
		},
	}

	MoreBuild.neededTools = {"Hammer"}


	local _chairsData = MoreBuild.getSeatingData()
	local _currentOption
	local _currentSubMenu

	for _subsectionName, _subsectionData in pairs(_chairsData) do

		_currentOption = subMenu:addOption(_subsectionName, worldobjects, nil)
		_currentSubMenu = subMenu:getNew(subMenu)
		context:addSubMenu(_currentOption, _currentSubMenu)

		for _, _currentList in pairs(_subsectionData) do
			_sprite = {}
			_sprite.sprite = _currentList[1]
			_sprite.northSprite = _currentList[2]
			_sprite.eastSprite = _currentList[3]
			_sprite.southSprite = _currentList[4]

			_name = _currentList[5]

			_option = _currentSubMenu:addOption(_name, nil, MoreBuild.onBuildWoodenChair, _sprite, player, _name)
			_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.simpleFurniture, MoreBuild.ElectricityskillLevel.none, _option, player)
			_tooltip.description = _currentList[6] .. _tooltip.description
			_tooltip:setName(_name)
			_tooltip:setTexture(_sprite.sprite)
		end
	end
end

-- 长凳类别有BUG，暂时移除
MoreBuild.getSeatingData = function()
	local _seatingData =
	{
        --[[
		[getText "ContextMenu_changdeng"] =
		{
			{ "location_shop_mall_01_35", "location_shop_mall_01_32", "location_shop_mall_01_35", "location_shop_mall_01_32", getText "ContextMenu_dengzi1", getText "Tooltip_dengzi1", },
			{ "location_trailer_02_9", "location_trailer_02_8", "location_trailer_02_9", "location_trailer_02_8", getText "ContextMenu_dengzi2", getText "Tooltip_dengzi2", },
			{ "furniture_seating_indoor_02_16", "furniture_seating_indoor_02_19", "furniture_seating_indoor_02_16", "furniture_seating_indoor_02_19", getText "ContextMenu_dengzi3", getText "Tooltip_dengzi3", },
		},
--]]

		[getText "ContextMenu_muyi"] =
		{
			{ "furniture_seating_indoor_02_4", "furniture_seating_indoor_02_5", "furniture_seating_indoor_02_6", "furniture_seating_indoor_02_7", getText "ContextMenu_dengzi4", getText "Tooltip_dengzi4", },
			{ "location_restaurant_pileocrepe_01_40", "location_restaurant_pileocrepe_01_41", "location_restaurant_pileocrepe_01_42", "location_restaurant_pileocrepe_01_43", getText "ContextMenu_dengzi5", getText "Tooltip_dengzi4", },
			{ "furniture_seating_indoor_02_1", "furniture_seating_indoor_02_0", "furniture_seating_indoor_02_3", "furniture_seating_indoor_02_2", getText "ContextMenu_dengzi6", getText "Tooltip_dengzi4", },
			{ "furniture_seating_indoor_02_8", "furniture_seating_indoor_02_9", "furniture_seating_indoor_02_10", "furniture_seating_indoor_02_11", getText "ContextMenu_dengzi7", getText "Tooltip_dengzi4", },
			{ "furniture_seating_indoor_02_57", "furniture_seating_indoor_02_56", "furniture_seating_indoor_02_59", "furniture_seating_indoor_02_58", getText "ContextMenu_dengzi8", getText "Tooltip_dengzi4", },
			{ "furniture_seating_indoor_03_56", "furniture_seating_indoor_03_57", "furniture_seating_indoor_03_58", "furniture_seating_indoor_03_59", getText "ContextMenu_dengzi9", getText "Tooltip_dengzi4", },
			{ "furniture_seating_indoor_03_44", "furniture_seating_indoor_03_45", "furniture_seating_indoor_03_46", "furniture_seating_indoor_03_47", getText "ContextMenu_dengzi10", getText "Tooltip_dengzi5", },
			{ "furniture_seating_indoor_01_56", "furniture_seating_indoor_01_57", "furniture_seating_indoor_01_58", "furniture_seating_indoor_01_59", getText "ContextMenu_dengzi11", getText "Tooltip_dengzi5", },
		},


		[getText "ContextMenu_jianyiyizi"] =
		{
			{ "furniture_seating_indoor_01_61", "furniture_seating_indoor_01_60", "furniture_seating_indoor_01_63", "furniture_seating_indoor_01_62", getText "ContextMenu_dengzi12", getText "Tooltip_dengzi7", },
			{ "furniture_seating_indoor_01_49", "furniture_seating_indoor_01_50", "furniture_seating_indoor_01_48", "furniture_seating_indoor_01_51", getText "ContextMenu_dengzi13", getText "Tooltip_dengzi8", },
			{ "furniture_seating_indoor_02_12", "furniture_seating_indoor_02_13", "furniture_seating_indoor_02_14", "furniture_seating_indoor_02_15", getText "ContextMenu_dengzi14", getText "Tooltip_dengzi9", },
			{ "furniture_seating_indoor_01_53", "furniture_seating_indoor_01_54", "furniture_seating_indoor_01_52", "furniture_seating_indoor_01_55", getText "ContextMenu_dengzi15", getText "Tooltip_dengzi10", },
		},


		[getText "ContextMenu_ruandianyizi"] =
		{
			{ "furniture_seating_indoor_01_40", "furniture_seating_indoor_01_41", "furniture_seating_indoor_01_42", "furniture_seating_indoor_01_43", getText "ContextMenu_dengzi16", getText "Tooltip_dengzi11", },
			{ "furniture_seating_indoor_01_36", "furniture_seating_indoor_01_37", "furniture_seating_indoor_01_38", "furniture_seating_indoor_01_39", getText "ContextMenu_dengzi17", getText "Tooltip_dengzi12", },
			{ "furniture_seating_indoor_03_48", "furniture_seating_indoor_03_49", "furniture_seating_indoor_03_50", "furniture_seating_indoor_03_51", getText "ContextMenu_dengzi18", getText "Tooltip_dengzi11", },
			{ "furniture_seating_indoor_03_40", "furniture_seating_indoor_03_41", "furniture_seating_indoor_03_42", "furniture_seating_indoor_03_43", getText "ContextMenu_dengzi19", getText "Tooltip_dengzi11", },
		},


		[getText "ContextMenu_ruandianyizitip"] =
		{
			{ "furniture_seating_indoor_03_24", "furniture_seating_indoor_03_25", "furniture_seating_indoor_03_26", "furniture_seating_indoor_03_27", getText "ContextMenu_dengzi20", getText "Tooltip_dengzi12", },
			{ "furniture_seating_indoor_03_5", "furniture_seating_indoor_03_4", "furniture_seating_indoor_03_6", "furniture_seating_indoor_03_7", getText "ContextMenu_dengzi21", getText "Tooltip_dengzi12", },
			{ "furniture_seating_indoor_02_45", "furniture_seating_indoor_02_44", "furniture_seating_indoor_02_46", "furniture_seating_indoor_02_47", getText "ContextMenu_dengzi22", getText "Tooltip_dengzi12", },
			{ "furniture_seating_indoor_02_40", "furniture_seating_indoor_02_41", "furniture_seating_indoor_02_42", "furniture_seating_indoor_02_43", getText "ContextMenu_dengzi23", getText "Tooltip_dengzi12", },
			{ "furniture_seating_indoor_01_8", "furniture_seating_indoor_01_9", "furniture_seating_indoor_01_10", "furniture_seating_indoor_01_11", getText "ContextMenu_dengzi24", getText "Tooltip_dengzi12", },
			{ "furniture_seating_indoor_03_29", "furniture_seating_indoor_03_28", "furniture_seating_indoor_03_30", "furniture_seating_indoor_03_31", getText "ContextMenu_dengzi25", getText "Tooltip_dengzi12", },
			{ "furniture_seating_indoor_01_13", "furniture_seating_indoor_01_12", "furniture_seating_indoor_01_14", "furniture_seating_indoor_01_15", getText "ContextMenu_dengzi26", getText "Tooltip_dengzi12", },
			{ "furniture_seating_indoor_01_46", "furniture_seating_indoor_01_47", "furniture_seating_indoor_01_46", "furniture_seating_indoor_01_47", getText "ContextMenu_dengzi27", getText "Tooltip_dengzi13", },
			{ "furniture_seating_indoor_01_32", "furniture_seating_indoor_01_33", "furniture_seating_indoor_01_34", "furniture_seating_indoor_01_35", getText "ContextMenu_dengzi28", getText "Tooltip_dengzi12", },
			{ "furniture_seating_indoor_02_21", "furniture_seating_indoor_02_20", "furniture_seating_indoor_02_22", "furniture_seating_indoor_02_23", getText "ContextMenu_dengzi29", getText "Tooltip_dengzi12", },
		},


		[getText "ContextMenu_dengzi"] =
		{
			{ "location_restaurant_diner_01_42", "location_restaurant_diner_01_42", "location_restaurant_diner_01_42", "location_restaurant_diner_01_42", getText "ContextMenu_dengzi30", getText "Tooltip_dengzi14", },
			{ "location_community_medical_01_10", "location_community_medical_01_10", "location_community_medical_01_10", "location_community_medical_01_10", getText "ContextMenu_dengzi31", getText "Tooltip_dengzi15", },
			{ "location_restaurant_bar_01_25", "location_restaurant_bar_01_25", "location_restaurant_bar_01_25", "location_restaurant_bar_01_25", getText "ContextMenu_dengzi32", getText "Tooltip_dengzi16", },
			{ "location_restaurant_bar_01_26", "location_restaurant_bar_01_26", "location_restaurant_bar_01_26", "location_restaurant_bar_01_26", getText "ContextMenu_dengzi33", getText "Tooltip_dengzi16", },
			{ "location_restaurant_spiffos_02_25", "location_restaurant_spiffos_02_24", "location_restaurant_spiffos_02_27", "location_restaurant_spiffos_02_26", getText "ContextMenu_dengzi34", getText "Tooltip_dengzi19", },
			{ "location_services_beauty_01_1", "location_services_beauty_01_2", "location_services_beauty_01_0", "location_services_beauty_01_3", getText "ContextMenu_dengzi35", getText "Tooltip_dengzi20", },
			{ "location_shop_mall_01_41", "location_shop_mall_01_40", "location_shop_mall_01_43", "location_shop_mall_01_42", getText "ContextMenu_dengzi36", getText "Tooltip_dengzi21", },
		},
	}

	return _seatingData
end

MoreBuild.onBuildWoodenChair = function(ignoreThisArgument, sprite, player, name)
	local _chair = ISSimpleFurniture:new(name, sprite.sprite, sprite.northSprite)

	_chair.canPassThrough = true
	_chair.player = player
	_chair.name = name

	_chair:setEastSprite(sprite.eastSprite)
	_chair:setSouthSprite(sprite.southSprite)

	_chair.modData["need:Base.Plank"] = "5"
	_chair.modData["need:Base.Nails"] = "4"
	_chair.modData["xp:Woodwork"] = "5"

	getCell():setDrag(_chair, player)
end

MoreBuild.couchesMenuBuilder = function(subMenu, player, context, worldobjects)
	local _sprite
	local _option
	local _tooltip
	local _name = ""


	local _couchData = MoreBuild.getCouchesData()


	local _frontViewOption = subMenu:addOption(getText "ContextMenu_zhengshitujianzhu", worldobjects, nil)
	local _frontViewSubMenu = subMenu:getNew(subMenu)
	context:addSubMenu(_frontViewOption, _frontViewSubMenu)

	local _backViewOption = subMenu:addOption(getText "ContextMenu_beishitujianzhu", worldobjects, nil)
	local _backViewSubMenu = subMenu:getNew(subMenu)
	context:addSubMenu(_backViewOption, _backViewSubMenu)

	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 6,
			Text = getItemText("Plank"),
		},

		{
			Material = "Nails",
			Amount = 4,
			Text = getItemText("Nails"),
		},

		{
			Material = "Sheet",
			Amount = 1,
			Text = getItemText("Sheet"),
		},
	}

	MoreBuild.neededTools = {"Hammer"}


	for _, _currentList in pairs(_couchData) do
		_name = _currentList[9]

		_sprite = {}
		_sprite.sprite = _currentList[1]
		_sprite.sprite2 = _currentList[2]
		_sprite.northSprite = _currentList[3]
		_sprite.northSprite2 = _currentList[4]

		_option = _frontViewSubMenu:addOption(_name, nil, MoreBuild.onBuildCouch, _sprite, player, _name)

		_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.complexFurniture, MoreBuild.ElectricityskillLevel.none, _option, player)
		_tooltip.description = MoreBuild.textCouchFrontDescription .. _tooltip.description
		_tooltip:setName(_name)
		_tooltip:setTexture(_sprite.sprite)

		_sprite = {}
		_sprite.sprite = _currentList[5]
		_sprite.sprite2 = _currentList[6]
		_sprite.northSprite = _currentList[7]
		_sprite.northSprite2 = _currentList[8]

		_option = _backViewSubMenu:addOption(_name, nil, MoreBuild.onBuildCouch, _sprite, player, _name)

		_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.complexFurniture, MoreBuild.ElectricityskillLevel.none, _option, player)
		_tooltip.description = MoreBuild.textCouchRearDescription .. _tooltip.description
		_tooltip:setName(_name)
		_tooltip:setTexture(_sprite.sprite)
	end
end

MoreBuild.getCouchesData = function()
	local _couchesData =
	{
		{
			"furniture_seating_indoor_03_32", "furniture_seating_indoor_03_33", "furniture_seating_indoor_03_34", "furniture_seating_indoor_03_35",
			"furniture_seating_indoor_03_37", "furniture_seating_indoor_03_36", "furniture_seating_indoor_03_38", "furniture_seating_indoor_03_39",

			getText "ContextMenu_lanse",
		},
		{
			"furniture_seating_indoor_03_9", "furniture_seating_indoor_03_8", "furniture_seating_indoor_03_10", "furniture_seating_indoor_03_11",
			"furniture_seating_indoor_03_15", "furniture_seating_indoor_03_14", "furniture_seating_indoor_03_12", "furniture_seating_indoor_03_13",

			getText "ContextMenu_fenlanse",
		},
		{
			"furniture_seating_indoor_02_49", "furniture_seating_indoor_02_48", "furniture_seating_indoor_02_50", "furniture_seating_indoor_02_51",
			"furniture_seating_indoor_02_55", "furniture_seating_indoor_02_54", "furniture_seating_indoor_02_52", "furniture_seating_indoor_02_53",

			getText "ContextMenu_zongse",
		},
		{
			"furniture_seating_indoor_02_35", "furniture_seating_indoor_02_34", "furniture_seating_indoor_02_32", "furniture_seating_indoor_02_33",
			"furniture_seating_indoor_02_39", "furniture_seating_indoor_02_38", "furniture_seating_indoor_02_36", "furniture_seating_indoor_02_37",

			getText "ContextMenu_Gray_Cinder_Block",
		},
		{
			"furniture_seating_indoor_01_16", "furniture_seating_indoor_01_17", "furniture_seating_indoor_01_18", "furniture_seating_indoor_01_19",
			"furniture_seating_indoor_01_21", "furniture_seating_indoor_01_20", "furniture_seating_indoor_01_22", "furniture_seating_indoor_01_23",

			getText "ContextMenu_ganlanlv",
		},
		{
			"furniture_seating_indoor_03_17", "furniture_seating_indoor_03_16", "furniture_seating_indoor_03_18", "furniture_seating_indoor_03_19",
			"furniture_seating_indoor_03_23", "furniture_seating_indoor_03_22", "furniture_seating_indoor_03_20", "furniture_seating_indoor_03_21",

			getText "ContextMenu_lvse",
		},
		{
			"furniture_seating_indoor_01_1", "furniture_seating_indoor_01_0", "furniture_seating_indoor_01_2", "furniture_seating_indoor_01_3",
			"furniture_seating_indoor_01_7", "furniture_seating_indoor_01_6", "furniture_seating_indoor_01_4", "furniture_seating_indoor_01_5",

			getText "ContextMenu_chengse",
		},
		{
			"furniture_seating_indoor_01_27", "furniture_seating_indoor_01_26", "furniture_seating_indoor_01_24", "furniture_seating_indoor_01_25",
			"furniture_seating_indoor_01_31", "furniture_seating_indoor_01_30", "furniture_seating_indoor_01_28", "furniture_seating_indoor_01_29",

			getText "ContextMenu_zise",
		},
		{
			"furniture_seating_indoor_02_25", "furniture_seating_indoor_02_24", "furniture_seating_indoor_02_26", "furniture_seating_indoor_02_27",
			"furniture_seating_indoor_02_31", "furniture_seating_indoor_02_30", "furniture_seating_indoor_02_28", "furniture_seating_indoor_02_29",

			getText "ContextMenu_huangse",
		},
	}

	return _couchesData
end

MoreBuild.onBuildCouch = function(ignoreThisArgument, sprite, player, name)
	local _couch = ISDoubleTileFurniture:new(name, sprite.sprite, sprite.sprite2, sprite.northSprite, sprite.northSprite2)

	_couch.player = player
	_couch.name = name

	_couch.modData["need:Base.Plank"] = "6"
	_couch.modData["need:Base.Nails"] = "4"
	_couch.modData["need:Base.Sheet"] = "1"
	_couch.modData["xp:Woodwork"] = "5"

	getCell():setDrag(_couch, player)
end

MoreBuild.bedsMenuBuilder = function(subMenu, player)
	local _sprite
	local _option
	local _tooltip
	local _name = ""

	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 6,
			Text = getItemText("Plank"),
		},

		{
			Material = "Nails",
			Amount = 4,
			Text = getItemText("Nails"),
		},

		{
			Material = "Mattress",
			Amount = 1,
			Text = getItemText("Mattress"),
		},
	}

	MoreBuild.neededTools = {"Hammer"}

	local _bedsData = MoreBuild.getBedData()

	for _, _currentList in pairs(_bedsData) do
		_sprite = {}
		_sprite.sprite = _currentList[1]
		_sprite.sprite2 = _currentList[2]
		_sprite.northSprite = _currentList[3]
		_sprite.northSprite2 = _currentList[4]

		_name = _currentList[5]

		_option = subMenu:addOption(_name, nil, MoreBuild.onBuildBed, _sprite, player, _name)

		_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.complexFurniture, MoreBuild.ElectricityskillLevel.none, _option, player)
		_tooltip.description = _currentList[6] .. _tooltip.description
		_tooltip:setName(_name)
		_tooltip:setTexture(_sprite.sprite)
	end
end

MoreBuild.getBedData = function()
	local _bedData =
	{
		{ "furniture_bedding_01_33", "furniture_bedding_01_32", "furniture_bedding_01_34", "furniture_bedding_01_35", getText "ContextMenu_chuang", MoreBuild.textBedDescription, },
		{ "furniture_bedding_01_11", "furniture_bedding_01_10", "furniture_bedding_01_8", "furniture_bedding_01_9", getText "ContextMenu_chuang1", MoreBuild.textBedDescription, },
		{ "furniture_bedding_01_29", "furniture_bedding_01_28", "furniture_bedding_01_26", "furniture_bedding_01_27", getText "ContextMenu_chuang2", MoreBuild.textBedDescription, },
		{ "furniture_bedding_01_3", "furniture_bedding_01_2", "furniture_bedding_01_0", "furniture_bedding_01_1", getText "ContextMenu_chuang3", MoreBuild.textBedDescription, },

		{ "furniture_bedding_01_37", "furniture_bedding_01_36", "furniture_bedding_01_38", "furniture_bedding_01_39", getText "ContextMenu_chuang4", getText "Tooltip_chuang4tip", },
		{ "furniture_bedding_01_59", "furniture_bedding_01_58", "furniture_bedding_01_56", "furniture_bedding_01_57", getText "ContextMenu_chuang5", getText "Tooltip_chuang5tip", },
	}

	return _bedData
end

MoreBuild.onBuildBed = function(ignoreThisArgument, sprite, player, name)
	local _bed = ISDoubleTileFurniture:new(name, sprite.sprite, sprite.sprite2, sprite.northSprite, sprite.northSprite2)

	_bed.player = player
	_bed.name = name

	_bed.modData["need:Base.Plank"] = "6"
	_bed.modData["need:Base.Nails"] = "4"
	_bed.modData["need:Base.Mattress"] = "1"
	_bed.modData["xp:Woodwork"] = "10"

	getCell():setDrag(_bed, player)
end

MoreBuild.roadwayMenuBuilder = function(subMenu, player)
	local _sprite
	local _option
	local _tooltip
	local _name = ""

	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 1,
			Text = getItemText("Plank"),
		},

		{
			Material = "Nails",
			Amount = 1,
			Text = getItemText("Nails"),
		},
	}

	MoreBuild.neededTools = {"Hammer"}


	local _roadwaysData = MoreBuild.getRoadwayData()

	for _, _currentList in pairs(_roadwaysData) do
		_sprite = {}
		_sprite.sprite = _currentList[1]
		_sprite.northSprite = _currentList[2]
		_sprite.eastSprite = _currentList[3]
		_sprite.southSprite = _currentList[4]

		_name = _currentList[5]

		_option = subMenu:addOption(_name, nil, MoreBuild.onBuildSign, _sprite, player, _name)

		_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.simpleObject, MoreBuild.ElectricityskillLevel.none, _option, player)
		_tooltip.description = _currentList[6] .. _tooltip.description
		_tooltip:setName(_name)
		_tooltip:setTexture(_sprite.sprite)
	end
end

MoreBuild.getRoadwayData = function()
	local _roadwayData =
	{
		{
			"street_decoration_01_5", "street_decoration_01_4", "street_decoration_01_7", "street_decoration_01_6",
			getText "ContextMenu_roadwayData", getText "Tooltip_roadwayData",
		},
		{
			"street_decoration_01_19", "street_decoration_01_18", "street_decoration_01_21", "street_decoration_01_20",

			getText "ContextMenu_roadwayData1", getText "Tooltip_roadwayData1",
		},

		{
			"street_decoration_01_12", "street_decoration_01_12", "street_decoration_01_12", "street_decoration_01_12",

			getText "ContextMenu_roadwayData2", getText "Tooltip_roadwayData2",
		},
		{
			"street_decoration_01_26", "street_decoration_01_26", "street_decoration_01_26", "street_decoration_01_26",

			getText "ContextMenu_roadwayData3", getText "Tooltip_roadwayData3",
		},
		{
			"street_decoration_01_27", "street_decoration_01_27", "street_decoration_01_27", "street_decoration_01_27",

			getText "ContextMenu_roadwayData4", getText "Tooltip_roadwayData4",
		},
	}

	return _roadwayData
end

MoreBuild.signsMenuBuilder = function(subMenu, player)
	local _sprite
	local _option
	local _tooltip
	local _name = ""

	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 1,
			Text = getItemText("Plank"),
		},

		{
			Material = "Nails",
			Amount = 1,
			Text = getItemText("Nails"),
		},
	}

	MoreBuild.neededTools = {"Hammer"}


	local _signsData = MoreBuild.getSignData()


	for _, _currentList in pairs(_signsData) do
		_sprite = {}
		_sprite.sprite = _currentList[1]
		_sprite.northSprite = _currentList[2]
		_sprite.eastSprite = _currentList[3]
		_sprite.southSprite = _currentList[4]

		_name = _currentList[5]

		_option = subMenu:addOption(_name, nil, MoreBuild.onBuildSign, _sprite, player, _name)

		_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.simpleObject, MoreBuild.ElectricityskillLevel.none, _option, player)
		_tooltip.description = _currentList[6] .. _tooltip.description
		_tooltip:setName(_name)
		_tooltip:setTexture(_sprite.sprite)
	end
end

MoreBuild.getSignData = function()
	local _signData =
	{
		{ "location_restaurant_spiffos_02_58", "location_restaurant_spiffos_02_59", "location_restaurant_spiffos_02_57", "location_restaurant_spiffos_02_56", getText "ContextMenu_jiantou", getText "Tooltip_jiantoutip", },
		{ "street_decoration_01_1", "street_decoration_01_0", "street_decoration_01_3", "street_decoration_01_2", getText "ContextMenu_stopcar", getText "Tooltip_stop", },
		{ "location_shop_accessories_genericsigns_01_7", "location_shop_accessories_genericsigns_01_6", "location_shop_accessories_genericsigns_01_7", "location_shop_accessories_genericsigns_01_6", getText "ContextMenu_buy", getText "Tooltip_buytip", },
	}

	return _signData
end

MoreBuild.onBuildSign = function(ignoreThisArgument, sprite, player, name)
	local _sign = ISSimpleFurniture:new(name, sprite.sprite, sprite.northSprite)

	_sign.blockAllTheSquare = false
	_sign.player = player
	_sign.name = name
	_sign.eastSprite = sprite.eastSprite
	_sign.southSprite = sprite.southSprite

	_sign.modData["need:Base.Plank"] = "1"
	_sign.modData["need:Base.Nails"] = "1"
	_sign.modData["xp:Woodwork"] = "5"

	getCell():setDrag(_sign, player)
end

MoreBuild.wallDecorationsMenuBuilder = function(subMenu, player, context, worldobjects)
	local _sprite
	local _option
	local _tooltip
	local _name = ""


	local _wallDecorationData = MoreBuild.getWallDecorationsData()

	MoreBuild.neededMaterials =
	{
		{
			Material = "SheetPaper2",
			Amount = 1,
			Text = getItemText("Sheet of Paper"),
		},

		{
			Material = "Nails",
			Amount = 1,
			Text = getItemText("Nails"),
		},
	}

	MoreBuild.neededTools = {"Hammer"}

	for _subsectionName, _subsectionData in pairs(_wallDecorationData) do

		_currentOption = subMenu:addOption(_subsectionName, worldobjects, nil)
		_currentSubMenu = subMenu:getNew(subMenu)
		context:addSubMenu(_currentOption, _currentSubMenu)

		for _, _currentList in pairs(_subsectionData) do
			_sprite = {}
			_sprite.sprite = _currentList[2]
			_sprite.northSprite = _currentList[1]

			_name = _currentList[3]

			_option = _currentSubMenu:addOption(_name, nil, MoreBuild.onBuildWallDecoration, _sprite, player, _name)

			_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.simpleDecoration, MoreBuild.ElectricityskillLevel.none, _option, player)
			_tooltip.description = _currentList[4] .. _tooltip.description
			_tooltip:setName(_name)
			_tooltip:setTexture(_sprite.sprite)
		end
	end
end

MoreBuild.getWallDecorationsData = function()
	local _wallDecorationsData =
	{
		[getText "ContextMenu_canguan"] =
		{
			{ "location_restaurant_pie_01_22", "location_restaurant_pie_01_23", getText "ContextMenu_biaozhi", getText "Tooltip_biaozhi", },
			{ "location_restaurant_pie_01_56", "location_restaurant_pie_01_63", getText "ContextMenu_biaozhi1", getText "Tooltip_biaozhi1", },
			{ "location_restaurant_pie_01_57", "location_restaurant_pie_01_62", getText "ContextMenu_biaozhi2", getText "Tooltip_biaozhi1", },
			{ "location_restaurant_pie_01_58", "location_restaurant_pie_01_61", getText "ContextMenu_biaozhi3", getText "Tooltip_biaozhi1", },
			{ "location_restaurant_pie_01_59", "location_restaurant_pie_01_60", getText "ContextMenu_biaozhi4", getText "Tooltip_biaozhi1", },
			{ "location_restaurant_spiffos_02_14", "location_restaurant_spiffos_02_15", getText "ContextMenu_biaozhi5", getText "Tooltip_biaozhi2", },
			{ "location_shop_accessories_01_27", "location_shop_accessories_01_26", getText "ContextMenu_biaozhi6", getText "Tooltip_biaozhi3", },
		},


		[getText "ContextMenu_yiy"] =
		{
			{ "location_community_medical_01_11", "location_community_medical_01_12", getText "ContextMenu_biaozhi7", getText "Tooltip_biaozhi4", },
			{ "location_community_medical_01_14", "location_community_medical_01_13", getText "ContextMenu_biaozhi8", getText "Tooltip_biaozhi5", },
			{ "location_community_medical_01_31", "location_community_medical_01_30", getText "ContextMenu_biaozhi9", getText "Tooltip_biaozhi5", },
			{ "location_community_medical_01_29", "location_community_medical_01_28", getText "ContextMenu_biaozhi10", getText "Tooltip_biaozhi6", },
		},


		[getText "ContextMenu_dianyhaibao"] =
		{
			{ "location_entertainment_theatre_01_83", "location_entertainment_theatre_01_80", getText "ContextMenu_biaozhi11", getText "Tooltip_biaozhi7", },
			{ "location_entertainment_theatre_01_84", "location_entertainment_theatre_01_81", getText "ContextMenu_biaozhi12", getText "Tooltip_biaozhi8", },
			{ "location_entertainment_theatre_01_85", "location_entertainment_theatre_01_82", getText "ContextMenu_biaozhi13", getText "Tooltip_biaozhi9", },
		},


		[getText "ContextMenu_lunwen"] =
		{
			{ "papernotices_01_3", "papernotices_01_0", getText "ContextMenu_biaozhi14", getText "Tooltip_biaozhi10", },
			{ "papernotices_01_2", "papernotices_01_1", getText "ContextMenu_biaozhi15", getText "Tooltip_biaozhi11", },
			{ "papernotices_01_7", "papernotices_01_4", getText "ContextMenu_biaozhi16", getText "Tooltip_biaozhi12", },
			{ "papernotices_01_6", "papernotices_01_5", getText "ContextMenu_biaozhi16", getText "Tooltip_biaozhi13", },
			{ "papernotices_01_9", "papernotices_01_8", getText "ContextMenu_biaozhi16", getText "Tooltip_biaozhi14", },
		},

		[getText "ContextMenu_hua"] =
		{
			{ "walls_decoration_01_33", "walls_decoration_01_32", getText "ContextMenu_biaozhi17", getText "Tooltip_biaozhi15", },

			{ "walls_decoration_01_35", "walls_decoration_01_34", getText "ContextMenu_biaozhi18", getText "Tooltip_biaozhi16", },
			{ "walls_decoration_01_46", "walls_decoration_01_47", getText "ContextMenu_biaozhi19", getText "Tooltip_biaozhi17", },
			{ "walls_decoration_01_48", "walls_decoration_01_49", getText "ContextMenu_biaozhi20", getText "Tooltip_biaozhi18", },
			{ "walls_decoration_01_50", "walls_decoration_01_51", getText "ContextMenu_biaozhi21", getText "Tooltip_biaozhi19", },
			{ "walls_decoration_01_57", "walls_decoration_01_56", getText "ContextMenu_biaozhi22", getText "Tooltip_biaozhi20", },
		},


		[getText "ContextMenu_qita"] =
		{
			{ "walls_decoration_01_16", "walls_decoration_01_17", getText "ContextMenu_biaozhi23", getText "Tooltip_biaozhi21", },
			{ "walls_decoration_01_18", "walls_decoration_01_19", getText "ContextMenu_biaozhi24", getText "Tooltip_biaozhi22", },
			{ "location_shop_accessories_01_25", "location_shop_accessories_01_24", getText "ContextMenu_biaozhi25", getText "Tooltip_biaozhi23", },
			{ "location_community_school_01_32", "location_community_school_01_33", getText "ContextMenu_biaozhi26", getText "Tooltip_biaozhi24", },
			{ "fixtures_bathroom_01_20", "fixtures_bathroom_01_18", getText "ContextMenu_biaozhi27", getText "Tooltip_biaozhi25", },
			{ "fixtures_bathroom_01_21", "fixtures_bathroom_01_19", getText "ContextMenu_biaozhi28", getText "Tooltip_biaozhi26", },
		},
	}

	return _wallDecorationsData
end

MoreBuild.onBuildWallDecoration = function(ignoreThisArgument, sprite, player, name)
	local _decoration = ISSimpleFurniture:new(name, sprite.sprite, sprite.northSprite)

	_decoration.needToBeAgainstWall = true
	_decoration.blockAllTheSquare = false
	_decoration.renderFloorHelper = true
	_decoration.canPassThrough = true
	_decoration.canBarricade = false
	_decoration.player = player
	_decoration.name = name

	_decoration.modData["need:Base.SheetPaper2"] = "1"
	_decoration.modData["need:Base.Nails"] = "1"
	_decoration.modData["xp:Woodwork"] = "5"

	function _decoration:getHealth()
		return MoreBuild.healthLevel.wallDecoration
	end

	getCell():setDrag(_decoration, player)
end

MoreBuild.flowerBedsMenuBuilder = function(subMenu, player, context, worldobjects)
	local _sprite
	local _option
	local _tooltip
	local _name = ""

	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 1,
			Text = getItemText("Plank"),
		},

		{
			Material = "Twigs",
			Amount = 1,
			Text = getItemText("Twigs"),
		},
	}

	MoreBuild.neededTools = { "HandShovel", }


	local _flowerBedsData = MoreBuild.getFlowerBedsData()
	local _currentOption
	local _currentSubMenu

	local _justFlowersOption = subMenu:addOption(getText "ContextMenu_caoping", worldobjects, nil)
	local _justFlowersSubMenu = subMenu:getNew(subMenu)
	context:addSubMenu(_justFlowersOption, _justFlowersSubMenu)

	local _stoneLinedOption = subMenu:addOption(getText "ContextMenu_shitou", worldobjects, nil)
	local _stoneLinedSubMenu = subMenu:getNew(subMenu)
	context:addSubMenu(_stoneLinedOption, _stoneLinedSubMenu)

	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 1,
			Text = getItemText("Plank"),
		},

		{
			Material = "Twigs",
			Amount = 1,
			Text = getItemText("Twigs"),
		},
	}

	MoreBuild.neededTools = { "HandShovel", }

	for _, _currentList in pairs(_flowerBedsData[getText "ContextMenu_Just_Flowers"]) do
		_sprite = {}
		_sprite.sprite = _currentList[1]

		_name = _currentList[2]

		_option = _justFlowersSubMenu:addOption(_name, nil, MoreBuild.onBuildFlowerFloor, _sprite, player, _name)

		_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.landscaping, MoreBuild.ElectricityskillLevel.none, _option, player)
		_tooltip.description = _currentList[3] .. _tooltip.description
		_tooltip:setName(_name)
		_tooltip:setTexture(_sprite.sprite)
	end

	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 1,
			Text = getItemText("Plank"),
		},

		{
			Material = "Twigs",
			Amount = 1,
			Text = getItemText("Twigs"),
		},
	}

	MoreBuild.neededTools = { "HandShovel", }

	for _, _currentList in pairs(_flowerBedsData[getText "ContextMenu_Stone_Border"]) do
		_sprite = {}
		_sprite.sprite = _currentList[1]
		_sprite.northSprite = _currentList[2]
		_sprite.eastSprite = _currentList[3]
		_sprite.southSprite = _currentList[4]

		_name = _currentList[5]

		_option = _stoneLinedSubMenu:addOption(_name, nil, MoreBuild.onBuildFourSpriteFlowerFloor, _sprite, player, _name)

		_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.landscaping, MoreBuild.ElectricityskillLevel.none, _option, player)
		_tooltip.description = _currentList[6] .. _tooltip.description
		_tooltip:setName(_name)
		_tooltip:setTexture(_sprite.sprite)
	end
end

MoreBuild.onBuildFlowerFloor = function(ignoreThisArgument, sprite, player, name)
	local _floor = ISWoodenFloor:new(sprite.sprite, sprite.sprite)

	_floor.player = player
	_floor.name = name

	_floor.modData["need:Base.Plank"] = "1"
	_floor.modData["need:Base.Twigs"] = "1"
	_floor.modData["xp:Woodwork"] = "5"

	getCell():setDrag(_floor, player)
end


MoreBuild.onBuildFourSpriteFlowerFloor = function(ignoreThisArgument, sprite, player, name)
	local _floor = ISWoodenFloor:new(sprite.sprite, sprite.northSprite)

	_floor.player = player
	_floor.name = name
	_floor.eastSprite = sprite.eastSprite
	_floor.southSprite = sprite.southSprite

	_floor.modData["need:Base.Plank"] = "1"
	_floor.modData["need:Base.Plank"] = "1"
	_floor.modData["need:Base.Twigs"] = "1"
	_floor.modData["xp:Woodwork"] = "5"

	getCell():setDrag(_floor, player)
end

MoreBuild.getFlowerBedsData = function()
	local _flowerBedsData =
	{
		[getText "ContextMenu_Just_Flowers"] =
		{
			{ "vegetation_ornamental_01_17", getText "ContextMenu_shitou", MoreBuild.textFlowerBedDescription, },
			{ "vegetation_ornamental_01_32", getText "ContextMenu_shitou1", MoreBuild.textFlowerBedDescription, },
			{ "vegetation_ornamental_01_16", getText "ContextMenu_shitou2", MoreBuild.textFlowerBedDescription, },
			{ "vegetation_ornamental_01_18", getText "ContextMenu_shitou3", MoreBuild.textFlowerBedDescription, },
			{ "vegetation_ornamental_01_33", getText "ContextMenu_shitou4", MoreBuild.textFlowerBedDescription, },
			{ "vegetation_ornamental_01_34", getText "ContextMenu_shitou5", MoreBuild.textFlowerBedDescription, },
		},
		[getText "ContextMenu_Stone_Border"] =
		{
			{ "vegetation_ornamental_01_19", "vegetation_ornamental_01_21", "vegetation_ornamental_01_29", "vegetation_ornamental_01_23", getText "ContextMenu_shitou6", MoreBuild.textFlowerBedDescription .. MoreBuild.textCanRotate, },
			{ "vegetation_ornamental_01_20", "vegetation_ornamental_01_22", "vegetation_ornamental_01_28", "vegetation_ornamental_01_30", getText "ContextMenu_shitou7", MoreBuild.textFlowerBedDescription .. MoreBuild.textCanRotate, },
			{ "vegetation_ornamental_01_31", "vegetation_ornamental_01_31", "vegetation_ornamental_01_31", "vegetation_ornamental_01_31", getText "ContextMenu_shitou8", MoreBuild.textFlowerBedDescription, },

			{ "vegetation_ornamental_01_35", "vegetation_ornamental_01_37", "vegetation_ornamental_01_39", "vegetation_ornamental_01_45", getText "ContextMenu_shitou9", MoreBuild.textFlowerBedDescription .. MoreBuild.textCanRotate, },
			{ "vegetation_ornamental_01_36", "vegetation_ornamental_01_38", "vegetation_ornamental_01_46", "vegetation_ornamental_01_44", getText "ContextMenu_shitou10", MoreBuild.textFlowerBedDescription .. MoreBuild.textCanRotate, },
			{ "vegetation_ornamental_01_47", "vegetation_ornamental_01_47", "vegetation_ornamental_01_47", "vegetation_ornamental_01_47", getText "ContextMenu_shitou11", MoreBuild.textFlowerBedDescription, },
		},
	}

	return _flowerBedsData
end

MoreBuild.lightPostMenuBuilder = function(subMenu, player)
	local _sprite
	local _option
	local _tooltip
	local _name = ""

	local _lightPoleData = MoreBuild.getLightPoleData()

	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 2,
			Text = getItemText("Plank"),
		},

		{
			Material = "Nails",
			Amount = 4,
			Text = getItemText("Nails"),
		},

		{
			Material = "Rope",
			Amount = 1,
			Text = getItemText("Rope"),
		},

		{
			Material = "LightBulb",
			Amount = 1,
			Text = getItemText("LightBulb"),
		},
		{
			Material = "ElectricWire",
			Amount = 1,
			Text = getItemText("Electric Wire"),
		},
		{
			Material = "ElectronicsScrap",
			Amount = 5,
			Text = getItemText("Electronics Scrap"),
		},
	}

	MoreBuild.neededTools = { "Hammer" }

	for _, _currentList in pairs(_lightPoleData) do
		_sprite = {}
		_sprite.sprite = _currentList[1]

		_name = _currentList[2]

		_option = subMenu:addOption(_name, nil, MoreBuild.onBuildLightPole, _sprite, player, _name)

		_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.lighting, MoreBuild.ElectricityskillLevel.lighting, _option, player)
		_tooltip.description = MoreBuild.textLightPoleDescription .. _tooltip.description
		_tooltip:setName(_name)
		_tooltip:setTexture(_sprite.sprite)
	end
end

MoreBuild.getLightPoleData = function()
	local _lightPoleData =
	{
		{ "lighting_outdoor_01_0", getText "ContextMenu_Light_Pole", },
		{ "lighting_outdoor_01_1", getText "ContextMenu_Light_Pole", },
		{ "lighting_outdoor_01_2", getText "ContextMenu_Light_Pole", },
	}

	return _lightPoleData
end

MoreBuild.onBuildLightPole = function(ignoreThisArgument, sprite, player, name)
	local _lightPole = ISLightSource:new(sprite.sprite, sprite.sprite, getSpecificPlayer(player))

	_lightPole.offsetX = 5
	_lightPole.offsetY = 5
	_lightPole.player = player
	_lightPole.name = name

	_lightPole:setEastSprite(sprite.sprite)
	_lightPole:setSouthSprite(sprite.sprite)

	_lightPole.fuel = "Base.Battery"
	_lightPole.baseItem = "Base.LightBulb"
	_lightPole.radius = 10

	_lightPole.modData["need:Base.Plank"] = "2"
	_lightPole.modData["need:Base.Nails"] = "4"
	_lightPole.modData["need:Base.Rope"] = "1"
	_lightPole.modData["need:Base.LightBulb"] = "1"
	_lightPole.modData["need:Radio.ElectricWire"] = "1"
    _lightPole.modData["need:Base.ElectronicsScrap"] = "5"
	_lightPole.modData["xp:Woodwork"] = "5"
	_lightPole.modData["xp:Electricity"] = "5"

	getCell():setDrag(_lightPole, player)
end

MoreBuild.missingPostsMenuBuilder = function(subMenu, player)
	local _sprite
	local _option
	local _tooltip
	local _name = ""


	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 1,
			Text = getItemText("Plank"),
		},

		{
			Material = "Nails",
			Amount = 2,
			Text = getItemText("Nails"),
		},
	}

	MoreBuild.neededTools = {"Hammer"}

	_sprite = {}
	_sprite.sprite = "carpentry_02_51"
	_sprite.northSprite = "carpentry_02_51"

	_name = getText "ContextMenu_Wooden_FencePost"

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenFencePost, _sprite, player)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_yuanmuzhalanzhutip" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)

	MoreBuild.neededMaterials =
	{
		{
			Material = "Log",
			Amount = 1,
			Text = getItemText("Log"),
		},

		{
			Material = "Rope",
			Amount = 1,
			Text = getItemText("Rope"),
		},
	}

	MoreBuild.neededTools = {}

	_sprite = {}
	_sprite.sprite = "carpentry_02_83"
	_sprite.northSprite = "carpentry_02_83"

	_name = getText "ContextMenu_Log_WallPillar"

	_option = subMenu:addOption(_name .. "(Rope)", nil, MoreBuild.onBuildStonePillar, _sprite, player)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.logObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_yuanmuqiangtip" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)


	MoreBuild.neededMaterials =
	{
		{
			Material = "Log",
			Amount = 1,
			Text = getItemText("Log"),
		},

		{
			Material = "SheetRope",
			Amount = 2,
			Text = getItemText("Sheet Rope"),
		},
	}

	_option = subMenu:addOption(_name .. "(Sheet Rope)", nil, MoreBuild.onBuildStonePillar, _sprite, player)

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.logObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = getText "Tooltip_pipei" .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)
end

MoreBuild.roadwayMenuBuilder = function(subMenu, player)
	local _sprite
	local _option
	local _tooltip
	local _name = ""

	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 1,
			Text = getItemText("Plank"),
		},

		{
			Material = "Nails",
			Amount = 1,
			Text = getItemText("Nails"),
		},
	}

	MoreBuild.neededTools = {"Hammer"}


	local _roadwaysData = MoreBuild.getRoadwayData()

	for _, _currentList in pairs(_roadwaysData) do
		_sprite = {}
		_sprite.sprite = _currentList[1]
		_sprite.northSprite = _currentList[2]
		_sprite.eastSprite = _currentList[3]
		_sprite.southSprite = _currentList[4]

		_name = _currentList[5]

		_option = subMenu:addOption(_name, nil, MoreBuild.onBuildTestFence, _sprite, player, _name)

		_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.simpleObject, MoreBuild.ElectricityskillLevel.none, _option, player)
		_tooltip.description = _currentList[6] .. _tooltip.description
		_tooltip:setName(_name)
		_tooltip:setTexture(_sprite.sprite)
	end

	MoreBuild.neededMaterials =
	{
		{
			Material = "Plank",
			Amount = 2,
			Text = getItemText("Plank"),
		},

		{
			Material = "Nails",
			Amount = 2,
			Text = getItemText("Nails"),
		},
	}

	MoreBuild.neededTools = {"Hammer"}

	_sprite = {}
	_sprite.sprite = "construction_01_9"
	_sprite.northSprite = "construction_01_8"

	_name = getText "ContextMenu_Construction_Horse"
	_icon = ""

	_option = subMenu:addOption(_name, worldobjects, MoreBuild.onSurvivalItem, "Wood Barricade")

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.simpleObject, MoreBuild.ElectricityskillLevel.none, _option, player)
	_tooltip:setName(_name)
	_tooltip.description = " <RGB:106,168,79>" .. getText("Tooltip_luzhangtip") .. _tooltip.description
	_tooltip:setTexture(_sprite.sprite)
end