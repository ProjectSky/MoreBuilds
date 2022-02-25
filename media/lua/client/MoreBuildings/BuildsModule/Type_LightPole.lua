if not getMoreBuildInstance then
  require('MoreBuildings/MoreBuilds_Main')
end

local MoreBuild = getMoreBuildInstance()

MoreBuild.lightPostMenuBuilder = function(subMenu, player)
  local _sprite
  local _option
  local _tooltip
  local _name = ''

  local _lightPoleData = MoreBuild.getLightPoleData()

  MoreBuild.neededMaterials = {
    {
      Material = 'Base.ScrapMetal',
      Amount = 10
    },
    {
      Material = 'Base.Screws',
      Amount = 4
    },
    {
      Material = 'Base.LightBulb',
      Amount = 1
    },
    {
      Material = 'Radio.ElectricWire',
      Amount = 1
    },
    {
      Material = 'Base.ElectronicsScrap',
      Amount = 5
    },
    {
      Material = 'Base.BlowTorch',
      Amount = 1
    }
  }

  MoreBuild.neededTools = {'Hammer', 'Screwdriver'}

  local needSkills = {
    Woodwork = MoreBuild.skillLevel.lighting,
    Electricity = MoreBuild.skillLevel.lightingObject
  }

  for _, _currentList in pairs(_lightPoleData) do
    _sprite = {}
    _sprite.sprite = _currentList[1]

    _name = _currentList[2]

    _option = subMenu:addOption(_name, nil, MoreBuild.onBuildLightPole, _sprite, player, _name)

    _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
    _tooltip.description = MoreBuild.textLightPoleDescription .. _tooltip.description
    _tooltip:setName(_name)
    _tooltip:setTexture(_sprite.sprite)
  end

  MoreBuild.neededMaterials = {
    {
      Material = 'Base.ScrapMetal',
      Amount = 15
    },
    {
      Material = 'Base.Screws',
      Amount = 5
    },
    {
      Material = 'Base.LightBulb',
      Amount = 2
    },
    {
      Material = 'Radio.ElectricWire',
      Amount = 1
    },
    {
      Material = 'Base.ElectronicsScrap',
      Amount = 5
    },
    {
      Material = 'Base.BlowTorch',
      Amount = 1
    }
  }

  _sprite = {}
  _sprite.sprite = 'lighting_outdoor_01_49'
  _sprite.northSprite = 'lighting_outdoor_01_48'
  _sprite.southSprite = 'lighting_outdoor_01_50'
  _sprite.eastSprite = 'lighting_outdoor_01_51'

  _name = getText 'ContextMenu_Emergency_Lamp'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildOutdoorLight, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip.description = getText "Tooltip_Emergency_Lamp" .. _tooltip.description
  _tooltip:setName(_name)
  _tooltip:setTexture(_sprite.sprite)
end

MoreBuild.getLightPoleData = function()
  local _lightPoleData = {
    {'lighting_outdoor_01_0', getText 'ContextMenu_Light_Pole'},
    {'lighting_outdoor_01_1', getText 'ContextMenu_Light_Pole'},
    {'lighting_outdoor_01_2', getText 'ContextMenu_Light_Pole'}
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

  _lightPole.fuel = 'Base.Battery'
  _lightPole.baseItem = 'Base.LightBulb'
  _lightPole.radius = 10

  _lightPole.modData['need:Base.ScrapMetal'] = 10
  _lightPole.modData['need:Base.Screws'] = 4
  _lightPole.modData['need:Base.LightBulb'] = 1
  _lightPole.modData['need:Radio.ElectricWire'] = 1
  _lightPole.modData['need:Base.ElectronicsScrap'] = 5
  _lightPole.modData['use:Base.BlowTorch'] = 10
  _lightPole.modData['xp:Woodwork'] = 5
  _lightPole.modData['xp:Electricity'] = 5
  _lightPole.modData['IsLighting'] = true

  getCell():setDrag(_lightPole, player)
end

MoreBuild.onBuildOutdoorLight = function(ignoreThisArgument, sprite, player, name)
  local _outdoorLight = ISLightSource:new(sprite.sprite, sprite.northSprite, getSpecificPlayer(player))

  _outdoorLight.offsetX = 0
  _outdoorLight.offsetY = 0
  _outdoorLight.player = player
  _outdoorLight.name = name

  if sprite.eastSprite then
    _outdoorLight:setEastSprite(sprite.eastSprite)
  end

  if sprite.southSprite then
    _outdoorLight:setSouthSprite(sprite.southSprite)
  end

  _outdoorLight.fuel = 'Base.Battery'
  _outdoorLight.baseItem = 'Base.LightBulb'
  _outdoorLight.radius = 20

  _outdoorLight.modData['need:Base.ScrapMetal'] = 15
  _outdoorLight.modData['need:Base.Screws'] = 5
  _outdoorLight.modData['need:Base.LightBulb'] = 2
  _outdoorLight.modData['need:Radio.ElectricWire'] = 1
  _outdoorLight.modData['need:Base.ElectronicsScrap'] = 5
  _outdoorLight.modData['use:Base.BlowTorch'] = 10
  _outdoorLight.modData['xp:Woodwork'] = 5
  _outdoorLight.modData['xp:Electricity'] = 10
  _outdoorLight.modData['IsLighting'] = true

  getCell():setDrag(_outdoorLight, player)
end