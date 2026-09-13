if isClient() then
  return {}
end

local ConstructionService = require('MoreBuildings/internal/ConstructionService')
local MaterialSources = require('MoreBuildings/internal/MaterialSources')
local RegistrationCoordinator = require('MoreBuildings/internal/RegistrationCoordinator')
local PopularBuildings = require('MoreBuildings/PopularBuildingsAuthority')
local RegistryGuard = require('MoreBuildings/RegistryGuard')
local SalvageAuthority = require('MoreBuildings/SalvageAuthority')
local WaterSourceSystem = require('MoreBuildings/WaterSourceSystem')
local WorldObjectFactory = require('MoreBuildings/WorldObjectFactory')

local ConstructionAuthority = {}

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
  context.logic = logic
  context.recipeData = logic:getRecipeData()
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
    -- Never replicate a client-localized label into world-object state.  Every
    -- client resolves the managed definition ID through its own locale.
    definition.id
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

  local logic = ConstructionService.createLogicWithContainers(
    player,
    definition.id,
    MaterialSources.getAccessibleContainers(player)
  )
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
