if not getMoreBuildInstance then
  require('MoreBuildings/MoreBuilds_Main')
end

local MoreBuild = getMoreBuildInstance()

MoreBuild.doorFramesMenuBuilder = function(subMenu, player)
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
    Woodwork = MoreBuild.skillLevel.wallObject
  }

  _sprite = {}
  _sprite.sprite = 'location_restaurant_pileocrepe_01_10'
  _sprite.northSprite = 'location_restaurant_pileocrepe_01_11'
  _sprite.corner = 'location_restaurant_pileocrepe_01_3'

  _name = getText 'ContextMenu_LightBrownWood_DoorFrame'

  _option = subMenu[getText 'ContextMenu_Light_BrownWood']:addOption(_name, nil, MoreBuild.onBuildWoodenDoorFrame, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textDoorFrameDescription .. _tooltip.description

  if MoreBuild.playerCanPlaster then
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
  else
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
  end

  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'location_shop_bargNclothes_01_34'
  _sprite.northSprite = 'location_shop_bargNclothes_01_35'
  _sprite.corner = 'location_shop_bargNclothes_01_27'

  _name = getText 'ContextMenu_DarkBrown_WoodDoorFrame'

  _option = subMenu[getText 'ContextMenu_Dark_BrownWood']:addOption(_name, nil, MoreBuild.onBuildWoodenDoorFrame, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textDoorFrameDescription .. _tooltip.description

  if MoreBuild.playerCanPlaster then
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
  else
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
  end

  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'walls_garage_02_26'
  _sprite.northSprite = 'walls_garage_02_27'
  _sprite.corner = 'walls_garage_02_19'

  _name = getText 'ContextMenu_GrayPlaster_DoorFrame'

  _option = subMenu[getText 'ContextMenu_Gray_Plaster']:addOption(_name, nil, MoreBuild.onBuildWoodenDoorFrame, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textDoorFrameDescription .. _tooltip.description

  if MoreBuild.playerCanPlaster then
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
  else
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
  end

  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'walls_exterior_wooden_01_38'
  _sprite.northSprite = 'walls_exterior_wooden_01_39'
  _sprite.corner = 'walls_exterior_wooden_01_31'

  _name = getText 'ContextMenu_GrayWood_DoorFrame'

  _option = subMenu[getText 'ContextMenu_Gray_Wood']:addOption(_name, nil, MoreBuild.onBuildWoodenDoorFrame, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textDoorFrameDescription .. _tooltip.description

  if MoreBuild.playerCanPlaster then
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
  else
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
  end

  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'walls_exterior_wooden_01_10'
  _sprite.northSprite = 'walls_exterior_wooden_01_11'
  _sprite.corner = 'walls_exterior_wooden_01_3'

  _name = getText 'ContextMenu_RedBarnwood_DoorFrame'

  _option = subMenu[getText 'ContextMenu_Red_Barnwood']:addOption(_name, nil, MoreBuild.onBuildWoodenDoorFrame, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textDoorFrameDescription .. _tooltip.description

  if MoreBuild.playerCanPlaster then
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
  else
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
  end

  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'location_shop_mall_01_10'
  _sprite.northSprite = 'location_shop_mall_01_11'
  _sprite.corner = 'location_shop_mall_01_3'

  _name = getText 'ContextMenu_WhitePlaster_DoorFrame'

  _option = subMenu[getText 'ContextMenu_White_Plaster']:addOption(_name, nil, MoreBuild.onBuildWoodenDoorFrame, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textDoorFrameDescription .. _tooltip.description

  if MoreBuild.playerCanPlaster then
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
  else
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
  end

  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'walls_exterior_wooden_02_10'
  _sprite.northSprite = 'walls_exterior_wooden_02_11'
  _sprite.corner = 'walls_exterior_wooden_02_3'

  _name = getText 'ContextMenu_WhiteWood_DoorFrame'

  _option = subMenu[getText 'ContextMenu_White_Wood']:addOption(_name, nil, MoreBuild.onBuildWoodenDoorFrame, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textDoorFrameDescription .. _tooltip.description

  if MoreBuild.playerCanPlaster then
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
  else
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
  end

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
    Woodwork = MoreBuild.skillLevel.stoneArchitecture
  }

  _sprite = {}
  _sprite.sprite = 'walls_commercial_03_10'
  _sprite.northSprite = 'walls_commercial_03_11'
  _sprite.corner = 'walls_commercial_03_3'

  _name = getText 'ContextMenu_BrownCinder_Block_DoorFrame'

  _option = subMenu[getText 'ContextMenu_Brown_Cinder_Block']:addOption(_name, nil, MoreBuild.onBuildStoneDoorFrame, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)

  _tooltip.description = getText 'Tooltip_BrownCinder_Block_DoorFrame' .. _tooltip.description

  if MoreBuild.playerCanPlaster then
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
  else
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
  end

  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'walls_commercial_03_42'
  _sprite.northSprite = 'walls_commercial_03_43'
  _sprite.corner = 'walls_commercial_03_35'

  _name = getText 'ContextMenu_GrayCinder_Block_DoorFrame'

  _option = subMenu[getText 'ContextMenu_Gray_Cinder_Block']:addOption(_name, nil, MoreBuild.onBuildStoneDoorFrame, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_GrayCinder_Block_DoorFrame' .. _tooltip.description

  if MoreBuild.playerCanPlaster then
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
  else
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
  end

  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'walls_commercial_01_58'
  _sprite.northSprite = 'walls_commercial_01_59'
  _sprite.corner = 'walls_commercial_01_51'

  _name = getText 'ContextMenu_WhiteCinder_Block_DoorFrame'

  _option = subMenu[getText 'ContextMenu_White_CinderBlock']:addOption(_name, nil, MoreBuild.onBuildStoneDoorFrame, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_WhiteCinder_Block_DoorFrame' .. _tooltip.description

  if MoreBuild.playerCanPlaster then
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
  else
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
  end

  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'walls_exterior_house_01_14'
  _sprite.northSprite = 'walls_exterior_house_01_15'
  _sprite.corner = 'walls_exterior_house_01_7'

  _name = getText 'ContextMenu_RedBrick_DoorFrame'

  _option = subMenu[getText 'ContextMenu_RedBrick_Wall']:addOption(_name, nil, MoreBuild.onBuildStoneDoorFrame, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_RedBrick_DoorFrame' .. _tooltip.description

  if MoreBuild.playerCanPlaster then
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
  else
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
  end

  _tooltip:setTexture(_sprite.sprite)
end

MoreBuild.onBuildWoodenDoorFrame = function(ignoreThisArgument, sprite, player, name)
  local _doorFrame = ISWoodenDoorFrame:new(sprite.sprite, sprite.northSprite, sprite.corner)

  _doorFrame.canBePlastered = MoreBuild.playerCanPlaster
  _doorFrame.modData['wallType'] = 'doorframe'
  _doorFrame.player = player
  _doorFrame.name = name

  _doorFrame.modData['need:Base.Plank'] = 4
  _doorFrame.modData['need:Base.Nails'] = 4
  _doorFrame.modData['xp:Woodwork'] = 5

  getCell():setDrag(_doorFrame, player)
end

MoreBuild.onBuildLowDoorFrame = function(ignoreThisArgument, sprite, player, name)
  local _LowdoorFrame = ISWoodenDoorFrame:new(sprite.sprite, sprite.northSprite, sprite.corner)

  _LowdoorFrame.canBePlastered = MoreBuild.playerCanPlaster
  _LowdoorFrame.modData['wallType'] = 'doorframe'
  _LowdoorFrame.player = player
  _LowdoorFrame.name = name

  _LowdoorFrame.modData['need:Base.Plank'] = 1
  _LowdoorFrame.modData['need:Base.Nails'] = 1
  _LowdoorFrame.modData['xp:Woodwork'] = 5

  getCell():setDrag(_LowdoorFrame, player)
end

MoreBuild.onBuildStoneDoorFrame = function(ignoreThisArgument, sprite, player, name)
  local _doorFrame = ISWoodenDoorFrame:new(sprite.sprite, sprite.northSprite, sprite.corner)

  _doorFrame.canBePlastered = MoreBuild.playerCanPlaster
  _doorFrame.modData['wallType'] = 'doorframe'
  _doorFrame.player = player
  _doorFrame.name = name

  _doorFrame.modData['need:Base.Plank'] = 2
  _doorFrame.modData['need:Base.Nails'] = 3
  _doorFrame.modData['xp:Woodwork'] = 5

  function _doorFrame:getHealth()
    return MoreBuild.healthLevel.stoneWall + buildUtil.getWoodHealth(self)
  end

  MoreBuild.equipToolPrimary(_doorFrame, player, 'Hammer')

  getCell():setDrag(_doorFrame, player)
end