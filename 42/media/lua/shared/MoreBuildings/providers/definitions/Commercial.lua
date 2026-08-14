local definitions = {}

local function addContainer(id, sortKey, nameKey, descriptionKey, recipeId, sprite, data, multi)
  data.sprite = sprite
  definitions[#definitions + 1] = {
    id = id,
    sortKey = sortKey,
    categoryId = 'storage:shelves-counters',
    nameKey = nameKey,
    descriptionKey = descriptionKey,
    recipeId = recipeId,
    previewSprite = sprite,
    placement = {
      kind = multi and 'morebuilds:multi-container' or 'morebuilds:container',
      data = data,
    },
    salvagePolicy = 'recipe-inputs',
  }
end

local woodShelf = {
  canBeLockedByPadlock = false,
  containerType = 'shelves',
  health = 200,
  healthFromCarpentry = true,
}

addContainer('morebuilds:commercial:comics_store_shelves', 6050,
  'ContextMenu_MoreBuild_Name_commercial_comics_store_shelves', 'Tooltip_MoreBuild_CommercialWoodShelf',
  'MoreBuilds.StorageWood', 'location_shop_generic_01_0', {
    canBeLockedByPadlock = woodShelf.canBeLockedByPadlock,
    containerCapacity = 20,
    containerType = woodShelf.containerType,
    health = woodShelf.health,
    healthFromCarpentry = woodShelf.healthFromCarpentry,
    northSprite = 'location_shop_generic_01_1',
  })

addContainer('morebuilds:commercial:beige_magazine_shelves', 6060,
  'ContextMenu_MoreBuild_Name_commercial_beige_magazine_shelves', 'Tooltip_MoreBuild_CommercialWoodShelf',
  'MoreBuilds.StorageWood', 'location_shop_generic_01_3', {
    canBeLockedByPadlock = woodShelf.canBeLockedByPadlock,
    containerCapacity = 20,
    containerType = woodShelf.containerType,
    health = woodShelf.health,
    healthFromCarpentry = woodShelf.healthFromCarpentry,
    northSprite = 'location_shop_generic_01_2',
  })

addContainer('morebuilds:commercial:beige_rack_shelves', 6070,
  'ContextMenu_MoreBuild_Name_commercial_beige_rack_shelves', 'Tooltip_MoreBuild_CommercialWoodShelf',
  'MoreBuilds.CommercialTallWoodShelves', 'location_shop_generic_01_15', {
    canBeLockedByPadlock = false,
    containerCapacity = 20,
    containerType = 'shelves',
    health = 350,
    healthFromCarpentry = true,
    northSprite = 'location_shop_generic_01_8',
  }, true)

addContainer('morebuilds:commercial:rounded_glass_display', 6080,
  'ContextMenu_MoreBuild_Name_commercial_rounded_glass_display', 'Tooltip_MoreBuild_CommercialGlassDisplay',
  'MoreBuilds.CommercialRoundedGlassDisplay', 'location_shop_generic_01_33', {
    canBeLockedByPadlock = false,
    containerCapacity = 20,
    containerType = 'displaycasebakery',
    eastSprite = 'location_shop_generic_01_113',
    health = 300,
    healthFromCarpentry = true,
    northSprite = 'location_shop_generic_01_34',
    southSprite = 'location_shop_generic_01_114',
  }, true)

addContainer('morebuilds:commercial:large_clothes_rack', 6090,
  'ContextMenu_MoreBuild_Name_commercial_large_clothes_rack', 'Tooltip_MoreBuild_CommercialMetalClothesRack',
  'MoreBuilds.CommercialMetalClothesRack', 'location_shop_generic_01_37', {
    canBeLockedByPadlock = false,
    containerType = 'clothingrack',
    health = 300,
    northSprite = 'location_shop_generic_01_38',
  }, true)

addContainer('morebuilds:commercial:long_clothes_rack', 6100,
  'ContextMenu_MoreBuild_Name_commercial_long_shelves', 'Tooltip_MoreBuild_CommercialWoodShelf',
  'MoreBuilds.CommercialTallWoodShelves', 'location_shop_generic_01_47', {
    canBeLockedByPadlock = false,
    containerCapacity = 25,
    containerType = 'clothingrack',
    health = 350,
    healthFromCarpentry = true,
    northSprite = 'location_shop_generic_01_40',
  }, true)

addContainer('morebuilds:commercial:small_clothes_rack', 6110,
  'ContextMenu_MoreBuild_Name_commercial_small_clothes_rack', 'Tooltip_MoreBuild_CommercialMetalClothesRack',
  'MoreBuilds.CommercialMetalClothesRack', 'location_shop_generic_01_49', {
    canBeLockedByPadlock = false,
    containerType = 'clothingrack',
    health = 250,
    northSprite = 'location_shop_generic_01_50',
  }, true)

addContainer('morebuilds:commercial:open_wardrobe', 6120,
  'ContextMenu_MoreBuild_Name_commercial_open_wardrobe', 'Tooltip_MoreBuild_CommercialWoodShelf',
  'MoreBuilds.CommercialOpenWardrobe', 'location_shop_generic_01_58', {
    canBeLockedByPadlock = false,
    containerCapacity = 25,
    containerType = 'clothingrack',
    health = 350,
    healthFromCarpentry = true,
    northSprite = 'location_shop_generic_01_59',
  }, true)

addContainer('morebuilds:commercial:large_store_shelves', 6130,
  'ContextMenu_MoreBuild_Name_commercial_large_store_shelves', 'Tooltip_MoreBuild_CommercialWoodShelf',
  'MoreBuilds.CommercialLargeStoreShelves', 'location_shop_generic_01_75', {
    canBeLockedByPadlock = false,
    containerType = 'shelves',
    eastSprite = 'location_shop_generic_01_79',
    health = 350,
    healthFromCarpentry = true,
    northSprite = 'location_shop_generic_01_72',
    southSprite = 'location_shop_generic_01_76',
  }, true)

addContainer('morebuilds:commercial:white_display_counter', 6140,
  'ContextMenu_MoreBuild_Name_commercial_white_display_counter', 'Tooltip_MoreBuild_CommercialGlassDisplay',
  'MoreBuilds.CommercialLargeGlassDisplay', 'location_shop_generic_01_85', {
    canBeLockedByPadlock = false,
    containerType = 'displaycasebutcher',
    health = 300,
    healthFromCarpentry = true,
    northSprite = 'location_shop_generic_01_80',
  }, true)

addContainer('morebuilds:commercial:store_display_counter', 6150,
  'ContextMenu_MoreBuild_Name_commercial_store_display_counter', 'Tooltip_MoreBuild_CommercialWoodShelf',
  'MoreBuilds.StorageWood', 'location_shop_generic_01_89', {
    canBeLockedByPadlock = false,
    containerCapacity = 20,
    containerType = 'grocerstand',
    eastSprite = 'location_shop_generic_01_90',
    health = 200,
    healthFromCarpentry = true,
    northSprite = 'location_shop_generic_01_88',
    southSprite = 'location_shop_generic_01_91',
  })

addContainer('morebuilds:commercial:trapezoid_store_shelves', 6160,
  'ContextMenu_MoreBuild_Name_commercial_trapezoid_store_shelves', 'Tooltip_MoreBuild_CommercialWoodShelf',
  'MoreBuilds.StorageWood', 'location_shop_generic_01_93', {
    canBeLockedByPadlock = false,
    containerCapacity = 20,
    containerType = 'grocerstand',
    eastSprite = 'location_shop_generic_01_94',
    health = 200,
    healthFromCarpentry = true,
    northSprite = 'location_shop_generic_01_92',
    southSprite = 'location_shop_generic_01_95',
  })

addContainer('morebuilds:commercial:glass_corner_display_counter', 6170,
  'ContextMenu_MoreBuild_Name_commercial_glass_corner_display_counter', 'Tooltip_MoreBuild_CommercialMetalGlassDisplay',
  'MoreBuilds.CommercialMetalGlassDisplay', 'location_shop_generic_01_102', {
    canBeLockedByPadlock = false,
    containerCapacity = 20,
    containerType = 'displaycase',
    eastSprite = 'location_shop_generic_01_98',
    health = 250,
    northSprite = 'location_shop_generic_01_96',
    southSprite = 'location_shop_generic_01_100',
  })

addContainer('morebuilds:commercial:glass_display_counter', 6180,
  'ContextMenu_MoreBuild_Name_commercial_glass_display_counter', 'Tooltip_MoreBuild_CommercialMetalGlassDisplay',
  'MoreBuilds.CommercialMetalGlassDisplay', 'location_shop_generic_01_103', {
    canBeLockedByPadlock = false,
    containerCapacity = 20,
    containerType = 'displaycase',
    eastSprite = 'location_shop_generic_01_99',
    health = 250,
    northSprite = 'location_shop_generic_01_97',
    southSprite = 'location_shop_generic_01_101',
  })

addContainer('morebuilds:commercial:generic_low_shelves', 6190,
  'ContextMenu_MoreBuild_Name_commercial_generic_low_shelves', 'Tooltip_MoreBuild_CommercialWoodShelf',
  'MoreBuilds.StorageWood', 'location_shop_generic_01_109', {
    canBeLockedByPadlock = false,
    containerType = 'counter',
    health = 200,
    healthFromCarpentry = true,
    northSprite = 'location_shop_generic_01_108',
  })

addContainer('morebuilds:commercial:small_black_display', 6200,
  'ContextMenu_MoreBuild_Name_commercial_small_black_display', 'Tooltip_MoreBuild_CommercialMetalDisplay',
  'MoreBuilds.CommercialMetalDisplay', 'location_shop_generic_01_120', {
    canBeLockedByPadlock = false,
    containerCapacity = 5,
    containerType = 'shelves',
    eastSprite = 'location_shop_generic_01_122',
    health = 150,
    northSprite = 'location_shop_generic_01_121',
    southSprite = 'location_shop_generic_01_123',
  })

addContainer('morebuilds:commercial:zippee_shelves_rack', 6210,
  'ContextMenu_MoreBuild_Name_commercial_zippee_shelves_rack', 'Tooltip_MoreBuild_CommercialWoodShelf',
  'MoreBuilds.CommercialTallWoodShelves', 'location_shop_zippee_01_15', {
    canBeLockedByPadlock = false,
    containerType = 'shelves',
    health = 350,
    healthFromCarpentry = true,
    northSprite = 'location_shop_zippee_01_8',
  }, true)

addContainer('morebuilds:commercial:red_magazine_shelf', 6220,
  'ContextMenu_MoreBuild_Name_commercial_red_magazine_shelf', 'Tooltip_MoreBuild_CommercialWoodShelf',
  'MoreBuilds.StorageWoodLarge', 'location_shop_zippee_01_33', {
    canBeLockedByPadlock = false,
    containerCapacity = 15,
    containerType = 'shelvesmag',
    eastSprite = 'location_shop_zippee_01_27',
    health = 200,
    healthFromCarpentry = true,
    northSprite = 'location_shop_zippee_01_25',
    southSprite = 'location_shop_zippee_01_34',
  }, true)

addContainer('morebuilds:commercial:greenes_grocery_display_counter', 6230,
  'ContextMenu_MoreBuild_Name_commercial_greenes_grocery_display_counter', 'Tooltip_MoreBuild_CommercialWoodShelf',
  'MoreBuilds.StorageWood', 'location_shop_greenes_01_25', {
    canBeLockedByPadlock = false,
    containerCapacity = 20,
    containerType = 'grocerstand',
    eastSprite = 'location_shop_greenes_01_26',
    health = 200,
    healthFromCarpentry = true,
    northSprite = 'location_shop_greenes_01_24',
    southSprite = 'location_shop_greenes_01_27',
  })

addContainer('morebuilds:commercial:grocery_trapezoid_counter', 6240,
  'ContextMenu_MoreBuild_Name_commercial_grocery_trapezoid_counter', 'Tooltip_MoreBuild_CommercialWoodShelf',
  'MoreBuilds.StorageWood', 'location_shop_greenes_01_29', {
    canBeLockedByPadlock = false,
    containerCapacity = 20,
    containerType = 'displaycasebakery',
    eastSprite = 'location_shop_greenes_01_30',
    health = 200,
    healthFromCarpentry = true,
    northSprite = 'location_shop_greenes_01_28',
    southSprite = 'location_shop_greenes_01_31',
  })

addContainer('morebuilds:commercial:beige_wall_shelves', 6250,
  'ContextMenu_MoreBuild_Name_commercial_beige_wall_shelves', 'Tooltip_MoreBuild_CommercialWallShelf',
  'MoreBuilds.WallCabinetWood', 'location_shop_generic_01_31', {
    blockAllTheSquare = false,
    canBeLockedByPadlock = false,
    containerType = 'shelves',
    eastSprite = 'location_shop_generic_01_28',
    health = 150,
    healthFromCarpentry = true,
    needToBeAgainstWall = true,
    northSprite = 'location_shop_generic_01_30',
    southSprite = 'location_shop_generic_01_29',
  })

addContainer('morebuilds:commercial:clothing_wall_shelves', 6260,
  'ContextMenu_MoreBuild_Name_commercial_clothing_wall_shelves', 'Tooltip_MoreBuild_CommercialWallShelf',
  'MoreBuilds.WallCabinetWood', 'location_shop_generic_01_53', {
    blockAllTheSquare = false,
    canBeLockedByPadlock = false,
    containerType = 'clothingrack',
    health = 150,
    healthFromCarpentry = true,
    needToBeAgainstWall = true,
    northSprite = 'location_shop_generic_01_54',
  })

addContainer('morebuilds:commercial:wooden_wall_shelves', 6270,
  'ContextMenu_MoreBuild_Name_commercial_wooden_wall_shelves', 'Tooltip_MoreBuild_CommercialWallShelf',
  'MoreBuilds.WallCabinetWood', 'location_shop_generic_01_63', {
    blockAllTheSquare = false,
    canBeLockedByPadlock = false,
    containerCapacity = 25,
    containerType = 'shelves',
    eastSprite = 'location_shop_generic_01_119',
    health = 150,
    healthFromCarpentry = true,
    needToBeAgainstWall = true,
    northSprite = 'location_shop_generic_01_62',
    southSprite = 'location_shop_generic_01_118',
  })

addContainer('morebuilds:commercial:fancy_wooden_wall_shelves', 6280,
  'ContextMenu_MoreBuild_Name_commercial_fancy_wooden_wall_shelves', 'Tooltip_MoreBuild_CommercialWallShelf',
  'MoreBuilds.WallCabinetWood', 'location_shop_generic_01_87', {
    blockAllTheSquare = false,
    canBeLockedByPadlock = false,
    containerCapacity = 15,
    containerType = 'shelves',
    eastSprite = 'location_shop_generic_01_117',
    health = 150,
    healthFromCarpentry = true,
    needToBeAgainstWall = true,
    northSprite = 'location_shop_generic_01_86',
    southSprite = 'location_shop_generic_01_116',
  })

addContainer('morebuilds:commercial:zippee_wall_shelves', 6290,
  'ContextMenu_MoreBuild_Name_commercial_zippee_wall_shelves', 'Tooltip_MoreBuild_CommercialWallShelf',
  'MoreBuilds.WallCabinetWood', 'location_shop_zippee_01_3', {
    blockAllTheSquare = false,
    canBeLockedByPadlock = false,
    containerType = 'shelves',
    eastSprite = 'location_shop_zippee_01_0',
    health = 150,
    healthFromCarpentry = true,
    needToBeAgainstWall = true,
    northSprite = 'location_shop_zippee_01_2',
    southSprite = 'location_shop_zippee_01_1',
  })

addContainer('morebuilds:commercial:zippee_low_wall_shelves', 6300,
  'ContextMenu_MoreBuild_Name_commercial_zippee_low_wall_shelves', 'Tooltip_MoreBuild_CommercialWallShelf',
  'MoreBuilds.WallCabinetWood', 'location_shop_zippee_01_5', {
    blockAllTheSquare = false,
    canBeLockedByPadlock = false,
    containerType = 'shelves',
    eastSprite = 'location_shop_zippee_01_63',
    health = 150,
    healthFromCarpentry = true,
    needToBeAgainstWall = true,
    northSprite = 'location_shop_zippee_01_4',
    southSprite = 'location_shop_zippee_01_62',
  })

addContainer('morebuilds:commercial:pie_glass_display_stand', 7960,
  'ContextMenu_MoreBuild_Name_commercial_pie_glass_display_stand', 'Tooltip_MoreBuild_CommercialGlassDisplay',
  'MoreBuilds.CounterWoodGlassLarge', 'location_restaurant_pie_01_49', {
    canBeLockedByPadlock = false,
    containerCapacity = 20,
    containerType = 'displaycasebakery',
    eastSprite = 'location_restaurant_pie_01_33',
    health = 250,
    healthFromCarpentry = true,
    northSprite = 'location_restaurant_pie_01_34',
    southSprite = 'location_restaurant_pie_01_50',
  }, true)

addContainer('morebuilds:commercial:pie_display_stand', 7970,
  'ContextMenu_MoreBuild_Name_commercial_pie_display_stand', 'Tooltip_MoreBuild_PieDisplayStand',
  'MoreBuilds.PieDisplayStand', 'location_restaurant_pie_01_53', {
    canBeLockedByPadlock = false,
    containerCapacity = 20,
    containerType = 'displaycasebakery',
    eastSprite = 'location_restaurant_pie_01_55',
    health = 150,
    healthFromCarpentry = true,
    northSprite = 'location_restaurant_pie_01_54',
    southSprite = 'location_restaurant_pie_01_52',
  })

addContainer('morebuilds:commercial:pizza_glass_display', 7980,
  'ContextMenu_MoreBuild_Name_commercial_pizza_glass_display', 'Tooltip_MoreBuild_CommercialMetalGlassDisplay',
  'MoreBuilds.RestaurantWoodGlassDisplay', 'location_restaurant_pizzawhirled_01_65', {
    canBeLockedByPadlock = false,
    containerCapacity = 20,
    containerType = 'restaurantdisplay',
    eastSprite = 'location_restaurant_pizzawhirled_01_69',
    health = 275,
    healthFromCarpentry = true,
    northSprite = 'location_restaurant_pizzawhirled_01_70',
    southSprite = 'location_restaurant_pizzawhirled_01_66',
  }, true)

addContainer('morebuilds:commercial:coffee_glass_display', 7990,
  'ContextMenu_MoreBuild_Name_commercial_coffee_glass_display', 'Tooltip_MoreBuild_CommercialMetalGlassDisplay',
  'MoreBuilds.RestaurantWoodGlassDisplay', 'location_restaurant_seahorse_01_59', {
    canBeLockedByPadlock = false,
    containerCapacity = 20,
    containerType = 'restaurantdisplay',
    eastSprite = 'location_restaurant_seahorse_01_61',
    health = 275,
    healthFromCarpentry = true,
    northSprite = 'location_restaurant_seahorse_01_62',
    southSprite = 'location_restaurant_seahorse_01_56',
  }, true)

addContainer('morebuilds:commercial:blue_magazine_shelf', 13782,
  'ContextMenu_MoreBuild_Name_commercial_blue_magazine_shelf', 'Tooltip_MoreBuild_CommercialWoodShelf',
  'MoreBuilds.CommercialMagazineShelf', 'location_shop_fossoil_01_37', {
    canBeLockedByPadlock = false,
    containerCapacity = 15,
    containerType = 'shelvesmag',
    eastSprite = 'location_shop_fossoil_01_65',
    health = 200,
    healthFromCarpentry = true,
    northSprite = 'location_shop_fossoil_01_66',
    southSprite = 'location_shop_fossoil_01_35',
  }, true)

definitions[#definitions + 1] = {
  id = 'morebuilds:commercial:cash_register',
  sortKey = 13790,
  categoryId = 'storage:shelves-counters',
  nameKey = 'ContextMenu_MoreBuild_Name_commercial_cash_register',
  descriptionKey = 'Tooltip_MoreBuild_CashRegister',
  recipeId = 'MoreBuilds.CashRegister',
  previewSprite = 'location_shop_accessories_01_0',
  placement = {
    kind = 'morebuilds:table-decoration',
    data = {
      canBeLockedByPadlock = false,
      containerCapacity = 5,
      containerType = 'cashregister',
      eastSprite = 'location_shop_accessories_01_3',
      health = 100,
      northSprite = 'location_shop_accessories_01_1',
      southSprite = 'location_shop_accessories_01_2',
      sprite = 'location_shop_accessories_01_0',
    },
  },
  salvagePolicy = 'recipe-inputs',
}

definitions[#definitions + 1] = {
  id = 'morebuilds:commercial:black_cash_register',
  sortKey = 13800,
  categoryId = 'storage:shelves-counters',
  nameKey = 'ContextMenu_MoreBuild_Name_commercial_black_cash_register',
  descriptionKey = 'Tooltip_MoreBuild_CashRegister',
  recipeId = 'MoreBuilds.CashRegister',
  previewSprite = 'location_shop_accessories_01_20',
  placement = {
    kind = 'morebuilds:table-decoration',
    data = {
      canBeLockedByPadlock = false,
      containerCapacity = 5,
      containerType = 'cashregister',
      eastSprite = 'location_shop_accessories_01_23',
      health = 100,
      northSprite = 'location_shop_accessories_01_21',
      southSprite = 'location_shop_accessories_01_22',
      sprite = 'location_shop_accessories_01_20',
    },
  },
  salvagePolicy = 'recipe-inputs',
}

definitions[#definitions + 1] = {
  id = 'morebuilds:commercial:oak_employee_bank_counter',
  sortKey = 13810,
  categoryId = 'storage:shelves-counters',
  nameKey = 'ContextMenu_MoreBuild_Name_commercial_oak_employee_bank_counter',
  descriptionKey = 'Tooltip_MoreBuild_BankCounter',
  recipeId = 'MoreBuilds.BankCounterWood',
  previewSprite = 'location_business_bank_01_25',
  placement = {
    kind = 'morebuilds:multi-furniture',
    data = {
      eastSprite = 'location_business_bank_01_29',
      health = 300,
      healthFromCarpentry = true,
      northSprite = 'location_business_bank_01_26',
      southSprite = 'location_business_bank_01_30',
      sprite = 'location_business_bank_01_25',
    },
  },
  salvagePolicy = 'recipe-inputs',
}

definitions[#definitions + 1] = {
  id = 'morebuilds:commercial:employee_bank_counter',
  sortKey = 13820,
  categoryId = 'storage:shelves-counters',
  nameKey = 'ContextMenu_MoreBuild_Name_commercial_employee_bank_counter',
  descriptionKey = 'Tooltip_MoreBuild_BankCounter',
  recipeId = 'MoreBuilds.BankCounterWood',
  previewSprite = 'location_business_bank_01_33',
  placement = {
    kind = 'morebuilds:multi-furniture',
    data = {
      eastSprite = 'location_business_bank_01_37',
      health = 300,
      healthFromCarpentry = true,
      northSprite = 'location_business_bank_01_34',
      southSprite = 'location_business_bank_01_38',
      sprite = 'location_business_bank_01_33',
    },
  },
  salvagePolicy = 'recipe-inputs',
}

definitions[#definitions + 1] = {
  id = 'morebuilds:commercial:oak_bank_counter',
  sortKey = 13830,
  categoryId = 'storage:shelves-counters',
  nameKey = 'ContextMenu_MoreBuild_Name_commercial_oak_bank_counter',
  descriptionKey = 'Tooltip_MoreBuild_BankCounter',
  recipeId = 'MoreBuilds.BankCounterWood',
  previewSprite = 'location_business_bank_01_49',
  placement = {
    kind = 'morebuilds:multi-furniture',
    data = {
      eastSprite = 'location_business_bank_01_53',
      health = 300,
      healthFromCarpentry = true,
      northSprite = 'location_business_bank_01_50',
      southSprite = 'location_business_bank_01_54',
      sprite = 'location_business_bank_01_49',
    },
  },
  salvagePolicy = 'recipe-inputs',
}

definitions[#definitions + 1] = {
  id = 'morebuilds:commercial:bank_counter_white_black_top',
  sortKey = 13840,
  categoryId = 'storage:shelves-counters',
  nameKey = 'ContextMenu_MoreBuild_Name_commercial_bank_counter_white_black_top',
  descriptionKey = 'Tooltip_MoreBuild_BankCounter',
  recipeId = 'MoreBuilds.BankCounterWood',
  previewSprite = 'location_business_bank_01_57',
  placement = {
    kind = 'morebuilds:multi-furniture',
    data = {
      eastSprite = 'location_business_bank_01_61',
      health = 300,
      healthFromCarpentry = true,
      northSprite = 'location_business_bank_01_58',
      southSprite = 'location_business_bank_01_62',
      sprite = 'location_business_bank_01_57',
    },
  },
  salvagePolicy = 'recipe-inputs',
}

for _, definition in ipairs(definitions) do
  definition.sortKey = definition.sortKey + 50000
end

return definitions
