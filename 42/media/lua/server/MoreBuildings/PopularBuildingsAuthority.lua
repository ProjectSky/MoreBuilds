if isClient() then
  return {}
end

local Config = require('MoreBuildings/internal/PopularBuildingsConfig')
local RegistrationCoordinator = require('MoreBuildings/internal/RegistrationCoordinator')
local TableUtil = require('MoreBuildings/internal/TableUtil')

local PopularBuildingsAuthority = {
  installed = false,
}

local viewDirty = false
local nextPublishAt = 0

local function isEnabled()
  return SandboxVars.MoreBuilds.EnablePopularBuildings and isMultiplayer()
end

local function currentWorldHour()
  return math.floor(getGameTime():getWorldAgeHours())
end

local function getScoreData()
  local data = ModData.getOrCreate(Config.scoreDataTag)
  data.scores = data.scores or {}
  return data
end

local function applyScoreDecay(data, currentHour)
  local halfLifeDays = SandboxVars.MoreBuilds.PopularityHalfLifeDays
  local lastDecayHour = data.lastDecayHour
  if lastDecayHour == nil or lastDecayHour > currentHour or halfLifeDays == 0 then
    data.lastDecayHour = currentHour
    return false
  end

  local halfLifeHours = halfLifeDays * 24
  local elapsedHalfLives = math.floor((currentHour - lastDecayHour) / halfLifeHours)
  if elapsedHalfLives < 1 then
    return false
  end

  local decayFactor = 0.5 ^ elapsedHalfLives
  for definitionId, score in pairs(data.scores) do
    local decayedScore = score * decayFactor
    if decayedScore < 0.01 then
      data.scores[definitionId] = nil
    else
      data.scores[definitionId] = decayedScore
    end
  end
  data.lastDecayHour = lastDecayHour + elapsedHalfLives * halfLifeHours
  return true
end

local function schedulePublish()
  if not viewDirty then
    nextPublishAt = getTimestampMs() + Config.publishDelayMs
  end
  viewDirty = true
end

local function rebuildView()
  local scoreData = getScoreData()
  applyScoreDecay(scoreData, currentWorldHour())
  local candidates = {}
  local staleDefinitionIds = {}
  local minimumScore = SandboxVars.MoreBuilds.PopularBuildingsMinimumScore
  for definitionId, score in pairs(scoreData.scores) do
    if not RegistrationCoordinator.isDefinitionEnabled(definitionId) then
      staleDefinitionIds[#staleDefinitionIds + 1] = definitionId
    elseif score >= minimumScore then
      candidates[#candidates + 1] = { definitionId = definitionId, score = score }
    end
  end
  for _, definitionId in ipairs(staleDefinitionIds) do
    scoreData.scores[definitionId] = nil
  end
  TableUtil.stableMergeSort(candidates, function(first, second)
    if first.score ~= second.score then
      return first.score > second.score
    end
    return first.definitionId < second.definitionId
  end)

  local view = ModData.getOrCreate(Config.viewDataTag)
  local scores = {}
  local maximumVisible = SandboxVars.MoreBuilds.PopularBuildingsMaximumVisible
  for index = 1, math.min(#candidates, maximumVisible) do
    local candidate = candidates[index]
    scores[candidate.definitionId] = candidate.score
  end
  view.scores = scores
end

local function publishView()
  rebuildView()
  ModData.transmit(Config.viewDataTag)
  viewDirty = false
end

function PopularBuildingsAuthority.record(definitionId)
  if not isEnabled() then
    return
  end
  local data = getScoreData()
  local decayed = applyScoreDecay(data, currentWorldHour())
  data.scores[definitionId] = (data.scores[definitionId] or 0) + 1
  if decayed or data.scores[definitionId] >= SandboxVars.MoreBuilds.PopularBuildingsMinimumScore then
    schedulePublish()
  end
end

local function decayScores()
  if isEnabled() and applyScoreDecay(getScoreData(), currentWorldHour()) then
    schedulePublish()
  end
end

local function flushView()
  if viewDirty and getTimestampMs() >= nextPublishAt then
    publishView()
  end
end

function PopularBuildingsAuthority.install()
  if PopularBuildingsAuthority.installed then
    return
  end
  Events.OnInitGlobalModData.Add(function()
    if isEnabled() then
      rebuildView()
    end
  end)
  Events.EveryHours.Add(decayScores)
  Events.OnTick.Add(flushView)
  PopularBuildingsAuthority.installed = true
end

return PopularBuildingsAuthority
