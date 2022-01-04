require "TimedActions/ISBaseTimedAction"

ISCraftTime = ISBaseTimedAction:derive("ISCraftTime");

function ISCraftTime:isValid()
	return true;
end

function ISCraftTime:update()
end

function ISCraftTime:stop()
	if self.sound then
		getSoundManager():StopSound(self.sound);
	end

	ISBaseTimedAction.stop(self);
end

function ISCraftTime:start()
end

function ISCraftTime:perform()
	local item = self.object;
	local player = getSpecificPlayer(0);
    local inv = player:getInventory();
	if item == "Bar Becue" then --BarBecue
		inv:Remove("SheetMetal");
		inv:Remove("SheetMetal");
		inv:Remove("Screws");
		inv:Remove("Screws");
		inv:Remove("Screws");
		inv:Remove("Screws");
		inv:Remove("Plank");
		inv:Remove("Plank");
		inv:Remove("Nails");
		inv:Remove("Nails");
		inv:Remove("Nails");
		inv:Remove("Nails");
		inv:AddItem("Morebuild.Barbecue");
	elseif item == "Wooden Windows" then --Wooden Windows
		inv:Remove("Plank");
		inv:Remove("Plank");
		inv:Remove("Plank");
		inv:Remove("Plank");
		inv:Remove("Screws");
		inv:Remove("Screws");
		inv:Remove("Screws");
		inv:Remove("Screws");
		inv:AddItem("Morebuild.WoodenWindows");
	elseif item == "White Tiled Windows" then --White Tiled Windows
		inv:Remove("Plank");
		inv:Remove("Plank");
		inv:Remove("Plank");
		inv:Remove("Plank");
		inv:Remove("Screws");
		inv:Remove("Screws");
		inv:Remove("Screws");
		inv:Remove("Screws");
		inv:AddItem("Morebuild.WhiteTiledWindows");
	elseif item == "Tiled Windows" then --Tiled Windows
		inv:Remove("Plank");
		inv:Remove("Plank");
		inv:Remove("Plank");
		inv:Remove("Plank");
		inv:Remove("Screws");
		inv:Remove("Screws");
		inv:Remove("Screws");
		inv:Remove("Screws");
		inv:AddItem("Morebuild.TiledWindows");
	elseif item == "White Windows" then --White Windows
		inv:Remove("Plank");
		inv:Remove("Plank");
		inv:Remove("Plank");
		inv:Remove("Plank");
		inv:Remove("Screws");
		inv:Remove("Screws");
		inv:Remove("Screws");
		inv:Remove("Screws");
		inv:AddItem("Morebuild.WhiteWindows");
	elseif item == "Chrome Windows" then --Chrome Windows
		inv:Remove("Plank");
		inv:Remove("Plank");
		inv:Remove("Plank");
		inv:Remove("Plank");
		inv:Remove("Screws");
		inv:Remove("Screws");
		inv:Remove("Screws");
		inv:Remove("Screws");
		inv:AddItem("Morebuild.ChromeWindows");
	elseif item == "Slider Windows" then --Slider Windows
		inv:Remove("Plank");
		inv:Remove("Plank");
		inv:Remove("Plank");
		inv:Remove("Plank");
		inv:Remove("Screws");
		inv:Remove("Screws");
		inv:Remove("Screws");
		inv:Remove("Screws");
		inv:AddItem("Morebuild.SliderWindows");
	elseif item == "Wood Barricade" then --Slider Windows
		inv:Remove("Plank");
		inv:Remove("Plank");
		inv:Remove("Nails");
		inv:Remove("Nails");
		inv:AddItem("Morebuild.Barricade");
	end
	ISBaseTimedAction.perform(self);
end

function ISCraftTime:new(_character, _object, _square)
	local o = {};
	setmetatable(o, self);
	self.__index = self;
	o.character = _character;
	o.object = _object;
	o.square = _square;
	o.stopOnWalk = true;
	o.stopOnRun = true;
	o.maxTime = 500;
	o.sound = nil;
	return o;
end