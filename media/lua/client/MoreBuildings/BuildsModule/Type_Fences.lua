if not getMoreBuildInstance then
  require('MoreBuildings/MoreBuilds_Main')
end

local MoreBuild = getMoreBuildInstance()

MoreBuild.fencesMenuBuilder = function(subMenu, player)
  local _sprite
  local _option
  local _tooltip
  local _name = ''

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
    Woodwork = MoreBuild.skillLevel.wallObject
  }

  _sprite = {}
  _sprite.sprite = 'location_restaurant_pileocrepe_01_44'
  _sprite.northSprite = 'location_restaurant_pileocrepe_01_45'
  _sprite.corner = 'location_restaurant_pileocrepe_01_47'

  _name = getText 'ContextMenu_Light_BrownWood_Fence'

  _option = subMenu[getText 'ContextMenu_Light_BrownWood']:addOption(_name, nil, MoreBuild.onBuildWoodenFence, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textFenceDescription .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'walls_garage_02_20'
  _sprite.northSprite = 'walls_garage_02_21'
  _sprite.corner = 'walls_garage_02_23'

  _name = getText 'ContextMenu_GrayFence_WithRail'

  _option = subMenu[getText 'ContextMenu_Gray_Plaster']:addOption(_name, nil, MoreBuild.onBuildWoodenFence, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textFenceDescription .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'walls_exterior_wooden_01_60'
  _sprite.northSprite = 'walls_exterior_wooden_01_61'
  _sprite.corner = 'walls_exterior_wooden_01_63'

  _name = getText 'ContextMenu_Gray_WoodFence'

  _option = subMenu[getText 'ContextMenu_Gray_Wood']:addOption(_name, nil, MoreBuild.onBuildWoodenFence, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textFenceDescription .. _tooltip.description
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
  _sprite.sprite = 'walls_commercial_03_4'
  _sprite.northSprite = 'walls_commercial_03_5'
  _sprite.corner = 'walls_commercial_03_7'

  _name = getText 'ContextMenu_BrownCinder_BlockFence'

  _option = subMenu[getText 'ContextMenu_Brown_Cinder_Block']:addOption(_name, nil, MoreBuild.onBuildWoodenFence, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_BrownCinder_BlockFence' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'walls_commercial_03_36'
  _sprite.northSprite = 'walls_commercial_03_37'
  _sprite.corner = 'walls_commercial_03_38'

  _name = getText 'ContextMenu_GrayCinder_BlockFence'

  _option = subMenu[getText 'ContextMenu_Gray_Cinder_Block']:addOption(_name, nil, MoreBuild.onBuildWoodenFence, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_Gray_Cinder_Block' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'walls_commercial_01_52'
  _sprite.northSprite = 'walls_commercial_01_53'
  _sprite.corner = 'walls_commercial_01_55'

  _name = getText 'ContextMenu_WhiteCinder_BlockFence'

  _option = subMenu[getText 'ContextMenu_White_CinderBlock']:addOption(_name, nil, MoreBuild.onBuildWoodenFence, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_WhiteCinder_BlockFence' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'walls_exterior_house_01_36'
  _sprite.northSprite = 'walls_exterior_house_01_37'
  _sprite.corner = 'walls_exterior_house_01_39'

  _name = getText 'ContextMenu_RedBrick_Fence'

  _option = subMenu[getText 'ContextMenu_RedBrick_Wall']:addOption(_name, nil, MoreBuild.onBuildStoneFence, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_RedBrick_Fence' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)
end

MoreBuild.moreFencesMenuBuilder = function(subMenu, player)
  local _sprite
  local _option
  local _tooltip
  local _name = ''

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
    Woodwork = MoreBuild.skillLevel.wallObject
  }

  _sprite = {}
  _sprite.sprite = 'fencing_01_4'
  _sprite.northSprite = 'fencing_01_5'
  _sprite.corner = 'fencing_01_7'

  _name = getText 'ContextMenu_WhitePicket_FencePost'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenFence, _sprite, player)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_WhitePicket_FencePost' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'fixtures_railings_01_112'
  _sprite.northSprite = 'fixtures_railings_01_113'
  _sprite.corner = 'fixtures_railings_01_115'

  _name = getText 'ContextMenu_BeigeFence_WithRail'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenFence, _sprite, player)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_GrayFence_WithRail' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'fixtures_railings_01_116'
  _sprite.northSprite = 'fixtures_railings_01_117'
  _sprite.corner = 'fixtures_railings_01_119'

  _name = getText 'ContextMenu_GrayFence_WithRail'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenFence, _sprite, player)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_GrayFence_WithRail' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  MoreBuild.neededMaterials = {
    {
      Material = 'Base.SheetMetal',
      Amount = 2
    },
    {
      Material = 'Base.Screws',
      Amount = 3
    }
  }

  MoreBuild.neededTools = {'Screwdriver'}

  local needSkills = {
    Woodwork = MoreBuild.skillLevel.metalArchitecture
  }

  _sprite = {}
  _sprite.sprite = 'industry_railroad_05_40'
  _sprite.northSprite = 'industry_railroad_05_41'
  _sprite.corner = 'industry_railroad_05_43'

  _name = getText 'ContextMenu_GreenMetal_Fence'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildMetalFence, _sprite, player)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_WhitePicket_FencePost' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'industry_bunker_01_24'
  _sprite.northSprite = 'industry_bunker_01_25'
  _sprite.corner = 'industry_bunker_01_27'

  _name = getText 'ContextMenu_RedMetal_Fence'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenPillar, _sprite, player)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_WhitePicket_FencePost' .. _tooltip.description
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
  _sprite.sprite = 'construction_01_0'
  _sprite.northSprite = 'construction_01_1'
  _sprite.corner = 'construction_01_3'

  _name = getText 'ContextMenu_RoughBrick_Fence'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildStoneFence, _sprite, player)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_RoughBrick_Fence' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)
end

MoreBuild.onBuildWoodenFence = function(ignoreThisArgument, sprite, player, name)
  local _fence = ISWoodenWall:new(sprite.sprite, sprite.northSprite, sprite.corner)

  _fence.hoppable = true
  _fence.isThumpable = true
  _fence.player = player
  _fence.name = name

  _fence.modData['need:Base.Plank'] = 2
  _fence.modData['need:Base.Nails'] = 3
  _fence.modData['xp:Woodwork'] = 5

  function _fence:getHealth()
    return MoreBuild.healthLevel.woodenFence
  end

  getCell():setDrag(_fence, player)
end

MoreBuild.onBuildStoneFence = function(ignoreThisArgument, sprite, player, name)
  local _fence = ISWoodenWall:new(sprite.sprite, sprite.northSprite, sprite.corner)

  _fence.hoppable = true
  _fence.isThumpable = true
  _fence.player = player
  _fence.name = name

  _fence.modData['need:Base.Plank'] = 4
  _fence.modData['need:Base.Nails'] = 3
  _fence.modData['xp:Woodwork'] = 5

  function _fence:getHealth()
    return MoreBuild.healthLevel.stoneWall + buildUtil.getWoodHealth(self)
  end

  MoreBuild.equipToolPrimary(_fence, player, 'Hammer')

  getCell():setDrag(_fence, player)
end

MoreBuild.onBuildMetalFence = function(ignoreThisArgument, sprite, player, name)
  local _fence = ISWoodenWall:new(sprite.sprite, sprite.northSprite, sprite.corner)

  _fence.hoppable = true
  _fence.isThumpable = true
  _fence.player = player
  _fence.name = name

  _fence.modData['need:Base.SheetMetal'] = 2
  _fence.modData['need:Base.Screws'] = 3
  _fence.modData['xp:Woodwork'] = 5

  function _fence:getHealth()
    return MoreBuild.healthLevel.metalWall + buildUtil.getWoodHealth(self)
  end

  MoreBuild.equipToolPrimary(_fence, player, 'Screwdriver')

  getCell():setDrag(_fence, player)
end