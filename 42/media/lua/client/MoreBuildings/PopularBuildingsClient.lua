local Config = require('MoreBuildings/internal/PopularBuildingsConfig')

local PopularBuildingsClient = {}

local data = false
local revision = 0

function PopularBuildingsClient.isAvailable()
  return SandboxVars.MoreBuilds.EnablePopularBuildings and isClient() and isMultiplayer()
end

function PopularBuildingsClient.getVisibleScores()
  return data and data.scores or nil
end

function PopularBuildingsClient.getRevision()
  return revision
end

function PopularBuildingsClient.request()
  if PopularBuildingsClient.isAvailable() then
    ModData.request(Config.viewDataTag)
  end
end

Events.OnReceiveGlobalModData.Add(function(tag, receivedData)
  if tag == Config.viewDataTag then
    data = receivedData
    revision = revision + 1
  end
end)
local function resetState()
  data = false
  revision = revision + 1
end
Events.OnGameStart.Add(resetState)
Events.OnDisconnect.Add(resetState)

return PopularBuildingsClient
