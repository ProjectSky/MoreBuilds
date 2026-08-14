local FurnitureKinds = require('MoreBuildings/kinds/FurnitureKinds')
local OpeningKinds = require('MoreBuildings/kinds/OpeningKinds')
local StructuralKinds = require('MoreBuildings/kinds/StructuralKinds')
local MultiTileKinds = require('MoreBuildings/kinds/MultiTileKinds')
local SpecialKinds = require('MoreBuildings/kinds/SpecialKinds')

local BuiltinKinds = {}

function BuiltinKinds.createAll()
  local kinds = {}
  local structuralKinds = StructuralKinds.createAll()
  local furnitureKinds = FurnitureKinds.createAll()
  local openingKinds = OpeningKinds.createAll()
  local multiTileKinds = MultiTileKinds.createAll()
  local specialKinds = SpecialKinds.createAll()
  local seen = {}
  local kindSets = { structuralKinds, furnitureKinds, openingKinds, multiTileKinds, specialKinds }
  for _, kindSet in ipairs(kindSets) do
    for _, kind in ipairs(kindSet) do
      assert(seen[kind.id] == nil, 'duplicate built-in placement kind: ' .. kind.id)
      seen[kind.id] = true
      kind.manifest = { family = kind.id }
      kinds[#kinds + 1] = kind
    end
  end
  return kinds
end

return BuiltinKinds
