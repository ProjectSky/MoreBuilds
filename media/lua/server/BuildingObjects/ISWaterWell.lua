--***********************************************************
--**                    ROBERT JOHNSON                     **
--***********************************************************

ISWaterWell = ISBuildingObject:derive('ISWaterWell')
-- list of our WaterWell in the world
ISWaterWell.WaterWells = {}

ISWaterWell.wantNoise = false
local noise = function(msg)
    if (ISWaterWell.wantNoise) then
        print('Water Well: ' .. msg)
    end
end

function ISWaterWell:create(x, y, z, north, sprite)
    local cell = getWorld():getCell()
    self.sq = cell:getGridSquare(x, y, z)
    self.javaObject = IsoThumpable.new(cell, self.sq, sprite, north, self)
    buildUtil.setInfo(self.javaObject, self)
    buildUtil.consumeMaterial(self)
    -- the WaterWell have 200 base health + 100 per carpentry lvl
    self.javaObject:setMaxHealth(self:getHealth())
    self.javaObject:setHealth(self.javaObject:getMaxHealth())
    -- the sound that will be played when our WaterWell will be broken
    self.javaObject:setBreakSound('breakdoor')
    -- add the item to the ground
    self.sq:AddSpecialObject(self.javaObject)
    -- add some xp for because you successfully build the WaterWell
    buildUtil.addWoodXp(self)
    -- IsoObjects with 'waterAmount'
    ISWaterWell.waterAmount = ZombRand(250, 500)
    self.javaObject:getModData()['waterMax'] = 1200
    self.javaObject:getModData()['waterAmount'] = ISWaterWell.waterAmount
    self.javaObject:setName('Water Well')
    local WaterWell = {}
    WaterWell.x = self.sq:getX()
    WaterWell.y = self.sq:getY()
    WaterWell.z = self.sq:getZ()
    WaterWell.waterAmount = ISWaterWell.waterAmount
    WaterWell.waterMax = 1200
    WaterWell.exterior = self.sq:isOutside()
    table.insert(ISWaterWell.WaterWells, WaterWell)
    self.javaObject:transmitCompleteItemToServer()
    --~ 	print("add a WaterWell at : " .. x .. "," .. y);
end

function ISWaterWell:new(player, sprite, waterMax)
    -- OOP stuff
    -- we create an item (o), and return it
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o:init()
    -- the number of sprites can be up to 4, one for each direction, you ALWAYS need at least 2 sprites, south (Sprite) and north (NorthSprite)
    -- here we're not gonna be able to rotate our building (it's a WaterWell, so every face are the same), so we set that the south sprite = north sprite
    o:setSprite(sprite)
    o:setNorthSprite(sprite)
    o.name = 'Water Well'
    o.waterMax = waterMax
    o.player = player
    -- the WaterWell will be dismantable (come from IsoThumpable stuff, check buildUtil.setInfo to see wich options are available)
    o.dismantable = true
    -- you can't barricade it
    o.canBarricade = false
    -- the item will block all the square where it placed (not like a wall for example)
    o.blockAllTheSquare = true
    return o
end

-- return the health of the new WaterWell, it's 200 + 100 per carpentry lvl
function ISWaterWell:getHealth()
    return 200 + buildUtil.getWoodHealth(self)
end

-- our WaterWell can be placed on this square ?
-- this function is called everytime you move the mouse over a grid square, you can for example not allow building inside house..
function ISWaterWell:isValid(square)
    if not self:haveMaterial(square) then
        return false
    end
    if not square:isOutside() then
        return false
    end
    for i = 1, square:getObjects():size() do
        local obj = square:getObjects():get(i - 1)
        if
            obj:getTextureName() and getPlayer():getZ() == 0 and
                (luautils.stringStarts(obj:getTextureName(), 'floors_exterior_natural') or
                    luautils.stringStarts(obj:getTextureName(), 'blends_natural_01'))
         then
            return true
        end
    end
    if not square then
        return false
    end
    if square:isSolid() or square:isSolidTrans() then
        return false
    end
    if square:HasStairs() then
        return false
    end
    if square:HasTree() then
        return false
    end
    if not square:getMovingObjects():isEmpty() then
        return false
    end
    if not square:TreatAsSolidFloor() then
        return false
    end
    for i = 1, square:getObjects():size() do
        local obj = square:getObjects():get(i - 1)
        if self:getSprite() == obj:getTextureName() then
            return false
        end
    end
    if buildUtil.stairIsBlockingPlacement(square, true) then
        return false
    end
end

function ISWaterWell:render(x, y, z, square)
    ISBuildingObject.render(self, x, y, z, square)
end

function ISWaterWell.isISWaterWellObject(object)
    return object ~= nil and object:getName() == 'Water Well'
end

function ISWaterWell.findObject(square)
    if not square then
        return nil
    end
    for i = 0, square:getSpecialObjects():size() - 1 do
        local obj = square:getSpecialObjects():get(i)
        if ISWaterWell.isISWaterWellObject(obj) then
            return obj
        end
    end
    return nil
end

function ISWaterWell.checkRain()
    if isClient() then
        return
    end
    if RainManager.isRaining() then
        for iB, vB in ipairs(ISWaterWell.WaterWells) do
            if vB.waterAmount < vB.waterMax then
                local square = getCell():getGridSquare(vB.x, vB.y, vB.z)
                if square then
                    vB.exterior = square:isOutside()
                end
                if vB.exterior then
                    vB.waterAmount = math.min(vB.waterMax, vB.waterAmount + 0.2)
                    local obj = ISWaterWell.findObject(square)
                    if obj then -- object might have been destroyed
                        noise(
                            'added rain to WaterWell at ' ..
                                vB.x .. ',' .. vB.y .. ',' .. vB.z .. ' waterAmount=' .. vB.waterAmount
                        )
                        obj:setWaterAmount(vB.waterAmount)
                        obj:transmitModData()
                    end
                end
            end
        end
    end
end

function ISWaterWell.checkEveryHours()
    if isClient() then
        return
    end
    for iB, vB in ipairs(ISWaterWell.WaterWells) do
        if vB.waterAmount < vB.waterMax then
            local square = getCell():getGridSquare(vB.x, vB.y, vB.z)
            if square then
                vB.exterior = square:isOutside()
            end
            if vB.exterior then
                vB.waterAmount = math.min(vB.waterMax, vB.waterAmount + ZombRand(5, 10))
                local obj = ISWaterWell.findObject(square)
                if obj then -- object might have been destroyed
                    noise(
                        'added rain to WaterWell at ' ..
                            vB.x .. ',' .. vB.y .. ',' .. vB.z .. ' waterAmount=' .. vB.waterAmount
                    )
                    obj:setWaterAmount(vB.waterAmount)
                    obj:transmitModData()
                end
            end
        end
    end
end

Events.EveryHours.Add(ISWaterWell.checkEveryHours)

function ISWaterWell.LoadGridsquare(square)
    if isClient() then
        return
    end
    -- does this square have a rain WaterWell ?
    for i = 0, square:getSpecialObjects():size() - 1 do
        local obj = square:getSpecialObjects():get(i)
        if ISWaterWell.isISWaterWellObject(obj) then
            ISWaterWell.loadRainWaterWell(obj)
            break
        end
    end
end

function ISWaterWell.loadGridsquareJavaHook(sq, object)
    if isClient() then
        return
    end
    ISWaterWell.loadRainWaterWell(object)
end

function ISWaterWell.loadRainWaterWell(WaterWellObject)
    if not WaterWellObject or not WaterWellObject:getSquare() then
        return
    end
    local square = WaterWellObject:getSquare()
    local WaterWell = nil
    for i, v in ipairs(ISWaterWell.WaterWells) do
        if v.x == square:getX() and v.y == square:getY() and v.z == square:getZ() then
            WaterWell = v
            break
        end
    end
    if not WaterWell then
        WaterWell = {}
        WaterWell.x = square:getX()
        WaterWell.y = square:getY()
        WaterWell.z = square:getZ()
        WaterWell.waterAmount = WaterWellObject:getWaterAmount()
        WaterWell.waterMax = WaterWellObject:getModData()['waterMax']
        if square:getModData()['waterAmount'] then
            WaterWell.waterAmount = tonumber(square:getModData()['waterAmount'])
            square:getModData()['waterAmount'] = ISWaterWell.waterAmount
            square:getModData()['waterMax'] = 1200
            square:getModData()['alwaysTakeWater'] = nil
        end
        table.insert(ISWaterWell.WaterWells, WaterWell)
        noise(
            'new WaterWell created ' ..
                WaterWell.x .. ',' .. WaterWell.y .. ' with ' .. WaterWell.waterAmount .. ' water'
        )
    else
        noise('found existed WaterWell ' .. WaterWell.x .. ',' .. WaterWell.y .. ' with ' .. WaterWell.waterAmount)
        WaterWellObject:setWaterAmount(WaterWell.waterAmount)
    end
    WaterWellObject:getModData()['waterMax'] = WaterWell.waterMax
    WaterWell.exterior = square:isOutside()
end

ISWaterWell.OnWaterAmountChange = function(object, prevAmount)
    if isClient() then
        return
    end
    if not object then
        return
    end
    for iB, vB in ipairs(ISWaterWell.WaterWells) do
        if vB.x == object:getX() and vB.y == object:getY() and vB.z == object:getZ() then
            noise('waterAmount changed to ' .. object:getWaterAmount() .. ' at ' .. vB.x .. ',' .. vB.y .. ',' .. vB.z)
            vB.waterAmount = object:getWaterAmount()
            break
        end
    end
end

ISWaterWell.OnClientCommand = function(module, command, player, args)
    if module ~= 'object' then
        return
    end
    -- This takeWater command works for *any* object that the player takes
    -- water from, including sinks and rain WaterWells.
    if command == 'takeWater' then
        local gs = getCell():getGridSquare(args.x, args.y, args.z)
        if gs then
            for i = 0, gs:getObjects():size() - 1 do
                local obj = gs:getObjects():get(i)
                if obj:useWater(args.units) > 0 then
                    obj:transmitModData()
                    break
                end
            end
        end
    end
end

-- Called when the client adds an object to the map (which it shouldn't be able to)
ISWaterWell.OnObjectAdded = function(object)
    if isClient() then
        return
    end
    if ISWaterWell.isISWaterWellObject(object) then
        ISWaterWell.loadRainWaterWell(object)
    end
end

function ISWaterWell.OnDestroyIsoThumpable(thump, player)
    if isClient() then
        return
    end
    if not thump:getSquare() or not ISWaterWell.isISWaterWellObject(thump) then
        return
    end
    local sq = thump:getSquare()
    if not sq then
        return
    end
    for iB, vB in ipairs(ISWaterWell.WaterWells) do
        if vB.x == sq:getX() and vB.y == sq:getY() and vB.z == sq:getZ() then
            noise('destroyed at ' .. vB.x .. ',' .. vB.y .. ',' .. vB.z)
            table.remove(ISWaterWell.WaterWells, iB)
            break
        end
    end
end

Events.EveryTenMinutes.Add(ISWaterWell.checkRain)
Events.LoadGridsquare.Add(ISWaterWell.LoadGridsquare)
Events.OnWaterAmountChange.Add(ISWaterWell.OnWaterAmountChange)
Events.OnClientCommand.Add(ISWaterWell.OnClientCommand)
Events.OnObjectAdded.Add(ISWaterWell.OnObjectAdded)
Events.OnDestroyIsoThumpable.Add(ISWaterWell.OnDestroyIsoThumpable)
