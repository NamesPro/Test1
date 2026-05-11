--// POTATO UI V5.0 (MODERN DARK/WHITE STYLE 2026)
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name == "Potato_V5" or v.Name == "PotatoToggleUI" then v:Destroy() end
end

local function Tween(obj, t, props)
    TS:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play()
end

local function Corner(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = obj
end

local ConfigManager = {}
ConfigManager.Configs = {}
ConfigManager.CurrentConfig = "default"

function ConfigManager:SaveConfig(name)
    local config = {}
    for _, callback in pairs(self.Callbacks) do
        local data = callback()
        if data then config[data.name] = data.value end
    end
    self.Configs[name] = config
    self.CurrentConfig = name
    pcall(function() writefile("PotatoUI_Configs.json", HttpService:JSONEncode(self.Configs)) end)
    return true
end

function ConfigManager:LoadConfig(name)
    local config = self.Configs[name]
    if not config then return false end
    self.CurrentConfig = name
    for _, callback in pairs(self.LoadCallbacks) do callback(config) end
    return true
end

function ConfigManager:DeleteConfig(name)
    if name == "default" then return false end
    self.Configs[name] = nil
    pcall(function() writefile("PotatoUI_Configs.json", HttpService:JSONEncode(self.Configs)) end)
    return true
end

function ConfigManager:GetConfigs() return self.Configs end

pcall(function()
    if isfile and isfile("PotatoUI_Configs.json") then
        ConfigManager.Configs = HttpService:JSONDecode(readfile("PotatoUI_Configs.json"))
    end
end)

ConfigManager.Callbacks = {}
ConfigManager.LoadCallbacks = {}

local Library = {}

-- ЦВЕТОВАЯ СХЕМА 2026
local C = {
    BG = Color3.fromRGB(18, 18, 20),
    Header = Color3.fromRGB(12, 12, 14),
    Sidebar = Color3.fromRGB(14, 14, 16),
    Card = Color3.fromRGB(24, 24, 28),
    CardHover = Color3.fromRGB(30, 30, 34),
    Accent = Color3.fromRGB(130, 130, 255),
    AccentDark = Color3.fromRGB(100, 100, 220),
    Text = Color3.fromRGB(220, 220, 230),
    TextDim = Color3.fromRGB(140, 140, 150),
    Border = Color3.fromRGB(35, 35, 40),
    Danger = Color3.fromRGB(255, 90, 90),
    ToggleOff = Color3.fromRGB(50, 50, 55),
    Input = Color3.fromRGB(30, 30, 35),
}

function Library:CreateWindow(title)
    local UI = Instance.new("ScreenGui")
    UI.Name = "Potato_V5"
    UI.Parent = CoreGui
    UI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local ToggleScreen = Instance.new("ScreenGui")
    ToggleScreen.Name = "PotatoToggleUI"
    ToggleScreen.Parent = CoreGui
    
    local OpenBtn = Instance.new("TextButton")
    OpenBtn.Parent = ToggleScreen
    OpenBtn.Size = UDim2.fromOffset(40, 40)
    OpenBtn.Position = UDim2.new(0, 15, 0, 15)
    OpenBtn.BackgroundColor3 = C.Card
    OpenBtn.Text = "✦"
    OpenBtn.TextColor3 = C.Accent
    OpenBtn.Font = Enum.Font.GothamBold
    OpenBtn.TextSize = 18
    OpenBtn.Visible = false
    Corner(OpenBtn, 20)
    Instance.new("UIStroke", OpenBtn).Color = C.Border

    local Main = Instance.new("Frame")
    Main.Parent = UI
    Main.Size = UDim2.fromOffset(380, 260)
    Main.Position = UDim2.new(0.5, -190, 0.5, -130)
    Main.BackgroundColor3 = C.BG
    Main.ClipsDescendants = true
    Corner(Main, 14)
    Instance.new("UIStroke", Main).Color = C.Border

    -- HEADER
    local Header = Instance.new("Frame")
    Header.Parent = Main
    Header.Size = UDim2.new(1, 0, 0, 32)
    Header.BackgroundColor3 = C.Header
    Corner(Header, 14)

    local Title = Instance.new("TextLabel")
    Title.Parent = Header
    Title.Size = UDim2.new(1, -40, 1, 0)
    Title.Position = UDim2.new(0, 14, 0, 0)
    Title.Text = title
    Title.TextColor3 = C.Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 12
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = Header
    CloseBtn.Size = UDim2.fromOffset(28, 28)
    CloseBtn.Position = UDim2.new(1, -34, 0, 2)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.new(1, 1, 1)
    CloseBtn.TextSize = 12
    Corner(CloseBtn, 14)
    
    CloseBtn.MouseButton1Click:Connect(function()
        Main.Visible = false
        OpenBtn.Visible = true
    end)
    
    OpenBtn.MouseButton1Click:Connect(function()
        Main.Visible = true
        OpenBtn.Visible = false
    end)

    local dragging, dragStart, startPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function() dragging = false end)

    -- SIDEBAR
    local Sidebar = Instance.new("Frame")
    Sidebar.Parent = Main
    Sidebar.Size = UDim2.new(0, 100, 1, -32)
    Sidebar.Position = UDim2.new(0, 6, 0, 32)
    Sidebar.BackgroundTransparency = 1
    
    local SidebarList = Instance.new("UIListLayout", Sidebar)
    SidebarList.Padding = UDim.new(0, 4)
    SidebarList.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- CONTENT
    local Container = Instance.new("Frame")
    Container.Parent = Main
    Container.Size = UDim2.new(1, -115, 1, -38)
    Container.Position = UDim2.new(0, 108, 0, 34)
    Container.BackgroundTransparency = 1
    Container.ClipsDescendants = true

    local Tabs = {First = true}

    function Tabs:CreateTab(name)
        local Page = Instance.new("ScrollingFrame")
        Page.Parent = Container
        Page.Size = UDim2.new(1, -4, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = C.Accent
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Page.ScrollingDirection = Enum.ScrollingDirection.Y
        Page.ScrollBarImageTransparency = 0.7
        
        local PageList = Instance.new("UIListLayout", Page)
        PageList.Padding = UDim.new(0, 4)

        local TabBtn = Instance.new("TextButton")
        TabBtn.Parent = Sidebar
        TabBtn.Size = UDim2.new(1, -8, 0, 26)
        TabBtn.BackgroundColor3 = C.Card
        TabBtn.Text = name
        TabBtn.TextColor3 = C.TextDim
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 10
        Corner(TabBtn, 8)
        Instance.new("UIStroke", TabBtn).Color = C.Border

        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(Container:GetChildren()) do if p:IsA("ScrollingFrame") then p.Visible = false end end
            for _, b in pairs(Sidebar:GetChildren()) do 
                if b:IsA("TextButton") then 
                    Tween(b, 0.2, {BackgroundColor3 = C.Card, TextColor3 = C.TextDim})
                end 
            end
            Page.Visible = true
            Tween(TabBtn, 0.2, {BackgroundColor3 = C.Accent, TextColor3 = Color3.new(1,1,1)})
            Page.CanvasPosition = Vector2.new(0, 0)
        end)

        if Tabs.First then 
            Tabs.First = false 
            Page.Visible = true 
            TabBtn.BackgroundColor3 = C.Accent
            TabBtn.TextColor3 = Color3.new(1,1,1)
        end

        local Elements = {}

        -- TOGGLE
        function Elements:CreateToggle(text, callback)
            local enabled = false
            local elementData = {name = text, value = enabled}
            
            local Item = Instance.new("TextButton", Page)
            Item.Size = UDim2.new(1, -4, 0, 30)
            Item.BackgroundColor3 = C.Card
            Item.Text = ""
            Corner(Item, 8)
            Instance.new("UIStroke", Item).Color = C.Border
            
            local Lbl = Instance.new("TextLabel", Item)
            Lbl.Size = UDim2.new(1, -35, 1, 0)
            Lbl.Position = UDim2.new(0, 10, 0, 0)
            Lbl.BackgroundTransparency = 1
            Lbl.Text = text
            Lbl.TextColor3 = C.Text
            Lbl.Font = Enum.Font.GothamMedium
            Lbl.TextSize = 10
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
            
            local Check = Instance.new("Frame", Item)
            Check.Size = UDim2.fromOffset(14, 14)
            Check.Position = UDim2.new(1, -25, 0.5, -7)
            Check.BackgroundColor3 = C.ToggleOff
            Corner(Check, 7)
            
            Item.MouseButton1Click:Connect(function()
                enabled = not enabled
                elementData.value = enabled
                Tween(Check, 0.15, {BackgroundColor3 = enabled and C.Accent or C.ToggleOff})
                callback(enabled)
            end)

            table.insert(ConfigManager.Callbacks, function() return {name = text, value = enabled} end)
            table.insert(ConfigManager.LoadCallbacks, function(config)
                local data = config[text]
                if data ~= nil then
                    enabled = data
                    Check.BackgroundColor3 = enabled and C.Accent or C.ToggleOff
                    elementData.value = enabled
                    callback(enabled)
                end
            end)
        end

        -- SLIDER
        function Elements:CreateSlider(text, min, max, def, callback)
            local sliderValue = def
            local elementData = {name = text, value = def}
            
            local SFrame = Instance.new("Frame", Page)
            SFrame.Size = UDim2.new(1, -4, 0, 40)
            SFrame.BackgroundColor3 = C.Card
            Corner(SFrame, 8)
            Instance.new("UIStroke", SFrame).Color = C.Border
            
            local Lbl = Instance.new("TextLabel", SFrame)
            Lbl.Size = UDim2.new(1, -20, 0, 16)
            Lbl.Position = UDim2.new(0, 10, 0, 3)
            Lbl.BackgroundTransparency = 1
            Lbl.Text = text .. " : " .. def
            Lbl.TextColor3 = C.Text
            Lbl.Font = Enum.Font.GothamMedium
            Lbl.TextSize = 9
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
            
            local Bar = Instance.new("Frame", SFrame)
            Bar.Size = UDim2.new(1, -20, 0, 3)
            Bar.Position = UDim2.new(0, 10, 0, 26)
            Bar.BackgroundColor3 = C.Input
            Corner(Bar, 2)
            
            local Fill = Instance.new("Frame", Bar)
            Fill.Size = UDim2.new((def - min) / (max - min), 0, 1, 0)
            Fill.BackgroundColor3 = C.Accent
            Corner(Fill, 2)
            
            local function up(input)
                local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                local val = math.floor(((max - min) * pos) + min)
                Lbl.Text = text .. " : " .. val
                Fill.Size = UDim2.new(pos, 0, 1, 0)
                sliderValue = val
                elementData.value = val
                callback(val)
            end
            
            local sliding = false
            SFrame.InputBegan:Connect(function(i) 
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then sliding = true up(i) end 
            end)
            UIS.InputChanged:Connect(function(i) 
                if sliding and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then up(i) end 
            end)
            UIS.InputEnded:Connect(function() sliding = false end)

            table.insert(ConfigManager.Callbacks, function() return {name = text, value = sliderValue} end)
            table.insert(ConfigManager.LoadCallbacks, function(config)
                local data = config[text]
                if data ~= nil then
                    sliderValue = data
                    elementData.value = data
                    local pos = (data - min) / (max - min)
                    Lbl.Text = text .. " : " .. data
                    Fill.Size = UDim2.new(pos, 0, 1, 0)
                    callback(data)
                end
            end)
        end

        -- BUTTON
        function Elements:CreateButton(text, callback)
            local Btn = Instance.new("TextButton", Page)
            Btn.Size = UDim2.new(1, -4, 0, 30)
            Btn.BackgroundColor3 = C.Accent
            Btn.Text = text
            Btn.TextColor3 = Color3.new(1, 1, 1)
            Btn.Font = Enum.Font.GothamBold
            Btn.TextSize = 10
            Corner(Btn, 8)
            
            Btn.MouseButton1Click:Connect(function() callback() end)
            Btn.MouseEnter:Connect(function() Tween(Btn, 0.1, {BackgroundColor3 = C.AccentDark}) end)
            Btn.MouseLeave:Connect(function() Tween(Btn, 0.1, {BackgroundColor3 = C.Accent}) end)
        end

        -- LABEL
        function Elements:CreateLabel(text)
            local Lbl = Instance.new("TextLabel", Page)
            Lbl.Size = UDim2.new(1, -4, 0, 20)
            Lbl.BackgroundTransparency = 1
            Lbl.Text = text
            Lbl.TextColor3 = C.TextDim
            Lbl.Font = Enum.Font.Gotham
            Lbl.TextSize = 9
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
        end

        -- INPUT
        function Elements:CreateInput(text, placeholder, callback)
            local elementData = {name = text, value = ""}
            
            local InputFrame = Instance.new("Frame", Page)
            InputFrame.Size = UDim2.new(1, -4, 0, 30)
            InputFrame.BackgroundColor3 = C.Card
            Corner(InputFrame, 8)
            Instance.new("UIStroke", InputFrame).Color = C.Border
            
            local Lbl = Instance.new("TextLabel", InputFrame)
            Lbl.Size = UDim2.new(0, 70, 1, 0)
            Lbl.Position = UDim2.new(0, 8, 0, 0)
            Lbl.BackgroundTransparency = 1
            Lbl.Text = text
            Lbl.TextColor3 = C.TextDim
            Lbl.Font = Enum.Font.GothamMedium
            Lbl.TextSize = 9
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
            
            local Input = Instance.new("TextBox", InputFrame)
            Input.Size = UDim2.new(1, -86, 0, 22)
            Input.Position = UDim2.new(0, 78, 0.5, -11)
            Input.BackgroundColor3 = C.Input
            Input.Text = ""
            Input.TextColor3 = C.Text
            Input.Font = Enum.Font.Gotham
            Input.TextSize = 9
            Input.PlaceholderText = placeholder or ""
            Input.PlaceholderColor3 = C.TextDim
            Corner(Input, 5)
            
            Input.FocusLost:Connect(function()
                elementData.value = Input.Text
                callback(Input.Text)
            end)

            table.insert(ConfigManager.Callbacks, function() return {name = text, value = Input.Text} end)
            table.insert(ConfigManager.LoadCallbacks, function(config)
                local data = config[text]
                if data ~= nil then
                    Input.Text = data
                    elementData.value = data
                    callback(data)
                end
            end)
        end

        -- DROPDOWN
        function Elements:CreateDropdown(text, list, callback)
            local selected = list[1] or ""
            
            local DropFrame = Instance.new("Frame", Page)
            DropFrame.Size = UDim2.new(1, -4, 0, 30)
            DropFrame.BackgroundTransparency = 1
            
            local DropBtn = Instance.new("TextButton", DropFrame)
            DropBtn.Size = UDim2.new(1, 0, 0, 30)
            DropBtn.BackgroundColor3 = C.Card
            DropBtn.Text = "  " .. tostring(selected)
            DropBtn.TextColor3 = C.Text
            DropBtn.Font = Enum.Font.GothamMedium
            DropBtn.TextSize = 10
            DropBtn.TextXAlignment = Enum.TextXAlignment.Left
            Corner(DropBtn, 8)
            Instance.new("UIStroke", DropBtn).Color = C.Border
            
            local Arrow = Instance.new("TextLabel", DropBtn)
            Arrow.Size = UDim2.fromOffset(18, 18)
            Arrow.Position = UDim2.new(1, -22, 0.5, -9)
            Arrow.BackgroundTransparency = 1
            Arrow.Text = "›"
            Arrow.Rotation = 90
            Arrow.TextColor3 = C.Accent
            Arrow.Font = Enum.Font.GothamBold
            Arrow.TextSize = 14
            
            local DropList = Instance.new("Frame")
            DropList.Parent = UI
            DropList.Size = UDim2.fromOffset(240, 0)
            DropList.BackgroundColor3 = C.BG
            DropList.Visible = false
            DropList.ZIndex = 6000
            Corner(DropList, 10)
            Instance.new("UIStroke", DropList).Color = C.Accent
            
            local ScrollFrame = Instance.new("ScrollingFrame", DropList)
            ScrollFrame.Size = UDim2.new(1, -8, 1, -8)
            ScrollFrame.Position = UDim2.new(0, 4, 0, 4)
            ScrollFrame.BackgroundTransparency = 1
            ScrollFrame.ScrollBarThickness = 2
            ScrollFrame.ScrollBarImageColor3 = C.Accent
            ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
            ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
            
            local ListLayout = Instance.new("UIListLayout", ScrollFrame)
            ListLayout.Padding = UDim.new(0, 2)
            
            local dropOpen = false
            
            local function updateList()
                for _, v in pairs(ScrollFrame:GetChildren()) do
                    if v:IsA("TextButton") then v:Destroy() end
                end
                
                for _, item in pairs(list) do
                    local ItemBtn = Instance.new("TextButton", ScrollFrame)
                    ItemBtn.Size = UDim2.new(1, 0, 0, 24)
                    ItemBtn.BackgroundColor3 = selected == item and C.Accent or C.Card
                    ItemBtn.Text = "  " .. tostring(item)
                    ItemBtn.TextColor3 = selected == item and Color3.new(1,1,1) or C.Text
                    ItemBtn.Font = Enum.Font.Gotham
                    ItemBtn.TextSize = 9
                    ItemBtn.TextXAlignment = Enum.TextXAlignment.Left
                    Corner(ItemBtn, 6)
                    
                    ItemBtn.MouseButton1Click:Connect(function()
                        selected = item
                        DropBtn.Text = "  " .. tostring(selected)
                        DropList.Visible = false
                        dropOpen = false
                        Arrow.Rotation = 90
                        callback(selected)
                        updateList()
                    end)
                end
                
                DropList.Size = UDim2.fromOffset(240, math.min(#list * 26 + 8, 180))
            end
            
            DropBtn.MouseButton1Click:Connect(function()
                dropOpen = not dropOpen
                DropList.Position = UDim2.fromOffset(DropBtn.AbsolutePosition.X, DropBtn.AbsolutePosition.Y + 32)
                DropList.Visible = dropOpen
                Arrow.Rotation = dropOpen and 270 or 90
                if dropOpen then updateList() end
            end)
            
            UIS.InputBegan:Connect(function(input)
                if dropOpen and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                    local pos = input.Position
                    local listPos = DropList.AbsolutePosition
                    local listSize = DropList.AbsoluteSize
                    local btnPos = DropBtn.AbsolutePosition
                    local btnSize = DropBtn.AbsoluteSize
                    
                    if (pos.X < listPos.X or pos.X > listPos.X + listSize.X or pos.Y < listPos.Y or pos.Y > listPos.Y + listSize.Y) and
                       (pos.X < btnPos.X or pos.X > btnPos.X + btnSize.X or pos.Y < btnPos.Y or pos.Y > btnPos.Y + btnSize.Y) then
                        DropList.Visible = false
                        dropOpen = false
                        Arrow.Rotation = 90
                    end
                end
            end)
            
            local dropdownController = {}
            function dropdownController.SetValue(value)
                selected = value
                DropBtn.Text = "  " .. tostring(selected)
                callback(selected)
                updateList()
            end
            function dropdownController.GetValue() return selected end
            function dropdownController.Destroy()
                DropFrame:Destroy()
                DropList:Destroy()
            end
            
            return dropdownController
        end

        -- CONFIG SYSTEM
        function Elements:CreateConfigSystem()
            local configDropdown = nil
            local lastLoaded = ConfigManager.CurrentConfig
            
            local function getConfigList()
                local configs = {}
                for name, _ in pairs(ConfigManager:GetConfigs()) do table.insert(configs, name) end
                if #configs == 0 then configs = {"default"} end
                return configs
            end
            
            local function rebuildDropdown()
                if configDropdown then configDropdown.Destroy() end
                configDropdown = Elements:CreateDropdown("Config", getConfigList(), function(selected)
                    ConfigManager:LoadConfig(selected)
                    lastLoaded = selected
                end)
                configDropdown.SetValue(lastLoaded)
            end
            
            Elements:CreateLabel("Configuration")
            
            Elements:CreateButton("Save Config", function()
                local inputFrame = Instance.new("Frame")
                inputFrame.Parent = UI
                inputFrame.Size = UDim2.fromOffset(230, 90)
                inputFrame.BackgroundColor3 = C.BG
                inputFrame.Position = UDim2.new(0.5, -115, 0.5, -45)
                inputFrame.ZIndex = 7000
                Corner(inputFrame, 12)
                Instance.new("UIStroke", inputFrame).Color = C.Accent
                
                local title = Instance.new("TextLabel", inputFrame)
                title.Size = UDim2.new(1, 0, 0, 22)
                title.BackgroundTransparency = 1
                title.Text = "Save Config"
                title.TextColor3 = C.Text
                title.Font = Enum.Font.GothamBold
                title.TextSize = 11
                
                local input = Instance.new("TextBox", inputFrame)
                input.Size = UDim2.new(1, -16, 0, 26)
                input.Position = UDim2.new(0, 8, 0, 26)
                input.BackgroundColor3 = C.Input
                input.Text = ""
                input.TextColor3 = C.Text
                input.Font = Enum.Font.Gotham
                input.TextSize = 10
                input.PlaceholderText = "Config name..."
                input.PlaceholderColor3 = C.TextDim
                Corner(input, 6)
                
                local confirm = Instance.new("TextButton", inputFrame)
                confirm.Size = UDim2.new(1, -16, 0, 24)
                confirm.Position = UDim2.new(0, 8, 0, 56)
                confirm.BackgroundColor3 = C.Accent
                confirm.Text = "SAVE"
                confirm.TextColor3 = Color3.new(1,1,1)
                confirm.Font = Enum.Font.GothamBold
                confirm.TextSize = 10
                Corner(confirm, 6)
                
                input:CaptureFocus()
                
                confirm.MouseButton1Click:Connect(function()
                    if input.Text ~= "" then
                        ConfigManager:SaveConfig(input.Text)
                        lastLoaded = input.Text
                        inputFrame:Destroy()
                        rebuildDropdown()
                    end
                end)
                
                local closeConnection
                closeConnection = UIS.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                        local pos = inp.Position
                        local framePos = inputFrame.AbsolutePosition
                        local frameSize = inputFrame.AbsoluteSize
                        if (pos.X < framePos.X or pos.X > framePos.X + frameSize.X or pos.Y < framePos.Y or pos.Y > framePos.Y + frameSize.Y) then
                            inputFrame:Destroy()
                            closeConnection:Disconnect()
                        end
                    end
                end)
            end)
            
            Elements:CreateButton("Delete Config", function()
                if ConfigManager.CurrentConfig ~= "default" then
                    ConfigManager:DeleteConfig(ConfigManager.CurrentConfig)
                    lastLoaded = "default"
                    rebuildDropdown()
                end
            end)
            
            rebuildDropdown()
            
            if ConfigManager.Configs[ConfigManager.CurrentConfig] then
                ConfigManager:LoadConfig(ConfigManager.CurrentConfig)
            end
        end

        return Elements
    end
    
    return Tabs
end

return Library
