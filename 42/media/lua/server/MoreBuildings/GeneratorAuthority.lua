local GeneratorAuthority = {
  installed = false,
}

if isClient() then
  return GeneratorAuthority
end

local GeneratorSprites = require('MoreBuildings/internal/GeneratorSprites')

function GeneratorAuthority.install()
  if not isServer() or GeneratorAuthority.installed then
    return
  end
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
  GeneratorAuthority.installed = true
end

return GeneratorAuthority
