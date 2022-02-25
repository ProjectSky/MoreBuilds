if not getMoreBuildInstance then
  require('MoreBuildings/MoreBuilds_Main')
end

local MoreBuild = getMoreBuildInstance()

MoreBuild.onBuildLaundryCart = function(ignoreThisArgument, sprite, player, name)
  local _cart = ISWoodenContainer:new(sprite.sprite, sprite.northSprite)

  _cart.canPassThrough = true
  _cart.canBarricade = false
  _cart.canBeLockedByPadlock = true
  _cart.renderFloorHelper = true
  _cart.canBeAlwaysPlaced = true
  _cart.player = player
  _cart.name = name

  _cart.modData['need:Base.Sheet'] = 1
  _cart.modData['need:Base.Screws'] = 2
  _cart.modData['need:Base.SheetMetal'] = 1
  _cart.modData['xp:Woodwork'] = 5

  function _cart:getHealth()
    self.javaObject:getContainer():setType('officedrawers')
    return MoreBuild.healthLevel.woodContainer + buildUtil.getWoodHealth(self)
  end

  MoreBuild.equipToolPrimary(_cart, player, 'Screwdriver')

  getCell():setDrag(_cart, player)
end

MoreBuild.dressersMenuBuilder = function(subMenu, player)
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
      Material = 'Base.Drawer',
      Amount = 1
    }
  }

  MoreBuild.neededTools = {'Hammer'}

  local needSkills = {
    Woodwork = MoreBuild.skillLevel.advancedContainer
  }

  local _dresserData = MoreBuild.getDresserData()

  for _, _currentList in pairs(_dresserData) do
    _sprite = {}
    _sprite.sprite = _currentList[1]
    _sprite.northSprite = _currentList[2]
    _sprite.eastSprite = _currentList[3]
    _sprite.southSprite = _currentList[4]

    _name = _currentList[5]

    _option = subMenu:addOption(_name, nil, MoreBuild.onBuildDresser, _sprite, player, _name)

    _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
    _tooltip:setName(_name)
    _tooltip.description = _currentList[6] .. _tooltip.description
    _tooltip:setTexture(_sprite.sprite)
  end
end

MoreBuild.getDresserData = function()
  local _dresserData = {
    {'furniture_storage_01_46', 'furniture_storage_01_47', 'furniture_storage_01_44', 'furniture_storage_01_45', getText 'ContextMenu_Beige_Dresser', MoreBuild.textDresserDescription},
    {'furniture_storage_01_49', 'furniture_storage_01_48', 'furniture_storage_01_50', 'furniture_storage_01_51', getText 'ContextMenu_Beige_Nightstand', getText 'Tooltip_Beige_Nightstand'},
    {'furniture_storage_01_12', 'furniture_storage_01_13', 'furniture_storage_01_14', 'furniture_storage_01_15', getText 'ContextMenu_Dark_Brown_Dresser', MoreBuild.textDresserDescription},
    {'furniture_storage_01_32', 'furniture_storage_01_33', 'furniture_storage_01_34', 'furniture_storage_01_35', getText 'ContextMenu_Gray_Dresser', MoreBuild.textDresserDescription},
    {'furniture_storage_01_8', 'furniture_storage_01_9', 'furniture_storage_01_10', 'furniture_storage_01_11', getText 'ContextMenu_White_Dresser', MoreBuild.textDresserDescription}
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

  _dresser.modData['need:Base.Plank'] = 4
  _dresser.modData['need:Base.Nails'] = 4
  _dresser.modData['need:Base.Drawer'] = 1
  _dresser.modData['xp:Woodwork'] = 5

  function _dresser:getHealth()
    self.javaObject:getContainer():setType('wardrobe')
    return MoreBuild.healthLevel.woodContainer + buildUtil.getWoodHealth(self)
  end

  getCell():setDrag(_dresser, player)
end

MoreBuild.otherFurnitureMenuBuilder = function(subMenu, player)
  local _sprite
  local _option
  local _tooltip
  local _name = ''
  local _icon = ''

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
      Material = 'Base.Drawer',
      Amount = 1
    }
  }

  MoreBuild.neededTools = {'Hammer'}

  local needSkills = {
    Woodwork = MoreBuild.skillLevel.advancedContainer
  }

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

    _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
    _tooltip.description = _currentList[7] .. _tooltip.description
    _tooltip:setName(_name)
    _tooltip:setTexture(_sprite.sprite)
  end
end

MoreBuild.getOtherFurnitureData = function()
  local _otherFurnitureData = {
    {
      'location_business_office_generic_01_16',
      'location_business_office_generic_01_17',
      'location_business_office_generic_01_24',
      'location_business_office_generic_01_25',
      getText 'ContextMenu_GrayFiling_Cabinet',
      'officedrawers',
      getText 'Tooltip_GrayFiling_Cabinet'
    },
    {
      'location_business_office_generic_01_32',
      'location_business_office_generic_01_33',
      'location_business_office_generic_01_34',
      'location_business_office_generic_01_35',
      getText 'ContextMenu_YellowFiling_Cabinet',
      'officedrawers',
      getText 'Tooltip_YellowFiling_Cabinet'
    },
    {
      'location_community_medical_01_36',
      'location_community_medical_01_37',
      'location_community_medical_01_38',
      'location_community_medical_01_39',
      getText 'ContextMenu_Medical_Drawers',
      'medicine',
      getText 'Tooltip_Medical_Drawers'
    },
    {
      'furniture_storage_01_53',
      'furniture_storage_01_52',
      'furniture_storage_01_54',
      'furniture_storage_01_55',
      getText 'ContextMenu_EndTableWith_Drawer',
      'sidetable',
      getText 'Tooltip_EndTableWith_Drawer'
    },
    {
      'location_community_school_01_4',
      'location_community_school_01_5',
      'location_community_school_01_7',
      'location_community_school_01_6',
      getText 'ContextMenu_BrownSchool_Desk',
      'officedrawers',
      getText 'Tooltip_BrownSchool_Desk'
    },
    {
      'location_community_school_01_12',
      'location_community_school_01_13',
      'location_community_school_01_15',
      'location_community_school_01_14',
      getText 'ContextMenu_GreenSchool_Desk',
      'officedrawers',
      getText 'Tooltip_BrownSchool_Desk'
    },
    {
      'furniture_tables_low_01_12',
      'furniture_tables_low_01_13',
      'furniture_tables_low_01_12',
      'furniture_tables_low_01_13',
      getText 'ContextMenu_CoffeeTableWith_Storage',
      'sidetable',
      getText 'Tooltip_CoffeeTableWith_Storage'
    }
  }

  return _otherFurnitureData
end