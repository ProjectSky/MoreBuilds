ISGarageDoor = ISBuildingObject:derive('ISGarageDoor')

function ISGarageDoor:create(x, y, z, north, sprite)
  local cell = getWorld():getCell()
  local square = cell:getGridSquare(x, y, z)
  local xa, ya = self:getSquare2Pos(square, north)
  local xb, yb = self:getSquare3Pos(square, north)
  local spriteAName = self.sprite2
  local spriteBName = self.sprite3

  if self.north then
    spriteAName = self.northSprite2
    spriteBName = self.northSprite3
  end

  self:addDoorPart(x, y, z, north, sprite, 1)
  self:addDoorPart(xa, ya, z, north, spriteAName, 2)
  self:addDoorPart(xb, yb, z, north, spriteBName, 3)
end

function ISGarageDoor:addDoorPart(x, y, z, north, sprite, index)
  local cell = getWorld():getCell()
  self.sq = cell:getGridSquare(x, y, z)
  if self:partExists(self.sq, index) then
    return
  end
  self.javaObject = IsoDoor.new(cell, self.sq, sprite, north)
  self.javaObject:setHealth(self:getHealth())
  self.sq:AddSpecialObject(self.javaObject)

  local consumedItems = {}
  if index == 1 then
    consumedItems = buildUtil.consumeMaterial(self)
  end

  for _, item in ipairs(consumedItems) do
    if item:getType() == 'Doorknob' and item:getKeyId() ~= -1 then
      self.javaObject:setKeyId(item:getKeyId(), false)
    end
  end

  self.javaObject:transmitCompleteItemToServer()
end

function ISGarageDoor:getHealth()
	return 700 + buildUtil.getWoodHealth(self);
end

function ISGarageDoor:isValid(square)
  if not self:haveMaterial(square) then
    return false
  end
  if not square:hasFloor(self.north) then
    return false
  end
  if not self:partExists(square, 1) and not square:isFreeOrMidair(false) then
    return false
  end
  if square:isVehicleIntersecting() then
    return false
  end

  local xa, ya = self:getSquare2Pos(square, self.north)
  local xb, yb = self:getSquare3Pos(square, self.north)
  local squareA = getCell():getGridSquare(xa, ya, square:getZ())
  local squareB = getCell():getGridSquare(xb, yb, square:getZ())

  if (not squareA) or (not squareB) then
    return false
  end

  local existsA = self:partExists(squareA, 2)
  local existsB = self:partExists(squareB, 3)

  if not existsA and not buildUtil.canBePlace(self, squareA) then
    return false
  end
  if not existsB and not buildUtil.canBePlace(self, squareB) then
    return false
  end

  if square:getBuilding() or squareA:getBuilding() or squareB:getBuilding() then
    return false
  end

  if squareA:isSomethingTo(square) then
    return false
  end
  if squareB:isSomethingTo(squareA) then
    return false
  end

  if buildUtil.stairIsBlockingPlacement(square, true, self.north) then
    return false
  end
  if buildUtil.stairIsBlockingPlacement(squareA, true, self.north) then
    return false
  end
  if buildUtil.stairIsBlockingPlacement(squareB, true, self.north) then
    return false
  end

  return true
end

function ISGarageDoor:render(x, y, z, square)
  if not self:partExists(square, 1) then
    local spriteName = self:getSprite()
    local sprite = IsoSprite.new()
    sprite:LoadFramesNoDirPageSimple(spriteName)

    local spriteFree = ISBuildingObject.isValid(self, square) and not square:getBuilding()
    if buildUtil.stairIsBlockingPlacement(square, true, self.north) then
      spriteFree = false
    end
    if spriteFree then
      sprite:RenderGhostTile(x, y, z)
    else
      sprite:RenderGhostTileRed(x, y, z)
    end
  end

  local spriteAName = self.sprite2
  local spriteBName = self.sprite3
  local spriteCName = self.sprite4

  local spriteAFree = true
  local spriteBFree = true
  local spriteCFree = true

  local xa, ya = self:getSquare2Pos(square, self.north)
  local xb, yb = self:getSquare3Pos(square, self.north)

  if self.north then
    spriteName = self.northSprite
    spriteAName = self.northSprite2
    spriteBName = self.northSprite3
  end

  local squareA = getCell():getGridSquare(xa, ya, z)
  if squareA == nil and getWorld():isValidSquare(xa, ya, z) then
    squareA = IsoGridSquare.new(getCell(), nil, xa, ya, z)
    getCell():ConnectNewSquare(squareA, false)
  end
  local squareB = getCell():getGridSquare(xb, yb, z)
  if squareB == nil and getWorld():isValidSquare(xb, yb, z) then
    squareB = IsoGridSquare.new(getCell(), nil, xb, yb, z)
    getCell():ConnectNewSquare(squareB, false)
  end

  local existsA = self:partExists(squareA, 2)
  local existsB = self:partExists(squareB, 3)

  if not existsA and not buildUtil.canBePlace(self, squareA) then
    spriteAFree = false
  end
  if not existsB and not buildUtil.canBePlace(self, squareB) then
    spriteBFree = false
  end

  if squareA and (squareA:isSomethingTo(square) or buildUtil.stairIsBlockingPlacement(squareA, true, self.north) or squareA:getBuilding()) then
    spriteAFree = false
  end
  if squareB and (squareB:isSomethingTo(squareA) or buildUtil.stairIsBlockingPlacement(squareB, true, self.north) or squareB:getBuilding()) then
    spriteBFree = false
  end

  if not existsA then
    local spriteA = IsoSprite.new()
    spriteA:LoadFramesNoDirPageSimple(spriteAName)
    if spriteAFree then
      spriteA:RenderGhostTile(xa, ya, z)
    else
      spriteA:RenderGhostTileRed(xa, ya, z)
    end
  end
  if not existsB then
    local spriteB = IsoSprite.new()
    spriteB:LoadFramesNoDirPageSimple(spriteBName)
    if spriteBFree then
      spriteB:RenderGhostTile(xb, yb, z)
    else
      spriteB:RenderGhostTileRed(xb, yb, z)
    end
  end
end

function ISGarageDoor:getSquare2Pos(square, north)
  local x = square:getX()
  local y = square:getY()
  local z = square:getZ()
  if north then
    x = x + 1
  else
    y = y - 1
  end
  return x, y, z
end

function ISGarageDoor:getSquare3Pos(square, north)
  local x = square:getX()
  local y = square:getY()
  local z = square:getZ()
  if north then
    x = x + 2
  else
    y = y - 2
  end
  return x, y, z
end

function ISGarageDoor:partExists(square, index)
  local spriteName
  if self.north then
    if index == 1 then
      spriteName = self.northSprite
    elseif index == 2 then
      spriteName = self.northSprite2
    else
      spriteName = self.northSprite3
    end
  else
    if index == 1 then
      spriteName = self.sprite
    elseif index == 2 then
      spriteName = self.sprite2
    else
      spriteName = self.sprite3
    end
  end
  local objects = square:getSpecialObjects()
  for i = 1, objects:size() do
    local object = objects:get(i - 1)
    if IsoDoor.getGarageDoorIndex(object) == index and object:getNorth() == self.north and not object:IsOpen() and object:getSprite():getName() == spriteName then
      return true
    end
  end
  return false
end

function ISGarageDoor:new(sprite, spriteIndex)
  local o = {}
  setmetatable(o, self)
  self.__index = self
  o:init()
  o:setSprite(sprite .. spriteIndex)
  o.sprite2 = sprite .. spriteIndex + 1
  o.sprite3 = sprite .. spriteIndex + 2
  o.northSprite = sprite .. spriteIndex + 3
  o.northSprite2 = sprite .. spriteIndex + 4
  o.northSprite3 = sprite .. spriteIndex + 5
  o.thumpDmg = 5
  o.name = 'Garage Door'
  return o
end