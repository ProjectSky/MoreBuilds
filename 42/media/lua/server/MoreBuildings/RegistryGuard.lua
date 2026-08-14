if isClient() then
  return {}
end

local RegistryGuard = {
  compatiblePlayers = {},
}

function RegistryGuard.isCompatible(player)
  return not isMultiplayer() or RegistryGuard.compatiblePlayers[player] == true
end

function RegistryGuard.setCompatible(player, compatible)
  RegistryGuard.compatiblePlayers[player] = compatible == true
end

function RegistryGuard.prune(onlinePlayers)
  local activePlayers = {}
  for index = 0, onlinePlayers:size() - 1 do
    activePlayers[onlinePlayers:get(index)] = true
  end
  for player in pairs(RegistryGuard.compatiblePlayers) do
    if not activePlayers[player] then
      RegistryGuard.compatiblePlayers[player] = nil
    end
  end
  return activePlayers
end

return RegistryGuard
