local definitions = {}

local function rotation(sprite, northSprite, eastSprite, southSprite)
  return {
    sprite = sprite,
    northSprite = northSprite,
    eastSprite = eastSprite,
    southSprite = southSprite,
  }
end

local function add(id, sortKey, nameKey, recipeId, previewSprite, health, data)
  definitions[#definitions + 1] = {
    id = id,
    sortKey = sortKey,
    categoryId = 'utilities:water-sanitation',
    nameKey = nameKey,
    descriptionKey = 'Tooltip_MoreBuild_PlumbableFixture',
    recipeId = recipeId,
    previewSprite = previewSprite,
    placement = {
      kind = 'morebuilds:water-fixture',
      data = {
        health = health,
        sprite = data.sprite,
        northSprite = data.northSprite,
        eastSprite = data.eastSprite,
        southSprite = data.southSprite,
      },
    },
    salvagePolicy = 'recipe-inputs',
  }
end

add('morebuilds:toilet:ceramic_white', 5300, 'ContextMenu_MoreBuild_Name_toilet_ceramic_white', 'MoreBuilds.CeramicPlumbingFixture', 'fixtures_bathroom_01_0', 150,
  rotation('fixtures_bathroom_01_0', 'fixtures_bathroom_01_1', 'fixtures_bathroom_01_3', 'fixtures_bathroom_01_2'))
add('morebuilds:toilet:low', 5310, 'ContextMenu_MoreBuild_Name_toilet_low', 'MoreBuilds.CeramicPlumbingFixture', 'fixtures_bathroom_01_4', 150,
  rotation('fixtures_bathroom_01_4', 'fixtures_bathroom_01_5', 'fixtures_bathroom_01_7', 'fixtures_bathroom_01_6'))

add('morebuilds:sink:white', 5320, 'ContextMenu_MoreBuild_Name_sink_white', 'MoreBuilds.CeramicPlumbingFixture', 'fixtures_sinks_01_2', 100,
  rotation('fixtures_sinks_01_2', 'fixtures_sinks_01_1', 'fixtures_sinks_01_0', 'fixtures_sinks_01_3'))
add('morebuilds:sink:porcelain_industrial', 5330, 'ContextMenu_MoreBuild_Name_sink_porcelain_industrial', 'MoreBuilds.CeramicPlumbingFixture', 'fixtures_sinks_01_5', 100,
  rotation('fixtures_sinks_01_5', 'fixtures_sinks_01_4', 'fixtures_sinks_01_7', 'fixtures_sinks_01_6'))
add('morebuilds:sink:chrome', 5340, 'ContextMenu_MoreBuild_Name_sink_chrome', 'MoreBuilds.CeramicPlumbingFixture', 'fixtures_sinks_01_9', 100,
  rotation('fixtures_sinks_01_9', 'fixtures_sinks_01_8', 'fixtures_sinks_01_11', 'fixtures_sinks_01_10'))
add('morebuilds:sink:standing_white', 5350, 'ContextMenu_MoreBuild_Name_sink_standing_white', 'MoreBuilds.CeramicPlumbingFixture', 'fixtures_sinks_01_12', 120,
  rotation('fixtures_sinks_01_12', 'fixtures_sinks_01_13', 'fixtures_sinks_01_28', 'fixtures_sinks_01_29'))
add('morebuilds:sink:hanging_white', 5360, 'ContextMenu_MoreBuild_Name_sink_hanging_white', 'MoreBuilds.CeramicPlumbingFixture', 'fixtures_sinks_01_14', 100,
  rotation('fixtures_sinks_01_14', 'fixtures_sinks_01_15', 'fixtures_sinks_01_30', 'fixtures_sinks_01_31'))
add('morebuilds:sink:dark_industrial', 5370, 'ContextMenu_MoreBuild_Name_sink_dark_industrial', 'MoreBuilds.CeramicPlumbingFixture', 'fixtures_sinks_01_17', 100,
  rotation('fixtures_sinks_01_17', 'fixtures_sinks_01_16', 'fixtures_sinks_01_19', 'fixtures_sinks_01_18'))
add('morebuilds:sink:beige', 5380, 'ContextMenu_MoreBuild_Name_sink_beige', 'MoreBuilds.CeramicPlumbingFixture', 'fixtures_sinks_01_22', 100,
  rotation('fixtures_sinks_01_22', 'fixtures_sinks_01_21', 'fixtures_sinks_01_20', 'fixtures_sinks_01_23'))
add('morebuilds:sink:fancy_hanging', 5390, 'ContextMenu_MoreBuild_Name_sink_fancy_hanging', 'MoreBuilds.CeramicPlumbingFixture', 'fixtures_sinks_01_24', 100,
  rotation('fixtures_sinks_01_24', 'fixtures_sinks_01_25'))
add('morebuilds:sink:large_industrial', 5400, 'ContextMenu_MoreBuild_Name_sink_large_industrial', 'MoreBuilds.IndustrialSink', 'fixtures_sinks_01_33', 250,
  rotation('fixtures_sinks_01_33', 'fixtures_sinks_01_32', 'fixtures_sinks_01_35', 'fixtures_sinks_01_34'))
add('morebuilds:shower:deluxe_white', 5410, 'ContextMenu_MoreBuild_Name_shower_deluxe_white', 'MoreBuilds.CeramicPlumbingFixture', 'fixtures_bathroom_01_32', 100,
  rotation('fixtures_bathroom_01_32', 'fixtures_bathroom_01_33'))

definitions[#definitions + 1] = {
  id = 'morebuilds:bath:large_deluxe',
  sortKey = 5415,
  categoryId = 'furniture:bedroom-leisure',
  nameKey = 'ContextMenu_MoreBuild_Name_bath_large_deluxe',
  descriptionKey = 'Tooltip_MoreBuild_DecorativeBath',
  recipeId = 'MoreBuilds.LargeBathroomFixture',
  previewSprite = 'fixtures_bathroom_01_26',
  placement = {
    kind = 'morebuilds:multi-furniture',
    data = {
      eastSprite = 'fixtures_bathroom_01_54',
      health = 250,
      northSprite = 'fixtures_bathroom_01_25',
      southSprite = 'fixtures_bathroom_01_53',
      sprite = 'fixtures_bathroom_01_26',
    },
  },
  salvagePolicy = 'recipe-inputs',
}

for _, definition in ipairs(definitions) do
  definition.sortKey = definition.sortKey + 30000
end

return definitions
