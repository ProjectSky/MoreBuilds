require 'TimedActions/ISBaseTimedAction'

ISGenerator = ISBuildingObject:derive('ISGenerator')

function ISGenerator:create(x, y, z, north, sprite)
  local cell = getWorld():getCell()
  local perkLvl = getPlayer():getPerkLevel(Perks.Electricity)
  self.sq = cell:getGridSquare(x, y, z)
  self.javaObject = IsoGenerator.new(nil, getCell(), self.sq)
  self.javaObject:setCondition(perkLvl * 10 - ZombRand(0, 10))
  buildUtil.consumeMaterial(self)
  -- no need
  --self.javaObject:setActivated(false)
  --self.javaObject:setConnected(false)
  --self.javaObject:setFuel(0)
  --self.sq:AddSpecialObject(self.javaObject)
  --self.javaObject:transmitCompleteItemToServer()
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

function ISGenerator:onTimedActionStart(self)
  self:setActionAnim('Loot')
  self.character:SetVariable('LootPosition', 'Low')
end

function ISGenerator:stop()
  if self.sound then
    getSoundManager():StopSound(self.sound)
  end

  ISBaseTimedAction.stop(self)
end

function ISGenerator:perform()
  ISBaseTimedAction.perform(self)
end

function ISGenerator:render(x, y, z, square)
  ISBuildingObject.render(self, x, y, z, square)
end

function ISGenerator:new(sprite, northSprite, corner)
  local o = {}
  setmetatable(o, self)
  self.__index = self
  o:init()
  o:setSprite(sprite)
  o:setNorthSprite(northSprite)
  o.corner = corner
  o.name = 'Generator'
  o.stopOnWalk = true
  o.stopOnRun = true
  o.maxTime = 500
  return o
end
