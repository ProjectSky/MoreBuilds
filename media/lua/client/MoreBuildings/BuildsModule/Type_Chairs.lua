if not getMoreBuildInstance then
  require('MoreBuildings/MoreBuilds_Main')
end

local MoreBuild = getMoreBuildInstance()

MoreBuild.chairsMenuBuilder = function(subMenu, player, context)
  local _sprite
  local _option
  local _tooltip
  local _name = ''

  MoreBuild.neededMaterials = {
    {
      Material = 'Base.Plank',
      Amount = 5
    },
    {
      Material = 'Base.Nails',
      Amount = 4
    }
  }

  MoreBuild.neededTools = {'Hammer'}

  local needSkills = {
    Woodwork = MoreBuild.skillLevel.simpleFurniture
  }

  local _chairsData = MoreBuild.getSeatingData()
  local _currentOption
  local _currentSubMenu

  for _subsectionName, _subsectionData in pairs(_chairsData) do
    _currentOption = subMenu:addOption(_subsectionName)
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
      _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
      _tooltip.description = _currentList[6] .. _tooltip.description
      _tooltip:setName(_name)
      _tooltip:setTexture(_sprite.sprite)
    end
  end
end

MoreBuild.getSeatingData = function()
  local _seatingData = {
    [getText 'ContextMenu_Benches'] = {
      {'location_shop_mall_01_35', 'location_shop_mall_01_32', 'location_shop_mall_01_35', 'location_shop_mall_01_32', getText 'ContextMenu_Mall_Bench', getText 'Tooltip_Mall_Bench'},
      {'location_trailer_02_9', 'location_trailer_02_8', 'location_trailer_02_9', 'location_trailer_02_8', getText 'ContextMenu_Trailer_Bench', getText 'Tooltip_Trailer_Bench'},
      {'furniture_seating_indoor_02_16', 'furniture_seating_indoor_02_19', 'furniture_seating_indoor_02_16', 'furniture_seating_indoor_02_19', getText 'ContextMenu_Padded_Bench', getText 'Tooltip_Padded_Bench'}
    },
    [getText 'ContextMenu_Wooden_Chairs'] = {
      {'furniture_seating_indoor_02_4', 'furniture_seating_indoor_02_5', 'furniture_seating_indoor_02_6', 'furniture_seating_indoor_02_7', getText 'ContextMenu_BeigeWooden_Chair', getText 'Tooltip_BeigeWooden_Chair'},
      {'location_restaurant_pileocrepe_01_40', 'location_restaurant_pileocrepe_01_41', 'location_restaurant_pileocrepe_01_42', 'location_restaurant_pileocrepe_01_43', getText 'ContextMenu_BrownWooden_Chair', getText 'Tooltip_BeigeWooden_Chair'},
      {'furniture_seating_indoor_02_1', 'furniture_seating_indoor_02_0', 'furniture_seating_indoor_02_3', 'furniture_seating_indoor_02_2', getText 'ContextMenu_DarkBrown_WoodenChair', getText 'Tooltip_BeigeWooden_Chair'},
      {'furniture_seating_indoor_02_8', 'furniture_seating_indoor_02_9', 'furniture_seating_indoor_02_10', 'furniture_seating_indoor_02_11', getText 'ContextMenu_RedWooden_Chair', getText 'Tooltip_BeigeWooden_Chair'},
      {'furniture_seating_indoor_02_57', 'furniture_seating_indoor_02_56', 'furniture_seating_indoor_02_59', 'furniture_seating_indoor_02_58', getText 'ContextMenu_WhiteWooden_Chair', getText 'Tooltip_BeigeWooden_Chair'},
      {'furniture_seating_indoor_03_56', 'furniture_seating_indoor_03_57', 'furniture_seating_indoor_03_58', 'furniture_seating_indoor_03_59', getText 'ContextMenu_YellowWooden_Chair', getText 'Tooltip_BeigeWooden_Chair'},
      {'furniture_seating_indoor_03_44', 'furniture_seating_indoor_03_45', 'furniture_seating_indoor_03_46', 'furniture_seating_indoor_03_47', getText 'ContextMenu_BlackPadded_Chair', getText 'Tooltip_BlackPadded_Chair'},
      {'furniture_seating_indoor_01_56', 'furniture_seating_indoor_01_57', 'furniture_seating_indoor_01_58', 'furniture_seating_indoor_01_59', getText 'ContextMenu_GreenPadded_Chair', getText 'Tooltip_BlackPadded_Chair'}
    },
    [getText 'ContextMenu_Simple_Chairs'] = {
      {'furniture_seating_indoor_01_61', 'furniture_seating_indoor_01_60', 'furniture_seating_indoor_01_63', 'furniture_seating_indoor_01_62', getText 'ContextMenu_BlackFolding_Chair', getText 'Tooltip_BlackFolding_Chair'},
      {'furniture_seating_indoor_01_49', 'furniture_seating_indoor_01_50', 'furniture_seating_indoor_01_48', 'furniture_seating_indoor_01_51', getText 'ContextMenu_BlackOffice_Chair', getText 'Tooltip_BlackOffice_Chair'},
      {'furniture_seating_indoor_02_12', 'furniture_seating_indoor_02_13', 'furniture_seating_indoor_02_14', 'furniture_seating_indoor_02_15', getText 'ContextMenu_BlueSchool_Chair', getText 'Tooltip_BlueSchool_Chair'},
      {'furniture_seating_indoor_01_53', 'furniture_seating_indoor_01_54', 'furniture_seating_indoor_01_52', 'furniture_seating_indoor_01_55', getText 'ContextMenu_GrayMetal_Chair', getText 'Tooltip_GrayMetal_Chair'}
    },
    [getText 'ContextMenu_Padded_Chairs'] = {
      {'furniture_seating_indoor_01_40', 'furniture_seating_indoor_01_41', 'furniture_seating_indoor_01_42', 'furniture_seating_indoor_01_43', getText 'ContextMenu_RedPadded_Chair', getText 'Tooltip_RedPadded_Chair'},
      {'furniture_seating_indoor_01_36', 'furniture_seating_indoor_01_37', 'furniture_seating_indoor_01_38', 'furniture_seating_indoor_01_39', getText 'ContextMenu_Beige_Armchair', getText 'Tooltip_Beige_Armchair'},
      {'furniture_seating_indoor_03_48', 'furniture_seating_indoor_03_49', 'furniture_seating_indoor_03_50', 'furniture_seating_indoor_03_51', getText 'ContextMenu_BluePadded_Chair', getText 'Tooltip_RedPadded_Chair'},
      {'furniture_seating_indoor_03_40', 'furniture_seating_indoor_03_41', 'furniture_seating_indoor_03_42', 'furniture_seating_indoor_03_43', getText 'ContextMenu_BlackLeather_Armchair', getText 'Tooltip_RedPadded_Chair'}
    },
    [getText 'ContextMenu_Upholstered_Chairs'] = {
      {'furniture_seating_indoor_03_24', 'furniture_seating_indoor_03_25', 'furniture_seating_indoor_03_26', 'furniture_seating_indoor_03_27', getText 'ContextMenu_Blue_Armchair', getText 'Tooltip_Beige_Armchair'},
      {'furniture_seating_indoor_03_5', 'furniture_seating_indoor_03_4', 'furniture_seating_indoor_03_6', 'furniture_seating_indoor_03_7', getText 'ContextMenu_PowderBlue_Armchair', getText 'Tooltip_Beige_Armchair'},
      {'furniture_seating_indoor_02_45', 'furniture_seating_indoor_02_44', 'furniture_seating_indoor_02_46', 'furniture_seating_indoor_02_47', getText 'ContextMenu_Brown_Armchair', getText 'Tooltip_Beige_Armchair'},
      {'furniture_seating_indoor_02_40', 'furniture_seating_indoor_02_41', 'furniture_seating_indoor_02_42', 'furniture_seating_indoor_02_43', getText 'ContextMenu_Gray_Armchair', getText 'Tooltip_Beige_Armchair'},
      {'furniture_seating_indoor_01_8', 'furniture_seating_indoor_01_9', 'furniture_seating_indoor_01_10', 'furniture_seating_indoor_01_11', getText 'ContextMenu_OliveGreen_Armchair', getText 'Tooltip_Beige_Armchair'},
      {'furniture_seating_indoor_03_29', 'furniture_seating_indoor_03_28', 'furniture_seating_indoor_03_30', 'furniture_seating_indoor_03_31', getText 'ContextMenu_Green_Armchair', getText 'Tooltip_Beige_Armchair'},
      {'furniture_seating_indoor_01_13', 'furniture_seating_indoor_01_12', 'furniture_seating_indoor_01_14', 'furniture_seating_indoor_01_15', getText 'ContextMenu_Orange_Armchair', getText 'Tooltip_Beige_Armchair'},
      {'furniture_seating_indoor_01_46', 'furniture_seating_indoor_01_47', 'furniture_seating_indoor_01_46', 'furniture_seating_indoor_01_47', getText 'ContextMenu_Orange_Footstool', getText 'Tooltip_Orange_Footstool'},
      {'furniture_seating_indoor_01_32', 'furniture_seating_indoor_01_33', 'furniture_seating_indoor_01_34', 'furniture_seating_indoor_01_35', getText 'ContextMenu_Purple_Armchair', getText 'Tooltip_Beige_Armchair'},
      {'furniture_seating_indoor_02_21', 'furniture_seating_indoor_02_20', 'furniture_seating_indoor_02_22', 'furniture_seating_indoor_02_23', getText 'ContextMenu_Yellow_Armchair', getText 'Tooltip_Beige_Armchair'}
    },
    [getText 'ContextMenu_Stools'] = {
      {'location_restaurant_diner_01_42', 'location_restaurant_diner_01_42', 'location_restaurant_diner_01_42', 'location_restaurant_diner_01_42', getText 'ContextMenu_Diner_Stool', getText 'Tooltip_Diner_Stool'},
      {'location_community_medical_01_10', 'location_community_medical_01_10', 'location_community_medical_01_10', 'location_community_medical_01_10', getText 'ContextMenu_Black_Stool', getText 'Tooltip_Black_Stool'},
      {'location_restaurant_bar_01_25', 'location_restaurant_bar_01_25', 'location_restaurant_bar_01_25', 'location_restaurant_bar_01_25', getText 'ContextMenu_BlackBar_Stool', getText 'Tooltip_BlackBar_Stool'},
      {'location_restaurant_bar_01_26', 'location_restaurant_bar_01_26', 'location_restaurant_bar_01_26', 'location_restaurant_bar_01_26', getText 'ContextMenu_BrownBar_Stool', getText 'Tooltip_BlackBar_Stool'},
      {'location_restaurant_spiffos_02_25', 'location_restaurant_spiffos_02_24', 'location_restaurant_spiffos_02_27', 'location_restaurant_spiffos_02_26', getText 'ContextMenu_Spiffos_Stool', getText 'Tooltip_Spiffos_Stool'},
      {'location_services_beauty_01_1', 'location_services_beauty_01_2', 'location_services_beauty_01_0', 'location_services_beauty_01_3', getText 'ContextMenu_BeautySalon_Stool', getText 'Tooltip_BeautySalon_Stool'},
      {'location_shop_mall_01_41', 'location_shop_mall_01_40', 'location_shop_mall_01_43', 'location_shop_mall_01_42', getText 'ContextMenu_Brown_Stool', getText 'Tooltip_Brown_Stool'}
    }
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

  _chair.modData['need:Base.Plank'] = 5
  _chair.modData['need:Base.Nails'] = 4
  _chair.modData['xp:Woodwork'] = 5

  getCell():setDrag(_chair, player)
end