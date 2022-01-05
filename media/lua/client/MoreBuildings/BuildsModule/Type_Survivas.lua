if not getMoreBuildInstance then
  require('MoreBuildings/MoreBuilds_Main')
end

local MoreBuild = getMoreBuildInstance()

MoreBuild.SurvivalPostsMenuBuilder = function(subMenu, player)
  local _sprite = nil
  local _option = nil
  local _tooltip = nil
  local _name = ''

  -- Water Well --

  MoreBuild.neededMaterials = {
    {
      Material = 'Nails',
      Amount = 10,
      Text = getItemNameFromFullType('Base.Nails')
    },
    {
      Material = 'Rope',
      Amount = 5,
      Text = getItemNameFromFullType('Base.Rope')
    },
    {
      Material = 'Plank',
      Amount = 5,
      Text = getItemNameFromFullType('Base.Plank')
    },
    {
      Material = 'Gravelbag',
      Amount = 2,
      Text = getItemNameFromFullType('Base.Gravelbag')
    },
    {
      Material = 'BucketEmpty',
      Amount = 1,
      Text = getItemNameFromFullType('Base.BucketEmpty')
    }
  }

  MoreBuild.neededTools = {'Hammer', 'Spade', 'Saw'}

  _sprite = {}
  _sprite.sprite = 'morebuild_01_0'
  _sprite.northSprite = 'morebuild_01_0'
  _sprite.corner = 'morebuild_01_0'

  _name = getText 'ContextMenu_Water_Well'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWaterWell, _sprite, player, _name, _icon)

  _tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.waterwellObject, MoreBuild.skillLevel.none, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_Water_Well' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  -- Fridge --

  MoreBuild.neededMaterials = {
    {
      Material = 'SheetMetal',
      Amount = 4,
      Text = getItemNameFromFullType('Base.SheetMetal')
    },
    {
      Material = 'Screws',
      Amount = 5,
      Text = getItemNameFromFullType('Base.Screws')
    },
    {
      Material = 'ElectricWire',
      Amount = 2,
      Text = getItemNameFromFullType('Radio.ElectricWire')
    },
    {
      Material = 'ElectronicsScrap',
      Amount = 10,
      Text = getItemNameFromFullType('Base.ElectronicsScrap')
    }
  }

  MoreBuild.neededTools = {'Hammer', 'Screwdriver', 'Saw'}

  _sprite = {}
  _sprite.sprite = 'appliances_refrigeration_01_24'
  _sprite.northSprite = 'appliances_refrigeration_01_25'
  _sprite.eastSprite = 'appliances_refrigeration_01_26'
  _sprite.southSprite = 'appliances_refrigeration_01_27'

  _name = MoreBuild.getMoveableDisplayName(_sprite.sprite)
  _icon = 'fridge'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildfridge, _sprite, player, _name, _icon)

  _tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.advancedContainer, MoreBuild.skillLevel.fridgeObject, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_Mini_Fridge' .. _tooltip.description .. MoreBuild.textCanRotate
  _tooltip:setTexture(_sprite.sprite)

  -- Barbecue --

  MoreBuild.neededMaterials = {
    {
      Material = 'SheetMetal',
      Amount = 2,
      Text = getItemNameFromFullType('Base.SheetMetal')
    },
    {
      Material = 'Screws',
      Amount = 3,
      Text = getItemNameFromFullType('Base.Screws')
    },
    {
      Material = 'Plank',
      Amount = 2,
      Text = getItemNameFromFullType('Base.Plank')
    }
  }

  MoreBuild.neededTools = {'Hammer', 'Screwdriver'}

  _sprite = {}
  _sprite.sprite = 'appliances_cooking_01_35'
  _sprite.northSprite = 'appliances_cooking_01_35'
  _sprite.corner = 'appliances_cooking_01_35'

  _name = MoreBuild.getMoveableDisplayName(_sprite.sprite)
  _option = subMenu:addOption(_name, worldobjects, MoreBuild.onBuildBarbecue, _sprite, player, _name, _icon)
  _tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.barbecueObject, MoreBuild.skillLevel.none, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText('Tooltip_Barbecue') .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  -- Generator --

  MoreBuild.neededMaterials = {
    {
      Material = 'ElectricWire',
      Amount = 2,
      Text = getItemNameFromFullType('Radio.ElectricWire')
    },
    {
      Material = 'Aluminum',
      Amount = 10,
      Text = getItemNameFromFullType('Base.Aluminum')
    },
    {
      Material = 'SheetMetal',
      Amount = 4,
      Text = getItemNameFromFullType('Base.SheetMetal')
    },
    {
      Material = 'Screws',
      Amount = 10,
      Text = getItemNameFromFullType('Base.Screws')
    },
    {
      Material = 'ElectronicsScrap',
      Amount = 100,
      Text = getItemNameFromFullType('Base.ElectronicsScrap')
    }
  }

  MoreBuild.neededTools = {'Hammer', 'Screwdriver', 'Saw'}

  _sprite = {}
  _sprite.sprite = 'appliances_misc_01_0'
  _sprite.northSprite = 'appliances_misc_01_0'
  _sprite.corner = 'appliances_misc_01_0'

  _name = getText 'ContextMenu_Fuel_Generator'
  _option = subMenu:addOption(_name, worldobjects, MoreBuild.onBuildGenerator, _sprite, player, _name, _icon)
  _tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.barbecueObject, MoreBuild.skillLevel.generatorObject, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText('Tooltip_Fuel_Generator') .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  -- Fireplace --

  MoreBuild.neededMaterials = {
    {
      Material = 'SheetMetal',
      Amount = 6,
      Text = getItemNameFromFullType('Base.SheetMetal')
    },
    {
      Material = 'Nails',
      Amount = 20,
      Text = getItemNameFromFullType('Base.Nails')
    },
    {
      Material = 'Screws',
      Amount = 10,
      Text = getItemNameFromFullType('Base.Screws')
    }
  }

  MoreBuild.neededTools = {'Hammer', 'Screwdriver'}

  _sprite = {}
  _sprite.sprite = 'appliances_cooking_01_17'
  _sprite.northSprite = 'appliances_cooking_01_16'

  _name = MoreBuild.getMoveableDisplayName(_sprite.sprite)
  _option = subMenu:addOption(_name, worldobjects, MoreBuild.onBuildStove, _sprite, player, _name, _icon)
  _tooltip = MoreBuild.canBuildObject(7, 0, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText('Tooltip_Stove') .. _tooltip.description .. MoreBuild.textCanRotate
  _tooltip:setTexture(_sprite.sprite)

  MoreBuild.neededMaterials = {
    {
      Material = 'Stone',
      Amount = 10,
      Text = getItemNameFromFullType('Base.Stone')
    },
    {
      Material = 'Dirtbag',
      Amount = 1,
      Text = getItemNameFromFullType('Base.Dirtbag')
    },
    {
      Material = 'BucketWaterFull',
      Amount = 1,
      Text = getItemNameFromFullType('Base.BucketWaterFull')
    }
  }

  MoreBuild.neededTools = {'Hammer', 'HandShovel'}

  _sprite = {}
  _sprite.sprite = 'fixtures_fireplaces_01_0'
  _sprite.northSprite = 'fixtures_fireplaces_01_3'

  _name = getText 'ContextMenu_Fireplace'
  _option = subMenu:addOption(_name, worldobjects, MoreBuild.onBuildFireplace, _sprite, player, _name, _icon)
  _tooltip = MoreBuild.canBuildObject(7, 0, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText('Tooltip_Stove') .. _tooltip.description .. MoreBuild.textCanRotate
  _tooltip:setTexture(_sprite.sprite)
end

MoreBuild.onBuildBarbecue = function(ignoreThisArgument, sprite, player, name)
  local _Barbecue = ISBarbecue:new(sprite.sprite, sprite.northSprite, sprite.corner)
  _Barbecue.player = player
  _Barbecue.name = name

  _Barbecue.modData['need:Base.Plank'] = '2'
  _Barbecue.modData['need:Base.SheetMetal'] = '2'
  _Barbecue.modData['need:Base.Screws'] = '3'
  _Barbecue.modData['xp:Woodwork'] = '5'
  getCell():setDrag(_Barbecue, player)
end

MoreBuild.onBuildGenerator = function(ignoreThisArgument, sprite, player, name)
  local _Generator = ISGenerator:new(sprite.sprite, sprite.northSprite, sprite.corner)
  _Generator.player = player
  _Generator.name = name

  _Generator.modData['need:Radio.ElectricWire'] = '2'
  _Generator.modData['need:Base.Aluminum'] = '10'
  _Generator.modData['need:Base.SheetMetal'] = '4'
  _Generator.modData['need:Base.Screws'] = '10'
  _Generator.modData['need:Base.ElectronicsScrap'] = '100'
  _Generator.modData['xp:Woodwork'] = '10'
  _Generator.modData['xp:Electricity'] = '50'
  getCell():setDrag(_Generator, player)
end

MoreBuild.onBuildWaterWell = function(ignoreThisArgument, sprite, player, name)
  local _WaterWell = ISWaterWell:new(sprite.sprite, sprite.northSprite, sprite.corner)
  _WaterWell.player = player
  _WaterWell.name = name

  _WaterWell.modData['need:Base.Plank'] = '20'
  _WaterWell.modData['need:Base.Nails'] = '10'
  _WaterWell.modData['need:Base.Rope'] = '5'
  _WaterWell.modData['need:Base.Plank'] = '5'
  _WaterWell.modData['need:Base.Gravelbag'] = '2'
  _WaterWell.modData['need:Base.BucketEmpty'] = '1'
  _WaterWell.modData['xp:Woodwork'] = '50'
  _WaterWell.modData['IsWaterWell'] = true
  getCell():setDrag(_WaterWell, player)
end

MoreBuild.onBuildfridge = function(ignoreThisArgument, sprite, player, name, icon)
  local _fridge = ISWoodenContainer:new(sprite.sprite, sprite.northSprite)

  _fridge.renderFloorHelper = false
  _fridge.canBeAlwaysPlaced = false
  _fridge.canBeLockedByPadlock = true
  _fridge.player = player
  _fridge.name = name

  if sprite.eastSprite then
    _fridge:setEastSprite(sprite.eastSprite)
  end

  if sprite.southSprite then
    _fridge:setSouthSprite(sprite.southSprite)
  end

  _fridge.modData['need:Base.SheetMetal'] = '4'
  _fridge.modData['need:Base.Screws'] = '5'
  _fridge.modData['need:Radio.ElectricWire'] = '2'
  _fridge.modData['need:Base.ElectronicsScrap'] = '10'
  _fridge.modData['xp:Woodwork'] = '30'
  _fridge.modData['xp:Electricity'] = '5'

  MoreBuild.equipToolPrimary(_fridge, player, 'Screwdriver')

  function _fridge:getHealth()
    self.javaObject:getContainer():setType(icon)
    return MoreBuild.healthLevel.metalContainer + buildUtil.getWoodHealth(self)
  end

  getCell():setDrag(_fridge, player)
end

MoreBuild.onBuildStove = function(ignoreThisArgument, sprite, player, name)
  local _stove = ISStove:new(sprite.sprite, sprite.northSprite, getSpecificPlayer(player))

  _stove.player = player
  _stove.name = name

  _stove.modData['need:Base.SheetMetal'] = '6'
  _stove.modData['need:Base.Nails'] = '20'
  _stove.modData['need:Base.Screws'] = '10'
  _stove.modData['xp:Woodwork'] = '15'

  getCell():setDrag(_stove, player)
end

MoreBuild.onBuildFireplace = function(ignoreThisArgument, sprite, player, name)
  local _fireplace = ISStove:new(sprite.sprite, sprite.northSprite, getSpecificPlayer(player))

  _fireplace.player = player
  _fireplace.name = name

  _fireplace.modData['need:Base.Stone'] = '10'
  _fireplace.modData['use:Base.Dirtbag'] = '4'
  _fireplace.modData['use:Base.BucketWaterFull'] = '25'
  _fireplace.modData['xp:Woodwork'] = '15'

  getCell():setDrag(_fireplace, player)
end

MoreBuild.doWaterWellInfo = function(player, context, worldobjects)
  local WellWater

  for _, v in ipairs(worldobjects) do
    local modData = v:getModData()

    if modData['IsWaterWell'] then
      WellWaterAmount = v:getWaterAmount()
      objx = v:getX()
      objy = v:getY()
      WellWater = v
    end
  end

  if WellWater and getSpecificPlayer(player):DistToSquared(objx + 0.5, objy + 0.5) < 2 * 2 then
    local _option = context:addOption(getText('ContextMenu_Water_Well'), worldobjects, nil)
    _option.toolTip = ISToolTip:new()
    _option.toolTip:initialise()
    _option.toolTip:setVisible(false)
    _option.toolTip:setName(getText('ContextMenu_Water_Well'))
    _option.toolTip.description = getText('Tooltip_WaterAmount') .. WellWaterAmount
    _option.toolTip:setTexture('morebuild_01_0')
  end
end