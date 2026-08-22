local Support = require('MoreBuildings/kinds/Support')

local KindFactory = {}
local EMPTY = {}
local SINGLE_TILE_FOOTPRINT = { { x = 0, y = 0 } }

local function singleTileFootprint()
  return SINGLE_TILE_FOOTPRINT
end

function KindFactory.create(spec)
  local function validate(definition)
    Support.requireFields(definition, spec.requiredFields or EMPTY)
    Support.requireSprites(definition, spec.spriteFields or EMPTY)
    if spec.validate then
      spec.validate(definition)
    end
  end

  local function configureCursor(cursor, definition, context)
    local settings = spec.cursorSettings or EMPTY
    Support.configureCursor(cursor, definition, context, settings)
    if spec.afterConfigureCursor then
      spec.afterConfigureCursor(cursor, definition, context)
    end
  end

  local function prepare(cursor, square, context)
    return Support.prepare(cursor, square, context, spec.isValid)
  end

  return {
    dataFields = spec.dataFields,
    getRecipe = spec.getRecipe,
    id = spec.id,
    salvage = spec.salvage,
    validate = validate,
    footprint = spec.footprint or singleTileFootprint,
    configureCursor = configureCursor,
    isValid = spec.isValid,
    isPreviewTileValid = spec.isPreviewTileValid,
    prepare = prepare,
    create = spec.create,
    onCreated = spec.onCreated,
    onDestroyed = spec.onDestroyed,
    timedActionOnIsValid = spec.timedActionOnIsValid,
  }
end

return KindFactory
