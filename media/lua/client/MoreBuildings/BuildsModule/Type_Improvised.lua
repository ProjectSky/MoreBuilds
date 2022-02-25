if not getMoreBuildInstance then
  require('MoreBuildings/MoreBuilds_Main')
end

local MoreBuild = getMoreBuildInstance()

MoreBuild.improvisedMenuBuilder = function(subMenu, player)
  local _sprite
  local _option
  local _tooltip
  local _name = ''
  local _icon = ''

  MoreBuild.neededMaterials = {
    {
      Material = 'Base.Sheet',
      Amount = 1
    },
    {
      Material = 'Base.Screws',
      Amount = 2
    },
    {
      Material = 'Base.SheetMetal',
      Amount = 1
    }
  }

  MoreBuild.neededTools = {'Screwdriver'}

  local needSkills = {
    Woodwork = MoreBuild.skillLevel.simpleContainer
  }

  _sprite = {}
  _sprite.sprite = 'appliances_laundry_01_24'
  _sprite.northSprite = 'appliances_laundry_01_25'

  _name = getText 'ContextMenu_Laundry_Cart'
  _icon = 'officedrawers'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildLaundryCart, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_Laundry_Cart' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  MoreBuild.neededMaterials = {
    {
      Material = 'Base.Plank',
      Amount = 2
    },
    {
      Material = 'Base.Nails',
      Amount = 3
    }
  }

  MoreBuild.neededTools = {'Hammer'}

  local needSkills = {
    Woodwork = MoreBuild.skillLevel.complexContainer
  }

  _sprite = {}
  _sprite.sprite = 'construction_01_4'
  _sprite.northSprite = 'construction_01_4'

  _name = getText 'ContextMenu_Pallet_of_Bricks'
  _icon = 'fireplace'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildStoneContainer, _sprite, player, _name, _icon)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_Pallet_of_Bricks' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  MoreBuild.neededMaterials = {
    {
      Material = 'Base.SheetMetal',
      Amount = 2
    },
    {
      Material = 'Base.Screws',
      Amount = 2
    }
  }

  MoreBuild.neededTools = {'Screwdriver'}

  local needSkills = {
    Woodwork = MoreBuild.skillLevel.advancedContainer
  }

  _sprite = {}
  _sprite.sprite = 'industry_01_22'
  _sprite.northSprite = 'industry_01_23'

  _name = getText 'ContextMenu_Metal_Barrel'
  _icon = 'bin'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildMetalContainer, _sprite, player, _name, _icon)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_Metal_Barrel' .. _tooltip.description .. MoreBuild.textCanRotate
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'street_decoration_01_8'
  _sprite.northSprite = 'street_decoration_01_9'
  _sprite.eastSprite = 'street_decoration_01_10'
  _sprite.southSprite = 'street_decoration_01_11'

  _name = getText 'ContextMenu_Post_Box'
  _icon = 'vendingpop'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildMetalContainer, _sprite, player, _name, _icon)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_Post_Box' .. _tooltip.description .. MoreBuild.textCanRotate
  _tooltip:setTexture(_sprite.sprite)

  MoreBuild.neededMaterials = {
    {
      Material = 'Base.Plank',
      Amount = 2
    },
    {
      Material = 'Base.Nails',
      Amount = 2
    }
  }

  MoreBuild.neededTools = {'Hammer'}

  local needSkills = {
    Woodwork = MoreBuild.skillLevel.simpleContainer
  }

  _sprite = {}
  _sprite.sprite = 'trashcontainers_01_0'
  _sprite.northSprite = 'trashcontainers_01_1'
  _sprite.eastSprite = 'trashcontainers_01_2'
  _sprite.southSprite = 'trashcontainers_01_3'

  _name = getText 'ContextMenu_Recycling_Bin'
  _icon = 'bin'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenContainer, _sprite, player, _name, _icon)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_RecyclingBin' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)
end

MoreBuild.trashMenuBuilder = function(subMenu, player)
  local _sprite
  local _option
  local _tooltip
  local _name = ''
  local _icon = 'bin'

  local _trashCanData = MoreBuild.getTrashCanData()

  MoreBuild.neededMaterials = {
    {
      Material = 'Base.Plank',
      Amount = 2
    },
    {
      Material = 'Base.Nails',
      Amount = 2
    }
  }

  MoreBuild.neededTools = {'Hammer'}

  local needSkills = {
    Woodwork = MoreBuild.skillLevel.simpleContainer
  }

  for _, _currentList in pairs(_trashCanData['Wood']) do
    _sprite = {}
    _sprite.sprite = _currentList[1]
    _sprite.northSprite = _currentList[2]

    _name = _currentList[3]

    _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenContainer, _sprite, player, _name, _icon)

    _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
    _tooltip.description = MoreBuild.textTrashCanDescription .. _tooltip.description
    _tooltip:setName(_name)
    _tooltip:setTexture(_sprite.sprite)
  end

  MoreBuild.neededMaterials = {
    {
      Material = 'Base.SheetMetal',
      Amount = 2
    },
    {
      Material = 'Base.Screws',
      Amount = 2
    }
  }

  MoreBuild.neededTools = {'Screwdriver'}

  local needSkills = {
    Woodwork = MoreBuild.skillLevel.complexContainer
  }

  for _, _currentList in pairs(_trashCanData['Metal']) do
    _sprite = {}
    _sprite.sprite = _currentList[1]
    _sprite.northSprite = _currentList[2]

    _name = _currentList[3]

    _option = subMenu:addOption(_name, nil, MoreBuild.onBuildMetalContainer, _sprite, player, _name, _icon)

    _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
    _tooltip.description = MoreBuild.textTrashCanDescription .. _tooltip.description
    _tooltip:setName(_name)
    _tooltip:setTexture(_sprite.sprite)
  end

  MoreBuild.neededMaterials = {
    {
      Material = 'Base.Plank',
      Amount = 2
    },
    {
      Material = 'Base.Nails',
      Amount = 3
    }
  }

  MoreBuild.neededTools = {'Hammer'}

  for _, _currentList in pairs(_trashCanData['Stone']) do
    _sprite = {}
    _sprite.sprite = _currentList[1]
    _sprite.northSprite = _currentList[2]

    _name = _currentList[3]

    _option = subMenu:addOption(_name, nil, MoreBuild.onBuildStoneContainer, _sprite, player, _name, _icon)

    _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
    _tooltip.description = MoreBuild.textTrashCanDescription .. _tooltip.description
    _tooltip:setName(_name)
    _tooltip:setTexture(_sprite.sprite)
  end
end

MoreBuild.getTrashCanData = function()
  local _trashCanData = {
    ['Wood'] = {
      {'location_restaurant_pizzawhirled_01_17', 'location_restaurant_pizzawhirled_01_18', getText 'ContextMenu_Recycling_Bin'},
      {'location_restaurant_spiffos_01_30', 'location_restaurant_spiffos_01_31', getText 'ContextMenu_Recycling_Bin'},
      {'location_shop_fossoil_01_32', 'location_shop_fossoil_01_33', getText 'ContextMenu_Recycling_Bin'},
      {'trashcontainers_01_18', 'trashcontainers_01_19', getText 'ContextMenu_Factory_Trash_Can'},
      {'trashcontainers_01_20', 'trashcontainers_01_20', getText 'ContextMenu_Small_Waste_Basket'}
    },
    ['Metal'] = {
      {'trashcontainers_01_16', 'trashcontainers_01_16', getText 'ContextMenu_Steel_Trash_Can'},
      {'trashcontainers_01_17', 'trashcontainers_01_17', getText 'ContextMenu_Recycling_Bin'}
    },
    ['Stone'] = {
      {'location_shop_mall_01_44', 'location_shop_mall_01_44', getText 'ContextMenu_Mall_Trash'}
    }
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

  _container.modData['need:Base.Plank'] = 2
  _container.modData['need:Base.Nails'] = 2
  _container.modData['xp:Woodwork'] = 5

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

  _container.modData['need:Base.Plank'] = 4
  _container.modData['need:Base.Nails'] = 2
  _container.modData['xp:Woodwork'] = 5

  function _container:getHealth()
    self.javaObject:getContainer():setType(icon)
    return MoreBuild.healthLevel.stoneContainer + buildUtil.getWoodHealth(self)
  end

  MoreBuild.equipToolPrimary(_container, player, 'Hammer')

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

  _container.modData['need:Base.SheetMetal'] = 2
  _container.modData['need:Base.Screws'] = 2
  _container.modData['xp:Woodwork'] = 5

  MoreBuild.equipToolPrimary(_container, player, 'Screwdriver')

  function _container:getHealth()
    self.javaObject:getContainer():setType(icon)
    return MoreBuild.healthLevel.metalContainer + buildUtil.getWoodHealth(self)
  end

  getCell():setDrag(_container, player)
end