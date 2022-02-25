if not getMoreBuildInstance then
  require('MoreBuildings/MoreBuilds_Main')
end

local MoreBuild = getMoreBuildInstance()

MoreBuild.floorsMenuBuilder = function(subMenu, player, context)
  local _sprite
  local _option
  local _tooltip
  local _name = ''

  MoreBuild.neededMaterials = {
    {
      Material = 'Base.Plank',
      Amount = 1
    },
    {
      Material = 'Base.Nails',
      Amount = 1
    }
  }

  MoreBuild.neededTools = {'Hammer'}

  local needSkills = {
    Woodwork = MoreBuild.skillLevel.floorObject
  }

  local _floorData = MoreBuild.getFloorsData()
  local _currentOption
  local _currentSubMenu

  for _subsectionName, _subsectionData in pairs(_floorData) do
    _currentOption = subMenu:addOption(_subsectionName)
    _currentSubMenu = subMenu:getNew(subMenu)
    context:addSubMenu(_currentOption, _currentSubMenu)

    for _, _currentList in pairs(_subsectionData) do
      _sprite = {}
      _sprite.sprite = _currentList[1]
      _sprite.northSprite = _currentList[2]

      _name = MoreBuild.getMoveableDisplayName(_sprite.sprite) or _currentList[3]

      _option = _currentSubMenu:addOption(_name, nil, MoreBuild.onBuildTwoSpriteFloor, _sprite, player, _name)

      _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
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

  _floor.modData['need:Base.Plank'] = 1
  _floor.modData['need:Base.Nails'] = 1
  _floor.modData['xp:Woodwork'] = 5

  getCell():setDrag(_floor, player)
end

MoreBuild.onBuildFourSpriteFloor = function(ignoreThisArgument, sprite, player, name)
  local _floor = ISWoodenFloor:new(sprite.sprite, sprite.northSprite)

  _floor.player = player
  _floor.name = name
  _floor.eastSprite = sprite.eastSprite
  _floor.southSprite = sprite.southSprite

  _floor.modData['need:Base.Plank'] = 1
  _floor.modData['need:Base.Nails'] = 1
  _floor.modData['xp:Woodwork'] = 5

  getCell():setDrag(_floor, player)
end

MoreBuild.getFloorsData = function()
  local _floorData = {
    [getText 'ContextMenu_Location_Carpets'] = {
      {'location_hospitality_sunstarmotel_01_57', 'location_hospitality_sunstarmotel_01_57', getText 'ContextMenu_UglyMotel_Carpet', false},
      {'location_hospitality_sunstarmotel_01_56', 'location_hospitality_sunstarmotel_01_56', getText 'ContextMenu_WhiteMotel_Carpet', false},
      {'location_restaurant_pileocrepe_01_14', 'location_restaurant_pileocrepe_01_14', getText 'ContextMenu_BeigeRestaurant_Carpet', false},
      {'location_shop_fossoil_01_39', 'location_shop_fossoil_01_39', getText('ContextMenu_Blue_GasStation_Carpet'), false},
      {'location_shop_fossoil_01_38', 'location_shop_fossoil_01_38', getText 'ContextMenu_White_GasStation_Carpet', false},
      {'location_shop_zippee_01_6', 'location_shop_zippee_01_6', getText('ContextMenu_Blue_Zippee_Carpet'), false},
      {'location_shop_zippee_01_7', 'location_shop_zippee_01_7', getText 'ContextMenu_Orange_Zippee_Carpet', false}
    },
    [getText 'ContextMenu_General_Carpets1'] = {
      {'location_shop_greenes_01_32', 'location_shop_greenes_01_33', getText 'ContextMenu_Black_Carpet', true},
      {'floors_interior_carpet_01_7', 'floors_interior_carpet_01_7', getText 'ContextMenu_Charcoal_Carpet', false},
      {'floors_interior_carpet_01_13', 'floors_interior_carpet_01_13', getText 'ContextMenu_DarkGray_Carpet', false},
      {'floors_interior_carpet_01_2', 'floors_interior_carpet_01_2', getText 'ContextMenu_Gray_Carpet', false},
      {'floors_interior_carpet_01_14', 'floors_interior_carpet_01_14', getText 'ContextMenu_LightGray_Carpet', false},
      {'floors_interior_carpet_01_11', 'floors_interior_carpet_01_11', getText 'ContextMenu_White_Carpet', false},
      {'floors_interior_carpet_01_9', 'floors_interior_carpet_01_9', getText 'ContextMenu_Red_Carpet', false},
      {'floors_interior_carpet_01_8', 'floors_interior_carpet_01_8', getText 'ContextMenu_Maroon_Carpet', false},
      {'floors_interior_carpet_01_3', 'floors_interior_carpet_01_3', getText 'ContextMenu_Rust_Carpet', false},
      {'floors_interior_carpet_01_10', 'floors_interior_carpet_01_10', getText 'ContextMenu_Yellow_Carpet', false}
    },
    [getText 'ContextMenu_General_Carpets2'] = {
      {'floors_interior_carpet_01_5', 'floors_interior_carpet_01_5', getText 'ContextMenu_Teal_Carpet', false},
      {'floors_interior_carpet_01_0', 'floors_interior_carpet_01_0', getText 'ContextMenu_Blue_Carpet', false},
      {'floors_interior_carpet_01_1', 'floors_interior_carpet_01_1', getText 'ContextMenu_Purple_Carpet', false},
      {'floors_interior_carpet_01_6', 'floors_interior_carpet_01_6', getText 'ContextMenu_Violet_Carpet', false},
      {'floors_interior_carpet_01_4', 'floors_interior_carpet_01_4', getText 'ContextMenu_Lavender_Carpet', false},
      {'floors_interior_tilesandwood_01_45', 'floors_interior_tilesandwood_01_45', getText 'ContextMenu_BrownShag_Carpet', false},
      {'floors_interior_carpet_01_12', 'floors_interior_carpet_01_12', getText 'ContextMenu_Tan_Carpet', false}
    },
    [getText 'ContextMenu_MetalFloor'] = {
      {'industry_01_37', 'industry_01_38', getText 'ContextMenu_RustyMesh_Floor', true},
      {'industry_01_39', 'industry_01_39', getText 'ContextMenu_RustyMesh_Grate', false},
      {'industry_railroad_05_22', 'industry_railroad_05_23', getText 'ContextMenu_BrownRailroad_MetalPanel', true},
      {'industry_railroad_05_38', 'industry_railroad_05_39', getText 'ContextMenu_GrayRailroad_MetalPanel', true},
      {'location_sewer_01_40', 'location_sewer_01_41', getText 'ContextMenu_SewerGrating_Edged', true},
      {'location_sewer_01_42', 'location_sewer_01_42', getText 'ContextMenu_SewerGrating_Mesh', false}
    },
    [getText 'ContextMenu_StoneFloor'] = {
      {'floors_exterior_street_01_14', 'floors_exterior_street_01_14', getText 'ContextMenu_Concrete_Floor', false},
      {'floors_exterior_street_01_17', 'floors_exterior_street_01_17', getText 'ContextMenu_LightAsphalt_Floor', false},
      {'floors_exterior_street_01_16', 'floors_exterior_street_01_16', getText 'ContextMenu_DarkAsphalt_Floor', false}
    },
    [getText 'ContextMenu_Roofing_Styles'] = {
      {'roofs_01_22', 'roofs_01_23', getText 'ContextMenu_BlackShingle_Roofing', true},
      {'roofs_01_54', 'roofs_01_55', getText 'ContextMenu_BrownWood_Roofing', true},
      {'roofs_03_22', 'roofs_03_23', getText 'ContextMenu_LightBrown_WoodRoofing', true},
      {'roofs_03_54', 'roofs_03_55', getText 'ContextMenu_GreenWood_Roofing', true},
      {'roofs_04_22', 'roofs_04_23', getText 'ContextMenu_RedWood_Roofing', true},
      {'roofs_04_54', 'roofs_04_55', getText 'ContextMenu_White_Roofing', true},
      {'roofs_burnt_01_22', 'roofs_burnt_01_23', getText 'ContextMenu_Burnt_Roofing', true}
    },
    [getText 'ContextMenu_Location_Tiles'] = {
      {'location_hospitality_sunstarmotel_02_16', 'location_hospitality_sunstarmotel_02_16', getText 'ContextMenu_YellowMotel_Tile', false},
      {'location_restaurant_diner_01_40', 'location_restaurant_diner_01_40', getText 'ContextMenu_DinerCheckerboard_Tile', false},
      {'location_restaurant_diner_01_41', 'location_restaurant_diner_01_41', getText 'ContextMenu_DinerTurquoise_Tile', false},
      {'location_restaurant_pie_01_7', 'location_restaurant_pie_01_7', getText 'ContextMenu_RestaurantPink_Tile', false},
      {'location_restaurant_pizzawhirled_01_16', 'location_restaurant_pizzawhirled_01_16', getText 'ContextMenu_PizzaWhilredRed_Tile', false},
      {'location_restaurant_spiffos_01_38', 'location_restaurant_spiffos_01_38', getText 'ContextMenu_SpiffosGreen_Tile', false},
      {'location_shop_mall_01_20', 'location_shop_mall_01_21', getText 'ContextMenu_MallTile_Path', true},
      {'location_shop_mall_01_22', 'location_shop_mall_01_22', getText 'ContextMenu_MallGray_TileFloor', false},
      {'location_shop_mall_01_23', 'location_shop_mall_01_23', getText 'ContextMenu_MallWhite_TileFloor', false}
    },
    [getText 'ContextMenu_Interior_Tiles1'] = {
      {'location_restaurant_bar_01_24', 'location_restaurant_bar_01_24', getText 'ContextMenu_Gray_Tile', false},
      {'floors_interior_tilesandwood_01_0', 'floors_interior_tilesandwood_01_0', getText 'ContextMenu_GrayCheckerboard_Tile', false},
      {'floors_interior_tilesandwood_01_1', 'floors_interior_tilesandwood_01_1', getText 'ContextMenu_PurpleCheckerboard_Floor', false},
      {'floors_interior_tilesandwood_01_2', 'floors_interior_tilesandwood_01_2', getText 'ContextMenu_LightBlueCheckerboard_Tile', false},
      {'floors_interior_tilesandwood_01_3', 'floors_interior_tilesandwood_01_3', getText 'ContextMenu_OrangeCheckerboard_Tile', false},
      {'floors_interior_tilesandwood_01_4', 'floors_interior_tilesandwood_01_4', getText 'ContextMenu_GrayCheckerboard_Tile', false},
      {'floors_interior_tilesandwood_01_5', 'floors_interior_tilesandwood_01_5', getText 'ContextMenu_WhiteSquare_Tile', false},
      {'floors_interior_tilesandwood_01_6', 'floors_interior_tilesandwood_01_6', getText 'ContextMenu_OrangeandYellow_Tile', false},
      {'floors_interior_tilesandwood_01_7', 'floors_interior_tilesandwood_01_7', getText 'ContextMenu_BlackandWhite_Tile', false},
      {'floors_interior_tilesandwood_01_8', 'floors_interior_tilesandwood_01_8', getText 'ContextMenu_SpiffosGreen_Tile', false}
    },
    [getText 'ContextMenu_Interior_Tiles2'] = {
      {'floors_interior_tilesandwood_01_9', 'floors_interior_tilesandwood_01_9', getText 'ContextMenu_SunburstYellow_Tile', false},
      {'floors_interior_tilesandwood_01_10', 'floors_interior_tilesandwood_01_10', getText 'ContextMenu_Beige_Tile', false},
      {'floors_interior_tilesandwood_01_11', 'floors_interior_tilesandwood_01_11', getText 'ContextMenu_WhiteSquare_Tile', false},
      {'floors_interior_tilesandwood_01_12', 'floors_interior_tilesandwood_01_12', getText 'ContextMenu_WhiteDiamond_Tile', false},
      {'floors_interior_tilesandwood_01_13', 'floors_interior_tilesandwood_01_13', getText 'ContextMenu_BrownSquare_Tile', false},
      {'floors_interior_tilesandwood_01_14', 'floors_interior_tilesandwood_01_14', getText 'ContextMenu_GrayDiamond_Tile', false},
      {'floors_interior_tilesandwood_01_16', 'floors_interior_tilesandwood_01_17', getText 'ContextMenu_White_Tile', true},
      {'floors_interior_tilesandwood_01_18', 'floors_interior_tilesandwood_01_18', getText 'ContextMenu_FlatGray_Tile', false},
      {'floors_interior_tilesandwood_01_19', 'floors_interior_tilesandwood_01_19', getText 'ContextMenu_LightYellow_Tile', false},
      {'floors_interior_tilesandwood_01_20', 'floors_interior_tilesandwood_01_20', getText 'ContextMenu_GraySquare_Tile', false}
    },
    [getText 'ContextMenu_Interior_Tiles3'] = {
      {'floors_interior_tilesandwood_01_21', 'floors_interior_tilesandwood_01_21', getText 'ContextMenu_GreenSquare_Tile', false},
      {'floors_interior_tilesandwood_01_22', 'floors_interior_tilesandwood_01_22', getText 'ContextMenu_PurpleSquare_Tile', false},
      {'floors_interior_tilesandwood_01_23', 'floors_interior_tilesandwood_01_23', getText 'ContextMenu_OffWhiteSquare_Tile', false},
      {'floors_interior_tilesandwood_01_30', 'floors_interior_tilesandwood_01_30', getText 'ContextMenu_DarkGraySquare_Tile', false},
      {'floors_interior_tilesandwood_01_31', 'floors_interior_tilesandwood_01_31', getText 'ContextMenu_OrangeSquare_Tile', false}
    },
    [getText 'ContextMenu_Exterior_Tiles'] = {
      {'floors_exterior_tilesandstone_01_7', 'floors_exterior_tilesandstone_01_7', getText 'ContextMenu_LightGray_Stone', false},
      {'floors_exterior_tilesandstone_01_3', 'floors_exterior_tilesandstone_01_3', getText 'ContextMenu_Gray_Stone', false},
      {'floors_exterior_tilesandstone_01_2', 'floors_exterior_tilesandstone_01_2', getText 'ContextMenu_Red_Stone', false},
      {'floors_exterior_tilesandstone_01_4', 'floors_exterior_tilesandstone_01_4', getText 'ContextMenu_White_Stone', false},
      {'floors_exterior_tilesandstone_01_5', 'floors_exterior_tilesandstone_01_5', getText 'ContextMenu_MixedGray_Tiles', false},
      {'floors_exterior_tilesandstone_01_6', 'floors_exterior_tilesandstone_01_6', getText 'ContextMenu_MixedRed_TIles', false},
      {'floors_exterior_tilesandstone_01_1', 'floors_exterior_tilesandstone_01_1', getText 'ContextMenu_MixedYellow_Tiles', false},
      {'floors_exterior_tilesandstone_01_0', 'floors_exterior_tilesandstone_01_0', getText 'ContextMenu_Yellow_Tiles', false}
    },
    [getText 'ContextMenu_Wooden_Flooring'] = {
      {'construction_01_22', 'construction_01_31', getText 'ContextMenu_Plywood_Panel', true},
      {'industry_railroad_05_44', 'industry_railroad_05_47', getText 'ContextMenu_WidePlank_Floor', true},
      {'floors_interior_tilesandwood_01_40', 'floors_interior_tilesandwood_01_40', getText 'ContextMenu_AnotherWood_Floor', false},
      {'floors_interior_tilesandwood_01_41', 'floors_interior_tilesandwood_01_41', getText 'ContextMenu_MoreWood_Flooring', false},
      {'location_shop_greenes_01_34', 'location_shop_greenes_01_34', getText 'ContextMenu_RedWoodShop_Floor', false},
      {'floors_interior_tilesandwood_01_42', 'floors_interior_tilesandwood_01_42', getText 'ContextMenu_YellowWood_Floor', false},
      {'floors_interior_tilesandwood_01_43', 'floors_interior_tilesandwood_01_44', getText 'ContextMenu_TanWood_Floor', true},
      {'floors_interior_tilesandwood_01_46', 'floors_interior_tilesandwood_01_46', getText 'ContextMenu_DarkBrownWood_Floor', false}
    },
    [getText 'ContextMenu_Other_Menu'] = {
      {'floors_interior_tilesandwood_01_48', 'floors_interior_tilesandwood_01_48', getText 'ContextMenu_RedSquare_Flooring'},
      {'floors_interior_tilesandwood_01_49', 'floors_interior_tilesandwood_01_49', getText 'ContextMenu_YellowSquare_Flooring', false},
      {'floors_interior_tilesandwood_01_50', 'floors_interior_tilesandwood_01_50', getText 'ContextMenu_OrangeSquare_Flooring', false},
      {'recreational_sports_01_34', 'recreational_sports_01_34', getText 'ContextMenu_RubberFloor_Padding', false},
      {'floors_burnt_01_0', 'floors_burnt_01_0', getText 'ContextMenu_Burnt_Floor', false},
      {'roofs_02_54', 'roofs_02_55', getText 'ContextMenu_Glass_Floor', false}
    },
    [getText 'ContextMenu_Industrial_Flooring'] = {
      {'industry_01_7', 'industry_01_7', getText 'ContextMenu_GrayIndustrial_Flooring', false},
      {'industry_01_6', 'industry_01_6', getText 'ContextMenu_GreenIndustrial_Flooring', false},
      {'industry_trucks_01_47', 'industry_trucks_01_47', getText 'ContextMenu_TruckstopBlue_Floor', false},
      {'industry_trucks_01_39', 'industry_trucks_01_39', getText 'ContextMenu_TruckstopGray_Floor', false},
      {'industry_trucks_01_38', 'industry_trucks_01_38', getText 'ContextMenu_TruckstopGreen_Floor', false},
      {'industry_trucks_01_46', 'industry_trucks_01_46', getText 'ContextMenu_TruckstopYellow_Floor', false},
      {'location_shop_generic_01_4', 'location_shop_generic_01_4', getText 'ContextMenu_GenericWhiteShop_Floor', false},
      {'location_trailer_02_28', 'location_trailer_02_28', getText 'ContextMenu_BlueTrailer_Flooring', false},
      {'location_trailer_01_44', 'location_trailer_01_44', getText 'ContextMenu_TanTrailer_Flooring', false}
    }
  }

  return _floorData
end