---- Garden Hoses By Kyun, thanks to Robert Johnson for it's rain collector barrel and farming mod (among others !)

require 'BuildingObjects/ISBuildingObject'

ISpipe = ISBuildingObject:derive('ISpipe')

function ISpipe.checkForBarrel(square)
    for i = 0, square:getSpecialObjects():size() - 1 do
        if square:getSpecialObjects():get(i):getName() == 'Rain Collector Barrel' then
            return true
        end
    end
    return false
end

function ISpipe:create(x, y, z, north, sprite)
    local cell = getWorld():getCell()
    self.sq = cell:getGridSquare(x, y, z)
    self.javaObject = IsoObject.new(self.sq, sprite, 'WaterISpipe')
    self.javaObject:getModData()['ISpipeType'] = self.ISpipeType
    self.javaObject:getModData()['infinite'] = 'false'
    local ISpipe = {}
    ISpipe.x = self.sq:getX()
    ISpipe.y = self.sq:getY()
    ISpipe.z = self.sq:getZ()
    ISpipe.ISpipeType = self.ISpipeType
    ISpipe.infinite = 'false'
    if GameTime:getInstance():getNightsSurvived() < SandboxVars.WaterShutModifier then
        local north = cell:getGridSquare(self.sq:getX(), self.sq:getY() - 1, self.sq:getZ())
        local south = cell:getGridSquare(self.sq:getX(), self.sq:getY() + 1, self.sq:getZ())
        local east = cell:getGridSquare(self.sq:getX() + 1, self.sq:getY(), self.sq:getZ())
        local west = cell:getGridSquare(self.sq:getX() - 1, self.sq:getY(), self.sq:getZ())
        if north:getProperties():Is(IsoFlagType.waterISpiped) then
            if not ISpipe.checkForBarrel(north) then
                ISpipe.infinite = 'true'
                self.javaObject:getModData()['infinite'] = 'true'
            end
        elseif south:getProperties():Is(IsoFlagType.waterISpiped) then
            if not ISpipe.checkForBarrel(south) then
                ISpipe.infinite = 'true'
                self.javaObject:getModData()['infinite'] = 'true'
            end
        elseif east:getProperties():Is(IsoFlagType.waterISpiped) then
            if not ISpipe.checkForBarrel(east) then
                ISpipe.infinite = 'true'
                self.javaObject:getModData()['infinite'] = 'true'
            end
        elseif west:getProperties():Is(IsoFlagType.waterISpiped) then
            if not ISpipe.checkForBarrel(west) then
                ISpipe.infinite = 'true'
                self.javaObject:getModData()['infinite'] = 'true'
            end
        end
    end
    table.insert(WaterISpipe.ISpipes, ISpipe)
    self.sq:AddSpecialObject(self.javaObject)
    self.javaObject:transmitCompleteItemToServer()
end

function ISpipe:isValid(square, north)
    for i = 0, square:getObjects():size() - 1 do
        if square:getObjects():get(i):getName() == 'WaterISpipe' then
            return false
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
    if not self:haveMaterial(square) then
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
    return true
end

function ISpipe:render(x, y, z, square, north)
    ISBuildingObject.render(self, x, y, z, square, north)
end

function ISpipe:getHealth()
    return 100
end

function ISpipe:new(player, sprite, ISpipeType)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o:init()
    o:setSprite(sprite)
    o.name = 'Water ISpipe'
    o.dismantable = false
    o.canBarricade = false
    o.blockAllTheSquare = false
    o.canPassThrough = true
    o.maxTime = 10
    o.isContainer = false
    o.isThumpable = true
    o.noNeedHammer = true
    o.player = player
    o.ISpipeType = ISpipeType
    return o
end
