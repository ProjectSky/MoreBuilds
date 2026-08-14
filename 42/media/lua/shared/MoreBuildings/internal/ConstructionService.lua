local RegistrationCoordinator = require('MoreBuildings/internal/RegistrationCoordinator')

local ConstructionService = {}
local recipeCache = {}

local function getDefinition(definitionId)
  local definition = RegistrationCoordinator.getInternalDefinition(definitionId)
  assert(definition ~= nil, 'unknown MoreBuilds definition: ' .. tostring(definitionId))
  return definition
end

local function getPlacementKind(definition)
  local kind = RegistrationCoordinator.getInternalPlacementKind(definition.placement.kind)
  assert(kind ~= nil, 'unknown MoreBuilds placement kind: ' .. definition.id .. '.placement.kind=' .. definition.placement.kind)
  return kind
end

function ConstructionService.getRecipe(definitionId)
  local definition = getDefinition(definitionId)
  local recipe = recipeCache[definition.recipeId]
  if recipe == nil then
    recipe = getScriptManager():getCraftRecipe(definition.recipeId)
    assert(recipe ~= nil, 'missing CraftRecipe: ' .. definition.id .. '.recipeId=' .. definition.recipeId)
    recipeCache[definition.recipeId] = recipe
  end
  return recipe
end

function ConstructionService.isBuildRestricted(player)
  -- The complete role list is not guaranteed to be replicated to ordinary clients.
  -- Keep role enforcement authoritative so a missing Roles packet cannot hide UI entry points.
  if isClient() or not isMultiplayer() or player:isBuildCheat() then
    return false
  end

  local requiredRoleName = SandboxVars.MoreBuilds.MinimumBuildRole
  local roles = getRoles()
  for index = 0, roles:size() - 1 do
    local requiredRole = roles:get(index)
    if requiredRole:getName() == requiredRoleName then
      return player:getRole():getPosition() < requiredRole:getPosition()
    end
  end
  return true
end

function ConstructionService.createLogicWithContainers(player, definitionId, containers)
  local logic = BuildLogic.new(player, nil, nil)
  logic:setManualSelectInputs(false)
  logic:setContainers(containers)
  logic:setRecipe(ConstructionService.getRecipe(definitionId))
  logic:updateFloorContainer()
  logic:refresh()
  return logic
end

function ConstructionService.makeContext(definition, kind, cursor, player)
  return {
    cursor = cursor,
    definition = definition,
    name = cursor.moreBuildsDisplayName,
    placementKind = kind,
    player = player,
  }
end

function ConstructionService.configureCursor(cursor, definition, player, displayName)
  local kind = getPlacementKind(definition)
  local context = ConstructionService.makeContext(definition, kind, cursor, player)
  context.name = displayName or cursor.moreBuildsDisplayName or definition.id
  kind.configureCursor(cursor, definition, context)
  cursor.definition = definition
  cursor.definitionId = definition.id
  cursor.placementKind = kind
  cursor.moreBuildsDisplayName = context.name
  return kind
end

function ConstructionService.isPlacementPermitted(kind, definition, cursor, square, player)
  if not isMultiplayer() then
    return true
  end
  for _, part in ipairs(kind.footprint(definition, cursor)) do
    local target = getCell():getGridSquare(
      square:getX() + part.x,
      square:getY() + part.y,
      square:getZ() + (part.z or 0)
    )
    if target and SafeHouse.isSafeHouse(target, player:getUsername(), true) then
      return false
    end
  end
  return true
end

function ConstructionService.isCursorPlacementValid(cursor, square, player)
  local definition = cursor.definition
  local kind = cursor.placementKind
  assert(definition ~= nil and kind ~= nil, 'MoreBuilds cursor is not configured: ' .. tostring(cursor.definitionId))
  return square ~= nil
    and ConstructionService.isPlacementPermitted(kind, definition, cursor, square, player)
    and kind.isValid(cursor, square, ConstructionService.makeContext(definition, kind, cursor, player))
end

return ConstructionService
