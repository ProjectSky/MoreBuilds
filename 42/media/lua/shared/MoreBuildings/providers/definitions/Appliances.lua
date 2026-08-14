local definitions = {}

local function add(id, sortKey, nameKey, descriptionKey, recipeId, previewSprite, kind, data)
  definitions[#definitions + 1] = {
    id = id,
    sortKey = sortKey + 20000,
    categoryId = 'utilities:appliances',
    nameKey = nameKey,
    descriptionKey = descriptionKey,
    recipeId = recipeId,
    previewSprite = previewSprite,
    placement = {
      kind = kind,
      data = data,
    },
    salvagePolicy = 'recipe-inputs',
  }
end

local function addOutdoor(id, sortKey, nameKey, descriptionKey, recipeId, previewSprite, kind, data)
  definitions[#definitions + 1] = {
    id = id,
    sortKey = sortKey + 20000,
    categoryId = 'outdoors:garden',
    nameKey = nameKey,
    descriptionKey = descriptionKey,
    recipeId = recipeId,
    previewSprite = previewSprite,
    placement = {
      kind = kind,
      data = data,
    },
    salvagePolicy = 'recipe-inputs',
  }
end

local function rotation(sprite, northSprite, eastSprite, southSprite)
  return {
    sprite = sprite,
    northSprite = northSprite,
    eastSprite = eastSprite,
    southSprite = southSprite,
  }
end

add(
  'morebuilds:radio:valu_tech', 5160,
  'ContextMenu_MoreBuild_Name_radio_valu_tech', 'Tooltip_MoreBuild_Radio',
  'MoreBuilds.Radio', 'appliances_radio_01_0', 'morebuilds:radio',
  rotation('appliances_radio_01_0', 'appliances_radio_01_2', 'appliances_radio_01_1', 'appliances_radio_01_3')
)
add(
  'morebuilds:radio:premium_technologies', 5170,
  'ContextMenu_MoreBuild_Name_radio_premium_technologies', 'Tooltip_MoreBuild_Radio',
  'MoreBuilds.Radio', 'appliances_radio_01_8', 'morebuilds:radio',
  rotation('appliances_radio_01_8', 'appliances_radio_01_10', 'appliances_radio_01_9', 'appliances_radio_01_11')
)
add(
  'morebuilds:radio:makeshift', 5180,
  'ContextMenu_MoreBuild_Name_radio_makeshift', 'Tooltip_MoreBuild_Radio',
  'MoreBuilds.Radio', 'appliances_radio_01_16', 'morebuilds:radio',
  rotation('appliances_radio_01_16', 'appliances_radio_01_18', 'appliances_radio_01_17', 'appliances_radio_01_19')
)
add(
  'morebuilds:radio:premium_technologies_ham', 5190,
  'ContextMenu_MoreBuild_Name_radio_premium_technologies_ham', 'Tooltip_MoreBuild_Radio',
  'MoreBuilds.HamRadio', 'appliances_com_01_0', 'morebuilds:radio',
  rotation('appliances_com_01_0', 'appliances_com_01_2', 'appliances_com_01_1', 'appliances_com_01_3')
)
add(
  'morebuilds:radio:us_army_ham', 5200,
  'ContextMenu_MoreBuild_Name_radio_us_army_ham', 'Tooltip_MoreBuild_Radio',
  'MoreBuilds.HamRadio', 'appliances_com_01_8', 'morebuilds:radio',
  rotation('appliances_com_01_8', 'appliances_com_01_10', 'appliances_com_01_9', 'appliances_com_01_11')
)
add(
  'morebuilds:radio:makeshift_ham', 5210,
  'ContextMenu_MoreBuild_Name_radio_makeshift_ham', 'Tooltip_MoreBuild_Radio',
  'MoreBuilds.HamRadio', 'appliances_com_01_56', 'morebuilds:radio',
  rotation('appliances_com_01_56', 'appliances_com_01_58', 'appliances_com_01_57', 'appliances_com_01_59')
)

add(
  'morebuilds:television:premium_technologies', 5220,
  'ContextMenu_MoreBuild_Name_television_premium_technologies', 'Tooltip_MoreBuild_Television',
  'MoreBuilds.Television', 'appliances_television_01_0', 'morebuilds:television',
  rotation('appliances_television_01_0', 'appliances_television_01_3', 'appliances_television_01_1', 'appliances_television_01_2')
)
add(
  'morebuilds:television:valu_tech', 5230,
  'ContextMenu_MoreBuild_Name_television_valu_tech', 'Tooltip_MoreBuild_Television',
  'MoreBuilds.Television', 'appliances_television_01_4', 'morebuilds:television',
  rotation('appliances_television_01_4', 'appliances_television_01_6', 'appliances_television_01_5', 'appliances_television_01_7')
)
add(
  'morebuilds:television:antique', 5240,
  'ContextMenu_MoreBuild_Name_television_antique', 'Tooltip_MoreBuild_Television',
  'MoreBuilds.Television', 'appliances_television_01_8', 'morebuilds:television',
  rotation('appliances_television_01_8', 'appliances_television_01_11', 'appliances_television_01_9', 'appliances_television_01_10')
)

add(
  'morebuilds:jukebox:oldies', 5305,
  'ContextMenu_MoreBuild_Name_jukebox_oldies', 'Tooltip_MoreBuild_OldiesJukebox',
  'MoreBuilds.Jukebox', 'recreational_01_0', 'morebuilds:jukebox',
  rotation('recreational_01_0', 'recreational_01_1')
)

add(
  'morebuilds:laundry:combo_blue', 5250,
  'ContextMenu_MoreBuild_Name_laundry_combo_blue', 'Tooltip_MoreBuild_ComboWasherDryer',
  'MoreBuilds.LaundryMachine', 'appliances_laundry_01_0', 'morebuilds:laundry-combo',
  rotation('appliances_laundry_01_0', 'appliances_laundry_01_2', 'appliances_laundry_01_1', 'appliances_laundry_01_3')
)
add(
  'morebuilds:laundry:washer_white', 5260,
  'ContextMenu_MoreBuild_Name_laundry_washer_white', 'Tooltip_MoreBuild_WashingMachine',
  'MoreBuilds.LaundryMachine', 'appliances_laundry_01_4', 'morebuilds:laundry-washer',
  rotation('appliances_laundry_01_4', 'appliances_laundry_01_6', 'appliances_laundry_01_5', 'appliances_laundry_01_7')
)
add(
  'morebuilds:laundry:dryer_white', 5270,
  'ContextMenu_MoreBuild_Name_laundry_dryer_white', 'Tooltip_MoreBuild_ClothingDryer',
  'MoreBuilds.LaundryMachine', 'appliances_laundry_01_12', 'morebuilds:laundry-dryer',
  rotation('appliances_laundry_01_12', 'appliances_laundry_01_14', 'appliances_laundry_01_13', 'appliances_laundry_01_15')
)

add(
  'morebuilds:barbecue:hector_lopez', 5280,
  'ContextMenu_MoreBuild_Name_barbecue_hector_lopez', 'Tooltip_MoreBuild_PropaneGrill',
  'MoreBuilds.PropaneGrill', 'appliances_cooking_01_36', 'morebuilds:barbecue',
  rotation('appliances_cooking_01_36', 'appliances_cooking_01_38', 'appliances_cooking_01_37', 'appliances_cooking_01_39')
)

addOutdoor(
  'morebuilds:feeding_trough:large_metal', 5290,
  'ContextMenu_MoreBuild_Name_feeding_trough_large_metal', 'Tooltip_MoreBuild_LargeMetalTrough',
  'MoreBuilds.LargeMetalTrough', 'location_farm_accesories_01_29', 'morebuilds:feeding-trough',
  {
    sprite = 'location_farm_accesories_01_29',
    northSprite = 'location_farm_accesories_01_24',
  }
)

return definitions
