local KindFactory = require('MoreBuildings/kinds/KindFactory')
local NativePlacement = require('MoreBuildings/kinds/NativePlacement')
local Support = require('MoreBuildings/kinds/Support')

local MultiTileKinds = {}

local function furnitureNorth(cursor)
  return cursor.nSprite == 2 or cursor.nSprite == 4
end

local furniturePartsCache = {}

local function furnitureDirectionFields(data, nSprite)
  if nSprite == 2 then
    return 'northSprite', 'northTileOffsets'
  end
  if nSprite == 3 and data.eastSprite then
    return 'eastSprite', 'eastTileOffsets'
  end
  if nSprite == 4 then
    if data.southSprite then
      return 'southSprite', 'southTileOffsets'
    end
    return 'northSprite', 'northTileOffsets'
  end
  return 'sprite', 'tileOffsets'
end

local function spriteGridParts(spriteName)
  local sprite = getSprite(spriteName)
  local spriteGrid = sprite:getSpriteGrid()
  if spriteGrid == nil then
    return nil
  end

  local originX = spriteGrid:getSpriteGridPosX(sprite)
  local originY = spriteGrid:getSpriteGridPosY(sprite)
  local parts = {}
  for x = 0, spriteGrid:getWidth() - 1 do
    for y = 0, spriteGrid:getHeight() - 1 do
      local member = spriteGrid:getSprite(x, y)
      if member then
        parts[#parts + 1] = {
          sprite = member:getName(),
          x = x - originX,
          y = y - originY,
        }
      end
    end
  end
  return parts
end

local function furnitureParts(definition, nSprite)
  local data = definition.placement.data
  local spriteField, offsetsField = furnitureDirectionFields(data, nSprite)
  local cacheKey = definition.id .. ':' .. tostring(nSprite)
  local cached = furniturePartsCache[cacheKey]
  if cached then
    return cached
  end

  local primary = data[spriteField]
  local parts = spriteGridParts(primary)
  if parts == nil then
    local offsets = data[offsetsField]
    if offsets == nil and nSprite == 3 then
      offsets = data.tileOffsets
    elseif offsets == nil and nSprite == 4 then
      offsets = data.northTileOffsets
    end
    assert(offsets ~= nil, 'multi-tile sprite has no SpriteGrid or tile offsets: ' .. primary)
    parts = {}
    for index, offset in ipairs(offsets) do
      local field = index == 1 and spriteField or spriteField .. tostring(index)
      local spriteName = data[field]
      assert(spriteName ~= nil, 'missing multi-tile sprite ' .. field .. ': ' .. definition.id)
      assert(getSprite(spriteName) ~= nil, 'missing placement sprite ' .. field .. ': ' .. definition.id)
      parts[#parts + 1] = { sprite = spriteName, x = offset.x, y = offset.y }
    end
  end
  furniturePartsCache[cacheKey] = parts
  return parts
end

local function installFurnitureDirectionResolver(cursor)
  if cursor.moreBuildsFurnitureDirectionResolver then
    return
  end
  local inheritedGetSprite = cursor.getSprite
  cursor.getSprite = function(activeCursor)
    local spriteName = inheritedGetSprite(activeCursor)
    activeCursor.north = furnitureNorth(activeCursor)
    return spriteName
  end
  cursor.moreBuildsFurnitureDirectionResolver = true
end

local function validateFurnitureParts(definition)
  local expectedCount
  for nSprite = 1, 4 do
    local partCount = #furnitureParts(definition, nSprite)
    expectedCount = expectedCount or partCount
    assert(partCount == expectedCount,
      'multi-tile direction size mismatch: ' .. definition.id .. '.nSprite=' .. tostring(nSprite))
  end
end

local function offsetsFor(kind, north)
  if kind == 'high-metal-fence' then
    return north and { { x = 0, y = 0 }, { x = -1, y = 0 } } or { { x = 0, y = 0 }, { x = 0, y = -1 } }
  end
  if kind == 'stairs' then
    return north and { { x = 0, y = 0 }, { x = 0, y = -1 }, { x = 0, y = -2 } } or { { x = 0, y = 0 }, { x = -1, y = 0 }, { x = -2, y = 0 } }
  end
  return north and { { x = 0, y = 0 }, { x = 1, y = 0 }, { x = 2, y = 0 } } or { { x = 0, y = 0 }, { x = 0, y = -1 }, { x = 0, y = -2 } }
end

local function partsFor(kind, north, spriteNames)
  local parts = offsetsFor(kind, north)
  for index, part in ipairs(parts) do
    part.sprite = spriteNames[index]
  end
  return parts
end

local function allPartsValid(cursor, square, parts, validator)
  for _, part in ipairs(parts) do
    if not validator(cursor, square, part) then
      return false
    end
  end
  return true
end

local function candidateSquare(square, part)
  return getCell():getGridSquare(square:getX() + part.x, square:getY() + part.y, square:getZ())
end

local function validateFootprint(cursor, square, parts, validator)
  return square ~= nil
    and allPartsValid(cursor, square, parts, validator)
    and not NativePlacement.hasWallBetweenParts(square, parts)
end

local function createPartObjects(plan, context, createPart)
  local cursor = context.cursor
  local created = {}
  for index, part in ipairs(furnitureParts(plan.definition, cursor.nSprite)) do
    local square = context.worldObjectFactory.getOrCreateSquare(
      plan.square:getX() + part.x,
      plan.square:getY() + part.y,
      plan.square:getZ()
    )
    created[index] = createPart(cursor, square, part, index)
  end
  return created
end

local function validFurnitureTile(cursor, square, part)
  local candidate = candidateSquare(square, part)
  -- Match ISDoubleTileFurniture: every occupied tile must be clear before
  -- moveable-specific placement rules can allow it.
  return candidate ~= nil
    and candidate:isFreeOrMidair(true)
    and Support.isMultiTileSquareValid(cursor, candidate, false, part.sprite)
    and (not cursor.definition.placement.data.needToBeAgainstWall or Support.hasRequiredWall(cursor, candidate))
end

local function validFurniture(cursor, square)
  if square == nil then
    return false
  end

  local parts = furnitureParts(cursor.definition, cursor.nSprite)
  local nativeResult = NativePlacement.canPlaceSpriteGrid(cursor:getSprite(), square, cursor.character)
  if nativeResult ~= nil then
    -- SpriteGrid validates the combined moveable footprint, while the preview
    -- evaluates every part. Keep both paths identical at commit time.
    return nativeResult and allPartsValid(cursor, square, parts, validFurnitureTile)
  end

  return validateFootprint(cursor, square, parts, validFurnitureTile)
end

local function validWallDecorationTile(cursor, square, part)
  local candidate = candidateSquare(square, part)
  return Support.isWallDecorationValid(cursor, candidate, part.sprite)
end

local function validWallDecoration(cursor, square)
  local parts = furnitureParts(cursor.definition, cursor.nSprite)
  -- Wall-mounted sprites span adjacent wall squares. A wall between those
  -- squares is the mounting surface, not an obstruction as it is for furniture.
  return square ~= nil and allPartsValid(cursor, square, parts, validWallDecorationTile)
end

local function validHighMetalFenceTile(cursor, square, offset)
  local candidate = candidateSquare(square, offset)
  return Support.isMultiTileSquareValid(cursor, candidate)
end

local function validHighMetalFence(cursor, square)
  local parts = offsetsFor('high-metal-fence', cursor.north)
  return validateFootprint(cursor, square, parts, validHighMetalFenceTile)
end

local function validStairsTile(cursor, square, offset)
  if square:getZ() >= getMaximumWorldLevel() then
    return false
  end

  local candidate = candidateSquare(square, offset)
  if not Support.isMultiTileSquareValid(cursor, candidate) or candidate:getModData()['ConnectedToStairs' .. tostring(not cursor.north)] then
    return false
  end

  local above = getCell():getGridSquare(candidate:getX(), candidate:getY(), candidate:getZ() + 1)
  if above and above:getFloor() then
    return false
  end

  local offsets = offsetsFor('stairs', cursor.north)
  local last = offsets[#offsets]
  if offset.x ~= last.x or offset.y ~= last.y then
    return true
  end

  if above and above:getWall(cursor.north) then
    return false
  end
  local topX = square:getX() + (cursor.north and 0 or -3)
  local topY = square:getY() + (cursor.north and -3 or 0)
  local top = getCell():getGridSquare(topX, topY, square:getZ() + 1)
  return top == nil or (not top:isSolid() and not top:isSolidTrans())
end

local function validGarageDoorTile(cursor, square, offset)
  local candidate = candidateSquare(square, offset)
  if not Support.isMultiTileSquareValid(cursor, candidate) then
    return false
  end
  if buildUtil.stairIsBlockingPlacement(candidate, true, cursor.north) then
    return false
  end
  if offset.x == 0 and offset.y == 0 then
    return true
  end
  local offsets = offsetsFor('garage-door', cursor.north)
  for index = 2, #offsets do
    if offsets[index].x == offset.x and offsets[index].y == offset.y then
      local previousOffset = offsets[index - 1]
      local previous = getCell():getGridSquare(square:getX() + previousOffset.x, square:getY() + previousOffset.y, square:getZ())
      return previous ~= nil and not candidate:isSomethingTo(previous)
    end
  end
  return false
end

local function validGarageDoor(cursor, square)
  return square ~= nil and allPartsValid(
    cursor,
    square,
    offsetsFor('garage-door', cursor.north),
    validGarageDoorTile
  )
end

local function createFurnitureKind(id, container, cursorSettings, placementValidator, tileValidator)
  local requiredFields = { 'sprite', 'northSprite', 'health' }
  if container then
    requiredFields[#requiredFields + 1] = 'containerType'
  end
  local dataFields = Support.joinFields(
    Support.MULTI_FURNITURE_FIELDS,
    Support.THUMPABLE_FIELDS,
    { 'canPassThrough', 'needToBeAgainstWall' },
    container and { 'canBeLockedByPadlock', 'containerCapacity', 'containerType' } or {}
  )
  return KindFactory.create({
    dataFields = dataFields,
    id = id,
    requiredFields = requiredFields,
    spriteFields = { 'sprite', 'northSprite', 'eastSprite', 'southSprite' },
    validate = validateFurnitureParts,
    footprint = function(definition, cursor)
      return furnitureParts(definition, cursor.nSprite)
    end,
    cursorSettings = cursorSettings or {
      buildLow = true,
      defaultAlwaysPlaced = not container,
      defaultBlockAllTheSquare = true,
      dismantable = true,
      isContainer = container,
    },
    afterConfigureCursor = function(cursor)
      installFurnitureDirectionResolver(cursor)
    end,
    isValid = placementValidator or validFurniture,
    isPreviewTileValid = tileValidator or validFurnitureTile,
    create = function(plan, context)
      local cursor = context.cursor
      local north = cursor.north
      return createPartObjects(plan, context, function(cursor, square, part)
        return context.worldObjectFactory.makeThumpable(cursor, square, part.sprite, north)
      end)
    end,
  })
end

local function createMultiStoveKind()
  return KindFactory.create({
    dataFields = Support.MULTI_FURNITURE_FIELDS,
    id = 'morebuilds:multi-stove',
    requiredFields = { 'sprite', 'northSprite' },
    spriteFields = { 'sprite', 'northSprite', 'eastSprite', 'southSprite' },
    validate = validateFurnitureParts,
    footprint = function(definition, cursor)
      return furnitureParts(definition, cursor.nSprite)
    end,
    afterConfigureCursor = function(cursor)
      installFurnitureDirectionResolver(cursor)
    end,
    isValid = validFurniture,
    isPreviewTileValid = validFurnitureTile,
    create = function(plan, context)
      return createPartObjects(plan, context, function(cursor, square, part)
        return context.worldObjectFactory.createStove(cursor, square, nil, part.sprite)
      end)
    end,
  })
end

local function createFeedingTroughKind()
  return KindFactory.create({
    dataFields = Support.ROTATION_FIELDS,
    id = 'morebuilds:feeding-trough',
    requiredFields = { 'sprite', 'northSprite' },
    spriteFields = { 'sprite', 'northSprite' },
    validate = function(definition)
      validateFurnitureParts(definition)
      for _, spriteName in ipairs({ definition.placement.data.sprite, definition.placement.data.northSprite }) do
        local props = ISMoveableSpriteProps.new(getSprite(spriteName))
        assert(props.isMoveable and props.isMultiSprite and props.isoType == 'IsoFeedingTrough',
          'sprite is not a multi-tile IsoFeedingTrough: ' .. definition.id .. '.placement.data.sprite')
      end
    end,
    footprint = function(definition, cursor)
      return furnitureParts(definition, cursor.nSprite)
    end,
    cursorSettings = {
      buildLow = true,
      defaultThumpable = false,
      dismantable = true,
    },
    afterConfigureCursor = function(cursor)
      installFurnitureDirectionResolver(cursor)
    end,
    isValid = validFurniture,
    isPreviewTileValid = validFurnitureTile,
    create = function(plan, context)
      return createPartObjects(plan, context, function(cursor, square, part)
        return context.worldObjectFactory.createFeedingTrough(cursor, square, part.sprite)
      end)
    end,
  })
end

local function createMultiLightKind()
  local function validLightTile(cursor, square, part)
    local candidate = candidateSquare(square, part)
    local nativeResult = NativePlacement.canPlaceSprite(part.sprite, candidate, false, cursor.character)
    if nativeResult == nil then
      return validFurnitureTile(cursor, square, part)
    end
    return nativeResult
      and not Support.hasWallMountedPlacementConflict(candidate, part.sprite)
      and (not cursor.definition.placement.data.needToBeAgainstWall or Support.hasRequiredWall(cursor, candidate))
  end

  local function validLight(cursor, square)
    local parts = furnitureParts(cursor.definition, cursor.nSprite)
    return validateFootprint(cursor, square, parts, validLightTile)
  end

  return KindFactory.create({
    dataFields = Support.joinFields(
      Support.MULTI_FURNITURE_FIELDS,
      { 'needToBeAgainstWall' }
    ),
    id = 'morebuilds:multi-light',
    requiredFields = { 'sprite', 'northSprite' },
    spriteFields = { 'sprite', 'northSprite', 'eastSprite', 'southSprite' },
    validate = validateFurnitureParts,
    footprint = function(definition, cursor)
      return furnitureParts(definition, cursor.nSprite)
    end,
    cursorSettings = {
      buildLow = true,
      canPassThrough = true,
      defaultThumpable = false,
      dismantable = true,
    },
    afterConfigureCursor = function(cursor)
      installFurnitureDirectionResolver(cursor)
    end,
    isValid = validLight,
    isPreviewTileValid = validLightTile,
    create = function(plan, context)
      return createPartObjects(plan, context, function(cursor, square, part)
        return context.worldObjectFactory.createLight(cursor, square, nil, part.sprite)
      end)
    end,
  })
end

local function createHighMetalFenceKind()
  local function sprites(definition, north)
    local data = definition.placement.data
    return north and { data.northSprite1, data.northSprite2 } or { data.sprite1, data.sprite2 }
  end
  return KindFactory.create({
    dataFields = Support.joinFields(
      Support.THUMPABLE_FIELDS,
      { 'sprite1', 'sprite2', 'northSprite1', 'northSprite2' }
    ),
    id = 'morebuilds:high-metal-fence',
    requiredFields = { 'sprite1', 'sprite2', 'northSprite1', 'northSprite2', 'health' },
    spriteFields = { 'sprite1', 'sprite2', 'northSprite1', 'northSprite2' },
    footprint = function(definition, cursor)
      return partsFor('high-metal-fence', cursor.north, sprites(definition, cursor.north))
    end,
    cursorSettings = { isWallLike = true },
    afterConfigureCursor = function(cursor, definition)
      local data = definition.placement.data
      cursor:setSprite(data.sprite1)
      cursor:setNorthSprite(data.northSprite1)
    end,
    isValid = validHighMetalFence,
    isPreviewTileValid = validHighMetalFenceTile,
    create = function(plan, context)
      local cursor = context.cursor
      local created = {}
      local spriteNames = sprites(plan.definition, cursor.north)
      for index, offset in ipairs(offsetsFor('high-metal-fence', cursor.north)) do
        local square = context.worldObjectFactory.getOrCreateSquare(plan.square:getX() + offset.x, plan.square:getY() + offset.y, plan.square:getZ())
        local object = context.worldObjectFactory.makeThumpable(cursor, square, spriteNames[index], cursor.north)
        object:setThumpSound('ZombieThumpMetal')
        created[index] = object
      end
      return created
    end,
  })
end

local function createStairsKind()
  local function sprites(definition, north)
    local data = definition.placement.data
    return north and { data.upToRight01, data.upToRight02, data.upToRight03 } or { data.upToLeft01, data.upToLeft02, data.upToLeft03 }
  end
  return KindFactory.create({
    dataFields = Support.joinFields(
      Support.THUMPABLE_FIELDS,
      { 'upToLeft01', 'upToLeft02', 'upToLeft03', 'upToRight01', 'upToRight02', 'upToRight03', 'pillar', 'pillarNorth' }
    ),
    id = 'morebuilds:stairs',
    salvage = { groupRemoval = 'preserve' },
    requiredFields = { 'upToLeft01', 'upToLeft02', 'upToLeft03', 'upToRight01', 'upToRight02', 'upToRight03', 'pillar', 'pillarNorth', 'health' },
    spriteFields = { 'upToLeft01', 'upToLeft02', 'upToLeft03', 'upToRight01', 'upToRight02', 'upToRight03', 'pillar', 'pillarNorth' },
    footprint = function(definition, cursor)
      return partsFor('stairs', cursor.north, sprites(definition, cursor.north))
    end,
    afterConfigureCursor = function(cursor, definition)
      local data = definition.placement.data
      cursor:setSprite(data.upToLeft01)
      cursor:setNorthSprite(data.upToRight01)
      NativePlacement.configureStairsCursor(cursor)
    end,
    isValid = function(cursor, square)
      return NativePlacement.isStairsValid(cursor, square)
        and allPartsValid(cursor, square, offsetsFor('stairs', cursor.north), validStairsTile)
    end,
    isPreviewTileValid = validStairsTile,
    create = function(plan, context)
      local cursor = context.cursor
      local data = plan.definition.placement.data
      local created = {}
      local spriteNames = sprites(plan.definition, cursor.north)
      for index, offset in ipairs(offsetsFor('stairs', cursor.north)) do
        local square = context.worldObjectFactory.getOrCreateSquare(plan.square:getX() + offset.x, plan.square:getY() + offset.y, plan.square:getZ())
        local pillars = cursor.north and data.pillarNorth or data.pillar
        created[index] = context.worldObjectFactory.createStairs(cursor, square, index - 1, spriteNames[index], pillars)
      end
      return created
    end,
  })
end

local function createGarageDoorKind()
  local function sprites(definition, north)
    local data = definition.placement.data
    local base = data.garageIndex
    return north and { data.sprite .. (base + 3), data.sprite .. (base + 4), data.sprite .. (base + 5) } or { data.sprite .. base, data.sprite .. (base + 1), data.sprite .. (base + 2) }
  end
  return KindFactory.create({
    dataFields = Support.joinFields(Support.THUMPABLE_FIELDS, { 'sprite', 'garageIndex' }),
    id = 'morebuilds:garage-door',
    salvage = { groupRemoval = 'preserve' },
    requiredFields = { 'sprite', 'garageIndex', 'health' },
    validate = function(definition)
      local data = definition.placement.data
      for index = 0, 5 do
        assert(getSprite(data.sprite .. (data.garageIndex + index)) ~= nil, 'missing garage door sprite: ' .. definition.id)
      end
    end,
    footprint = function(definition, cursor)
      return partsFor('garage-door', cursor.north, sprites(definition, cursor.north))
    end,
    afterConfigureCursor = function(cursor, definition)
      local data = definition.placement.data
      cursor:setSprite(data.sprite .. data.garageIndex)
      cursor:setNorthSprite(data.sprite .. (data.garageIndex + 3))
    end,
    isValid = validGarageDoor,
    isPreviewTileValid = validGarageDoorTile,
    create = function(plan, context)
      local cursor = context.cursor
      local created = {}
      local keyId = Support.keyIdFromRecordedItems(context.recordedItems)
      local spriteNames = sprites(plan.definition, cursor.north)
      for index, offset in ipairs(offsetsFor('garage-door', cursor.north)) do
        local square = context.worldObjectFactory.getOrCreateSquare(plan.square:getX() + offset.x, plan.square:getY() + offset.y, plan.square:getZ())
        created[index] = context.worldObjectFactory.createGarageDoor(cursor, square, spriteNames[index], keyId)
      end
      return created
    end,
  })
end

function MultiTileKinds.createAll()
  return {
    createFurnitureKind('morebuilds:multi-furniture', false),
    createFurnitureKind('morebuilds:multi-container', true),
    createFurnitureKind(
      'morebuilds:multi-wall-decoration',
      false,
      {
        buildLow = true,
        canPassThrough = true,
        defaultBlockAllTheSquare = false,
        defaultThumpable = false,
        dismantable = true,
      },
      validWallDecoration,
      validWallDecorationTile
    ),
    createMultiStoveKind(),
    createFeedingTroughKind(),
    createMultiLightKind(),
    createHighMetalFenceKind(),
    createStairsKind(),
    createGarageDoorKind(),
  }
end

return MultiTileKinds
