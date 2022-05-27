if not getMoreBuildInstance then
  require('MoreBuildings/MoreBuilds_Main')
end

local MoreBuild = getMoreBuildInstance()

MoreBuild.SurvivalMenuBuilder = function(subMenu, player)
  local _sprite = nil
  local _option = nil
  local _tooltip = nil
  local _name = ''

  -- Water Well --

  MoreBuild.neededMaterials = {
    {
      Material = 'Base.Nails',
      Amount = 10
    },
    {
      Material = 'Base.Rope',
      Amount = 5
    },
    {
      Material = 'Base.Plank',
      Amount = 5
    },
    {
      Material = 'Base.Gravelbag',
      Amount = 2
    },
    {
      Material = 'Base.BucketEmpty',
      Amount = 1
    }
  }

  MoreBuild.neededTools = {'Hammer', 'Shovel', 'Saw'}

  local needSkills = {
    Woodwork = MoreBuild.skillLevel.waterwellObject,
  }

  _sprite = {}
  _sprite.sprite = 'morebuild_01_0'
  _sprite.northSprite = 'morebuild_01_0'

  _name = getText 'ContextMenu_Water_Well'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWaterWell, player, _sprite.sprite, nil)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText('Tooltip_Water_Well', SandboxVars.MoreBuilds.MaxWaterWallStorageAmount) .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  -- Fridge --

  MoreBuild.neededMaterials = {
    {
      Material = 'Base.SheetMetal',
      Amount = 4
    },
    {
      Material = 'Base.Screws',
      Amount = 5
    },
    {
      Material = 'Radio.ElectricWire',
      Amount = 2
    },
    {
      Material = 'Base.ElectronicsScrap',
      Amount = 10
    }
  }

  MoreBuild.neededTools = {'Hammer', 'Screwdriver', 'Saw'}

  local needSkills = {
    Woodwork = MoreBuild.skillLevel.advancedContainer,
    Electricity = MoreBuild.skillLevel.fridgeObject,
    MetalWelding = 1
  }

  _sprite = {}
  _sprite.sprite = 'appliances_refrigeration_01_24'
  _sprite.northSprite = 'appliances_refrigeration_01_25'
  _sprite.eastSprite = 'appliances_refrigeration_01_26'
  _sprite.southSprite = 'appliances_refrigeration_01_27'

  _name = MoreBuild.getMoveableDisplayName(_sprite.sprite)

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildfridge, _sprite, player, _name, 'fridge')

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_Mini_Fridge' .. _tooltip.description .. MoreBuild.textCanRotate
  _tooltip:setTexture(_sprite.sprite)

  -- Barbecue --

  MoreBuild.neededMaterials = {
    {
      Material = 'Base.SheetMetal',
      Amount = 2
    },
    {
      Material = 'Base.Screws',
      Amount = 3
    },
    {
      Material = 'Base.Plank',
      Amount = 2
    }
  }

  MoreBuild.neededTools = {'Hammer', 'Screwdriver'}

  local needSkills = {
    Woodwork = MoreBuild.skillLevel.barbecueObject,
    MetalWelding = 3
  }

  _sprite = {}
  _sprite.sprite = 'appliances_cooking_01_35'
  _sprite.northSprite = 'appliances_cooking_01_35'

  _name = MoreBuild.getMoveableDisplayName(_sprite.sprite)
  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildBarbecue, _sprite, player, _name)
  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText('Tooltip_Barbecue') .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  -- Generator --

  MoreBuild.neededMaterials = {
    {
      Material = 'Radio.ElectricWire',
      Amount = 2
    },
    {
      Material = 'Base.Aluminum',
      Amount = 10
    },
    {
      Material = 'Base.SheetMetal',
      Amount = 4
    },
    {
      Material = 'Base.Screws',
      Amount = 10
    },
    {
      Material = 'Base.ElectronicsScrap',
      Amount = 100
    }
  }

  MoreBuild.neededTools = {'Screwdriver', 'Saw'}

  local needSkills = {
    Woodwork = MoreBuild.skillLevel.barbecueObject,
    Electricity = MoreBuild.skillLevel.generatorObject,
    MetalWelding = MoreBuild.skillLevel.generatorObject
  }

  _sprite = {}
  _sprite.sprite = 'appliances_misc_01_0'
  _sprite.northSprite = 'appliances_misc_01_0'

  local perk = MoreBuild.playerSkills['Electricity']

  _name = getText 'ContextMenu_Fuel_Generator'
  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildGenerator, _sprite, perk, _name, player)
  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText('Tooltip_Fuel_Generator') .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  -- Fireplace --

  MoreBuild.neededMaterials = {
    {
      Material = 'Base.SheetMetal',
      Amount = 6
    },
    {
      Material = 'Base.Nails',
      Amount = 20
    },
    {
      Material = 'Base.Screws',
      Amount = 10
    }
  }

  MoreBuild.neededTools = {'Hammer', 'Screwdriver'}

  local needSkills = {
    Woodwork = 7
  }

  _sprite = {}
  _sprite.sprite = 'appliances_cooking_01_17'
  _sprite.northSprite = 'appliances_cooking_01_16'

  _name = MoreBuild.getMoveableDisplayName(_sprite.sprite)
  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildStove, _sprite, player, _name)
  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText('Tooltip_Stove') .. _tooltip.description .. MoreBuild.textCanRotate
  _tooltip:setTexture(_sprite.sprite)

  MoreBuild.neededMaterials = {
    {
      Material = 'Base.Stone',
      Amount = 10
    },
    {
      Material = 'Base.Dirtbag',
      Amount = 1
    },
    {
      Material = 'Base.BucketWaterFull',
      Amount = 1
    }
  }

  MoreBuild.neededTools = {'Hammer', 'HandShovel'}

  _sprite = {}
  _sprite.sprite = 'fixtures_fireplaces_01_0'
  _sprite.northSprite = 'fixtures_fireplaces_01_3'

  _name = getText 'ContextMenu_Fireplace'
  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildFireplace, _sprite, player, _name)
  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText('Tooltip_Stove') .. _tooltip.description .. MoreBuild.textCanRotate
  _tooltip:setTexture(_sprite.sprite)
end

MoreBuild.onBuildBarbecue = function(ignoreThisArgument, sprite, player, name)
  local _Barbecue = ISBarbecue:new(sprite.sprite, sprite.northSprite, player)
  _Barbecue.player = player
  _Barbecue.name = name

  _Barbecue.modData['need:Base.Plank'] = 2
  _Barbecue.modData['need:Base.SheetMetal'] = 2
  _Barbecue.modData['need:Base.Screws'] = 3
  _Barbecue.modData['xp:Woodwork'] = 5
  getCell():setDrag(_Barbecue, player)
end

MoreBuild.onBuildGenerator = function(ignoreThisArgument, sprite, perk, name, player)
  local _Generator = ISGenerator:new(sprite.sprite, sprite.northSprite, perk)
  _Generator.player = player
  _Generator.name = name
  _Generator.completionSound = "BuildMetalStructureSmallScrap"
  _Generator.craftingBank = "BlowTorch"
  _Generator.noNeedHammer = true
  _Generator.actionAnim = "BlowTorchMid"

  _Generator.modData['need:Radio.ElectricWire'] = 2
  _Generator.modData['need:Base.Aluminum'] = 10
  _Generator.modData['need:Base.SheetMetal'] = 4
  _Generator.modData['need:Base.Screws'] = 10
  _Generator.modData['need:Base.ElectronicsScrap'] = 100
  _Generator.modData['xp:Woodwork'] = 10
  _Generator.modData['xp:Electricity'] = 25
  getCell():setDrag(_Generator, player)
end

MoreBuild.onBuildWaterWell = function(ignoreThisArgument, player, sprite, waterMax)
  local _WaterWell = ISWaterWell:new(player, sprite, SandboxVars.MoreBuilds.MaxWaterWallStorageAmount) --waterMax
  _WaterWell.player = player

  _WaterWell.modData['need:Base.Nails'] = 10
  _WaterWell.modData['need:Base.Rope'] = 5
  _WaterWell.modData['need:Base.Plank'] = 5
  _WaterWell.modData['need:Base.Gravelbag'] = 2
  _WaterWell.modData['need:Base.BucketEmpty'] = 1
  _WaterWell.modData['xp:Woodwork'] = 50
  _WaterWell.modData['IsWaterWell'] = true
  getCell():setDrag(_WaterWell, player)
end

MoreBuild.onBuildfridge = function(ignoreThisArgument, sprite, player, name, icon)
  local _fridge = ISWoodenContainer:new(sprite.sprite, sprite.northSprite)

  _fridge.renderFloorHelper = false
  _fridge.canBeAlwaysPlaced = false
  _fridge.canBeLockedByPadlock = true
  _fridge.player = player
  _fridge.name = name

  if sprite.eastSprite then
    _fridge:setEastSprite(sprite.eastSprite)
  end

  if sprite.southSprite then
    _fridge:setSouthSprite(sprite.southSprite)
  end

  _fridge.modData['need:Base.SheetMetal'] = 4
  _fridge.modData['need:Base.Screws'] = 5
  _fridge.modData['need:Radio.ElectricWire'] = 2
  _fridge.modData['need:Base.ElectronicsScrap'] = 10
  _fridge.modData['xp:Woodwork'] = 30
  _fridge.modData['xp:Electricity'] = 5

  MoreBuild.equipToolPrimary(_fridge, player, 'Screwdriver')

  function _fridge:getHealth()
    self.javaObject:getContainer():setType(icon)
    return MoreBuild.healthLevel.metalContainer + buildUtil.getWoodHealth(self)
  end

  getCell():setDrag(_fridge, player)
end

MoreBuild.onBuildStove = function(ignoreThisArgument, sprite, player, name)
  local _stove = ISStove:new(sprite.sprite, sprite.northSprite, player)

  _stove.player = player
  _stove.name = name

  _stove.modData['need:Base.SheetMetal'] = 6
  _stove.modData['need:Base.Nails'] = 20
  _stove.modData['need:Base.Screws'] = 10
  _stove.modData['xp:Woodwork'] = 15

  getCell():setDrag(_stove, player)
end

MoreBuild.onBuildFireplace = function(ignoreThisArgument, sprite, player, name)
  local _fireplace = ISStove:new(sprite.sprite, sprite.northSprite, player)

  _fireplace.player = player
  _fireplace.name = name

  _fireplace.modData['need:Base.Stone'] = 10
  _fireplace.modData['use:Base.Dirtbag'] = 1
  _fireplace.modData['use:Base.BucketWaterFull'] = 25
  _fireplace.modData['xp:Woodwork'] = 15

  getCell():setDrag(_fireplace, player)
end

--[[
MoreBuild.doWaterWellInfo = function(player, context, worldobjects)
  local waterwell
  local amount

  for _, v in ipairs(worldobjects) do
    local modData = v:getModData()

    if modData['IsWaterWell'] then
      amount = v:getWaterAmount()
      waterwell = v
    end
  end

  if waterwell and getSpecificPlayer(player):DistToSquared(waterwell:getX() + 0.5, waterwell:getY() + 0.5) < 2 * 2 then
    local _option = context:addOption(getText('ContextMenu_Water_Well'), worldobjects, nil)
    _option.toolTip = ISToolTip:new()
    _option.toolTip:initialise()
    _option.toolTip:setVisible(false)
    --_option.toolTip:setName(getText('ContextMenu_Water_Well'))
    _option.toolTip.description = getText('Tooltip_WaterAmount', amount)
    --_option.toolTip:setTexture('morebuild_01_0')
  end
end
--]]

local function DoSpecialWellTooltip(tooltipUI, square)
	local playerObj = getSpecificPlayer(0)
	if not playerObj or playerObj:getPerkLevel(Perks.Woodwork) < 4 or playerObj:getZ() ~= square:getZ() or
			playerObj:DistToSquared(square:getX() + 0.5, square:getY() + 0.5) > 2 * 2 then
		return
	end
	
	local waterwell = ISWaterWell.findObject(square)
	if not waterwell or not waterwell:getModData()["waterMax"] then return end

	local smallFontHgt = getTextManager():getFontFromEnum(UIFont.Small):getLineHeight()
	tooltipUI:setHeight(6 + smallFontHgt + 6 + smallFontHgt + 12)

	local textX = 12
	local textY = 6 + smallFontHgt + 6
	tooltipUI:DrawTextureScaledColor(nil, 0, 0, tooltipUI:getWidth(), tooltipUI:getHeight(), 0, 0, 0, 0.75)
	tooltipUI:DrawTextCentre(getText("ContextMenu_Water_Well"), tooltipUI:getWidth() / 2, 6, 1, 1, 1, 1)
	tooltipUI:DrawText(getText('Tooltip_WaterAmount', waterwell:getWaterAmount()), textX, textY, 1, 1, 1, 1)
end

Events.DoSpecialTooltip.Add(DoSpecialWellTooltip)