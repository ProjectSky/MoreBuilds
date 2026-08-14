local function mannequin(id, sortKey, nameKey, sprites, scripts)
  return {
    id = id,
    sortKey = sortKey + 80000,
    categoryId = 'furniture:bedroom-leisure',
    nameKey = nameKey,
    descriptionKey = 'Tooltip_MoreBuild_Mannequin',
    recipeId = 'MoreBuilds.MannequinPlastic',
    previewSprite = sprites[1],
    placement = {
      kind = 'morebuilds:mannequin',
      data = {
        sprite = sprites[1],
        northSprite = sprites[2],
        eastSprite = sprites[3],
        mannequinScript = scripts[1],
        northMannequinScript = scripts[2],
        eastMannequinScript = scripts[3],
      },
    },
    salvagePolicy = 'recipe-inputs',
  }
end

return {
  mannequin(
    'morebuilds:mannequin:female_white',
    7700,
    'ContextMenu_MoreBuild_Name_mannequin_female_white',
    { 'location_shop_mall_01_65', 'location_shop_mall_01_66', 'location_shop_mall_01_67' },
    { 'MoreBuilds.MoreBuildsFemaleWhite01', 'MoreBuilds.MoreBuildsFemaleWhite02', 'MoreBuilds.MoreBuildsFemaleWhite03' }
  ),
  mannequin(
    'morebuilds:mannequin:male_white',
    7730,
    'ContextMenu_MoreBuild_Name_mannequin_male_white',
    { 'location_shop_mall_01_68', 'location_shop_mall_01_69', 'location_shop_mall_01_70' },
    { 'MoreBuilds.MoreBuildsMaleWhite01', 'MoreBuilds.MoreBuildsMaleWhite02', 'MoreBuilds.MoreBuildsMaleWhite03' }
  ),
  mannequin(
    'morebuilds:mannequin:female_black',
    7760,
    'ContextMenu_MoreBuild_Name_mannequin_female_black',
    { 'location_shop_mall_01_73', 'location_shop_mall_01_74', 'location_shop_mall_01_75' },
    { 'MoreBuilds.MoreBuildsFemaleBlack01', 'MoreBuilds.MoreBuildsFemaleBlack02', 'MoreBuilds.MoreBuildsFemaleBlack03' }
  ),
  mannequin(
    'morebuilds:mannequin:male_black',
    7790,
    'ContextMenu_MoreBuild_Name_mannequin_male_black',
    { 'location_shop_mall_01_76', 'location_shop_mall_01_77', 'location_shop_mall_01_78' },
    { 'MoreBuilds.MoreBuildsMaleBlack01', 'MoreBuilds.MoreBuildsMaleBlack02', 'MoreBuilds.MoreBuildsMaleBlack03' }
  ),
}
