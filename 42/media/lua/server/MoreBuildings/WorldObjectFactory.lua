if isClient() then
  return {}
end

local Support = require('MoreBuildings/kinds/Support')

local WorldObjectFactory = {}

local function markContainersExplored(object)
  for index = 0, object:getContainerCount() - 1 do
    object:getContainerByIndex(index):setExplored(true)
  end
end

local function finalizeMoveableObject(object, cursor, square, renderYOffset)
  object:setMovedThumpable(true)
  object:setName(cursor.name)
  if renderYOffset then
    object:setRenderYOffset(renderYOffset)
  end
  object:createContainersFromSpriteProperties()
  markContainersExplored(object)
  GameEntityFactory.CreateIsoEntityFromCellLoading(object)
  square:AddSpecialObject(object)
  triggerEvent('OnObjectAdded', object)
  object:transmitCompleteItemToClients()
  return object
end

local function configureContainers(object, cursor, createMissingContainer)
  if not cursor.isContainer then
    return
  end

  if object:getContainerCount() == 0 then
    assert(createMissingContainer, 'missing tile container: ' .. cursor.definition.id)
    object:setIsContainer(true)
  end

  local container = object:getContainerByIndex(0)
  if cursor.containerType then
    container:setType(cursor.containerType)
  end
  if cursor.containerCapacity then
    container:setCapacity(cursor.containerCapacity)
  end
end

function WorldObjectFactory.getOrCreateSquare(x, y, z)
  local square = getCell():getGridSquare(x, y, z)
  if square == nil and getWorld():isValidSquare(x, y, z) then
    square = getCell():createNewGridSquare(x, y, z, true)
  end
  if square then
    square:EnsureSurroundNotNull()
  end
  return square
end

function WorldObjectFactory.makeThumpable(cursor, square, spriteName, north, openSprite, options)
  local object
  if openSprite then
    object = IsoThumpable.new(getWorld():getCell(), square, spriteName, openSprite, north, cursor)
  else
    object = IsoThumpable.new(getWorld():getCell(), square, spriteName, north, cursor)
  end
  buildUtil.setInfo(object, cursor)
  object:setMaxHealth(Support.healthFor(cursor))
  object:setHealth(object:getMaxHealth())
  object:setIsThumpable(cursor.isThumpable)
  object:setName(cursor.name)
  object:setBreakSound(IsoThumpable.GetBreakFurnitureSound(spriteName))
  local sharedSprite = getSprite(spriteName)
  if sharedSprite and sharedSprite:getProperties():has('IsStackable') then
    local props = ISMoveableSpriteProps.new(sharedSprite)
    object:setRenderYOffset(props:getTotalTableHeight(square))
  end
  if options and options.initialModData then
    local modData = object:getModData()
    for key, value in pairs(options.initialModData) do
      modData[key] = value
    end
  end
  local insertIndex = nil
  if options and options.placeBeforeCountertop then
    local countertop = square:getCountertopObject()
    if countertop then
      insertIndex = countertop:getObjectIndex()
    end
  end
  if insertIndex ~= nil then
    square:AddSpecialObject(object, insertIndex)
  else
    square:AddSpecialObject(object)
  end
  configureContainers(object, cursor, true)
  markContainersExplored(object)
  if not options or not options.deferTransmit then
    object:transmitCompleteItemToClients()
  end
  return object
end

function WorldObjectFactory.createFloor(cursor, square)
  local object = square:addFloor(cursor:getSprite())
  square:disableErosion()
  object:transmitCompleteItemToClients()
  return object
end

function WorldObjectFactory.createAttachedFloor(cursor, square)
  local object = IsoObject.new(getCell(), square, getSprite(cursor:getSprite()))
  object:setName(cursor.name)
  square:AddTileObject(object)
  object:transmitCompleteItemToClients()
  return object
end

local function finalizeNativeMoveable(object, cursor, square, insertIndex, renderYOffset)
  object:setName(cursor.name)
  if renderYOffset then
    object:setRenderYOffset(renderYOffset)
  end
  object:createContainersFromSpriteProperties()
  configureContainers(object, cursor, false)
  markContainersExplored(object)
  GameEntityFactory.CreateIsoEntityFromCellLoading(object)
  if insertIndex == nil then
    square:AddSpecialObject(object)
  else
    square:AddSpecialObject(object, insertIndex)
  end
  triggerEvent('OnObjectAdded', object)
  object:transmitCompleteItemToClients()
  getTileOverlays():fixTableTopOverlays(square)
  square:RecalcProperties()
  square:RecalcAllWithNeighbours(true)
  triggerEvent('OnContainerUpdate')
  IsoGenerator.updateGenerator(square)
  return object
end

function WorldObjectFactory.makeTableDecoration(cursor, square)
  return finalizeNativeMoveable(
    IsoObject.new(getCell(), square, getSprite(cursor:getSprite())),
    cursor,
    square,
    nil,
    Support.tableTopOffset(cursor, square)
  )
end

function WorldObjectFactory.createCurtain(cursor, square)
  local spriteName = cursor:getSprite()
  local props = ISMoveableSpriteProps.new(getSprite(spriteName))
  local north = props.facing == 'N' or props.facing == 'S'
  local insertIndex = square:getObjects():size()

  if props.facing == 'S' or props.facing == 'E' then
    local opening = square:getWindow(north)
    if opening == nil and cursor.definition.placement.data.allowDoor then
      opening = square:getDoor(north)
    end
    for index = 0, square:getObjects():size() - 1 do
      local object = square:getObjects():get(index)
      if object == opening then
        insertIndex = index + 1
      end
    end
  end

  return finalizeNativeMoveable(
    IsoCurtain.new(getCell(), square, spriteName, north),
    cursor,
    square,
    insertIndex
  )
end

function WorldObjectFactory.createRug(cursor, square)
  local insertIndex = square:getObjects():size()
  for index = square:getObjects():size(), 1, -1 do
    local object = square:getObjects():get(index - 1)
    local sprite = object:getSprite()
    if sprite and sprite:getProperties():has(IsoFlagType.solidfloor) then
      insertIndex = index
      break
    end
  end

  return finalizeNativeMoveable(
    IsoObject.new(getCell(), square, cursor:getSprite()),
    cursor,
    square,
    insertIndex
  )
end

function WorldObjectFactory.createWindow(cursor, square)
  local object = IsoWindow.new(getWorld():getCell(), square, getSprite(cursor:getSprite()), cursor.north)
  local moveableProps = ISMoveableSpriteProps.new(getSprite(cursor:getSprite()))
  local frame = moveableProps:getWallForFacing(square, cursor.north and 'S' or 'E', 'WindowFrame')
  local insertIndex = frame and frame:getObjectIndex() + 1 or -1
  square:AddSpecialObject(object, insertIndex)
  object:setIsLocked(false)
  object:transmitCompleteItemToClients()
  return object
end

function WorldObjectFactory.createLight(cursor, square, offset, spriteName)
  local object = IsoLightSwitch.new(getWorld():getCell(), square, getSprite(spriteName or cursor:getSprite()), square:getRoomID())
  object:setCanBeModified(true)
  object:addLightSourceFromSprite()
  object:setName(cursor.name)
  if offset then
    object:setRenderYOffset(offset)
  end
  square:AddSpecialObject(object)
  object:transmitCompleteItemToClients()
  return object
end

function WorldObjectFactory.createMannequin(cursor, square, scriptName, forwardDirection)
  local object = IsoMannequin.new(getWorld():getCell(), square, getSprite(cursor:getSprite()))
  object:setForwardIsoDirection(forwardDirection)
  object:setMannequinScriptName(scriptName)
  object:setName(cursor.name)
  square:AddSpecialObject(object)
  markContainersExplored(object)
  triggerEvent('OnObjectAdded', object)
  object:transmitCompleteItemToClients()
  return object
end

local function makeDestroyable(object)
  object:setMovedThumpable(true)
  object:transmitCompleteItemToClients()
  return object
end

function WorldObjectFactory.createBarbecue(cursor, square)
  local object = IsoBarbecue.new(getWorld():getCell(), square, getSprite(cursor:getSprite()))
  return finalizeMoveableObject(object, cursor, square)
end

function WorldObjectFactory.createRadio(cursor, square)
  local object = IsoRadio.new(getWorld():getCell(), square, getSprite(cursor:getSprite()))
  return finalizeNativeMoveable(object, cursor, square, nil, Support.tableTopOffset(cursor, square))
end

function WorldObjectFactory.createTelevision(cursor, square)
  local object = IsoTelevision.new(getWorld():getCell(), square, getSprite(cursor:getSprite()))
  local props = ISMoveableSpriteProps.new(getSprite(cursor:getSprite()))
  local offset = props.isTableTop and Support.tableTopOffset(cursor, square) or nil
  return finalizeMoveableObject(object, cursor, square, offset)
end

function WorldObjectFactory.createJukebox(cursor, square)
  local object = IsoJukebox.new(getWorld():getCell(), square, getSprite(cursor:getSprite()))
  return finalizeMoveableObject(object, cursor, square)
end

function WorldObjectFactory.createLaundryMachine(cursor, square, machineType)
  local sprite = getSprite(cursor:getSprite())
  local object
  if machineType == 'washer' then
    object = IsoClothingWasher.new(getWorld():getCell(), square, sprite)
  elseif machineType == 'dryer' then
    object = IsoClothingDryer.new(getWorld():getCell(), square, sprite)
  else
    object = IsoCombinationWasherDryer.new(getWorld():getCell(), square, sprite)
  end
  return finalizeMoveableObject(object, cursor, square)
end

function WorldObjectFactory.createFeedingTrough(cursor, square, spriteName)
  -- IsoFeedingTrough creates its master/slave links and FluidContainer itself.
  local object = IsoFeedingTrough.new(square, spriteName, nil)
  object:setName(cursor.name)
  markContainersExplored(object)
  square:AddSpecialObject(object)
  triggerEvent('OnObjectAdded', object)
  object:transmitCompleteItemToClients()
  return object
end

function WorldObjectFactory.createWaterFixture(cursor, square)
  local object = WorldObjectFactory.makeThumpable(cursor, square, cursor:getSprite(), cursor.north, nil, {
    deferTransmit = true,
  })
  local props = ISMoveableSpriteProps.new(getSprite(cursor:getSprite()))
  object:getModData().canBeWaterPiped = true
  if props.isTableTop then
    object:setRenderYOffset(Support.tableTopOffset(cursor, square))
  end
  object:transmitModData()
  object:transmitCompleteItemToClients()
  return object
end

function WorldObjectFactory.createGenerator(cursor, square, generatorItem)
  local item = instanceItem(generatorItem)
  item:setCondition(math.max(1, cursor.character:getPerkLevel(Perks.Electricity) * 10 - ZombRand(0, 10)))
  local object = IsoGenerator.new(item, getWorld():getCell(), square)
  object:setSprite(getSprite(cursor:getSprite()))
  return makeDestroyable(object)
end

function WorldObjectFactory.createStove(cursor, square, renderYOffset, spriteName)
  local object = IsoStove.new(getWorld():getCell(), square, getSprite(spriteName or cursor:getSprite()))
  if renderYOffset then
    object:setRenderYOffset(renderYOffset)
  end
  square:AddSpecialObject(object)
  markContainersExplored(object)
  triggerEvent('OnObjectAdded', object)
  return makeDestroyable(object)
end

function WorldObjectFactory.createStairs(cursor, square, index, spriteName, pillarSprite)
  local object = square:AddStairs(cursor.north, index, spriteName, pillarSprite, cursor)
  object:setName(cursor.name)
  object:setCanBarricade(false)
  object:setIsDismantable(true)
  object:setIsStairs(true)
  object:setIsThumpable(cursor.isThumpable)
  object:setMaxHealth(Support.healthFor(cursor))
  object:setHealth(object:getMaxHealth())
  object:setBreakSound('BreakObject')
  object:transmitCompleteItemToClients()
  return object
end

function WorldObjectFactory.createGarageDoor(cursor, square, spriteName, keyId)
  local object = IsoDoor.new(getWorld():getCell(), square, spriteName, cursor.north)
  object:setHealth(Support.healthFor(cursor))
  if keyId then
    object:setKeyId(keyId)
  end
  square:AddSpecialObject(object)
  object:transmitCompleteItemToClients()
  return object
end

function WorldObjectFactory.createFireplace(cursor, square, moveable)
  local object = IsoFireplace.new(getWorld():getCell(), square, getSprite(cursor:getSprite()))
  if moveable then
    square:AddSpecialObject(object)
    local properties = getSprite(cursor:getSprite()):getProperties()
    if properties:has(IsoFlagType.solid) or properties:has(IsoFlagType.solidtrans) then
      object:setMovedThumpable(true)
    end
  else
    square:AddTileObject(object)
  end
  markContainersExplored(object)
  triggerEvent('OnObjectAdded', object)
  object:transmitCompleteItemToClients()
  return object
end

function WorldObjectFactory.createWaterSource(cursor, square, settings)
  local modData = {
    MoreBuildsWaterSource = true,
    MoreBuildsWaterSourceLastRefillHour = math.floor(getGameTime():getWorldAgeHours()),
    MoreBuildsWaterSourceRefillMin = settings.refillMin,
    MoreBuildsWaterSourceRefillMax = settings.refillMax,
  }
  local object = WorldObjectFactory.makeThumpable(cursor, square, cursor:getSprite(), cursor.north, nil, {
    deferTransmit = true,
    initialModData = modData,
  })
  object:setBreakSound('breakdoor')
  local component = ComponentType.FluidContainer:CreateComponent()
  component:setCapacity(settings.capacity)
  component:setRainCatcher(settings.rainCatcher)
  component:addFluid(FluidType.Water, settings.capacity * settings.initialWaterPercent / 100)
  GameEntityFactory.AddComponent(object, true, component)
  object:sync()
  object:transmitModData()
  object:transmitCompleteItemToClients()
  return object
end

return WorldObjectFactory
