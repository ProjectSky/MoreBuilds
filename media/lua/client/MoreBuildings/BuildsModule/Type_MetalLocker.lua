if not getMoreBuildInstance then
  require('MoreBuildings/MoreBuilds_Main')
end

local MoreBuild = getMoreBuildInstance()

MoreBuild.metalLockersMenuBuilder = function(subMenu, player)
  local _sprite
  local _option
  local _tooltip
  local _name = ''

  MoreBuild.neededMaterials = {
    {
      Material = 'Base.SheetMetal',
      Amount = 2
    },
    {
      Material = 'Base.Screws',
      Amount = 6
    },
    {
      Material = 'Base.Hinge',
      Amount = 2
    }
  }

  MoreBuild.neededTools = {'Screwdriver'}

  local needSkills = {
    Woodwork = MoreBuild.skillLevel.complexFurniture
  }

  _sprite = {}
  _sprite.sprite = 'furniture_storage_02_9'
  _sprite.northSprite = 'furniture_storage_02_8'
  _sprite.southSprite = 'furniture_storage_02_10'
  _sprite.eastSprite = 'furniture_storage_02_11'

  _name = getText 'ContextMenu_Gun_Locker'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildMetalLocker, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_Gun_Locker' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'furniture_storage_02_1'
  _sprite.northSprite = 'furniture_storage_02_0'
  _sprite.southSprite = 'furniture_storage_02_2'
  _sprite.eastSprite = 'furniture_storage_02_3'

  _name = getText 'ContextMenu_MetalLocker_Menu'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildMetalLocker, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_Metal_Locker' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'location_business_bank_01_43'
  _sprite.northSprite = 'location_business_bank_01_42'
  _sprite.southSprite = 'location_business_bank_01_44'
  _sprite.eastSprite = 'location_business_bank_01_45'

  _name = getText 'ContextMenu_Lock_Boxes'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildMetalLocker, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_Lock_Boxes' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'furniture_storage_02_4'
  _sprite.northSprite = 'furniture_storage_02_5'
  _sprite.southSprite = 'furniture_storage_02_7'
  _sprite.eastSprite = 'furniture_storage_02_6'

  _name = getText 'ContextMenu_Blue_Lockers'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildHangingMetalLocker, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_Blue_Lockers' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'furniture_storage_02_12'
  _sprite.northSprite = 'furniture_storage_02_13'
  _sprite.southSprite = 'furniture_storage_02_15'
  _sprite.eastSprite = 'furniture_storage_02_14'

  _name = getText 'ContextMenu_Yellow_Lockers'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildHangingMetalLocker, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_Yellow_Lockers' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'location_military_generic_01_23'
  _sprite.northSprite = 'location_military_generic_01_22'
  _sprite.southSprite = 'location_military_generic_01_31'
  _sprite.eastSprite = 'location_military_generic_01_30'

  _name = getText 'ContextMenu_Military_Lockers'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildHangingMetalLocker, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_Military_Lockers' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)
end

MoreBuild.onBuildMetalLocker = function(ignoreThisArgument, sprite, player, name)
  local _locker = ISSimpleFurniture:new(name, sprite.sprite, sprite.northSprite)

  _locker.canBeAlwaysPlaced = true
  _locker.isContainer = true
  _locker.canBeLockedByPadlock = true
  _locker.containerType = 'shelves'
  _locker:setEastSprite(sprite.eastSprite)
  _locker:setSouthSprite(sprite.southSprite)
  _locker.player = player
  _locker.name = name

  _locker.modData['need:Base.SheetMetal'] = 2
  _locker.modData['need:Base.Screws'] = 6
  _locker.modData['need:Base.Hinge'] = 2
  _locker.modData['xp:Woodwork'] = 5

  function _locker:getHealth()
    self.javaObject:getContainer():setType('vendingsnack')
    return MoreBuild.healthLevel.metalContainer + buildUtil.getWoodHealth(self)
  end

  MoreBuild.equipToolPrimary(_locker, player, 'Screwdriver')

  getCell():setDrag(_locker, player)
end

MoreBuild.onBuildHangingMetalLocker = function(ignoreThisArgument, sprite, player, name)
  local _locker = ISSimpleFurniture:new(name, sprite.sprite, sprite.northSprite)

  _locker.canBeAlwaysPlaced = true
  _locker.isContainer = true
  _locker.canBeLockedByPadlock = true
  _locker.containerType = 'shelves'
  _locker:setEastSprite(sprite.eastSprite)
  _locker:setSouthSprite(sprite.southSprite)
  _locker.player = player
  _locker.name = name

  _locker.modData['need:Base.SheetMetal'] = 2
  _locker.modData['need:Base.Screws'] = 6
  _locker.modData['need:Base.Hinge'] = 2
  _locker.modData['xp:Woodwork'] = 5

  function _locker:getHealth()
    self.javaObject:getContainer():setType('filingcabinet')
    return MoreBuild.healthLevel.metalContainer + buildUtil.getWoodHealth(self)
  end

  getCell():setDrag(_locker, player)
end