require 'TimedActions/ISBaseTimedAction'

ISWindowObj = ISBuildingObject:derive('ISWindowObj')

function ISWindowObj:create(x, y, z, north, sprite)
  local cell = getWorld():getCell()
  local north = nil
  self.sq = cell:getGridSquare(x, y, z)
  local props = ISMoveableSpriteProps.new(getSprite(sprite))
  north = props.facing and (props.facing == "N" or props.facing == "S")
  self.javaObject = IsoWindow.new(getCell(), self.sq, getSprite(sprite), north)
  buildUtil.consumeMaterial(self)
  self.sq:AddSpecialObject(self.javaObject)
  self.javaObject:setIsLocked(false)
  self.javaObject:transmitCompleteItemToServer()
end

function ISWindowObj:isValid(square)
  if not self:haveMaterial(square) then return false end
	if square:isVehicleIntersecting() then return false end

  local sharedSprite = getSprite(self:getSprite())
  if sharedSprite then
		local props = ISMoveableSpriteProps.new(sharedSprite)
		return props:canPlaceMoveable("bogus", square, nil)
	end
end

function ISWindowObj:stop()
  if self.sound then
    getSoundManager():StopSound(self.sound)
  end

  ISBaseTimedAction.stop(self)
end

function ISWindowObj:perform()
  ISBaseTimedAction.perform(self)
end

function ISWindowObj:new(sprite, northSprite, player)
  local o = {}
  setmetatable(o, self)
  self.__index = self
  o:init()
  o:setSprite(sprite)
  o:setNorthSprite(northSprite)
  o.player = player
  o.canBarricade = true
  o.dismantable = true
  o.name = name
  o.stopOnWalk = true
  o.stopOnRun = true
  o.maxTime = 150
  return o
end

function ISWindowObj:render(x, y, z, square)
  ISBuildingObject.render(self, x, y, z, square)
end