if isClient() then
  return {}
end

local RegistrationCoordinator = require('MoreBuildings/internal/RegistrationCoordinator')
local Bootstrap = require('MoreBuildings/Bootstrap')
local RegistryGuard = require('MoreBuildings/RegistryGuard')
local TableUtil = require('MoreBuildings/internal/TableUtil')

local RegistryAuthority = {
  installed = false,
}

local MODULE = 'MoreBuilds'
local awaitingManifest = {}
local manifestLimits
local MAX_MANIFEST_EXTRA_ENTRIES = 256
local MAX_MANIFEST_ID_LENGTH = 160
local DIAGNOSTIC_FIELDS = {
  'missingProviders',
  'extraProviders',
  'missingPlacementKinds',
  'extraPlacementKinds',
  'changedPlacementKinds',
  'missingGroups',
  'extraGroups',
  'changedGroups',
  'missingCategories',
  'extraCategories',
  'changedCategories',
  'missingDefinitions',
  'extraDefinitions',
  'changedDefinitions',
}

local MANIFEST_FIELDS = {
  apiVersion = true,
  categories = true,
  definitions = true,
  groups = true,
  placementKinds = true,
  providers = true,
  schema = true,
}

local function mapSize(entries)
  local count = 0
  for _ in pairs(entries) do
    count = count + 1
  end
  return count
end

local function getManifestLimits()
  if manifestLimits == nil then
    local manifest = RegistrationCoordinator.getInternalManifest()
    manifestLimits = {
      categories = mapSize(manifest.categories) + MAX_MANIFEST_EXTRA_ENTRIES,
      definitions = mapSize(manifest.definitions) + MAX_MANIFEST_EXTRA_ENTRIES,
      groups = mapSize(manifest.groups) + MAX_MANIFEST_EXTRA_ENTRIES,
      placementKinds = mapSize(manifest.placementKinds) + MAX_MANIFEST_EXTRA_ENTRIES,
      providers = #manifest.providers + MAX_MANIFEST_EXTRA_ENTRIES,
    }
  end
  return manifestLimits
end

local function isStringArray(entries, maximumCount)
  local count = #entries
  if count > maximumCount then
    return false
  end
  for key, value in pairs(entries) do
    if type(key) ~= 'number' or key ~= math.floor(key) or key < 1 or key > count
      or type(value) ~= 'string' or #value > MAX_MANIFEST_ID_LENGTH then
      return false
    end
  end
  return true
end

local function isDigestMap(entries, maximumCount)
  local count = 0
  for key, digest in pairs(entries) do
    count = count + 1
    if count > maximumCount
      or type(key) ~= 'string' or #key > MAX_MANIFEST_ID_LENGTH
      or type(digest) ~= 'string' or digest:match('^[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]$') == nil then
      return false
    end
  end
  return true
end

local function isManifest(value)
  if type(value) ~= 'table' or type(value.apiVersion) ~= 'number' or value.apiVersion ~= math.floor(value.apiVersion) then
    return false
  end
  for field in pairs(value) do
    if not MANIFEST_FIELDS[field] then
      return false
    end
  end
  if type(value.schema) ~= 'string' or value.schema ~= RegistrationCoordinator.REGISTRY_SCHEMA
    or type(value.providers) ~= 'table'
    or type(value.placementKinds) ~= 'table'
    or type(value.groups) ~= 'table'
    or type(value.categories) ~= 'table'
    or type(value.definitions) ~= 'table' then
    return false
  end
  local limits = getManifestLimits()
  return isStringArray(value.providers, limits.providers)
    and isDigestMap(value.placementKinds, limits.placementKinds)
    and isDigestMap(value.groups, limits.groups)
    and isDigestMap(value.categories, limits.categories)
    and isDigestMap(value.definitions, limits.definitions)
end

local function copyLimited(entries, limit)
  local copied = {}
  for index = 1, math.min(#entries, limit) do
    copied[index] = entries[index]
  end
  return copied, math.max(0, #entries - limit)
end

local function compareIdLists(serverEntries, clientEntries)
  local serverSet = {}
  local clientSet = {}
  local missing = {}
  local extra = {}
  for _, entry in ipairs(serverEntries) do
    serverSet[entry] = true
  end
  for _, entry in ipairs(clientEntries) do
    clientSet[entry] = true
  end
  for _, entry in ipairs(serverEntries) do
    if not clientSet[entry] then
      missing[#missing + 1] = entry
    end
  end
  for _, entry in ipairs(clientEntries) do
    if not serverSet[entry] then
      extra[#extra + 1] = entry
    end
  end
  TableUtil.stableMergeSort(missing, function(first, second)
    return first < second
  end)
  TableUtil.stableMergeSort(extra, function(first, second)
    return first < second
  end)
  return missing, extra
end

local function compareDigests(serverDefinitions, clientDefinitions)
  local missing = {}
  local extra = {}
  local changed = {}
  for definitionId, digest in pairs(serverDefinitions) do
    local clientDigest = clientDefinitions[definitionId]
    if clientDigest == nil then
      missing[#missing + 1] = definitionId
    elseif clientDigest ~= digest then
      changed[#changed + 1] = definitionId
    end
  end
  for definitionId in pairs(clientDefinitions) do
    if serverDefinitions[definitionId] == nil then
      extra[#extra + 1] = definitionId
    end
  end
  TableUtil.stableMergeSort(missing, function(first, second)
    return first < second
  end)
  TableUtil.stableMergeSort(extra, function(first, second)
    return first < second
  end)
  TableUtil.stableMergeSort(changed, function(first, second)
    return first < second
  end)
  return missing, extra, changed
end

local function makeDiagnostic(clientManifest)
  local serverManifest = RegistrationCoordinator.getInternalManifest()
  local missingProviders, extraProviders = compareIdLists(serverManifest.providers, clientManifest.providers)
  local missingKinds, extraKinds, changedKinds = compareDigests(serverManifest.placementKinds, clientManifest.placementKinds)
  local missingGroups, extraGroups, changedGroups = compareDigests(serverManifest.groups, clientManifest.groups)
  local missingCategories, extraCategories, changedCategories = compareDigests(serverManifest.categories, clientManifest.categories)
  local missingDefinitions, extraDefinitions, changedDefinitions = compareDigests(serverManifest.definitions, clientManifest.definitions)
  local diagnostic = {
    apiVersionMatches = clientManifest.apiVersion == serverManifest.apiVersion,
    schemaMatches = clientManifest.schema == serverManifest.schema,
    serverDigest = RegistrationCoordinator.getRegistryDigest(),
  }
  diagnostic.missingProviders, diagnostic.missingProvidersRemaining = copyLimited(missingProviders, 12)
  diagnostic.extraProviders, diagnostic.extraProvidersRemaining = copyLimited(extraProviders, 12)
  diagnostic.missingPlacementKinds, diagnostic.missingPlacementKindsRemaining = copyLimited(missingKinds, 12)
  diagnostic.extraPlacementKinds, diagnostic.extraPlacementKindsRemaining = copyLimited(extraKinds, 12)
  diagnostic.changedPlacementKinds, diagnostic.changedPlacementKindsRemaining = copyLimited(changedKinds, 12)
  diagnostic.missingGroups, diagnostic.missingGroupsRemaining = copyLimited(missingGroups, 12)
  diagnostic.extraGroups, diagnostic.extraGroupsRemaining = copyLimited(extraGroups, 12)
  diagnostic.changedGroups, diagnostic.changedGroupsRemaining = copyLimited(changedGroups, 12)
  diagnostic.missingCategories, diagnostic.missingCategoriesRemaining = copyLimited(missingCategories, 12)
  diagnostic.extraCategories, diagnostic.extraCategoriesRemaining = copyLimited(extraCategories, 12)
  diagnostic.changedCategories, diagnostic.changedCategoriesRemaining = copyLimited(changedCategories, 12)
  diagnostic.missingDefinitions, diagnostic.missingDefinitionsRemaining = copyLimited(missingDefinitions, 12)
  diagnostic.extraDefinitions, diagnostic.extraDefinitionsRemaining = copyLimited(extraDefinitions, 12)
  diagnostic.changedDefinitions, diagnostic.changedDefinitionsRemaining = copyLimited(changedDefinitions, 12)
  return diagnostic
end

local function logDiagnostic(player, diagnostic)
  print('MoreBuilds registry mismatch: player=' .. player:getUsername()
    .. ' apiVersionMatches=' .. tostring(diagnostic.apiVersionMatches)
    .. ' schemaMatches=' .. tostring(diagnostic.schemaMatches)
    .. ' serverDigest=' .. diagnostic.serverDigest)
  for _, field in ipairs(DIAGNOSTIC_FIELDS) do
    local entries = diagnostic[field]
    if entries and #entries > 0 then
      print('MoreBuilds registry mismatch: ' .. field .. '=' .. table.concat(entries, ',')
        .. ' remaining=' .. tostring(diagnostic[field .. 'Remaining']))
    end
  end
end

local function sendResult(player, accepted, diagnostic)
  sendServerCommand(player, MODULE, 'registryResult', {
    accepted = accepted,
    diagnostic = diagnostic,
    playerIndex = player:getIndex(),
    serverDigest = RegistrationCoordinator.getRegistryDigest(),
  })
end

local function onClientCommand(module, command, player, args)
  if module ~= MODULE then
    return
  end
  Bootstrap.ensureSealed()
  if command == 'registryDigest' then
    RegistryGuard.setCompatible(player, false)
    if args and args.apiVersion == RegistrationCoordinator.API_VERSION and args.digest == RegistrationCoordinator.getRegistryDigest() then
      awaitingManifest[player] = nil
      RegistryGuard.setCompatible(player, true)
      sendResult(player, true)
      return
    end
    awaitingManifest[player] = true
    sendServerCommand(player, MODULE, 'registryManifestRequested', {
      playerIndex = player:getIndex(),
      serverDigest = RegistrationCoordinator.getRegistryDigest(),
    })
    return
  end
  if command == 'registryManifest' and awaitingManifest[player] then
    awaitingManifest[player] = nil
    RegistryGuard.setCompatible(player, false)
    if isManifest(args) then
      local diagnostic = makeDiagnostic(args)
      logDiagnostic(player, diagnostic)
      sendResult(player, false, diagnostic)
    else
      sendResult(player, false, {
        invalidManifest = true,
        serverDigest = RegistrationCoordinator.getRegistryDigest(),
      })
    end
  end
end

local function prunePlayerState()
  if not isServer() then
    return
  end
  local activePlayers = RegistryGuard.prune(getOnlinePlayers())
  for player in pairs(awaitingManifest) do
    if not activePlayers[player] then
      awaitingManifest[player] = nil
    end
  end
end

function RegistryAuthority.install()
  if RegistryAuthority.installed then
    return
  end
  Events.OnClientCommand.Add(onClientCommand)
  Events.EveryOneMinute.Add(prunePlayerState)
  RegistryAuthority.installed = true
end

return RegistryAuthority
