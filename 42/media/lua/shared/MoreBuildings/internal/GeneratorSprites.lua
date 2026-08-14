local canonicalByDirection = {
  ['appliances_misc_01_1'] = 'appliances_misc_01_0',
  ['appliances_misc_01_2'] = 'appliances_misc_01_0',
  ['appliances_misc_01_3'] = 'appliances_misc_01_0',
  ['appliances_misc_01_5'] = 'appliances_misc_01_4',
  ['appliances_misc_01_6'] = 'appliances_misc_01_4',
  ['appliances_misc_01_7'] = 'appliances_misc_01_4',
  ['appliances_misc_01_9'] = 'appliances_misc_01_8',
  ['appliances_misc_01_10'] = 'appliances_misc_01_8',
  ['appliances_misc_01_11'] = 'appliances_misc_01_8',
  ['appliances_misc_01_13'] = 'appliances_misc_01_12',
  ['appliances_misc_01_14'] = 'appliances_misc_01_12',
  ['appliances_misc_01_15'] = 'appliances_misc_01_12',
}

local GeneratorSprites = {}

function GeneratorSprites.canonical(spriteName)
  return canonicalByDirection[spriteName]
end

return GeneratorSprites
