if not getMoreBuildInstance then
  require('MoreBuildings/MoreBuilds_Main')
end

local MoreBuild = getMoreBuildInstance()

MoreBuild.stairsMenuBuilder = function(subMenu, player)
  local _sprite
  local _option
  local _tooltip
  local _name = ''

  MoreBuild.neededMaterials = {
    {
      Material = 'Base.Plank',
      Amount = 15
    },
    {
      Material = 'Base.Nails',
      Amount = 15
    }
  }

  MoreBuild.neededTools = {'Hammer'}

  local needSkills = {
    Woodwork = MoreBuild.skillLevel.stairsObject
  }

  _sprite = {}
  _sprite.upToLeft01 = 'fixtures_stairs_01_64'
  _sprite.upToLeft02 = 'fixtures_stairs_01_65'
  _sprite.upToLeft03 = 'fixtures_stairs_01_66'
  _sprite.upToRight01 = 'fixtures_stairs_01_72'
  _sprite.upToRight02 = 'fixtures_stairs_01_73'
  _sprite.upToRight03 = 'fixtures_stairs_01_74'
  _sprite.pillar = 'fixtures_stairs_01_70'
  _sprite.pillarNorth = 'fixtures_stairs_01_70'

  _name = getText 'ContextMenu_LightBrown_Stairs'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenStairs, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textStairsDescription .. _tooltip.description
  _tooltip:setTexture(_sprite.upToLeft01)

  _sprite = {}
  _sprite.upToLeft01 = 'fixtures_stairs_01_32'
  _sprite.upToLeft02 = 'fixtures_stairs_01_33'
  _sprite.upToLeft03 = 'fixtures_stairs_01_34'
  _sprite.upToRight01 = 'fixtures_stairs_01_40'
  _sprite.upToRight02 = 'fixtures_stairs_01_41'
  _sprite.upToRight03 = 'fixtures_stairs_01_42'
  _sprite.pillar = 'fixtures_stairs_01_38'
  _sprite.pillarNorth = 'fixtures_stairs_01_39'

  _name = getText 'ContextMenu_Brown_Stairs'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenStairs, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textStairsDescription .. _tooltip.description
  _tooltip:setTexture(_sprite.upToLeft01)

  _sprite = {}
  _sprite.upToLeft01 = 'fixtures_stairs_01_16'
  _sprite.upToLeft02 = 'fixtures_stairs_01_17'
  _sprite.upToLeft03 = 'fixtures_stairs_01_18'
  _sprite.upToRight01 = 'fixtures_stairs_01_24'
  _sprite.upToRight02 = 'fixtures_stairs_01_25'
  _sprite.upToRight03 = 'fixtures_stairs_01_26'
  _sprite.pillar = 'fixtures_stairs_01_22'
  _sprite.pillarNorth = 'fixtures_stairs_01_23'

  _name = getText 'ContextMenu_DarkBrown_Stairs'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenStairs, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textStairsDescription .. _tooltip.description
  _tooltip:setTexture(_sprite.upToLeft01)

  _sprite = {}
  _sprite.upToLeft01 = 'location_hospitality_sunstarmotel_01_40'
  _sprite.upToLeft02 = 'location_hospitality_sunstarmotel_01_41'
  _sprite.upToLeft03 = 'location_hospitality_sunstarmotel_01_42'
  _sprite.upToRight01 = 'location_hospitality_sunstarmotel_01_48'
  _sprite.upToRight02 = 'location_hospitality_sunstarmotel_01_49'
  _sprite.upToRight03 = 'location_hospitality_sunstarmotel_01_50'
  _sprite.pillar = 'location_hospitality_sunstarmotel_01_43'
  _sprite.pillarNorth = 'location_hospitality_sunstarmotel_01_51'

  _name = getText 'ContextMenu_WhiteMotel_Stairs'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenStairs, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textStairsDescription .. _tooltip.description
  _tooltip:setTexture(_sprite.upToLeft01)

  _sprite = {}
  _sprite.upToLeft01 = 'fixtures_stairs_01_48'
  _sprite.upToLeft02 = 'fixtures_stairs_01_49'
  _sprite.upToLeft03 = 'fixtures_stairs_01_50'
  _sprite.upToRight01 = 'fixtures_stairs_01_56'
  _sprite.upToRight02 = 'fixtures_stairs_01_57'
  _sprite.upToRight03 = 'fixtures_stairs_01_58'
  _sprite.pillar = 'location_hospitality_sunstarmotel_01_43'
  _sprite.pillarNorth = 'location_hospitality_sunstarmotel_01_51'

  _name = getText 'ContextMenu_WhiteIndustrial_Stairs'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenStairs, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textStairsDescription .. _tooltip.description
  _tooltip:setTexture(_sprite.upToLeft01)

  _sprite = {}
  _sprite.upToLeft01 = 'fixtures_stairs_01_19'
  _sprite.upToLeft02 = 'fixtures_stairs_01_20'
  _sprite.upToLeft03 = 'fixtures_stairs_01_21'
  _sprite.upToRight01 = 'fixtures_stairs_01_27'
  _sprite.upToRight02 = 'fixtures_stairs_01_28'
  _sprite.upToRight03 = 'fixtures_stairs_01_29'
  _sprite.pillar = 'fixtures_stairs_01_30'
  _sprite.pillarNorth = 'fixtures_stairs_01_31'

  _name = getText 'ContextMenu_Yellow_Stairs'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenStairs, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textStairsDescription .. _tooltip.description
  _tooltip:setTexture(_sprite.upToLeft01)

  MoreBuild.neededMaterials = {
    {
      Material = 'Base.SheetMetal',
      Amount = 10
    },
    {
      Material = 'Base.Screws',
      Amount = 15
    }
  }

  MoreBuild.neededTools = {'Hammer', 'Screwdriver'}

  _sprite = {}
  _sprite.upToLeft01 = 'fixtures_stairs_01_3'
  _sprite.upToLeft02 = 'fixtures_stairs_01_4'
  _sprite.upToLeft03 = 'fixtures_stairs_01_5'
  _sprite.upToRight01 = 'fixtures_stairs_01_11'
  _sprite.upToRight02 = 'fixtures_stairs_01_12'
  _sprite.upToRight03 = 'fixtures_stairs_01_13'
  _sprite.pillar = 'fixtures_stairs_01_14'
  _sprite.pillarNorth = 'fixtures_stairs_01_14'

  _name = getText 'ContextMenu_Metal_Stairs'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildMetalStairs, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = MoreBuild.textStairsDescription .. _tooltip.description
  _tooltip:setTexture(_sprite.upToLeft01)
end

MoreBuild.onBuildWoodenStairs = function(ignoreThisArgument, sprite, player, name)
  local _stairs = ISWoodenStairs:new(sprite.upToLeft01, sprite.upToLeft02, sprite.upToLeft03, sprite.upToRight01, sprite.upToRight02, sprite.upToRight03, sprite.pillar, sprite.pillarNorth)

  _stairs.isThumpable = false
  _stairs.player = player
  _stairs.name = name

  _stairs.modData['need:Base.Plank'] = 15
  _stairs.modData['need:Base.Nails'] = 15
  _stairs.modData['xp:Woodwork'] = 10

  getCell():setDrag(_stairs, player)
end

MoreBuild.onBuildMetalStairs = function(ignoreThisArgument, sprite, player, name)
  local _stairs = ISWoodenStairs:new(sprite.upToLeft01, sprite.upToLeft02, sprite.upToLeft03, sprite.upToRight01, sprite.upToRight02, sprite.upToRight03, sprite.pillar, sprite.pillarNorth)

  _stairs.isThumpable = false
  _stairs.player = player
  _stairs.name = name

  _stairs.modData['need:Base.SheetMetal'] = 10
  _stairs.modData['need:Base.Screws'] = 15
  _stairs.modData['xp:Woodwork'] = 15

  function _stairs:getHealth()
    return MoreBuild.healthLevel.metalStairs + buildUtil.getWoodHealth(self)
  end

  MoreBuild.equipToolPrimary(_stairs, player, 'Hammer')

  getCell():setDrag(_stairs, player)
end