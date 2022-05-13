if not getMoreBuildInstance then
  require('MoreBuildings/MoreBuilds_Main')
end

local MoreBuild = getMoreBuildInstance()

MoreBuild.doorsMenuBuilder = function(subMenu, player, context)
  local _woodenDoorsOption = subMenu:addOption(getText 'ContextMenu_Wooden_Doors')
  local _woodenDoorsSubMenu = subMenu:getNew(subMenu)

  context:addSubMenu(_woodenDoorsOption, _woodenDoorsSubMenu)
  MoreBuild.woodenDoorsMenuBuilder(_woodenDoorsSubMenu, player)

  local _panelDoorsOption = subMenu:addOption(getText 'ContextMenu_Panel_Doors')
  local _panelDoorsSubMenu = subMenu:getNew(subMenu)

  context:addSubMenu(_panelDoorsOption, _panelDoorsSubMenu)
  MoreBuild.panelDoorsMenuBuilder(_panelDoorsSubMenu, player)

  local _industrialDoorsOption = subMenu:addOption(getText 'ContextMenu_Industrial_Doors')
  local _industrialDoorsSubMenu = subMenu:getNew(subMenu)

  context:addSubMenu(_industrialDoorsOption, _industrialDoorsSubMenu)
  MoreBuild.industrialDoorsMenuBuilder(_industrialDoorsSubMenu, player)

  local _exteriorDoorsOption = subMenu:addOption(getText 'ContextMenu_Exterior_Doors')
  local _exteriorDoorsSubMenu = subMenu:getNew(subMenu)

  context:addSubMenu(_exteriorDoorsOption, _exteriorDoorsSubMenu)
  MoreBuild.exteriorDoorsMenuBuilder(_exteriorDoorsSubMenu, player)

  local _LowDoorsOption = subMenu:addOption(getText 'ContextMenu_Low_Doors')
  local _LowDoorsSubMenu = subMenu:getNew(subMenu)

  context:addSubMenu(_LowDoorsOption, _LowDoorsSubMenu)
  MoreBuild.lowDoorsMenuBuilder(_LowDoorsSubMenu, player)

  local _doubleDoorsOption = subMenu:addOption(getText 'ContextMenu_Garage_Doors')
  local _doubleDoorsSubMenu = subMenu:getNew(subMenu)

  context:addSubMenu(_doubleDoorsOption, _doubleDoorsSubMenu)
  MoreBuild.garageDoorMenuBuilder(_doubleDoorsSubMenu, player)

  local _otherDoorsOption = subMenu:addOption(getText 'ContextMenu_Other_Doors')
  local _otherDoorsSubMenu = subMenu:getNew(subMenu)

  context:addSubMenu(_otherDoorsOption, _otherDoorsSubMenu)
  MoreBuild.otherDoorsMenuBuilder(_otherDoorsSubMenu, player)

  local _glassDoorsOption = subMenu:addOption(getText 'ContextMenu_Glass_Doors')
  local _glassDoorsSubMenu = subMenu:getNew(subMenu)

  context:addSubMenu(_glassDoorsOption, _glassDoorsSubMenu)
  MoreBuild.glassDoorsMenuBuilder(_glassDoorsSubMenu, player)
end

MoreBuild.garageDoorMenuBuilder = function(subMenu, player)
  local _sprite
  local _option
  local _tooltip
  local _name = ''

  MoreBuild.neededMaterials = {
    {
      Material = 'Base.Plank',
      Amount = 8
    },
    {
      Material = 'Base.Nails',
      Amount = 8
    },
    {
      Material = 'Base.Doorknob',
      Amount = 2
    },
    {
      Material = 'Base.Hinge',
      Amount = 4
    },
    {
      Material = 'Base.Screws',
      Amount = 8
    },
    {
      Material = 'Base.SmallSheetMetal',
      Amount = 4
    }
  }

  MoreBuild.neededTools = {'Hammer', 'Screwdriver', 'Saw'}

  local needSkills = {
    Woodwork = MoreBuild.skillLevel.garageDoorObject
  }

  _sprite = {}
  _sprite.sprite = 'walls_garage_01_'

  _name = getText 'ContextMenu_White_Garage_Door'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildGarageDoor, _sprite, 0, player)
  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_White_Garage_Door' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite .. 1)

  _name = getText 'ContextMenu_Green_Garage_Door'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildGarageDoor, _sprite, 16, player)
  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_Green_Garage_Door' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite .. 17)

  _name = getText 'ContextMenu_Grey_Garage_Door'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildGarageDoor, _sprite, 48, player)
  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_Grey_Garage_Door' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite .. 49)

  _sprite = {}
  _sprite.sprite = 'walls_garage_02_'

  _name = getText 'ContextMenu_Rolling_Garage_Door'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildGarageDoor, _sprite, 0, player)
  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_Rolling_Garage_Door' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite .. 1)

  _name = getText 'ContextMenu_Red_Window_Garage_Door'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildGarageDoor, _sprite, 32, player)
  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_Red_Window_Garage_Door' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite .. 33)

  _name = getText 'ContextMenu_Gray_Window_Garage_Door'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildGarageDoor, _sprite, 48, player)
  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_Gray_Window_Garage_Door' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite .. 49)
end

MoreBuild.woodenDoorsMenuBuilder = function(subMenu, player)
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
    },
    {
      Material = 'Base.Doorknob',
      Amount = 1
    },
    {
      Material = 'Base.Hinge',
      Amount = 2
    }
  }

  MoreBuild.neededTools = {'Hammer'}

  local needSkills = {
    Woodwork = MoreBuild.skillLevel.doorObject
  }

  _sprite = {}
  _sprite.sprite = 'fixtures_doors_02_0'
  _sprite.northSprite = 'fixtures_doors_02_1'
  _sprite.openSprite = 'fixtures_doors_02_2'
  _sprite.openNorthSprite = 'fixtures_doors_02_3'

  _name = getText 'ContextMenu_Blue_WoodenDoor'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textDoorGenericDescription .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'fixtures_doors_01_4'
  _sprite.northSprite = 'fixtures_doors_01_5'
  _sprite.openSprite = 'fixtures_doors_01_6'
  _sprite.openNorthSprite = 'fixtures_doors_01_7'

  _name = getText 'ContextMenu_Brown_WoodenDoor'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textDoorGenericDescription .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'fixtures_doors_01_12'
  _sprite.northSprite = 'fixtures_doors_01_13'
  _sprite.openSprite = 'fixtures_doors_01_14'
  _sprite.openNorthSprite = 'fixtures_doors_01_15'

  _name = getText 'ContextMenu_DarkBrown_WoodenDoor'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textDoorGenericDescription .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'location_community_church_small_01_64'
  _sprite.northSprite = 'location_community_church_small_01_65'
  _sprite.openSprite = 'location_community_church_small_01_66'
  _sprite.openNorthSprite = 'location_community_church_small_01_67'

  _name = getText 'ContextMenu_FancyBrown_Door'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textDoorGenericDescription .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'fixtures_doors_01_0'
  _sprite.northSprite = 'fixtures_doors_01_1'
  _sprite.openSprite = 'fixtures_doors_01_2'
  _sprite.openNorthSprite = 'fixtures_doors_01_3'

  _name = getText 'ContextMenu_White_WoodenDoor'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textDoorGenericDescription .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)
end

MoreBuild.panelDoorsMenuBuilder = function(subMenu, player)
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
    },
    {
      Material = 'Base.Doorknob',
      Amount = 1
    },
    {
      Material = 'Base.Hinge',
      Amount = 2
    }
  }

  MoreBuild.neededTools = {'Hammer'}

  local needSkills = {
    Woodwork = MoreBuild.skillLevel.doorObject
  }

  _sprite = {}
  _sprite.sprite = 'fixtures_doors_02_16'
  _sprite.northSprite = 'fixtures_doors_02_17'
  _sprite.openSprite = 'fixtures_doors_02_18'
  _sprite.openNorthSprite = 'fixtures_doors_02_19'

  _name = getText 'ContextMenu_Brown_PanelDoor'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_Brown_PanelDoor' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'fixtures_doors_02_24'
  _sprite.northSprite = 'fixtures_doors_02_25'
  _sprite.openSprite = 'fixtures_doors_02_26'
  _sprite.openNorthSprite = 'fixtures_doors_02_27'

  _name = getText 'ContextMenu_Gray_PanelDoor'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_Brown_PanelDoor' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'fixtures_doors_02_20'
  _sprite.northSprite = 'fixtures_doors_02_21'
  _sprite.openSprite = 'fixtures_doors_02_22'
  _sprite.openNorthSprite = 'fixtures_doors_02_23'

  _name = getText 'ContextMenu_White_PanelDoor'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_Brown_PanelDoor' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)
end

MoreBuild.industrialDoorsMenuBuilder = function(subMenu, player)
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
    },
    {
      Material = 'Base.Doorknob',
      Amount = 1
    },
    {
      Material = 'Base.Hinge',
      Amount = 2
    }
  }

  MoreBuild.neededTools = {'Hammer'}

  local needSkills = {
    Woodwork = MoreBuild.skillLevel.doorObject
  }

  _sprite = {}
  _sprite.sprite = 'fixtures_doors_02_12'
  _sprite.northSprite = 'fixtures_doors_02_13'
  _sprite.openSprite = 'fixtures_doors_02_14'
  _sprite.openNorthSprite = 'fixtures_doors_02_15'

  _name = getText 'ContextMenu_Black_IndustrialDoor'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textDoorIndustrial .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'fixtures_doors_01_24'
  _sprite.northSprite = 'fixtures_doors_01_25'
  _sprite.openSprite = 'fixtures_doors_01_26'
  _sprite.openNorthSprite = 'fixtures_doors_01_27'

  _name = getText 'ContextMenu_Blue_IndustrialDoor'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textDoorIndustrial .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'location_restaurant_pizzawhirled_01_60'
  _sprite.northSprite = 'location_restaurant_pizzawhirled_01_61'
  _sprite.openSprite = 'location_restaurant_pizzawhirled_01_62'
  _sprite.openNorthSprite = 'location_restaurant_pizzawhirled_01_63'

  _name = getText 'ContextMenu_Green_IndustrialDoor'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textDoorIndustrial .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'location_restaurant_pileocrepe_01_52'
  _sprite.northSprite = 'location_restaurant_pileocrepe_01_53'
  _sprite.openSprite = 'location_restaurant_pileocrepe_01_54'
  _sprite.openNorthSprite = 'location_restaurant_pileocrepe_01_55'

  _name = getText 'ContextMenu_Orange_IndustrialDoor'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textDoorIndustrial .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'fixtures_doors_02_8'
  _sprite.northSprite = 'fixtures_doors_02_9'
  _sprite.openSprite = 'fixtures_doors_02_10'
  _sprite.openNorthSprite = 'fixtures_doors_02_11'

  _name = getText 'ContextMenu_Red_IndustrialDoor'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textDoorIndustrial .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'fixtures_doors_01_60'
  _sprite.northSprite = 'fixtures_doors_01_61'
  _sprite.openSprite = 'fixtures_doors_01_62'
  _sprite.openNorthSprite = 'fixtures_doors_01_63'

  _name = getText 'ContextMenu_White_IndustrialDoor'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textDoorIndustrial .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)
end

MoreBuild.exteriorDoorsMenuBuilder = function(subMenu, player)
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
    },
    {
      Material = 'Base.Doorknob',
      Amount = 1
    },
    {
      Material = 'Base.Hinge',
      Amount = 2
    }
  }

  MoreBuild.neededTools = {'Hammer'}

  local needSkills = {
    Woodwork = MoreBuild.skillLevel.doorObject
  }

  _sprite = {}
  _sprite.sprite = 'fixtures_doors_01_56'
  _sprite.northSprite = 'fixtures_doors_01_57'
  _sprite.openSprite = 'fixtures_doors_01_58'
  _sprite.openNorthSprite = 'fixtures_doors_01_59'

  _name = getText 'ContextMenu_Beige_ExteriorDoor'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textDoorExterior .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'fixtures_doors_01_52'
  _sprite.northSprite = 'fixtures_doors_01_53'
  _sprite.openSprite = 'fixtures_doors_01_54'
  _sprite.openNorthSprite = 'fixtures_doors_01_55'

  _name = getText 'ContextMenu_Gray_ExteriorDoor'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textDoorExterior .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'fixtures_doors_01_64'
  _sprite.northSprite = 'fixtures_doors_01_65'
  _sprite.openSprite = 'fixtures_doors_01_66'
  _sprite.openNorthSprite = 'fixtures_doors_01_67'

  _name = getText 'ContextMenu_Orange_ExteriorDoor'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textDoorExterior .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)
end

MoreBuild.otherDoorsMenuBuilder = function(subMenu, player)
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
    },
    {
      Material = 'Base.Doorknob',
      Amount = 1
    },
    {
      Material = 'Base.Hinge',
      Amount = 2
    }
  }

  MoreBuild.neededTools = {'Hammer'}

  local needSkills = {
    Woodwork = MoreBuild.skillLevel.doorObject
  }

  _sprite = {}
  _sprite.sprite = 'fixtures_doors_01_28'
  _sprite.northSprite = 'fixtures_doors_01_29'
  _sprite.openSprite = 'fixtures_doors_01_30'
  _sprite.openNorthSprite = 'fixtures_doors_01_31'

  _name = getText 'ContextMenu_Rough_WoodenDoor'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_Rough_WoodenDoor' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'fixtures_doors_fences_01_12'
  _sprite.northSprite = 'fixtures_doors_fences_01_13'
  _sprite.openSprite = 'fixtures_doors_fences_01_14'
  _sprite.openNorthSprite = 'fixtures_doors_fences_01_15'

  _name = getText 'ContextMenu_Wood_FortressDoor'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_Wood_FortressDoor' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'location_restaurant_spiffos_01_52'
  _sprite.northSprite = 'location_restaurant_spiffos_01_53'
  _sprite.openSprite = 'location_restaurant_spiffos_01_54'
  _sprite.openNorthSprite = 'location_restaurant_spiffos_01_55'

  _name = getText 'ContextMenu_Spiffos_Door'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_Spiffos_Door' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'fixtures_bathroom_02_32'
  _sprite.northSprite = 'fixtures_bathroom_02_33'
  _sprite.openSprite = 'fixtures_bathroom_02_34'
  _sprite.openNorthSprite = 'fixtures_bathroom_02_35'

  _name = getText 'ContextMenu_Outhouse_Door'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_Outhouse_Door' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'fixtures_doors_01_32'
  _sprite.northSprite = 'fixtures_doors_01_33'
  _sprite.openSprite = 'fixtures_doors_01_34'
  _sprite.openNorthSprite = 'fixtures_doors_01_35'

  _name = getText 'ContextMenu_Safety_Door'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_Safety_Door' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)
end

MoreBuild.glassDoorsMenuBuilder = function(subMenu, player)
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
    },
    {
      Material = 'Base.Doorknob',
      Amount = 1
    },
    {
      Material = 'Base.Hinge',
      Amount = 2
    }
  }

  MoreBuild.neededTools = {'Hammer'}

  local needSkills = {
    Woodwork = MoreBuild.skillLevel.doorObject
  }

  local _data = {
    Red_Frame_Glass = {
      sprites = {
        sprite = 'fixtures_doors_01_36',
        northSprite = 'fixtures_doors_01_37',
        openSprite = 'fixtures_doors_01_38',
        openNorthSprite = 'fixtures_doors_01_39',
      },
      action = MoreBuild.onBuildWoodenDoor,
    },
    Black_Frame_Glass = {
      sprites = {
        sprite = 'fixtures_doors_01_40',
        northSprite = 'fixtures_doors_01_41',
        openSprite = 'fixtures_doors_01_42',
        openNorthSprite = 'fixtures_doors_01_43',
      },
      action = MoreBuild.onBuildWoodenDoor,
    },
    Black_Frame_Glass2 = {
      sprites = {
        sprite = 'fixtures_doors_01_48',
        northSprite = 'fixtures_doors_01_49',
        openSprite = 'fixtures_doors_01_50',
        openNorthSprite = 'fixtures_doors_01_51',
      },
      action = MoreBuild.onBuildWoodenDoor,
    },
    White_Frame_Glass_Window = {
      sprites = {
        sprite = 'fixtures_doors_01_112',
        northSprite = 'fixtures_doors_01_113',
        openSprite = 'fixtures_doors_01_114',
        openNorthSprite = 'fixtures_doors_01_115',
      },
      action = MoreBuild.onBuildWindowWall,
    },
    White_Frame_Glass_Door = {
      sprites = {
        sprite = 'fixtures_doors_01_116',
        northSprite = 'fixtures_doors_01_117',
        openSprite = 'fixtures_doors_01_118',
        openNorthSprite = 'fixtures_doors_01_119',
      },
      action = MoreBuild.onBuildGlassDoor,
    },
    Brown_Frame_Glass_Window = {
      sprites = {
        sprite = 'fixtures_doors_01_104',
        northSprite = 'fixtures_doors_01_105',
        openSprite = 'fixtures_doors_01_106',
        openNorthSprite = 'fixtures_doors_01_107',
      },
      action = MoreBuild.onBuildWindowWall,
    },
    Brown_Frame_Glass_Door = {
      sprites = {
        sprite = 'fixtures_doors_01_108',
        northSprite = 'fixtures_doors_01_109',
        openSprite = 'fixtures_doors_01_110',
        openNorthSprite = 'fixtures_doors_01_111',
      },
      action = MoreBuild.onBuildGlassDoor,
    },
  }

  for key, data in pairs(_data) do
    _name = getText('ContextMenu_' .. key)
    _option = subMenu:addOption(_name, nil, data.action, data.sprites, player, _name)
    _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
    _tooltip:setName(_name)
    _tooltip.description = getText('Tooltip_' .. key) .. _tooltip.description
    _tooltip:setTexture(data.sprites.sprite)
  end
end

MoreBuild.lowDoorsMenuBuilder = function(subMenu, player)
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
    Woodwork = MoreBuild.skillLevel.wallObject
  }

  _sprite = {}
  _sprite.sprite = 'fixtures_doors_frames_01_0'
  _sprite.northSprite = 'fixtures_doors_frames_01_1'
  _sprite.corner = ''

  _name = getText 'ContextMenu_Low_DoorFrame'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildLowDoorFrame, _sprite, player, _name)
  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_Low_DoorFrame' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  MoreBuild.neededMaterials = {
    {
      Material = 'Base.Plank',
      Amount = 4
    },
    {
      Material = 'Base.Nails',
      Amount = 4
    },
    {
      Material = 'Base.Doorknob',
      Amount = 1
    },
    {
      Material = 'Base.Hinge',
      Amount = 2
    }
  }

  MoreBuild.neededTools = {'Hammer'}

  local needSkills = {
    Woodwork = MoreBuild.skillLevel.doorObject
  }

  _sprite = {}
  _sprite.sprite = 'fixtures_doors_fences_01_4'
  _sprite.northSprite = 'fixtures_doors_fences_01_5'
  _sprite.openSprite = 'fixtures_doors_fences_01_6'
  _sprite.openNorthSprite = 'fixtures_doors_fences_01_7'

  _name = getText 'ContextMenu_Low_WoodenDoor'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_Low_WoodenDoor' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'fixtures_doors_fences_01_8'
  _sprite.northSprite = 'fixtures_doors_fences_01_9'
  _sprite.openSprite = 'fixtures_doors_fences_01_10'
  _sprite.openNorthSprite = 'fixtures_doors_fences_01_11'

  _name = getText 'ContextMenu_White_Low_WoodenDoor'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_White_Low_WoodenDoor' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  MoreBuild.neededMaterials = {
    {
      Material = 'Base.Wire',
      Amount = 4
    },
    {
      Material = 'Base.Nails',
      Amount = 4
    },
    {
      Material = 'Base.Doorknob',
      Amount = 1
    },
    {
      Material = 'Base.Hinge',
      Amount = 2
    }
  }

  MoreBuild.neededTools = {'Hammer'}

  _sprite = {}
  _sprite.sprite = 'fixtures_doors_fences_01_16'
  _sprite.northSprite = 'fixtures_doors_fences_01_17'
  _sprite.openSprite = 'fixtures_doors_fences_01_18'
  _sprite.openNorthSprite = 'fixtures_doors_fences_01_19'

  _name = getText 'ContextMenu_Metal_LowDoor'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildLowdoorframe, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_Metal_LowDoor' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)
end

MoreBuild.onBuildWoodenDoor = function(ignoreThisArgument, sprite, player, name)
  local _door = ISWoodenDoor:new(sprite.sprite, sprite.northSprite, sprite.openSprite, sprite.openNorthSprite)

  _door.player = player
  _door.name = name

  _door.modData['need:Base.Plank'] = 4
  _door.modData['need:Base.Nails'] = 4
  _door.modData['need:Base.Hinge'] = 2
  _door.modData['need:Base.Doorknob'] = 1
  _door.modData['xp:Woodwork'] = 5

  getCell():setDrag(_door, player)
end

MoreBuild.onBuildGlassDoor = function(ignoreThisArgument, sprite, player, name)
  local _door = ISWoodenDoor:new(sprite.sprite, sprite.northSprite, sprite.openSprite, sprite.openNorthSprite)

  _door.dontNeedFrame = true
  _door.player = player
  _door.name = name

  _door.modData['need:Base.Plank'] = 4
  _door.modData['need:Base.Nails'] = 4
  _door.modData['need:Base.Hinge'] = 2
  _door.modData['need:Base.Doorknob'] = 1
  _door.modData['xp:Woodwork'] = 5

  getCell():setDrag(_door, player)
end

MoreBuild.onBuildLowdoorframe = function(ignoreThisArgument, sprite, player, name)
  local _lowdoorframe = ISWoodenDoor:new(sprite.sprite, sprite.northSprite, sprite.openSprite, sprite.openNorthSprite)

  _lowdoorframe.player = player
  _lowdoorframe.name = name

  _lowdoorframe.modData['need:Base.Wire'] = 4
  _lowdoorframe.modData['need:Base.Nails'] = 4
  _lowdoorframe.modData['need:Base.Hinge'] = 1
  _lowdoorframe.modData['need:Base.Doorknob'] = 2
  _lowdoorframe.modData['xp:Woodwork'] = 5

  getCell():setDrag(_lowdoorframe, player)
end

MoreBuild.onBuildGarageDoor = function(ignoreThisArgument, sprite, spriteIndex, player)
  local _garageDoor = ISGarageDoor:new(sprite.sprite, spriteIndex)

  _garageDoor.player = player

  _garageDoor.modData['need:Base.Plank'] = 8
  _garageDoor.modData['need:Base.Nails'] = 8
  _garageDoor.modData['need:Base.Doorknob'] = 2
  _garageDoor.modData['need:Base.Hinge'] = 4
  _garageDoor.modData['need:Base.Screws'] = 8
  _garageDoor.modData['need:Base.SmallSheetMetal'] = 4
  _garageDoor.modData['xp:Woodwork'] = 15

  function _garageDoor:getHealth()
    return MoreBuild.healthLevel.metalDoor + buildUtil.getWoodHealth(self)
  end

  getCell():setDrag(_garageDoor, player)
end