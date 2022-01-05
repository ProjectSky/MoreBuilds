DebugWindow = ISCollapsableWindow:derive('MoreBuilds_Debug')
DebugWindowInstance = nil
DebugWindowInited = false

local MoreBuilds_Debug = {}

function DebugWindow:initialise()
  ISCollapsableWindow.initialise(self)
end

local function ShowItemsListViewer()
  if ISItemsListViewer.instance then
    ISItemsListViewer.instance:close()
  end
  local modal = ISItemsListViewer:new(50, 200, 680, 650, getPlayer())
  modal:initialise()
  modal:addToUIManager()
end

function DebugWindow:ButtonClick(button)
  local char = getPlayer()
  local x = char:getX()
  local y = char:getY()
  local z = char:getZ()
  local Zombie = 100
  if button.internal == 'MG_zombie' then
    newZombiePopulationWindow()
  elseif button.internal == 'clear_zombie' then
    getWorld():ForceKillAllZombies()
  elseif button.internal == 'Items_View' then
    ShowItemsListViewer()
  elseif button.internal == 'clear_moolds' then
    local body = char:getBodyDamage()
    body:RestoreToFullHealth()
  elseif button.internal == 'add_skill' then
    local perks = PerkFactory.PerkList
    for i = 0, perks:size() - 1 do
      local perk = perks:get(i):getType()
      char:LevelPerk(perk)
    end
  elseif button.internal == 'start_rain' then
    if RainManager:isRaining() then
      RainManager:stopRaining()
    else
      RainManager:startRaining()
    end
  elseif button.internal == 'add_item' then
    local container = char:getInventory()
    if DebugWindowInstance.textEntry:getText() == nil or luautils.trim(DebugWindowInstance.textEntry:getText()) == '' then
      if container:getNumItems('Base.Axe') == 0 then
        container:AddItem('Base.Axe')
        container:AddItem('Base.Hammer')
        container:AddItem('Base.Saw')
        container:AddItem('Base.Lighter')
      end
      container:AddItem('Base.Plank')
      container:AddItem('Base.NailsBox')
    else
      container:AddItem(DebugWindowInstance.textEntry:getText())
    end
  elseif button.internal == 'Build_Mode' then
    ISBuildMenu.cheat = not ISBuildMenu.cheat
    if ISBuildMenu.cheat == true then
    end
  elseif button.internal == 'Lua_Debug' then
    ISUILuaWindow.SetupBar()
  end
  if button.internal == 'Zombie_Spawn' then
    spawnHorde(x - ZombRand(50), y + ZombRand(50), x - ZombRand(50), y + ZombRand(50), z, Zombie)
  end
end

function DebugWindow:createChildren()
  ISCollapsableWindow.createChildren(self)
  local butt = ISButton:new(8, 24, 64, 24, 'Zombie Manage', butt, DebugWindow.ButtonClick)
  butt.internal = 'MG_zombie'
  self:addChild(butt)
  butt = ISButton:new(110, 24, 64, 24, 'Clear Debuff', butt, DebugWindow.ButtonClick)
  butt.internal = 'clear_moolds'
  self:addChild(butt)
  butt = ISButton:new(195, 24, 80, 24, 'Clear Zombie', butt, DebugWindow.ButtonClick)
  butt.internal = 'clear_zombie'
  self:addChild(butt)
  butt = ISButton:new(80, 56, 64, 24, 'Add skill', butt, DebugWindow.ButtonClick)
  butt.internal = 'add_skill'
  self:addChild(butt)
  butt = ISButton:new(8, 56, 64, 24, 'Start Rain', butt, DebugWindow.ButtonClick)
  butt.internal = 'start_rain'
  self:addChild(butt)
  butt = ISButton:new(8, 88, 64, 24, 'Add Item', butt, DebugWindow.ButtonClick)
  butt.internal = 'add_item'
  self:addChild(butt)
  butt = ISButton:new(150, 56, 80, 24, 'Build Mode', butt, DebugWindow.ButtonClick)
  butt.internal = 'Build_Mode'
  self:addChild(butt)
  butt = ISButton:new(170, 88, 80, 24, 'Lua Debug', butt, DebugWindow.ButtonClick)
  butt.internal = 'Lua_Debug'
  self:addChild(butt)
  butt = ISButton:new(8, 120, 80, 24, 'Zombie Spawn', butt, DebugWindow.ButtonClick)
  butt.internal = 'Zombie_Spawn'
  self:addChild(butt)
  butt = ISButton:new(8, 150, 80, 24, 'Items View', butt, DebugWindow.ButtonClick)
  butt.internal = 'Items_View'
  self:addChild(butt)
  self.textEntry = ISTextEntryBox:new('', 80, 88, 85, 24)
  self.textEntry:instantiate()
  self.textEntry:setAnchorLeft(false)
  self.textEntry:setAnchorRight(false)
  self.textEntry:setAnchorTop(true)
  self.textEntry:setAnchorBottom(false)
  self:addChild(self.textEntry)
end

function ShowDebugWindow()
  if DebugWindowInstance == nil then
    DebugWindowInstance = DebugWindow:new(180, 190, 300, 200)
    DebugWindowInstance:addToUIManager()
  else
    if DebugWindowInstance:getIsVisible() then
      DebugWindowInstance:setVisible(false)
    else
      DebugWindowInstance:setVisible(true)
    end
  end
end

local function OnKeyPressed(key)
  if isKeyDown(221) and isKeyDown(157) and key == 199 and DebugWindowInited then --getCore():getGameMode()=="Multiplayer"
    ShowDebugWindow()
  end
end

local function func_Init()
  if getSteamModeActive() and isAdmin() then
    DebugWindowInited = true
    Events.OnKeyPressed.Add(OnKeyPressed)
  end
end

Events.OnGameStart.Add(func_Init)

function DebugWindow:new(x, y, width, height)
  local o = {}
  o = ISCollapsableWindow:new(x, y, width, height)
  setmetatable(o, self)
  self.__index = self
  o.title = 'Debug Menu'
  o.width = width
  o.height = height
  o.borderColor = {r = 0.4, g = 0.4, b = 0.4, a = 1}
  o.backgroundColor = {r = 0, g = 0, b = 0, a = 0.5}
  o.drawFrame = true
  o.collapseCounter = 0
  o.viewList = {}
  o.resizable = true
  return o
end