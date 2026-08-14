local definitions = {}

definitions[#definitions + 1] = {
  id = 'morebuilds:light:rainbow_string_lights',
  sortKey = 6390,
  categoryId = 'utilities:lighting',
  nameKey = 'ContextMenu_MoreBuild_Name_light_rainbow_string_lights',
  descriptionKey = 'Tooltip_MoreBuild_RainbowStringLights',
  recipeId = 'MoreBuilds.RainbowStringLights',
  previewSprite = 'walls_decoration_01_79',
  placement = {
    kind = 'morebuilds:multi-light',
    data = {
      northSprite = 'walls_decoration_01_76',
      sprite = 'walls_decoration_01_79',
    },
  },
  salvagePolicy = 'recipe-inputs',
}

for _, definition in ipairs(definitions) do
  definition.sortKey = definition.sortKey + 60000
end

return definitions
