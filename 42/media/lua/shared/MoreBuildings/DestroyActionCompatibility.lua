require 'TimedActions/ISDestroyStuffAction'

if ISDestroyStuffAction.moreBuildsNullTargetGuardInstalled then
  return {}
end

local activeTargets = {}
local DEFINITION_KEY = 'MoreBuildsDefinitionId'

-- This compatibility guard only tracks MoreBuilds objects. Vanilla buildings
-- are left entirely on the original ISDestroyStuffAction path.
local originalNew = ISDestroyStuffAction.new
local originalStart = ISDestroyStuffAction.start
local originalPerform = ISDestroyStuffAction.perform
local originalStop = ISDestroyStuffAction.stop
local originalUpdate = ISDestroyStuffAction.update
local originalIsValid = ISDestroyStuffAction.isValid

local function unregisterTarget(action)
  if action.moreBuildsDestroyTarget then
    activeTargets[action.moreBuildsDestroyTarget] = nil
    action.moreBuildsDestroyTarget = nil
  end
end

function ISDestroyStuffAction:new(character, item, cornerCounter)
  local action = originalNew(self, character, item, cornerCounter)
  if item and item:getModData()[DEFINITION_KEY] ~= nil then
    action.moreBuildsDestroyTarget = item
  end
  return action
end

function ISDestroyStuffAction:start()
  if self.moreBuildsDestroyTarget then
    activeTargets[self.moreBuildsDestroyTarget] = self
  end
  originalStart(self)
end

function ISDestroyStuffAction:perform()
  unregisterTarget(self)
  originalPerform(self)
end

function ISDestroyStuffAction:stop()
  unregisterTarget(self)
  originalStop(self)
end

function ISDestroyStuffAction:update()
  if self.moreBuildsDestroyTargetRemoved then
    return
  end
  originalUpdate(self)
end

function ISDestroyStuffAction:isValid()
  if self.moreBuildsDestroyTargetRemoved then
    return false
  end
  return originalIsValid(self)
end

Events.OnObjectAboutToBeRemoved.Add(function(object)
  local action = activeTargets[object]
  if action then
    action.moreBuildsDestroyTargetRemoved = true
    unregisterTarget(action)
  end
end)

ISDestroyStuffAction.moreBuildsNullTargetGuardInstalled = true

return {}
