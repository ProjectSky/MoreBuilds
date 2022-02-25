if not getMoreBuildInstance then
  require('MoreBuildings/MoreBuilds_Main')
end

local MoreBuild = getMoreBuildInstance()

MoreBuild.windowFramesMenuBuilder = function(subMenu, player)
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
  _sprite.sprite = 'location_restaurant_pileocrepe_01_8'
  _sprite.northSprite = 'location_restaurant_pileocrepe_01_9'
  _sprite.corner = 'location_restaurant_pileocrepe_01_3'

  _name = getText 'ContextMenu_Light_BrownWood_WindowFrame'

  _option = subMenu[getText 'ContextMenu_Light_BrownWood']:addOption(_name, nil, MoreBuild.onBuildWoodenWindowFrame, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textWindowFrameDescription .. _tooltip.description

  if MoreBuild.playerCanPlaster then
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
  else
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
  end

  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'location_shop_bargNclothes_01_32'
  _sprite.northSprite = 'location_shop_bargNclothes_01_33'
  _sprite.corner = 'location_shop_bargNclothes_01_27'

  _name = getText 'ContextMenu_DarkBrown_Wood _WindowFrame'

  _option = subMenu[getText 'ContextMenu_Dark_BrownWood']:addOption(_name, nil, MoreBuild.onBuildWoodenWindowFrame, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textWindowFrameDescription .. _tooltip.description

  if MoreBuild.playerCanPlaster then
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
  else
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
  end

  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'walls_garage_02_24'
  _sprite.northSprite = 'walls_garage_02_25'
  _sprite.corner = 'walls_garage_02_19'

  _name = getText 'ContextMenu_Gray_Plaster_WindowFram'

  _option = subMenu[getText 'ContextMenu_Gray_Plaster']:addOption(_name, nil, MoreBuild.onBuildWoodenWindowFrame, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textWindowFrameDescription .. _tooltip.description

  if MoreBuild.playerCanPlaster then
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
  else
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
  end

  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'walls_exterior_wooden_01_36'
  _sprite.northSprite = 'walls_exterior_wooden_01_37'
  _sprite.corner = 'walls_exterior_wooden_01_31'

  _name = getText 'ContextMenu_Gray_Wood_WindowFrame'

  _option = subMenu[getText 'ContextMenu_Gray_Wood']:addOption(_name, nil, MoreBuild.onBuildWoodenWindowFrame, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textWindowFrameDescription .. _tooltip.description

  if MoreBuild.playerCanPlaster then
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
  else
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
  end

  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'walls_exterior_wooden_01_8'
  _sprite.northSprite = 'walls_exterior_wooden_01_9'
  _sprite.corner = 'walls_exterior_wooden_01_3'

  _name = getText 'ContextMenu_Red_Barnwood_WindowFrame'

  _option = subMenu[getText 'ContextMenu_Red_Barnwood']:addOption(_name, nil, MoreBuild.onBuildWoodenWindowFrame, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textWindowFrameDescription .. _tooltip.description

  if MoreBuild.playerCanPlaster then
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
  else
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
  end

  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'location_shop_mall_01_8'
  _sprite.northSprite = 'location_shop_mall_01_9'
  _sprite.corner = 'location_shop_mall_01_3'

  _name = getText 'ContextMenu_White_Plaster_WindowFrame'

  _option = subMenu[getText 'ContextMenu_White_Plaster']:addOption(_name, nil, MoreBuild.onBuildWoodenWindowFrame, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textWindowFrameDescription .. _tooltip.description

  if MoreBuild.playerCanPlaster then
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
  else
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
  end

  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'walls_exterior_wooden_02_8'
  _sprite.northSprite = 'walls_exterior_wooden_02_9'
  _sprite.corner = 'walls_exterior_wooden_02_3'

  _name = getText 'ContextMenu_White_Wood_WindowFrame'

  _option = subMenu[getText 'ContextMenu_White_Wood']:addOption(_name, nil, MoreBuild.onBuildWoodenWindowFrame, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textWindowFrameDescription .. _tooltip.description

  if MoreBuild.playerCanPlaster then
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
  else
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
  end

  _tooltip:setTexture(_sprite.sprite)

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
    Woodwork = MoreBuild.skillLevel.stoneArchitecture
  }

  _sprite = {}
  _sprite.sprite = 'walls_commercial_03_8'
  _sprite.northSprite = 'walls_commercial_03_9'
  _sprite.corner = 'walls_commercial_03_3'

  _name = getText 'ContextMenu_Brown_Cinder_Block_DoorWindow'

  _option = subMenu[getText 'ContextMenu_Brown_Cinder_Block']:addOption(_name, nil, MoreBuild.onBuildStoneWindowFrame, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_BrownCinder_Block_DoorWindow' .. _tooltip.description

  if MoreBuild.playerCanPlaster then
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
  else
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
  end

  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'walls_commercial_03_40'
  _sprite.northSprite = 'walls_commercial_03_41'
  _sprite.corner = 'walls_commercial_03_35'

  _name = getText 'ContextMenu_Gray_Cinder_Block_WindowFrame'

  _option = subMenu[getText 'ContextMenu_Gray_Cinder_Block']:addOption(_name, nil, MoreBuild.onBuildStoneWindowFrame, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_GrayCinder_Block_WindowFrame' .. _tooltip.description

  if MoreBuild.playerCanPlaster then
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
  else
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
  end

  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'walls_commercial_01_56'
  _sprite.northSprite = 'walls_commercial_01_57'
  _sprite.corner = 'walls_commercial_01_51'

  _name = getText 'ContextMenu_White_Cinder_Block_WindowFrame'

  _option = subMenu[getText 'ContextMenu_White_CinderBlock']:addOption(_name, nil, MoreBuild.onBuildStoneWindowFrame, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_WhiteCinder_Block_WindowFrame' .. _tooltip.description

  if MoreBuild.playerCanPlaster then
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
  else
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
  end

  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'walls_exterior_house_01_12'
  _sprite.northSprite = 'walls_exterior_house_01_13'
  _sprite.corner = 'walls_exterior_house_01_7'

  _name = getText 'ContextMenu_RedBrick_WindowFrame'

  _option = subMenu[getText 'ContextMenu_RedBrick_Wall']:addOption(_name, nil, MoreBuild.onBuildStoneWindowFrame, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_RedBrick_WindowFrame' .. _tooltip.description

  if MoreBuild.playerCanPlaster then
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
  else
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
  end

  _tooltip:setTexture(_sprite.sprite)
end

MoreBuild.onBuildWoodenWindowFrame = function(ignoreThisArgument, sprite, player, name)
  local _windowFrame = ISWoodenWall:new(sprite.sprite, sprite.northSprite, sprite.corner)

  _windowFrame.canBePlastered = MoreBuild.playerCanPlaster
  _windowFrame.hoppable = true
  _windowFrame.isThumpable = false
  _windowFrame.player = player
  _windowFrame.name = name

  _windowFrame.modData['need:Base.Plank'] = 4
  _windowFrame.modData['need:Base.Nails'] = 4
  _windowFrame.modData['xp:Woodwork'] = 5

  getCell():setDrag(_windowFrame, player)
end

MoreBuild.onBuildStoneWindowFrame = function(ignoreThisArgument, sprite, player, name)
  local _windowFrame = ISWoodenWall:new(sprite.sprite, sprite.northSprite, sprite.corner)

  _windowFrame.canBePlastered = MoreBuild.playerCanPlaster
  _windowFrame.hoppable = true
  _windowFrame.isThumpable = false
  _windowFrame.player = player
  _windowFrame.name = name

  _windowFrame.modData['need:Base.Plank'] = 4
  _windowFrame.modData['need:Base.Nails'] = 4
  _windowFrame.modData['xp:Woodwork'] = 5

  function _windowFrame:getHealth()
    return MoreBuild.healthLevel.stoneWall + buildUtil.getWoodHealth(self)
  end

  MoreBuild.equipToolPrimary(_windowFrame, player, 'Hammer')

  getCell():setDrag(_windowFrame, player)
end