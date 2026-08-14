local definitions = {
  {
    id = 'morebuilds:bed:light_wood',
    sortKey = 5420,
    categoryId = 'furniture:bedroom-leisure',
    nameKey = 'ContextMenu_MoreBuild_Name_bed_light_wood',
    descriptionKey = 'Tooltip_MoreBuild_Bed',
    recipeId = 'MoreBuilds.Bed',
    previewSprite = 'furniture_bedding_01_88',
    placement = {
      kind = 'morebuilds:multi-furniture',
      data = {
        health = 200,
        healthFromCarpentry = true,
        northSprite = 'furniture_bedding_01_91',
        sprite = 'furniture_bedding_01_88',
      },
    },
    salvagePolicy = 'recipe-inputs',
  },
  {
    id = 'morebuilds:bed:oak',
    sortKey = 5430,
    categoryId = 'furniture:bedroom-leisure',
    nameKey = 'ContextMenu_MoreBuild_Name_bed_oak',
    descriptionKey = 'Tooltip_MoreBuild_Bed',
    recipeId = 'MoreBuilds.Bed',
    previewSprite = 'furniture_bedding_01_92',
    placement = {
      kind = 'morebuilds:multi-furniture',
      data = {
        health = 200,
        healthFromCarpentry = true,
        northSprite = 'furniture_bedding_01_95',
        sprite = 'furniture_bedding_01_92',
      },
    },
    salvagePolicy = 'recipe-inputs',
  },
  {
    id = 'morebuilds:bed:large_oak',
    sortKey = 5440,
    categoryId = 'furniture:bedroom-leisure',
    nameKey = 'ContextMenu_MoreBuild_Name_bed_large_oak',
    descriptionKey = 'Tooltip_MoreBuild_Bed',
    recipeId = 'MoreBuilds.DoubleBed',
    previewSprite = 'furniture_bedding_01_50',
    placement = {
      kind = 'morebuilds:multi-furniture',
      data = {
        eastSprite = 'furniture_bedding_01_42',
        health = 300,
        healthFromCarpentry = true,
        northSprite = 'furniture_bedding_01_53',
        southSprite = 'furniture_bedding_01_45',
        sprite = 'furniture_bedding_01_50',
      },
    },
    salvagePolicy = 'recipe-inputs',
  },
  {
    id = 'morebuilds:bed:hospital',
    sortKey = 5445,
    categoryId = 'furniture:bedroom-leisure',
    nameKey = 'ContextMenu_MoreBuild_Name_bed_hospital',
    descriptionKey = 'Tooltip_MoreBuild_Bed',
    recipeId = 'MoreBuilds.Bed',
    previewSprite = 'furniture_bedding_01_66',
    placement = {
      kind = 'morebuilds:multi-furniture',
      data = {
        health = 200,
        healthFromCarpentry = true,
        northSprite = 'furniture_bedding_01_65',
        sprite = 'furniture_bedding_01_66',
      },
    },
    salvagePolicy = 'recipe-inputs',
  },
  {
    id = 'morebuilds:bed:large_fancy',
    sortKey = 7860,
    categoryId = 'furniture:bedroom-leisure',
    nameKey = 'ContextMenu_MoreBuild_Name_bed_large_fancy',
    descriptionKey = 'Tooltip_MoreBuild_Bed',
    recipeId = 'MoreBuilds.DoubleBed',
    previewSprite = 'furniture_bedding_01_15',
    placement = {
      kind = 'morebuilds:multi-furniture',
      data = {
        eastSprite = 'furniture_bedding_01_82',
        health = 300,
        healthFromCarpentry = true,
        northSprite = 'furniture_bedding_01_73',
        southSprite = 'furniture_bedding_01_5',
        sprite = 'furniture_bedding_01_15',
      },
    },
    salvagePolicy = 'recipe-inputs',
  },
}

for _, definition in ipairs(definitions) do
  definition.sortKey = definition.sortKey + 40000
end

return definitions
