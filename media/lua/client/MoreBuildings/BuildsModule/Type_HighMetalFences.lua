if not getMoreBuildInstance then
  require('MoreBuildings/MoreBuilds_Main')
end

local MoreBuild = getMoreBuildInstance()

MoreBuild.highMetalFenceMenuBuilder = function(subMenu, player)
  local _sprite
  local _option
  local _tooltip
  local _name = ''

  MoreBuild.neededMaterials = {
    {
      Material = 'Base.Wire',
      Amount = 4
    },
    {
      Material = 'Base.SmallSheetMetal',
      Amount = 4
    },
    {
      Material = 'Base.ScrapMetal',
      Amount = 20
    },
    {
      Material = 'Base.WeldingRods',
      Amount = 1
    },
    {
      Material = 'Base.BlowTorch',
      Amount = 1
    }
  }

  MoreBuild.neededTools = {'Hammer'}

  local needSkills = {
    Woodwork = MoreBuild.skillLevel.wallObject,
    MetalWelding = 4
  }

  local _highMetalFenceData = MoreBuild.getHighMetalFenceData()

  for k, _currentList in pairs(_highMetalFenceData) do
    _sprite = {}
    _sprite.sprite1 = _currentList[1]
    _sprite.sprite2 = _currentList[2]
    _sprite.northSprite1 = _currentList[3]
    _sprite.northSprite2 = _currentList[4]

    _name = getText 'ContextMenu_HighMetal_Fence' .. k

    _option = subMenu:addOption(_name, nil, MoreBuild.onBuildHighMetalFence, _sprite, player, _name)

    _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
    _tooltip:setName(_name)
    _tooltip.description = getText 'Tooltip_HighMetal_Fence' .. _tooltip.description
    _tooltip:setTexture(_sprite.sprite1)
  end
end

MoreBuild.onBuildHighMetalFence = function(ignoreThisArgument, sprite, player, name)
  local _metalFence = ISHighMetalFence:new(sprite.sprite1, sprite.sprite2, sprite.northSprite1, sprite.northSprite2)

  _metalFence.player = player
  _metalFence.name = name
  _metalFence.blockAllTheSquare = false

  _metalFence.completionSound = 'BuildMetalStructureMedium'

  _metalFence.modData['need:Base.Wire'] = 4
  _metalFence.modData['need:Base.SmallSheetMetal'] = 4
  _metalFence.modData['need:Base.ScrapMetal'] = 20
  _metalFence.modData['use:Base.WeldingRods'] = 4
  _metalFence.modData['use:Base.BlowTorch'] = 10
  _metalFence.modData['xp:Woodwork'] = 10
  _metalFence.modData['xp:MetalWelding'] = 20

  function _metalFence:getHealth()
    return MoreBuild.healthLevel.metalWall + buildUtil.getWoodHealth(self)
  end

  MoreBuild.equipToolPrimary(_metalFence, player, 'Hammer')

  getCell():setDrag(_metalFence, player)
end

MoreBuild.getHighMetalFenceData = function()
  local _highMetalFenceData = {
    {'fencing_01_50', 'fencing_01_51', 'fencing_01_49', 'fencing_01_48'},
    {'fencing_01_58', 'fencing_01_59', 'fencing_01_57', 'fencing_01_56'},
    {'fencing_01_66', 'fencing_01_67', 'fencing_01_65', 'fencing_01_64'},
    {'fencing_01_82', 'fencing_01_83', 'fencing_01_81', 'fencing_01_80'},
    {'fencing_01_90', 'fencing_01_91', 'fencing_01_89', 'fencing_01_88'}
  }
  return _highMetalFenceData
end