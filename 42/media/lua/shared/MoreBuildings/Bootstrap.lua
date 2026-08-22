local MoreBuilds = require('MoreBuildings/API')
local RegistrationCoordinator = require('MoreBuildings/internal/RegistrationCoordinator')

local Bootstrap = {}

function Bootstrap.initialize()
  return MoreBuilds.getStatus()
end

function Bootstrap.ensureSealed()
  Bootstrap.initialize()
  return RegistrationCoordinator.seal()
end

function Bootstrap.validateRuntime()
  Bootstrap.ensureSealed()
  return RegistrationCoordinator.validateRuntime()
end

Bootstrap.initialize()
Events.OnLoadedTileDefinitions.Add(Bootstrap.ensureSealed)
Events.OnGameStart.Add(Bootstrap.validateRuntime)

return Bootstrap
