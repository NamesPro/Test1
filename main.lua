--// POTATO UI V4.8(2) (CLASSIC STYLE + STABLE PICKER + CONFIG TAB + INPUT)
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Player = game:GetService("Players").LocalPlayer
local HttpService = game:GetService("HttpService")

for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name == "Potato_V4" or v.Name == "PotatoToggleUI" then v:Destroy() end
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
        if data then
            config[data.name] = data.value
        end
    end
    self.Configs[name] = config
    self.CurrentConfig = name
    pcall(function()
        writefile("PotatoUI_Configs.json", HttpService:JSONEncode(self.Configs))
    end)
    return true
end

function ConfigManager:LoadConfig(name)
    local config = self.Configs[name]
    if not config then return false end
    self.CurrentConfig = name
    for _, callback in pairs(self.LoadCallbacks) do
        callback(config)
    end
    return true
end

function ConfigManager:DeleteConfig(name)
    if name == "default" then return false end
    self.Configs[name] = nil
    pcall(function()
        writefile("PotatoUI_Configs.json", HttpService:JSONEncode(self.Configs))
    end)
    return true
end

function ConfigManager:GetConfigs()
    return self.Configs
end

pcall(function()
    if isfile and isfile("PotatoUI_Configs.json") then
        ConfigManager.Configs = HttpService:JSONDecode(readfile("PotatoUI_Configs.json"))
    end
end)

ConfigManager.Callbacks = {}
ConfigManager.LoadCallbacks = {}

local Library = {}
local IsPickerOpen = false

function Library:CreateWindow(title)
    local UI = Instance.new("ScreenGui")
    UI.Name = "Potato_V4"
    UI.Parent = CoreGui
    UI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
local CameraBlocker = Instance.new("Frame")
CameraBlocker.Size = UDim2.new(1, 0, 1, 0)
CameraBlocker.BackgroundTransparency = 1
CameraBlocker.Visible = false
CameraBlocker.ZIndex = 1
CameraBlocker.Active = true
CameraBlocker.Parent = UI
    
    local ToggleScreen = Instance.new("ScreenGui")
    ToggleScreen.Name = "PotatoToggleUI"
    ToggleScreen.Parent = CoreGui
    
    local OpenBtn = Instance.new("TextButton")
    OpenBtn.Parent = ToggleScreen
    OpenBtn.Size = UDim2.fromOffset(45, 45)
    OpenBtn.Position = UDim2.new(0, 10, 0, 10)
    OpenBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    OpenBtn.Text = "P"
    OpenBtn.TextColor3 = Color3.fromRGB(0, 150, 255)
    OpenBtn.Font = Enum.Font.GothamBold
    OpenBtn.TextSize = 22
    OpenBtn.Visible = false
    Corner(OpenBtn, 50)

    local Main = Instance.new("Frame")
    Main.Parent = UI
    Main.Size = UDim2.fromOffset(400, 280)
    Main.Position = UDim2.new(0.5, -200, 0.5, -140)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Corner(Main, 10)

    local Header = Instance.new("Frame")
    Header.Parent = Main
    Header.Size = UDim2.new(1, 0, 0, 35)
    Header.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Corner(Header, 10)

    local Title = Instance.new("TextLabel")
    Title.Parent = Header
    Title.Size = UDim2.new(1, -70, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Text = title
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = Header
    CloseBtn.Size = UDim2.fromOffset(35, 35)
    CloseBtn.Position = UDim2.new(1, -35, 0, 0)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
    CloseBtn.TextSize = 22
    
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
            CameraBlocker.Visible = IsPickerOpen
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function()
        dragging = false 
        CameraBlocker.Visible = false
end)

    local Sidebar = Instance.new("Frame")
    Sidebar.Parent = Main
    Sidebar.Size = UDim2.new(0, 110, 1, -45)
    Sidebar.Position = UDim2.new(0, 10, 0, 40)
    Sidebar.BackgroundTransparency = 1
    
    local SidebarList = Instance.new("UIListLayout")
    SidebarList.Padding = UDim.new(0, 5)
    SidebarList.Parent = Sidebar

    local Container = Instance.new("Frame")
    Container.Parent = Main
    Container.Size = UDim2.new(1, -135, 1, -50)
    Container.Position = UDim2.new(0, 125, 0, 40)
    Container.BackgroundTransparency = 1
    Container.ClipsDescendants = true

    local Tabs = {First = true}

    function Tabs:CreateTab(name)
        local Page = Instance.new("ScrollingFrame")
        Page.Parent = Container
        Page.Size = UDim2.new(1, -5, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 4
        Page.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Page.ScrollingDirection = Enum.ScrollingDirection.Y
        Page.ScrollBarImageTransparency = 0.5
        
        local PageList = Instance.new("UIListLayout")
        PageList.Padding = UDim.new(0, 5)
        PageList.Parent = Page

        local TabBtn = Instance.new("TextButton")
        TabBtn.Parent = Sidebar
        TabBtn.Size = UDim2.new(1, -10, 0, 30)
        TabBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        TabBtn.Text = name
        TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 11
        Corner(TabBtn, 6)

        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(Container:GetChildren()) do 
                if p:IsA("ScrollingFrame") then p.Visible = false end 
            end
            for _, b in pairs(Sidebar:GetChildren()) do 
                if b:IsA("TextButton") then 
                    b.TextColor3 = Color3.fromRGB(150, 150, 150) 
                    b.BackgroundColor3 = Color3.fromRGB(22, 22, 22) 
                end 
            end
            Page.Visible = true
            TabBtn.TextColor3 = Color3.new(1, 1, 1)
            TabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Page.CanvasPosition = Vector2.new(0, 0)
        end)

        if Tabs.First then 
            Tabs.First = false 
            Page.Visible = true 
            TabBtn.TextColor3 = Color3.new(1,1,1) 
            TabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35) 
        end

        local Elements = {}

        -- TOGGLE
        function Elements:CreateToggle(text, callback)
            local enabled = false
            local elementData = {name = text, value = enabled}
            
            local Item = Instance.new("TextButton", Page)
            Item.Size = UDim2.new(1, -5, 0, 35)
            Item.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
            Item.Text = ""
            Corner(Item, 6)
            
            local Lbl = Instance.new("TextLabel", Item)
            Lbl.Size = UDim2.new(1, -40, 1, 0)
            Lbl.Position = UDim2.new(0, 10, 0, 0)
            Lbl.BackgroundTransparency = 1
            Lbl.Text = text
            Lbl.TextColor3 = Color3.new(1, 1, 1)
            Lbl.Font = Enum.Font.Gotham
            Lbl.TextSize = 11
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
            
            local Check = Instance.new("Frame", Item)
            Check.Size = UDim2.fromOffset(16, 16)
            Check.Position = UDim2.new(1, -30, 0.5, -8)
            Check.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Corner(Check, 4)
            
            Item.MouseButton1Click:Connect(function()
                enabled = not enabled
                elementData.value = enabled
                Tween(Check, 0.2, {BackgroundColor3 = enabled and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(40, 40, 40)})
                callback(enabled)
            end)

            table.insert(ConfigManager.Callbacks, function()
                return {name = text, value = enabled}
            end)
            table.insert(ConfigManager.LoadCallbacks, function(config)
                local data = config[text]
                if data ~= nil then
                    enabled = data
                    Check.BackgroundColor3 = enabled and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(40, 40, 40)
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
            SFrame.Size = UDim2.new(1, -5, 0, 45)
            SFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
            Corner(SFrame, 6)
            
            local Lbl = Instance.new("TextLabel", SFrame)
            Lbl.Size = UDim2.new(1, -20, 0, 20)
            Lbl.Position = UDim2.new(0, 10, 0, 5)
            Lbl.BackgroundTransparency = 1
            Lbl.Text = text .. " : " .. def
            Lbl.TextColor3 = Color3.new(1, 1, 1)
            Lbl.Font = Enum.Font.Gotham
            Lbl.TextSize = 10
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
            
            local Bar = Instance.new("Frame", SFrame)
            Bar.Size = UDim2.new(1, -20, 0, 5)
            Bar.Position = UDim2.new(0, 10, 0, 32)
            Bar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Corner(Bar, 5)
            
            local Fill = Instance.new("Frame", Bar)
            Fill.Size = UDim2.new((def - min) / (max - min), 0, 1, 0)
            Fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
            Corner(Fill, 5)
            
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
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then 
                    sliding = true up(i) 
                end 
            end)
            UIS.InputChanged:Connect(function(i) 
                if sliding and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then up(i) end 
            end)
            UIS.InputEnded:Connect(function() sliding = false end)

            table.insert(ConfigManager.Callbacks, function()
                return {name = text, value = sliderValue}
            end)
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
            Btn.Size = UDim2.new(1, -5, 0, 35)
            Btn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
            Btn.Text = text
            Btn.TextColor3 = Color3.new(1, 1, 1)
            Btn.Font = Enum.Font.GothamBold
            Btn.TextSize = 11
            Corner(Btn, 6)
            
            Btn.MouseButton1Click:Connect(function() callback() end)
        end

        -- LABEL
        function Elements:CreateLabel(text)
            local Lbl = Instance.new("TextLabel", Page)
            Lbl.Size = UDim2.new(1, -5, 0, 25)
            Lbl.BackgroundTransparency = 1
            Lbl.Text = text
            Lbl.TextColor3 = Color3.fromRGB(150, 150, 150)
            Lbl.Font = Enum.Font.Gotham
            Lbl.TextSize = 11
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
        end

        -- INPUT (TextBox)
        function Elements:CreateInput(text, placeholder, callback)
            local elementData = {name = text, value = ""}
            
            local InputFrame = Instance.new("Frame", Page)
            InputFrame.Size = UDim2.new(1, -5, 0, 35)
            InputFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
            Corner(InputFrame, 6)
            
            local Lbl = Instance.new("TextLabel", InputFrame)
            Lbl.Size = UDim2.new(0, 80, 1, 0)
            Lbl.Position = UDim2.new(0, 10, 0, 0)
            Lbl.BackgroundTransparency = 1
            Lbl.Text = text
            Lbl.TextColor3 = Color3.new(1, 1, 1)
            Lbl.Font = Enum.Font.Gotham
            Lbl.TextSize = 10
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
            
            local Input = Instance.new("TextBox", InputFrame)
            Input.Size = UDim2.new(1, -100, 0, 25)
            Input.Position = UDim2.new(0, 85, 0.5, -12)
            Input.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Input.Text = ""
            Input.TextColor3 = Color3.new(1, 1, 1)
            Input.Font = Enum.Font.Gotham
            Input.TextSize = 10
            Input.PlaceholderText = placeholder or ""
            Input.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
            Corner(Input, 4)
            
            Input.FocusLost:Connect(function()
                elementData.value = Input.Text
                callback(Input.Text)
            end)

            table.insert(ConfigManager.Callbacks, function()
                return {name = text, value = Input.Text}
            end)
            table.insert(ConfigManager.LoadCallbacks, function(config)
                local data = config[text]
                if data ~= nil then
                    Input.Text = data
                    elementData.value = data
                    callback(data)
                end
            end)
        end


-- COLOR PICKER
        function Elements:CreateColor(text, default, callback)
            local h, s, v = default:ToHSV()
            local elementData = {name = text, value = {h = h, s = s, v = v}}
            
            local Item = Instance.new("TextButton")
            Item.Parent = Page
            Item.Size = UDim2.new(1, -5, 0, 35)
            Item.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
            Item.Text = ""
            Corner(Item, 6)

            local Lbl = Instance.new("TextLabel", Item)
            Lbl.Size = UDim2.new(1, -50, 1, 0)
            Lbl.Position = UDim2.new(0, 10, 0, 0)
            Lbl.BackgroundTransparency = 1
            Lbl.Text = text
            Lbl.TextColor3 = Color3.new(1, 1, 1)
            Lbl.Font = Enum.Font.Gotham
            Lbl.TextSize = 11
            Lbl.TextXAlignment = Enum.TextXAlignment.Left

            local Box = Instance.new("Frame", Item)
            Box.Size = UDim2.fromOffset(20, 20)
            Box.Position = UDim2.new(1, -35, 0.5, -10)
            Box.BackgroundColor3 = default
            Corner(Box, 4)

            local Picker = Instance.new("Frame")
            Picker.Parent = UI
            Picker.Size = UDim2.fromOffset(190, 230)
            Picker.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            Picker.Visible = false
            Picker.ZIndex = 5000
            Corner(Picker, 10)
            Instance.new("UIStroke", Picker).Color = Color3.fromRGB(45, 45, 45)

            local Sat = Instance.new("ImageLabel", Picker)
            Sat.Size = UDim2.fromOffset(140, 130)
            Sat.Position = UDim2.fromOffset(10, 10)
            Sat.Image = "rbxassetid://4155801252"
            Sat.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
            Corner(Sat, 4)

            local Hue = Instance.new("ImageLabel", Picker)
            Hue.Size = UDim2.fromOffset(20, 130)
            Hue.Position = UDim2.fromOffset(160, 10)
            Hue.Image = "rbxassetid://3641079629"
            Corner(Hue, 4)

            local Input = Instance.new("TextBox", Picker)
            Input.Size = UDim2.new(0, 170, 0, 30)
            Input.Position = UDim2.new(0, 10, 0, 150)
            Input.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Input.Text = "255, 255, 255"
            Input.TextColor3 = Color3.new(1, 1, 1)
            Input.Font = Enum.Font.Gotham
            Input.TextSize = 10
            Corner(Input, 4)

            local Apply = Instance.new("TextButton", Picker)
            Apply.Size = UDim2.new(0, 170, 0, 30)
            Apply.Position = UDim2.new(0, 10, 0, 190)
            Apply.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
            Apply.Text = "APPLY"
            Apply.TextColor3 = Color3.new(1, 1, 1)
            Apply.Font = Enum.Font.GothamBold
            Apply.TextSize = 11
            Corner(Apply, 4)

            local function update()
                local color = Color3.fromHSV(h, s, v)
                Box.BackgroundColor3 = color
                Sat.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                Input.Text = math.floor(color.R*255)..", "..math.floor(color.G*255)..", "..math.floor(color.B*255)
                elementData.value = {h = h, s = s, v = v}
                callback(color)
            end

            local function openPicker()
                Picker.Position = UDim2.fromOffset(
                    math.clamp(Item.AbsolutePosition.X + 270, 0, 1920 - 190),
                    math.clamp(Item.AbsolutePosition.Y - 180, 0, 1080 - 230)
                )
                Picker.Visible = not Picker.Visible
                IsPickerOpen = Picker.Visible
                CameraBlocker.Visible = IsPickerOpen
                if IsPickerOpen then update() end
            end

            Item.MouseButton1Click:Connect(function()
                if not IsPickerOpen then openPicker() end
            end)

            Apply.MouseButton1Click:Connect(function()
                pcall(function()
                    local r, g, b = Input.Text:match("(%d+),%s*(%d+),%s*(%d+)")
                    if r then
                        local nc = Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b))
                        h, s, v = nc:ToHSV()
                        update()
                    end
                end)
                Picker.Visible = false
                IsPickerOpen = false
                CameraBlocker.Visible = false
            end)

            local psat, phue = false, false
            Sat.InputBegan:Connect(function(i) 
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then psat = true end 
            end)
            Hue.InputBegan:Connect(function(i) 
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then phue = true end 
            end)
            
            UIS.InputChanged:Connect(function(i)
                if IsPickerOpen and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                    if psat then
                        s = math.clamp((i.Position.X - Sat.AbsolutePosition.X) / Sat.AbsoluteSize.X, 0, 1)
                        v = 1 - math.clamp((i.Position.Y - Sat.AbsolutePosition.Y - 36) / Sat.AbsoluteSize.Y, 0, 1)
                        update()
                    elseif phue then
                        h = 1 - math.clamp((i.Position.Y - Hue.AbsolutePosition.Y - 36) / Hue.AbsoluteSize.Y, 0, 1)
                        update()
                    end
                end
            end)
            
            UIS.InputEnded:Connect(function() psat = false; phue = false end)

            UIS.InputBegan:Connect(function(input)
                if IsPickerOpen and Picker.Visible then
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        local pos = input.Position
                        local pp = Picker.AbsolutePosition
                        local ps = Picker.AbsoluteSize
                        if pos.X < pp.X or pos.X > pp.X + ps.X or pos.Y < pp.Y or pos.Y > pp.Y + ps.Y then
                            Picker.Visible = false
                            IsPickerOpen = false
                            CameraBlocker.Visible = false
                        end
                    end
                end
            end)

            table.insert(ConfigManager.Callbacks, function()
                return {name = text, value = elementData.value}
            end)
            table.insert(ConfigManager.LoadCallbacks, function(config)
                local data = config[text]
                if data then h, s, v = data.h, data.s, data.v; update() end
            end)
        end
        -- DROPDOWN
        function Elements:CreateDropdown(text, list, callback)
            local selected = list[1] or ""
            
            local DropFrame = Instance.new("Frame", Page)
            DropFrame.Size = UDim2.new(1, -5, 0, 35)
            DropFrame.BackgroundTransparency = 1
            
            local DropBtn = Instance.new("TextButton", DropFrame)
            DropBtn.Size = UDim2.new(1, 0, 0, 35)
            DropBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
            DropBtn.Text = "▼  " .. tostring(selected)
            DropBtn.TextColor3 = Color3.new(1, 1, 1)
            DropBtn.Font = Enum.Font.GothamMedium
            DropBtn.TextSize = 10
            DropBtn.TextXAlignment = Enum.TextXAlignment.Left
            Corner(DropBtn, 6)
            
            local Arrow = Instance.new("TextLabel", DropBtn)
            Arrow.Size = UDim2.fromOffset(20, 20)
            Arrow.Position = UDim2.new(1, -25, 0.5, -10)
            Arrow.BackgroundTransparency = 1
            Arrow.Text = "▼"
            Arrow.TextColor3 = Color3.fromRGB(0, 150, 255)
            Arrow.Font = Enum.Font.GothamBold
            Arrow.TextSize = 14
            
            local DropList = Instance.new("Frame")
            DropList.Parent = UI
            DropList.Size = UDim2.fromOffset(250, 0)
            DropList.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            DropList.Visible = false
            DropList.ZIndex = 6000
            Corner(DropList, 8)
            Instance.new("UIStroke", DropList).Color = Color3.fromRGB(0, 150, 255)
            Instance.new("UIStroke", DropList).Thickness = 1.5
            
            local ScrollFrame = Instance.new("ScrollingFrame", DropList)
            ScrollFrame.Size = UDim2.new(1, -10, 1, -10)
            ScrollFrame.Position = UDim2.new(0, 5, 0, 5)
            ScrollFrame.BackgroundTransparency = 1
            ScrollFrame.ScrollBarThickness = 3
            ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
            ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
            ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
            
            local ListLayout = Instance.new("UIListLayout", ScrollFrame)
            ListLayout.Padding = UDim.new(0, 3)
            
            local dropOpen = false
            
            local function updateList()
                for _, v in pairs(ScrollFrame:GetChildren()) do
                    if v:IsA("TextButton") then v:Destroy() end
                end
                
                for _, item in pairs(list) do
                    local ItemBtn = Instance.new("TextButton", ScrollFrame)
                    ItemBtn.Size = UDim2.new(1, 0, 0, 28)
                    ItemBtn.BackgroundColor3 = selected == item and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(30, 30, 30)
                    ItemBtn.Text = "  " .. tostring(item)
                    ItemBtn.TextColor3 = Color3.new(1, 1, 1)
                    ItemBtn.Font = Enum.Font.Gotham
                    ItemBtn.TextSize = 10
                    ItemBtn.TextXAlignment = Enum.TextXAlignment.Left
                    Corner(ItemBtn, 5)
                    
                    ItemBtn.MouseButton1Click:Connect(function()
                        selected = item
                        DropBtn.Text = "▼  " .. tostring(selected)
                        DropList.Visible = false
                        dropOpen = false
                        Arrow.Rotation = 0
                        callback(selected)
                        updateList()
                    end)
                end
                
                DropList.Size = UDim2.fromOffset(250, math.min(#list * 31 + 10, 200))
            end
            
            DropBtn.MouseButton1Click:Connect(function()
                dropOpen = not dropOpen
                DropList.Position = UDim2.fromOffset(DropBtn.AbsolutePosition.X, DropBtn.AbsolutePosition.Y + 35)
                DropList.Visible = dropOpen
                Arrow.Rotation = dropOpen and 180 or 0
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
                        Arrow.Rotation = 0
                    end
                end
            end)
            
            local dropdownController = {}
            function dropdownController.SetValue(value)
                selected = value
                DropBtn.Text = "▼  " .. tostring(selected)
                callback(selected)
                updateList()
            end
            function dropdownController.GetValue()
                return selected
            end
            function dropdownController.Destroy()
                DropFrame:Destroy()
                DropList:Destroy()
            end
            
            return dropdownController
        end

        -- CREATE CONFIG SYSTEM
        function Elements:CreateConfigSystem()
            local configDropdown = nil
            local lastLoaded = ConfigManager.CurrentConfig
            
            local function getConfigList()
                local configs = {}
                for name, _ in pairs(ConfigManager:GetConfigs()) do
                    table.insert(configs, name)
                end
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
            
            Elements:CreateLabel("Config Manager")
            
            Elements:CreateButton("Save Config", function()
                local inputFrame = Instance.new("Frame")
                inputFrame.Parent = UI
                inputFrame.Size = UDim2.fromOffset(250, 100)
                inputFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                inputFrame.Position = UDim2.new(0.5, -125, 0.5, -50)
                inputFrame.ZIndex = 7000
                Corner(inputFrame, 8)
                Instance.new("UIStroke", inputFrame).Color = Color3.fromRGB(45, 45, 45)
                
                local title = Instance.new("TextLabel", inputFrame)
                title.Size = UDim2.new(1, 0, 0, 25)
                title.BackgroundTransparency = 1
                title.Text = "Save Config"
                title.TextColor3 = Color3.new(1, 1, 1)
                title.Font = Enum.Font.GothamBold
                title.TextSize = 12
                
                local input = Instance.new("TextBox", inputFrame)
                input.Size = UDim2.new(1, -20, 0, 30)
                input.Position = UDim2.new(0, 10, 0, 30)
                input.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                input.Text = ""
                input.TextColor3 = Color3.new(1, 1, 1)
                input.Font = Enum.Font.Gotham
                input.TextSize = 11
                input.PlaceholderText = "Config name..."
                input.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
                Corner(input, 4)
                
                local confirm = Instance.new("TextButton", inputFrame)
                confirm.Size = UDim2.new(1, -20, 0, 25)
                confirm.Position = UDim2.new(0, 10, 0, 65)
                confirm.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
                confirm.Text = "SAVE"
                confirm.TextColor3 = Color3.new(1, 1, 1)
                confirm.Font = Enum.Font.GothamBold
                confirm.TextSize = 11
                Corner(confirm, 4)
                
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
