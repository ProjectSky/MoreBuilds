local GeneratorSprites = require('MoreBuildings/internal/GeneratorSprites')

require 'TimedActions/ISTakeGenerator'

local vanillaComplete = ISTakeGenerator.complete

function ISTakeGenerator:complete()
  local sprite = self.generator:getSprite()
  local canonicalSprite = sprite and GeneratorSprites.canonical(sprite:getName())
  if canonicalSprite then
    self.generator:setSprite(getSprite(canonicalSprite))
  end
  return vanillaComplete(self)
end
