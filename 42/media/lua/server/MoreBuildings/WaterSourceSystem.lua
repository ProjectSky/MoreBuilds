local WaterSourceSystem = {
  installed = false,
}

if isClient() then
  return WaterSourceSystem
end

local waterSources = {}

local function waterSourceKey(object)
  return object:getX() .. ':' .. object:getY() .. ':' .. object:getZ()
end

local function isWaterSource(object)
  return object:getModData().MoreBuildsWaterSource == true
end

function WaterSourceSystem.register(object)
  if isWaterSource(object) then
    waterSources[waterSourceKey(object)] = {
      x = object:getX(),
      y = object:getY(),
      z = object:getZ(),
    }
  end
end

local function findWaterSource(square)
  for index = 0, square:getSpecialObjects():size() - 1 do
    local object = square:getSpecialObjects():get(index)
    if isWaterSource(object) then
      return object
    end
  end
end

local function refillWaterSource(object, currentHour)
  local modData = object:getModData()
  local lastHour = modData.MoreBuildsWaterSourceLastRefillHour
  if lastHour == nil or lastHour > currentHour then
    modData.MoreBuildsWaterSourceLastRefillHour = currentHour
    return
  end

  local elapsedHours = currentHour - lastHour
  if elapsedHours < 1 then
    return
  end
  modData.MoreBuildsWaterSourceLastRefillHour = currentHour

  local refillMultiplier = SandboxVars.MoreBuilds.AutomaticWaterRefillMultiplier
  if refillMultiplier == 0 then
    return
  end

  local fluidContainer = object:getFluidContainer()
  local missingWater = fluidContainer:getFreeCapacity()
  if missingWater <= 0 then
    return
  end

  local refillAmount = 0
  for _ = 1, elapsedHours do
    refillAmount = refillAmount
      + ZombRand(
        modData.MoreBuildsWaterSourceRefillMin,
        modData.MoreBuildsWaterSourceRefillMax
      ) * refillMultiplier
    if refillAmount >= missingWater then
      break
    end
  end
  fluidContainer:addFluid(FluidType.Water, math.min(refillAmount, missingWater))
  object:sync()
end

local function refillWaterSources()
  local currentHour = math.floor(getGameTime():getWorldAgeHours())
  for key, location in pairs(waterSources) do
    local square = getCell():getGridSquare(location.x, location.y, location.z)
    if square then
      local waterSource = findWaterSource(square)
      if waterSource then
        refillWaterSource(waterSource, currentHour)
      else
        waterSources[key] = nil
      end
    end
  end
end

local function registerWaterSourcesInSquare(square)
  local currentHour = math.floor(getGameTime():getWorldAgeHours())
  for index = 0, square:getSpecialObjects():size() - 1 do
    local object = square:getSpecialObjects():get(index)
    WaterSourceSystem.register(object)
    if isWaterSource(object) then
      refillWaterSource(object, currentHour)
    end
  end
end

local function unregisterWaterSource(object)
  if isWaterSource(object) then
    waterSources[waterSourceKey(object)] = nil
  end
end

function WaterSourceSystem.install()
  if WaterSourceSystem.installed then
    return
  end
  Events.OnObjectAdded.Add(WaterSourceSystem.register)
  Events.LoadGridsquare.Add(registerWaterSourcesInSquare)
  Events.OnObjectAboutToBeRemoved.Add(unregisterWaterSource)
  Events.EveryHours.Add(refillWaterSources)
  WaterSourceSystem.installed = true
end

return WaterSourceSystem
