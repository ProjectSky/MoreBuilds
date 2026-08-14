local definitions = {}

local function rotation(east, west, south, north)
  return {
    eastSprite = west,
    northSprite = south,
    southSprite = north,
    sprite = east,
  }
end

local function addCurtain(id, sortKey, nameKey, sprites, allowDoor)
  if allowDoor then
    sprites.allowDoor = true
  end
  definitions[#definitions + 1] = {
    id = id,
    sortKey = sortKey + 140000,
    categoryId = 'decorations:wall-decor',
    nameKey = nameKey,
    descriptionKey = 'Tooltip_MoreBuild_Curtain',
    recipeId = 'MoreBuilds.Curtain',
    previewSprite = sprites.sprite,
    placement = {
      kind = 'morebuilds:curtain',
      data = sprites,
    },
    salvagePolicy = 'recipe-inputs',
  }
end

local function addRug(id, sortKey, nameKey, sprite)
  definitions[#definitions + 1] = {
    id = id,
    sortKey = sortKey + 140000,
    categoryId = 'decorations:objects',
    nameKey = nameKey,
    descriptionKey = 'Tooltip_MoreBuild_Rug',
    recipeId = 'MoreBuilds.Rug',
    previewSprite = sprite,
    placement = {
      kind = 'morebuilds:rug',
      data = { sprite = sprite },
    },
    salvagePolicy = 'recipe-inputs',
  }
end

addCurtain('morebuilds:curtain:long_beige', 5450, 'ContextMenu_MoreBuild_Name_curtain_long_beige',
  rotation('fixtures_windows_curtains_01_4', 'fixtures_windows_curtains_01_5', 'fixtures_windows_curtains_01_6', 'fixtures_windows_curtains_01_7'), true)
addCurtain('morebuilds:curtain:long_white', 5460, 'ContextMenu_MoreBuild_Name_curtain_long_white',
  rotation('fixtures_windows_curtains_01_12', 'fixtures_windows_curtains_01_13', 'fixtures_windows_curtains_01_14', 'fixtures_windows_curtains_01_15'), true)
addCurtain('morebuilds:curtain:blue', 5470, 'ContextMenu_MoreBuild_Name_curtain_blue',
  rotation('fixtures_windows_curtains_01_28', 'fixtures_windows_curtains_01_29', 'fixtures_windows_curtains_01_30', 'fixtures_windows_curtains_01_31'))
addCurtain('morebuilds:curtain:pink', 5480, 'ContextMenu_MoreBuild_Name_curtain_pink',
  rotation('fixtures_windows_curtains_01_36', 'fixtures_windows_curtains_01_37', 'fixtures_windows_curtains_01_38', 'fixtures_windows_curtains_01_39'))
addCurtain('morebuilds:curtain:brown', 5490, 'ContextMenu_MoreBuild_Name_curtain_brown',
  rotation('fixtures_windows_curtains_01_44', 'fixtures_windows_curtains_01_45', 'fixtures_windows_curtains_01_46', 'fixtures_windows_curtains_01_47'))
addCurtain('morebuilds:curtain:white', 5500, 'ContextMenu_MoreBuild_Name_curtain_white',
  rotation('fixtures_windows_curtains_01_52', 'fixtures_windows_curtains_01_53', 'fixtures_windows_curtains_01_54', 'fixtures_windows_curtains_01_55'))
addCurtain('morebuilds:curtain:beige', 5510, 'ContextMenu_MoreBuild_Name_curtain_beige',
  rotation('fixtures_windows_curtains_01_60', 'fixtures_windows_curtains_01_61', 'fixtures_windows_curtains_01_62', 'fixtures_windows_curtains_01_63'))
addCurtain('morebuilds:curtain:green', 5520, 'ContextMenu_MoreBuild_Name_curtain_green',
  rotation('fixtures_windows_curtains_01_68', 'fixtures_windows_curtains_01_69', 'fixtures_windows_curtains_01_70', 'fixtures_windows_curtains_01_71'))
addCurtain('morebuilds:curtain:black', 5530, 'ContextMenu_MoreBuild_Name_curtain_black',
  rotation('fixtures_windows_curtains_01_76', 'fixtures_windows_curtains_01_77', 'fixtures_windows_curtains_01_78', 'fixtures_windows_curtains_01_79'))
addCurtain('morebuilds:curtain:grey', 5540, 'ContextMenu_MoreBuild_Name_curtain_grey',
  rotation('fixtures_windows_curtains_01_84', 'fixtures_windows_curtains_01_85', 'fixtures_windows_curtains_01_86', 'fixtures_windows_curtains_01_87'))
addCurtain('morebuilds:curtain:grey_long', 5550, 'ContextMenu_MoreBuild_Name_curtain_grey_long',
  rotation('fixtures_windows_curtains_01_92', 'fixtures_windows_curtains_01_93', 'fixtures_windows_curtains_01_94', 'fixtures_windows_curtains_01_95'), true)
addCurtain('morebuilds:curtain:small_white', 5560, 'ContextMenu_MoreBuild_Name_curtain_small_white',
  rotation('fixtures_windows_curtains_02_4', 'fixtures_windows_curtains_02_5', 'fixtures_windows_curtains_02_6', 'fixtures_windows_curtains_02_7'))
addCurtain('morebuilds:curtain:small_green', 5570, 'ContextMenu_MoreBuild_Name_curtain_small_green',
  rotation('fixtures_windows_curtains_02_12', 'fixtures_windows_curtains_02_13', 'fixtures_windows_curtains_02_14', 'fixtures_windows_curtains_02_15'))
addCurtain('morebuilds:curtain:small_bordeaux', 5580, 'ContextMenu_MoreBuild_Name_curtain_small_bordeaux',
  rotation('fixtures_windows_curtains_02_20', 'fixtures_windows_curtains_02_21', 'fixtures_windows_curtains_02_22', 'fixtures_windows_curtains_02_23'))
addCurtain('morebuilds:curtain:small_pearl', 5590, 'ContextMenu_MoreBuild_Name_curtain_small_pearl',
  rotation('fixtures_windows_curtains_02_28', 'fixtures_windows_curtains_02_29', 'fixtures_windows_curtains_02_30', 'fixtures_windows_curtains_02_31'))

addRug('morebuilds:rug:fabric_pattern_1', 5600, 'ContextMenu_MoreBuild_Name_rug_fabric_pattern_1', 'floors_rugs_01_60')
addRug('morebuilds:rug:fabric_pattern_2', 5610, 'ContextMenu_MoreBuild_Name_rug_fabric_pattern_2', 'floors_rugs_01_61')
addRug('morebuilds:rug:fabric_pattern_3', 5620, 'ContextMenu_MoreBuild_Name_rug_fabric_pattern_3', 'floors_rugs_01_62')
addRug('morebuilds:rug:white_shag', 5630, 'ContextMenu_MoreBuild_Name_rug_white_shag', 'floors_rugs_02_0')
addRug('morebuilds:rug:black_shag', 5640, 'ContextMenu_MoreBuild_Name_rug_black_shag', 'floors_rugs_02_1')
addRug('morebuilds:rug:beige_shag', 5650, 'ContextMenu_MoreBuild_Name_rug_beige_shag', 'floors_rugs_02_2')
addRug('morebuilds:rug:white_brown_shag', 5660, 'ContextMenu_MoreBuild_Name_rug_white_brown_shag', 'floors_rugs_02_3')
addRug('morebuilds:rug:pink_shag', 5670, 'ContextMenu_MoreBuild_Name_rug_pink_shag', 'floors_rugs_02_4')
addRug('morebuilds:rug:blue_shag', 5680, 'ContextMenu_MoreBuild_Name_rug_blue_shag', 'floors_rugs_02_5')
addRug('morebuilds:rug:grey_shag', 5690, 'ContextMenu_MoreBuild_Name_rug_grey_shag', 'floors_rugs_02_6')
addRug('morebuilds:rug:rainbow_shag', 5700, 'ContextMenu_MoreBuild_Name_rug_rainbow_shag', 'floors_rugs_02_7')

return definitions
