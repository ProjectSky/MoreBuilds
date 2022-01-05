require 'TimedActions/ISBaseTimedAction'

ISBarbecue = ISBuildingObject:derive('ISBarbecue')

function ISBarbecue:create(x, y, z, north, sprite)
  local cell = getWorld():getCell()
  self.sq = cell:getGridSquare(x, y, z)
  self.javaObject = IsoBarbecue.new(getCell(), self.sq, getSprite('appliances_cooking_01_35'))
  --self.javaObject:setFuelAmount(ZombRand(0,100));
  self.javaObject:setLit(false)
  self.sq:AddSpecialObject(self.javaObject)
  buildUtil.consumeMaterial(self)
  self.javaObject:transmitCompleteItemToServer()
end

function ISBarbecue:isValid(square)
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

function ISBarbecue:update()
end

function ISBarbecue:stop()
  if self.sound then
    getSoundManager():StopSound(self.sound)
  end

  ISBaseTimedAction.stop(self)
end

function ISBarbecue:start()
end

function ISBarbecue:perform()
  ISBaseTimedAction.perform(self)
end

function ISBarbecue:new(sprite, northSprite, corner)
  local o = {}
  setmetatable(o, self)
  self.__index = self
  o:init()
  o:setSprite(sprite)
  o:setNorthSprite(northSprite)
  o.corner = corner
  o.canBarricade = true
  o.dismantable = true
  o.name = name
  o.stopOnWalk = true
  o.stopOnRun = true
  o.maxTime = 500
  return o
end

function ISBarbecue:render(x, y, z, square)
  ISBuildingObject.render(self, x, y, z, square)
end