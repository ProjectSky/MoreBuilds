--***********************************************************
--**                    ROBERT JOHNSON                     **
--***********************************************************
require 'TimedActions/ISBaseTimedAction'

ISStove = ISBuildingObject:derive('ISStove')

function ISStove:create(x, y, z, north, sprite)
    local cell = getWorld():getCell()
    self.sq = cell:getGridSquare(x, y, z)
    self.javaObject = IsoFireplace.new(getCell(), self.sq, getSprite(sprite))
    self.sq:AddSpecialObject(self.javaObject)
    buildUtil.consumeMaterial(self)
    self.javaObject:transmitCompleteItemToServer()
end

function ISStove:isValid(square)
    if not self:haveMaterial(square) then
        return false
    end
    if not buildUtil.canBePlace(self, square) then
        return false
    end
    if buildUtil.stairIsBlockingPlacement(square, true, (self.nSprite == 4 or self.nSprite == 2)) then
        return false
    end
    return square:isFreeOrMidair(false)
end

function ISStove:update()
end

function ISStove:stop()
    if self.sound then
        getSoundManager():StopSound(self.sound)
    end

    ISBaseTimedAction.stop(self)
end

function ISStove:start()
end

function ISStove:perform()
    ISBaseTimedAction.perform(self)
end

function ISStove:new(sprite, northSprite, corner)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o:init()
    o:setSprite(sprite)
    o:setNorthSprite(northSprite)
    o.corner = corner
    o.canBarricade = false
    o.dismantable = true
    o.name = name
    o.stopOnWalk = true
    o.stopOnRun = true
    o.maxTime = 500
    return o
end

function ISStove:render(x, y, z, square)
    ISBuildingObject.render(self, x, y, z, square)
end
