if not getMoreBuildInstance then
  require('MoreBuildings/MoreBuilds_Main')
end

local MoreBuild = getMoreBuildInstance()

MoreBuild.counterElementsMenuBuilder = function(subMenu, player, context)
  local _sprite
  local _option
  local _tooltip
  local _name = ''

  MoreBuild.neededMaterials = {
    {
      Material = 'Base.Plank',
      Amount = 4
    },
    {
      Material = 'Base.Nails',
      Amount = 4
    }
  }

  MoreBuild.neededTools = {'Hammer'}
  
  local needSkills = {
    Woodwork = MoreBuild.skillLevel.advancedContainer
  }

  local _counterData = MoreBuild.getBarElementData()
  local _currentOption
  local _currentSubMenu

  for _subsectionName, _subsectionData in pairs(_counterData) do
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

      _option = _currentSubMenu:addOption(_name, nil, MoreBuild.onBuildBarElement, _sprite, player, _name)

      _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
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

  _barElement.modData['need:Base.Plank'] = 4
  _barElement.modData['need:Base.Nails'] = 4
  _barElement.modData['xp:Woodwork'] = 5

  function _barElement:getHealth()
    self.javaObject:getContainer():setType('counter')
    return MoreBuild.healthLevel.woodContainer + buildUtil.getWoodHealth(self)
  end

  getCell():setDrag(_barElement, player)
end

MoreBuild.getBarElementData = function()
  local _barElementData = {
    [getText 'ContextMenu_Cabinets_Menu'] = {
      {'fixtures_counters_01_3', 'fixtures_counters_01_5', 'fixtures_counters_01_7', 'fixtures_counters_01_1', getText 'ContextMenu_RedYellow_Cabinet', MoreBuild.textBarElementDescription},
      {'fixtures_counters_01_2', 'fixtures_counters_01_4', 'fixtures_counters_01_6', 'fixtures_counters_01_0', getText 'ContextMenu_RedYellow_Corner', MoreBuild.textBarCornerDescription},
      {'fixtures_counters_01_43', 'fixtures_counters_01_45', 'fixtures_counters_01_47', 'fixtures_counters_01_41', getText 'ContextMenu_Yellow_Cabinet', MoreBuild.textBarElementDescription},
      {'fixtures_counters_01_42', 'fixtures_counters_01_44', 'fixtures_counters_01_46', 'fixtures_counters_01_40', getText 'ContextMenu_Yellow_Corner', MoreBuild.textBarCornerDescription},
      {'fixtures_counters_01_51', 'fixtures_counters_01_53', 'fixtures_counters_01_55', 'fixtures_counters_01_49', getText 'ContextMenu_Orange_Cabinet', MoreBuild.textBarElementDescription},
      {'fixtures_counters_01_50', 'fixtures_counters_01_52', 'fixtures_counters_01_54', 'fixtures_counters_01_48', getText 'ContextMenu_Orange_Corner', MoreBuild.textBarCornerDescription},
      {'fixtures_counters_01_59', 'fixtures_counters_01_61', 'fixtures_counters_01_63', 'fixtures_counters_01_57', getText 'ContextMenu_BrownGray_Cabinet', MoreBuild.textBarElementDescription},
      {'fixtures_counters_01_58', 'fixtures_counters_01_60', 'fixtures_counters_01_62', 'fixtures_counters_01_56', getText 'ContextMenu_BrownGray_Corner', MoreBuild.textBarCornerDescription},
      {'fixtures_counters_01_67', 'fixtures_counters_01_69', 'fixtures_counters_01_71', 'fixtures_counters_01_65', getText 'ContextMenu_Green_Cabinet', MoreBuild.textBarElementDescription},
      {'fixtures_counters_01_66', 'fixtures_counters_01_68', 'fixtures_counters_01_70', 'fixtures_counters_01_64', getText 'ContextMenu_Green_Corner', MoreBuild.textBarCornerDescription}
    },
    [getText 'ContextMenu_More_Cabinets'] = {
      {'fixtures_counters_01_75', 'fixtures_counters_01_77', 'fixtures_counters_01_79', 'fixtures_counters_01_73', getText 'ContextMenu_GrayWhite_Cabinet', MoreBuild.textBarElementDescription},
      {'fixtures_counters_01_74', 'fixtures_counters_01_76', 'fixtures_counters_01_78', 'fixtures_counters_01_72', getText 'ContextMenu_GrayWhite_Corner', MoreBuild.textBarCornerDescription},
      {'location_trailer_02_19', 'location_trailer_02_18', 'location_trailer_02_21', 'location_trailer_02_20', getText 'ContextMenu_TrailerPark_Cabinet', MoreBuild.textBarElementDescription},
      {'location_hospitality_sunstarmotel_02_13', 'location_hospitality_sunstarmotel_02_14', 'location_hospitality_sunstarmotel_02_15', 'location_hospitality_sunstarmotel_02_12', getText 'ContextMenu_Motel_Cabinet', MoreBuild.textBarElementDescription},
      {'fixtures_counters_01_11', 'fixtures_counters_01_13', 'fixtures_counters_01_15', 'fixtures_counters_01_9', getText 'ContextMenu_Brown_Counter', MoreBuild.textBarElementDescription},
      {'fixtures_counters_01_10', 'fixtures_counters_01_12', 'fixtures_counters_01_14', 'fixtures_counters_01_8', getText 'ContextMenu_Brown_Corner', MoreBuild.textBarCornerDescription},
      {'fixtures_counters_01_35', 'fixtures_counters_01_37', 'fixtures_counters_01_39', 'fixtures_counters_01_33', getText 'ContextMenu_Gray_Counter', MoreBuild.textBarElementDescription},
      {'fixtures_counters_01_34', 'fixtures_counters_01_36', 'fixtures_counters_01_38', 'fixtures_counters_01_32', getText 'ContextMenu_Gray_Corner', MoreBuild.textBarCornerDescription}
    },
    [getText 'ContextMenu_Business_Counters1'] = {
      {'location_restaurant_bar_01_6', 'location_restaurant_bar_01_4', 'location_restaurant_bar_01_2', 'location_restaurant_bar_01_0', getText 'ContextMenu_Bar_Counter', MoreBuild.textBarElementDescription},
      {'location_restaurant_bar_01_7', 'location_restaurant_bar_01_5', 'location_restaurant_bar_01_3', 'location_restaurant_bar_01_1', getText 'ContextMenu_Bar_Corner', MoreBuild.textBarCornerDescription},
      {'location_restaurant_pie_01_43', 'location_restaurant_pie_01_45', 'location_restaurant_pie_01_47', 'location_restaurant_pie_01_41', getText 'ContextMenu_Restaurant_Counter', MoreBuild.textBarElementDescription},
      {'location_restaurant_pie_01_42', 'location_restaurant_pie_01_44', 'location_restaurant_pie_01_46', 'location_restaurant_pie_01_40', getText 'ContextMenu_Restaurant_Corner', MoreBuild.textBarCornerDescription},
      {'location_entertainment_theatre_01_11', 'location_entertainment_theatre_01_13', 'location_entertainment_theatre_01_15', 'location_entertainment_theatre_01_9', getText 'ContextMenu_Theatre_Counter', MoreBuild.textBarElementDescription},
      {'location_entertainment_theatre_01_10', 'location_entertainment_theatre_01_12', 'location_entertainment_theatre_01_14', 'location_entertainment_theatre_01_8', getText 'ContextMenu_Theatre_Corner', MoreBuild.textBarCornerDescription},
      {'location_shop_fossoil_01_19', 'location_shop_fossoil_01_21', 'location_shop_fossoil_01_23', 'location_shop_fossoil_01_17', getText 'ContextMenu_Fossoil_Counter', MoreBuild.textBarElementDescription},
      {'location_shop_fossoil_01_18', 'location_shop_fossoil_01_20', 'location_shop_fossoil_01_22', 'location_shop_fossoil_01_16', getText 'ContextMenu_Fossoil_Station_Corner', MoreBuild.textBarCornerDescription},
      {'location_shop_gas2go_01_19', 'location_shop_gas2go_01_21', 'location_shop_gas2go_01_23', 'location_shop_gas2go_01_17', getText 'ContextMenu_Gas2Go_Counter', MoreBuild.textBarElementDescription},
      {'location_shop_gas2go_01_18', 'location_shop_gas2go_01_20', 'location_shop_gas2go_01_22', 'location_shop_gas2go_01_16', getText 'ContextMenu_Gas2Go_Cabinet', MoreBuild.textBarCornerDescription}
    },
    [getText 'ContextMenu_Business_Counters2'] = {
      {'location_restaurant_pizzawhirled_01_35', 'location_restaurant_pizzawhirled_01_37', 'location_restaurant_pizzawhirled_01_39', 'location_restaurant_pizzawhirled_01_33', getText 'ContextMenu_PizzaWhirled_Counter', MoreBuild.textBarElementDescription},
      {'location_restaurant_pizzawhirled_01_32', 'location_restaurant_pizzawhirled_01_36', 'location_restaurant_pizzawhirled_01_38', 'location_restaurant_pizzawhirled_01_34', getText 'ContextMenu_PizzaWhirled_Corner', MoreBuild.textBarCornerDescription},
      {'location_restaurant_seahorse_01_43', 'location_restaurant_seahorse_01_49', 'location_restaurant_seahorse_01_51', 'location_restaurant_seahorse_01_41', getText 'ContextMenu_SeahorseCoffee_Counter', MoreBuild.textBarElementDescription},
      {'location_restaurant_seahorse_01_42', 'location_restaurant_seahorse_01_48', 'location_restaurant_seahorse_01_50', 'location_restaurant_seahorse_01_40', getText 'ContextMenu_SeahorseCoffee_Corner', MoreBuild.textBarCornerDescription},
      {'location_restaurant_spiffos_01_59', 'location_restaurant_spiffos_01_61', 'location_restaurant_spiffos_01_63', 'location_restaurant_spiffos_01_57', getText 'ContextMenu_Spiffos_Counter', MoreBuild.textBarElementDescription},
      {'location_restaurant_spiffos_01_56', 'location_restaurant_spiffos_01_60', 'location_restaurant_spiffos_01_62', 'location_restaurant_spiffos_01_58', getText 'ContextMenu_Spiffos_Corner', MoreBuild.textBarCornerDescription},
      {'location_restaurant_diner_01_27', 'location_restaurant_diner_01_29', 'location_restaurant_diner_01_31', 'location_restaurant_diner_01_25', getText 'ContextMenu_Diner_Counter', MoreBuild.textBarElementDescription},
      {'location_restaurant_diner_01_26', 'location_restaurant_diner_01_28', 'location_restaurant_diner_01_30', 'location_restaurant_diner_01_24', getText 'ContextMenu_Diner_Corner', MoreBuild.textBarCornerDescription},
      {'location_shop_zippee_01_19', 'location_shop_zippee_01_21', 'location_shop_zippee_01_23', 'location_shop_zippee_01_17', getText 'ContextMenu_Zippee_Counter', MoreBuild.textBarElementDescription},
      {'location_shop_zippee_01_18', 'location_shop_zippee_01_20', 'location_shop_zippee_01_22', 'location_shop_zippee_01_16', getText 'ContextMenu_Zippee_Corner', MoreBuild.textBarCornerDescription}
    }
  }

  return _barElementData
end