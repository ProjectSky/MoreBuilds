local BuiltinKinds = require('MoreBuildings/kinds/BuiltinKinds')
local PublicPlacementKinds = require('MoreBuildings/PublicPlacementKinds')
local TableUtil = require('MoreBuildings/internal/TableUtil')
local CatalogData = require('MoreBuildings/providers/CatalogData')
local Architecture = require('MoreBuildings/providers/definitions/Architecture')
local Appliances = require('MoreBuildings/providers/definitions/Appliances')
local Bathroom = require('MoreBuildings/providers/definitions/Bathroom')
local Bedroom = require('MoreBuildings/providers/definitions/Bedroom')
local Commercial = require('MoreBuildings/providers/definitions/Commercial')
local Decorations = require('MoreBuildings/providers/definitions/Decorations')
local DecorExtras = require('MoreBuildings/providers/definitions/DecorExtras')
local Furniture = require('MoreBuildings/providers/definitions/Furniture')
local Mannequins = require('MoreBuildings/providers/definitions/Mannequins')
local Other = require('MoreBuildings/providers/definitions/Other')
local Outdoors = require('MoreBuildings/providers/definitions/Outdoors')
local Storage = require('MoreBuildings/providers/definitions/Storage')
local Utilities = require('MoreBuildings/providers/definitions/Utilities')
local WallCabinets = require('MoreBuildings/providers/definitions/WallCabinets')
local WindowTreatments = require('MoreBuildings/providers/definitions/WindowTreatments')

local definitions = {}

local placementConstructors = {
  ['morebuilds:attached-floor'] = PublicPlacementKinds.attachedFloor,
  ['morebuilds:barbecue'] = PublicPlacementKinds.barbecue,
  ['morebuilds:container'] = PublicPlacementKinds.container,
  ['morebuilds:curtain'] = PublicPlacementKinds.curtain,
  ['morebuilds:door'] = PublicPlacementKinds.door,
  ['morebuilds:door-frame'] = PublicPlacementKinds.doorFrame,
  ['morebuilds:entity'] = PublicPlacementKinds.entity,
  ['morebuilds:feeding-trough'] = PublicPlacementKinds.feedingTrough,
  ['morebuilds:fence'] = PublicPlacementKinds.fence,
  ['morebuilds:stackable-fence'] = PublicPlacementKinds.stackableFence,
  ['morebuilds:fence-post'] = PublicPlacementKinds.fencePost,
  ['morebuilds:fireplace'] = PublicPlacementKinds.fireplace,
  ['morebuilds:floor'] = PublicPlacementKinds.floor,
  ['morebuilds:furniture'] = PublicPlacementKinds.furniture,
  ['morebuilds:garage-door'] = PublicPlacementKinds.garageDoor,
  ['morebuilds:generator'] = PublicPlacementKinds.generator,
  ['morebuilds:high-metal-fence'] = PublicPlacementKinds.highMetalFence,
  ['morebuilds:jukebox'] = PublicPlacementKinds.jukebox,
  ['morebuilds:laundry-combo'] = PublicPlacementKinds.laundryCombo,
  ['morebuilds:laundry-dryer'] = PublicPlacementKinds.laundryDryer,
  ['morebuilds:laundry-washer'] = PublicPlacementKinds.laundryWasher,
  ['morebuilds:light'] = PublicPlacementKinds.light,
  ['morebuilds:mannequin'] = PublicPlacementKinds.mannequin,
  ['morebuilds:multi-container'] = PublicPlacementKinds.multiContainer,
  ['morebuilds:multi-furniture'] = PublicPlacementKinds.multiFurniture,
  ['morebuilds:multi-light'] = PublicPlacementKinds.multiLight,
  ['morebuilds:multi-stove'] = PublicPlacementKinds.multiStove,
  ['morebuilds:multi-wall-decoration'] = PublicPlacementKinds.multiWallDecoration,
  ['morebuilds:pillar'] = PublicPlacementKinds.pillar,
  ['morebuilds:radio'] = PublicPlacementKinds.radio,
  ['morebuilds:rug'] = PublicPlacementKinds.rug,
  ['morebuilds:stairs'] = PublicPlacementKinds.stairs,
  ['morebuilds:stove'] = PublicPlacementKinds.stove,
  ['morebuilds:table-decoration'] = PublicPlacementKinds.tableDecoration,
  ['morebuilds:table-light'] = PublicPlacementKinds.tableLight,
  ['morebuilds:television'] = PublicPlacementKinds.television,
  ['morebuilds:wall'] = PublicPlacementKinds.wall,
  ['morebuilds:wall-decoration'] = PublicPlacementKinds.wallDecoration,
  ['morebuilds:water-fixture'] = PublicPlacementKinds.waterFixture,
  ['morebuilds:water-pump'] = PublicPlacementKinds.waterPump,
  ['morebuilds:water-well'] = PublicPlacementKinds.waterWell,
  ['morebuilds:window'] = PublicPlacementKinds.window,
  ['morebuilds:window-frame'] = PublicPlacementKinds.windowFrame,
  ['morebuilds:window-wall'] = PublicPlacementKinds.windowWall,
}

local function appendDefinitions(entries)
  for _, definition in ipairs(entries) do
    definitions[#definitions + 1] = definition
  end
end

appendDefinitions(Architecture)
appendDefinitions(Appliances)
appendDefinitions(Bathroom)
appendDefinitions(Bedroom)
appendDefinitions(Commercial)
appendDefinitions(Furniture)
appendDefinitions(Mannequins)
appendDefinitions(Storage)
appendDefinitions(WallCabinets)
appendDefinitions(WindowTreatments)
appendDefinitions(Utilities)
appendDefinitions(Outdoors)
appendDefinitions(Decorations)
appendDefinitions(DecorExtras)
appendDefinitions(Other)

local function register(registry)
  for _, kind in ipairs(BuiltinKinds.createAll()) do
    registry:placementKind(kind)
  end
  for _, group in ipairs(CatalogData.groups) do
    registry:group(group)
  end
  for _, category in ipairs(CatalogData.categories) do
    registry:category(category)
  end
  registry:buildableEntity({
    id = 'morebuilds:entity:drying_rack_large',
    categoryId = 'outdoors:garden',
    sortKey = 150000,
    entityScript = 'Base.DryingRackLarge',
  })
  for _, definition in ipairs(definitions) do
    local registered = TableUtil.copy(definition)
    local constructor = placementConstructors[registered.placement.kind]
    assert(constructor ~= nil, 'missing public placement constructor: ' .. registered.placement.kind)
    registered.placement = constructor(registered.placement.data)
    registry:definition(registered)
  end
end

return register
