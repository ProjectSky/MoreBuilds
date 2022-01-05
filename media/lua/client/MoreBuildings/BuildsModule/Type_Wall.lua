if not getMoreBuildInstance then
  require('MoreBuildings/MoreBuilds_Main')
end

local MoreBuild = getMoreBuildInstance()

MoreBuild.wallsMenuBuilder = function(subMenu, player)
  local _sprite
  local _option
  local _tooltip
  local _name = ''

  MoreBuild.neededMaterials = {
    {
      Material = 'Plank',
      Amount = 3,
      Text = getItemNameFromFullType('Base.Plank')
    },
    {
      Material = 'Nails',
      Amount = 3,
      Text = getItemNameFromFullType('Base.Nails')
    }
  }

  MoreBuild.neededTools = {'Hammer'}

  _sprite = {}
  _sprite.sprite = 'location_restaurant_pileocrepe_01_0'
  _sprite.northSprite = 'location_restaurant_pileocrepe_01_1'
  _sprite.corner = 'location_restaurant_pileocrepe_01_3'

  _name = getText 'ContextMenu_Light_Brown_WoodWall'

  _option = subMenu[getText 'ContextMenu_Light_BrownWood']:addOption(_name, nil, MoreBuild.onBuildWoodenWall, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.skillLevel.none, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textWallDescription .. _tooltip.description

  if MoreBuild.playerCanPlaster then
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
  else
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
  end

  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'location_shop_bargNclothes_01_24'
  _sprite.northSprite = 'location_shop_bargNclothes_01_25'
  _sprite.corner = 'location_shop_bargNclothes_01_27'

  _name = getText 'ContextMenu_Dark_BrownWoodWal'

  _option = subMenu[getText 'ContextMenu_Dark_BrownWood']:addOption(_name, nil, MoreBuild.onBuildWoodenWall, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.skillLevel.none, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textWallDescription .. _tooltip.description

  if MoreBuild.playerCanPlaster then
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
  else
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
  end

  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'walls_garage_02_16'
  _sprite.northSprite = 'walls_garage_02_17'
  _sprite.corner = 'walls_garage_02_19'

  _name = getText 'ContextMenu_Gray_Plaster_Wall'

  _option = subMenu[getText 'ContextMenu_Gray_Plaster']:addOption(_name, nil, MoreBuild.onBuildWoodenWall, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.skillLevel.none, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textWallDescription .. _tooltip.description

  if MoreBuild.playerCanPlaster then
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
  else
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
  end

  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'walls_exterior_wooden_01_28'
  _sprite.northSprite = 'walls_exterior_wooden_01_29'
  _sprite.corner = 'walls_exterior_wooden_01_31'

  _name = getText 'ContextMenu_Gray_Wood'

  _option = subMenu[getText 'ContextMenu_Gray_Wood']:addOption(_name, nil, MoreBuild.onBuildWoodenWall, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.skillLevel.none, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textWallDescription .. _tooltip.description

  if MoreBuild.playerCanPlaster then
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
  else
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
  end

  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'walls_exterior_wooden_01_0'
  _sprite.northSprite = 'walls_exterior_wooden_01_1'
  _sprite.corner = 'walls_exterior_wooden_01_3'

  _name = getText 'ContextMenu_Red_Barnwood'

  _option = subMenu[getText 'ContextMenu_Red_Barnwood']:addOption(_name, nil, MoreBuild.onBuildWoodenWall, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.skillLevel.none, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textWallDescription .. _tooltip.description

  if MoreBuild.playerCanPlaster then
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
  else
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
  end

  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'location_shop_mall_01_0'
  _sprite.northSprite = 'location_shop_mall_01_1'
  _sprite.corner = 'location_shop_mall_01_3'

  _name = getText 'ContextMenu_White_Plaster'

  _option = subMenu[getText 'ContextMenu_White_Plaster']:addOption(_name, nil, MoreBuild.onBuildWoodenWall, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.skillLevel.none, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textWallDescription .. _tooltip.description

  if MoreBuild.playerCanPlaster then
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
  else
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
  end

  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'walls_exterior_wooden_02_0'
  _sprite.northSprite = 'walls_exterior_wooden_02_1'
  _sprite.corner = 'walls_exterior_wooden_02_3'

  _name = getText 'ContextMenu_White_Wood'

  _option = subMenu[getText 'ContextMenu_White_Wood']:addOption(_name, nil, MoreBuild.onBuildWoodenWall, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.wallObject, MoreBuild.skillLevel.none, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textWallDescription .. _tooltip.description

  if MoreBuild.playerCanPlaster then
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
  else
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
  end

  _tooltip:setTexture(_sprite.sprite)

  MoreBuild.neededMaterials = {
    {
      Material = 'Plank',
      Amount = 6,
      Text = getItemNameFromFullType('Base.Plank')
    },
    {
      Material = 'Nails',
      Amount = 3,
      Text = getItemNameFromFullType('Base.Nails')
    }
  }

  MoreBuild.neededTools = {'Hammer'}

  _sprite = {}
  _sprite.sprite = 'walls_commercial_03_0'
  _sprite.northSprite = 'walls_commercial_03_1'
  _sprite.corner = 'walls_commercial_03_3'

  _name = getText 'ContextMenu_Brown_Cinder_Block'

  _option = subMenu[getText 'ContextMenu_Brown_Cinder_Block']:addOption(_name, nil, MoreBuild.onBuildStoneWall, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.stoneArchitecture, MoreBuild.skillLevel.none, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_BrownCinder_Block' .. _tooltip.description

  if MoreBuild.playerCanPlaster then
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
  else
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
  end

  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'walls_commercial_03_32'
  _sprite.northSprite = 'walls_commercial_03_33'
  _sprite.corner = 'walls_commercial_03_35'

  _name = getText 'ContextMenu_Gray_Cinder_Block'

  _option = subMenu[getText 'ContextMenu_Gray_Cinder_Block']:addOption(_name, nil, MoreBuild.onBuildStoneWall, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.stoneArchitecture, MoreBuild.skillLevel.none, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_GrayCinder_Block' .. _tooltip.description

  if MoreBuild.playerCanPlaster then
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
  else
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
  end

  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'walls_commercial_01_48'
  _sprite.northSprite = 'walls_commercial_01_49'
  _sprite.corner = 'walls_commercial_01_51'

  _name = getText 'ContextMenu_White_CinderBlock'

  _option = subMenu[getText 'ContextMenu_White_CinderBlock']:addOption(_name, nil, MoreBuild.onBuildStoneWall, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.stoneArchitecture, MoreBuild.skillLevel.none, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_White_CinderBlock' .. _tooltip.description

  if MoreBuild.playerCanPlaster then
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
  else
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
  end

  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'walls_exterior_house_01_4'
  _sprite.northSprite = 'walls_exterior_house_01_5'
  _sprite.corner = 'walls_exterior_house_01_7'

  _name = getText 'ContextMenu_RedBrick_Wall'

  _option = subMenu[getText 'ContextMenu_RedBrick_Wall']:addOption(_name, nil, MoreBuild.onBuildStoneWall, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.stoneArchitecture, MoreBuild.skillLevel.none, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_RedBrick_Wall' .. _tooltip.description

  if MoreBuild.playerCanPlaster then
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterGreen
  else
    _tooltip.description = _tooltip.description .. MoreBuild.textPlasterRed
  end

  _tooltip:setTexture(_sprite.sprite)
end

MoreBuild.onBuildWoodenWall = function(ignoreThisArgument, sprite, player, name)
  local _wall = ISWoodenWall:new(sprite.sprite, sprite.northSprite, sprite.corner)

  _wall.canBePlastered = MoreBuild.playerCanPlaster
  _wall.canBarricade = false
  _wall.modData['wallType'] = 'wall'
  _wall.player = player
  _wall.name = name

  _wall.modData['need:Base.Plank'] = '3'
  _wall.modData['need:Base.Nails'] = '3'
  _wall.modData['xp:Woodwork'] = '5'

  MoreBuild.equipToolPrimary(_wall, player, 'Hammer')

  getCell():setDrag(_wall, player)
end

MoreBuild.onBuildStoneWall = function(ignoreThisArgument, sprite, player, name)
  local _wall = ISWoodenWall:new(sprite.sprite, sprite.northSprite, sprite.corner)

  _wall.canBePlastered = MoreBuild.playerCanPlaster
  _wall.canBarricade = false
  _wall.modData['wallType'] = 'wall'
  _wall.player = player
  _wall.name = name

  _wall.modData['need:Base.Plank'] = '6'
  _wall.modData['need:Base.Nails'] = '3'
  _wall.modData['xp:Woodwork'] = '5'

  function _wall:getHealth()
    return MoreBuild.healthLevel.stoneWall + buildUtil.getWoodHealth(self)
  end

  MoreBuild.equipToolPrimary(_wall, player, 'Trowel')

  getCell():setDrag(_wall, player)
end

MoreBuild.wallStylesMenuBuilder = function(subMenu, player, context, worldobjects)
  local _stylesOptions = {}
  local _stylesSubMenus = {}
  local _styleList = {
    getText 'ContextMenu_Light_BrownWood',
    getText 'ContextMenu_Dark_BrownWood',
    getText 'ContextMenu_Gray_Plaster',
    getText 'ContextMenu_Gray_Wood',
    getText 'ContextMenu_Red_Barnwood',
    getText 'ContextMenu_White_Plaster',
    getText 'ContextMenu_White_Wood',
    getText 'ContextMenu_Brown_Cinder_Block',
    getText 'ContextMenu_Gray_Cinder_Block',
    getText 'ContextMenu_White_CinderBlock',
    getText 'ContextMenu_RedBrick_Wall'
  }

  for _, _style in pairs(_styleList) do
    _stylesOptions[_style] = subMenu:addOption(_style, worldobjects, nil)
    _stylesSubMenus[_style] = subMenu:getNew(subMenu)
    context:addSubMenu(_stylesOptions[_style], _stylesSubMenus[_style])
  end

  MoreBuild.wallsMenuBuilder(_stylesSubMenus, player)
  MoreBuild.pillarsMenuBuilder(_stylesSubMenus, player)
  MoreBuild.doorFramesMenuBuilder(_stylesSubMenus, player)
  MoreBuild.windowFramesMenuBuilder(_stylesSubMenus, player)
  MoreBuild.fencesMenuBuilder(_stylesSubMenus, player)
  MoreBuild.fencePostsMenuBuilder(_stylesSubMenus, player)
end