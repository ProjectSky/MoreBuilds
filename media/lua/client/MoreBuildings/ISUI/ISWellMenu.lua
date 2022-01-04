--
-- Created by IntelliJ IDEA.
-- User: ProjectSky
-- Date: 2016/12/12
-- Time: 22:13
-- Do Well WaterAmount Menu.
--
function DoWellMenu(player, context, worldobjects)
    local WellWater;

    for i, v in ipairs(worldobjects) do
        local spriteName = v:getSprite():getName()

        if spriteName == "morebuild_01_0" then
            WellWaterAmount = v:getWaterAmount();
            objx = v:getX()
            objy = v:getY()
            WellWater = v;
        end
    end
    if WellWater and getSpecificPlayer(player):DistToSquared(objx + 0.5, objy + 0.5) < 2 * 2 then
        local _option = context:addOption(getText("ContextMenu_Water_Well"), worldobjects, nil)
        _option.toolTip = ISToolTip:new();
        _option.toolTip:initialise();
        _option.toolTip:setVisible(false);
        _option.toolTip:setName(getText("ContextMenu_Water_Well"));
        _option.toolTip.description = getText("Tooltip_WaterAmount") .. WellWaterAmount;
        _option.toolTip:setTexture("morebuild_01_0");
    end
end

Events.OnFillWorldObjectContextMenu.Add(DoWellMenu);