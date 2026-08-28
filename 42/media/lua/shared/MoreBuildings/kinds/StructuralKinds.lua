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
      { 'canPassThrough', 'corner', 'isCorner', 'isThumpable' }
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

local function createStackableFenceKind()
  return KindFactory.create({
    dataFields = Support.joinFields(
      Support.THUMPABLE_FIELDS,
      { 'sprite', 'stackGroup', 'stackOffset' }
    ),
    id = 'morebuilds:stackable-fence',
    salvage = { groupRemoval = 'stacked' },
    requiredFields = { 'sprite', 'health', 'stackGroup', 'stackOffset' },
    spriteFields = { 'sprite' },
    cursorSettings = { isWallLike = true, dismantable = true },
    afterConfigureCursor = function(cursor)
      -- Military barriers intentionally use one fixed default sprite. Height is
      -- selected by the target square, never by the rotation control.
      cursor.nSprite = 1
      cursor.north = false
      cursor.rotateKey = function() end
      cursor.rotateMouse = function() end
    end,
    isValid = function(cursor, square)
      if square == nil then
        cursor.moreBuildsStackLevel = nil
        return false
      end

      local data = cursor.definition.placement.data
      local existingLevel = nil
      for index = 0, square:getObjects():size() - 1 do
        local object = square:getObjects():get(index)
        local modData = object:getModData()
        if modData and modData.MoreBuildsStackGroup == data.stackGroup then
          if existingLevel ~= nil then
            return false
          end
          existingLevel = tonumber(modData.MoreBuildsStackLevel) or 1
        elseif not instanceof(object, 'IsoWorldInventoryObject')
          and not object:isFloor() and not object:isWall() then
          return false
        end
      end

      if existingLevel and existingLevel >= 2 then
        return false
      end
      cursor.moreBuildsStackLevel = existingLevel and 2 or 1
      if existingLevel then
        return not square:isVehicleIntersecting()
          and square:getMovingObjects():isEmpty()
          and not square:has(IsoFlagType.water)
      end
      return NativePlacement.isWallValid(cursor, square)
    end,
    create = function(plan, context)
      local cursor = context.cursor
      local data = plan.definition.placement.data
      local level = cursor.moreBuildsStackLevel or 1
      local object = context.worldObjectFactory.makeThumpable(
        cursor,
        plan.square,
        cursor:getSprite(),
        cursor.north,
        nil,
        {
          renderYOffset = level == 2 and data.stackOffset or nil,
          initialModData = {
            MoreBuildsStackGroup = data.stackGroup,
            MoreBuildsStackLevel = level,
          },
        }
      )
      return { object }
    end,
    onCreated = function(objects)
      local object = objects[1]
      local stackGroup = object and object:getModData().MoreBuildsStackGroup
      if object == nil or stackGroup == nil
        or tonumber(object:getModData().MoreBuildsStackLevel) ~= 2 then
        return
      end

      local square = object:getSquare()
      for index = 0, square:getObjects():size() - 1 do
        local lower = square:getObjects():get(index)
        local lowerData = lower:getModData()
        if lower ~= object
          and lowerData.MoreBuildsStackGroup == stackGroup
          and tonumber(lowerData.MoreBuildsStackLevel) == 1 then
          local objectData = object:getModData()
          objectData.MoreBuildsStackDefinitionId = objectData.MoreBuildsDefinitionId
          objectData.MoreBuildsDefinitionId = lowerData.MoreBuildsDefinitionId
          objectData.MoreBuildsSalvageGroupId = lowerData.MoreBuildsSalvageGroupId
          if objectData.MoreBuildsSalvageMaterials then
            objectData.MoreBuildsStackMaterials = {}
            for itemType, count in pairs(objectData.MoreBuildsSalvageMaterials) do
              objectData.MoreBuildsStackMaterials[itemType] = count
            end
          end
          for itemType, count in pairs(objectData.MoreBuildsSalvageMaterials or {}) do
            lowerData.MoreBuildsSalvageMaterials = lowerData.MoreBuildsSalvageMaterials or {}
            lowerData.MoreBuildsSalvageMaterials[itemType] =
              (lowerData.MoreBuildsSalvageMaterials[itemType] or 0) + count
          end
          objectData.MoreBuildsSalvageMaterials = nil
          lower:transmitModData()
          object:transmitModData()
          return
        end
      end
    end,
  })
end

function StructuralKinds.createAll()
  return {
    createFloorKind(),
    createAttachedFloorKind(),
    createWallLikeKind('morebuilds:wall', { isWallLike = true, canPlaster = true, dismantable = true }, NativePlacement.isWallValid),
    createWallLikeKind('morebuilds:fence', { isWallLike = true, hoppable = true, dismantable = true }, NativePlacement.isWallValid),
    createStackableFenceKind(),
    createWallLikeKind('morebuilds:fence-post', { isWallLike = true, isCorner = true, canPassThrough = true, dismantable = true }, NativePlacement.isWallValid),
    createWallLikeKind('morebuilds:pillar', { isWallLike = true, canPassThrough = true, dismantable = true }, NativePlacement.isWallValid),
    createWallLikeKind('morebuilds:door-frame', {
      isWallLike = true,
      isDoorFrame = true,
      canPassThrough = true,
      canPlaster = true,
      defaultThumpable = false,
      dismantable = true,
    }, NativePlacement.isFrameValid),
    createWallLikeKind('morebuilds:window-frame', { isWallLike = true, hoppable = true, canPlaster = true, dismantable = true }, NativePlacement.isFrameValid),
  }
end

return StructuralKinds
