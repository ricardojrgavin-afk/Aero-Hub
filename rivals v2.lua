--[[
    Aero Hub — Complete Mobile & PC Edition
    Place in: StarterPlayerScripts OR StarterGui > ScreenGui > LocalScript
    RightShift / F9 or the Floating Button → open / close menu
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LP = Players.LocalPlayer
local PGui = LP:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

-- ═══════════════════════════════════════════════════════
-- MOBILE DETECTION & DYNAMIC LAYOUT SIZE CONFIG
-- ═══════════════════════════════════════════════════════
local IsMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled

-- Scaled dimensions based on device type
local MENU_SIZE = IsMobile and UDim2.fromOffset(540, 330) or UDim2.fromOffset(860, 520)
local SW = IsMobile and 135 or 195
local TEXT_SIZE_HEADER = IsMobile and 14 or 20
local TEXT_SIZE_BODY = IsMobile and 11 or 13
local ROW_HEIGHT = IsMobile and 42 or 52

-- Custom Whitelist Tracking
local WhitelistedPlayers = {}

-- Global Stream Mode State
local StreamModeActive = false

-- ═══════════════════════════════════════════════════════
-- GLOBAL CONFIGURATION & STATES
-- ═══════════════════════════════════════════════════════
local Keybinds = {
	aimbot = { key=Enum.KeyCode.Q, holdMode=false, label="Aimbot" },
	esp = { key=Enum.KeyCode.Z, holdMode=false, label="ESP" },
	infiniteJump = { key=Enum.KeyCode.X, holdMode=false, label="Inf Jump" },
}

local State = {
	autoLoadConfig=false, infiniteJump=false, esp=false, aimbot=false, streamMode=false,
	espSettings = { Box=true, BoxFilled=false, Name=true, Distance=true, TeamCheck=true },
	aimbotSettings = { TeamCheck=true, WallCheck=false, TargetPart="HumanoidRootPart" },
}

-- ═══════════════════════════════════════════════════════
-- NEW INTEGRATED AIMBOT ENGINE
-- ═══════════════════════════════════════════════════════
local Features = {}
Features.aimbotEnabled = false
Features.aimbotSettings = {
    WallCheck = false,
    TargetPart = "HumanoidRootPart",
    TeamCheck = true,
    TargetNPCs = false
}

local aimbotLoop = nil

local function lookAt(targetPosition)
    if targetPosition then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPosition)
    end
end

local function getClosestTarget()
    local character = LP.Character or LP.CharacterAdded:Wait()
    local localRoot = character:WaitForChild("HumanoidRootPart")
    local nearestTarget = nil
    local shortestDistance = math.huge
    local s = Features.aimbotSettings

    local function checkTarget(target)
        if target and target:IsA("Model") and target:FindFirstChild("Humanoid") and target:FindFirstChild(s.TargetPart) then
            local targetRoot = target[s.TargetPart]
            local distance = (targetRoot.Position - localRoot.Position).Magnitude

            if distance < shortestDistance then
                if s.WallCheck then
                    local rayDirection = (targetRoot.Position - Camera.CFrame.Position).Unit * 1000
                    local raycastParams = RaycastParams.new()
                    raycastParams.FilterDescendantsInstances = {character}
                    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

                    local raycastResult = workspace:Raycast(Camera.CFrame.Position, rayDirection, raycastParams)

                    if raycastResult and raycastResult.Instance:IsDescendantOf(target) then
                        shortestDistance = distance
                        nearestTarget = target
                    end
                else
                    shortestDistance = distance
                    nearestTarget = target
                end
            end
        end
    end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LP then
            if s.TeamCheck and WhitelistedPlayers[player.Name] then continue end
            if s.TeamCheck and LP.Team and player.Team and player.Team == LP.Team then continue end
            checkTarget(player.Character)
        end
    end

    if s.TargetNPCs then
        for _, npc in pairs(workspace:GetDescendants()) do
            checkTarget(npc)
        end
    end

    return nearestTarget
end

local function startAimbotLoop()
    if aimbotLoop then return end
    aimbotLoop = RunService.RenderStepped:Connect(function()
        if not Features.aimbotEnabled then
            if aimbotLoop then aimbotLoop:Disconnect(); aimbotLoop = nil end
            return
        end

        local closestTarget = getClosestTarget()
        if closestTarget and closestTarget:FindFirstChild(Features.aimbotSettings.TargetPart) then
            local targetRoot = closestTarget[Features.aimbotSettings.TargetPart]
            local character = LP.Character

            while Features.aimbotEnabled and closestTarget and closestTarget:FindFirstChild(Features.aimbotSettings.TargetPart) and closestTarget.Humanoid.Health > 0 do
                lookAt(targetRoot.Position)
                
                local rayDirection = (targetRoot.Position - Camera.CFrame.Position).Unit * 1000
                local raycastParams = RaycastParams.new()
                raycastParams.FilterDescendantsInstances = {character}
                raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

                local raycastResult = workspace:Raycast(Camera.CFrame.Position, rayDirection, raycastParams)

                if not raycastResult or not raycastResult.Instance:IsDescendantOf(closestTarget) then
                    break
                end

                RunService.RenderStepped:Wait()
            end
        end
    end)
end

function Features.setAimbot(on)
    Features.aimbotEnabled = on
    if on then startAimbotLoop() elseif aimbotLoop then aimbotLoop:Disconnect(); aimbotLoop = nil end
end

-- ═══════════════════════════════════════════════════════
-- INFINITE JUMP
-- ═══════════════════════════════════════════════════════
Features.infiniteJumpEnabled = false
local jumpConn = nil

local function getHum()
	local c = LP.Character
	return c and c:FindFirstChildOfClass("Humanoid")
end

local function stopIJ()
	if jumpConn then jumpConn:Disconnect(); jumpConn = nil end
end

local function startIJ()
	stopIJ()
	jumpConn = UIS.JumpRequest:Connect(function()
		if not Features.infiniteJumpEnabled then return end
		local h = getHum(); if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
	end)
end

function Features.setInfiniteJump(on)
	Features.infiniteJumpEnabled = on
	if on then startIJ() else stopIJ() end
end

LP.CharacterAdded:Connect(function()
	task.wait(0.2)
	if Features.infiniteJumpEnabled then startIJ() end
end)

-- ═══════════════════════════════════════════════════════
-- ESP SYSTEM
-- ═══════════════════════════════════════════════════════
Features.espEnabled = false
Features.espSettings = { Box=true, BoxFilled=false, Name=true, Distance=true, TeamCheck=true }
local espObjects = {}
local espLoop = nil

local function teamCol(p) return p.Team and p.Team.TeamColor.Color or Color3.fromRGB(255,60,60) end

local function isEnemy(p)
	if not Features.espSettings.TeamCheck then return true end
	if WhitelistedPlayers[p.Name] then return false end
	if not LP.Team or not p.Team then return true end
	return p.Team ~= LP.Team
end

local function removeESP(p)
	local d = espObjects[p]; if not d then return end
	if d.hl and d.hl.Parent then d.hl:Destroy() end
	if d.bb and d.bb.Parent then d.bb:Destroy() end
	espObjects[p] = nil
end

local function removeAllESP() for p in pairs(espObjects) do removeESP(p) end end

local function updateESP(p)
	if p == LP then return end
	local char = p.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	
	if StreamModeActive or not Features.espEnabled or not char or not hrp or not hum or hum.Health <= 0 then removeESP(p); return end
	if not isEnemy(p) then removeESP(p); return end
	
	local d = espObjects[p] or {}; espObjects[p] = d
	local col = teamCol(p)
	
	if Features.espSettings.Box or Features.espSettings.BoxFilled then
		if not d.hl or not d.hl.Parent then
			local h = Instance.new("Highlight"); h.Name="RFunESP"; h.Adornee=char; h.Parent=char; d.hl=h
		end
		d.hl.OutlineColor = col
		d.hl.FillColor = col
		d.hl.OutlineTransparency = Features.espSettings.Box and 0 or 1
		d.hl.FillTransparency = Features.espSettings.BoxFilled and 0.55 or 1
		d.hl.Enabled = true
	elseif d.hl then d.hl:Destroy(); d.hl=nil end
	
	if Features.espSettings.Name or Features.espSettings.Distance then
		if not d.bb or not d.bb.Parent then
			local bb = Instance.new("BillboardGui"); bb.Name="RFunBB"; bb.AlwaysOnTop=true
			bb.Size=UDim2.fromOffset(130,44); bb.StudsOffset=Vector3.new(0,3.5,0); bb.Adornee=hrp; bb.Parent=hrp
			local ul = Instance.new("UIListLayout"); ul.HorizontalAlignment=Enum.HorizontalAlignment.Center
			ul.SortOrder=Enum.SortOrder.LayoutOrder; ul.Parent=bb
			
			local nl = Instance.new("TextLabel"); nl.Name="NL"; nl.BackgroundTransparency=1
			nl.Size=UDim2.new(1,0,0,18); nl.Font=Enum.Font.GothamBold; nl.TextSize=13
			nl.TextStrokeTransparency=0.4; nl.LayoutOrder=1; nl.Parent=bb
			
			local dl = Instance.new("TextLabel"); dl.Name="DL"; dl.BackgroundTransparency=1
			dl.Size=UDim2.new(1,0,0,16); dl.Font=Enum.Font.Gotham; dl.TextSize=11
			dl.TextStrokeTransparency=0.4; dl.LayoutOrder=2; nl.Parent=bb
			d.bb = bb
		end
		local bb=d.bb; bb.Adornee=hrp; bb.Enabled=true
		local cam = workspace.CurrentCamera
		local nl=bb:FindFirstChild("NL"); if nl then nl.Visible=Features.espSettings.Name; if Features.espSettings.Name then nl.Text=p.DisplayName~="" and p.DisplayName or p.Name; nl.TextColor3=col end end
		local dl=bb:FindFirstChild("DL"); if dl then dl.Visible=Features.espSettings.Distance; if Features.espSettings.Distance and cam then dl.Text=math.floor((cam.CFrame.Position-hrp.Position).Magnitude).." studs"; dl.TextColor3=Color3.fromRGB(220,220,220) end end
	elseif d.bb then d.bb:Destroy(); d.bb=nil end
end

local function startESPLoop()
	if espLoop then return end
	espLoop = RunService.RenderStepped:Connect(function()
		if StreamModeActive or not Features.espEnabled then return end
		for _,p in ipairs(Players:GetPlayers()) do updateESP(p) end
	end)
end

local function stopESPLoop() if espLoop then espLoop:Disconnect(); espLoop=nil end end

function Features.setESP(on)
	Features.espEnabled = on
	if on and not StreamModeActive then startESPLoop() else stopESPLoop(); removeAllESP() end
end

function Features.setESPSetting(k,v)
	Features.espSettings[k]=v
	if not Features.espEnabled or StreamModeActive then return end
	for _,p in ipairs(Players:GetPlayers()) do updateESP(p) end
end

Players.PlayerRemoving:Connect(removeESP)
LP.CharacterAdded:Connect(function() task.wait(0.2); if Features.espEnabled and not StreamModeActive then removeAllESP() end end)

-- ═══════════════════════════════════════════════════════
-- KEYBINDS HELPER
-- ═══════════════════════════════════════════════════════
local function keyName(kc)
	if typeof(kc) == "EnumItem" then return kc.Name end
	return tostring(kc):gsub("Enum%.KeyCode%.",""):gsub("Enum%.UserInputType%.","")
end

-- ═══════════════════════════════════════════════════════
-- UI STYLING & RED/BLACK THEME CONFIG
-- ═══════════════════════════════════════════════════════
for _,c in ipairs(PGui:GetChildren()) do
	if (c.Name=="RivalsFun3D" or c.Name=="RFunMobileBinds" or c.Name=="AeroHub_TeamManager") and not script:IsDescendantOf(c) then c:Destroy() end
end

local C = {
	bg = Color3.fromRGB(6, 0, 0),
	panel = Color3.fromRGB(14, 2, 2),
	row = Color3.fromRGB(22, 4, 4),
	sidebarBg = Color3.fromRGB(10, 0, 0),
	topBar = Color3.fromRGB(14, 0, 0),
	accent = Color3.fromRGB(210, 30, 30),
	accentBrt = Color3.fromRGB(255, 55, 55),
	activeDim = Color3.fromRGB(65, 8, 8),
	sep = Color3.fromRGB(150, 18, 18),
	text = Color3.fromRGB(255,255,255),
	textDim = Color3.fromRGB(185,115,115),
	sliderTrack = Color3.fromRGB(40, 5, 5),
	toggleOff = Color3.fromRGB(50, 8, 8),
}

local FONT = Enum.Font.Gotham
local FONT_MED = Enum.Font.GothamMedium
local FONT_BOL = Enum.Font.GothamBold
local CR = UDim.new(0,5)
local CR_SM = UDim.new(0,4)

local function mkCorner(p,r) local c=Instance.new("UICorner"); c.CornerRadius=r or CR; c.Parent=p; return c end
local function mkStroke(p,col,tr,th) local s=Instance.new("UIStroke"); s.Color=col or C.sep; s.Transparency=tr or 0.5; s.Thickness=th or 1; s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; s.Parent=p; return s end
local function mkPad(p,t,r,b,l) local x=Instance.new("UIPadding"); x.PaddingTop=UDim.new(0,t or 12); x.PaddingRight=UDim.new(0,r or 12); x.PaddingBottom=UDim.new(0,b or 12); x.PaddingLeft=UDim.new(0,l or 12); x.Parent=p; return x end

local function mkLabel(props)
	local l=Instance.new("TextLabel"); l.Name=props.Name or "Lbl"; l.BackgroundTransparency=1
	l.Font=props.Font or FONT; l.TextSize=props.TextSize or TEXT_SIZE_BODY
	l.TextColor3=props.TextColor or C.text; l.Text=props.Text or ""; l.TextXAlignment=props.TextXAlignment or Enum.TextXAlignment.Left
	l.TextYAlignment=Enum.TextYAlignment.Center
	if props.Size then l.Size=props.Size end
	if props.Position then l.Position=props.Position end
	if props.LayoutOrder then l.LayoutOrder=props.LayoutOrder end
	l.Parent=props.Parent; return l
end

local function mkSep(parent,lo)
	local l=Instance.new("Frame"); l.Name="Sep"; l.Size=UDim2.new(1,0,0,1)
	l.BackgroundColor3=C.sep; l.BackgroundTransparency=0.4; l.BorderSizePixel=0
	l.LayoutOrder=lo or 0; l.Parent=parent; return l
end

-- ── GUI ROOT ───────────────────────────────────────────
local gui=Instance.new("ScreenGui"); gui.Name="RivalsFun3D"; gui.ResetOnSpawn=false
gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; gui.IgnoreGuiInset=true; gui.Parent=PGui

local function showToast(msg)
	if StreamModeActive then return end
	local t=gui:FindFirstChild("Toast"); if t then t:Destroy() end
	local toast=Instance.new("Frame"); toast.Name="Toast"; toast.BackgroundColor3=Color3.fromRGB(12,0,0)
	toast.BorderSizePixel=0; toast.Size=UDim2.fromOffset(340,36)
	toast.Position=UDim2.new(0.5,0,1,-65); toast.AnchorPoint=Vector2.new(0.5,1); toast.ZIndex=200; toast.Parent=gui
	mkCorner(toast,CR); mkStroke(toast,C.accent,0,1)
	mkLabel({Parent=toast, Text=msg, TextSize=11, TextXAlignment=Enum.TextXAlignment.Center, Size=UDim2.fromScale(1,1)})
	task.delay(2.5,function() if toast.Parent then toast:Destroy() end end)
end

local root=Instance.new("Frame"); root.Name="Root"; root.BackgroundColor3=C.bg
root.BorderSizePixel=0; root.Size=MENU_SIZE
root.Position=UDim2.new(0.5,0,0.5,0); root.AnchorPoint=Vector2.new(0.5,0.5)
root.ClipsDescendants=true; root.ZIndex=1; root.Visible=false; root.Parent=gui
mkCorner(root,CR); mkStroke(root,C.accent,0,1)

-- ═══════════════════════════════════════════════════════
-- DETACHED TEAM MANAGEMENT MENU DESIGN
-- ═══════════════════════════════════════════════════════
local WhitelistMenu = Instance.new("Frame")
local MenuTitle = Instance.new("TextLabel")
local ListScroll = Instance.new("ScrollingFrame")
local ListLayout = Instance.new("UIListLayout")

WhitelistMenu.Name = "AeroHub_TeamManager"
WhitelistMenu.Size = IsMobile and UDim2.fromOffset(210, 220) or UDim2.fromOffset(250, 310)
WhitelistMenu.Position = UDim2.new(0.5, IsMobile and 280 or 440, 0.5, -110)
WhitelistMenu.BackgroundColor3 = C.panel
WhitelistMenu.BorderSizePixel = 0
WhitelistMenu.Active = true
WhitelistMenu.Draggable = true
WhitelistMenu.Visible = false
WhitelistMenu.Parent = gui
mkCorner(WhitelistMenu, CR)
mkStroke(WhitelistMenu, C.accent, 0, 1)

MenuTitle.Size = UDim2.new(1, 0, 0, IsMobile and 26 or 34)
MenuTitle.BackgroundColor3 = C.topBar
MenuTitle.Text = "  EXCLUSION ROSTER"
MenuTitle.TextColor3 = C.text
MenuTitle.Font = FONT_BOL
MenuTitle.TextSize = TEXT_SIZE_BODY
MenuTitle.TextXAlignment = Enum.TextXAlignment.Left
MenuTitle.Parent = WhitelistMenu
local titleLine = Instance.new("Frame")
titleLine.Size = UDim2.new(1, 0, 0, 1)
titleLine.Position = UDim2.new(0, 0, 1, -1)
titleLine.BackgroundColor3 = C.accent
titleLine.BorderSizePixel = 0
titleLine.Parent = MenuTitle

ListScroll.Size = UDim2.new(1, -10, 1, IsMobile and -34 or -42)
ListScroll.Position = UDim2.new(0, 5, 0, IsMobile and 30 or 38)
ListScroll.BackgroundTransparency = 1
ListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
ListScroll.ScrollBarThickness = 3
ListScroll.ScrollBarImageColor3 = C.accent
ListScroll.Parent = WhitelistMenu

ListLayout.Parent = ListScroll
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 4)

local function UpdateWhitelistMenu()
	if not WhitelistMenu.Visible or StreamModeActive then return end
	for _, child in ipairs(ListScroll:GetChildren()) do
		if child:IsA("Frame") then child:Destroy() end
	end

	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LP then
			local Row = Instance.new("Frame")
			local NameLbl = Instance.new("TextLabel")
			local Toggle = Instance.new("TextButton")
			
			Row.Size = UDim2.new(1, -4, 0, IsMobile and 28 or 34)
			Row.BackgroundColor3 = C.row
			Row.BorderSizePixel = 0
			Row.Parent = ListScroll
			mkCorner(Row, CR_SM)
			mkStroke(Row, C.sep, 0.6, 1)
			
			NameLbl.Size = UDim2.new(0.65, -8, 1, 0)
			NameLbl.Position = UDim2.new(0, 6, 0, 0)
			NameLbl.Text = p.DisplayName ~= "" and p.DisplayName or p.Name
			NameLbl.TextColor3 = C.text
			NameLbl.Font = FONT
			NameLbl.TextSize = TEXT_SIZE_BODY - 1
			NameLbl.TextXAlignment = Enum.TextXAlignment.Left
			NameLbl.BackgroundTransparency = 1
			NameLbl.Parent = Row
			
			Toggle.Size = UDim2.new(0.32, 0, 0.75, 0)
			Toggle.Position = UDim2.new(0.66, 0, 0.125, 0)
			Toggle.Font = FONT_BOL
			Toggle.TextSize = TEXT_SIZE_BODY - 2
			Toggle.TextColor3 = C.text
			Toggle.BorderSizePixel = 0
			Toggle.Parent = Row
			mkCorner(Toggle, CR_SM)
			
			local function refreshBtnState()
				if WhitelistedPlayers[p.Name] then
					Toggle.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
					Toggle.Text = "FRIEND"
				else
					Toggle.BackgroundColor3 = C.toggleOff
					Toggle.Text = "TARGET"
				end
			end
			refreshBtnState()
			
			Toggle.Activated:Connect(function()
				WhitelistedPlayers[p.Name] = not WhitelistedPlayers[p.Name]
				refreshBtnState()
				for _, player in ipairs(Players:GetPlayers()) do updateESP(player) end
			end)
		end
	end
	ListScroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
end

Players.PlayerAdded:Connect(UpdateWhitelistMenu)
Players.PlayerRemoving:Connect(function(p)
	WhitelistedPlayers[p.Name] = nil
	UpdateWhitelistMenu()
end)

local function setTeamCheckMenuState(state)
	if StreamModeActive then WhitelistMenu.Visible = false return end
	WhitelistMenu.Visible = state
	if state then UpdateWhitelistMenu() end
end

-- ── PARTICLE LAYER ────────────────────────────────────
local ptLayer=Instance.new("Frame"); ptLayer.BackgroundTransparency=1
ptLayer.Size=UDim2.fromScale(1,1); ptLayer.ZIndex=2; ptLayer.Parent=root
local ptPool={}
local function spawnParticle()
	if #ptPool>=(IsMobile and 14 or 28) then return end
	local p=Instance.new("Frame")
	local sz=math.random(2,4)
	p.Size=UDim2.fromOffset(sz,sz)
	local xs=math.random()
	p.Position=UDim2.fromScale(xs,1.02)
	p.BackgroundColor3=math.random()<0.6 and C.accent or C.accentBrt
	p.BackgroundTransparency=math.random()*0.4+0.3
	p.BorderSizePixel=0; p.ZIndex=3
	mkCorner(p,UDim.new(1,0))
	p.Parent=ptLayer
	table.insert(ptPool,p)
	local life=math.random(35,75)/10
	local xDrift=(math.random()-0.5)*0.12
	TweenService:Create(p,TweenInfo.new(life,Enum.EasingStyle.Linear),{
		Position=UDim2.fromScale(xs+xDrift,-0.04),
		BackgroundTransparency=1,
	}):Play()
	task.delay(life,function()
		for i,v in ipairs(ptPool) do if v==p then table.remove(ptPool,i); break end end
		if p.Parent then p:Destroy() end
	end)
end
RunService.RenderStepped:Connect(function()
	if root.Visible and math.random()<0.045 then spawnParticle() end
end)

-- ── TOP BAR DRAGGING ──────────────────────────────────
local topBar=Instance.new("Frame"); topBar.Name="TopBar"; topBar.BackgroundColor3=C.topBar
topBar.BorderSizePixel=0; topBar.Size=UDim2.new(1,0,0,IsMobile and 36 or 44); topBar.ZIndex=10; topBar.Parent=root

local tbBorder=Instance.new("Frame"); tbBorder.Size=UDim2.new(1,0,0,1)
tbBorder.Position=UDim2.new(0,0,1,-1); tbBorder.BackgroundColor3=C.accent; tbBorder.BorderSizePixel=0; tbBorder.ZIndex=11; tbBorder.Parent=topBar

local tbLayout=Instance.new("UIListLayout"); tbLayout.FillDirection=Enum.FillDirection.Horizontal
tbLayout.VerticalAlignment=Enum.VerticalAlignment.Center; tbLayout.Padding=UDim.new(0,10)
tbLayout.SortOrder=Enum.SortOrder.LayoutOrder; tbLayout.Parent=topBar
mkPad(topBar,0,14,0,14)

local dragging,dragStart,dragOrigin=false,nil,nil
topBar.InputBegan:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
		dragging=true; dragStart=i.Position; dragOrigin=root.Position
		i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dragging=false end end)
	end
end)
UIS.InputChanged:Connect(function(i)
	if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
		local d=i.Position-dragStart
		root.Position=UDim2.new(dragOrigin.X.Scale,dragOrigin.X.Offset+d.X,dragOrigin.Y.Scale,dragOrigin.Y.Offset+d.Y)
	end
end)

local wCtrl=Instance.new("Frame"); wCtrl.BackgroundTransparency=1
wCtrl.Size=UDim2.fromOffset(56,14); wCtrl.LayoutOrder=1; wCtrl.Parent=topBar
local wl=Instance.new("UIListLayout"); wl.FillDirection=Enum.FillDirection.Horizontal
wl.Padding=UDim.new(0,6); wl.VerticalAlignment=Enum.VerticalAlignment.Center; wl.Parent=wCtrl

local winClose,winMin,winMax
for i,col in ipairs({Color3.fromRGB(255,75,55),Color3.fromRGB(255,185,55),Color3.fromRGB(55,200,75)}) do
	local d=Instance.new("TextButton"); d.Size=UDim2.fromOffset(10,10); d.BackgroundColor3=col
	d.Text=""; d.AutoButtonColor=false; mkCorner(d,UDim.new(1,0)); d.Parent=wCtrl
	if i==1 then winClose=d elseif i==2 then winMin=d else winMax=d end
end

mkLabel({Parent=topBar, Name="Title", Text="AERO HUB", Font=FONT_BOL, TextSize=TEXT_SIZE_BODY+1, TextColor=C.accentBrt, LayoutOrder=3, Size=UDim2.fromOffset(120,28)})

local brandLbl = Instance.new("TextLabel")
brandLbl.Name = "Brand"
brandLbl.BackgroundTransparency = 1
brandLbl.Text = "@strictlytech"
brandLbl.Font = FONT_MED
brandLbl.TextSize = TEXT_SIZE_BODY - 1
brandLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
brandLbl.TextXAlignment = Enum.TextXAlignment.Right
brandLbl.Size = UDim2.fromOffset(100, 30)
brandLbl.Position = UDim2.new(1, -14, 0, 0)
brandLbl.AnchorPoint = Vector2.new(1, 0)
brandLbl.ZIndex = 15
brandLbl.Parent = topBar

-- ── INTERFACE BODY FRAMEWORK ──────────────────────────
local body=Instance.new("Frame"); body.BackgroundTransparency=1; body.Name="Body"
body.Size=UDim2.new(1,0,1,IsMobile and -36 or -44); body.Position=UDim2.fromOffset(0,IsMobile and 36 or 44); body.ZIndex=4; body.Parent=root

local sidebar=Instance.new("Frame"); sidebar.Name="Sidebar"; sidebar.BackgroundColor3=C.sidebarBg
sidebar.BorderSizePixel=0; sidebar.Size=UDim2.new(0,SW,1,0); sidebar.ZIndex=5; sidebar.Parent=body

local sbLine=Instance.new("Frame"); sbLine.Size=UDim2.new(0,1,1,0); sbLine.Position=UDim2.new(1,-1,0,0)
sbLine.BackgroundColor3=C.accent; sbLine.BackgroundTransparency=0.2; sbLine.BorderSizePixel=0; sbLine.Parent=sidebar

local sbScroll=Instance.new("ScrollingFrame"); sbScroll.BackgroundTransparency=1; sbScroll.BorderSizePixel=0
sbScroll.Size=UDim2.fromScale(1,1); sbScroll.CanvasSize=UDim2.new(0,0,0,0)
sbScroll.ScrollBarThickness=2; sbScroll.ScrollBarImageColor3=C.accent
sbScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y; sbScroll.Parent=sidebar
mkPad(sbScroll,6,6,6,6)

local sbLL=Instance.new("UIListLayout"); sbLL.Padding=UDim.new(0,3); sbLL.SortOrder=Enum.SortOrder.LayoutOrder; sbLL.Parent=sbScroll

local brandBlock = Instance.new("Frame")
brandBlock.Name = "BrandBlock"
brandBlock.BackgroundTransparency = 1
brandBlock.Size = UDim2.new(1, 0, 0, IsMobile and 42 or 58)
brandBlock.LayoutOrder = 0
brandBlock.Parent = sbScroll

local brandLL = Instance.new("UIListLayout")
brandLL.Padding = UDim.new(0, 2)
brandLL.SortOrder = Enum.SortOrder.LayoutOrder
brandLL.Parent = brandBlock

local versionLbl = Instance.new("TextLabel")
versionLbl.Name = "Version"
versionLbl.BackgroundTransparency = 1
versionLbl.Text = "AERO HUB"
versionLbl.Font = FONT_BOL
versionLbl.TextSize = TEXT_SIZE_HEADER
versionLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
versionLbl.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
versionLbl.TextStrokeTransparency = 0.35
versionLbl.TextXAlignment = Enum.TextXAlignment.Left
versionLbl.Size = UDim2.new(1, 0, 0, IsMobile and 18 or 26)
versionLbl.LayoutOrder = 1
versionLbl.Parent = brandBlock

local navBtns={}
local activeNav=nil
local function setNavActive(btn)
	if activeNav then
		activeNav.BackgroundColor3=Color3.fromRGB(0,0,0); activeNav.BackgroundTransparency=1
		activeNav.TextColor3=C.textDim
		local s=activeNav:FindFirstChildOfClass("UIStroke"); if s then s.Color=C.sep; s.Transparency=0.6 end
	end
	activeNav=btn; btn.BackgroundColor3=C.activeDim; btn.BackgroundTransparency=0; btn.TextColor3=C.accentBrt
	local s=btn:FindFirstChildOfClass("UIStroke"); if s then s.Color=C.accentBrt; s.Transparency=0 end
end

local function mkNav(text,lo,onClick)
	local btn=Instance.new("TextButton"); btn.Name=text:gsub(" ",""); btn.LayoutOrder=lo
	btn.Size=UDim2.new(1,0,0,IsMobile and 24 or 30); btn.BackgroundColor3=Color3.fromRGB(0,0,0); btn.BackgroundTransparency=1
	btn.Font=FONT_MED; btn.TextSize=TEXT_SIZE_BODY - 1; btn.Text=" "..text; btn.TextColor3=C.textDim
	btn.TextXAlignment=Enum.TextXAlignment.Left; btn.AutoButtonColor=false
	mkCorner(btn,CR_SM); mkStroke(btn,C.sep,0.6,1); btn.Parent=sbScroll
	navBtns[text]=btn
	btn.MouseButton1Click:Connect(function() setNavActive(btn); if onClick then onClick() end end)
	return btn
end

local function mkNavHdr(text,lo)
	mkLabel({Parent=sbScroll,Text=text,Font=FONT_BOL,TextSize=TEXT_SIZE_BODY-3,TextColor=C.accent,LayoutOrder=lo,Size=UDim2.new(1,0,0,16)})
end

mkNavHdr("COMBAT", 1); mkNav("Aimbot", 2)
mkSep(sbScroll,3)
mkNavHdr("MOVEMENT", 4); mkNav("Infinite Jump", 5)
mkSep(sbScroll,6)
mkNavHdr("VISUALS", 7); mkNav("ESP", 8)
mkSep(sbScroll,9)
mkNavHdr("UTILITIES", 10); mkNav("Misc", 11)
mkSep(sbScroll,12)
mkNavHdr("SETTINGS", 13); mkNav("Config", 14); mkNav("Keybinds", 15)

local main=Instance.new("Frame"); main.Name="Main"; main.BackgroundColor3=C.panel
main.BorderSizePixel=0; main.Size=UDim2.new(1,-SW,1,0); main.Position=UDim2.fromOffset(SW,0); main.ZIndex=4; main.Parent=body

local mainScroll=Instance.new("ScrollingFrame"); mainScroll.BackgroundTransparency=1; mainScroll.BorderSizePixel=0
mainScroll.Size=UDim2.fromScale(1,1); mainScroll.CanvasSize=UDim2.new(0,0,0,0)
mainScroll.ScrollBarThickness=2; mainScroll.ScrollBarImageColor3=C.accent
mainScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y; mainScroll.Parent=main
mkPad(mainScroll,10,12,10,12)

local mainLL=Instance.new("UIListLayout"); mainLL.Padding=UDim.new(0,8); mainLL.SortOrder=Enum.SortOrder.LayoutOrder; mainLL.Parent=mainScroll

local function secHead(text,order)
	return mkLabel({Parent=mainScroll,Text=text:upper(),Font=FONT_BOL,TextSize=TEXT_SIZE_BODY-2,TextColor=C.accent,LayoutOrder=order,Size=UDim2.new(1,0,0,16)})
end

local function mkRow(title,lo,h)
	local f=Instance.new("Frame"); f.Name=title; f.BackgroundColor3=C.row; f.BorderSizePixel=0
	f.Size=UDim2.new(1,0,0,h or ROW_HEIGHT); f.LayoutOrder=lo; f.Parent=mainScroll
	mkCorner(f,CR); mkStroke(f,C.sep,0.45,1); mkPad(f,6,10,6,10); return f
end

local registeredVisualToggles = {}

local function createToggleProps(props)
	local row=mkRow(props.title,props.layoutOrder,ROW_HEIGHT)
	local info=Instance.new("Frame"); info.BackgroundTransparency=1; info.Size=UDim2.new(1,-52,1,0); info.Parent=row
	mkLabel({Parent=info,Text=props.title,Font=FONT_MED,TextSize=TEXT_SIZE_BODY,Position=UDim2.fromOffset(0,0),Size=UDim2.new(1,0,0,16)})
	mkLabel({Parent=info,Text=props.desc or "",TextSize=TEXT_SIZE_BODY-2,TextColor=C.textDim,Position=UDim2.fromOffset(0,16),Size=UDim2.new(1,0,0,14)})
	
	local track=Instance.new("TextButton"); track.AnchorPoint=Vector2.new(1,0.5); track.Position=UDim2.new(1,0,0.5,0)
	track.Size=UDim2.fromOffset(38,18); track.Text=""; track.AutoButtonColor=false; mkCorner(track,UDim.new(1,0)); track.Parent=row
	local knob=Instance.new("Frame"); knob.Size=UDim2.fromOffset(13,13); knob.BorderSizePixel=0; mkCorner(knob,UDim.new(1,0)); knob.Parent=track
	
	local on = props.default == true
	local function paint()
		track.BackgroundColor3 = on and C.accent or C.toggleOff
		knob.Position = on and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,2,0.5,-6)
		knob.BackgroundColor3 = C.text
	end
	paint()
	
	track.MouseButton1Click:Connect(function()
		on = not on; paint()
		TweenService:Create(knob,TweenInfo.new(0.12,Enum.EasingStyle.Quad),{Position=on and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,2,0.5,-6)}):Play()
		if props.onChange then props.onChange(on) end
	end)
	
	registeredVisualToggles[props.title] = function(forcedValue)
		on = forcedValue
		paint()
	end
	return row
end

local function createDropdown(props)
	local row=mkRow(props.title,props.layoutOrder,ROW_HEIGHT+6)
	mkLabel({Parent=row,Text=props.title,Font=FONT_MED,TextSize=TEXT_SIZE_BODY,Position=UDim2.fromOffset(0,0),Size=UDim2.new(1,-110,0,16)})
	
	local btn=Instance.new("TextButton"); btn.AnchorPoint=Vector2.new(1,0.5); btn.Position=UDim2.new(1,0,0.5,0)
	btn.Size=UDim2.fromOffset(100,22); btn.BackgroundColor3=C.activeDim; btn.Font=FONT; btn.TextSize=TEXT_SIZE_BODY-1
	btn.Text=" "..tostring(props.default).." ▾"; btn.TextColor3=C.text; btn.TextXAlignment=Enum.TextXAlignment.Left
	btn.AutoButtonColor=false; mkCorner(btn,CR_SM); mkStroke(btn,C.accent,0,1); btn.Parent=row
	
	local open=false; local mr
	local function closeM() open=false; if mr then mr:Destroy(); mr=nil end end
	local function openM()
		closeM(); open=true
		local opts=props.options or {}; local iH,pV = 22,2; local cnt=#opts
		local cH=cnt*iH+math.max(0,cnt-1)*2+pV*2; local mH=math.min(cH,130)
		local ap=btn.AbsolutePosition; local as=btn.AbsoluteSize; local ga=gui.AbsolutePosition
		
		mr=Instance.new("Frame"); mr.BackgroundTransparency=1; mr.Size=UDim2.fromOffset(as.X,mH+4)
		mr.Position=UDim2.fromOffset(ap.X-ga.X,ap.Y-ga.Y+as.Y+4); mr.ZIndex=220; mr.Parent=gui
		
		local menu=Instance.new("ScrollingFrame"); menu.BackgroundColor3=Color3.fromRGB(16,2,2); menu.BorderSizePixel=0
		menu.Size=UDim2.new(1,0,1,0); menu.CanvasSize=UDim2.fromOffset(0,cH); menu.ScrollBarThickness=2
		menu.ScrollBarImageColor3=C.accent; menu.ZIndex=221; menu.ClipsDescendants=true; menu.Parent=mr
		mkCorner(menu,CR_SM); mkStroke(menu,C.accent,0,1); mkPad(menu,pV,4,pV,4)
		
		local ml=Instance.new("UIListLayout"); ml.Padding=UDim.new(0,2); ml.SortOrder=Enum.SortOrder.LayoutOrder; ml.Parent=menu
		for i,o in ipairs(opts) do
			local ob=Instance.new("TextButton"); ob.LayoutOrder=i; ob.Size=UDim2.new(1,0,0,iH)
			ob.BackgroundTransparency=1; ob.BackgroundColor3=C.activeDim; ob.Font=FONT; ob.TextSize=TEXT_SIZE_BODY-1
			ob.Text=" "..tostring(o); ob.TextColor3=C.text; ob.TextXAlignment=Enum.TextXAlignment.Left
			ob.AutoButtonColor=false; ob.ZIndex=222; ob.Parent=menu
			ob.MouseButton1Click:Connect(function() btn.Text=" "..tostring(o).." ▾"; closeM(); if props.onSelect then props.onSelect(o) end end)
		end
	end
	btn.MouseButton1Click:Connect(function() if open then closeM() else openM() end end)
	return {Close=closeM}
end

local dropdowns={}
local function clearContent()
	for _,d in ipairs(dropdowns) do if d and d.Close then d.Close() end end; dropdowns={}
	for _,ch in ipairs(mainScroll:GetChildren()) do
		if ch:IsA("Frame") or ch:IsA("TextLabel") then ch:Destroy() end
	end
	mainScroll.CanvasPosition=Vector2.zero
end

-- ── DYNAMIC KEYBINDS LAYOUTS ──────────────────────────
local listeningFor=nil
local kbBtns={}

local function createKeybindRow(props)
	local id = props.id
	local bind = Keybinds[id]
	local row = mkRow(bind.label, props.layoutOrder, ROW_HEIGHT)
	row.Name = id
	
	local info=Instance.new("Frame"); info.BackgroundTransparency=1; info.Size=UDim2.new(1,-160,1,0); info.Parent=row
	mkLabel({Parent=info,Text=props.title or bind.label,Font=FONT_MED,TextSize=TEXT_SIZE_BODY,Position=UDim2.fromOffset(0,0),Size=UDim2.new(1,0,0,16)})
	mkLabel({Parent=info,Name="CK",Text="Key: "..keyName(bind.key),TextSize=TEXT_SIZE_BODY-2,TextColor=C.textDim,Position=UDim2.fromOffset(0,18),Size=UDim2.new(1,0,0,14)})
	
	local hb=Instance.new("TextButton"); hb.AnchorPoint=Vector2.new(1,0.5); hb.Position=UDim2.new(1,0,0.5,0)
	hb.Size=UDim2.fromOffset(56,20); hb.Font=FONT; hb.TextSize=TEXT_SIZE_BODY-2
	hb.Text=bind.holdMode and "HOLD" or "TOGGLE"; hb.BackgroundColor3=bind.holdMode and C.accent or Color3.fromRGB(38,8,8)
	hb.TextColor3=C.text; hb.AutoButtonColor=false; mkCorner(hb,CR_SM); hb.Parent=row
	hb.MouseButton1Click:Connect(function()
		bind.holdMode=not bind.holdMode
		hb.Text=bind.holdMode and "HOLD" or "TOGGLE"; hb.BackgroundColor3=bind.holdMode and C.accent or Color3.fromRGB(38,8,8)
	end)
	
	local kb=Instance.new("TextButton"); kb.AnchorPoint=Vector2.new(1,0.5); kb.Position=UDim2.new(1,-62,0.5,0)
	kb.Size=UDim2.fromOffset(56,20); kb.Font=FONT_MED; kb.TextSize=TEXT_SIZE_BODY-1
	kb.Text=keyName(bind.key); kb.BackgroundColor3=Color3.fromRGB(28,4,4); kb.TextColor3=C.text; kb.AutoButtonColor=false
	mkCorner(kb,CR_SM); mkStroke(kb,C.accent,0,1); kb.Parent=row; kbBtns[id]=kb
	
	kb.MouseButton1Click:Connect(function()
		if listeningFor==id then
			listeningFor=nil; kb.Text=keyName(bind.key); kb.BackgroundColor3=Color3.fromRGB(28,4,4)
		else
			if listeningFor and kbBtns[listeningFor] then
				kbBtns[listeningFor].Text=keyName(Keybinds[listeningFor].key)
				kbBtns[listeningFor].BackgroundColor3=Color3.fromRGB(28,4,4)
			end
			listeningFor=id; kb.Text="[...]"; kb.BackgroundColor3=C.activeDim
		end
	end)
	return row
end

-- ── CONFIG LOAD/SAVE ──────────────────────────────────
local configName = "AeroHub_Config.json"

local function syncMobileVisuals()
	if registeredVisualToggles["Aimbot"] then registeredVisualToggles["Aimbot"](State.aimbot) end
	if registeredVisualToggles["ESP"] then registeredVisualToggles["ESP"](State.esp) end
	if registeredVisualToggles["Infinite Jump"] then registeredVisualToggles["Infinite Jump"](State.infiniteJump) end
	if registeredVisualToggles["Stream Mode"] then registeredVisualToggles["Stream Mode"](State.streamMode) end
end

local function saveConfig()
	local data = { State = State, Keybinds = {} }
	for k,v in pairs(Keybinds) do
		data.Keybinds[k] = { keyName = v.key.Name, keyType = tostring(v.key.EnumType), holdMode = v.holdMode }
	end
	if writefile then
		local s,e = pcall(function() writefile(configName, HttpService:JSONEncode(data)) end)
		if s then showToast("Config saved!") else showToast("Error saving config!") end
	else
		showToast("Executor lacks writefile support!")
	end
end

local floatBtn

local function applyStreamMode(active)
	StreamModeActive = active
	State.streamMode = active
	
	if active then
		removeAllESP()
		root.Visible = false
		WhitelistMenu.Visible = false
		if floatBtn then floatBtn.Visible = false end
		
		local mobGui = PGui:FindFirstChild("RFunMobileBinds")
		if mobGui then mobGui.Enabled = false end
	else
		if floatBtn then floatBtn.Visible = true end
		local mobGui = PGui:FindFirstChild("RFunMobileBinds")
		if mobGui then mobGui.Enabled = true end
		
		if Features.espEnabled then startESPLoop() end
	end
end

local function loadConfig(silent)
	if readfile and isfile and isfile(configName) then
		local success, data = pcall(function() return HttpService:JSONDecode(readfile(configName)) end)
		if success and data then
			if data.State then
				for k,v in pairs(data.State) do
					if type(v)=="table" and type(State[k])=="table" then
						for k2,v2 in pairs(v) do State[k][k2] = v2 end
					else
						State[k] = v
					end
				end
				Features.setInfiniteJump(State.infiniteJump)
				Features.setESP(State.esp)
				for k,v in pairs(State.espSettings) do Features.setESPSetting(k,v) end
				Features.setAimbot(State.aimbot)
				for k,v in pairs(State.aimbotSettings) do Features.aimbotSettings[k] = v end
				applyStreamMode(State.streamMode)
				syncMobileVisuals()
			end
			if data.Keybinds then
				for k,v in pairs(data.Keybinds) do
					if Keybinds[k] then
						Keybinds[k].holdMode = v.holdMode
						if v.keyType == tostring(Enum.KeyCode) and Enum.KeyCode[v.keyName] then
							Keybinds[k].key = Enum.KeyCode[v.keyName]
						elseif v.keyType == tostring(Enum.UserInputType) and Enum.UserInputType[v.keyName] then
							Keybinds[k].key = Enum.UserInputType[v.keyName]
						end
					end
				end
			end
			if not silent then showToast("Config loaded!") end
		else
			if not silent then showToast("Failed to parse config file!") end
		end
	else
		if not silent then showToast("No config file found or executor unsupported!") end
	end
end

-- ── PAGE RENDERERS ────────────────────────────────────
local function renderConfig()
	clearContent(); local lo=1
	secHead("Config",lo); lo+=1
	createToggleProps({title="Auto Load Config",desc="Load automatically when script starts",layoutOrder=lo,default=State.autoLoadConfig,onChange=function(on) State.autoLoadConfig=on end}); lo+=1
	createToggleProps({title="Save Configuration", desc="Saves settings to " .. configName, buttonText="SAVE", layoutOrder=lo, onClick=saveConfig}); lo+=1
	createToggleProps({title="Load Configuration", desc="Loads settings from " .. configName, buttonText="LOAD", layoutOrder=lo, onClick=function() loadConfig(false) end}); lo+=1
end

local function renderKeybinds()
	clearContent(); local lo=1
	secHead("Keybinds",lo); lo+=1
	if IsMobile then
		mkLabel({Parent=mainScroll,Text="Keybind system active for keyboard mapping overlay.",TextSize=10,TextColor=C.textDim,LayoutOrder=lo,Size=UDim2.new(1,0,0,16)}); lo+=1
	else
		mkLabel({Parent=mainScroll,Text="Click a button, then press any key to reassign.",TextSize=10,TextColor=C.textDim,LayoutOrder=lo,Size=UDim2.new(1,0,0,16)}); lo+=1
	end
	mkSep(mainScroll,lo); lo+=1
	createKeybindRow({id="aimbot", layoutOrder=lo}); lo+=1
	createKeybindRow({id="esp", layoutOrder=lo}); lo+=1
	createKeybindRow({id="infiniteJump", layoutOrder=lo}); lo+=1
end

local function renderInfiniteJump()
	clearContent(); local lo=1
	secHead("Movement",lo); lo+=1
	createToggleProps({title="Infinite Jump",desc="Jump again while in the air",layoutOrder=lo,default=State.infiniteJump,
		onChange=function(on) State.infiniteJump=on; Features.setInfiniteJump(on); showToast("Infinite Jump: "..(on and "ON" or "OFF")) end})
end

local function renderESP()
	clearContent(); local lo=1
	secHead("Visuals",lo); lo+=1
	createToggleProps({title="ESP",desc="See enemies through walls",layoutOrder=lo,default=State.esp,
		onChange=function(on) State.esp=on; Features.setESP(on); showToast("ESP: "..(on and "ON" or "OFF")) end}); lo+=1
	mkSep(mainScroll,lo); lo+=1; secHead("ESP Settings",lo); lo+=1
	createToggleProps({title="Box",desc="Outline around enemy model",layoutOrder=lo,default=State.espSettings.Box,onChange=function(on) State.espSettings.Box=on; Features.setESPSetting("Box",on) end}); lo+=1
	createToggleProps({title="Box Filled",desc="Fill highlight over player model",layoutOrder=lo,default=State.espSettings.BoxFilled,onChange=function(on) State.espSettings.BoxFilled=on; Features.setESPSetting("BoxFilled",on) end}); lo+=1
	createToggleProps({title="Name",desc="Show name tag above player",layoutOrder=lo,default=State.espSettings.Name,onChange=function(on) State.espSettings.Name=on; Features.setESPSetting("Name",on) end}); lo+=1
	createToggleProps({title="Distance",desc="Show distance in studs",layoutOrder=lo,default=State.espSettings.Distance,onChange=function(on) State.espSettings.Distance=on; Features.setESPSetting("Distance",on) end}); lo+=1
	createToggleProps({title="Team Check",desc="Skip teammates & exclusions",layoutOrder=lo,default=State.espSettings.TeamCheck,
		onChange=function(on) State.espSettings.TeamCheck=on; Features.setESPSetting("TeamCheck",on); setTeamCheckMenuState(on or State.aimbotSettings.TeamCheck) end})
end

local function renderAimbot()
	clearContent(); local lo=1
	secHead("Combat",lo); lo+=1
	createToggleProps({title="Aimbot",desc="Auto-lock camera view angle to the nearest opponent tracking node",layoutOrder=lo,default=State.aimbot,
		onChange=function(on) State.aimbot=on; Features.setAimbot(on); showToast("Aimbot: "..(on and "ON" or "OFF")) end}); lo+=1
	mkSep(mainScroll,lo); lo+=1; secHead("Aimbot Settings",lo); lo+=1
	
	createToggleProps({title="Team Check",desc="Skip teammates & exclusions",layoutOrder=lo,default=State.aimbotSettings.TeamCheck,
		onChange=function(on) State.aimbotSettings.TeamCheck=on; Features.aimbotSettings.TeamCheck=on; setTeamCheckMenuState(on or State.espSettings.TeamCheck) end}); lo+=1
		
	createToggleProps({title="Wall Check",desc="Verify targeting visibility vector via raycast obstruction scan",layoutOrder=lo,default=State.aimbotSettings.WallCheck,
		onChange=function(on) State.aimbotSettings.WallCheck=on; Features.aimbotSettings.WallCheck=on end}); lo+=1

	createToggleProps({title="Target NPCs",desc="Include custom workspace non-player entities in target validation",layoutOrder=lo,default=State.aimbotSettings.TargetNPCs,
		onChange=function(on) State.aimbotSettings.TargetNPCs=on; Features.aimbotSettings.TargetNPCs=on end}); lo+=1

	local dd_part=createDropdown({title="Target Part",desc="Which body part segment to lock onto",layoutOrder=lo,default=State.aimbotSettings.TargetPart,
		options={"Head","HumanoidRootPart"},
		onSelect=function(o) State.aimbotSettings.TargetPart=o; Features.aimbotSettings.TargetPart=o end})
	table.insert(dropdowns,dd_part)
end

local function renderMisc()
	clearContent(); local lo=1
	secHead("Utilities", lo); lo+=1
	
	createToggleProps({
		title="Stream Mode", 
		desc="Hides all UI overlays & indicators from streaming apps capture tools", 
		layoutOrder=lo, 
		default=State.streamMode,
		onChange=function(on) applyStreamMode(on) end
	})
end

navBtns["Aimbot"].MouseButton1Click:Connect(renderAimbot)
navBtns["Infinite Jump"].MouseButton1Click:Connect(renderInfiniteJump)
navBtns["ESP"].MouseButton1Click:Connect(renderESP)
navBtns["Misc"].MouseButton1Click:Connect(renderMisc)
navBtns["Config"].MouseButton1Click:Connect(renderConfig)
navBtns["Keybinds"].MouseButton1Click:Connect(renderKeybinds)

task.defer(function()
	setNavActive(navBtns["Aimbot"])
	renderAimbot()
end)

local savedMouseBehavior = Enum.MouseBehavior.LockCenter
local function openPanel()
	if StreamModeActive then return end
	savedMouseBehavior = UIS.MouseBehavior
	UIS.MouseBehavior = Enum.MouseBehavior.Default
	UIS.MouseIconEnabled = true
	root.Visible = true
	if State.aimbotSettings.TeamCheck or State.espSettings.TeamCheck then WhitelistMenu.Visible = true; UpdateWhitelistMenu() end
end
local function closePanel()
	root.Visible = false
	WhitelistMenu.Visible = false
	UIS.MouseBehavior = savedMouseBehavior
	UIS.MouseIconEnabled = false
end
local function togglePanel() if root.Visible then closePanel() else openPanel() end end

floatBtn = Instance.new("TextButton")
floatBtn.Name = "RFunFloat"
floatBtn.Size = UDim2.fromOffset(40, 40)
floatBtn.Position = UDim2.new(0, 20, 0.5, -20)
floatBtn.BackgroundColor3 = C.panel
floatBtn.Text = "AH"
floatBtn.Font = FONT_BOL
floatBtn.TextSize = 14
floatBtn.TextColor3 = C.accentBrt
floatBtn.BorderSizePixel = 0
floatBtn.ZIndex = 100
floatBtn.Parent = gui
mkCorner(floatBtn, UDim.new(1,0))
mkStroke(floatBtn, C.accent, 0, 1.5)

local floatDrag, floatStartPos, floatStartInput = false, nil, nil
floatBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		floatDrag = true
		floatStartPos = floatBtn.Position
		floatStartInput = input.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				floatDrag = false
				if (input.Position - floatStartInput).Magnitude < 5 then togglePanel() end
			end
		end)
	end
end)
UIS.InputChanged:Connect(function(input)
	if floatDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - floatStartInput
		floatBtn.Position = UDim2.new(floatStartPos.X.Scale, floatStartPos.X.Offset + delta.X, floatStartPos.Y.Scale, floatStartPos.Y.Offset + delta.Y)
	end
end)

if IsMobile then
	local mobGui = Instance.new("ScreenGui")
	mobGui.Name = "RFunMobileBinds"
	mobGui.ResetOnSpawn = false
	mobGui.IgnoreGuiInset = true
	mobGui.Parent = PGui
	
	local btnContainer = Instance.new("Frame")
	btnContainer.Name = "BtnContainer"
	btnContainer.Size = UDim2.fromOffset(65, 220)
	btnContainer.Position = UDim2.new(1, -85, 0.5, -110)
	btnContainer.BackgroundTransparency = 1
	btnContainer.Parent = mobGui
	
	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Vertical
	layout.Padding = UDim.new(0, 12)
	layout.VerticalAlignment = Enum.VerticalAlignment.Center
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = btnContainer
	
	local dynamicMobileButtons = {}
	
	local function createMobileShortcut(name, labelText, toggleStateKey, layoutOrder, actionCallback)
		local b = Instance.new("TextButton")
		b.Name = name
		b.Size = UDim2.fromOffset(52, 52)
		b.Font = FONT_BOL
		b.TextSize = 11
		b.Text = labelText
		b.LayoutOrder = layoutOrder
		b.AutoButtonColor = false
		mkCorner(b, UDim.new(1, 0))
		local str = mkStroke(b, C.accent, 0.4, 1.5)
		b.Parent = btnContainer
		
		local function updateVisualState()
			local active = State[toggleStateKey]
			b.BackgroundColor3 = active and C.activeDim or Color3.fromRGB(12, 2, 2)
			b.TextColor3 = active and C.accentBrt or C.textDim
			str.Color = active and C.accentBrt or C.accent
		end
		
		updateVisualState()
		
		b.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Touch then
				if Keybinds[toggleStateKey] and Keybinds[toggleStateKey].holdMode then
					actionCallback(true)
					State[toggleStateKey] = true
					updateVisualState()
					syncMobileVisuals()
				else
					State[toggleStateKey] = not State[toggleStateKey]
					actionCallback(State[toggleStateKey])
					updateVisualState()
					syncMobileVisuals()
					showToast(labelText .. ": " .. (State[toggleStateKey] and "ON" or "OFF"))
				end
			end
		end)
		
		if Keybinds[toggleStateKey] and Keybinds[toggleStateKey].holdMode then
			b.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.Touch then
					actionCallback(false)
					State[toggleStateKey] = false
					updateVisualState()
					syncMobileVisuals()
				end
			end)
		end
		
		dynamicMobileButtons[toggleStateKey] = updateVisualState
	end
	
	createMobileShortcut("AimShort", "AIM", "aimbot", 1, function(on) Features.setAimbot(on) end)
	createMobileShortcut("EspShort", "ESP", "esp", 2, function(on) Features.setESP(on) end)
	createMobileShortcut("JumpShort", "JUMP", "infiniteJump", 3, function(on) Features.setInfiniteJump(on) end)
	
	RunService.RenderStepped:Connect(function()
		if StreamModeActive then return end
		if dynamicMobileButtons["aimbot"] then dynamicMobileButtons["aimbot"]() end
		if dynamicMobileButtons["esp"] then dynamicMobileButtons["esp"]() end
		if dynamicMobileButtons["infiniteJump"] then dynamicMobileButtons["infiniteJump"]() end
	end)
end

if winClose then winClose.MouseButton1Click:Connect(closePanel) end
if winMin then winMin.MouseButton1Click:Connect(closePanel) end
if winMax then winMax.MouseButton1Click:Connect(openPanel) end

UIS.InputBegan:Connect(function(input, processed)
	if processed then return end
	if listeningFor then
		local isKey = input.UserInputType == Enum.UserInputType.Keyboard
		local isMouse = input.UserInputType.Name:match("MouseButton")
		if isKey or isMouse then
			local id=listeningFor; local bind=Keybinds[id]
			bind.key = isKey and input.KeyCode or input.UserInputType; listeningFor=nil
			local kb=kbBtns[id]
			if kb then kb.Text=keyName(bind.key); kb.BackgroundColor3=Color3.fromRGB(28,4,4) end
			local row=mainScroll:FindFirstChild(id)
			if row then local inf=row:FindFirstChildOfClass("Frame"); if inf then local lbl=inf:FindFirstChild("CK"); if lbl then lbl.Text="Key: "..keyName(bind.key) end end end
			showToast(bind.label.." → "..keyName(bind.key))
			return
		end
	end
	
	for id,bind in pairs(Keybinds) do
		local match = false
		if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == bind.key then match = true end
		if input.UserInputType.Name:match("MouseButton") and input.UserInputType == bind.key then match = true end
		if match then
			if bind.holdMode then
				if id=="aimbot" then Features.setAimbot(true)
				elseif id=="esp" then Features.setESP(true)
				elseif id=="infiniteJump" then Features.setInfiniteJump(true) end
			else
				if id=="aimbot" then State.aimbot=not State.aimbot; Features.setAimbot(State.aimbot); showToast("Aimbot: "..(State.aimbot and "ON" or "OFF"))
				elseif id=="esp" then State.esp=not State.esp; Features.setESP(State.esp); showToast("ESP: "..(State.esp and "ON" or "OFF"))
				elseif id=="infiniteJump" then State.infiniteJump=not State.infiniteJump; Features.setInfiniteJump(State.infiniteJump); showToast("Inf Jump: "..(State.infiniteJump and "ON" or "OFF")) end
			end
			syncMobileVisuals()
		end
	end
	
	if input.KeyCode==Enum.KeyCode.RightShift or input.KeyCode==Enum.KeyCode.F9 then togglePanel() end
end)

UIS.InputEnded:Connect(function(input)
	for id,bind in pairs(Keybinds) do
		local match = false
		if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == bind.key then match = true end
		if input.UserInputType.Name:match("MouseButton") and input.UserInputType == bind.key then match = true end
		if bind.holdMode and match then
			if id=="aimbot" then Features.setAimbot(false)
			elseif id=="esp" then Features.setESP(false)
			elseif id=="infiniteJump" then Features.setInfiniteJump(false) end
			syncMobileVisuals()
		end
	end
end)

task.delay(1.5,function() showToast("Aero Hub · RightShift / F9 or Floating Button to open") end)
print("[Aero Hub] Engine Core Loop Rebuilt & Loaded.")

if readfile and isfile and isfile(configName) then
	local success, data = pcall(function() return HttpService:JSONDecode(readfile(configName)) end)
	if success and data and data.State and data.State.autoLoadConfig then loadConfig(true) end
end