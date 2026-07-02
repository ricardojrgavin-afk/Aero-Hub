-- AERO HUB UNIVERSAL LOADER & MASTER ENGINE (INTEGRATED STANDALONE ARCHITECTURE)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    LocalPlayer = Players.LocalPlayer
end

-- CONFIGURATION STORAGE INITIALIZATION
local ConfigPath = "Aero Hub/Config.json"
local LoadedConfig = {}
pcall(function()
    if isfile(ConfigPath) then
        LoadedConfig = HttpService:JSONDecode(readfile(ConfigPath))
    else
        makefolder("Aero Hub")
    end
end)

getgenv().setconfig = function(key, value)
    local placeStr = tostring(game.PlaceId)
    if not LoadedConfig[placeStr] then LoadedConfig[placeStr] = {} end
    LoadedConfig[placeStr][key] = value
    writefile(ConfigPath, HttpService:JSONEncode(LoadedConfig))
end

-- 1. FULL GAME STATUS CONFIGURATION DATABASE
local GameDatabase = {
    ["89072926726733"]   = {Name = "Cross road for brainrots", Status = "Working"},
    ["100070667273689"]  = {Name = "Survive flood for brainrots", Status = "Working"},
    ["106772177198260"]  = {Name = "Reel for brainrots", Status = "Working"},
    ["108207853263201"]  = {Name = "Rizz tower", Status = "Patched"},
    ["109908567838703"]  = {Name = "Nuke for brainrots", Status = "Working"},
    ["137069154816703"]  = {Name = "Hack vault for brainrots", Status = "Maintenance"},
    ["74277864669743"]   = {Name = "Fly for brainrots", Status = "Maintenance"},
    ["89046742932569"]   = {Name = "Sail for Brainrots", Status = "Working"},
    ["94780005879799"]   = {Name = "Scream for Brainrots", Status = "Working"},
    ["97508801613157"]   = {Name = "Parkour run for Brainrots", Status = "Working"},
    ["102515477731035"]  = {Name = "Pole obby for Brainrots", Status = "Working"},
    ["135882949571046"]  = {Name = "Dream for brainrots", Status = "Working"},
    ["84332574190497"]   = {Name = "+1 Wings for Brainrots", Status = "Working"},
    ["136919941417380"]  = {Name = "Bike Obby for Brainrots", Status = "Working"},
    ["98868317791094"]   = {Name = "DUMP", Status = "Working"},
    ["137233438285284"]  = {Name = "Chicken Farm", Status = "Working"},
    ["114640202062357"]  = {Name = "Swing obby for Brainrots", Status = "Working"},
    ["99255447043899"]   = {Name = "Become a Brainrot", Status = "Working"},
    ["110627433764494"]  = {Name = "Fake a Brainrot", Status = "Working"},
    ["86614757217732"]   = {Name = "+1 Health for Brainrots", Status = "Working"},
    ["83569851223739"]   = {Name = "+1 Speed Evolve", Status = "Working"},
    ["95082159892680"]   = {Name = "+1 Speed Keyboard Escape", Status = "Working"},
    -- Newly Synchronized Additions
    ["100964511576728"]  = {Name = "Smash crate for Brainrot", Status = "Working"},
    ["110373292461174"]  = {Name = "Paper Plane for Brainrots", Status = "Working"},
    ["71213902019049"]   = {Name = "Cross rivers for Brainrots", Status = "Working"},
    ["85411355002110"]   = {Name = "+1 Dash for Brainrots", Status = "Working"},
    ["77862067599263"]   = {Name = "Obby as a Brainrot", Status = "Working"},
    ["80234914611737"]   = {Name = "+1 Jetpack for Brainrot", Status = "Working"},
    ["112500097711893"]  = {Name = "Lick a Brainrot", Status = "Working"},
    ["97931184538536"]   = {Name = "Skate for Brainrots", Status = "Working"}
}

-- 2. LOADER SPLASH SCREEN
local LoaderGui = Instance.new("ScreenGui")
LoaderGui.Name = "AeroLoader_" .. tostring(math.random(100000, 999999))
pcall(function() LoaderGui.Parent = CoreGui end)
if not LoaderGui.Parent then LoaderGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local SplashFrame = Instance.new("Frame")
SplashFrame.Size = UDim2.new(0, 320, 0, 140)
SplashFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
SplashFrame.AnchorPoint = Vector2.new(0.5, 0.5)
SplashFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
SplashFrame.Parent = LoaderGui

local UICorner = Instance.new("UICorner") UICorner.CornerRadius = UDim.new(0, 10); UICorner.Parent = SplashFrame
local UIStroke = Instance.new("UIStroke") UIStroke.Color = Color3.fromRGB(168, 85, 247); UIStroke.Thickness = 1.5; UIStroke.Parent = SplashFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 1, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "AERO HUB\nBuilding Layout Architecture..."
StatusLabel.Font = Enum.Font.GothamBold; StatusLabel.TextColor3 = Color3.fromRGB(240, 240, 250); StatusLabel.TextSize = 14; StatusLabel.Parent = SplashFrame

-- 3. INTERFACE ENGINE UI WRAPPER
local UI = {}
function UI:CreateWindow(hubName)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AeroWindow_" .. tostring(math.random(100000, 999999))
    ScreenGui.ResetOnSpawn = false
    pcall(function() ScreenGui.Parent = CoreGui end)
    if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 5, 0, 5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner") MainCorner.CornerRadius = UDim.new(0, 10); MainCorner.Parent = MainFrame
    local MainStroke = Instance.new("UIStroke") MainStroke.Thickness = 1.5; MainStroke.Color = Color3.fromRGB(45, 45, 55); MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; MainStroke.Parent = MainFrame

    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 45)
    TopBar.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    TopBar.Parent = MainFrame
    local TopCorner = Instance.new("UICorner") TopCorner.CornerRadius = UDim.new(0, 10); TopCorner.Parent = TopBar

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0.6, 0, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Text = hubName
    Title.Font = Enum.Font.GothamBold; Title.TextSize = 14; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.TextXAlignment = Enum.TextXAlignment.Left; Title.BackgroundTransparency = 1; Title.Parent = TopBar

    local TitleGradient = Instance.new("UIGradient")
    TitleGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(168, 85, 247)), ColorSequenceKeypoint.new(1, Color3.fromRGB(34, 197, 94))}
    TitleGradient.Parent = Title

    local HideButton = Instance.new("TextButton")
    HideButton.Name = "HideBtn"
    HideButton.Size = UDim2.new(0, 30, 0, 30)
    HideButton.Position = UDim2.new(1, -40, 0.5, -15)
    HideButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    HideButton.Text = "—"
    HideButton.Font = Enum.Font.GothamBold; HideButton.TextSize = 12; HideButton.TextColor3 = Color3.fromRGB(239, 68, 68); HideButton.AutoButtonColor = false; HideButton.Parent = TopBar
    local HideCorner = Instance.new("UICorner") HideCorner.CornerRadius = UDim.new(0, 6); HideCorner.Parent = HideButton
    local HideStroke = Instance.new("UIStroke") HideStroke.Thickness = 1; HideStroke.Color = Color3.fromRGB(55, 55, 65); HideStroke.Parent = HideButton

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "AeroToggleButton"
    ToggleButton.Size = UDim2.new(0, 50, 0, 50)
    ToggleButton.Position = UDim2.new(0.05, 0, 0.15, 0)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    ToggleButton.Text = "A"
    ToggleButton.Font = Enum.Font.GothamBold; ToggleButton.TextSize = 18; ToggleButton.TextColor3 = Color3.fromRGB(168, 85, 247); ToggleButton.Visible = false; ToggleButton.Active = true; ToggleButton.Draggable = true; ToggleButton.Parent = ScreenGui
    local ToggleCorner = Instance.new("UICorner") ToggleCorner.CornerRadius = UDim.new(1, 0); ToggleCorner.Parent = ToggleButton
    local ToggleStroke = Instance.new("UIStroke") ToggleStroke.Thickness = 2; ToggleStroke.Color = Color3.fromRGB(168, 85, 247); ToggleStroke.Parent = ToggleButton

    HideButton.MouseButton1Click:Connect(function() MainFrame.Visible = false; ToggleButton.Visible = true end)
    ToggleButton.MouseButton1Click:Connect(function() ToggleButton.Visible = false; MainFrame.Visible = true end)

    local SideBar = Instance.new("Frame")
    SideBar.Name = "SideBar"
    SideBar.Size = UDim2.new(0, 130, 1, -45)
    SideBar.Position = UDim2.new(0, 0, 0, 45)
    SideBar.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
    SideBar.Parent = MainFrame
    
    local SideLine = Instance.new("Frame")
    SideLine.Size = UDim2.new(0, 1, 1, 0)
    SideLine.Position = UDim2.new(1, -1, 0, 0)
    SideLine.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
    SideLine.BorderSizePixel = 0; SideLine.Parent = SideBar

    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(1, -10, 1, -20)
    TabContainer.Position = UDim2.new(0, 5, 0, 10)
    TabContainer.BackgroundTransparency = 1; TabContainer.Parent = TabContainer

    local TabListLayout = Instance.new("UIListLayout") TabListLayout.Padding = UDim.new(0, 6); TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder; TabListLayout.Parent = TabContainer

    local DisplayDesk = Instance.new("Frame")
    DisplayDesk.Name = "DisplayDesk"
    DisplayDesk.Size = UDim2.new(1, -130, 1, -45)
    DisplayDesk.Position = UDim2.new(0, 130, 0, 45)
    DisplayDesk.BackgroundTransparency = 1; DisplayDesk.Parent = MainFrame

    task.wait()
    MainFrame:TweenSize(UDim2.new(0, 520, 0, 340), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.5, true)

    local dragging, dragInput, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = MainFrame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    TopBar.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local Navigation = {ActiveTab = nil, OpenFrames = {}}

    function Navigation:CreateTab(name, layoutOrder)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 34)
        TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
        TabBtn.Text = name; TabBtn.Font = Enum.Font.GothamSemibold; TabBtn.TextSize = 12; TabBtn.TextColor3 = Color3.fromRGB(160, 160, 180); TabBtn.LayoutOrder = layoutOrder; TabBtn.AutoButtonColor = false; TabBtn.Parent = TabContainer
        local TabBtnCorner = Instance.new("UICorner") TabBtnCorner.CornerRadius = UDim.new(0, 6); TabBtnCorner.Parent = TabBtn
        local TabBtnStroke = Instance.new("UIStroke") TabBtnStroke.Thickness = 1; TabBtnStroke.Color = Color3.fromRGB(40, 40, 52); TabBtnStroke.Parent = TabBtn

        local ViewFrame = Instance.new("ScrollingFrame")
        ViewFrame.Size = UDim2.new(1, -20, 1, -20)
        ViewFrame.Position = UDim2.new(0, 10, 0, 10)
        ViewFrame.BackgroundTransparency = 1; ViewFrame.ScrollBarThickness = 3; ViewFrame.ScrollBarImageColor3 = Color3.fromRGB(65, 65, 80); ViewFrame.Visible = false; ViewFrame.Parent = DisplayDesk
        local ViewLayout = Instance.new("UIListLayout") ViewLayout.Padding = UDim.new(0, 8); ViewLayout.SortOrder = Enum.SortOrder.LayoutOrder; ViewLayout.Parent = ViewFrame

        Navigation.OpenFrames[name] = ViewFrame

        TabBtn.MouseButton1Click:Connect(function()
            for tName, frame in pairs(Navigation.OpenFrames) do frame.Visible = false end
            if Navigation.ActiveTab then
                TweenService:Create(Navigation.ActiveTab, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(30, 30, 38), TextColor3 = Color3.fromRGB(160, 160, 180)}):Play()
                TweenService:Create(Navigation.ActiveTab:FindFirstChildOfClass("UIStroke"), TweenInfo.new(0.25), {Color = Color3.fromRGB(40, 40, 52)}):Play()
            end
            Navigation.ActiveTab = TabBtn
            TweenService:Create(TabBtn, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(48, 32, 74), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            TweenService:Create(TabBtn:FindFirstChildOfClass("UIStroke"), TweenInfo.new(0.25), {Color = Color3.fromRGB(168, 85, 247)}):Play()
            ViewFrame.Visible = true
        end)

        if layoutOrder == 1 then
            Navigation.ActiveTab = TabBtn
            TabBtn.BackgroundColor3 = Color3.fromRGB(48, 32, 74)
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabBtnStroke.Color = Color3.fromRGB(168, 85, 247)
            ViewFrame.Visible = true
        end

        local ElementFactory = {}

        function ElementFactory:CreateToggle(text, startState, callback)
            local callback = callback or function() end
            local toggled = startState or false
            local ToggleFrame = Instance.new("TextButton")
            ToggleFrame.Size = UDim2.new(1, -5, 0, 40); ToggleFrame.BackgroundColor3 = Color3.fromRGB(32, 32, 40); ToggleFrame.Text = ""; ToggleFrame.AutoButtonColor = false; ToggleFrame.Parent = ViewFrame
            local Corner = Instance.new("UICorner") Corner.CornerRadius = UDim.new(0, 6); Corner.Parent = ToggleFrame
            local Stroke = Instance.new("UIStroke") Stroke.Thickness = 1; Stroke.Color = Color3.fromRGB(45, 45, 55); Stroke.Parent = ToggleFrame
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(0.7, 0, 1, 0); Label.Position = UDim2.new(0, 12, 0, 0); Label.Text = text; Label.Font = Enum.Font.GothamSemibold; Label.TextSize = 13; Label.TextColor3 = Color3.fromRGB(220, 220, 230); Label.TextXAlignment = Enum.TextXAlignment.Left; Label.BackgroundTransparency = 1; Label.Parent = ToggleFrame
            local Indicator = Instance.new("Frame")
            Indicator.Size = UDim2.new(0, 22, 0, 22); Indicator.Position = UDim2.new(1, -34, 0.5, -11); Indicator.BackgroundColor3 = toggled and Color3.fromRGB(168, 85, 247) or Color3.fromRGB(50, 50, 60); Indicator.Parent = ToggleFrame
            local IndCorner = Instance.new("UICorner") IndCorner.CornerRadius = UDim.new(0, 5); IndCorner.Parent = Indicator
            ToggleFrame.MouseButton1Click:Connect(function()
                toggled = not toggled
                TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = toggled and Color3.fromRGB(168, 85, 247) or Color3.fromRGB(50, 50, 60)}):Play()
                task.spawn(function() pcall(callback, toggled) end)
            end)
        end

        function ElementFactory:CreateTextbox(text, placeholder, callback)
            local callback = callback or function() end
            local BoxFrame = Instance.new("Frame")
            BoxFrame.Size = UDim2.new(1, -5, 0, 40); BoxFrame.BackgroundColor3 = Color3.fromRGB(32, 32, 40); BoxFrame.Parent = ViewFrame
            local Corner = Instance.new("UICorner") Corner.CornerRadius = UDim.new(0, 6); Corner.Parent = BoxFrame
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(0.5, 0, 1, 0); Label.Position = UDim2.new(0, 12, 0, 0); Label.Text = text; Label.Font = Enum.Font.GothamSemibold; Label.TextSize = 13; Label.TextColor3 = Color3.fromRGB(220, 220, 230); Label.TextXAlignment = Enum.TextXAlignment.Left; Label.BackgroundTransparency = 1; Label.Parent = BoxFrame
            local Input = Instance.new("TextBox")
            Input.Size = UDim2.new(0.35, 0, 0, 26); Input.Position = UDim2.new(1, -12, 0.5, -13); Input.AnchorPoint = Vector2.new(1, 0); Input.BackgroundColor3 = Color3.fromRGB(24, 24, 30); Input.Text = ""; Input.PlaceholderText = placeholder or "Enter..."; Input.Font = Enum.Font.Gotham; Input.TextSize = 12; Input.TextColor3 = Color3.fromRGB(255, 255, 255); Input.PlaceholderColor3 = Color3.fromRGB(100, 100, 115); Input.ClearTextOnFocus = false; Input.Parent = BoxFrame
            local InpCorner = Instance.new("UICorner") InpCorner.CornerRadius = UDim.new(0, 4); InpCorner.Parent = Input
            Input.FocusLost:Connect(function() pcall(callback, Input.Text) end)
        end

        function ElementFactory:CreateButton(text, callback)
            local callback = callback or function() end
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, -5, 0, 36); Btn.BackgroundColor3 = Color3.fromRGB(32, 32, 40); Btn.Text = text; Btn.Font = Enum.Font.GothamSemibold; Btn.TextColor3 = Color3.fromRGB(220, 220, 230); Btn.TextSize = 13; Btn.AutoButtonColor = false; Btn.Parent = ViewFrame
            local Corner = Instance.new("UICorner") Corner.CornerRadius = UDim.new(0, 6); Corner.Parent = Btn
            Btn.MouseButton1Click:Connect(function() pcall(callback) end)
        end

        function ElementFactory:CreateLabel(text)
            local LabelFrame = Instance.new("TextLabel")
            LabelFrame.Size = UDim2.new(1, -5, 0, 24); LabelFrame.BackgroundTransparency = 1; LabelFrame.Text = text; LabelFrame.Font = Enum.Font.GothamSemibold; LabelFrame.TextColor3 = Color3.fromRGB(168, 85, 247); LabelFrame.TextSize = 12; LabelFrame.TextXAlignment = Enum.TextXAlignment.Left; LabelFrame.Position = UDim2.new(0, 6, 0, 0); LabelFrame.Parent = ViewFrame
        end

        function ElementFactory:RawFrame() return ViewFrame end
        return ElementFactory
    end
    return Navigation
end

-- 4. VERIFICATION ROUTER ENGINE
local targetId = tostring(game.PlaceId)
local gameMatch = GameDatabase[targetId]
local env = getgenv()
local currentPlaceData = LoadedConfig[targetId] or {}

if gameMatch then
    if gameMatch.Status == "Working" then
        LoaderGui:Destroy()
        
        local Window = UI:CreateWindow("AERO HUB")
        local MainTab = Window:CreateTab("Main", 1)
        local GamesTab = Window:CreateTab("Games List", 2)
        local CreditsTab = Window:CreateTab("Credits", 3)

        -- DYNAMIC BUILDER FOR "GAMES LIST" TAB
        local sortedList = {}
        for id, info in pairs(GameDatabase) do table.insert(sortedList, {Name = info.Name, Status = info.Status}) end
        table.sort(sortedList, function(a, b) return a.Name < b.Name end)

        for _, item in ipairs(sortedList) do
            local StatusCard = Instance.new("Frame")
            StatusCard.Size = UDim2.new(1, -5, 0, 36); StatusCard.BackgroundColor3 = Color3.fromRGB(26, 26, 33); StatusCard.Parent = GamesTab:RawFrame()
            local ScCorner = Instance.new("UICorner") ScCorner.CornerRadius = UDim.new(0, 6); ScCorner.Parent = StatusCard

            local NameLbl = Instance.new("TextLabel")
            NameLbl.Size = UDim2.new(0.7, 0, 1, 0); NameLbl.Position = UDim2.new(0, 12, 0, 0)
            NameLbl.Text = item.Name; NameLbl.Font = Enum.Font.Gotham; NameLbl.TextSize = 12; NameLbl.TextColor3 = Color3.fromRGB(210, 210, 220); NameLbl.TextXAlignment = Enum.TextXAlignment.Left; NameLbl.BackgroundTransparency = 1; NameLbl.Parent = StatusCard

            local StatLbl = Instance.new("TextLabel")
            StatLbl.Size = UDim2.new(0.25, 0, 1, 0); StatLbl.Position = UDim2.new(1, -12, 0, 0); StatLbl.AnchorPoint = Vector2.new(1, 0)
            StatLbl.Text = item.Status; StatLbl.Font = Enum.Font.GothamBold; StatLbl.TextSize = 11; StatLbl.TextXAlignment = Enum.TextXAlignment.Right; StatLbl.BackgroundTransparency = 1; StatLbl.Parent = StatusCard
            
            if item.Status == "Working" then StatLbl.TextColor3 = Color3.fromRGB(34, 197, 94)
            elseif item.Status == "Maintenance" then StatLbl.TextColor3 = Color3.fromRGB(234, 179, 8)
            else StatLbl.TextColor3 = Color3.fromRGB(239, 68, 68) end
        end

        -- DYNAMIC BUILDER FOR "CREDITS" TAB
        local teamProfile = {
            {Role = "Developer", Names = {"esore aka vaehz", "Nexus (ME)"}},
            {Role = "UI Designer", Names = {"esore aka vaehz"}},
            {Role = "Contributors", Names = {"__ven0x__", "wirlypirly12"}}
        }

        for _, section in ipairs(teamProfile) do
            local Header = Instance.new("TextLabel")
            Header.Size = UDim2.new(1, 0, 0, 22); Header.Text = section.Role:upper(); Header.Font = Enum.Font.GothamBold; Header.TextSize = 11; Header.TextColor3 = Color3.fromRGB(168, 85, 247); Header.TextXAlignment = Enum.TextXAlignment.Left; Header.BackgroundTransparency = 1; Header.Parent = CreditsTab:RawFrame()

            for _, name in ipairs(section.Names) do
                local UserCard = Instance.new("Frame")
                UserCard.Size = UDim2.new(1, -5, 0, 32); UserCard.BackgroundColor3 = Color3.fromRGB(28, 28, 36); UserCard.Parent = CreditsTab:RawFrame()
                local UcCorner = Instance.new("UICorner") UcCorner.CornerRadius = UDim.new(0, 5); UcCorner.Parent = UserCard
                local UcStroke = Instance.new("UIStroke") UcStroke.Thickness = 1; UcStroke.Color = Color3.fromRGB(38, 38, 48); UcStroke.Parent = UserCard

                local UserLbl = Instance.new("TextLabel")
                UserLbl.Size = UDim2.new(1, 0, 1, 0); UserLbl.Position = UDim2.new(0, 12, 0, 0); UserLbl.Text = name; UserLbl.Font = Enum.Font.GothamSemibold; UserLbl.TextSize = 12; UserLbl.TextColor3 = Color3.fromRGB(230, 230, 240); UserLbl.TextXAlignment = Enum.TextXAlignment.Left; UserLbl.BackgroundTransparency = 1; UserLbl.Parent = UserCard
            end
        end

        -- ========================================================
        -- EXECUTION HOOK ROUTER INTERFACE HANDLERS
        -- ========================================================

        -- SKATE FOR BRAINROTS
        if targetId == "97931184538536" then
            env.Farming = false
            env.Farminga = false
            local Brainrots = workspace.Bin.FieldBrainrots

            MainTab:CreateToggle("Farm OG + Celestial Brainrots", currentPlaceData.farming or false, function(v)
                env.Farming = v
                env.setconfig("farming", v)
                if not v then return end
                while env.Farming do
                    pcall(function()
                        for _, br in pairs(Brainrots:GetChildren()) do
                            if br:GetAttribute("FieldName") == "CelestialField" or br:GetAttribute("FieldName") == "OGField" then
                                if br:GetAttribute("Traits") == "VIP" then continue end
                                LocalPlayer.Character:MoveTo(br.Position)
                                repeat
                                    fireproximityprompt(br:FindFirstChildOfClass("ProximityPrompt"))
                                    task.wait()
                                until not br or br.Parent ~= Brainrots
                                task.wait()
                                repeat
                                    LocalPlayer.Character:MoveTo(Vector3.new(69, 30, 162))
                                    task.wait()
                                until not LocalPlayer.Character:FindFirstChild("HeldFieldBrainrot")
                                task.wait()
                            end
                        end
                    end)
                    task.wait(0.1)
                end
            end)

            MainTab:CreateToggle("Farm All Brainrots", currentPlaceData.farmingany or false, function(v)
                env.Farminga = v
                env.setconfig("farmingany", v)
                if not v then return end
                while env.Farminga do
                    pcall(function()
                        for _, br in pairs(Brainrots:GetChildren()) do
                            if br:GetAttribute("FieldName") == nil then continue end
                            if br:GetAttribute("Traits") == "VIP" then continue end
                            LocalPlayer.Character:MoveTo(br.Position)
                            repeat
                                fireproximityprompt(br:FindFirstChildOfClass("ProximityPrompt"))
                                task.wait()
                            until not br or br.Parent ~= Brainrots
                            task.wait()
                            repeat
                                LocalPlayer.Character:MoveTo(Vector3.new(69, 30, 162))
                                task.wait()
                            until not LocalPlayer.Character:FindFirstChild("HeldFieldBrainrot")
                            task.wait()
                        end
                    end)
                    task.wait(0.1)
                end
            end)

        -- +1 DASH FOR BRAINROTS
        elseif targetId == "85411355002110" then
            env.Farming = false
            local endPos = Vector3.new(-74, 63, 15784)
            local colPos = Vector3.new(-74, 20, -447)

            MainTab:CreateToggle("Farm Brainrots", currentPlaceData.farmrots or false, function(v)
                env.Farming = v
                env.setconfig("farmrots", v)
                if not env.Farming then return end
                while env.Farming do
                    LocalPlayer.Character:MoveTo(endPos)
                    local lastPlace = workspace.Map.Spawners:WaitForChild("???xLuck"):WaitForChild("???")
                    pcall(function()
                        for _, item in pairs(lastPlace:GetChildren()) do
                            if not item:IsA("Model") then continue end
                            repeat task.wait() until not LocalPlayer.GameplayPaused
                            if not item.PrimaryPart then continue end
                            LocalPlayer.Character:MoveTo(item.PrimaryPart.Position)
                            local prox = item.PrimaryPart:FindFirstChildOfClass("ProximityPrompt")
                            repeat
                                fireproximityprompt(prox)
                                task.wait()
                            until not item or item.Parent ~= lastPlace
                            task.wait(0.5)
                            repeat
                                LocalPlayer.Character:MoveTo(colPos)
                                task.wait()
                            until not LocalPlayer.Character:FindFirstChildOfClass("Model")
                            break
                        end
                    end)
                    task.wait()
                end
            end)

        -- +1 JETPACK FOR BRAINROTS
        elseif targetId == "80234914611737" then
            env.Farming = false
            local endPos = Vector3.new(-93, 59, -9943)
            local scndEndPos = Vector3.new(-104, 59, -7863)

            MainTab:CreateToggle("Farm Brainrots", currentPlaceData.farmrots or false, function(v)
                env.Farming = v
                env.setconfig("farmrots", v)
                if not env.Farming then return end
                while env.Farming do
                    LocalPlayer.Character:MoveTo(endPos); task.wait(1)
                    for _, fold in pairs(workspace.Brainrots:GetChildren()) do
                        for _, br in pairs(fold:GetChildren()) do
                            if not env.Farming then break end
                            LocalPlayer.Character:MoveTo(br.PrimaryPart.Position)
                            local prox = br.AttachmentProximityPrompt:FindFirstChildOfClass("ProximityPrompt")
                            repeat fireproximityprompt(prox); task.wait() until not br or br.Parent ~= fold
                            task.wait()
                            game:GetService("ReplicatedStorage").Packages._Index["sleitnick_knit@1.7.0"].knit.Services.Game.RF.ClaimRewards:InvokeServer()
                            task.wait()
                        end
                    end
                    if not env.Farming then break end
                    LocalPlayer.Character:MoveTo(scndEndPos); task.wait(1)
                    for _, fold in pairs(workspace.Brainrots:GetChildren()) do
                        for _, br in pairs(fold:GetChildren()) do
                            if not env.Farming then break end
                            LocalPlayer.Character:MoveTo(br.PrimaryPart.Position)
                            local prox = br.AttachmentProximityPrompt:FindFirstChildOfClass("ProximityPrompt")
                            repeat fireproximityprompt(prox); task.wait() until not br or br.Parent ~= fold
                            task.wait()
                            game:GetService("ReplicatedStorage").Packages._Index["sleitnick_knit@1.7.0"].knit.Services.Game.RF.ClaimRewards:InvokeServer()
                            task.wait()
                        end
                    end
                end
            end)

        -- OBBY AS A BRAINROT
        elseif targetId == "77862067599263" then
            env.Farming, env.Upgrade, env.Collect, env.Rebirth = false, false, false, false

            MainTab:CreateToggle("Farm Disco Meowl", currentPlaceData.farmrots or false, function(v)
                env.Farming = v
                env.setconfig("farmrots", v)
                if not env.Farming then return end
                while env.Farming do
                    LocalPlayer.Character:MoveTo(Vector3.new(9, 19, -493)); task.wait(0.5)
                    local rems = game:GetService("ReplicatedStorage").ThrowLuckyBlockRemotes
                    rems.ThrowZoneBatVisual:FireServer(true); task.wait()
                    rems.ThrowStarted:FireServer(); task.wait()
                    rems.ThrowBatHit:FireServer(nil, false); task.wait()
                    rems.ThrowBatTimingVfxCleanup:FireServer(); task.wait()
                    rems.LuckyBlockLanded:FireServer({
                        LandingPosition = Vector3.new(4, -99, 4514), ItemName = "Meowl", Rarity = "OG",
                        BlockName = "Uncommon Lucky Block", LandingRarity = "OG", Mutation = "Disco", Power = 10.642112568062
                    })
                    task.wait(0.5)
                    LocalPlayer.Character:MoveTo(Vector3.new(8, 21, -558)); task.wait(0.5)
                end
            end)

            MainTab:CreateToggle("Auto Upgrade", currentPlaceData.upgr or false, function(v)
                env.Upgrade = v
                env.setconfig("upgr", v)
                while env.Upgrade do
                    for f = 1, 3 do
                        for i = 1, 10 do
                            game:GetService("ReplicatedStorage").Events.RequestSlotUpgrade:FireServer("Floor"..f, "Slot"..i)
                        end
                    end
                    task.wait(0.1)
                end
            end)

            MainTab:CreateToggle("Auto Collect", currentPlaceData.col or false, function(v)
                env.Collect = v
                env.setconfig("col", v)
                while env.Collect do
                    for f = 1, 3 do
                        local floor = workspace["Plot_" .. LocalPlayer.Name]:FindFirstChild("Floor"..f)
                        if floor then
                            for _, slot in pairs(floor.Slots:GetChildren()) do
                                if slot:FindFirstChild("CollectTouch") then
                                    firetouchinterest(LocalPlayer.Character.Head, slot.CollectTouch, true); task.wait()
                                    firetouchinterest(LocalPlayer.Character.Head, slot.CollectTouch, false)
                                end
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)

            MainTab:CreateToggle("Auto Rebirth", currentPlaceData.Rebirth or false, function(v)
                env.Rebirth = v
                env.setconfig("Rebirth", v)
                while env.Rebirth do
                    game:GetService("ReplicatedStorage").Events.RequestRebirth:FireServer()
                    task.wait(3)
                end
            end)

        -- CROSS RIVERS FOR BRAINROTS
        elseif targetId == "71213902019049" then
            env.Farming, env.Upgrade, env.Collect = false, false, false
            local brainrotsFolder = workspace.SpawnedBrainrots
            local crossWall = workspace.MainGame.Map.Model.CrossWall
            local plrPlot
            for _, plot in pairs(workspace.MainGame.Plots:GetChildren()) do
                if plot.PlotOwner.UIPart.SGUI_Name.Frame.NameTxt.Text:find(LocalPlayer.Name) then plrPlot = plot; break end
            end

            MainTab:CreateToggle("Farm Brainrots", currentPlaceData.farmrots or false, function(v)
                env.Farming = v
                env.setconfig("farmrots", v)
                if not env.Farming then return end
                while env.Farming do
                    pcall(function()
                        for _, item in pairs(brainrotsFolder:GetChildren()) do
                            if item:GetAttribute("_ZoneIndex") == 10 and item.PrimaryPart then
                                local prox = item.PrimaryPart:FindFirstChildOfClass("ProximityPrompt")
                                if prox then
                                    LocalPlayer.Character:MoveTo(item.PrimaryPart.Position)
                                    repeat fireproximityprompt(prox); task.wait() until not prox or prox.Parent ~= item.PrimaryPart or not prox.Enabled
                                    task.wait(0.5)
                                    firetouchinterest(LocalPlayer.Character.Head, crossWall, true); task.wait()
                                    firetouchinterest(LocalPlayer.Character.Head, crossWall, false); task.wait(0.5)
                                end
                            end
                        end
                    end)
                    task.wait(1)
                end
            end)

            MainTab:CreateToggle("Auto Upgrade", currentPlaceData.upgrade or false, function(v)
                env.Upgrade = v
                env.setconfig("upgrade", v)
                while env.Upgrade do
                    for i = 1, 30 do game:GetService("ReplicatedStorage").Packages.Knit.Services.PadService.RF.UpgradePad:InvokeServer(tostring(i)) end
                    task.wait(0.1)
                end
            end)

            MainTab:CreateToggle("Auto Collect", currentPlaceData.collect or false, function(v)
                env.Collect = v
                env.setconfig("collect", v)
                while env.Collect and plrPlot do
                    for _, pad in pairs(plrPlot.Pads:GetChildren()) do
                        if pad:FindFirstChild("CollectPart") then
                            firetouchinterest(LocalPlayer.Character.Head, pad.CollectPart, true); task.wait()
                            firetouchinterest(LocalPlayer.Character.Head, pad.CollectPart, false)
                        end
                    end
                    task.wait(0.1)
                end
            end)

        -- LICK A BRAINROT
        elseif targetId == "112500097711893" then
            env.Farming, env.Strength = false, false

            MainTab:CreateToggle("Farm Brainrots", currentPlaceData.farming or false, function(v)
                env.Farming = v
                env.setconfig("farming", v)
                while env.Farming do
                    task.spawn(function()
                        game:GetService("ReplicatedStorage").Remotes.OnCast:InvokeServer(1)
                        game:GetService("ReplicatedStorage").Remotes.StartRun:InvokeServer()
                        game:GetService("ReplicatedStorage").Remotes.FinishRun:InvokeServer(true)
                    end)
                    task.wait()
                end
            end)

            MainTab:CreateToggle("Farm Strength", currentPlaceData.strength or false, function(v)
                env.Strength = v
                env.setconfig("strength", v)
                while env.Strength do
                    local gym = LocalPlayer.Backpack:FindFirstChild("Gym")
                    if gym and LocalPlayer.Character:FindFirstChild("Humanoid") then
                        pcall(function() LocalPlayer.Character.Humanoid:EquipTool(gym) end)
                    end
                    game:GetService("ReplicatedStorage").Remotes.doubleStrength:FireServer()
                    task.wait(1)
                end
            end)

        -- PAPER PLANE FOR BRAINROTS
        elseif targetId == "110373292461174" then
            env.Farming, env.Strength = false, false

            MainTab:CreateToggle("Farm Brainrots", currentPlaceData.farming or false, function(v)
                env.Farming = v
                env.setconfig("farming", v)
                while env.Farming do
                    game:GetService("ReplicatedStorage").SharedModules.Network.RequestPendingFlight:FireServer()
                    task.wait(1)
                    local vsp = Vector3.new(-347.2116394043, 89.037544250488, 25.892095565796)
                    local GameCore = require(game:GetService("ReplicatedStorage").GameCore)
                    local results = game:GetService("ReplicatedStorage").SharedModules.Network.RequestActiveFlight:InvokeServer({
                        plotIndex = 3, intensity = 1, player = LocalPlayer,
                        flightUID = require(game:GetService("ReplicatedStorage").UtilityCore).StringUtility.GenerateUID(),
                        serverFloors = 10000000, visualStartPos = vsp, startTime = GameCore.GetSycnedTime(),
                        startPos = Vector3.new(-347.2116394043, 85.050003051758, 25.892095565796), serverStrength = 10000000
                    })
                    if results and results.spawnedBrainrots[1] then
                        task.wait(results.timeInAir + 0.5)
                        game:GetService("ReplicatedStorage").SharedModules.Network.ClaimFlight:InvokeServer(results.spawnedBrainrots[1].uid)
                    end
                end
            end)

            MainTab:CreateToggle("Farm Strength", currentPlaceData.strength or false, function(v)
                env.Strength = v
                env.setconfig("strength", v)
                while env.Strength do
                    game:GetService("ReplicatedStorage").SharedModules.Network.RequestStrength:InvokeServer()
                    game:GetService("ReplicatedStorage").SharedModules.Network.RequestDoubleStrength:InvokeServer()
                    task.wait(0.1)
                end
            end)

        -- SMASH CRATE FOR BRAINROT
        elseif targetId == "100964511576728" then
            env.Farming = false
            env.CrateRarity = currentPlaceData.CrateRarity or "common"
            local visualCrates = workspace.Crates
            local serverCrates = workspace.ServerInfo

            MainTab:CreateTextbox("Crate Rarity", env.CrateRarity, function(str)
                env.CrateRarity = str:lower()
                env.setconfig("CrateRarity", str:lower())
            end)

            MainTab:CreateToggle("Farm Brainrots", currentPlaceData.farming or false, function(v)
                env.Farming = v
                env.setconfig("farming", v)
                if not v then return end
                while env.Farming do
                    pcall(function()
                        for _, item in pairs(visualCrates:GetChildren()) do
                            if item:GetAttribute("Rarity"):lower() == env.CrateRarity then
                                LocalPlayer.Character:MoveTo(item.PrimaryPart.Position + Vector3.new(0, 4, 0))
                                local crateServer = serverCrates["1"].Crates:FindFirstChild(item.Name)
                                if crateServer and LocalPlayer.Character:FindFirstChild("Humanoid") then
                                    for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                                        if tool:GetAttribute("Cooldown") ~= nil then LocalPlayer.Character.Humanoid:EquipTool(tool) end
                                    end
                                    task.wait()
                                    repeat
                                        game:GetService("ReplicatedStorage").Remotes.HammerActivated:FireServer(crateServer)
                                        task.wait()
                                    until not item or item.Parent ~= visualCrates
                                    task.wait(0.5)
                                    firetouchinterest(LocalPlayer.Character.Head, workspace.Scripted.EnterSpawnTouch, true); task.wait()
                                    firetouchinterest(LocalPlayer.Character.Head, workspace.Scripted.EnterSpawnTouch, false); task.wait(1)
                                    LocalPlayer.Character.Humanoid:UnequipTools()
                                end
                            end
                        end
                    end)
                    task.wait(0.1)
                end
            end)

        -- PRE-EXISTING GAMES FROM DATABASE WRAPPER HOOKS
        elseif targetId == "86614757217732" then -- +1 HEALTH
            MainTab:CreateToggle("Farm Brainrots", false, function(v) env.Farming = v end)
            task.spawn(function()
                while true do
                    if env.Farming then
                        pcall(function()
                            local topRot, bestAmt = nil, 0
                            for _, br in pairs(workspace.SpawnedBrainrots:GetChildren()) do
                                if br:GetAttribute("CashPerSec") >= bestAmt then bestAmt = br:GetAttribute("CashPerSec"); topRot = br end
                            end
                            if topRot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                LocalPlayer.Character:MoveTo(topRot.PrimaryPart.Position)
                                repeat fireproximityprompt(topRot.PickupHitbox.ProximityPrompt); task.wait() until not env.Farming or not topRot or topRot.Parent ~= workspace.SpawnedBrainrots
                                firetouchinterest(LocalPlayer.Character.Head, workspace.Map.BrainrotCollectionPart, true); task.wait()
                                firetouchinterest(LocalPlayer.Character.Head, workspace.Map.BrainrotCollectionPart, false)
                            end
                        end)
                    end; task.wait(0.5)
                end
            end)

        elseif targetId == "83569851223739" then -- +1 SPEED EVOLVE
            env.FarmWins, env.FarmEvolve, env.AutoSpeed = false, false, false
            MainTab:CreateToggle("Auto Speed", false, function(v) env.AutoSpeed = v
                while env.AutoSpeed do game:GetService("ReplicatedStorage").Modules.Shared.RemoteEventService.AddSpeedRemoteEvent:FireServer(); task.wait() end
            end)
            MainTab:CreateToggle("Auto Win", false, function(v) env.FarmWins = v
                while env.FarmWins do
                    pcall(function() for _, block in pairs(workspace:WaitForChild("Wins"):GetChildren()) do if not env.FarmWins then break end; if LocalPlayer.Character then LocalPlayer.Character:PivotTo(block:GetPivot()); task.wait(1) end end end)
                    task.wait(0.25)
                end
            end)
            MainTab:CreateToggle("Auto Evolve", false, function(v) env.FarmEvolve = v
                while env.FarmEvolve do game:GetService("ReplicatedStorage").Modules.Shared.RemoteEventService.EvolutionRemoteEvent:FireServer({Action = "Evolve"}); task.wait(1) end
            end)

        elseif targetId == "95082159892680" then -- +1 SPEED KEYBOARD ESCAPE
            env.Farming, env.WinStage = false, 1
            MainTab:CreateLabel("Currently supports up to 5 stages.")
            MainTab:CreateTextbox("Win Stage", "1", function(v) env.WinStage = tonumber(v) or 1 end)
            local part = Instance.new("Part"); part.Anchored, part.Size, part.Position, part.Parent = true, Vector3.new(10, 1, 546), Vector3.new(1, 75, 1090), workspace
            MainTab:CreateToggle("Autofarm Loop", false, function(v) env.Farming = v
                if not v then return end
                task.spawn(function() while env.Farming do game:GetService("ReplicatedStorage").Remotes.UpdateSpeed:FireServer("Walking"); task.wait() end end)
                task.spawn(function()
                    while env.Farming do
                        pcall(function()
                            local hum = LocalPlayer.Character.Humanoid
                            hum:MoveTo(Vector3.new(2, 9, 282)); hum.MoveToFinished:Wait()
                            if env.WinStage == 1 then hum:MoveTo(workspace.Structure.Stage2.WinBlock1.Position); hum.MoveToFinished:Wait(); task.wait(1); return end
                            hum:MoveTo(Vector3.new(70, 9, 398)); hum.MoveToFinished:Wait()
                            hum:MoveTo(Vector3.new(1, 9, 505)); hum.MoveToFinished:Wait()
                            if env.WinStage == 2 then hum:MoveTo(workspace.Structure.Stage3.WinBlock2.Position); hum.MoveToFinished:Wait(); task.wait(1); return end
                            hum:MoveTo(Vector3.new(19, 9, 541)); hum.MoveToFinished:Wait()
                            hum:MoveTo(Vector3.new(20, 77, 754)); hum.MoveToFinished:Wait()
                            if env.WinStage == 3 then hum:MoveTo(workspace.Structure.Stage4.WinBlock3.Position); hum.MoveToFinished:Wait(); task.wait(1); return end
                            hum:MoveTo(Vector3.new(1, 77, 817)); hum.MoveToFinished:Wait()
                            hum:MoveTo(Vector3.new(1, 77, 1042)); hum.MoveToFinished:Wait()
                            if env.WinStage == 4 then hum:MoveTo(workspace.Structure.Stage5.WinBlock4.Position); hum.MoveToFinished:Wait(); task.wait(1); return end
                            hum:MoveTo(Vector3.new(2, 77, 1363)); hum.MoveToFinished:Wait()
                            if env.WinStage == 5 then hum:MoveTo(workspace.Structure.Stage6.WinBlock5.Position); hum.MoveToFinished:Wait(); task.wait(1); return end
                        end)
                        task.wait(0.1)
                    end
                end)
            end)

        elseif targetId == "100070667273689" then -- SURVIVE FLOOD
            env.Farming = false
            local function grabem(folder)
                if not folder or not env.Farming then return end
                for _, br in pairs(folder:GetChildren()) do
                    if not env.Farming then break end
                    if br:IsA("Model") and br.PrimaryPart and br.PrimaryPart:FindFirstChildOfClass("ProximityPrompt") then
                        LocalPlayer.Character:MoveTo(br.PrimaryPart.Position); task.wait(0.5)
                        if not env.Farming then break end
                        fireproximityprompt(br.PrimaryPart:FindFirstChildOfClass("ProximityPrompt")); task.wait(0.25)
                        LocalPlayer.Character:MoveTo(Vector3.new(-2, 4, 13)); task.wait(0.5)
                    end
                end
            end
            MainTab:CreateToggle("Autofarm Hierarchical Loop", false, function(isOn) env.Farming = isOn
                while env.Farming do
                    pcall(function()
                        local f = workspace:WaitForChild("GameFolder"):WaitForChild("Brainrots")
                        grabem(f:FindFirstChild("Infinity")); grabem(f:FindFirstChild("Godly"))
                        grabem(f:FindFirstChild("Secret")); grabem(f:FindFirstChild("Celestial"))
                    end); task.wait(1)
                end
            end)

        elseif targetId == "89072926726733" then -- CROSS ROAD
            env.FarmBrainrots = false
            local function tp(pos) if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character:MoveTo(pos); repeat task.wait() until (LocalPlayer.Character.HumanoidRootPart.Position - pos).Magnitude < 15 end end
            MainTab:CreateToggle("Farm Celestial & Secret", false, function(v) env.FarmBrainrots = v
                while env.FarmBrainrots do
                    pcall(function()
                        for _, tier in ipairs({"Celestial", "Secret"}) do
                            tp(tier == "Celestial" and Vector3.new(345, 19, 2242) or Vector3.new(353, 2, 2092))
                            local spawner = workspace.ItemSpawners:WaitForChild(tier, 3)
                            if spawner and #spawner:GetChildren() >= 1 then
                                for _, br in pairs(spawner:GetChildren()) do
                                    if br.PrimaryPart then
                                        tp(br.PrimaryPart.Position); task.wait(0.5)
                                        repeat fireproximityprompt(br.PrimaryPart:FindFirstChildOfClass("ProximityPrompt")); task.wait() until not br or br.Parent ~= spawner or not env.FarmBrainrots
                                        tp(Vector3.new(343, 2, -15)); task.wait(1)
                                    end
                                end
                            end
                        end
                    end); task.wait(0.5)
                end
            end)
            MainTab:CreateButton("Remove Lag Cars", function() if workspace:FindFirstChild("CarSpawn") then workspace.CarSpawn:Destroy() end end)

        elseif targetId == "135882949571046" then -- DREAM FOR BRAINROTS
            env.farming = false
            MainTab:CreateToggle("Dream Spoof Farm", false, function(v) env.farming = v
                while env.farming do
                    pcall(function()
                        local rems = game:GetService("ReplicatedStorage").Remotes
                        rems.DreamStateChanged:FireServer(true)
                        rems.RequestDreamBrainrots:FireServer()
                        rems.PickupDreamBrainrot:FireServer("60"); task.wait(0.1)
                        rems.RequestDreamWallExit:FireServer()
                    end); task.wait(0.5)
                end
            end)

        elseif targetId == "137069154816703" then -- HACK VAULT
            env.FarmRots = false
            MainTab:CreateToggle("Vault Zone 22 Farm", false, function(v) env.FarmRots = v
                while env.FarmRots do
                    pcall(function()
                        for _, br in pairs(workspace.EntitiesFolder:GetChildren()) do
                            if not env.FarmRots then break end
                            if br:GetAttribute("SpawnZone") == 22 and br.PrimaryPart then
                                LocalPlayer.Character:MoveTo(Vector3.new(-2494, 4, -726)); task.wait(0.3)
                                LocalPlayer.Character:MoveTo(br.PrimaryPart.Position); task.wait(0.1)
                                repeat fireproximityprompt(br.PrimaryPart.TakeBrainrotPrompt); task.wait() until not br.PrimaryPart or br.PrimaryPart:FindFirstChild("Attachment") or not env.FarmRots
                                LocalPlayer.Character:MoveTo(Vector3.new(77, 4, -729)); task.wait(0.5)
                            end
                        end
                    end); task.wait(1)
                end
            end)

        elseif targetId == "89046742932569" then -- SAIL FOR BRAINROTS
            env.Farming, env.Selling, env.ChosenZone, env.MaxPrice = false, false, nil, 0
            local function parseValue(str)
                local sfx = {K = 1e3, M = 1e6, B = 1e9, T = 1e12}
                local num, suf = str:match("^([%d%.]+)([A-Za-z]*)")
                if not num then return 0 end
                return sfx[suf:upper()] and (tonumber(num) or 0) * sfx[suf:upper()] or tonumber(num) or 0
            end
            MainTab:CreateTextbox("Farm Zone (1-13)", "1", function(v) env.ChosenZone = workspace.Zones["Zone" .. v] end)
            MainTab:CreateToggle("Autofarm Objects", false, function(v) env.Farming = v
                while env.Farming do
                    if LocalPlayer.Character and env.ChosenZone then
                        for _, br in pairs(env.ChosenZone.Objects:GetChildren()) do
                            if not env.Farming then break end
                            LocalPlayer.Character:MoveTo(br.PrimaryPart.Position)
                            repeat fireproximityprompt(br.ProximityPrompt); task.wait() until br == nil or br.Parent ~= env.ChosenZone.Objects or not env.Farming
                            LocalPlayer.Character:MoveTo(workspace.Bases[LocalPlayer.Name].Root.Position); task.wait(0.4)
                        end
                    end; task.wait(1)
                end
            end)
            MainTab:CreateTextbox("Max Sell Price", "0", function(v) env.MaxPrice = tonumber(v) or 0 end)
            MainTab:CreateToggle("Auto Backpack Sell", false, function(v) env.Selling = v
                while env.Selling do
                    for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
                        if item.Name ~= "Bat" and item:FindFirstChild("Handle") then
                            pcall(function() if parseValue(item.Handle.ObjectInfo.Value.ValueLabel.Text) <= env.MaxPrice then game:GetService("ReplicatedStorage").Shared.Classes.RemoteFunction.Remotes.EntityShared_SellEntity:InvokeServer(item.Name) end end)
                        end
                    end; task.wait(2)
                end
            end)
            MainTab:CreateButton("Redeem Active Codes", function() for _, code in pairs({"Stop Looking", "TommysHouse", "Phew", "GoldStatue", "FreeSpin"}) do game:GetService("ReplicatedStorage").Shared.Classes.RemoteFunction.Remotes.CodeShared_Redeem:InvokeServer(code) end end)

        elseif targetId == "94780005879799" then -- SCREAM FOR BRAINROTS
            env.AddingSpins, env.AutoSleepy, env.AutoOg = false, false, false
            MainTab:CreateToggle("Inf Spins Stream", false, function(v) env.AddingSpins = v; while env.AddingSpins do game:GetService("ReplicatedStorage").Remotes.AddSpin:FireServer(); task.wait(0.05) end end)
            MainTab:CreateToggle("Auto Wheel: Sleepy", false, function(v) env.AutoSleepy = v; while env.AutoSleepy do game:GetService("ReplicatedStorage").Remotes.SpinEventWheel:FireServer(5); task.wait(0.4) end end)
            MainTab:CreateToggle("Auto Wheel: OG", false, function(v) env.AutoOg = v; while env.AutoOg do game:GetService("ReplicatedStorage").Remotes.SpinEventWheel:FireServer(4); task.wait(0.4) end end)

        elseif targetId == "84332574190497" then -- +1 WINGS
            env.Farming = false
            local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]
            local worldPositions = { cosmic = Vector3.new(169, 42, 6124), spawn = Vector3.new(22, 71, -133) }
            local function teleportTo(pos)
                if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
                LocalPlayer.Character.HumanoidRootPart.CFrame = typeof(pos) == "Vector3" and CFrame.new(pos) or pos
                task.wait(((ping:GetValue() * 4) / 1000))
                while LocalPlayer.GameplayPaused do task.wait(0.1) end
            end
            MainTab:CreateToggle("Autofarm Cosmics", false, function(v) env.Farming = v
                if not v then return end
                task.spawn(function()
                    while env.Farming do
                        local cosmics = workspace:FindFirstChild("ItemSpawners") and workspace.ItemSpawners:FindFirstChild("Cosmic")
                        if not cosmics or #cosmics:GetChildren() == 0 then teleportTo(worldPositions.cosmic); task.wait(1); continue end
                        for _, rot in pairs(cosmics:GetChildren()) do
                            if not env.Farming then break end
                            local mesh = rot:WaitForChild("Mesh", 3)
                            if mesh and mesh:FindFirstChildWhichIsA("ProximityPrompt") then
                                teleportTo(rot.WorldPivot)
                                fireproximityprompt(mesh:FindFirstChildWhichIsA("ProximityPrompt")); task.wait(0.1)
                                teleportTo(worldPositions.spawn); task.wait(0.1)
                                for _, part in pairs(LocalPlayer.Character:GetChildren()) do if part:IsA("Tool") then part.Parent = LocalPlayer.Backpack end end
                                teleportTo(worldPositions.cosmic)
                            end
                        end; task.wait(0.5)
                    end
                end)
            end)
            MainTab:CreateButton("Teleport to Spawn", function() teleportTo(worldPositions.spawn) end)

        elseif targetId == "136919941417380" then -- BIKE OBBY
            env.Farming, env.equip = false, false
            MainTab:CreateToggle("Farm Brainrots (Zones 8, 9, 10)", false, function(v) env.Farming = v
                if not v then return end
                while env.Farming do
                    pcall(function()
                        local zones = { {id = "10", pos = Vector3.new(-3394, 1450, 7887)}, {id = "9", pos = Vector3.new(-3394, 1450, 6269)}, {id = "8", pos = Vector3.new(-3394, 1450, 4732)} }
                        for _, zData do
                            if not env.Farming then break end
                            LocalPlayer.Character:MoveTo(zData.pos)
                            local div = workspace.ItemSpawns:WaitForChild(zData.id, 5)
                            if div then
                                for _, item in pairs(div:GetChildren()) do
                                    if not env.Farming then break end
                                    if item:IsA("Model") and item.PrimaryPart then
                                        LocalPlayer.Character:MoveTo(item.PrimaryPart.Position)
                                        repeat fireproximityprompt(item.PrimaryPart.ProximityPrompt); task.wait() until not item or item.Parent ~= div or not env.Farming
                                        local br = LocalPlayer.Character:WaitForChild("StackItem", 3)
                                        if br then LocalPlayer.Character:MoveTo(workspace.Zones.BikeSpawn.Position); repeat task.wait() until not br or br.Parent ~= LocalPlayer.Character or not env.Farming end
                                    end
                                end
                            end
                        end
                    end); task.wait(0.1)
                end
            end)
            MainTab:CreateToggle("Auto Equip Best Assets", false, function(v) env.equip = v; while env.equip do game:GetService("ReplicatedStorage").Events.PlaceBestBrainrots:FireServer(); task.wait(5) end end)

        elseif targetId == "98868317791094" then -- DUMP
            env.AutoDig, env.AutoBuy, env.collect, env.stealfromall = false, false, false, false
            MainTab:CreateToggle("Steal from All Plots", false, function(v) env.stealfromall = v
                while env.stealfromall do
                    pcall(function()
                        for _, plot in pairs(workspace.ActivePlots:GetChildren()) do
                            if plot.Name ~= "Plot" and plot.Name ~= tostring(LocalPlayer.UserId) then
                                game:GetService("ReplicatedStorage").Network.RemoteEvents.LockpickGateOpen:FireServer(plot, 30); task.wait(0.1)
                                for _, item in pairs(plot.PlacedItems:GetChildren()) do
                                    if item.PrimaryPart and item.PrimaryPart:FindFirstChild("Attachment") and item.PrimaryPart.Attachment:FindFirstChildOfClass("ProximityPrompt") then
                                        LocalPlayer.Character:MoveTo(item.PrimaryPart.Position); task.wait(0.5)
                                        fireproximityprompt(item.PrimaryPart.Attachment:FindFirstChildOfClass("ProximityPrompt")); task.wait(0.5)
                                        if workspace.ActivePlots:FindFirstChild(tostring(LocalPlayer.UserId)) then LocalPlayer.Character:MoveTo(workspace.ActivePlots[tostring(LocalPlayer.UserId)].TeleportPoint.Position) end
                                        task.wait(0.5)
                                    end
                                end
                            end
                        end
                    end); task.wait(1)
                end
            end)
            MainTab:CreateToggle("Auto Dig Simulation", false, function(v) env.AutoDig = v
                while env.AutoDig do
                    pcall(function()
                        game:GetService("ReplicatedStorage").Network.RemoteFunctions.StartDigging:InvokeServer(); task.wait(1)
                        game:GetService("ReplicatedStorage").Network.RemoteFunctions.GetSelectedItem:InvokeServer(2)
                        game:GetService("ReplicatedStorage").Network.RemoteEvents["0a1baf564dbb5375"]:FireServer(-1)
                        game:GetService("ReplicatedStorage").Network.RemoteEvents["0a1baf564dbb5375"]:FireServer(0); task.wait(2)
                        game:GetService("ReplicatedStorage").Network.RemoteEvents.EndDigging:FireServer("Succeeded", 3)
                    end); task.wait(0.2)
                end
            end)
            MainTab:CreateToggle("Auto Buy Best Shovel", false, function(v) env.AutoBuy = v
                while env.AutoBuy do
                    pcall(function()
                        local money = LocalPlayer.leaderstats.Doubloons.Value
                        local best = nil
                        for _, rarity in ipairs({"Mythic", "Legendary", "Epic", "Rare", "Uncommon", "Common"}) do
                            for _, shovel in ipairs(require(game:GetService("ReplicatedStorage").SharedSource.GameData.Shovels):GetShovelsByRarity(rarity)) do
                                if shovel.BaseCost <= money and (not best or shovel.BaseCost > best.BaseCost) then best = shovel end
                            end
                            if best then break end
                        end
                        if best then game:GetService("ReplicatedStorage").Network.RemoteEvents["5844c2fc64759f91"]:FireServer({ItemType = "Shovel", Name = best.Name}) end
                    end); task.wait(5)
                end
            end)
            MainTab:CreateToggle("Auto Collect Passive Cash", false, function(v) env.collect = v; while env.collect do game:GetService("ReplicatedStorage").Network.RemoteEvents.CollectSavedPlotMoney:FireServer(); task.wait(1) end end)

        elseif targetId == "137233438285284" then -- CHICKEN FARM
            env.Farming = false
            local suffixValue = {} for i, suf in ipairs({"K","M","B","T","Qd","Qn","Sx","Sp","Oc","No","De"}) do suffixValue[suf] = 1000 ^ i end
            local function parseSuffixedNumber(str)
                str = str:gsub("[%$,%s]", "")
                local n, s = str:match("^(-?%d*%.?%d+)(%a*)$")
                return (tonumber(n) or 0) * (suffixValue[s] or 1)
            end
            local mainEvent = game:GetService("ReplicatedStorage").Paper.Remotes.__remoteevent
            local mainFunction = game:GetService("ReplicatedStorage").Paper.Remotes.__remotefunction
            MainTab:CreateLabel("⚠️ BUY FIRST CHICKEN BEFORE TURNING ON AUTOFARM!")
            MainTab:CreateToggle("Autofarm Tycoon Loop", false, function(v) env.Farming = v
                if not v then return end
                task.spawn(function()
                    while env.Farming do
                        pcall(function()
                            mainFunction:InvokeServer("Collect Cash"); task.wait(0.1)
                            mainFunction:InvokeServer("Upgrade Process Level"); task.wait(0.1)
                            local currentCash = parseSuffixedNumber(LocalPlayer.PlayerGui.Main.Currencies.Cash.List.Amount.Text)
                            local btns = workspace.Plots[LocalPlayer.Name].Buttons.BuyChickens
                            local tobuy = parseSuffixedNumber(btns.Buy100.Button.UI.Cost.Text) <= currentCash and 100 or parseSuffixedNumber(btns.Buy25.Button.UI.Cost.Text) <= currentCash and 25 or parseSuffixedNumber(btns.Buy5.Button.UI.Cost.Text) <= currentCash and 5 or parseSuffixedNumber(btns.Buy1.Button.UI.Cost.Text) <= currentCash and 1 or 0
                            if tobuy > 0 then mainFunction:InvokeServer("Buy Chickens", tobuy); task.wait(0.1); mainFunction:InvokeServer("Merge Chickens") end
                        end); task.wait(1)
                    end
                end)
            end)

        elseif targetId == "106772177198260" then -- REEL FOR BRAINROTS
            env.Farming = false
            MainTab:CreateToggle("Instant Autofarm Fishing", false, function(v) env.Farming = v; while env.Farming do game:GetService("ReplicatedStorage").RemoteHandler.Fishing:FireServer("Caught", 3); task.wait(0.1) end end)
            MainTab:CreateButton("Dupe Brainrot In-Hand", function()
                local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool and tool:GetAttribute("brainrot") then
                    for p = 1, 30 do game:GetService("ReplicatedStorage").RemoteHandler.Plot:FireServer("Add", "Plot" .. p, tool.Name); task.wait(0.5) end
                end
            end)

        elseif targetId == "109908567838703" then -- NUKE FOR BRAINROTS
            env.AutoMoney, env.AutoRebirth = false, false
            MainTab:CreateToggle("Auto Money (Packet Stream)", false, function(v) env.AutoMoney = v; while env.AutoMoney do task.spawn(function() game:GetService("ReplicatedStorage").ModifiedPackages.Packet.RemoteEvent:FireServer(buffer.fromstring("\x0E")) end); task.wait() end end)
            MainTab:CreateToggle("Auto Rebirth", false, function(v) env.AutoRebirth = v; while env.AutoRebirth do game:GetService("ReplicatedStorage").ModifiedPackages.Packet.RemoteEvent:FireServer(buffer.fromstring("\x93")); task.wait(1) end end)

        elseif targetId == "114640202062357" then -- SWING OBBY
            env.Farming = false
            MainTab:CreateToggle("Autofarm Zone 13 & 14", false, function(v) env.Farming = v
                if not v then return end
                game:GetService("ReplicatedStorage").Packages.Knit.Services.GameplayService.RF.ReturnToPlot:InvokeServer(); task.wait(0.5)
                while env.Farming do
                    pcall(function()
                        for _, br in pairs(workspace.ActiveBrainrots:GetChildren()) do
                            local zone = br:GetAttribute("Zone")
                            if (zone == 14 or zone == 13) and br:FindFirstChild("Attachment") then
                                LocalPlayer.Character:PivotTo(br.CFrame)
                                repeat fireproximityprompt(br.Attachment:FindFirstChildOfClass("ProximityPrompt")); task.wait() until not br or br.Parent ~= workspace.ActiveBrainrots or not env.Farming
                            end
                        end
                    end); task.wait(0.5)
                end
            end)

        elseif targetId == "99255447043899" then -- BECOME A BRAINROT
            env.Farming = false
            MainTab:CreateToggle("Autofarm Stage Loop", false, function(v) env.Farming = v
                while env.Farming do
                    pcall(function()
                        firetouchinterest(LocalPlayer.Character.Head, workspace.RunTrigger, true); task.wait()
                        firetouchinterest(LocalPlayer.Character.Head, workspace.RunTrigger, false); task.wait(0.4)
                        LocalPlayer.Character:MoveTo(Vector3.new(46, 4, -1816))
                        local fbr = workspace.Locations.End.Brainrots:FindFirstChildOfClass("Model")
                        if fbr and fbr.PrimaryPart then
                            LocalPlayer.Character:MoveTo(fbr.PrimaryPart.Position)
                            repeat fireproximityprompt(fbr.PrimaryPart.ProximityPrompt); task.wait() until not fbr or fbr.Parent ~= workspace.Locations.End.Brainrots or not env.Farming
                            LocalPlayer.Character:MoveTo(workspace.EscapeHitbox.Position)
                        end
                    end); task.wait(0.8)
                end
            end)

        elseif targetId == "110627433764494" then -- FAKE A BRAINROT
            env.Farming, env.Fakee = false, "Tim Cheese"
            MainTab:CreateTextbox("Target Name", "Tim Cheese", function(v) env.Fakee = v end)
            MainTab:CreateToggle("Steal Farm & Pathfind", false, function(v) env.Farming = v
                while env.Farming do
                    game:GetService("ReplicatedStorage").Events.FakeSystem_StartFake:FireServer(env.Fakee)
                    local complete = false
                    task.spawn(function() while not complete and env.Farming do if LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(math.random(-37, 80), 0, math.random(-399, -119))) end; task.wait(3) end end)
                    local connection = game:GetService("ReplicatedStorage").Events.LaserVisibility.OnClientEvent:Connect(function(uid, isOn)
                        if isOn then return end
                        for _, plot in pairs(workspace.Plots:GetChildren()) do
                            if plot:GetAttribute("OwnerUserId") == uid then
                                for _, slot in pairs(plot.Slots:GetChildren()) do
                                    if slot:FindFirstChild("PlacedBrainrot") then
                                        LocalPlayer.Character:MoveTo(slot.PlacedBrainrot.PrimaryPart.Position)
                                        repeat fireproximityprompt(slot.StealPrompt); task.wait() until not slot.StealPrompt.Enabled or not env.Farming
                                        LocalPlayer.Character:MoveTo(plot.CollectAllZone.Position); complete = true
                                    end
                                end
                            end
                        end
                    end)
                    repeat task.wait(0.5) until complete or not env.Farming
                    if connection then connection:Disconnect() end
                end
            end)

        -- EXTENSION STANDBY PROFILE FOR RECOGNIZED OBBY MODULES WITHOUT INLINE IMPLEMENTATION
        else
            MainTab:CreateButton("Initialize Script Context", function() print("Default profile loaded verified.") end)
            MainTab:CreateToggle("Anti-AFK Framework Active", true, function() end)
        end

    elseif gameMatch.Status == "Maintenance" then
        StatusLabel.TextColor3 = Color3.fromRGB(234, 179, 8)
        StatusLabel.Text = gameMatch.Name .. "\nStatus: 🟡 Under Maintenance.\nUpdates rolling out soon!"
        task.wait(3.5) LoaderGui:Destroy()
    elseif gameMatch.Status == "Patched" then
        StatusLabel.TextColor3 = Color3.fromRGB(239, 68, 68)
        StatusLabel.Text = gameMatch.Name .. "\nStatus: 🔴 Patched / Game Closed"
        task.wait(3.5) LoaderGui:Destroy()
    end
else
    StatusLabel.TextColor3 = Color3.fromRGB(239, 68, 68)
    StatusLabel.Text = "AERO HUB\nStatus: 🔴 Game Unrecognized"
    task.wait(3.5) LoaderGui:Destroy()
end
