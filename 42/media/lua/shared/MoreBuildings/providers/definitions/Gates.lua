local definitions = {
  {
    ["id"] = "morebuilds:door:low:wrought_iron",
    ["sortKey"] = 9140,
    ["categoryId"] = "structure:doors",
    ["nameKey"] = "ContextMenu_MoreBuild_Wrought_IronDoor",
    ["descriptionKey"] = "Tooltip_MoreBuild_WroughtGate",
    ["recipeId"] = "MoreBuilds.FenceMetal",
    ["previewSprite"] = "fixtures_doors_fences_01_0",
    ["placement"] = {
      ["kind"] = "morebuilds:door",
      ["data"] = {
        ["health"] = 300,
        ["healthFromCarpentry"] = true,
        ["northSprite"] = "fixtures_doors_fences_01_1",
        ["sprite"] = "fixtures_doors_fences_01_0",
        ["openNorthSprite"] = "fixtures_doors_fences_01_3",
        ["openSprite"] = "fixtures_doors_fences_01_2",
		["dontNeedFrame"] = true
      },
    },
    ["salvagePolicy"] = "recipe-inputs",
  },
  {
    ["id"] = "morebuilds:door:low:slat_wooden",
    ["sortKey"] = 9150,
    ["categoryId"] = "structure:doors",
    ["nameKey"] = "ContextMenu_MoreBuild_Slat_Low_WoodenDoor",
    ["descriptionKey"] = "Tooltip_MoreBuild_DoorSlatWood",
    ["recipeId"] = "MoreBuilds.DoorLowWood",
    ["previewSprite"] = "fixtures_doors_fences_01_4",
    ["placement"] = {
      ["kind"] = "morebuilds:door",
      ["data"] = {
        ["health"] = 300,
        ["healthFromCarpentry"] = true,
        ["northSprite"] = "fixtures_doors_fences_01_5",
        ["sprite"] = "fixtures_doors_fences_01_4",
        ["openNorthSprite"] = "fixtures_doors_fences_01_7",
        ["openSprite"] = "fixtures_doors_fences_01_6",
		["dontNeedFrame"] = true
      },
    },
    ["salvagePolicy"] = "recipe-inputs",
  },
  {
    ["id"] = "morebuilds:door:low:white_wooden",
    ["sortKey"] = 9160,
    ["categoryId"] = "structure:doors",
    ["nameKey"] = "ContextMenu_MoreBuild_White_Low_WoodenDoor",
    ["descriptionKey"] = "Tooltip_MoreBuild_DoorLowWood",
    ["recipeId"] = "MoreBuilds.DoorLowWood",
    ["previewSprite"] = "fixtures_doors_fences_01_8",
    ["placement"] = {
      ["kind"] = "morebuilds:door",
      ["data"] = {
        ["health"] = 300,
        ["healthFromCarpentry"] = true,
        ["northSprite"] = "fixtures_doors_fences_01_9",
        ["sprite"] = "fixtures_doors_fences_01_8",
        ["openNorthSprite"] = "fixtures_doors_fences_01_11",
        ["openSprite"] = "fixtures_doors_fences_01_10",
		["dontNeedFrame"] = true
      },
    },
    ["salvagePolicy"] = "recipe-inputs",
  },
  {
    ["id"] = "morebuilds:door:other:wooden_gate",
    ["sortKey"] = 9170,
    ["categoryId"] = "structure:doors",
    ["nameKey"] = "ContextMenu_MoreBuild_WoodenGate",
    ["descriptionKey"] = "Tooltip_MoreBuild_DoorWoodenGate",
    ["recipeId"] = "MoreBuilds.DoorWood",
    ["previewSprite"] = "fixtures_doors_fences_01_12",
    ["placement"] = {
      ["kind"] = "morebuilds:door",
      ["data"] = {
        ["health"] = 300,
        ["healthFromCarpentry"] = true,
        ["northSprite"] = "fixtures_doors_fences_01_13",
        ["sprite"] = "fixtures_doors_fences_01_12",
        ["openNorthSprite"] = "fixtures_doors_fences_01_15",
        ["openSprite"] = "fixtures_doors_fences_01_14",
		["dontNeedFrame"] = true
      },
    },
    ["salvagePolicy"] = "recipe-inputs",
  }
}

return definitions
