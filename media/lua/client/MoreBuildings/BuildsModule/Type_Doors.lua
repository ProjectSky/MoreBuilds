if not getMoreBuildInstance then
  require('MoreBuildings/MoreBuilds_Main')
end

local MoreBuild = getMoreBuildInstance()

MoreBuild.doorsMenuBuilder = function(subMenu, player, context, worldobjects)
  local _woodenDoorsOption = subMenu:addOption(getText 'ContextMenu_Wooden_Doors', worldobjects, nil)
  local _woodenDoorsSubMenu = subMenu:getNew(subMenu)

  context:addSubMenu(_woodenDoorsOption, _woodenDoorsSubMenu)
  MoreBuild.woodenDoorsMenuBuilder(_woodenDoorsSubMenu, player)

  local _panelDoorsOption = subMenu:addOption(getText 'ContextMenu_Panel_Doors', worldobjects, nil)
  local _panelDoorsSubMenu = subMenu:getNew(subMenu)

  context:addSubMenu(_panelDoorsOption, _panelDoorsSubMenu)
  MoreBuild.panelDoorsMenuBuilder(_panelDoorsSubMenu, player)

  local _industrialDoorsOption = subMenu:addOption(getText 'ContextMenu_Industrial_Doors', worldobjects, nil)
  local _industrialDoorsSubMenu = subMenu:getNew(subMenu)

  context:addSubMenu(_industrialDoorsOption, _industrialDoorsSubMenu)
  MoreBuild.industrialDoorsMenuBuilder(_industrialDoorsSubMenu, player)

  local _exteriorDoorsOption = subMenu:addOption(getText 'ContextMenu_Exterior_Doors', worldobjects, nil)
  local _exteriorDoorsSubMenu = subMenu:getNew(subMenu)

  context:addSubMenu(_exteriorDoorsOption, _exteriorDoorsSubMenu)
  MoreBuild.exteriorDoorsMenuBuilder(_exteriorDoorsSubMenu, player)

  local _LowDoorsOption = subMenu:addOption(getText 'ContextMenu_Low_Doors', worldobjects, nil)
  local _LowDoorsSubMenu = subMenu:getNew(subMenu)

  context:addSubMenu(_LowDoorsOption, _LowDoorsSubMenu)
  MoreBuild.lowDoorsMenuBuilder(_LowDoorsSubMenu, player)

  local _otherDoorsOption = subMenu:addOption(getText 'ContextMenu_Other_Doors', worldobjects, nil)
  local _otherDoorsSubMenu = subMenu:getNew(subMenu)

  context:addSubMenu(_otherDoorsOption, _otherDoorsSubMenu)
  MoreBuild.otherDoorsMenuBuilder(_otherDoorsSubMenu, player)
end

MoreBuild.woodenDoorsMenuBuilder = function(subMenu, player)
  local _sprite
  local _option
  local _tooltip
  local _name = ''

  MoreBuild.neededMaterials = {
    {
      Material = 'Plank',
      Amount = 4,
      Text = getItemNameFromFullType('Base.Plank')
    },
    {
      Material = 'Nails',
      Amount = 4,
      Text = getItemNameFromFullType('Base.Nails')
    },
    {
      Material = 'Doorknob',
      Amount = 1,
      Text = getItemNameFromFullType('Base.Doorknob')
    },
    {
      Material = 'Hinge',
      Amount = 2,
      Text = getItemNameFromFullType('Base.Hinge')
    }
  }

  MoreBuild.neededTools = {'Hammer'}

  _sprite = {}
  _sprite.sprite = 'fixtures_doors_02_0'
  _sprite.northSprite = 'fixtures_doors_02_1'
  _sprite.openSprite = 'fixtures_doors_02_2'
  _sprite.openNorthSprite = 'fixtures_doors_02_3'

  _name = getText 'ContextMenu_Blue_WoodenDoor'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.skillLevel.none, _option, player)
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

  _tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.skillLevel.none, _option, player)
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

  _tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.skillLevel.none, _option, player)
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

  _tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.skillLevel.none, _option, player)
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

  _tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.skillLevel.none, _option, player)
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
      Material = 'Plank',
      Amount = 4,
      Text = getItemNameFromFullType('Base.Plank')
    },
    {
      Material = 'Nails',
      Amount = 4,
      Text = getItemNameFromFullType('Base.Nails')
    },
    {
      Material = 'Doorknob',
      Amount = 1,
      Text = getItemNameFromFullType('Base.Doorknob')
    },
    {
      Material = 'Hinge',
      Amount = 2,
      Text = getItemNameFromFullType('Base.Hinge')
    }
  }

  MoreBuild.neededTools = {'Hammer'}

  _sprite = {}
  _sprite.sprite = 'fixtures_doors_02_16'
  _sprite.northSprite = 'fixtures_doors_02_17'
  _sprite.openSprite = 'fixtures_doors_02_18'
  _sprite.openNorthSprite = 'fixtures_doors_02_19'

  _name = getText 'ContextMenu_Brown_PanelDoor'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.skillLevel.none, _option, player)
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

  _tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.skillLevel.none, _option, player)
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

  _tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.skillLevel.none, _option, player)
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
      Material = 'Plank',
      Amount = 4,
      Text = getItemNameFromFullType('Base.Plank')
    },
    {
      Material = 'Nails',
      Amount = 4,
      Text = getItemNameFromFullType('Base.Nails')
    },
    {
      Material = 'Doorknob',
      Amount = 1,
      Text = getItemNameFromFullType('Base.Doorknob')
    },
    {
      Material = 'Hinge',
      Amount = 2,
      Text = getItemNameFromFullType('Base.Hinge')
    }
  }

  MoreBuild.neededTools = {'Hammer'}

  _sprite = {}
  _sprite.sprite = 'fixtures_doors_02_12'
  _sprite.northSprite = 'fixtures_doors_02_13'
  _sprite.openSprite = 'fixtures_doors_02_14'
  _sprite.openNorthSprite = 'fixtures_doors_02_15'

  _name = getText 'ContextMenu_Black_IndustrialDoor'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.skillLevel.none, _option, player)
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

  _tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.skillLevel.none, _option, player)
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

  _tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.skillLevel.none, _option, player)
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

  _tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.skillLevel.none, _option, player)
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

  _tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.skillLevel.none, _option, player)
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

  _tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.skillLevel.none, _option, player)
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
      Material = 'Plank',
      Amount = 4,
      Text = getItemNameFromFullType('Base.Plank')
    },
    {
      Material = 'Nails',
      Amount = 4,
      Text = getItemNameFromFullType('Base.Nails')
    },
    {
      Material = 'Doorknob',
      Amount = 1,
      Text = getItemNameFromFullType('Base.Doorknob')
    },
    {
      Material = 'Hinge',
      Amount = 2,
      Text = getItemNameFromFullType('Base.Hinge')
    }
  }

  MoreBuild.neededTools = {'Hammer'}

  _sprite = {}
  _sprite.sprite = 'fixtures_doors_01_56'
  _sprite.northSprite = 'fixtures_doors_01_57'
  _sprite.openSprite = 'fixtures_doors_01_58'
  _sprite.openNorthSprite = 'fixtures_doors_01_59'

  _name = getText 'ContextMenu_Beige_ExteriorDoor'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.skillLevel.none, _option, player)
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

  _tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.skillLevel.none, _option, player)
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

  _tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.skillLevel.none, _option, player)
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
      Material = 'Plank',
      Amount = 4,
      Text = getItemNameFromFullType('Base.Plank')
    },
    {
      Material = 'Nails',
      Amount = 4,
      Text = getItemNameFromFullType('Base.Nails')
    },
    {
      Material = 'Doorknob',
      Amount = 1,
      Text = getItemNameFromFullType('Base.Doorknob')
    },
    {
      Material = 'Hinge',
      Amount = 2,
      Text = getItemNameFromFullType('Base.Hinge')
    }
  }

  MoreBuild.neededTools = {'Hammer'}

  _sprite = {}
  _sprite.sprite = 'fixtures_doors_01_28'
  _sprite.northSprite = 'fixtures_doors_01_29'
  _sprite.openSprite = 'fixtures_doors_01_30'
  _sprite.openNorthSprite = 'fixtures_doors_01_31'

  _name = getText 'ContextMenu_Rough_WoodenDoor'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.skillLevel.none, _option, player)
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

  _tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.skillLevel.none, _option, player)
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

  _tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.skillLevel.none, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_Spiffos_Door' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'fixtures_bathroom_02_26'
  _sprite.northSprite = 'fixtures_bathroom_02_27'
  _sprite.openSprite = 'fixtures_bathroom_02_28'
  _sprite.openNorthSprite = 'fixtures_bathroom_02_29'

  _name = getText 'ContextMenu_Outhouse_Door'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.skillLevel.none, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_Outhouse_Door' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)
end

MoreBuild.lowDoorsMenuBuilder = function(subMenu, player)
  local _sprite
  local _option
  local _tooltip
  local _name = ''

  MoreBuild.neededMaterials = {
    {
      Material = 'Plank',
      Amount = 1,
      Text = getItemNameFromFullType('Base.Plank')
    },
    {
      Material = 'Nails',
      Amount = 1,
      Text = getItemNameFromFullType('Base.Nails')
    }
  }

  MoreBuild.neededTools = {'Hammer'}

  _sprite = {}
  _sprite.sprite = 'fixtures_doors_frames_01_0'
  _sprite.northSprite = 'fixtures_doors_frames_01_1'
  _sprite.corner = ''

  _name = getText 'ContextMenu_Low_DoorFrame'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildLowDoorFrame, _sprite, player, _name)
  _tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.skillLevel.none, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_Low_DoorFrame' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  MoreBuild.neededMaterials = {
    {
      Material = 'Plank',
      Amount = 4,
      Text = getItemNameFromFullType('Base.Plank')
    },
    {
      Material = 'Nails',
      Amount = 4,
      Text = getItemNameFromFullType('Base.Nails')
    },
    {
      Material = 'Doorknob',
      Amount = 1,
      Text = getItemNameFromFullType('Base.Doorknob')
    },
    {
      Material = 'Hinge',
      Amount = 2,
      Text = getItemNameFromFullType('Base.Hinge')
    }
  }

  MoreBuild.neededTools = {'Hammer'}

  _sprite = {}
  _sprite.sprite = 'fixtures_doors_fences_01_4'
  _sprite.northSprite = 'fixtures_doors_fences_01_5'
  _sprite.openSprite = 'fixtures_doors_fences_01_6'
  _sprite.openNorthSprite = 'fixtures_doors_fences_01_7'

  _name = getText 'ContextMenu_Low_WoodenDoor'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenDoor, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.skillLevel.none, _option, player)
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

  _tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.skillLevel.none, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_White_Low_WoodenDoor' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  MoreBuild.neededMaterials = {
    {
      Material = 'Wire',
      Amount = 4,
      Text = getItemNameFromFullType('Base.Wire')
    },
    {
      Material = 'Nails',
      Amount = 4,
      Text = getItemNameFromFullType('Base.Nails')
    },
    {
      Material = 'Doorknob',
      Amount = 1,
      Text = getItemNameFromFullType('Base.Doorknob')
    },
    {
      Material = 'Hinge',
      Amount = 2,
      Text = getItemNameFromFullType('Base.Hinge')
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

  _tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.doorObject, MoreBuild.skillLevel.none, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_Metal_LowDoor' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)
end

MoreBuild.onBuildWoodenDoor = function(ignoreThisArgument, sprite, player, name)
  local _door = ISWoodenDoor:new(sprite.sprite, sprite.northSprite, sprite.openSprite, sprite.openNorthSprite)

  _door.player = player
  _door.name = name

  _door.modData['need:Base.Plank'] = '4'
  _door.modData['need:Base.Nails'] = '4'
  _door.modData['need:Base.Hinge'] = '2'
  _door.modData['need:Base.Doorknob'] = '1'
  _door.modData['xp:Woodwork'] = '5'

  local _knob = getSpecificPlayer(player):getInventory():FindAndReturn('Base.Doorknob')
  if _knob and _knob:getKeyId() ~= -1 then
    _door.keyId = _knob:getKeyId()
  end

  getCell():setDrag(_door, player)
end

MoreBuild.onBuildLowdoorframe = function(ignoreThisArgument, sprite, player, name)
  local _lowdoorframe = ISWoodenDoor:new(sprite.sprite, sprite.northSprite, sprite.openSprite, sprite.openNorthSprite)

  _lowdoorframe.player = player
  _lowdoorframe.name = name

  _lowdoorframe.modData['need:Base.Wire'] = '4'
  _lowdoorframe.modData['need:Base.Nails'] = '4'
  _lowdoorframe.modData['need:Base.Hinge'] = '1'
  _lowdoorframe.modData['need:Base.Doorknob'] = '2'
  _lowdoorframe.modData['xp:Woodwork'] = '5'

  local _knob = getSpecificPlayer(player):getInventory():FindAndReturn('Base.Doorknob')
  if _knob and _knob:getKeyId() ~= -1 then
    _lowdoorframe.keyId = _knob:getKeyId()
  end

  getCell():setDrag(_lowdoorframe, player)
end