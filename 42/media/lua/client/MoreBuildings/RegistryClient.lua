local MoreBuilds = require('MoreBuildings/API')
local Bootstrap = require('MoreBuildings/Bootstrap')
local RegistrationCoordinator = require('MoreBuildings/internal/RegistrationCoordinator')

local RegistryClient = {}

local MODULE = 'MoreBuilds'
local states = {}
local handshakeTickRegistered = false
local requestRegistryHandshake

local function indexFor(player)
  return player and player:getIndex() or 0
end

local function sendDigest(player)
  Bootstrap.ensureSealed()
  sendClientCommand(player, MODULE, 'registryDigest', {
    apiVersion = MoreBuilds.API_VERSION,
    digest = MoreBuilds.getRegistryDigest(),
  })
end

local function sendManifest(player)
  Bootstrap.ensureSealed()
  sendClientCommand(player, MODULE, 'registryManifest', RegistrationCoordinator.getInternalManifest())
end

function RegistryClient.request(player)
  local playerIndex = indexFor(player)
  if not isMultiplayer() then
    states[playerIndex] = 'accepted'
    return
  end
  if player == nil or player:getOnlineID() == -1 or states[playerIndex] == 'accepted' or states[playerIndex] == 'rejected' then
    return
  end

  if states[playerIndex] == 'pending' then
    return
  end
  states[playerIndex] = 'pending'
  sendDigest(player)
end

function RegistryClient.isCompatible(playerIndex)
  return not isMultiplayer() or states[playerIndex or 0] == 'accepted'
end

local function onServerCommand(module, command, args)
  if module ~= MODULE then
    return
  end
  if command == 'registryManifestRequested' then
    sendManifest(getSpecificPlayer(args.playerIndex))
    return
  end
  if command == 'registryResult' then
    states[args.playerIndex] = args.accepted and 'accepted' or 'rejected'
    if not args.accepted then
      print('MoreBuilds registry mismatch with server: ' .. tostring(args.serverDigest))
    end
  end
end

requestRegistryHandshake = function()
  local player = getSpecificPlayer(0)
  if player == nil or player:getOnlineID() == -1 then
    return
  end
  Events.OnTick.Remove(requestRegistryHandshake)
  handshakeTickRegistered = false
  RegistryClient.request(player)
end

local function armRegistryHandshake()
  if not isMultiplayer() or handshakeTickRegistered then
    return
  end
  handshakeTickRegistered = true
  Events.OnTick.Add(requestRegistryHandshake)
end

local function disarmRegistryHandshake()
  if not handshakeTickRegistered then
    return
  end
  Events.OnTick.Remove(requestRegistryHandshake)
  handshakeTickRegistered = false
end

Events.OnServerCommand.Add(onServerCommand)
Events.OnConnected.Add(function()
  states = {}
  armRegistryHandshake()
end)
Events.OnDisconnect.Add(function()
  states = {}
  disarmRegistryHandshake()
end)

return RegistryClient
