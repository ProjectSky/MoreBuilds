require 'Moveables/ISMoveableSpriteProps'

if not isClient() then
  return {}
end

local DEFINITION_KEY = 'MoreBuildsDefinitionId'

local function isManagedObject(props)
  return props.object and props.object:getModData()[DEFINITION_KEY] ~= nil
end

local function installScrapHook(prototype)
  local originalScrapViaCursor = prototype.scrapObjectViaCursor
  prototype.scrapObjectViaCursor = function(self, player, square, originalSpriteName, moveCursor)
    if isManagedObject(self) then
      local object = self.object
      local objectSquare = object:getSquare()
      sendClientCommand(player, 'MoreBuilds', 'dismantle', {
        x = objectSquare:getX(),
        y = objectSquare:getY(),
        z = objectSquare:getZ(),
        index = object:getObjectIndex(),
      })
      if moveCursor then
        moveCursor:clearCache()
      end
      return true
    end
    return originalScrapViaCursor(self, player, square, originalSpriteName, moveCursor)
  end
end

installScrapHook(ISMoveableSpriteProps)
installScrapHook(ISThumpableSpriteProps)

local originalScrapHaloNoteCheck = ISMoveableSpriteProps.scrapHaloNoteCheck
ISMoveableSpriteProps.scrapHaloNoteCheck = function(self, player, itemCount)
  if itemCount == 0 and isManagedObject(self) then
    return
  end
  return originalScrapHaloNoteCheck(self, player, itemCount)
end

return {}
