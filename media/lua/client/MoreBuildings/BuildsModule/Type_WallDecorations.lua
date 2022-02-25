if not getMoreBuildInstance then
  require('MoreBuildings/MoreBuilds_Main')
end

local MoreBuild = getMoreBuildInstance()

MoreBuild.onBuildWallDecoration = function(ignoreThisArgument, sprite, player, name)
  local _decoration = ISSimpleFurniture:new(name, sprite.sprite, sprite.northSprite)

  _decoration.needToBeAgainstWall = true
  _decoration.blockAllTheSquare = false
  _decoration.renderFloorHelper = true
  _decoration.canPassThrough = true
  _decoration.canBarricade = false
  _decoration.player = player
  _decoration.name = name

  _decoration.modData['need:Base.SheetPaper2'] = 1
  _decoration.modData['need:Base.Nails'] = 1
  _decoration.modData['xp:Woodwork'] = 5

  function _decoration:getHealth()
    return MoreBuild.healthLevel.wallDecoration
  end

  getCell():setDrag(_decoration, player)
end

MoreBuild.wallDecorationsMenuBuilder = function(subMenu, player, context)
  local _sprite
  local _option
  local _tooltip
  local _name = ''

  local _wallDecorationData = MoreBuild.getWallDecorationsData()

  MoreBuild.neededMaterials = {
    {
      Material = 'Base.SheetPaper2',
      Amount = 1
    },
    {
      Material = 'Base.Nails',
      Amount = 1
    }
  }

  MoreBuild.neededTools = {'Hammer'}

  local needSkills = {
    Woodwork = MoreBuild.skillLevel.simpleDecoration
  }

  for _subsectionName, _subsectionData in pairs(_wallDecorationData) do
    _currentOption = subMenu:addOption(_subsectionName)
    _currentSubMenu = subMenu:getNew(subMenu)
    context:addSubMenu(_currentOption, _currentSubMenu)

    for _, _currentList in pairs(_subsectionData) do
      _sprite = {}
      _sprite.sprite = _currentList[2]
      _sprite.northSprite = _currentList[1]

      _name = MoreBuild.getMoveableDisplayName(_sprite.sprite) or _currentList[3]

      _option = _currentSubMenu:addOption(_name, nil, MoreBuild.onBuildWallDecoration, _sprite, player, _name)

      _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
      _tooltip.description = _currentList[4] .. _tooltip.description
      _tooltip:setName(_name)
      _tooltip:setTexture(_sprite.sprite)
    end
  end
end

MoreBuild.getWallDecorationsData = function()
  local _wallDecorationsData = {
    [getText 'ContextMenu_Decorations_Restaurant'] = {
      {'location_restaurant_pie_01_14', 'location_restaurant_pie_01_15', getText 'ContextMenu_Today_Special', getText 'Tooltip_Today_Special'},
      {'location_restaurant_pie_01_56', 'location_restaurant_pie_01_63', getText 'ContextMenu_PurplePie_Sign', getText 'Tooltip_PurplePie_Sign'},
      {'location_restaurant_pie_01_57', 'location_restaurant_pie_01_62', getText 'ContextMenu_BluePie_Sign', getText 'Tooltip_PurplePie_Sign'},
      {'location_restaurant_pie_01_58', 'location_restaurant_pie_01_61', getText 'ContextMenu_GreenPie_Sign', getText 'Tooltip_PurplePie_Sign'},
      {'location_restaurant_pie_01_59', 'location_restaurant_pie_01_60', getText 'ContextMenu_PinkPie_Sign', getText 'Tooltip_PurplePie_Sign'},
      {'location_shop_accessories_01_27', 'location_shop_accessories_01_26', getText 'ContextMenu_Juice_Sign', getText 'Tooltip_Juice_Sign'}
    },
    [getText 'ContextMenu_Decorations_Medical'] = {
      {'location_community_medical_01_11', 'location_community_medical_01_12', getText 'ContextMenu_Heart_Diagram', getText 'Tooltip_Heart_Diagram'},
      {'location_community_medical_01_14', 'location_community_medical_01_13', getText 'ContextMenu_Diploma1', getText 'Tooltip_Diploma1'},
      {'location_community_medical_01_31', 'location_community_medical_01_30', getText 'ContextMenu_Diploma2', getText 'Tooltip_Diploma1'},
      {'location_community_medical_01_29', 'location_community_medical_01_28', getText 'ContextMenu_EyeChart', getText 'Tooltip_EyeChart'}
    },
    [getText 'ContextMenu_Decorations_Movie'] = {
      {'location_entertainment_theatre_01_83', 'location_entertainment_theatre_01_80', getText 'ContextMenu_Horror_Movie', getText 'Tooltip_Horror_Movie'},
      {'location_entertainment_theatre_01_84', 'location_entertainment_theatre_01_81', getText 'ContextMenu_Romance_Movie', getText 'Tooltip_Romance_Movie'},
      {'location_entertainment_theatre_01_85', 'location_entertainment_theatre_01_82', getText 'ContextMenu_Action_Movie', getText 'Tooltip_Action_Movie'}
    },
    [getText 'ContextMenu_Decorations_Papers'] = {
      {'papernotices_01_3', 'papernotices_01_0', getText 'ContextMenu_Wanted_Posters', getText 'Tooltip_Wanted_Posters'},
      {'papernotices_01_2', 'papernotices_01_1', getText 'ContextMenu_Police_Notice', getText 'Tooltip_Police_Notice'},
      {'papernotices_01_7', 'papernotices_01_4', getText 'ContextMenu_Colorful_Papers', getText 'Tooltip_Colorful_Papers1'},
      {'papernotices_01_6', 'papernotices_01_5', getText 'ContextMenu_Colorful_Papers', getText 'Tooltip_Colorful_Papers2'},
      {'papernotices_01_9', 'papernotices_01_8', getText 'ContextMenu_Colorful_Papers', getText 'Tooltip_Colorful_Papers3'}
    },
    [getText 'ContextMenu_Decorations_Paintings'] = {
      {'walls_decoration_01_33', 'walls_decoration_01_32', getText 'ContextMenu_PacMan', getText 'Tooltip_PacMan'},
      {'walls_decoration_01_35', 'walls_decoration_01_34', getText 'ContextMenu_Landscape', getText 'Tooltip_Landscape'},
      {'walls_decoration_01_46', 'walls_decoration_01_47', getText 'ContextMenu_Elegant_Lady', getText 'Tooltip_Elegant_Lady'},
      {'walls_decoration_01_48', 'walls_decoration_01_49', getText 'ContextMenu_Womans_Portrait', getText 'Tooltip_Womans_Portrait'},
      {'walls_decoration_01_50', 'walls_decoration_01_51', getText 'ContextMenu_NoClue', getText 'Tooltip_NoClue'},
      {'walls_decoration_01_57', 'walls_decoration_01_56', getText 'ContextMenu_Possible_Shop', getText 'Tooltip_Possible_Shop'}
    },
    [getText 'ContextMenu_Decorations_Other'] = {
      {'walls_decoration_01_16', 'walls_decoration_01_17', getText 'ContextMenu_American_Flag', getText 'Tooltip_American_Flag'},
      {'walls_decoration_01_18', 'walls_decoration_01_19', getText 'ContextMenu_State_Flag', getText 'Tooltip_State_Flag'},
      {'location_shop_accessories_01_25', 'location_shop_accessories_01_24', getText 'ContextMenu_ForLease_Sign', getText 'Tooltip_ForLease_Sign'},
      {'location_community_school_01_32', 'location_community_school_01_33', getText 'ContextMenu_Wall_Clock', getText 'Tooltip_Wall_Clock'},
      {'fixtures_bathroom_01_20', 'fixtures_bathroom_01_18', getText 'ContextMenu_MenRoom_Sign', getText 'Tooltip_MenRoom_Sign'},
      {'fixtures_bathroom_01_21', 'fixtures_bathroom_01_19', getText 'ContextMenu_LadyRoom_Sign', getText 'Tooltip_LadyRoom_Sign'}
    }
  }

  return _wallDecorationsData
end