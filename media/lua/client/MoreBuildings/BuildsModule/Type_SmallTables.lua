if not getMoreBuildInstance then
  require('MoreBuildings/MoreBuilds_Main')
end

local MoreBuild = getMoreBuildInstance()

MoreBuild.smallTablesMenuBuilder = function(subMenu, player)
  local _sprite
  local _option
  local _tooltip
  local _name = ''

  local _tableData = MoreBuild.getSmallTableData()

  MoreBuild.neededMaterials = {
    {
      Material = 'Base.Plank',
      Amount = 5
    },
    {
      Material = 'Base.Nails',
      Amount = 4
    }
  }

  MoreBuild.neededTools = {'Hammer'}

  local needSkills = {
    Woodwork = MoreBuild.skillLevel.simpleFurniture
  }

  for _, _currentList in pairs(_tableData) do
    _sprite = {}
    _sprite.sprite = _currentList[1]
    _sprite.northSprite = _currentList[2]

    _name = MoreBuild.getMoveableDisplayName(_currentList[1]) or _currentList[3]

    _option = subMenu:addOption(_name, nil, MoreBuild.onBuildSingleTileWoodenTable, _sprite, player, _name)

    _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
    _tooltip.description = _currentList[4] .. _tooltip.description
    _tooltip:setName(_name)
    _tooltip:setTexture(_sprite.sprite)
  end
end

MoreBuild.getSmallTableData = function()
  local _smallTableData = {
    {'furniture_tables_high_01_4', 'furniture_tables_high_01_5', getText 'ContextMenu_HighRedBrown_Table', MoreBuild.textSmallTableDescription},
    {'furniture_tables_high_01_6', 'furniture_tables_high_01_6', getText 'ContextMenu_RoundBrown_Table', MoreBuild.textSmallTableDescription},
    {'furniture_tables_high_01_7', 'furniture_tables_high_01_7', getText 'ContextMenu_RoundBeige_Table', MoreBuild.textSmallTableDescription},
    {'furniture_tables_high_01_13', 'furniture_tables_high_01_12', getText 'ContextMenu_HighBeige_Table', MoreBuild.textSmallTableDescription},
    {'furniture_tables_high_01_15', 'furniture_tables_high_01_15', getText 'ContextMenu_Square_Table', MoreBuild.textSmallTableDescription},
    {'furniture_tables_high_01_16', 'furniture_tables_high_01_16', getText 'ContextMenu_SquareGray_Table', MoreBuild.textSmallTableDescription},
    {'furniture_tables_high_01_21', 'furniture_tables_high_01_22', getText 'ContextMenu_HighBrown_Table', MoreBuild.textSmallTableDescription},
    {'furniture_tables_low_01_2', 'furniture_tables_low_01_3', getText 'ContextMenu_RedBrownEnd_Table', MoreBuild.textSmallTableDescription},
    {'furniture_tables_low_01_16', 'furniture_tables_low_01_17', getText 'ContextMenu_BeigeEnd_Table', MoreBuild.textSmallTableDescription},
    {'furniture_tables_low_01_21', 'furniture_tables_low_01_20', getText 'ContextMenu_WhiteEnd_Table', MoreBuild.textSmallTableDescription},
    {'location_restaurant_pileocrepe_01_37', 'location_restaurant_pileocrepe_01_36', getText 'ContextMenu_SquareBeige_Table', MoreBuild.textSmallTableDescription}
  }

  return _smallTableData
end

MoreBuild.onBuildSingleTileWoodenTable = function(ignoreThisArgument, sprite, player, name)
  local _table = ISSimpleFurniture:new(name, sprite.sprite, sprite.northSprite)

  _table.player = player
  _table.name = name

  _table.modData['need:Base.Plank'] = 5
  _table.modData['need:Base.Nails'] = 4
  _table.modData['xp:Woodwork'] = 5

  getCell():setDrag(_table, player)
end

MoreBuild.largeTablesMenuBuilder = function(subMenu, player)
  local _sprite
  local _option
  local _tooltip
  local _name = ''

  local _tableData = MoreBuild.getLargeTableData()

  MoreBuild.neededMaterials = {
    {
      Material = 'Base.Plank',
      Amount = 6
    },
    {
      Material = 'Base.Nails',
      Amount = 4
    }
  }

  MoreBuild.neededTools = {'Hammer'}

  local needSkills = {
    Woodwork = MoreBuild.skillLevel.complexFurniture
  }

  for _, _currentList in pairs(_tableData) do
    _sprite = {}
    _sprite.sprite = _currentList[1]
    _sprite.sprite2 = _currentList[2]
    _sprite.northSprite = _currentList[3]
    _sprite.northSprite2 = _currentList[4]

    _name = MoreBuild.getMoveableDisplayName(_currentList[1])

    _option = subMenu:addOption(_name, nil, MoreBuild.onBuildDoubleTileWoodenTable, _sprite, player, _name)

    _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
    _tooltip.description = _currentList[5] .. _tooltip.description
    _tooltip:setName(_name)
    _tooltip:setTexture(_sprite.sprite)
  end
end

MoreBuild.getLargeTableData = function()
  local _largeTableData = {
    {'location_restaurant_pileocrepe_01_33', 'location_restaurant_pileocrepe_01_32', 'location_restaurant_pileocrepe_01_34', 'location_restaurant_pileocrepe_01_35', MoreBuild.textLargeTableDescription},
    {'furniture_tables_high_01_1', 'furniture_tables_high_01_0', 'furniture_tables_high_01_2', 'furniture_tables_high_01_3', MoreBuild.textLargeTableDescription},
    {'furniture_tables_high_01_9', 'furniture_tables_high_01_8', 'furniture_tables_high_01_10', 'furniture_tables_high_01_11', MoreBuild.textLargeTableDescription},
    {'furniture_tables_high_01_20', 'furniture_tables_high_01_19', 'furniture_tables_high_01_17', 'furniture_tables_high_01_18', MoreBuild.textLargeTableDescription},
    {'furniture_tables_high_01_27', 'furniture_tables_high_01_26', 'furniture_tables_high_01_28', 'furniture_tables_high_01_29', MoreBuild.textLargeTableDescription},
    {'furniture_tables_high_01_35', 'furniture_tables_high_01_34', 'furniture_tables_high_01_32', 'furniture_tables_high_01_33', getText 'Tooltip_BrownOffice_Table'},
    {'furniture_tables_high_01_37', 'furniture_tables_high_01_36', 'furniture_tables_high_01_38', 'furniture_tables_high_01_39', MoreBuild.textLargeTableDescription},
    {'furniture_tables_high_01_41', 'furniture_tables_high_01_40', 'furniture_tables_high_01_42', 'furniture_tables_high_01_43', MoreBuild.textLargeTableDescription},
    {'furniture_tables_high_01_45', 'furniture_tables_high_01_44', 'furniture_tables_high_01_46', 'furniture_tables_high_01_47', getText 'Tooltip_WhiteWork_Table'},
    {'furniture_tables_high_01_51', 'furniture_tables_high_01_50', 'furniture_tables_high_01_48', 'furniture_tables_high_01_49', getText 'Tooltip_BeigeFolding_Table'},
    {'furniture_tables_high_01_53', 'furniture_tables_high_01_52', 'furniture_tables_high_01_54', 'furniture_tables_high_01_55', getText 'Tooltip_BeigeFolding_Table'},
    {'furniture_tables_high_01_57', 'furniture_tables_high_01_56', 'furniture_tables_high_01_58', 'furniture_tables_high_01_59', getText 'Tooltip_BeigeFolding_Table'},
    {'furniture_tables_low_01_15', 'furniture_tables_low_01_14', 'furniture_tables_low_01_0', 'furniture_tables_low_01_1', getText 'Tooltip_Coffee_Table'}
  }

  return _largeTableData
end

MoreBuild.onBuildDoubleTileWoodenTable = function(ignoreThisArgument, sprite, player, name)
  local _table = ISDoubleTileFurniture:new(name, sprite.sprite, sprite.sprite2, sprite.northSprite, sprite.northSprite2)

  _table.player = player
  _table.name = name

  _table.modData['need:Base.Plank'] = 6
  _table.modData['need:Base.Nails'] = 4
  _table.modData['xp:Woodwork'] = 5

  getCell():setDrag(_table, player)
end

MoreBuild.missingPostsMenuBuilder = function(subMenu, player)
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
      Material = 'Base.Nails',
      Amount = 2
    }
  }

  MoreBuild.neededTools = {'Hammer'}

  local needSkills = {
    Woodwork = MoreBuild.skillLevel.wallObject
  }

  _sprite = {}
  _sprite.sprite = 'carpentry_02_51'
  _sprite.northSprite = 'carpentry_02_51'

  _name = getText 'ContextMenu_Wooden_FencePost'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenFencePost, _sprite, player)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_Wooden_FencePost' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  MoreBuild.neededMaterials = {
    {
      Material = 'Base.Log',
      Amount = 1
    },
    {
      Material = 'Base.Rope',
      Amount = 1
    }
  }

  local needSkills = {
    Woodwork = MoreBuild.skillLevel.logObject
  }

  _sprite = {}
  _sprite.sprite = 'carpentry_02_83'
  _sprite.northSprite = 'carpentry_02_83'

  _name = getText 'ContextMenu_RopeLogWall_Pillar'

  _option = subMenu:addOption(_name .. '(' .. getItemNameFromFullType('Base.Rope') .. ')', nil, MoreBuild.onBuildStonePillar, _sprite, player)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_RopeLogWall_Pillar' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  MoreBuild.neededMaterials = {
    {
      Material = 'Base.Log',
      Amount = 1
    },
    {
      Material = 'Base.SheetRope',
      Amount = 2
    }
  }

  _option = subMenu:addOption(_name .. '(' .. getItemNameFromFullType('Base.SheetRope') .. ')', nil, MoreBuild.onBuildStonePillar, _sprite, player)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_SheetRopeLogWall_Pillar' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)
end