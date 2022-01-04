-- Survival Build Menu --
MoreBuild.SurvivalPostsMenuBuilder = function(subMenu, player)
	local _sprite = nil;
	local _option = nil;
	local _tooltip = nil;
	local _name = "";
	
-- Water Well --
	
	MoreBuild.neededMaterials =
	{	
		{
			Material = "Nails", Amount = 10, Text = getItemText("Nails"),
		},
		
		{
			Material = "Rope", Amount = 5, Text = getItemText("Rope"),
		},
		
		{
			Material = "Plank", Amount = 5, Text = getItemText("Plank"),
		},	
		
		{
			Material = "Gravelbag", Amount = 2, Text = getItemText("Gravel bag"),
		},		
		
		{
			Material = "BucketEmpty", Amount = 1, Text = getItemText("Bucket"),
		},
	};

	MoreBuild.neededTools = { "Hammer", "Spade", "Saw" };
	
	_sprite = {};
	_sprite.sprite = "morebuild_01_0";
	_sprite.northSprite = "morebuild_01_0";
	_sprite.corner = "morebuild_01_0";

	_name = getText "ContextMenu_Water_Well";

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildWaterWell, _sprite, player, _name, _icon);

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.shuijinObject, MoreBuild.ElectricityskillLevel.none, _option, player);
	_tooltip:setName(_name);
	_tooltip.description = getText "Tooltip_Water_Well" .. _tooltip.description;
	_tooltip:setTexture(_sprite.sprite);
	
-- Fridge --
	
	MoreBuild.neededMaterials =
	{
		{
			Material = "SheetMetal", Amount = 4, Text = getItemText("Sheet Metal"),
		},
        
		
		{
			Material = "Screws", Amount = 5, Text = getItemText("Screws"),
		},
		
		{
			Material = "ElectricWire", Amount = 2, Text = getItemText("Electric Wire"),
		},
        
        {
			Material = "ElectronicsScrap", Amount = 10, Text = getItemText("Electronics Scrap"),
		},
	};

	MoreBuild.neededTools = { "Hammer", "Screwdriver", "Saw" };
	
	_sprite = {};
	_sprite.sprite = "appliances_refrigeration_01_24";
	_sprite.northSprite = "appliances_refrigeration_01_25";
	_sprite.eastSprite = "appliances_refrigeration_01_26";
	_sprite.southSprite = "appliances_refrigeration_01_27";

	_name = getText "ContextMenu_Mini_Fridge";
	_icon = "fridge";

	_option = subMenu:addOption(_name, nil, MoreBuild.onBuildfridge, _sprite, player, _name, _icon);

	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.advancedContainer, MoreBuild.ElectricityskillLevel.fridge, _option, player);
	_tooltip:setName(_name);
	_tooltip.description = getText "Tooltip_minibingxiang" .. _tooltip.description .. MoreBuild.textCanRotate;
	_tooltip:setTexture(_sprite.sprite);
	
-- Barbecue --
	
	MoreBuild.neededMaterials =
	{
		{
			Material = "SheetMetal", Amount = 2, Text = getItemText("Sheet Metal"),
		},
		
		{
			Material = "Screws", Amount = 3, Text = getItemText("Screws"),
		},
		
		{
			Material = "Plank", Amount = 2, Text = getItemText("Plank"),
		},
	};
	
	MoreBuild.neededTools = { "Hammer", "Screwdriver" };

	_sprite = {};
	_sprite.sprite = "appliances_cooking_01_35"; --"construction_01_9";
	_sprite.northSprite = "appliances_cooking_01_35";
	_sprite.corner = "appliances_cooking_01_35";

	_name = getText "ContextMenu_Redgrill";
	_option = subMenu:addOption(_name, worldobjects, MoreBuild.onBuildBarbecue, _sprite, player, _name, _icon);
	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.shaokaojiaObject, MoreBuild.ElectricityskillLevel.none, _option, player);
	_tooltip:setName(_name);
	_tooltip.description = getText("Tooltip_shaokaojia") .. _tooltip.description;
	_tooltip:setTexture(_sprite.sprite);
	
-- Generator --
	
		MoreBuild.neededMaterials =
	{
		{
			Material = "ElectricWire", Amount = 2, Text = getItemText("Electric Wire"),
		},
		
		{
			Material = "Aluminum", Amount = 10, Text = getItemText("Aluminum"),
		},
		
		{
			Material = "SheetMetal", Amount = 4, Text = getItemText("Sheet Metal"),
		},
		
		{
			Material = "Screws", Amount = 10, Text = getItemText("Screws"),
		},
		
		{
			Material = "ElectronicsScrap", Amount = 100, Text = getItemText("Electronics Scrap"),
		},
	};
	
	MoreBuild.neededTools = { "Hammer", "Screwdriver", "Saw" };

	_sprite = {};
	_sprite.sprite = "appliances_misc_01_0";
	_sprite.northSprite = "appliances_misc_01_0";
	_sprite.corner = "appliances_misc_01_0";

	_name = getText "ContextMenu_Fuel_Generator";
	_option = subMenu:addOption(_name, worldobjects, MoreBuild.onBuildGenerator, _sprite, player, _name, _icon);
	_tooltip = MoreBuild.canBuildObject(MoreBuild.skillLevel.shaokaojiaObject, MoreBuild.ElectricityskillLevel.Generator, _option, player);
	_tooltip:setName(_name);
	_tooltip.description = getText("Tooltip_BuildGenerator") .. _tooltip.description;
	_tooltip:setTexture(_sprite.sprite);
	
-- Stove --
	
		MoreBuild.neededMaterials =
	{
		{
			Material = "SheetMetal", Amount = 6, Text = getItemText("Sheet Metal"),
		},
		
		{
			Material = "Nails", Amount = 20, Text = getItemText("Nails"),
		},
		
		{
			Material = "Screws", Amount = 10, Text = getItemText("Screws"),
		},
	};
	
	MoreBuild.neededTools = { "Hammer", "Screwdriver", "Saw" };

	_sprite = {};
	_sprite.sprite = "appliances_cooking_01_16";
	_sprite.northSprite = "appliances_cooking_01_17";

	_name = getText "ContextMenu_Fireplace";
	_option = subMenu:addOption(_name, worldobjects, MoreBuild.onBuildStove, _sprite, player, _name, _icon);
	_tooltip = MoreBuild.canBuildObject(7, 0, _option, player);
	_tooltip:setName(_name);
	_tooltip.description = getText("Tooltip_BuildStove") .. _tooltip.description .. MoreBuild.textCanRotate;
	_tooltip:setTexture(_sprite.sprite);
end