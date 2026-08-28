local NativePlacement = require('MoreBuildings/kinds/NativePlacement')

local Support = {}

function Support.joinFields(...)
  local fields = {}
  local seen = {}
  for argumentIndex = 1, select('#', ...) do
    for _, field in ipairs(select(argumentIndex, ...)) do
      if not seen[field] then
        fields[#fields + 1] = field
        seen[field] = true
      end
    end
  end
  return fields
end

Support.ROTATION_FIELDS = { 'sprite', 'northSprite', 'eastSprite', 'southSprite' }
Support.THUMPABLE_FIELDS = { 'health', 'healthFromCarpentry' }
Support.MULTI_FURNITURE_FIELDS = {
  'sprite', 'sprite2', 'sprite3', 'sprite4', 'sprite5', 'sprite6',
  'northSprite', 'northSprite2', 'northSprite3', 'northSprite4', 'northSprite5', 'northSprite6',
  'eastSprite', 'eastSprite2', 'eastSprite3', 'eastSprite4', 'eastSprite5', 'eastSprite6',
  'southSprite', 'southSprite2', 'southSprite3', 'southSprite4', 'southSprite5', 'southSprite6',
  'tileOffsets', 'northTileOffsets', 'eastTileOffsets', 'southTileOffsets',
}

function Support.requireFields(definition, fields)
  local data = definition.placement.data
  for _, field in ipairs(fields) do
    assert(data[field] ~= nil, 'missing placement.data.' .. field .. ': ' .. definition.id)
  end
end

function Support.requireSprites(definition, fields)
  local data = definition.placement.data
  for _, field in ipairs(fields) do
    local sprite = data[field]
    if sprite then
      assert(getSprite(sprite) ~= nil, 'missing placement sprite ' .. field .. ': ' .. definition.id)
    end
  end
end

function Support.configureCursor(cursor, definition, context, settings)
  local data = definition.placement.data
  cursor.definition = definition
  cursor.name = context.name
  cursor:setSprite(data.sprite or definition.previewSprite)
  cursor:setNorthSprite(data.northSprite or data.sprite or definition.previewSprite)
  cursor:setEastSprite(data.eastSprite)
  cursor:setSouthSprite(data.southSprite)
  cursor.corner = data.corner
  cursor.isWallLike = settings.isWallLike == true
  cursor.needToBeAgainstWall = data.needToBeAgainstWall == true
  cursor.buildLow = settings.buildLow == true
  cursor.canBeAlwaysPlaced = (settings.defaultAlwaysPlaced == true or data.canBeAlwaysPlaced == true) and data.canBeAlwaysPlaced ~= false
  cursor.isContainer = settings.isContainer == true
  cursor.containerType = data.containerType
  cursor.containerCapacity = data.containerCapacity
  cursor.canBeLockedByPadlock = settings.isContainer == true and data.canBeLockedByPadlock ~= false
  cursor.isDoor = false
  cursor.isDoorFrame = settings.isDoorFrame == true
  cursor.canPassThrough = settings.canPassThrough == true or data.canPassThrough == true
  cursor.canBarricade = false
  cursor.hoppable = settings.hoppable == true
  cursor.isThumpable = settings.defaultThumpable ~= false and data.isThumpable ~= false
  cursor.isCorner = settings.isCorner == true or data.isCorner == true
  cursor.canBePlastered = settings.canPlaster == true and context.player and context.player:getPerkLevel(Perks.Woodwork) > 6 or false
  cursor.thumpDmg = 8
  cursor.dontNeedFrame = false
  cursor.noNeedHammer = true
  cursor.dismantable = settings.dismantable == true
  cursor.blockAllTheSquare = (settings.defaultBlockAllTheSquare == true or data.blockAllTheSquare == true) and data.blockAllTheSquare ~= false
  cursor.dragNilAfterPlace = false
end

function Support.hasMatchingSprite(cursor, square)
  return square:getObjectWithSprite(cursor:getSprite()) ~= nil
end

function Support.hasStructuralPlacementBlocker(square)
  for index = 0, square:getObjects():size() - 1 do
    local object = square:getObjects():get(index)
    if not instanceof(object, 'IsoWorldInventoryObject')
      and not object:isFloor() and not object:isWall() then
      return true
    end
  end
  return false
end

local function wallSquareForFacing(square, facing)
  if facing == 'N' then
    return square:getTileInDirection(IsoDirections.S), true
  end
  if facing == 'W' then
    return square:getTileInDirection(IsoDirections.E), false
  end
  return square, facing == 'S'
end

local function supportingWall(square, facing)
  local wallSquare, north = wallSquareForFacing(square, facing)
  if wallSquare == nil then
    return nil
  end
  local wallProperty = north and 'WallN' or 'WallW'
  for index = 0, wallSquare:getObjects():size() - 1 do
    local object = wallSquare:getObjects():get(index)
    local properties = object:getProperties()
    if properties and (properties:has(wallProperty) or properties:has('WallNW')) then
      return object, wallSquare, north
    end
  end
  return nil
end

local function hasFireplacePlacementBlocker(square, supportingObject)
  for index = 0, square:getObjects():size() - 1 do
    local object = square:getObjects():get(index)
    if object ~= supportingObject then
      local properties = object:getProperties()
      local wall = properties and (
        properties:has('WallN')
        or properties:has('WallW')
        or properties:has('WallNW')
      )
      if (instanceof(object, 'IsoThumpable') and not object:isFloor() and not wall)
        or instanceof(object, 'IsoWindow')
        or instanceof(object, 'IsoDoor')
        or instanceof(object, 'IsoFireplace')
        or (properties and properties:has('BlocksPlacement')) then
        return true
      end
    end
  end
  return false
end

function Support.allowsDoorFrame(cursor, spriteName)
  local props = NativePlacement.getMoveableProps(spriteName or cursor:getSprite())
  return cursor.definition.placement.data.allowDoorFrame == true or (props ~= nil and props.isHigh)
end

function Support.hasRequiredWall(cursor, square, spriteName)
  local allowDoorFrame = Support.allowsDoorFrame(cursor, spriteName)
  local nativeResult = NativePlacement.hasRequiredWall(spriteName or cursor:getSprite(), square, allowDoorFrame)
  if nativeResult ~= nil then
    return nativeResult
  end
  if NativePlacement.isGarageDoorWall(square, not cursor.north) then
    return false
  end
  return square ~= nil and square:getWall(not cursor.north) ~= nil
end

local function isWallMountedProperties(properties)
  if properties == nil then
    return false
  end
  local moveType = properties:has('MoveType') and properties:get('MoveType') or nil
  return moveType == 'WallObject'
    or moveType == 'WallOverlay'
    or properties:has('attachedN')
    or properties:has('attachedW')
    or properties:has('attachedE')
    or properties:has('attachedS')
    or properties:has('IsHigh')
end

function Support.hasWallMountedPlacementConflict(square, spriteName)
  local targetProps = NativePlacement.getMoveableProps(spriteName)
  if square == nil
    or targetProps == nil
    or targetProps.facing == nil
    or not isWallMountedProperties(targetProps.spriteProps) then
    return false
  end

  for index = 0, square:getObjects():size() - 1 do
    local object = square:getObjects():get(index)
    local sprite = object:getSprite()
    local properties = sprite and sprite:getProperties() or nil
    if properties and properties:has('Facing') and properties:get('Facing') == targetProps.facing then
      if isWallMountedProperties(properties) then
        return true
      end
    end
  end
  return false
end

function Support.isWallDecorationValid(cursor, square, spriteName)
  spriteName = spriteName or cursor:getSprite()
  if square == nil or square:isVehicleIntersecting() or square:has(IsoFlagType.water) then
    return false
  end

  local nativeResult = NativePlacement.canPlaceSprite(
    spriteName,
    square,
    false,
    cursor.character,
    Support.allowsDoorFrame(cursor, spriteName)
  )
  if nativeResult == true then
    return not Support.hasWallMountedPlacementConflict(square, spriteName)
  end

  return not Support.hasWallMountedPlacementConflict(square, spriteName)
    and Support.hasRequiredWall(cursor, square, spriteName)
end

function Support.canPlaceAgainstWall(cursor, square)
  if square == nil or square:isVehicleIntersecting() or not square:getMovingObjects():isEmpty() then
    return false
  end

  if Support.hasMatchingSprite(cursor, square) then
    return false
  end

  local data = cursor.definition.placement.data
  local facing = ({ data.wallFacing, data.northWallFacing, data.eastWallFacing, data.southWallFacing })[cursor.nSprite]
  local wall, wallSquare, north = supportingWall(square, facing)
  return wall ~= nil
    and not NativePlacement.isGarageDoorWall(wallSquare, north)
    and not hasFireplacePlacementBlocker(square, wall)
end

function Support.isFurnitureValid(cursor, square)
  if square == nil then
    return false
  end
  local requiresWall = cursor.needToBeAgainstWall
  local spriteName = cursor:getSprite()
  local nativeResult = NativePlacement.canPlaceSprite(
    spriteName,
    square,
    false,
    cursor.character,
    Support.allowsDoorFrame(cursor, spriteName)
  )
  if nativeResult ~= nil then
    return nativeResult
      and not Support.hasWallMountedPlacementConflict(square, spriteName)
      and (not requiresWall or Support.hasRequiredWall(cursor, square, spriteName))
  end

  if cursor.canBeAlwaysPlaced then
    return not square:isVehicleIntersecting()
      and not Support.hasMatchingSprite(cursor, square)
      and not Support.hasWallMountedPlacementConflict(square, spriteName)
      and (not requiresWall or Support.hasRequiredWall(cursor, square))
  end

  if buildUtil.stairIsBlockingPlacement(square, true) then
    return false
  end
  return Support.canPlaceOnSquare(cursor, square, true)
    and not Support.hasWallMountedPlacementConflict(square, spriteName)
    and (not requiresWall or Support.hasRequiredWall(cursor, square))
end

local function hasFloorVolumeBlocker(square)
  for index = 0, square:getObjects():size() - 1 do
    local object = square:getObjects():get(index)
    local sprite = object:getSprite()
    local properties = sprite and sprite:getProperties() or nil
    if properties and properties:has('BlocksPlacement') then
      local highWallObject = properties:has('IsHigh')
        and properties:has('MoveType')
        and properties:get('MoveType') == 'WallObject'
      if not highWallObject then
        return true
      end
    end
  end
  return false
end

function Support.isFullSquareObjectValid(cursor, square)
  if square == nil
    or square:getFloor() == nil
    or square:isVehicleIntersecting()
    or not square:getMovingObjects():isEmpty()
    or hasFloorVolumeBlocker(square)
    or square:has(IsoFlagType.canBeCut)
    or square:has('tree')
    or square:has(IsoFlagType.water)
    or square:has(IsoFlagType.HoppableN)
    or square:has(IsoFlagType.HoppableW)
    or square:has(IsoFlagType.TallHoppableN)
    or square:has(IsoFlagType.TallHoppableW)
    or buildUtil.stairIsBlockingPlacement(square, true) then
    return false
  end
  return square:isFree(true) and not Support.hasMatchingSprite(cursor, square)
end

function Support.tableTopOffset(cursor, square)
  local props = NativePlacement.getMoveableProps(cursor:getSprite())
  assert(props ~= nil, 'missing Moveable properties: ' .. cursor.definition.id)
  local offsetY = props:getTotalTableHeight(square)
  if props.surface and props.surfaceIsOffset then
    return offsetY - props.surface
  end
  return offsetY
end

function Support.isNativeMoveableValid(cursor, square)
  return square ~= nil and NativePlacement.canPlaceSprite(cursor:getSprite(), square, false, cursor.character) == true
end

local function curtainOpeningSquare(square, facing)
  if facing == 'N' then
    return square:getTileInDirection(IsoDirections.S)
  end
  if facing == 'W' then
    return square:getTileInDirection(IsoDirections.E)
  end
  return square
end

local function hasCurtainOnOpening(square, north)
  local currentType = north and IsoObjectType.curtainN or IsoObjectType.curtainW
  if square:getCurtain(currentType) ~= nil then
    return true
  end

  local opposite = square:getTileInDirection(north and IsoDirections.N or IsoDirections.W)
  local oppositeType = north and IsoObjectType.curtainS or IsoObjectType.curtainE
  return opposite ~= nil and opposite:getCurtain(oppositeType) ~= nil
end

function Support.isCurtainValid(cursor, square)
  if square == nil or square:has(IsoFlagType.water) or square:isVehicleIntersecting() then
    return false
  end

  local props = NativePlacement.getMoveableProps(cursor:getSprite())
  if props == nil or props.facing == nil then
    return false
  end

  local openingSquare = curtainOpeningSquare(square, props.facing)
  if openingSquare == nil or openingSquare:isVehicleIntersecting() then
    return false
  end

  local north = props.facing == 'N' or props.facing == 'S'
  local opening = openingSquare:getWindow(north)
  if opening == nil and cursor.definition.placement.data.allowDoor then
    opening = openingSquare:getDoor(north)
  end
  return opening ~= nil and opening:HasCurtains() == nil and not hasCurtainOnOpening(openingSquare, north)
end

function Support.isWindowValid(cursor, square)
  if square == nil or square:has(IsoFlagType.water) or square:isVehicleIntersecting() then
    return false
  end

  local spriteName = cursor:getSprite()
  local props = NativePlacement.getMoveableProps(spriteName)
  if props == nil or props.type ~= 'Window' then
    return false
  end

  local north = props.facing == 'N' or props.facing == 'S'
  if square:getWindow(north) ~= nil then
    return false
  end

  -- Moveable placement forbids windows outdoors, which is appropriate when
  -- moving existing furniture but not when building a window into a frame.
  if NativePlacement.canPlaceSprite(spriteName, square, false, cursor.character) then
    return true
  end
  return props:getWallForFacing(square, north and 'S' or 'E', 'WindowFrame') ~= nil
end

function Support.keyIdFromRecordedItems(recordedItems)
  if recordedItems == nil then
    return nil
  end
  for index = 0, recordedItems:size() - 1 do
    local item = recordedItems:get(index)
    if item:getType() == 'Doorknob' and item:getKeyId() ~= -1 then
      return item:getKeyId()
    end
  end
end

function Support.lightBulbsFromRecordedItems(recordedItems)
  local bulbs = {}
  if recordedItems == nil then
    return bulbs
  end
  for index = 0, recordedItems:size() - 1 do
    local item = recordedItems:get(index)
    if string.sub(item:getType(), 1, 9) == 'LightBulb' then
      bulbs[#bulbs + 1] = item
    end
  end
  return bulbs
end

function Support.canPlaceOnSquare(cursor, square, blockedByCharacters)
  if square == nil or square:isVehicleIntersecting() then
    return false
  end
  return buildUtil.canBePlace(cursor, square) and square:isFreeOrMidair(blockedByCharacters)
end

function Support.isMultiTileSquareValid(cursor, square, allowWater, spriteName)
  if square == nil
    or square:getFloor() == nil
    or square:isVehicleIntersecting()
    or square:has(IsoFlagType.canBeCut)
    or square:has('tree')
    or (not allowWater and square:has(IsoFlagType.water))
    or square:has(IsoFlagType.HoppableN)
    or square:has(IsoFlagType.HoppableW)
    or square:has(IsoFlagType.TallHoppableN)
    or square:has(IsoFlagType.TallHoppableW)
    or buildUtil.stairIsBlockingPlacement(square, true) then
    return false
  end

  local nativeResult = NativePlacement.canPlaceSprite(spriteName or cursor:getSprite(), square, true, cursor.character)
  if nativeResult ~= nil then
    return nativeResult
  end
  return Support.canPlaceOnSquare(cursor, square, false)
end

function Support.isAttachedFloorValid(cursor, square)
  if square == nil
    or not square:connectedWithFloor()
    or square:getObjectWithSprite(cursor:getSprite()) ~= nil then
    return false
  end
  for index = 0, square:getObjects():size() - 1 do
    local object = square:getObjects():get(index)
    local sprite = object:getSprite()
    if object:getModData().MoreBuildsDefinitionId
      and sprite
      and sprite:getProperties():has(IsoFlagType.attachedFloor) then
      return false
    end
  end
  return true
end

function Support.healthFor(cursor)
  local data = cursor.definition.placement.data
  if data.healthFromCarpentry then
    return data.health + buildUtil.getWoodHealth(cursor)
  end
  return data.health
end

function Support.prepare(cursor, square, context, validator)
  assert(validator(cursor, square, context), 'invalid MoreBuilds placement: ' .. context.definition.id)
  return {
    definition = context.definition,
    north = cursor.north,
    square = square,
  }
end

return Support
