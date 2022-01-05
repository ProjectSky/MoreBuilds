require 'TimedActions/ISBaseTimedAction'

ISWindow = ISBuildingObject:derive('ISWindow')

function ISWindow:create(x, y, z, north, sprite)
  local cell = getWorld():getCell()
  local direction = nil
  self.sq = cell:getGridSquare(x, y, z)
  for i = 0, self.sq:getObjects():size() - 1 do
    local obj = self.sq:getObjects():get(i)
    local prop = obj:getSprite():getProperties()
    if prop:Is(IsoFlagType.WindowW) then
      direction = false
    elseif prop:Is(IsoFlagType.WindowN) then
      direction = true
    end
  end
  self.javaObject = IsoWindow.new(getCell(), self.sq, getSprite(sprite), direction)
  self.sq:AddSpecialObject(self.javaObject)
  buildUtil.consumeMaterial(self)
  self.javaObject:setIsLocked(false)
  self.javaObject:transmitCompleteItemToServer()
end

function ISWindow:isValid(square)
  local direction = nil
  for i = 0, square:getObjects():size() - 1 do
    local obj = square:getObjects():get(i)
    local prop = obj:getSprite():getProperties()
    if instanceof(obj, 'IsoWindow') or instanceof(obj, 'IsoBarricade') then
      return false
    end
  end
  local props = getSprite(self:getSprite()):getProperties()
  if (props:Val('Facing') == 'N') then
    direction = 'S'
  elseif (props:Val('Facing') == 'W') then
    direction = 'E'
  end
  return ISMoveableSpriteProps:getWallForFacing(square, direction, 'WindowFrame')
end

function ISWindow:update()
end

function ISWindow:stop()
  if self.sound then
    getSoundManager():StopSound(self.sound)
  end

  ISBaseTimedAction.stop(self)
end

function ISWindow:start()
end

function ISWindow:perform()
  ISBaseTimedAction.perform(self)
end

function ISWindow:new(sprite, northSprite, corner)
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
  o.maxTime = 150
  return o
end

function ISWindow:render(x, y, z, square)
  ISBuildingObject.render(self, x, y, z, square)
end