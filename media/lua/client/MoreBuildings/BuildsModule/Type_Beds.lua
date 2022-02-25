if not getMoreBuildInstance then
  require('MoreBuildings/MoreBuilds_Main')
end

local MoreBuild = getMoreBuildInstance()

MoreBuild.bedsMenuBuilder = function(subMenu, player)
  local _sprite
  local _option
  local _tooltip
  local _name = ''

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
      Material = 'Base.Mattress',
      Amount = 1
    }
  }

  MoreBuild.neededTools = {'Hammer'}

  local needSkills = {
    Woodwork = MoreBuild.skillLevel.complexFurniture
  }

  local _bedsData = MoreBuild.getBedData()

  for _, _currentList in pairs(_bedsData) do
    _sprite = {}
    _sprite.sprite = _currentList[1]
    _sprite.sprite2 = _currentList[2]
    _sprite.northSprite = _currentList[3]
    _sprite.northSprite2 = _currentList[4]

    _name = _currentList[5]

    _option = subMenu:addOption(_name, nil, MoreBuild.onBuildBed, _sprite, player, _name)

    _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
    _tooltip.description = _currentList[6] .. _tooltip.description
    _tooltip:setName(_name)
    _tooltip:setTexture(_sprite.sprite)
  end
end

MoreBuild.getBedData = function()
  local _bedData = {
    {'furniture_bedding_01_3', 'furniture_bedding_01_2', 'furniture_bedding_01_0', 'furniture_bedding_01_1', getText 'ContextMenu_Gray_Bed', MoreBuild.textBedDescription},
    {'furniture_bedding_01_11', 'furniture_bedding_01_10', 'furniture_bedding_01_8', 'furniture_bedding_01_9', getText 'ContextMenu_Blue_Bed', MoreBuild.textBedDescription},
    {'furniture_bedding_01_29', 'furniture_bedding_01_28', 'furniture_bedding_01_26', 'furniture_bedding_01_27', getText 'ContextMenu_Brown_Bed', MoreBuild.textBedDescription},
    {'furniture_bedding_01_33', 'furniture_bedding_01_32', 'furniture_bedding_01_34', 'furniture_bedding_01_35', getText 'ContextMenu_Beige_Bed', MoreBuild.textBedDescription},
    {'furniture_bedding_01_37', 'furniture_bedding_01_36', 'furniture_bedding_01_38', 'furniture_bedding_01_39', getText 'ContextMenu_Red_BunkBed', getText 'Tooltip_Bunk_Bed'},
    {'furniture_bedding_01_59', 'furniture_bedding_01_58', 'furniture_bedding_01_56', 'furniture_bedding_01_57', getText 'ContextMenu_Folding_Bed', getText 'Tooltip_Folding_Bed'},
    {'furniture_bedding_01_87', 'furniture_bedding_01_86', 'furniture_bedding_01_84', 'furniture_bedding_01_85', getText 'ContextMenu_Gray_BunkBed', getText 'Tooltip_Bunk_Bed'}
  }

  return _bedData
end

MoreBuild.onBuildBed = function(ignoreThisArgument, sprite, player, name)
  local _bed = ISDoubleTileFurniture:new(name, sprite.sprite, sprite.sprite2, sprite.northSprite, sprite.northSprite2)

  _bed.player = player
  _bed.name = name

  _bed.modData['need:Base.Plank'] = 6
  _bed.modData['need:Base.Nails'] = 4
  _bed.modData['need:Base.Mattress'] = 1
  _bed.modData['xp:Woodwork'] = 10

  getCell():setDrag(_bed, player)
end