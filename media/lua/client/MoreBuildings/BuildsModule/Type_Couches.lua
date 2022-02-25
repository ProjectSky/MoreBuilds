if not getMoreBuildInstance then
  require('MoreBuildings/MoreBuilds_Main')
end

local MoreBuild = getMoreBuildInstance()

MoreBuild.couchesMenuBuilder = function(subMenu, player, context)
  local _sprite
  local _option
  local _tooltip
  local _name = ''

  local _couchData = MoreBuild.getCouchesData()

  local _frontViewOption = subMenu:addOption(getText 'ContextMenu_FrontSide_Views')
  local _frontViewSubMenu = subMenu:getNew(subMenu)
  context:addSubMenu(_frontViewOption, _frontViewSubMenu)

  local _backViewOption = subMenu:addOption(getText 'ContextMenu_BackSide_Views')
  local _backViewSubMenu = subMenu:getNew(subMenu)
  context:addSubMenu(_backViewOption, _backViewSubMenu)

  MoreBuild.neededMaterials = {
    {
      Material = 'Base.Plank',
      Amount = 6
    },
    {
      Material = 'Base.Nails',
      Amount = 4
    },
    {
      Material = 'Base.Sheet',
      Amount = 1
    }
  }

  MoreBuild.neededTools = {'Hammer'}

  local needSkills = {
    Woodwork = MoreBuild.skillLevel.complexFurniture
  }

  for _, _currentList in pairs(_couchData) do
    _name = _currentList[9]

    _sprite = {}
    _sprite.sprite = _currentList[1]
    _sprite.sprite2 = _currentList[2]
    _sprite.northSprite = _currentList[3]
    _sprite.northSprite2 = _currentList[4]

    _option = _frontViewSubMenu:addOption(_name, nil, MoreBuild.onBuildCouch, _sprite, player, _name)

    _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
    _tooltip.description = MoreBuild.textCouchFrontDescription .. _tooltip.description
    _tooltip:setName(_name)
    _tooltip:setTexture(_sprite.sprite)

    _sprite = {}
    _sprite.sprite = _currentList[5]
    _sprite.sprite2 = _currentList[6]
    _sprite.northSprite = _currentList[7]
    _sprite.northSprite2 = _currentList[8]

    _option = _backViewSubMenu:addOption(_name, nil, MoreBuild.onBuildCouch, _sprite, player, _name)

    _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
    _tooltip.description = MoreBuild.textCouchRearDescription .. _tooltip.description
    _tooltip:setName(_name)
    _tooltip:setTexture(_sprite.sprite)
  end
end

MoreBuild.getCouchesData = function()
  local _couchesData = {
    {
      'furniture_seating_indoor_03_32',
      'furniture_seating_indoor_03_33',
      'furniture_seating_indoor_03_34',
      'furniture_seating_indoor_03_35',
      'furniture_seating_indoor_03_37',
      'furniture_seating_indoor_03_36',
      'furniture_seating_indoor_03_38',
      'furniture_seating_indoor_03_39',
      getText 'ContextMenu_ColorType_Blue'
    },
    {
      'furniture_seating_indoor_03_9',
      'furniture_seating_indoor_03_8',
      'furniture_seating_indoor_03_10',
      'furniture_seating_indoor_03_11',
      'furniture_seating_indoor_03_15',
      'furniture_seating_indoor_03_14',
      'furniture_seating_indoor_03_12',
      'furniture_seating_indoor_03_13',
      getText 'ContextMenu_ColorType_PowderBlue'
    },
    {
      'furniture_seating_indoor_02_49',
      'furniture_seating_indoor_02_48',
      'furniture_seating_indoor_02_50',
      'furniture_seating_indoor_02_51',
      'furniture_seating_indoor_02_55',
      'furniture_seating_indoor_02_54',
      'furniture_seating_indoor_02_52',
      'furniture_seating_indoor_02_53',
      getText 'ContextMenu_ColorType_Brown'
    },
    {
      'furniture_seating_indoor_02_35',
      'furniture_seating_indoor_02_34',
      'furniture_seating_indoor_02_32',
      'furniture_seating_indoor_02_33',
      'furniture_seating_indoor_02_39',
      'furniture_seating_indoor_02_38',
      'furniture_seating_indoor_02_36',
      'furniture_seating_indoor_02_37',
      getText 'ContextMenu_Gray_Cinder_Block'
    },
    {
      'furniture_seating_indoor_01_16',
      'furniture_seating_indoor_01_17',
      'furniture_seating_indoor_01_18',
      'furniture_seating_indoor_01_19',
      'furniture_seating_indoor_01_21',
      'furniture_seating_indoor_01_20',
      'furniture_seating_indoor_01_22',
      'furniture_seating_indoor_01_23',
      getText 'ContextMenu_ColorType_OliveGreen'
    },
    {
      'furniture_seating_indoor_03_17',
      'furniture_seating_indoor_03_16',
      'furniture_seating_indoor_03_18',
      'furniture_seating_indoor_03_19',
      'furniture_seating_indoor_03_23',
      'furniture_seating_indoor_03_22',
      'furniture_seating_indoor_03_20',
      'furniture_seating_indoor_03_21',
      getText 'ContextMenu_ColorType_Green'
    },
    {
      'furniture_seating_indoor_01_1',
      'furniture_seating_indoor_01_0',
      'furniture_seating_indoor_01_2',
      'furniture_seating_indoor_01_3',
      'furniture_seating_indoor_01_7',
      'furniture_seating_indoor_01_6',
      'furniture_seating_indoor_01_4',
      'furniture_seating_indoor_01_5',
      getText 'ContextMenu_ColorType_Orange'
    },
    {
      'furniture_seating_indoor_01_27',
      'furniture_seating_indoor_01_26',
      'furniture_seating_indoor_01_24',
      'furniture_seating_indoor_01_25',
      'furniture_seating_indoor_01_31',
      'furniture_seating_indoor_01_30',
      'furniture_seating_indoor_01_28',
      'furniture_seating_indoor_01_29',
      getText 'ContextMenu_ColorType_Purple'
    },
    {
      'furniture_seating_indoor_02_25',
      'furniture_seating_indoor_02_24',
      'furniture_seating_indoor_02_26',
      'furniture_seating_indoor_02_27',
      'furniture_seating_indoor_02_31',
      'furniture_seating_indoor_02_30',
      'furniture_seating_indoor_02_28',
      'furniture_seating_indoor_02_29',
      getText 'ContextMenu_ColorType_Yellow'
    }
  }

  return _couchesData
end

MoreBuild.onBuildCouch = function(ignoreThisArgument, sprite, player, name)
  local _couch = ISDoubleTileFurniture:new(name, sprite.sprite, sprite.sprite2, sprite.northSprite, sprite.northSprite2)

  _couch.player = player
  _couch.name = name

  _couch.modData['need:Base.Plank'] = 6
  _couch.modData['need:Base.Nails'] = 4
  _couch.modData['need:Base.Sheet'] = 1
  _couch.modData['xp:Woodwork'] = 5

  getCell():setDrag(_couch, player)
end