if not getMoreBuildInstance then
  require('MoreBuildings/MoreBuilds_Main')
end

local MoreBuild = getMoreBuildInstance()

MoreBuild.signsMenuBuilder = function(subMenu, player)
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
    Woodwork = MoreBuild.skillLevel.simpleObject
  }

  local _signsData = MoreBuild.getSignData()

  for _, _currentList in pairs(_signsData) do
    _sprite = {}
    _sprite.sprite = _currentList[1]
    _sprite.northSprite = _currentList[2]
    _sprite.eastSprite = _currentList[3]
    _sprite.southSprite = _currentList[4]

    _name = _currentList[5]

    _option = subMenu:addOption(_name, nil, MoreBuild.onBuildSign, _sprite, player, _name)

    _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
    _tooltip.description = _currentList[6] .. _tooltip.description
    _tooltip:setName(_name)
    _tooltip:setTexture(_sprite.sprite)
  end

  MoreBuild.neededMaterials = {
    {
      Material = 'Base.MetalBar',
      Amount = 2
    },
    {
      Material = 'Base.WeldingRods',
      Amount = 1
    }
  }

  MoreBuild.neededTools = {'Hammer', 'BlowTorch'}

  local needSkills = {
    MetalWelding = MoreBuild.skillLevel.simpleObject
  }

  local metalsignData = MoreBuild.getMetalSignData()

  for _, _metalsign in pairs(metalsignData) do
    _sprite = {}
    _sprite.sprite = _metalsign[1]
    _sprite.northSprite = _metalsign[2]
    _sprite.eastSprite = _metalsign[3]
    _sprite.southSprite = _metalsign[4]

    _name = _metalsign[5]

    _option = subMenu:addOption(_name, nil, MoreBuild.onBuildMetalSign, _sprite, player, _name)

    _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
    _tooltip.description = _metalsign[6] .. _tooltip.description
    _tooltip:setName(_name)
    _tooltip:setTexture(_sprite.sprite)
  end
end

MoreBuild.roadwayMenuBuilder = function(subMenu, player)
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
    Woodwork = MoreBuild.skillLevel.simpleObject
  }

  local _roadwaysData = MoreBuild.getRoadwayData()

  for _, _currentList in pairs(_roadwaysData) do
    _sprite = {}
    _sprite.sprite = _currentList[1]
    _sprite.northSprite = _currentList[2]
    _sprite.eastSprite = _currentList[3]
    _sprite.southSprite = _currentList[4]

    _name = _currentList[5]

    _option = subMenu:addOption(_name, nil, MoreBuild.onBuildSign, _sprite, player, _name)

    _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
    _tooltip.description = _currentList[6] .. _tooltip.description
    _tooltip:setName(_name)
    _tooltip:setTexture(_sprite.sprite)
  end
end

MoreBuild.getRoadwayData = function()
  local _roadwayData = {
    {
      'street_decoration_01_19',
      'street_decoration_01_18',
      'street_decoration_01_21',
      'street_decoration_01_20',
      getText 'ContextMenu_Mailbox',
      getText 'Tooltip_Mailbox'
    },
    {
      'street_decoration_01_12',
      'street_decoration_01_12',
      'street_decoration_01_12',
      'street_decoration_01_12',
      getText 'ContextMenu_Fire_Hydrant',
      getText 'Tooltip_Fire_Hydrant'
    },
    {
      'street_decoration_01_26',
      'street_decoration_01_26',
      'street_decoration_01_26',
      'street_decoration_01_26',
      getText 'ContextMenu_Traffic_Cone',
      getText 'Tooltip_Traffic_Cone'
    },
    {
      'street_decoration_01_27',
      'street_decoration_01_27',
      'street_decoration_01_27',
      'street_decoration_01_27',
      getText 'ContextMenu_Traffic_Cone1',
      getText 'Tooltip_Traffic_Cone1'
    },
    {
      'construction_01_9',
      'construction_01_8',
      'construction_01_8',
      'construction_01_9',
      getText 'ContextMenu_Construction_Horse',
      getText 'Tooltip_Construction_Horse'
    }
  }
  return _roadwayData
end

MoreBuild.getSignData = function()
  local _signData = {
    {
      'location_restaurant_spiffos_02_58',
      'location_restaurant_spiffos_02_59',
      'location_restaurant_spiffos_02_57',
      'location_restaurant_spiffos_02_56',
      getText 'ContextMenu_DriveThru_Arrow',
      getText 'Tooltip_DriveThru_Arrow'
    },
    {
      'location_shop_accessories_genericsigns_01_7',
      'location_shop_accessories_genericsigns_01_6',
      'location_shop_accessories_genericsigns_01_7',
      'location_shop_accessories_genericsigns_01_6',
      getText 'ContextMenu_Sale_Sign',
      getText 'Tooltip_Sale_Sign'
    }
  }
  return _signData
end

MoreBuild.getMetalSignData = function()
  local MetalsignData = {
    {
      'street_decoration_01_1',
      'street_decoration_01_0',
      'street_decoration_01_3',
      'street_decoration_01_2',
      getText 'ContextMenu_StopCar',
      getText 'Tooltip_StopCar'
    },
    {
      'street_decoration_01_5',
      'street_decoration_01_4',
      'street_decoration_01_7',
      'street_decoration_01_6',
      getText 'ContextMenu_Parking_Meter',
      getText 'Tooltip_Parking_Meter'
    }
  }
  return MetalsignData
end

MoreBuild.onBuildSign = function(ignoreThisArgument, sprite, player, name)
  local _sign = ISSimpleFurniture:new(name, sprite.sprite, sprite.northSprite)

  _sign.player = player
  _sign.name = name
  _sign.eastSprite = sprite.eastSprite
  _sign.southSprite = sprite.southSprite

  _sign.modData['need:Base.Plank'] = 1
  _sign.modData['need:Base.Nails'] = 1
  _sign.modData['xp:Woodwork'] = 5

  getCell():setDrag(_sign, player)
end

MoreBuild.onBuildMetalSign = function(ignoreThisArgument, sprite, player, name)
  local metalSign = ISWoodenWall:new(sprite.sprite, sprite.northSprite, nil)

  metalSign.player = player
  metalSign.name = name
  metalSign.canPassThrough = true
  metalSign.isThumpable = false
  metalSign.eastSprite = sprite.eastSprite
  metalSign.southSprite = sprite.southSprite
  metalSign.craftingBank = "BlowTorch"
  metalSign.actionAnim = "BlowTorchMid"

  metalSign.completionSound = 'BuildMetalStructureSmallScrap'

  metalSign.modData['need:Base.MetalBar'] = 2
  metalSign.modData['use:Base.WeldingRods'] = 4
  metalSign.modData['use:Base.BlowTorch'] = 10
  metalSign.modData['xp:MetalWelding'] = 5

  MoreBuild.equipToolPrimary(metalSign, player, 'BlowTorch')

  getCell():setDrag(metalSign, player)
end