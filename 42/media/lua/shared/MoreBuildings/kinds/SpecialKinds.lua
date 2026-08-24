local KindFactory = require('MoreBuildings/kinds/KindFactory')
local EntityScriptRegistry = require('MoreBuildings/internal/EntityScriptRegistry')
local NativePlacement = require('MoreBuildings/kinds/NativePlacement')
local Support = require('MoreBuildings/kinds/Support')

local SpecialKinds = {}

local function hasFireplace(square)
  for index = 0, square:getObjects():size() - 1 do
    if instanceof(square:getObjects():get(index), 'IsoFireplace') then
      return true
    end
  end
  return false
end

local function createLightKind(id, tableTop)
  local function valid(cursor, square)
    if tableTop then
      return Support.isNativeMoveableValid(cursor, square)
    end
    if cursor.definition.placement.data.needToBeAgainstWall then
      return Support.isWallDecorationValid(cursor, square, cursor:getSprite())
    end
    return Support.isFurnitureValid(cursor, square)
  end
  return KindFactory.create({
    dataFields = Support.joinFields(
      Support.ROTATION_FIELDS,
      { 'needToBeAgainstWall' }
    ),
    id = id,
    requiredFields = { 'sprite' },
    spriteFields = Support.ROTATION_FIELDS,
    cursorSettings = {
      buildLow = true,
      canPassThrough = true,
      defaultThumpable = false,
      dismantable = true,
    },
    isValid = valid,
    create = function(plan, context)
      local offset = tableTop and Support.tableTopOffset(context.cursor, plan.square) or nil
      local bulbs = Support.lightBulbsFromRecordedItems(context.recordedItems)
      return { context.worldObjectFactory.createLight(context.cursor, plan.square, offset, nil, bulbs[1]) }
    end,
  })
end

local function normalizeMannequinPose(pose)
  pose = tonumber(pose) or 1
  if pose < 1 or pose > 3 then
    return 1
  end
  return math.floor(pose)
end

local function mannequinForwardDirection(pose)
  if pose == 2 then
    return IsoDirections.S
  end
  return IsoDirections.SE
end

local function mannequinGetSprite(cursor)
  local pose = normalizeMannequinPose(cursor.mannequinPose)
  cursor.mannequinPose = pose
  cursor.north = false
  cursor.south = false
  cursor.east = false
  cursor.west = true
  cursor.chosenSprite = cursor.mannequinSprites[pose]
  return cursor.chosenSprite
end

local function mannequinRotateKey(cursor, key)
  if getCore():isKey('Rotate building', key) then
    cursor.mannequinPose = normalizeMannequinPose(cursor.mannequinPose % 3 + 1)
  end
end

local function mannequinRotateMouse()
end

local function mannequinJoypadButton(cursor, joypadIndex, joypadData, button)
  if button == Joypad.RBumper then
    cursor.mannequinPose = normalizeMannequinPose(cursor.mannequinPose % 3 + 1)
    return
  end
  if button == Joypad.LBumper then
    cursor.mannequinPose = normalizeMannequinPose((cursor.mannequinPose + 1) % 3 + 1)
    return
  end
  ISBuildingObject.onJoypadPressButton(cursor, joypadIndex, joypadData, button)
end

local function createMannequinKind()
  return KindFactory.create({
    dataFields = Support.joinFields(
      { 'sprite', 'northSprite', 'eastSprite' },
      { 'mannequinScript', 'northMannequinScript', 'eastMannequinScript' }
    ),
    id = 'morebuilds:mannequin',
    requiredFields = { 'sprite', 'northSprite', 'eastSprite', 'mannequinScript', 'northMannequinScript', 'eastMannequinScript' },
    spriteFields = { 'sprite', 'northSprite', 'eastSprite' },
    cursorSettings = {
      buildLow = true,
      canPassThrough = true,
      defaultThumpable = false,
      dismantable = true,
    },
    validate = function(definition)
      local data = definition.placement.data
      local spriteFields = { 'sprite', 'northSprite', 'eastSprite' }
      local scriptFields = { 'mannequinScript', 'northMannequinScript', 'eastMannequinScript' }
      for index, spriteField in ipairs(spriteFields) do
        assert(IsoMannequin.isMannequinSprite(getSprite(data[spriteField])),
          'sprite is not an IsoMannequin: ' .. definition.id .. '.placement.data.' .. spriteField)
        local scriptField = scriptFields[index]
        assert(getScriptManager():getMannequinScript(data[scriptField]) ~= nil,
          'missing mannequin script: ' .. definition.id .. '.placement.data.' .. scriptField .. '=' .. data[scriptField])
      end
    end,
    afterConfigureCursor = function(cursor, definition)
      local data = definition.placement.data
      cursor.mannequinPose = normalizeMannequinPose(cursor.mannequinPose)
      cursor.mannequinSprites = { data.sprite, data.northSprite, data.eastSprite }
      cursor.getSprite = mannequinGetSprite
      cursor.rotateKey = mannequinRotateKey
      cursor.rotateMouse = mannequinRotateMouse
      cursor.onJoypadPressButton = mannequinJoypadButton
    end,
    isValid = Support.isNativeMoveableValid,
    create = function(plan, context)
      local data = plan.definition.placement.data
      return {
        context.worldObjectFactory.createMannequin(
          context.cursor,
          plan.square,
          ({ data.mannequinScript, data.northMannequinScript, data.eastMannequinScript })[normalizeMannequinPose(context.cursor.mannequinPose)],
          mannequinForwardDirection(normalizeMannequinPose(context.cursor.mannequinPose))
        ),
      }
    end,
  })
end

local function createMoveableEntityKind(id, isoType, create)
  return KindFactory.create({
    dataFields = Support.ROTATION_FIELDS,
    id = id,
    requiredFields = { 'sprite' },
    spriteFields = Support.ROTATION_FIELDS,
    cursorSettings = {
      buildLow = true,
      defaultThumpable = false,
      dismantable = true,
    },
    validate = function(definition)
      local props = ISMoveableSpriteProps.new(getSprite(definition.placement.data.sprite))
      assert(props.isMoveable and props.isoType == isoType,
        'sprite IsoType mismatch: ' .. definition.id .. '.placement.data.sprite')
    end,
    isValid = Support.isNativeMoveableValid,
    create = create,
  })
end

local function getEntityFace(objectInfo, nSprite)
  local current = nSprite
  for _ = 1, 4 do
    local faceId = current
    if faceId == 2 then
      faceId = 0
    elseif faceId == 4 then
      faceId = 2
    end
    local face = objectInfo:getFace(faceId)
    if face then
      return face
    end
    current = current == 4 and 1 or current + 1
  end
  return nil
end

local function createScriptEntityKind()
  return KindFactory.create({
    dataFields = { 'entityScript' },
    id = 'morebuilds:entity',
    requiredFields = { 'entityScript' },
    validate = function(definition)
      EntityScriptRegistry.requireBuildable(definition)
    end,
    getRecipe = function(definition)
      return EntityScriptRegistry.requireBuildable(definition).craftRecipe
    end,
    footprint = function(definition, cursor)
      local descriptor = EntityScriptRegistry.requireBuildable(definition)
      local face = getEntityFace(descriptor.objectInfo, cursor.nSprite)
      assert(face ~= nil, 'entity has no usable SpriteConfig face: ' .. definition.id)
      local parts = {}
      for x = 0, face:getWidth() - 1 do
        for y = 0, face:getHeight() - 1 do
          local tile = face:getTileInfo(x, y, 0)
          if tile and (tile:getSpriteName() or tile:isBlocking()) then
            parts[#parts + 1] = { sprite = tile:getSpriteName(), x = x, y = y }
          end
        end
      end
      return parts
    end,
    isValid = function()
      error('morebuilds:entity must use ISMoreBuildEntity')
    end,
    create = function()
      error('morebuilds:entity must use ISMoreBuildEntity')
    end,
  })
end

local function createJukeboxKind()
  return KindFactory.create({
    dataFields = Support.ROTATION_FIELDS,
    id = 'morebuilds:jukebox',
    requiredFields = { 'sprite' },
    spriteFields = Support.ROTATION_FIELDS,
    cursorSettings = {
      buildLow = true,
      defaultThumpable = false,
      dismantable = true,
    },
    validate = function(definition)
      for _, field in ipairs(Support.ROTATION_FIELDS) do
        local spriteName = definition.placement.data[field]
        if spriteName then
          local props = ISMoveableSpriteProps.new(getSprite(spriteName))
          assert(props.isMoveable, 'sprite is not a Moveable jukebox: ' .. definition.id .. '.placement.data.' .. field)
        end
      end
    end,
    isValid = Support.isNativeMoveableValid,
    create = function(plan, context)
      return { context.worldObjectFactory.createJukebox(context.cursor, plan.square) }
    end,
  })
end

local function createWaterFixtureKind()
  return KindFactory.create({
    dataFields = Support.joinFields(Support.ROTATION_FIELDS, Support.THUMPABLE_FIELDS),
    id = 'morebuilds:water-fixture',
    requiredFields = { 'sprite', 'health' },
    spriteFields = Support.ROTATION_FIELDS,
    cursorSettings = {
      buildLow = true,
      defaultThumpable = false,
      dismantable = true,
    },
    validate = function(definition)
      for _, field in ipairs(Support.ROTATION_FIELDS) do
        local spriteName = definition.placement.data[field]
        if spriteName then
          local sprite = getSprite(spriteName)
          local props = ISMoveableSpriteProps.new(sprite)
          assert(props.isMoveable and sprite:getProperties():has(IsoFlagType.waterPiped),
            'sprite is not a plumbable Moveable fixture: ' .. definition.id .. '.placement.data.' .. field)
        end
      end
    end,
    isValid = Support.isNativeMoveableValid,
    create = function(plan, context)
      return { context.worldObjectFactory.createWaterFixture(context.cursor, plan.square) }
    end,
  })
end

local function createMoveableTypeKind(id, moveType, isValid, create, extraDataFields)
  return KindFactory.create({
    dataFields = Support.joinFields(Support.ROTATION_FIELDS, extraDataFields or {}),
    id = id,
    requiredFields = { 'sprite' },
    spriteFields = Support.ROTATION_FIELDS,
    cursorSettings = {
      buildLow = true,
      canPassThrough = true,
      defaultThumpable = false,
      dismantable = true,
    },
    validate = function(definition)
      for _, field in ipairs(Support.ROTATION_FIELDS) do
        local spriteName = definition.placement.data[field]
        if spriteName then
          local props = ISMoveableSpriteProps.new(getSprite(spriteName))
          assert(props.isMoveable and props.type == moveType,
            'sprite MoveType mismatch: ' .. definition.id .. '.placement.data.' .. field)
        end
      end
    end,
    isValid = isValid or Support.isNativeMoveableValid,
    create = create,
  })
end

local function createWallDecorationKind()
  return KindFactory.create({
    dataFields = Support.joinFields(
      Support.ROTATION_FIELDS,
      Support.THUMPABLE_FIELDS,
      { 'needToBeAgainstWall' }
    ),
    id = 'morebuilds:wall-decoration',
    requiredFields = { 'sprite', 'health' },
    spriteFields = Support.ROTATION_FIELDS,
    cursorSettings = {
      buildLow = true,
      canPassThrough = true,
      defaultThumpable = false,
      dismantable = true,
    },
    isValid = function(cursor, square)
      return Support.isWallDecorationValid(cursor, square, cursor:getSprite())
    end,
    create = function(plan, context)
      return { context.worldObjectFactory.makeThumpable(context.cursor, plan.square, context.cursor:getSprite(), context.cursor.north) }
    end,
  })
end

local function createObjectKind(id, objectType)
  local dataFields = Support.ROTATION_FIELDS
  local requiredFields = { 'sprite' }
  if objectType == 'generator' then
    dataFields = Support.joinFields(dataFields, { 'generatorItem' })
    requiredFields[#requiredFields + 1] = 'generatorItem'
  elseif objectType == 'stove' then
    dataFields = Support.joinFields(dataFields, { 'needToBeAgainstWall', 'tableTop' })
  elseif objectType == 'fireplace' then
    dataFields = Support.joinFields(dataFields, {
      'isMoveable',
      'needToBeAgainstWall',
      'wallFacing',
      'northWallFacing',
      'eastWallFacing',
      'southWallFacing',
    })
    requiredFields = { 'sprite', 'northSprite', 'eastSprite', 'southSprite', 'wallFacing', 'northWallFacing', 'eastWallFacing', 'southWallFacing' }
  end
  local function valid(cursor, square)
    if objectType == 'generator' then
      return Support.isFullSquareObjectValid(cursor, square)
    end
    if objectType == 'stove' and cursor.definition.placement.data.tableTop then
      return Support.isNativeMoveableValid(cursor, square)
    end
    if objectType == 'fireplace' then
      if square == nil then
        return false
      end
      if hasFireplace(square) then
        return false
      end
      if cursor.needToBeAgainstWall then
        return Support.canPlaceAgainstWall(cursor, square)
      end
      if not Support.canPlaceOnSquare(cursor, square, true) then
        return false
      end
      if buildUtil.stairIsBlockingPlacement(square, true) then
        return false
      end
      return true
    end
    if objectType == 'stove' then
      local data = cursor.definition.placement.data
      local moveablePlacement = NativePlacement.canPlaceSprite(cursor:getSprite(), square, false, cursor.character)
      if moveablePlacement ~= nil then
        return moveablePlacement and (not data.needToBeAgainstWall or Support.hasRequiredWall(cursor, square))
      end
      return Support.canPlaceOnSquare(cursor, square, true)
        and (not data.needToBeAgainstWall or Support.hasRequiredWall(cursor, square))
    end
    return Support.isFurnitureValid(cursor, square)
  end
  return KindFactory.create({
    dataFields = dataFields,
    id = id,
    requiredFields = requiredFields,
    spriteFields = Support.ROTATION_FIELDS,
    afterConfigureCursor = function(cursor, definition)
      cursor.isWallLike = definition.placement.data.needToBeAgainstWall == true
    end,
    isValid = valid,
    create = function(plan, context)
      local cursor = context.cursor
      if objectType == 'barbecue' then
        return { context.worldObjectFactory.createBarbecue(cursor, plan.square) }
      end
      if objectType == 'generator' then
        local data = plan.definition.placement.data
        return { context.worldObjectFactory.createGenerator(cursor, plan.square, data.generatorItem) }
      end
      if objectType == 'stove' then
        local renderYOffset
        if plan.definition.placement.data.tableTop then
          renderYOffset = Support.tableTopOffset(cursor, plan.square)
        end
        return { context.worldObjectFactory.createStove(cursor, plan.square, renderYOffset) }
      end
      local data = plan.definition.placement.data
      return { context.worldObjectFactory.createFireplace(cursor, plan.square, data.isMoveable == true) }
    end,
  })
end

local function validGroundWaterSource(cursor, square)
  return square ~= nil
    and square:getZ() == 0
    and square:hasNaturalFloor()
    and Support.isFullSquareObjectValid(cursor, square)
end

local function createWaterSourceKind(id, requiredFields, spriteFields, settingsFactory)
  return KindFactory.create({
    dataFields = Support.joinFields(Support.ROTATION_FIELDS, Support.THUMPABLE_FIELDS),
    id = id,
    requiredFields = requiredFields,
    spriteFields = spriteFields,
    cursorSettings = { defaultBlockAllTheSquare = true },
    isValid = validGroundWaterSource,
    create = function(plan, context)
      local settings = settingsFactory()
      settings.initialWaterPercent = SandboxVars.MoreBuilds.InitialWaterPercent
      return { context.worldObjectFactory.createWaterSource(context.cursor, plan.square, settings) }
    end,
  })
end

function SpecialKinds.createAll()
  return {
    createScriptEntityKind(),
    createMannequinKind(),
    createMoveableEntityKind('morebuilds:radio', 'IsoRadio', function(plan, context)
      return { context.worldObjectFactory.createRadio(context.cursor, plan.square) }
    end),
    createMoveableEntityKind('morebuilds:television', 'IsoTelevision', function(plan, context)
      return { context.worldObjectFactory.createTelevision(context.cursor, plan.square) }
    end),
    createJukeboxKind(),
    createMoveableEntityKind('morebuilds:laundry-washer', 'IsoClothingWasher', function(plan, context)
      return { context.worldObjectFactory.createLaundryMachine(context.cursor, plan.square, 'washer') }
    end),
    createMoveableEntityKind('morebuilds:laundry-dryer', 'IsoClothingDryer', function(plan, context)
      return { context.worldObjectFactory.createLaundryMachine(context.cursor, plan.square, 'dryer') }
    end),
    createMoveableEntityKind('morebuilds:laundry-combo', 'IsoCombinationWasherDryer', function(plan, context)
      return { context.worldObjectFactory.createLaundryMachine(context.cursor, plan.square, 'combo') }
    end),
    createWaterFixtureKind(),
    createMoveableTypeKind(
      'morebuilds:curtain',
      'WindowObject',
      Support.isCurtainValid,
      function(plan, context)
        return { context.worldObjectFactory.createCurtain(context.cursor, plan.square) }
      end,
      { 'allowDoor' }
    ),
    createMoveableTypeKind('morebuilds:rug', 'FloorRug', nil, function(plan, context)
      return { context.worldObjectFactory.createRug(context.cursor, plan.square) }
    end),
    createLightKind('morebuilds:light', false),
    createLightKind('morebuilds:table-light', true),
    createWallDecorationKind(),
    createObjectKind('morebuilds:barbecue', 'barbecue'),
    createObjectKind('morebuilds:generator', 'generator'),
    createObjectKind('morebuilds:stove', 'stove'),
    createObjectKind('morebuilds:fireplace', 'fireplace'),
    createWaterSourceKind(
      'morebuilds:water-well',
      { 'sprite', 'health' },
      { 'sprite' },
      function()
        return {
          capacity = SandboxVars.MoreBuilds.WaterWellCapacity,
          rainCatcher = 1.0,
          refillMin = 5,
          refillMax = 10,
        }
      end
    ),
    createWaterSourceKind(
      'morebuilds:water-pump',
      { 'sprite', 'northSprite', 'eastSprite', 'southSprite', 'health' },
      { 'sprite', 'northSprite', 'eastSprite', 'southSprite' },
      function()
        return {
          capacity = SandboxVars.MoreBuilds.WaterPumpCapacity,
          rainCatcher = 0.0,
          refillMin = 1,
          refillMax = 3,
        }
      end
    ),
  }
end

return SpecialKinds
