if not getMoreBuildInstance then
  require('MoreBuildings/MoreBuilds_Main')
end

local MoreBuild = getMoreBuildInstance()

MoreBuild.flowerBedsMenuBuilder = function(subMenu, player, context)
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
      Material = 'Base.Twigs',
      Amount = 1
    }
  }

  MoreBuild.neededTools = {'HandShovel'}

  local _flowerBedsData = MoreBuild.getFlowerBedsData()
  local _currentOption
  local _currentSubMenu

  local _justFlowersOption = subMenu:addOption(getText 'ContextMenu_Just_Flowers')
  local _justFlowersSubMenu = subMenu:getNew(subMenu)
  context:addSubMenu(_justFlowersOption, _justFlowersSubMenu)

  local _stoneLinedOption = subMenu:addOption(getText 'ContextMenu_Blue_Flowers')
  local _stoneLinedSubMenu = subMenu:getNew(subMenu)
  context:addSubMenu(_stoneLinedOption, _stoneLinedSubMenu)

  MoreBuild.neededMaterials = {
    {
      Material = 'Base.Plank',
      Amount = 1
    },
    {
      Material = 'Base.Twigs',
      Amount = 1
    }
  }

  MoreBuild.neededTools = {'HandShovel'}

  local needSkills = {
    Woodwork = MoreBuild.skillLevel.landscaping
  }

  for _, _currentList in pairs(_flowerBedsData[getText 'ContextMenu_Just_Flowers']) do
    _sprite = {}
    _sprite.sprite = _currentList[1]

    _name = MoreBuild.getMoveableDisplayName(_sprite.sprite) .. _

    _option = _justFlowersSubMenu:addOption(_name, nil, MoreBuild.onBuildFlowerFloor, _sprite, player, _name)

    _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
    _tooltip.description = _currentList[3] .. _tooltip.description
    _tooltip:setName(_name)
    _tooltip:setTexture(_sprite.sprite)
  end

  MoreBuild.neededMaterials = {
    {
      Material = 'Base.Plank',
      Amount = 1
    },
    {
      Material = 'Base.Twigs',
      Amount = 1
    }
  }

  MoreBuild.neededTools = {'HandShovel'}

  for _, _currentList in pairs(_flowerBedsData[getText 'ContextMenu_Stone_Border']) do
    _sprite = {}
    _sprite.sprite = _currentList[1]
    _sprite.northSprite = _currentList[2]
    _sprite.eastSprite = _currentList[3]
    _sprite.southSprite = _currentList[4]

    _name = _currentList[5]

    _option = _stoneLinedSubMenu:addOption(_name, nil, MoreBuild.onBuildFourSpriteFlowerFloor, _sprite, player, _name)

    _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
    _tooltip.description = _currentList[6] .. _tooltip.description
    _tooltip:setName(_name)
    _tooltip:setTexture(_sprite.sprite)
  end
end

MoreBuild.onBuildFlowerFloor = function(ignoreThisArgument, sprite, player, name)
  local _floor = ISWoodenFloor:new(sprite.sprite, sprite.sprite)

  _floor.player = player
  _floor.name = name

  _floor.modData['need:Base.Plank'] = 1
  _floor.modData['need:Base.Twigs'] = 1
  _floor.modData['xp:Woodwork'] = 5

  getCell():setDrag(_floor, player)
end

MoreBuild.onBuildFourSpriteFlowerFloor = function(ignoreThisArgument, sprite, player, name)
  local _floor = ISWoodenFloor:new(sprite.sprite, sprite.northSprite)

  _floor.player = player
  _floor.name = name
  _floor.eastSprite = sprite.eastSprite
  _floor.southSprite = sprite.southSprite

  _floor.modData['need:Base.Plank'] = 1
  _floor.modData['need:Base.Plank'] = 1
  _floor.modData['need:Base.Twigs'] = 1
  _floor.modData['xp:Woodwork'] = 5

  getCell():setDrag(_floor, player)
end

MoreBuild.getFlowerBedsData = function()
  local _flowerBedsData = {
    [getText 'ContextMenu_Just_Flowers'] = {
      {'vegetation_ornamental_01_17', getText 'ContextMenu_Blue_Flowers', MoreBuild.textFlowerBedDescription},
      {'vegetation_ornamental_01_32', getText 'ContextMenu_Yellow_Flowers', MoreBuild.textFlowerBedDescription},
      {'vegetation_ornamental_01_16', getText 'ContextMenu_Purple_Flowers', MoreBuild.textFlowerBedDescription},
      {'vegetation_ornamental_01_18', getText 'ContextMenu_Pink_Flowers', MoreBuild.textFlowerBedDescription},
      {'vegetation_ornamental_01_33', getText 'ContextMenu_Gray_Flowers', MoreBuild.textFlowerBedDescription},
      {'vegetation_ornamental_01_34', getText 'ContextMenu_White_Flowers', MoreBuild.textFlowerBedDescription}
    },
    [getText 'ContextMenu_Stone_Border'] = {
      {'vegetation_ornamental_01_19', 'vegetation_ornamental_01_21', 'vegetation_ornamental_01_29', 'vegetation_ornamental_01_23', getText 'ContextMenu_PurpleandPink_Side', MoreBuild.textFlowerBedDescription .. MoreBuild.textCanRotate},
      {'vegetation_ornamental_01_20', 'vegetation_ornamental_01_22', 'vegetation_ornamental_01_28', 'vegetation_ornamental_01_30', getText 'ContextMenu_PurpleandPink_Corner', MoreBuild.textFlowerBedDescription .. MoreBuild.textCanRotate},
      {'f_flowerbed_1_3', 'f_flowerbed_1_5', 'f_flowerbed_1_7', 'f_flowerbed_1_9', getText 'ContextMenu_PurpleandPink_Post', MoreBuild.textFlowerBedDescription},
      {'vegetation_ornamental_01_35', 'vegetation_ornamental_01_37', 'vegetation_ornamental_01_39', 'vegetation_ornamental_01_45', getText 'ContextMenu_GrayandWhite_Side', MoreBuild.textFlowerBedDescription .. MoreBuild.textCanRotate},
      {'vegetation_ornamental_01_36', 'vegetation_ornamental_01_38', 'vegetation_ornamental_01_46', 'vegetation_ornamental_01_44', getText 'ContextMenu_GrayandWhite_Corner', MoreBuild.textFlowerBedDescription .. MoreBuild.textCanRotate},
      {'f_flowerbed_1_15', 'f_flowerbed_1_17', 'f_flowerbed_1_19', 'f_flowerbed_1_21', getText 'ContextMenu_GrayandWhite_Post', MoreBuild.textFlowerBedDescription}
    }
  }

  return _flowerBedsData
end