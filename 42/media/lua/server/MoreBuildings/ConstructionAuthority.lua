if isClient() then
  return {}
end

local ConstructionService = require('MoreBuildings/internal/ConstructionService')
local RegistrationCoordinator = require('MoreBuildings/internal/RegistrationCoordinator')
local PopularBuildings = require('MoreBuildings/PopularBuildingsAuthority')
local RegistryGuard = require('MoreBuildings/RegistryGuard')
local SalvageAuthority = require('MoreBuildings/SalvageAuthority')
local WaterSourceSystem = require('MoreBuildings/WaterSourceSystem')
local WorldObjectFactory = require('MoreBuildings/WorldObjectFactory')

local ConstructionAuthority = {}

local function addContainerTree(containers, seen, root)
  local stack = { root }
  while #stack > 0 do
    local container = stack[#stack]
    stack[#stack] = nil
    if not seen[container] then
      seen[container] = true
      containers:add(container)
      local items = container:getItems()
      for index = items:size() - 1, 0, -1 do
        local item = items:get(index)
        if instanceof(item, 'InventoryContainer') then
          stack[#stack + 1] = item:getItemContainer()
        end
      end
    end
  end
end

local function isAccessibleContainer(player, container)
  local outer = container:getOutermostContainer()
  local vehiclePart = outer:getVehiclePart()
  if vehiclePart and not vehiclePart:getVehicle():canAccessContainer(vehiclePart:getIndex(), player) then
    return false
  end

  local square = outer:getSquare()
  if not vehiclePart and square and square:DistToProper(player) > 2.5 then
    return false
  end

  local parent = outer:getParent()
  return not (parent and instanceof(parent, 'IsoThumpable') and parent:isLockedToCharacter(player))
end

local function getAccessibleContainers(player)
  local containers = ArrayList.new()
  local seen = {}
  local seenVehicles = {}
  addContainerTree(containers, seen, player:getInventory())

  local x = math.floor(player:getX())
  local y = math.floor(player:getY())
  local z = math.floor(player:getZ())
  for xx = x - 2, x + 2 do
    for yy = y - 2, y + 2 do
      local square = getCell():getGridSquare(xx, yy, z)
      if square and square:DistToProper(player) <= 2.5 then
        local objects = square:getObjects()
        for objectIndex = 0, objects:size() - 1 do
          local object = objects:get(objectIndex)
          for containerIndex = 0, object:getContainerCount() - 1 do
            local container = object:getContainerByIndex(containerIndex)
            if isAccessibleContainer(player, container) then
              addContainerTree(containers, seen, container)
            end
          end
        end

        local vehicle = square:getVehicleContainer()
        if vehicle and not seenVehicles[vehicle] then
          seenVehicles[vehicle] = true
          for partIndex = 0, vehicle:getPartCount() - 1 do
            local part = vehicle:getPartByIndex(partIndex)
            local container = part:getItemContainer()
            if container and isAccessibleContainer(player, container) then
              addContainerTree(containers, seen, container)
            end
          end
        end
      end
    end
  end
  return containers
end

local function getRecordedItems(logic, player)
  local craftData = logic:getRecipeDataInProgress()
  craftData:luaCallOnCreate(player)
  local beforeProcessing = craftData:getAllRecordedConsumedItems()
  craftData:processDestroyAndUsedItems(player)
  local recordedItems = craftData:getAllRecordedConsumedItems()
  if recordedItems:size() == 0 then
    return beforeProcessing
  end
  return recordedItems
end

local function performConstruction(logic, player, definition, kind, plan, context, buildCheat)
  local recipe = ConstructionService.getRecipe(definition.id)
  local consumed = buildCheat
  if consumed then
    player:getPlayerCraftHistory():addCraftHistoryCraftedEvent(recipe:getName())
  else
    consumed = logic:performCurrentRecipe()
  end
  if not consumed then
    return false
  end

  local recordedItems
  if not buildCheat then
    recordedItems = getRecordedItems(logic, player)
  end
  context.recordedItems = recordedItems
  local objects = kind.create(plan, context)
  SalvageAuthority.markCreated(objects, definition, recordedItems)
  if kind.onCreated then
    kind.onCreated(objects, context)
  end
  for _, object in ipairs(objects) do
    WaterSourceSystem.register(object)
    IsoGenerator.updateGenerator(object:getSquare())
  end
  if not buildCheat then
    PopularBuildings.record(definition.id)
  end
  return true, objects
end

local function configureCursor(cursor, player, definition)
  cursor.character = player
  local kind = ConstructionService.configureCursor(
    cursor,
    definition,
    player,
    cursor.moreBuildsDisplayName or cursor.definitionId
  )
  cursor:getSprite()
  return kind
end

local function isWithinBuildRange(player, x, y, z, kind, definition, cursor)
  for _, part in ipairs(kind.footprint(definition, cursor)) do
    local deltaX = x + part.x - player:getX()
    local deltaY = y + part.y - player:getY()
    local deltaZ = z + (part.z or 0) - player:getZ()
    if math.abs(deltaZ) <= 0.5 and deltaX * deltaX + deltaY * deltaY <= 6.25 then
      return true
    end
  end
  return false
end

function ConstructionAuthority.isCursorPlacementValid(cursor, player, square)
  if player == nil then
    return false
  end
  local definition = RegistrationCoordinator.getInternalDefinition(cursor.definitionId)
  if definition == nil or not RegistrationCoordinator.isDefinitionEnabled(cursor.definitionId) then
    return false
  end
  configureCursor(cursor, player, definition)
  return ConstructionService.isCursorPlacementValid(cursor, square, player)
end

function ConstructionAuthority.create(cursor, player, x, y, z)
  if player == nil then
    return false
  end
  local definition = RegistrationCoordinator.getInternalDefinition(cursor.definitionId)
  if definition == nil or not RegistrationCoordinator.isDefinitionEnabled(cursor.definitionId) then
    return false
  end
  if ConstructionService.isBuildRestricted(player) or not RegistryGuard.isCompatible(player) then
    return false
  end

  local buildCheat = player:isBuildCheat()
  local kind = configureCursor(cursor, player, definition)
  if not buildCheat and not isWithinBuildRange(player, x, y, z, kind, definition, cursor) then
    return false
  end

  local square = WorldObjectFactory.getOrCreateSquare(x, y, z)
  if not ConstructionService.isCursorPlacementValid(cursor, square, player) then
    return false
  end
  local context = ConstructionService.makeContext(definition, kind, cursor, player)
  context.worldObjectFactory = WorldObjectFactory
  local plan = kind.prepare(cursor, square, context)

  local logic = ConstructionService.createLogicWithContainers(player, definition.id, getAccessibleContainers(player))
  logic:startCraftAction(nil)
  local succeeded, created, objects = pcall(
    performConstruction,
    logic,
    player,
    definition,
    kind,
    plan,
    context,
    buildCheat
  )
  logic:stopCraftAction()
  if not succeeded then
    error(created)
  end
  return created, objects
end

return ConstructionAuthority
