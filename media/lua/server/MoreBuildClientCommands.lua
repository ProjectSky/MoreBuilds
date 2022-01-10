MoreBuildClientCommands = {}
local BuildCommands = {}
MoreBuildClientCommands.Lightpoles = {}
BuildCommands.object = {}

MoreBuildClientCommands.wantNoise = getDebug()
local noise = function(msg)
  if (MoreBuildClientCommands.wantNoise) then
    print('ClientCommand: ' .. msg)
  end
end

local getThumpableElectricLight = function(x, y, z)
  local gs = getCell():getGridSquare(x, y, z)
  if not gs then
    return nil
  end
  for i = 0, gs:getSpecialObjects():size() - 1 do
    local o = gs:getSpecialObjects():get(i)
    if o and instanceof(o, 'IsoThumpable') then
      if not o:haveFuel() then
        if o:getModData()['IsLighting'] then
          return o
        end
      end
    end
  end
  return nil
end

BuildCommands.object.toggleElectricLight = function(player, args)
  local o = getThumpableElectricLight(args.x, args.y, args.z)
  if o then
    if o:getSquare():haveElectricity() or (SandboxVars.ElecShutModifier > -1 and GameTime:getInstance():getNightsSurvived() < SandboxVars.ElecShutModifier) then
      o:toggleLightSource(not o:isLightSourceOn())
      o:sendObjectChange('lightSource')
    else
      o:toggleLightSource(false)
      o:sendObjectChange('lightSource')
    end
    if o:isLightSourceOn() then
      MoreBuildClientCommands.addPole(o:getSquare())
    else
      MoreBuildClientCommands.removePole(o:getSquare())
    end
  end
end

function MoreBuildClientCommands.removePole(square)
  for i, v in ipairs(MoreBuildClientCommands.Lightpoles) do
    if v.x == square:getX() and v.y == square:getY() and v.z == square:getZ() then
      table.remove(MoreBuildClientCommands.Lightpoles, i)
      break
    end
  end
end

function MoreBuildClientCommands.addPole(square)
  local Lightpole = {}
  Lightpole.x = square:getX()
  Lightpole.y = square:getY()
  Lightpole.z = square:getZ()
  table.insert(MoreBuildClientCommands.Lightpoles, Lightpole)
end

MoreBuildClientCommands.OnClientCommand = function(module, command, player, args)
  if BuildCommands[module] and BuildCommands[module][command] then
    local argStr = ''
    for k, v in pairs(args) do
      argStr = argStr .. ' ' .. k .. '=' .. tostring(v)
    end
    noise('received ' .. module .. ' ' .. command .. ' ' .. tostring(player) .. argStr)
    BuildCommands[module][command](player, args)
  end
end

function MoreBuildClientCommands.findObject(square)
  if not square then
    return nil
  end
  for i = 0, square:getSpecialObjects():size() - 1 do
    local o = square:getSpecialObjects():get(i)
    if o and instanceof(o, 'IsoThumpable') then
      if not o:haveFuel() then
        if o:getModData()['IsLighting'] then
          return o
        end
      end
    end
  end
  return nil
end

function MoreBuildClientCommands.checkPower()
  if isClient() then
    return
  end
  local temptable = MoreBuildClientCommands.Lightpoles
  for i, v in ipairs(temptable) do
    local square = getCell():getGridSquare(v.x, v.y, v.z)
    if square then
      if not (square:haveElectricity() or (SandboxVars.ElecShutModifier > -1 and GameTime:getInstance():getNightsSurvived() < SandboxVars.ElecShutModifier)) then
        local obj = MoreBuildClientCommands.findObject(square)
        if obj then
          obj:toggleLightSource(false)
          obj:sendObjectChange('lightSource')
          MoreBuildClientCommands.removePole(square)
        else
          MoreBuildClientCommands.removePole(square)
        end
      end
    end
  end
end

MoreBuildClientCommands.OnObjectAdded = function(o)
  if isClient() then
    return
  end

  if o and instanceof(o, 'IsoThumpable') then
    if not o:haveFuel() then
      if o:getModData()['IsLighting'] then
        if o:isLightSourceOn() then
          MoreBuildClientCommands.addPole(o:getSquare())
        end
      end
    end
  end
end

function MoreBuildClientCommands.OnDestroyIsoThumpable(o, player)
  if isClient() then
    return
  end
  if not o:getSquare() or not (o:getModData()['IsLighting']) then
    return
  end
  local sq = o:getSquare()
  MoreBuildClientCommands.removePole(sq)
end

Events.EveryTenMinutes.Add(MoreBuildClientCommands.checkPower)
Events.OnObjectAdded.Add(MoreBuildClientCommands.OnObjectAdded)
Events.OnDestroyIsoThumpable.Add(MoreBuildClientCommands.OnDestroyIsoThumpable)
Events.OnClientCommand.Add(MoreBuildClientCommands.OnClientCommand)