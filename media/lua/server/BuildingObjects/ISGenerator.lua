--***********************************************************
--**                       Sky_Orc_Mm	                   **
--***********************************************************
require 'TimedActions/ISBaseTimedAction'

ISGenerator = ISBuildingObject:derive('ISGenerator')

--************************************************************************--
--** ISGenerator:new
--**
--************************************************************************--
function ISGenerator:create(x, y, z, north, sprite)
    local cell = getWorld():getCell()
    local ESkill = getPlayer():getPerkLevel(Perks.Electricity)
    self.sq = cell:getGridSquare(x, y, z)
    self.javaObject = IsoGenerator.new(nil, getCell(), self.sq)
    self.javaObject:setActivated(false)
    self.javaObject:setCondition(ESkill * 10 - ZombRand(0, 10))
    self.javaObject:setConnected(false)
    self.javaObject:setFuel(0)
    self.sq:AddSpecialObject(self.javaObject)
    buildUtil.consumeMaterial(self)
    self.javaObject:transmitCompleteItemToServer()
end

function ISGenerator:isValid(square)
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

function ISGenerator:update()
end

function ISGenerator:stop()
    if self.sound then
        getSoundManager():StopSound(self.sound)
    end

    ISBaseTimedAction.stop(self)
end

function ISGenerator:start()
end

function ISGenerator:perform()
    ISBaseTimedAction.perform(self)
end

function ISGenerator:new(sprite, northSprite, corner)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o:init()
    o:setSprite(sprite)
    o:setNorthSprite(northSprite)
    o.corner = corner
    o.canBarricade = true
    o.name = 'Generator'
    o.stopOnWalk = true
    o.stopOnRun = true
    o.maxTime = 5000
    return o
end

function ISGenerator:render(x, y, z, square)
    ISBuildingObject.render(self, x, y, z, square)
end
