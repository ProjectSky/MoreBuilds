local KindFactory = require('MoreBuildings/kinds/KindFactory')
local Support = require('MoreBuildings/kinds/Support')

local FurnitureKinds = {}

local function createKind(id, settings)
  local requiredFields = { 'sprite', 'health' }
  if settings.isContainer then
    requiredFields[#requiredFields + 1] = 'containerType'
  end
  local dataFields = Support.joinFields(
    Support.ROTATION_FIELDS,
    Support.THUMPABLE_FIELDS,
    { 'blockAllTheSquare', 'canPassThrough', 'isThumpable', 'needToBeAgainstWall' },
    settings.isContainer
      and { 'canBeLockedByPadlock', 'containerCapacity', 'containerType', 'placeBeforeCountertop' }
      or { 'canBeAlwaysPlaced' }
  )
  return KindFactory.create({
    dataFields = dataFields,
    id = id,
    requiredFields = requiredFields,
    spriteFields = { 'sprite', 'northSprite', 'eastSprite', 'southSprite' },
    cursorSettings = settings,
    isValid = Support.isFurnitureValid,
    create = function(plan, context)
      return {
        context.worldObjectFactory.makeThumpable(context.cursor, plan.square, context.cursor:getSprite(), context.cursor.north, nil, {
          placeBeforeCountertop = plan.definition.placement.data.placeBeforeCountertop == true,
        }),
      }
    end,
  })
end

local function createTableDecorationKind()
  return KindFactory.create({
    dataFields = Support.joinFields(
      Support.ROTATION_FIELDS,
      Support.THUMPABLE_FIELDS,
      { 'canBeLockedByPadlock', 'containerCapacity', 'containerType' }
    ),
    id = 'morebuilds:table-decoration',
    requiredFields = { 'sprite', 'health' },
    spriteFields = Support.ROTATION_FIELDS,
    cursorSettings = {
      buildLow = true,
      canPassThrough = true,
      defaultThumpable = false,
      dismantable = true,
    },
    afterConfigureCursor = function(cursor, definition)
      if definition.placement.data.containerType then
        cursor.isContainer = true
        cursor.canBeLockedByPadlock = definition.placement.data.canBeLockedByPadlock ~= false
      end
    end,
    isValid = Support.isNativeMoveableValid,
    create = function(plan, context)
      return { context.worldObjectFactory.makeTableDecoration(context.cursor, plan.square) }
    end,
  })
end

function FurnitureKinds.createAll()
  return {
    createKind('morebuilds:furniture', {
      buildLow = true,
      defaultAlwaysPlaced = true,
      dismantable = true,
      defaultBlockAllTheSquare = true,
    }),
    createKind('morebuilds:container', {
      buildLow = true,
      isContainer = true,
      dismantable = true,
      defaultBlockAllTheSquare = true,
    }),
    createTableDecorationKind(),
  }
end

return FurnitureKinds
