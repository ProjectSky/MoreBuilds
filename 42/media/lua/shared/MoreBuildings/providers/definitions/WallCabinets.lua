local definitions = {}

local function add(id, sortKey, nameKey, recipeId, descriptionKey, containerType, health, sprites)
  definitions[#definitions + 1] = {
    id = id,
    sortKey = sortKey + 130000,
    categoryId = 'storage:cabinets-wardrobes',
    nameKey = nameKey,
    descriptionKey = descriptionKey,
    recipeId = recipeId,
    previewSprite = sprites.sprite,
    placement = {
      kind = 'morebuilds:container',
      data = {
        blockAllTheSquare = false,
        canBeLockedByPadlock = false,
        containerType = containerType,
        eastSprite = sprites.eastSprite,
        health = health,
        healthFromCarpentry = recipeId == 'MoreBuilds.WallCabinetWood',
        needToBeAgainstWall = true,
        northSprite = sprites.northSprite,
        southSprite = sprites.southSprite,
        sprite = sprites.sprite,
      },
    },
    salvagePolicy = 'recipe-inputs',
  }
end

local function regular(east, south, west, north)
  return { sprite = east, northSprite = south, eastSprite = west, southSprite = north }
end

local function corner(north, east, south, west)
  return { sprite = east, northSprite = south, eastSprite = west, southSprite = north }
end

local WOOD = 'MoreBuilds.WallCabinetWood'
local WOOD_TOOLTIP = 'Tooltip_MoreBuild_WallCabinetWood'
local METAL = 'MoreBuilds.WallCabinetMetal'
local METAL_TOOLTIP = 'Tooltip_MoreBuild_WallCabinetMetal'

add('morebuilds:wall_cabinet:birchwood', 13640, 'ContextMenu_MoreBuild_Name_wall_cabinet_birchwood', WOOD, WOOD_TOOLTIP, 'counter', 150,
  regular('fixtures_counters_01_27', 'fixtures_counters_01_26', 'fixtures_counters_01_24', 'fixtures_counters_01_25'))
add('morebuilds:wall_cabinet:birchwood_corner', 13650, 'ContextMenu_MoreBuild_Name_wall_cabinet_birchwood_corner', WOOD, WOOD_TOOLTIP, 'overhead', 150,
  corner('fixtures_counters_01_168', 'fixtures_counters_01_169', 'fixtures_counters_01_170', 'fixtures_counters_01_171'))
add('morebuilds:wall_cabinet:dark', 13660, 'ContextMenu_MoreBuild_Name_wall_cabinet_dark', WOOD, WOOD_TOOLTIP, 'counter', 150,
  regular('fixtures_counters_01_151', 'fixtures_counters_01_150', 'fixtures_counters_01_148', 'fixtures_counters_01_149'))
add('morebuilds:wall_cabinet:dark_corner', 13670, 'ContextMenu_MoreBuild_Name_wall_cabinet_dark_corner', WOOD, WOOD_TOOLTIP, 'overhead', 150,
  corner('fixtures_counters_01_180', 'fixtures_counters_01_181', 'fixtures_counters_01_182', 'fixtures_counters_01_183'))
add('morebuilds:wall_cabinet:dark_oak', 13680, 'ContextMenu_MoreBuild_Name_wall_cabinet_dark_oak', WOOD, WOOD_TOOLTIP, 'counter', 150,
  regular('fixtures_counters_01_203', 'fixtures_counters_01_202', 'fixtures_counters_01_200', 'fixtures_counters_01_201'))
add('morebuilds:wall_cabinet:dark_oak_corner', 13690, 'ContextMenu_MoreBuild_Name_wall_cabinet_dark_oak_corner', WOOD, WOOD_TOOLTIP, 'overhead', 150,
  corner('fixtures_counters_01_204', 'fixtures_counters_01_205', 'fixtures_counters_01_206', 'fixtures_counters_01_207'))
add('morebuilds:wall_cabinet:green', 13700, 'ContextMenu_MoreBuild_Name_wall_cabinet_green', WOOD, WOOD_TOOLTIP, 'counter', 150,
  regular('fixtures_counters_01_155', 'fixtures_counters_01_154', 'fixtures_counters_01_152', 'fixtures_counters_01_153'))
add('morebuilds:wall_cabinet:green_corner', 13710, 'ContextMenu_MoreBuild_Name_wall_cabinet_green_corner', WOOD, WOOD_TOOLTIP, 'overhead', 150,
  corner('fixtures_counters_01_184', 'fixtures_counters_01_185', 'fixtures_counters_01_186', 'fixtures_counters_01_187'))
add('morebuilds:wall_cabinet:oak', 13720, 'ContextMenu_MoreBuild_Name_wall_cabinet_oak', WOOD, WOOD_TOOLTIP, 'counter', 150,
  regular('fixtures_counters_01_147', 'fixtures_counters_01_146', 'fixtures_counters_01_144', 'fixtures_counters_01_145'))
add('morebuilds:wall_cabinet:oak_corner', 13730, 'ContextMenu_MoreBuild_Name_wall_cabinet_oak_corner', WOOD, WOOD_TOOLTIP, 'overhead', 150,
  corner('fixtures_counters_01_176', 'fixtures_counters_01_177', 'fixtures_counters_01_178', 'fixtures_counters_01_179'))
add('morebuilds:wall_cabinet:oakwood', 13740, 'ContextMenu_MoreBuild_Name_wall_cabinet_oakwood', WOOD, WOOD_TOOLTIP, 'counter', 150,
  regular('fixtures_counters_01_19', 'fixtures_counters_01_18', 'fixtures_counters_01_16', 'fixtures_counters_01_17'))
add('morebuilds:wall_cabinet:oakwood_corner', 13750, 'ContextMenu_MoreBuild_Name_wall_cabinet_oakwood_corner', WOOD, WOOD_TOOLTIP, 'overhead', 150,
  corner('fixtures_counters_01_160', 'fixtures_counters_01_161', 'fixtures_counters_01_162', 'fixtures_counters_01_163'))
add('morebuilds:wall_cabinet:steel_corner', 13760, 'ContextMenu_MoreBuild_Name_wall_cabinet_steel_corner', METAL, METAL_TOOLTIP, 'overhead', 220,
  corner('fixtures_counters_01_172', 'fixtures_counters_01_173', 'fixtures_counters_01_174', 'fixtures_counters_01_175'))
add('morebuilds:wall_cabinet:white', 13770, 'ContextMenu_MoreBuild_Name_wall_cabinet_white', WOOD, WOOD_TOOLTIP, 'counter', 150,
  regular('fixtures_counters_01_159', 'fixtures_counters_01_158', 'fixtures_counters_01_156', 'fixtures_counters_01_157'))
add('morebuilds:wall_cabinet:white_corner', 13780, 'ContextMenu_MoreBuild_Name_wall_cabinet_white_corner', WOOD, WOOD_TOOLTIP, 'overhead', 150,
  corner('fixtures_counters_01_188', 'fixtures_counters_01_189', 'fixtures_counters_01_190', 'fixtures_counters_01_191'))

return definitions
