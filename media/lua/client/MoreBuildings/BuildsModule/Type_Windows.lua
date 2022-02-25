if not getMoreBuildInstance then
  require('MoreBuildings/MoreBuilds_Main')
end

local MoreBuild = getMoreBuildInstance()

MoreBuild.onBuildWindow = function(ignoreThisArgument, sprite, player, name)
  local _window = ISWindowObj:new(sprite.sprite, sprite.northSprite, getSpecificPlayer(player))

  _window.player = player
  _window.name = name

  _window.modData['need:Base.Plank'] = 4
  _window.modData['need:Base.Screws'] = 4
  _window.modData['xp:Woodwork'] = 15

  getCell():setDrag(_window, player)
end

MoreBuild.WindowsMenuBuilder = function(subMenu, player)
  local _sprite = nil
  local _option = nil
  local _tooltip = nil
  local _name = ''

  local _windowsData = MoreBuild.getWindowsData()

  MoreBuild.neededMaterials = {
    {
      Material = 'Base.Screws',
      Amount = 4
    },
    {
      Material = 'Base.Plank',
      Amount = 4
    }
  }

  MoreBuild.neededTools = {'Screwdriver', 'Saw'}

  local needSkills = {
    Woodwork = MoreBuild.skillLevel.windowsObject
  }

  for _, _currentList in pairs(_windowsData) do
    _sprite = {}
    _sprite.sprite = _currentList[1]
    _sprite.northSprite = _currentList[2]

    _name = MoreBuild.getMoveableDisplayName(_currentList[1])

    _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWindow, _sprite, player, _name)

    _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
    _tooltip:setName(_name)
    _tooltip.description = getText('Tooltip_WoodWindows') .. _tooltip.description
    _tooltip:setTexture(_sprite.sprite)
  end
end

MoreBuild.getWindowsData = function()
  local _windowsData = {
    {'fixtures_windows_01_0', 'fixtures_windows_01_1'},
    {'fixtures_windows_01_8', 'fixtures_windows_01_9'},
    {'fixtures_windows_01_16', 'fixtures_windows_01_17'},
    {'fixtures_windows_01_24', 'fixtures_windows_01_25'},
    {'fixtures_windows_01_32', 'fixtures_windows_01_33'},
    {'fixtures_windows_01_56', 'fixtures_windows_01_57'}
  }

  return _windowsData
end