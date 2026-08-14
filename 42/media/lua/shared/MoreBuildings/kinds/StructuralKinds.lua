local KindFactory = require('MoreBuildings/kinds/KindFactory')
local NativePlacement = require('MoreBuildings/kinds/NativePlacement')
local Support = require('MoreBuildings/kinds/Support')

local StructuralKinds = {}

local function createFloorKind()
  return KindFactory.create({
    dataFields = Support.ROTATION_FIELDS,
    id = 'morebuilds:floor',
    requiredFields = { 'sprite' },
    spriteFields = { 'sprite' },
    cursorSettings = { buildLow = true },
    isValid = NativePlacement.isFloorValid,
    create = function(plan, context)
      return { context.worldObjectFactory.createFloor(context.cursor, plan.square) }
    end,
  })
end

local function createAttachedFloorKind()
  return KindFactory.create({
    dataFields = Support.ROTATION_FIELDS,
    id = 'morebuilds:attached-floor',
    requiredFields = { 'sprite' },
    spriteFields = Support.ROTATION_FIELDS,
    cursorSettings = {
      buildLow = true,
      defaultThumpable = false,
    },
    isValid = Support.isAttachedFloorValid,
    create = function(plan, context)
      return { context.worldObjectFactory.createAttachedFloor(context.cursor, plan.square) }
    end,
  })
end

local function createWallLikeKind(id, settings, validator)
  return KindFactory.create({
    dataFields = Support.joinFields(
      Support.ROTATION_FIELDS,
      Support.THUMPABLE_FIELDS,
      { 'canPassThrough', 'corner', 'isCorner' }
    ),
    id = id,
    requiredFields = { 'sprite', 'health' },
    spriteFields = { 'sprite', 'northSprite', 'eastSprite', 'southSprite', 'corner' },
    cursorSettings = settings,
    isValid = function(cursor, square)
      return validator(cursor, square) and not Support.hasStructuralPlacementBlocker(square)
    end,
    create = function(plan, context)
      local cursor = context.cursor
      local object = context.worldObjectFactory.makeThumpable(cursor, plan.square, cursor:getSprite(), cursor.north)
      buildUtil.checkCorner(plan.square:getX(), plan.square:getY(), plan.square:getZ(), cursor.north, object, cursor)
      return { object }
    end,
  })
end

function StructuralKinds.createAll()
  return {
    createFloorKind(),
    createAttachedFloorKind(),
    createWallLikeKind('morebuilds:wall', { isWallLike = true, canPlaster = true }, NativePlacement.isWallValid),
    createWallLikeKind('morebuilds:fence', { isWallLike = true, hoppable = true }, NativePlacement.isWallValid),
    createWallLikeKind('morebuilds:fence-post', { isWallLike = true, isCorner = true, canPassThrough = true }, NativePlacement.isWallValid),
    createWallLikeKind('morebuilds:pillar', { isWallLike = true, canPassThrough = true }, NativePlacement.isWallValid),
    createWallLikeKind('morebuilds:door-frame', { isWallLike = true, isDoorFrame = true, canPassThrough = true, canPlaster = true }, NativePlacement.isFrameValid),
    createWallLikeKind('morebuilds:window-frame', { isWallLike = true, hoppable = true, canPlaster = true }, NativePlacement.isFrameValid),
  }
end

return StructuralKinds
