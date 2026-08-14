local KindFactory = require('MoreBuildings/kinds/KindFactory')
local NativePlacement = require('MoreBuildings/kinds/NativePlacement')
local Support = require('MoreBuildings/kinds/Support')

local OpeningKinds = {}

local function createDoorKind()
  return KindFactory.create({
    dataFields = Support.joinFields(
      Support.THUMPABLE_FIELDS,
      { 'sprite', 'northSprite', 'openSprite', 'openNorthSprite', 'dontNeedFrame' }
    ),
    id = 'morebuilds:door',
    requiredFields = { 'sprite', 'northSprite', 'openSprite', 'openNorthSprite', 'health' },
    spriteFields = { 'sprite', 'northSprite', 'openSprite', 'openNorthSprite' },
    cursorSettings = { isWallLike = true },
    afterConfigureCursor = function(cursor, definition)
      cursor.isDoor = true
      cursor.thumpDmg = 5
      cursor.dontNeedFrame = definition.placement.data.dontNeedFrame == true
    end,
    isValid = NativePlacement.isDoorValid,
    create = function(plan, context)
      local cursor = context.cursor
      local data = plan.definition.placement.data
      local openSprite = cursor.north and data.openNorthSprite or data.openSprite
      local object = context.worldObjectFactory.makeThumpable(cursor, plan.square, cursor:getSprite(), cursor.north, openSprite)
      local keyId = Support.keyIdFromRecordedItems(context.recordedItems)
      if keyId then
        object:setKeyId(keyId)
      end
      return { object }
    end,
  })
end

local function createWindowKind(id, requiresWall)
  local function valid(cursor, square)
    if requiresWall then
      return NativePlacement.isWallValid(cursor, square) and square:getWindow(cursor.north) == nil
    end
    return Support.isWindowValid(cursor, square)
  end
  return KindFactory.create({
    dataFields = { 'sprite', 'northSprite', 'corner' },
    id = id,
    requiredFields = { 'sprite' },
    spriteFields = { 'sprite', 'northSprite' },
    cursorSettings = { isWallLike = requiresWall },
    isValid = valid,
    create = function(plan, context)
      return { context.worldObjectFactory.createWindow(context.cursor, plan.square) }
    end,
  })
end

function OpeningKinds.createAll()
  return {
    createDoorKind(),
    createWindowKind('morebuilds:window', false),
    createWindowKind('morebuilds:window-wall', true),
  }
end

return OpeningKinds
