local MaterialSources = {}

local ACCESS_RADIUS = 2.5

local function addContainerTree(containers, seen, root)
  local stack = { root }
  while #stack > 0 do
    local container = stack[#stack]
    stack[#stack] = nil
    if container and not seen[container] then
      seen[container] = true
      containers:add(container)
      local items = container:getItems()
      for index = items:size() - 1, 0, -1 do
        local item = items:get(index)
        if instanceof(item, 'InventoryContainer') then
          stack[#stack + 1] = item:getItemContainer()
        end
      end
    end
  end
end

local function isNearSquare(square, center)
  local deltaX = square:getX() - center:getX()
  local deltaY = square:getY() - center:getY()
  return deltaX * deltaX + deltaY * deltaY <= ACCESS_RADIUS * ACCESS_RADIUS
end

local function isAccessible(player, container, center)
  local outer = container:getOutermostContainer()
  local vehiclePart = outer:getVehiclePart()
  if vehiclePart and not vehiclePart:getVehicle():canAccessContainer(vehiclePart:getIndex(), player) then
    return false
  end

  local square = outer:getSquare()
  if not vehiclePart and square then
    if center and not isNearSquare(square, center) then
      return false
    end
    if not center and square:DistToProper(player) > ACCESS_RADIUS then
      return false
    end
  end

  local parent = outer:getParent()
  return not (parent and instanceof(parent, 'IsoThumpable') and parent:isLockedToCharacter(player))
end

function MaterialSources.getAccessibleContainers(player, center)
  local containers = ArrayList.new()
  if player == nil then
    return containers
  end

  local seen = {}
  local seenVehicles = {}
  addContainerTree(containers, seen, player:getInventory())

  local x = center and center:getX() or math.floor(player:getX())
  local y = center and center:getY() or math.floor(player:getY())
  local z = center and center:getZ() or math.floor(player:getZ())
  for xx = x - 2, x + 2 do
    for yy = y - 2, y + 2 do
      local square = getCell():getGridSquare(xx, yy, z)
      local inRange = false
      if square then
        if center then
          inRange = isNearSquare(square, center)
        else
          inRange = square:DistToProper(player) <= ACCESS_RADIUS
        end
      end
      if inRange then
        local objects = square:getObjects()
        for objectIndex = 0, objects:size() - 1 do
          local object = objects:get(objectIndex)
          for containerIndex = 0, object:getContainerCount() - 1 do
            local container = object:getContainerByIndex(containerIndex)
            if isAccessible(player, container, center) then
              addContainerTree(containers, seen, container)
            end
          end
        end

        local vehicle = square:getVehicleContainer()
        if vehicle and not seenVehicles[vehicle] then
          seenVehicles[vehicle] = true
          for partIndex = 0, vehicle:getPartCount() - 1 do
            local container = vehicle:getPartByIndex(partIndex):getItemContainer()
            if container and isAccessible(player, container, center) then
              addContainerTree(containers, seen, container)
            end
          end
        end
      end
    end
  end
  return containers
end

function MaterialSources.getPreviewContainers(player, center)
  local containers = MaterialSources.getAccessibleContainers(player, center)
  if center == nil then
    return containers
  end

  local floor = ItemContainer.new('morebuilds-preview-floor', center, nil)
  for x = center:getX() - 1, center:getX() + 1 do
    for y = center:getY() - 1, center:getY() + 1 do
      local square = getCell():getGridSquare(x, y, center:getZ())
      local worldItems = square and square:getWorldObjects() or nil
      if worldItems then
        for index = 0, worldItems:size() - 1 do
          local item = worldItems:get(index):getItem()
          if item then
            floor:getItems():add(item)
          end
        end
      end
    end
  end
  if not floor:getItems():isEmpty() then
    containers:add(floor)
  end
  return containers
end

return MaterialSources
