local DefinitionValidator = {}

local DEFINITION_FIELDS = {
  categoryId = true,
  descriptionKey = true,
  id = true,
  nameKey = true,
  placement = true,
  previewSprite = true,
  recipeId = true,
  salvageMaterial = true,
  salvagePolicy = true,
  sortKey = true,
}

local ENTITY_DEFINITION_FIELDS = {
  categoryId = true,
  id = true,
  placement = true,
  sortKey = true,
}

local PLACEMENT_FIELDS = {
  data = true,
  kind = true,
}

local BOOLEAN_DATA_FIELDS = {
  allowDoor = true,
  blockAllTheSquare = true,
  canBeAlwaysPlaced = true,
  canBeLockedByPadlock = true,
  canPassThrough = true,
  dontNeedFrame = true,
  healthFromCarpentry = true,
  isCorner = true,
  isMoveable = true,
  isThumpable = true,
  needToBeAgainstWall = true,
  tableTop = true,
  useSpriteEntity = true,
}

local STRING_DATA_FIELDS = {
  containerType = true,
  entityScript = true,
  generatorItem = true,
  mannequinScript = true,
  northMannequinScript = true,
  eastMannequinScript = true,
  wallFacing = true,
  northWallFacing = true,
  eastWallFacing = true,
  southWallFacing = true,
}

local function assertString(value, path)
  assert(type(value) == 'string' and value ~= '', 'expected non-empty string: ' .. path)
end

local function assertInteger(value, path)
  assert(type(value) == 'number' and value == math.floor(value), 'expected integer: ' .. path)
end

local function assertFields(value, fields, path)
  assert(type(value) == 'table', 'expected table: ' .. path)
  for field in pairs(value) do
    assert(fields[field] == true, 'unsupported field: ' .. path .. '.' .. tostring(field))
  end
end

local function validateOffsets(offsets, path)
  local count = #offsets
  assert(count > 0, 'expected non-empty array: ' .. path)
  local seen = {}
  local hasAnchor = false
  for index, offset in ipairs(offsets) do
    assertFields(offset, { x = true, y = true }, path .. '[' .. tostring(index) .. ']')
    assertInteger(offset.x, path .. '[' .. tostring(index) .. '].x')
    assertInteger(offset.y, path .. '[' .. tostring(index) .. '].y')
    local key = tostring(offset.x) .. ':' .. tostring(offset.y)
    assert(seen[key] == nil, 'duplicate tile offset: ' .. path .. '[' .. tostring(index) .. ']=' .. key)
    seen[key] = true
    hasAnchor = hasAnchor or (offset.x == 0 and offset.y == 0)
  end
  for key in pairs(offsets) do
    assert(type(key) == 'number' and key >= 1 and key <= count and key == math.floor(key), 'expected array: ' .. path)
  end
  assert(hasAnchor, 'missing tile offset anchor: ' .. path)
end

local function validatePlacementDataField(field, value, path)
  if BOOLEAN_DATA_FIELDS[field] then
    assert(type(value) == 'boolean', 'expected boolean: ' .. path)
  elseif STRING_DATA_FIELDS[field]
    or field == 'corner'
    or field == 'pillar'
    or field == 'pillarNorth'
    or field:match('^sprite%d*$')
    or field:match('Sprite%d*$')
    or field:match('^upToLeft%d+$')
    or field:match('^upToRight%d+$') then
    assertString(value, path)
  elseif field == 'health' or field == 'containerCapacity' then
    assert(type(value) == 'number' and value > 0, 'expected positive number: ' .. path)
  elseif field == 'garageIndex' then
    assertInteger(value, path)
    assert(value >= 0, 'expected non-negative integer: ' .. path)
  elseif field == 'tileOffsets' or field:match('TileOffsets$') then
    assert(type(value) == 'table', 'expected table: ' .. path)
    validateOffsets(value, path)
  end
  if field == 'wallFacing' or field:match('WallFacing$') then
    assert(value == 'N' or value == 'S' or value == 'E' or value == 'W', 'expected wall facing N, S, E, or W: ' .. path)
  end
end

local function validateStaticValue(value, path)
  local stack = { { value = value, path = path } }
  local seen = {}
  while #stack > 0 do
    local frame = stack[#stack]
    stack[#stack] = nil
    if frame.leave then
      seen[frame.value] = nil
    else
      local valueType = type(frame.value)
      assert(valueType == 'nil' or valueType == 'boolean' or valueType == 'number' or valueType == 'string' or valueType == 'table', 'non-static value: ' .. frame.path)
      if valueType == 'table' then
        assert(seen[frame.value] == nil, 'cyclic value: ' .. frame.path)
        seen[frame.value] = true
        stack[#stack + 1] = { value = frame.value, leave = true }
        for key, nestedValue in pairs(frame.value) do
          local keyType = type(key)
          assert(keyType == 'string' or keyType == 'number', 'invalid key type: ' .. frame.path)
          stack[#stack + 1] = {
            value = nestedValue,
            path = frame.path .. '[' .. tostring(key) .. ']',
          }
        end
      end
    end
  end
end

function DefinitionValidator.validateDefinition(definition, providerId, placementKindRegistry, catalogRegistry)
  local isEntity = type(definition.placement) == 'table'
    and definition.placement.kind == 'morebuilds:entity'
  assertFields(definition, isEntity and ENTITY_DEFINITION_FIELDS or DEFINITION_FIELDS, providerId .. '.definition')
  assertString(definition.id, providerId .. '.definition.id')
  assert(definition.id:sub(1, #providerId + 1) == providerId .. ':', 'definition id must belong to provider: ' .. definition.id)
  assertInteger(definition.sortKey, definition.id .. '.sortKey')
  assertString(definition.categoryId, definition.id .. '.categoryId')
  assert(catalogRegistry.getCategoryInternal(definition.categoryId) ~= nil, 'unknown category: ' .. definition.id .. '.categoryId=' .. definition.categoryId)

  if not isEntity then
    assertString(definition.nameKey, definition.id .. '.nameKey')
    assertString(definition.descriptionKey, definition.id .. '.descriptionKey')
    assertString(definition.previewSprite, definition.id .. '.previewSprite')
  end

  local placement = definition.placement
  assertFields(placement, PLACEMENT_FIELDS, definition.id .. '.placement')
  assertString(placement.kind, definition.id .. '.placement.kind')
  assert(type(placement.data) == 'table', 'expected table: ' .. definition.id .. '.placement.data')
  local kind = placementKindRegistry.getInternal(placement.kind)
  assert(kind ~= nil, 'unknown placement kind: ' .. definition.id .. '.placement.kind=' .. placement.kind)
  if kind.getRecipe == nil then
    assertString(definition.recipeId, definition.id .. '.recipeId')
  else
    assert(definition.recipeId == nil, 'recipeId is not allowed for native recipe placement: ' .. definition.id)
  end
  for field, value in pairs(placement.data) do
    assert(kind.dataFields[field] == true, 'unsupported field: ' .. definition.id .. '.placement.data.' .. tostring(field))
    validatePlacementDataField(field, value, definition.id .. '.placement.data.' .. tostring(field))
  end

  if not isEntity then
    assert(definition.salvagePolicy == 'recipe-inputs' or definition.salvagePolicy == 'none', 'unsupported salvagePolicy: ' .. definition.id)
    if definition.salvageMaterial ~= nil then
      assertString(definition.salvageMaterial, definition.id .. '.salvageMaterial')
    end
  end
  validateStaticValue(definition, definition.id)
end

function DefinitionValidator.validateRuntime(definition, placementKindRegistry)
  local kind = placementKindRegistry.getInternal(definition.placement.kind)
  if kind.getRecipe then
    assert(kind.getRecipe(definition) ~= nil, 'missing native CraftRecipe: ' .. definition.id)
  else
    assert(getScriptManager():getCraftRecipe(definition.recipeId) ~= nil, 'missing CraftRecipe: ' .. definition.id .. '.recipeId=' .. definition.recipeId)
  end
  if definition.placement.kind ~= 'morebuilds:entity' then
    assert(getSprite(definition.previewSprite) ~= nil, 'missing preview sprite: ' .. definition.id .. '.previewSprite=' .. definition.previewSprite)

    if not isServer() then
      assert(getText(definition.nameKey) ~= definition.nameKey, 'missing name text: ' .. definition.id .. '.nameKey=' .. definition.nameKey)
      assert(getText(definition.descriptionKey) ~= definition.descriptionKey, 'missing description text: ' .. definition.id .. '.descriptionKey=' .. definition.descriptionKey)
    end
  end

  kind.validate(definition, { phase = 'runtime' })
end

return DefinitionValidator
