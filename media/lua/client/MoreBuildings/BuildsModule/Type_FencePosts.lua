if not getMoreBuildInstance then
  require('MoreBuildings/MoreBuilds_Main')
end

local MoreBuild = getMoreBuildInstance()

MoreBuild.moreFencePostsMenuBuilder = function(subMenu, player)
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
  _sprite.sprite = 'fencing_01_7'
  _sprite.northSprite = 'fencing_01_7'

  _name = getText 'ContextMenu_WhitePicket_FencePost'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenFencePost, _sprite, player)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_WhitePicket_FencePost' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'fixtures_railings_01_115'
  _sprite.northSprite = 'fixtures_railings_01_115'

  _name = getText 'ContextMenu_Beige_FencePost_WithRail'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenFencePost, _sprite, player)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_Beige_FencePost_WithRail' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'fixtures_railings_01_119'
  _sprite.northSprite = 'fixtures_railings_01_119'

  _name = getText 'ContextMenu_Gray_FencePost_WithRail'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenFencePost, _sprite, player)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_Beige_FencePost_WithRail' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  MoreBuild.neededMaterials = {
    {
      Material = 'Base.SheetMetal',
      Amount = 1
    },
    {
      Material = 'Base.Screws',
      Amount = 2
    }
  }

  MoreBuild.neededTools = {'Screwdriver'}

  local needSkills = {
    Woodwork = MoreBuild.skillLevel.metalArchitecture
  }

  _sprite = {}
  _sprite.sprite = 'industry_railroad_05_43'
  _sprite.northSprite = 'industry_railroad_05_43'

  _name = getText 'ContextMenu_GreenMetal_FencePost'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildStoneFence, _sprite, player)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_GreenMetal_FencePost' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'industry_bunker_01_27'
  _sprite.northSprite = 'industry_bunker_01_27'

  _name = getText 'ContextMenu_RedMetal_Fence'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildStoneFence, _sprite, player)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_GreenMetal_FencePost' .. _tooltip.description
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
    Woodwork = MoreBuild.skillLevel.metalArchitecture
  }

  _sprite = {}
  _sprite.sprite = 'construction_01_3'
  _sprite.northSprite = 'construction_01_3'

  _name = getText 'ContextMenu_RoughBrick_FencePost'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildStoneFencePost, _sprite, player)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_RoughBrick_FencePost' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)
end

MoreBuild.fencePostsMenuBuilder = function(subMenu, player)
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
    Woodwork = MoreBuild.skillLevel.metalArchitecture
  }

  _sprite = {}
  _sprite.sprite = 'location_restaurant_pileocrepe_01_47'
  _sprite.northSprite = 'location_restaurant_pileocrepe_01_47'

  _name = getText 'ContextMenu_LightBrownWood_FencePost'

  _option = subMenu[getText 'ContextMenu_Light_BrownWood']:addOption(_name, nil, MoreBuild.onBuildWoodenFencePost, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textFencePostDescription .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'walls_garage_02_23'
  _sprite.northSprite = 'walls_garage_02_23'

  _name = getText 'ContextMenu_GrayPlaster_FencePost'

  _option = subMenu[getText 'ContextMenu_Gray_Plaster']:addOption(_name, nil, MoreBuild.onBuildWoodenFencePost, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textFencePostDescription .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'walls_exterior_wooden_01_63'
  _sprite.northSprite = 'walls_exterior_wooden_01_63'

  _name = getText 'ContextMenu_GrayWood_FencePost'

  _option = subMenu[getText 'ContextMenu_Gray_Wood']:addOption(_name, nil, MoreBuild.onBuildWoodenFencePost, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textFencePostDescription .. _tooltip.description
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
  _sprite.sprite = 'walls_commercial_03_7'
  _sprite.northSprite = 'walls_commercial_03_7'

  _name = getText 'ContextMenu_BrownCinder_Block_FencePost'

  _option = subMenu[getText 'ContextMenu_Brown_Cinder_Block']:addOption(_name, nil, MoreBuild.onBuildStoneFencePost, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_BrownCinder_Block_FencePost' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'walls_commercial_03_39'
  _sprite.northSprite = 'walls_commercial_03_39'

  _name = getText 'ContextMenu_GrayCinder_Block_FencePost'

  _option = subMenu[getText 'ContextMenu_Gray_Cinder_Block']:addOption(_name, nil, MoreBuild.onBuildStoneFencePost, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_GrayCinder_Block_FencePost' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'walls_commercial_01_55'
  _sprite.northSprite = 'walls_commercial_01_55'

  _name = getText 'ContextMenu_WhiteCinder_Block_FencePost'

  _option = subMenu[getText 'ContextMenu_White_CinderBlock']:addOption(_name, nil, MoreBuild.onBuildStoneFencePost, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_WhiteCinder_Block_FencePost' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'walls_exterior_house_01_39'
  _sprite.northSprite = 'walls_exterior_house_01_39'

  _name = getText 'ContextMenu_Red_BrickFence'

  _option = subMenu[getText 'ContextMenu_RedBrick_Wall']:addOption(_name, nil, MoreBuild.onBuildStoneFencePost, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_Red_BrickFence' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)
end

MoreBuild.onBuildWoodenFencePost = function(ignoreThisArgument, sprite, player, name)
  local _fencePost = ISWoodenWall:new(sprite.sprite, sprite.northSprite, nil)

  _fencePost.canPassThrough = true
  _fencePost.canBarricade = false
  _fencePost.isCorner = true
  _fencePost.player = player
  _fencePost.name = name

  _fencePost.modData['need:Base.Plank'] = 1
  _fencePost.modData['need:Base.Nails'] = 2
  _fencePost.modData['xp:Woodwork'] = 5
  _fencePost.modData['wallType'] = 'pillar'

  getCell():setDrag(_fencePost, player)
end

MoreBuild.onBuildStoneFencePost = function(ignoreThisArgument, sprite, player, name)
  local _fencePost = ISWoodenWall:new(sprite.sprite, sprite.northSprite, nil)

  _fencePost.canPassThrough = true
  _fencePost.canBarricade = false
  _fencePost.isCorner = true
  _fencePost.player = player
  _fencePost.name = name

  _fencePost.modData['need:Base.Plank'] = 2
  _fencePost.modData['need:Base.Nails'] = 2
  _fencePost.modData['xp:Woodwork'] = 5
  _fencePost.modData['wallType'] = 'pillar'

  function _fencePost:getHealth()
    return MoreBuild.healthLevel.stoneWall + buildUtil.getWoodHealth(self)
  end

  MoreBuild.equipToolPrimary(_fencePost, player, 'Hammer')

  getCell():setDrag(_fencePost, player)
end

MoreBuild.onBuildMetalFencePost = function(ignoreThisArgument, sprite, player, name)
  local _fencePost = ISWoodenWall:new(sprite.sprite, sprite.northSprite, nil)

  _fencePost.canPassThrough = true
  _fencePost.canBarricade = false
  _fencePost.isCorner = true
  _fencePost.player = player
  _fencePost.name = name

  _fencePost.modData['need:Base.SheetMetal'] = 1
  _fencePost.modData['need:Base.Screws'] = 2
  _fencePost.modData['xp:Woodwork'] = 5

  function _fencePost:getHealth()
    return MoreBuild.healthLevel.metalWall + buildUtil.getWoodHealth(self)
  end

  MoreBuild.equipToolPrimary(_fencePost, player, 'Screwdriver')

  getCell():setDrag(_fencePost, player)
end