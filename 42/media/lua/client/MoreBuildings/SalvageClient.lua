require 'Moveables/ISMoveableSpriteProps'

local RegistrationCoordinator = require('MoreBuildings/internal/RegistrationCoordinator')

local DEFINITION_KEY = 'MoreBuildsDefinitionId'

local function isManagedObject(props)
  return props.object and props.object:getModData()[DEFINITION_KEY] ~= nil
end

-- Vanilla location sprites often have no Material/CanScrap properties.  Keep
-- those shared sprites untouched and provide the native scrap capability only
-- for MoreBuilds objects.
local originalFromObject = ISMoveableSpriteProps.fromObject
ISMoveableSpriteProps.fromObject = function(object)
  local props = originalFromObject(object)
  if props and object then
    local definitionId = object:getModData()[DEFINITION_KEY]
    if definitionId ~= nil then
      local definition = RegistrationCoordinator.getInternalDefinition(definitionId)
      if definition then
        props.name = getText(definition.nameKey)
      end
      if not props.canScrap then
        props.material = 'Wood'
        props.canScrap = true
        props.scrapThumpable = true
        local nativeCanScrapObject = props.canScrapObject
        props.canScrapObject = function(self, player)
          local result, chance, perkName = nativeCanScrapObject(self, player)
          result.craftValid = true
          return result, chance, perkName
        end
      end
    end
  end
  return props
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
