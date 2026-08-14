require 'Moveables/ISMoveableSpriteProps'

local NativePlacement = {}
local placementCharacter = {}
local moveablePropsCache = {}

function placementCharacter:getSquare()
  return self.square
end

local function haveMaterial()
  return true
end

local function nativeClass(name)
  local class = _G[name]
  assert(class ~= nil, 'native placement class is unavailable: ' .. name)
  return class
end

local function validateWithoutMaterials(cursor, square, validator)
  if square == nil then
    return false
  end
  local originalHaveMaterial = cursor.haveMaterial
  cursor.haveMaterial = haveMaterial
  local valid = validator(cursor, square)
  cursor.haveMaterial = originalHaveMaterial
  return valid
end

function NativePlacement.getMoveableProps(spriteName)
  local cached = moveablePropsCache[spriteName]
  if cached ~= nil then
    return cached or nil
  end
  local sprite = getSprite(spriteName)
  if sprite == nil then
    moveablePropsCache[spriteName] = false
    return nil
  end
  local props = ISMoveableSpriteProps.new(sprite)
  if not props.isMoveable then
    moveablePropsCache[spriteName] = false
    return nil
  end
  moveablePropsCache[spriteName] = props
  return props
end

function NativePlacement.canPlaceSprite(spriteName, square, forceTypeObject, character, allowDoorFrame)
  local props = NativePlacement.getMoveableProps(spriteName)
  if props == nil then
    return nil
  end
  if square == nil or square:has(IsoFlagType.water) then
    return false
  end
  if (props.type == 'WallObject' or props.type == 'WallOverlay')
    and NativePlacement.isGarageDoorForFacing(spriteName, square) then
    return false
  end
  -- A non-player context preserves WindowObject geometry without applying Moveable skill and item requirements.
  placementCharacter.square = character and character:getSquare() or square
  local originalAllowDoorFrame = props.allowDoorFrame
  if allowDoorFrame then
    props.allowDoorFrame = true
  end
  local canPlace = props:canPlaceMoveableInternal(placementCharacter, square, nil, forceTypeObject == true)
  props.allowDoorFrame = originalAllowDoorFrame
  return not not canPlace
end

local function wallSquareForFacing(square, facing)
  if facing == 'N' then
    return square and square:getTileInDirection(IsoDirections.S)
  end
  if facing == 'W' then
    return square and square:getTileInDirection(IsoDirections.E)
  end
  return square
end

local function hasGarageDoorProperty(object)
  if object and instanceof(object, 'IsoDoor') and IsoDoor.getGarageDoorIndex(object) ~= -1 then
    return true
  end
  local sprite = object and object:getSprite()
  local properties = sprite and sprite:getProperties() or nil
  return properties ~= nil and properties:has('GarageDoor')
end

function NativePlacement.isGarageDoorWall(square, north)
  local wall = square and square:getWall(north)
  return hasGarageDoorProperty(wall)
end

function NativePlacement.isGarageDoorForFacing(spriteName, square)
  local sprite = getSprite(spriteName)
  local properties = sprite and sprite:getProperties() or nil
  local facing = properties and properties:has('Facing') and properties:get('Facing') or nil
  if facing == nil then
    return false
  end
  local wallSquare = wallSquareForFacing(square, facing)
  if wallSquare == nil then
    return false
  end
  for index = 0, wallSquare:getObjects():size() - 1 do
    if hasGarageDoorProperty(wallSquare:getObjects():get(index)) then
      return true
    end
  end
  return false
end

function NativePlacement.hasRequiredWall(spriteName, square, allowDoorFrame)
  if NativePlacement.isGarageDoorForFacing(spriteName, square) then
    return false
  end
  local props = NativePlacement.getMoveableProps(spriteName)
  if props == nil or props.facing == nil then
    return nil
  end
  local mode = allowDoorFrame and 'WallAndDoor' or 'Wall'
  local wall = props:getWallForFacing(square, props.facing, mode)
  if wall == nil then
    return false
  end
  local wallSprite = wall:getSprite()
  local wallProperties = wallSprite and wallSprite:getProperties() or nil
  return not (wallProperties and wallProperties:has('GarageDoor'))
end

function NativePlacement.canPlaceSpriteGrid(spriteName, square, character)
  local props = NativePlacement.getMoveableProps(spriteName)
  if props == nil or not props.isMultiSprite then
    return nil
  end
  if square == nil or square:has(IsoFlagType.water) then
    return false
  end

  local spriteGrid = props.sprite:getSpriteGrid()
  if spriteGrid == nil then
    return false
  end
  local originX = square:getX() - spriteGrid:getSpriteGridPosX(props.sprite)
  local originY = square:getY() - spriteGrid:getSpriteGridPosY(props.sprite)
  local originZ = square:getZ()
  local origin = getCell():getGridSquare(originX, originY, originZ)
  local gridInfo = origin and props:getSpriteGridInfo(origin, false) or nil
  if gridInfo == nil then
    return false
  end

  placementCharacter.square = character and character:getSquare() or square
  for _, member in ipairs(gridInfo) do
    if member.square == nil
      or member.square:has(IsoFlagType.water)
      or not props:canPlaceMoveableInternal(placementCharacter, member.square, nil) then
      return false
    end
  end
  return not props:isWallBetweenParts(spriteGrid, originX, originY, originZ)
end

function NativePlacement.hasWallBetweenParts(square, parts)
  for firstIndex = 1, #parts do
    local first = parts[firstIndex]
    local firstSquare = getCell():getGridSquare(square:getX() + first.x, square:getY() + first.y, square:getZ())
    if firstSquare then
      for secondIndex = firstIndex + 1, #parts do
        local second = parts[secondIndex]
        if math.abs(first.x - second.x) + math.abs(first.y - second.y) == 1 then
          local secondSquare = getCell():getGridSquare(square:getX() + second.x, square:getY() + second.y, square:getZ())
          if secondSquare and firstSquare:isSomethingTo(secondSquare) then
            return true
          end
        end
      end
    end
  end
  return false
end

function NativePlacement.isFloorValid(cursor, square)
  return validateWithoutMaterials(cursor, square, nativeClass('ISWoodenFloor').isValid)
end

function NativePlacement.isWallValid(cursor, square)
  return validateWithoutMaterials(cursor, square, nativeClass('ISWoodenWall').isValid)
end

function NativePlacement.isFrameValid(cursor, square)
  return validateWithoutMaterials(cursor, square, nativeClass('ISWoodenDoorFrame').isValid)
end

function NativePlacement.isDoorValid(cursor, square)
  return validateWithoutMaterials(cursor, square, nativeClass('ISWoodenDoor').isValid)
end

function NativePlacement.configureStairsCursor(cursor)
  local stairs = nativeClass('ISWoodenStairs')
  cursor.getSquare2Pos = stairs.getSquare2Pos
  cursor.getSquare3Pos = stairs.getSquare3Pos
  cursor.getSquareTopPos = stairs.getSquareTopPos
end

function NativePlacement.isStairsValid(cursor, square)
  return validateWithoutMaterials(cursor, square, nativeClass('ISWoodenStairs').isValid)
end

return NativePlacement
