ISUILuaWindow = ISCollapsableWindow:derive('ISUILuaWindow')

function ISUILuaWindow:initialise()
    ISCollapsableWindow.initialise(self)

    self.LuaBar = ISTextEntryBox:new('', 0, 15, 500, 237)
    self.LuaBar:initialise()
    self.LuaBar:instantiate()
    self.LuaBar:setMultipleLine(true)
    self.LuaBar.javaObject:setMaxLines(99999)
    self:addChild(self.LuaBar)

    self.pathBar = ISTextEntryBox:new('Filename here', 0, 250, 449, 22)
    self.pathBar:initialise()
    self.pathBar:instantiate()
    self.pathBar:setMultipleLine(false)
    self.pathBar.javaObject:setMaxLines(1)
    self.pathBar.borderColor = {r = 0.4, g = 0.4, b = 0.4, a = 0.4}
    self.pathBar:setVisible(false)
    self:addChild(self.pathBar)

    local mod = getModInfoByID('MoreBuild')
    local destPath = mod:getDir() .. '\\lua\\'

    self.pathBox = ISRichTextPanel:new(0, 271, 550, 24)
    self.pathBox.borderColor = {r = 0.4, g = 0.4, b = 0.4, a = 0.4}
    self.pathBox.marginTop = 4
    self.pathBox.text = 'Path: ' .. destPath
    self.pathBox:initialise()
    self.pathBox.autosetheight = false
    self.pathBox:paginate()
    self.pathBox:setVisible(false)
    self:addChild(self.pathBox)

    self.goButton =
        ISButton:new(
        499,
        250,
        51,
        22,
        'Go',
        self,
        function()
            ISUILuaWindow.portLua()
        end
    )
    self.goButton:initialise()
    self.goButton:instantiate()
    self.goButton.borderColor = {r = 0.4, g = 0.4, b = 0.4, a = 0.4}
    self.goButton:setVisible(false)
    self:addChild(self.goButton)

    self.closeButton = ISButton:new(449, 250, 51, 22, 'Close', self, ISUILuaWindow.togglePathBar)
    self.closeButton:initialise()
    self.closeButton:instantiate()
    self.closeButton.borderColor = {r = 0.4, g = 0.4, b = 0.4, a = 0.4}
    self.closeButton:setVisible(false)
    self:addChild(self.closeButton)

    self.confirmBox =
        ISRichTextPanel:new(
        self.LuaBar:getWidth() / 6,
        self.LuaBar:getHeight() / 2.5,
        self.LuaBar:getWidth() / 1.5,
        self.LuaBar:getHeight() / 3
    )
    self.confirmBox.backgroundColor = {r = 0, g = 0, b = 0, a = 0.8}
    self.confirmBox.borderColor = {r = 0.4, g = 0.4, b = 0.4, a = 1}
    self.confirmBox.text = 'File already exists. Are you sure you want to overwrite?'

    self.confirmBox.noButton =
        ISButton:new(
        self.confirmBox:getWidth() / 16,
        self.confirmBox:getHeight() / 2.5,
        self.confirmBox:getWidth() / 2.5,
        self.confirmBox:getHeight() / 2,
        'NO',
        self,
        function()
            ISUILuaWindow.confirmBox:setVisible(false)
        end
    )
    self.confirmBox.noButton.borderColor = {r = 0.4, g = 0.4, b = 0.4, a = 0.6}
    self.confirmBox.yesButton =
        ISButton:new(
        self.confirmBox:getWidth() / 1.88,
        self.confirmBox:getHeight() / 2.5,
        self.confirmBox:getWidth() / 2.5,
        self.confirmBox:getHeight() / 2,
        'YES',
        self,
        function()
            ISUILuaWindow.portLua(nil, false, true)
            ISUILuaWindow.confirmBox:setVisible(false)
        end
    )
    self.confirmBox.yesButton.borderColor = {r = 0.4, g = 0.4, b = 0.4, a = 0.6}
    self.confirmBox:addChild(self.confirmBox.yesButton) -- add these buttons to confirmBox so I can manipulate them as a single element
    self.confirmBox:addChild(self.confirmBox.noButton)

    self.confirmBox:initialise()
    self.confirmBox.autosetheight = false
    self.confirmBox:paginate()
    self.confirmBox:setVisible(false)
    self:addChild(self.confirmBox)

    self.runButton = ISButton:new(self:getWidth() - 51, 15, 51, 80, 'Run', self, ISUILuaWindow.runLua)
    self.runButton:initialise()
    self.runButton:instantiate()
    self.runButton.borderColor = {r = 0.4, g = 0.4, b = 0.4, a = 0.4}
    self:addChild(self.runButton)

    self.exportButton =
        ISButton:new(
        self:getWidth() - 51,
        94,
        51,
        80,
        'Export',
        self,
        function()
            ISUILuaWindow.portLua('export', true)
        end
    )
    self.exportButton:initialise()
    self.exportButton:instantiate()
    self.exportButton.borderColor = {r = 0.4, g = 0.4, b = 0.4, a = 0.4}
    self:addChild(self.exportButton)

    self.importButton =
        ISButton:new(
        self:getWidth() - 51,
        173,
        51,
        78,
        'Import',
        self,
        function()
            ISUILuaWindow.portLua('import', true)
        end
    )
    self.importButton:initialise()
    self.importButton:instantiate()
    self.importButton.borderColor = {r = 0.4, g = 0.4, b = 0.4, a = 0.4}
    self:addChild(self.importButton)
end

function ISUILuaWindow.togglePathBar()
    if ISUILuaWindow.pathBar:getIsVisible() ~= true then -- basic if else statement
        ISUILuaWindow:setHeight(getCore():getScreenHeight() - 606) -- make the window larger to accomodate for the new bar
        ISUILuaWindow.pathBar:setVisible(true) -- unhide the pathbar elements
        ISUILuaWindow.goButton:setVisible(true)
        ISUILuaWindow.pathBox:setVisible(true)
        ISUILuaWindow.closeButton:setVisible(true)
    else
        ISUILuaWindow.pathBar:setVisible(false) -- set everything to nonvisible
        ISUILuaWindow.goButton:setVisible(false)
        ISUILuaWindow.pathBox:setVisible(false)
        ISUILuaWindow.closeButton:setVisible(false)
        ISUILuaWindow:setHeight(getCore():getScreenHeight() - 650) -- else, shrink it back to normal
    end
end

function ISUILuaWindow.portLua(mode, noStart, doNotCheck)
    if ISUILuaWindow.pathBar:getIsVisible() ~= true then
        ISUILuaWindow.togglePathBar()
    end

    if type(mode) == 'string' then -- set the mode, either export or import
        ISUILuaWindow['mode'] = mode
    end

    if noStart ~= true then
        local mod = getModInfoByID('MoreBuild')
        local destPath = mod:getDir() .. '\\lua\\' .. ISUILuaWindow.pathBar:getText() -- for the user to look at
        local destPath2 = 'lua/' .. ISUILuaWindow.pathBar:getText() -- for the game-relative path

        if ISUILuaWindow.mode == 'export' then -- commence export actions
            local strTable = {}

            for i in string.gmatch(ISUILuaWindow.LuaBar:getText(), '[\n]*.+') do -- put each line of the lua bar's content into a separate table entry, so I can write them to a file later
                strTable[#strTable + 1] = i
            end
            if doNotCheck ~= true then
                if fileExists(destPath) then
                    print('FILE ' .. destPath .. ' ALREADY EXISTS! Prompting user to overwrite.')
                    ISUILuaWindow.confirmBox:setVisible(true)
                    return false
                end
            end
            _s.writeFile(strTable, 'MoreBuild', destPath2)
            print('File successfully written!')
        elseif ISUILuaWindow.mode == 'import' then -- otherwise, commence import actions
            if fileExists(destPath) then -- check if the file exists first, to prevent errors and to prevent readFile from creating a new file
                local fileT = _s.readFile('MoreBuild', destPath2)
                ISUILuaWindow.LuaBar:clear() -- clear the lua interpreter first
                for i = 1, #fileT do
                    ISUILuaWindow.LuaBar:setText(ISUILuaWindow.LuaBar:getText() .. fileT[i] .. '\n')
                end
                print('File successfully imported!') -- inform user in console if successful
            else
                print('Error: file does not exist!') -- or if unsuccessful.
            end
        end
    end
end

function ISUILuaWindow:new(x, y, width, height)
    local o = {}
    o = ISCollapsableWindow:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.title = 'Lua Debug'
    o.pin = true
    o.resizable = false
    o:noBackground()
    o.borderColor = {r = 0.4, g = 0.4, b = 0.4, a = 0.4}
    return o
end

function ISUILuaWindow.runLua()
    loadstring(ISUILuaWindow.LuaBar:getText())()
end

function ISUILuaWindow.SetupBar()
    ISUILuaWindow:setVisible(true)
    ISUILuaWindow.LuaBar:setEditable(true)
    ISUILuaWindow.LuaBar.borderColor = {r = 0.4, g = 0.4, b = 0.4, a = 0.4} -- for some reason LuaBar's border color refused to stick if I defined it in the init or anywhere else.
end

function LuaWindowCreate() -- basic UI setup
    ISUILuaWindow =
        ISUILuaWindow:new(
        getCore():getScreenWidth() - 1050,
        getCore():getScreenHeight() - 350,
        getCore():getScreenWidth() - 1050,
        getCore():getScreenHeight() - 650
    )
    ISUILuaWindow:initialise()
    ISUILuaWindow:addToUIManager()
    ISUILuaWindow:setVisible(false)
end

Events.OnGameStart.Add(LuaWindowCreate)
