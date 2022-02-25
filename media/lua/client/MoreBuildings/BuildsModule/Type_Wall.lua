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
      Material = 'Base.Plank',
      Amount = 3
    },
    {
      Material = 'Base.Nails',
      Amount = 3
    }
  }

  MoreBuild.neededTools = {'Hammer'}

  local needSkills = {
    Woodwork = MoreBuild.skillLevel.wallObject
  }

  _sprite = {}
  _sprite.sprite = 'location_restaurant_pileocrepe_01_0'
  _sprite.northSprite = 'location_restaurant_pileocrepe_01_1'
  _sprite.corner = 'location_restaurant_pileocrepe_01_3'

  _name = getText 'ContextMenu_Light_Brown_WoodWall'

  _option = subMenu[getText 'ContextMenu_Light_BrownWood']:addOption(_name, nil, MoreBuild.onBuildWoodenWall, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
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

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
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

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
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

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
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

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
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

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
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

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
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
      Material = 'Base.Plank',
      Amount = 6
    },
    {
      Material = 'Base.Nails',
      Amount = 3
    }
  }

  local needSkills = {
    Woodwork = MoreBuild.skillLevel.stoneArchitecture
  }

  _sprite = {}
  _sprite.sprite = 'walls_commercial_03_0'
  _sprite.northSprite = 'walls_commercial_03_1'
  _sprite.corner = 'walls_commercial_03_3'

  _name = getText 'ContextMenu_Brown_Cinder_Block'

  _option = subMenu[getText 'ContextMenu_Brown_Cinder_Block']:addOption(_name, nil, MoreBuild.onBuildStoneWall, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
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

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
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

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
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

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_RedBrick_Wall' .. _tooltip.description

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
      Material = 'Base.Screws',
      Amount = 4
    }
  }

  local _windowsWallData = MoreBuild.getWindowsWallData()

  for k, _currentList in pairs(_windowsWallData) do

    _sprite = {}
    _sprite.sprite = _currentList[1]
    _sprite.northSprite = _currentList[2]
    _sprite.corner = _currentList[3]

    _name = getText 'ContextMenu_Glass_Wall' .. k

    _option = subMenu[getText 'ContextMenu_Glass_Wall']:addOption(_name, nil, MoreBuild.onBuildWindowWall, _sprite, player, _name)

    _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
    _tooltip:setName(_name)
    _tooltip.description = getText 'Tooltip_Glass_Wall' .. _tooltip.description

    _tooltip:setTexture(_sprite.sprite)
  end
end

MoreBuild.onBuildWoodenWall = function(ignoreThisArgument, sprite, player, name)
  local _wall = ISWoodenWall:new(sprite.sprite, sprite.northSprite, sprite.corner)

  _wall.canBePlastered = MoreBuild.playerCanPlaster
  _wall.canBarricade = false
  _wall.modData['wallType'] = 'wall'
  _wall.player = player
  _wall.name = name

  _wall.modData['need:Base.Plank'] = 3
  _wall.modData['need:Base.Nails'] = 3
  _wall.modData['xp:Woodwork'] = 5

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

  _wall.modData['need:Base.Plank'] = 6
  _wall.modData['need:Base.Nails'] = 3
  _wall.modData['xp:Woodwork'] = 5

  function _wall:getHealth()
    return MoreBuild.healthLevel.stoneWall + buildUtil.getWoodHealth(self)
  end

  MoreBuild.equipToolPrimary(_wall, player, 'Hammer')

  getCell():setDrag(_wall, player)
end

MoreBuild.onBuildWindowWall = function(ignoreThisArgument, sprite, player, name)
  local _window = ISWindowWallObj:new(sprite.sprite, sprite.northSprite, getSpecificPlayer(player))

  _window.player = player
  _window.name = name

  _window.modData['need:Base.Plank'] = 4
  _window.modData['need:Base.Screws'] = 4
  _window.modData['xp:Woodwork'] = 15

  getCell():setDrag(_window, player)
end

MoreBuild.wallStylesMenuBuilder = function(subMenu, player, context)
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
    getText 'ContextMenu_RedBrick_Wall',
    getText 'ContextMenu_Glass_Wall'
  }

  for _, _style in pairs(_styleList) do
    _stylesOptions[_style] = subMenu:addOption(_style)
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

MoreBuild.getWindowsWallData = function()
  local _windowsWallData = {
    {'walls_commercial_01_0', 'walls_commercial_01_1', 'walls_commercial_01_2'},
    {'walls_commercial_01_16', 'walls_commercial_01_17', 'walls_commercial_01_19'},
    {'walls_commercial_01_32', 'walls_commercial_01_33', 'walls_commercial_01_35'},
    {'walls_commercial_01_40', 'walls_commercial_01_41', 'walls_commercial_01_35'},
    {'walls_commercial_01_64', 'walls_commercial_01_65', 'walls_commercial_01_67'},
    {'walls_commercial_01_80', 'walls_commercial_01_81', 'walls_commercial_01_83'},
    {'walls_commercial_01_96', 'walls_commercial_01_97', 'walls_commercial_01_99'},
    {'walls_commercial_01_112', 'walls_commercial_01_113', 'walls_commercial_01_115'},
    {'walls_commercial_02_0', 'walls_commercial_02_1', 'walls_commercial_02_3'},
    {'walls_commercial_02_8', 'walls_commercial_02_9', 'walls_commercial_02_11'}
  }
  return _windowsWallData
end