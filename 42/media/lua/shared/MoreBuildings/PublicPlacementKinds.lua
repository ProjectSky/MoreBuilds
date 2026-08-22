local TableUtil = require('MoreBuildings/internal/TableUtil')
local BuiltinKinds = require('MoreBuildings/kinds/BuiltinKinds')

local PublicPlacementKinds = {}

local KIND_IDS = {
  attachedFloor = 'morebuilds:attached-floor',
  barbecue = 'morebuilds:barbecue',
  container = 'morebuilds:container',
  curtain = 'morebuilds:curtain',
  door = 'morebuilds:door',
  doorFrame = 'morebuilds:door-frame',
  entity = 'morebuilds:entity',
  feedingTrough = 'morebuilds:feeding-trough',
  fence = 'morebuilds:fence',
  fencePost = 'morebuilds:fence-post',
  fireplace = 'morebuilds:fireplace',
  floor = 'morebuilds:floor',
  furniture = 'morebuilds:furniture',
  garageDoor = 'morebuilds:garage-door',
  generator = 'morebuilds:generator',
  highMetalFence = 'morebuilds:high-metal-fence',
  jukebox = 'morebuilds:jukebox',
  laundryCombo = 'morebuilds:laundry-combo',
  laundryDryer = 'morebuilds:laundry-dryer',
  laundryWasher = 'morebuilds:laundry-washer',
  light = 'morebuilds:light',
  mannequin = 'morebuilds:mannequin',
  multiContainer = 'morebuilds:multi-container',
  multiFurniture = 'morebuilds:multi-furniture',
  multiLight = 'morebuilds:multi-light',
  multiStove = 'morebuilds:multi-stove',
  multiWallDecoration = 'morebuilds:multi-wall-decoration',
  pillar = 'morebuilds:pillar',
  radio = 'morebuilds:radio',
  rug = 'morebuilds:rug',
  stairs = 'morebuilds:stairs',
  stove = 'morebuilds:stove',
  tableDecoration = 'morebuilds:table-decoration',
  tableLight = 'morebuilds:table-light',
  television = 'morebuilds:television',
  wall = 'morebuilds:wall',
  wallDecoration = 'morebuilds:wall-decoration',
  waterFixture = 'morebuilds:water-fixture',
  waterPump = 'morebuilds:water-pump',
  waterWell = 'morebuilds:water-well',
  window = 'morebuilds:window',
  windowFrame = 'morebuilds:window-frame',
  windowWall = 'morebuilds:window-wall',
}

local dataFieldsByKind = {}
for _, kind in ipairs(BuiltinKinds.createAll()) do
  local fields = {}
  for _, field in ipairs(kind.dataFields) do
    fields[field] = true
  end
  dataFieldsByKind[kind.id] = fields
end

local function assertStaticData(data, name, fields)
  assert(type(data) == 'table', 'placement data must be a table: ' .. name)
  local stack = { { root = true, value = data } }
  local seen = {}
  while #stack > 0 do
    local frame = stack[#stack]
    stack[#stack] = nil
    local value = frame.value
    assert(seen[value] == nil, 'placement data must not be cyclic: ' .. name)
    seen[value] = true
    for key, nestedValue in pairs(value) do
      local keyType = type(key)
      local valueType = type(nestedValue)
      assert(keyType == 'string' or keyType == 'number', 'invalid placement data key: ' .. name)
      if frame.root then
        assert(keyType == 'string' and fields[key] == true, 'unsupported placement data field: ' .. name .. '.' .. tostring(key))
      end
      assert(valueType == 'boolean' or valueType == 'number' or valueType == 'string' or valueType == 'table',
        'non-static placement data value: ' .. name)
      if valueType == 'table' then
        stack[#stack + 1] = { root = false, value = nestedValue }
      end
    end
  end
end

local function descriptor(name, data)
  local kindId = KIND_IDS[name]
  assertStaticData(data, name, dataFieldsByKind[kindId])
  return {
    kind = kindId,
    data = TableUtil.copy(data),
  }
end

for name in pairs(KIND_IDS) do
  PublicPlacementKinds[name] = function(data)
    return descriptor(name, data)
  end
end

return PublicPlacementKinds
