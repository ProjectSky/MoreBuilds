# More Builds API

```lua
local MoreBuilds = require('MoreBuildings/API')
```

`API_VERSION` is `1`. Call registration and disabling methods from shared Lua
before `OnGameBoot`. The server and every client must load the same providers
and apply the same disable list. The registry then seals permanently and its
digest is checked during multiplayer connection.

## Return Conventions

Registration, validation, and disabling return `true` on success. Public
input errors return `nil, errorInfo`:

```lua
-- errorInfo = { code = '...', path = '...', message = '...' }
local ok, errorInfo = MoreBuilds.disableDefinitions('not-an-array')
-- ok == nil
```

Read-only methods return copied tables. Editing a returned table never changes
the registry.

## Register

### `MoreBuilds.register(providerId, callback)`

Registers one provider transaction. `providerId` must match
`^[a-z][a-z0-9_.-]*$`. The callback receives a transaction object.

```lua
local ok, err = MoreBuilds.register('examplebuilds', function(registry)
  registry:group({
    id = 'examplebuilds',
    nameKey = 'UI_ExampleBuilds_Category',
    sortKey = 100,
  })
  registry:category({
    id = 'examplebuilds:furniture',
    groupId = 'examplebuilds',
    nameKey = 'UI_ExampleBuilds_Furniture',
    sortKey = 100,
  })
  registry:definition({
    id = 'examplebuilds:wooden_chair',
    sortKey = 100,
    categoryId = 'examplebuilds:furniture',
    nameKey = 'UI_ExampleBuilds_WoodenChair',
    descriptionKey = 'Tooltip_ExampleBuilds_WoodenChair',
    recipeId = 'ExampleBuilds.WoodenChair',
    previewSprite = 'furniture_seating_indoor_01_0',
    placement = MoreBuilds.kinds.furniture({
      sprite = 'furniture_seating_indoor_01_0',
      health = 25,
    }),
    salvagePolicy = 'recipe-inputs',
  })
end)

assert(ok, err and err.message)
-- ok == true
```

The complete transaction is committed only if the callback and provider
validation both succeed. A provider cannot be registered twice.

### `MoreBuilds.disableDefinitions(definitionIds)`

Disables definitions before sealing. Disabled definitions disappear from the
catalog and public definition queries, cannot be newly built on the server,
and are excluded from Popular Buildings. Their internal definition remains
available for existing-object salvage.

```lua
local ok, err = MoreBuilds.disableDefinitions({
  'morebuilds:commercial:cash_register',
  'morebuilds:bed:light_wood',
})

assert(ok, err and err.message)
-- ok == true
```

Unknown IDs fail when the registry seals. Call this on the server and every
client with the same list.

### `MoreBuilds.validate(providerSpec)`

Validates a provider without registering it. `providerSpec` contains `id` and
`callback`.

```lua
local valid, err = MoreBuilds.validate({
  id = 'examplebuilds',
  callback = function(registry)
    registry:group({ id = 'examplebuilds', nameKey = 'UI_ExampleBuilds_Category', sortKey = 100 })
  end,
})

assert(valid, err and err.message)
-- valid == true
```

## Transaction Methods

The `registry` transaction passed to `register` exposes the following methods.
Every method returns the same transaction, allowing chained calls.

### `registry:group(spec)`

```lua
local returned = registry:group({
  id = 'examplebuilds',
  nameKey = 'UI_ExampleBuilds_Category',
  sortKey = 100,
})
-- returned == registry
```

Required fields: `id`, `nameKey`, `sortKey`.

### `registry:category(spec)`

```lua
local returned = registry:category({
  id = 'examplebuilds:furniture',
  groupId = 'examplebuilds',
  nameKey = 'UI_ExampleBuilds_Furniture',
  sortKey = 100,
})
-- returned == registry
```

Required fields: `id`, `groupId`, `nameKey`, `sortKey`.

### `registry:definition(spec)`

```lua
local returned = registry:definition({
  id = 'examplebuilds:wooden_chair',
  categoryId = 'examplebuilds:furniture',
  sortKey = 100,
  nameKey = 'UI_ExampleBuilds_WoodenChair',
  descriptionKey = 'Tooltip_ExampleBuilds_WoodenChair',
  recipeId = 'ExampleBuilds.WoodenChair',
  previewSprite = 'furniture_seating_indoor_01_0',
  placement = MoreBuilds.kinds.furniture({
    sprite = 'furniture_seating_indoor_01_0',
    health = 25,
  }),
  salvagePolicy = 'recipe-inputs',
})
-- returned == registry
```

Required fields: `id`, `categoryId`, `sortKey`, `nameKey`, `descriptionKey`,
`previewSprite`, `placement`, and `salvagePolicy`. `recipeId` is required for
ordinary placement kinds and forbidden for a placement kind that supplies its
own native recipe. `salvagePolicy` is `recipe-inputs` or `none`.

### `registry:buildableEntity(spec)`

Adds a native entity script to the MoreBuilds catalog. It accepts `id`,
`categoryId`, `sortKey`, and `entityScript`. MoreBuilds derives the placement
kind from `entityScript`; `nameKey`, `descriptionKey`, `previewSprite`,
`recipeId`, and `salvagePolicy` are not accepted. The entity script is added
to the registry digest and runtime validation automatically.

```lua
local returned = registry:buildableEntity({
  id = 'examplebuilds:display_case',
  categoryId = 'examplebuilds:furniture',
  sortKey = 110,
  entityScript = 'ExampleBuilds.DisplayCase',
})
-- returned == registry
```

The script must supply both `SpriteConfig` and a resolved `CraftRecipe`. The
catalog uses the native translated name, tooltip, and icon, including overrides
from the entity `UiConfig`.
Creation, material consumption, tools, skills, callbacks, object state, and
native dismantling are owned by the game's `ISBuildIsoEntity` path.

### `registry:placementKind(spec)`

Registers a custom placement implementation. The ID must begin with the
provider ID followed by `:`.

```lua
local returned = registry:placementKind({
  id = 'examplebuilds:display',
  manifest = { family = 'display' },
  dataFields = { 'sprite' },
  validate = function(definition) end,
  footprint = function(definition, cursor)
    return { { sprite = definition.placement.data.sprite, x = 0, y = 0 } }
  end,
  configureCursor = function(cursor, definition, context)
    cursor:setSprite(definition.placement.data.sprite)
  end,
  isValid = function(cursor, square, context)
    return square ~= nil
  end,
  prepare = function(cursor, square, context)
    return { square = square, definition = context.definition }
  end,
  create = function(plan, context)
    return { context.worldObjectFactory.makeThumpable(context.cursor, plan.square, context.cursor:getSprite(), context.cursor.north) }
  end,
})
-- returned == registry
```

Required fields are `id`, `manifest`, `dataFields`, `validate`, `footprint`,
`configureCursor`, `isValid`, `prepare`, and `create`. Optional handlers are
`isPreviewTileValid`, `onCreated`, `onDestroyed`, and `salvage`; the latter
accepts `{ groupRemoval = 'remaining-parts' }` or `{ groupRemoval = 'preserve' }`.

## Read-Only Methods

### `MoreBuilds.getStatus()`

```lua
local status = MoreBuilds.getStatus()
-- { apiVersion = 1, digest = 'morebuilds-v1-...', phase = 'sealed', sealed = true }
```

### `MoreBuilds.getGroup(groupId)`

```lua
local group = MoreBuilds.getGroup('morebuilds:indoor')
-- { id = 'morebuilds:indoor', nameKey = '...', sortKey = 100, providerId = 'morebuilds' }
-- nil when the group does not exist
```

### `MoreBuilds.getCategory(categoryId)`

```lua
local category = MoreBuilds.getCategory('morebuilds:chairs')
-- { id = 'morebuilds:chairs', groupId = 'morebuilds:indoor', nameKey = '...', sortKey = 100, providerId = 'morebuilds' }
-- nil when the category does not exist
```

### `MoreBuilds.getDefinition(definitionId)`

```lua
local definition = MoreBuilds.getDefinition('morebuilds:bed:light_wood')
-- { id = 'morebuilds:bed:light_wood', categoryId = '...', recipeId = '...', placement = { kind = '...', data = { ... } }, ... }
-- nil when the definition does not exist or has been disabled
```

### `MoreBuilds.getEntityDescriptor(scriptName)`

Returns a copy of the script's resolved native capabilities after scripts are
loaded. It throws the game's normal script-resolution error for an unknown
script name.

```lua
local descriptor = MoreBuilds.getEntityDescriptor('ExampleBuilds.DisplayCase')
-- {
--   scriptName = 'ExampleBuilds.DisplayCase',
--   componentNames = { 'CraftRecipe', 'SpriteConfig', 'UiConfig' },
--   hasSpriteConfig = true,
--   hasCraftRecipe = true,
--   isBuildable = true,
-- }
```

### `MoreBuilds.listEntityScripts()`

```lua
local scripts = MoreBuilds.listEntityScripts()
-- { { id = 'ExampleBuilds.DisplayCase', scriptName = 'ExampleBuilds.DisplayCase' }, ... }
```

### `MoreBuilds.listGroups()`

```lua
local groups = MoreBuilds.listGroups()
-- { { id = '...', nameKey = '...', sortKey = 100, providerId = '...' }, ... }
```

### `MoreBuilds.listCategories(filter)`

`filter` is optional and may contain `groupId` and/or `providerId`.

```lua
local categories = MoreBuilds.listCategories({ groupId = 'morebuilds:indoor' })
-- { { id = '...', groupId = 'morebuilds:indoor', nameKey = '...', sortKey = 100, providerId = '...' }, ... }
```

### `MoreBuilds.listDefinitions(filter)`

`filter` is optional and may contain `groupId`, `categoryId`, and/or
`providerId`. Disabled definitions are omitted.

```lua
local definitions = MoreBuilds.listDefinitions({ categoryId = 'morebuilds:chairs' })
-- { { id = '...', categoryId = 'morebuilds:chairs', placement = { kind = '...', data = { ... } }, ... }, ... }
```

### `MoreBuilds.getCatalog()`

Returns the UI catalog with only groups and categories that still contain an
enabled definition.

```lua
local catalog = MoreBuilds.getCatalog()
-- {
--   groups = { { id = '...', categories = { { id = '...', definitionIds = { '...', '...' } } } } },
--   definitions = { { id = '...', placement = { kind = '...', data = { ... } }, ... }, ... },
-- }
```

### `MoreBuilds.getRegistryDigest()`

```lua
local digest = MoreBuilds.getRegistryDigest()
-- 'morebuilds-v1-365b8f95'
```

## Built-In Placement Constructors

Every `MoreBuilds.kinds.*` constructor accepts one static `data` table and
returns a copied descriptor. Sprite values below are placeholders; replace
them with valid game sprite names. `S`, `N`, `E`, and `W` mean the primary,
north, east, and south sprite names; `H` means a positive health value.

```lua
local S, N, E, W =
  'furniture_seating_indoor_01_0',
  'furniture_seating_indoor_01_1',
  'furniture_seating_indoor_01_2',
  'furniture_seating_indoor_01_3'
local placement = MoreBuilds.kinds.furniture({ sprite = S, health = 25 })
-- { kind = 'morebuilds:furniture', data = { sprite = 'furniture_seating_indoor_01_0', health = 25 } }
```

All constructors have the same return shape. The `Return` column gives the
exact value of `placement.kind`; `data` is a deep copy of the argument. In the
tables below, `kinds` means `MoreBuilds.kinds`.

### Structural And Single-Tile

| Constructor example | Required data | Additional supported data | Return |
| --- | --- | --- | --- |
| `kinds.floor({ sprite = S })` | `sprite` | `northSprite`, `eastSprite`, `southSprite` | `morebuilds:floor` |
| `kinds.attachedFloor({ sprite = S })` | `sprite` | rotation sprites | `morebuilds:attached-floor` |
| `kinds.wall({ sprite = S, health = H })` | `sprite`, `health` | rotation sprites, `healthFromCarpentry`, `canPassThrough`, `corner`, `isCorner`, `isThumpable` | `morebuilds:wall` |
| `kinds.fence({ sprite = S, health = H })` | `sprite`, `health` | wall fields | `morebuilds:fence` |
| `kinds.stackableFence({ sprite = S, health = H, stackGroup = G, stackOffset = O })` | `sprite`, `health`, `stackGroup`, `stackOffset` | `healthFromCarpentry` | `morebuilds:stackable-fence` |
| `kinds.fencePost({ sprite = S, health = H })` | `sprite`, `health` | wall fields | `morebuilds:fence-post` |
| `kinds.pillar({ sprite = S, health = H })` | `sprite`, `health` | wall fields | `morebuilds:pillar` |
| `kinds.doorFrame({ sprite = S, health = H })` | `sprite`, `health` | wall fields | `morebuilds:door-frame` |
| `kinds.windowFrame({ sprite = S, health = H })` | `sprite`, `health` | wall fields | `morebuilds:window-frame` |
| `kinds.furniture({ sprite = S, health = H })` | `sprite`, `health` | rotation sprites, `healthFromCarpentry`, `blockAllTheSquare`, `canPassThrough`, `isThumpable`, `needToBeAgainstWall`, `canBeAlwaysPlaced` | `morebuilds:furniture` |
| `kinds.container({ sprite = S, health = H, containerType = 'crate' })` | `sprite`, `health`, `containerType` | furniture fields, `containerCapacity`, `canBeLockedByPadlock`, `placeBeforeCountertop` | `morebuilds:container` |
| `kinds.tableDecoration({ sprite = S, health = H })` | `sprite`, `health` | rotation sprites, `healthFromCarpentry`, `containerType`, `containerCapacity`, `canBeLockedByPadlock` | `morebuilds:table-decoration` |

### Scripted Entities

`registry:buildableEntity()` requires an entity script that provides `SpriteConfig` and a
resolved `CraftRecipe`. MoreBuilds instantiates the native `ISBuildIsoEntity`
cursor rather than copying its rules, so rotations, multi-square/layer
footprints, previews, `OnIsValid`, frame/wall/stage constraints, `BuildLogic`,
manual inputs, tools, skills, item consumption, callbacks, component
instancing, XUI, context menus, persistence, and synchronization use the game
implementation directly. Entity definition data cannot override script health,
collision, movement, or component behavior.

### Doors And Windows

| Constructor example | Required data | Additional supported data | Return |
| --- | --- | --- | --- |
| `kinds.door({ sprite = S, northSprite = N, openSprite = 'fixtures_doors_01_1', openNorthSprite = 'fixtures_doors_01_3', health = H })` | `sprite`, `northSprite`, `openSprite`, `openNorthSprite`, `health` | `healthFromCarpentry`, `dontNeedFrame` | `morebuilds:door` |
| `kinds.window({ sprite = S })` | `sprite` | `northSprite`, `corner` | `morebuilds:window` |
| `kinds.windowWall({ sprite = S })` | `sprite` | `northSprite`, `corner` | `morebuilds:window-wall` |

### Multi-Tile

`multiFurniture`, `multiContainer`, `multiWallDecoration`, `multiStove`, and
`multiLight` use a SpriteGrid when available. Otherwise provide the matching
`tileOffsets`, `northTileOffsets`, `eastTileOffsets`, or `southTileOffsets`.
Their sprite fields support `sprite` through `sprite6`, and equivalent
`northSprite*`, `eastSprite*`, and `southSprite*` fields.

| Constructor example | Required data | Additional supported data | Return |
| --- | --- | --- | --- |
| `kinds.multiFurniture({ sprite = S, northSprite = N, health = H })` | `sprite`, `northSprite`, `health` | multi-sprite and tile-offset fields, `healthFromCarpentry`, `canPassThrough`, `needToBeAgainstWall` | `morebuilds:multi-furniture` |
| `kinds.multiContainer({ sprite = S, northSprite = N, health = H, containerType = 'crate' })` | `sprite`, `northSprite`, `health`, `containerType` | multi-furniture fields, `containerCapacity`, `canBeLockedByPadlock` | `morebuilds:multi-container` |
| `kinds.multiWallDecoration({ sprite = S, northSprite = N, health = H })` | `sprite`, `northSprite`, `health` | multi-furniture fields | `morebuilds:multi-wall-decoration` |
| `kinds.multiStove({ sprite = S, northSprite = N })` | `sprite`, `northSprite` | multi-sprite and tile-offset fields | `morebuilds:multi-stove` |
| `kinds.feedingTrough({ sprite = S, northSprite = N })` | `sprite`, `northSprite` | `eastSprite`, `southSprite` | `morebuilds:feeding-trough` |
| `kinds.multiLight({ sprite = S, northSprite = N })` | `sprite`, `northSprite` | multi-sprite and tile-offset fields, `needToBeAgainstWall` | `morebuilds:multi-light` |
| `kinds.highMetalFence({ sprite1 = S, sprite2 = N, northSprite1 = E, northSprite2 = W, health = H })` | `sprite1`, `sprite2`, `northSprite1`, `northSprite2`, `health` | `healthFromCarpentry` | `morebuilds:high-metal-fence` |
| `kinds.stairs({ upToLeft01 = S, upToLeft02 = N, upToLeft03 = E, upToRight01 = W, upToRight02 = S, upToRight03 = N, pillar = E, pillarNorth = W, health = H })` | all eight named sprite fields, `health` | `healthFromCarpentry` | `morebuilds:stairs` |
| `kinds.garageDoor({ sprite = 'fixtures_doors_garage_01_', garageIndex = 0, health = H })` | `sprite`, `garageIndex`, `health` | `healthFromCarpentry` | `morebuilds:garage-door` |

### Moveable And Special Objects

| Constructor example | Required data | Additional supported data | Return |
| --- | --- | --- | --- |
| `kinds.mannequin({ sprite = S, northSprite = N, eastSprite = E, mannequinScript = 'A', northMannequinScript = 'B', eastMannequinScript = 'C' })` | three sprites and three mannequin scripts | none | `morebuilds:mannequin` |
| `kinds.radio({ sprite = S })` | `sprite` | rotation sprites | `morebuilds:radio` |
| `kinds.television({ sprite = S })` | `sprite` | rotation sprites | `morebuilds:television` |
| `kinds.jukebox({ sprite = S })` | `sprite` | rotation sprites | `morebuilds:jukebox` |
| `kinds.laundryWasher({ sprite = S })` | `sprite` | rotation sprites | `morebuilds:laundry-washer` |
| `kinds.laundryDryer({ sprite = S })` | `sprite` | rotation sprites | `morebuilds:laundry-dryer` |
| `kinds.laundryCombo({ sprite = S })` | `sprite` | rotation sprites | `morebuilds:laundry-combo` |
| `kinds.waterFixture({ sprite = S, health = H })` | `sprite`, `health` | rotation sprites, `healthFromCarpentry` | `morebuilds:water-fixture` |
| `kinds.curtain({ sprite = S })` | `sprite` | rotation sprites, `allowDoor` | `morebuilds:curtain` |
| `kinds.rug({ sprite = S })` | `sprite` | rotation sprites | `morebuilds:rug` |
| `kinds.light({ sprite = S })` | `sprite` | rotation sprites, `needToBeAgainstWall` | `morebuilds:light` |
| `kinds.tableLight({ sprite = S })` | `sprite` | rotation sprites, `needToBeAgainstWall` | `morebuilds:table-light` |
| `kinds.wallDecoration({ sprite = S, health = H })` | `sprite`, `health` | rotation sprites, `healthFromCarpentry`, `needToBeAgainstWall` | `morebuilds:wall-decoration` |
| `kinds.barbecue({ sprite = S })` | `sprite` | rotation sprites | `morebuilds:barbecue` |
| `kinds.generator({ sprite = S, generatorItem = 'Base.Generator' })` | `sprite`, `generatorItem` | rotation sprites | `morebuilds:generator` |
| `kinds.stove({ sprite = S })` | `sprite` | rotation sprites, `needToBeAgainstWall`, `tableTop` | `morebuilds:stove` |
| `kinds.fireplace({ sprite = S, northSprite = N, eastSprite = E, southSprite = W, wallFacing = 'N', northWallFacing = 'W', eastWallFacing = 'S', southWallFacing = 'E' })` | four sprites and four wall-facing fields | `isMoveable`, `needToBeAgainstWall` | `morebuilds:fireplace` |
| `kinds.waterWell({ sprite = S, health = H })` | `sprite`, `health` | rotation sprites, `healthFromCarpentry` | `morebuilds:water-well` |
| `kinds.waterPump({ sprite = S, health = H })` | `sprite`, `health` | rotation sprites, `healthFromCarpentry` | `morebuilds:water-pump` |

## Runtime Requirements

Every definition must reference an existing CraftRecipe and preview sprite.
Placement sprites must exist and satisfy the selected kind's native sprite
type requirements. Client runtime validation also requires `nameKey` and
`descriptionKey` translations. These checks run after the registry seals.
