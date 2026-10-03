local Wayae = getgenv().Wayae
local player = Wayae.player
local playerGui = player:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

if playerGui:FindFirstChild("WayaeHUB") then
    playerGui:FindFirstChild("WayaeHUB"):Destroy()
end

-- Elegant Color Palette
local Colors = {
    Background = Color3.fromRGB(15, 15, 18),
    Button = Color3.fromRGB(28, 28, 34),
    ButtonHover = Color3.fromRGB(42, 42, 50),
    Accent = Color3.fromRGB(138, 90, 255),
    RedAccent = Color3.fromRGB(220, 60, 80),
    Text = Color3.fromRGB(250, 250, 255),
    SubText = Color3.fromRGB(170, 170, 180),
    Stroke = Color3.fromRGB(45, 45, 55)
}

-- UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WayaeHUB"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = playerGui

-- Main Window
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Size = UDim2.new(0.85, 0, 0.75, 0)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Colors.Background
MainFrame.BackgroundTransparency = 0.1 -- Glassy look
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UIConstraint = Instance.new("UISizeConstraint")
UIConstraint.MaxSize = Vector2.new(380, 420)
UIConstraint.Parent = MainFrame

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Colors.Stroke
UIStroke.Thickness = 1
UIStroke.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundTransparency = 1
TitleBar.Parent = MainFrame

local TitleLine = Instance.new("Frame")
TitleLine.Size = UDim2.new(1, 0, 0, 1)
TitleLine.Position = UDim2.new(0, 0, 1, 0)
TitleLine.BackgroundColor3 = Colors.Stroke
TitleLine.BorderSizePixel = 0
TitleLine.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -60, 1, 0)
TitleText.Position = UDim2.new(0, 20, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "WAYAE HUB"
TitleText.TextColor3 = Colors.Text
TitleText.TextSize = 14
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 7)
CloseBtn.BackgroundColor3 = Colors.Background
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Colors.SubText
CloseBtn.Font = Enum.Font.GothamMedium
CloseBtn.TextSize = 16
CloseBtn.Parent = TitleBar

CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {TextColor3 = Colors.RedAccent}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {TextColor3 = Colors.SubText}):Play()
end)

-- Toggle Button (Floating Logo)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleWayaeHUB"
ToggleBtn.Size = UDim2.new(0, 46, 0, 46)
ToggleBtn.Position = UDim2.new(0.5, -23, 0, 15)
ToggleBtn.BackgroundColor3 = Colors.Background
ToggleBtn.Text = "🦅"
ToggleBtn.TextColor3 = Colors.Text
ToggleBtn.TextSize = 20
ToggleBtn.Visible = false
ToggleBtn.Active = true
ToggleBtn.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleBtn

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Colors.Accent
ToggleStroke.Thickness = 1.5
ToggleStroke.Parent = ToggleBtn

-- Glowing effect
task.spawn(function()
    while true do
        TweenService:Create(ToggleStroke, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Color = Colors.RedAccent}):Play()
        task.wait(1)
        TweenService:Create(ToggleStroke, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Color = Colors.Accent}):Play()
        task.wait(1)
    end
end)

-- Dragging logic for ToggleBtn
local dragActive, isDragging, dragStartPos, dragStartBtnPos = false, false, nil, nil
local DRAG_THRESHOLD = 8
ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragActive = true; dragStartPos = input.Position; dragStartBtnPos = ToggleBtn.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if not dragActive or not dragStartPos then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStartPos
        if math.abs(delta.X) > DRAG_THRESHOLD or math.abs(delta.Y) > DRAG_THRESHOLD then
            isDragging = true
            ToggleBtn.Position = UDim2.new(dragStartBtnPos.X.Scale, dragStartBtnPos.X.Offset + delta.X, dragStartBtnPos.Y.Scale, dragStartBtnPos.Y.Offset + delta.Y)
        end
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        if dragActive and not isDragging and ToggleBtn.Visible then
            MainFrame.Visible = true; ToggleBtn.Visible = false
        end
        dragActive = false; dragStartPos = nil; isDragging = false
    end
end)

local function onClose()
    MainFrame.Visible = false; ToggleBtn.Visible = true
end
CloseBtn.MouseButton1Click:Connect(onClose)
CloseBtn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.Touch then onClose() end end)

-- Containers
local function MakeContainer(name)
    local frame = Instance.new("ScrollingFrame")
    frame.Name = name
    frame.Size = UDim2.new(1, -30, 1, -65)
    frame.Position = UDim2.new(0, 15, 0, 55)
    frame.BackgroundTransparency = 1
    frame.ScrollBarThickness = 3
    frame.ScrollBarImageColor3 = Colors.Stroke
    frame.BorderSizePixel = 0
    frame.Visible = false
    frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    frame.CanvasSize = UDim2.new(0, 0, 0, 0)
    frame.Parent = MainFrame

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 10)
    layout.Parent = frame
    
    local pad = Instance.new("UIPadding")
    pad.PaddingBottom = UDim.new(0, 15)
    pad.PaddingRight = UDim.new(0, 5)
    pad.Parent = frame
    return frame
end

local MainMenu = MakeContainer("MainMenu")
local EggMenu = MakeContainer("EggMenu")
local ExtraMenu = MakeContainer("ExtraMenu")
MainMenu.Visible = true

-- Elegant Button Factory
local function MakeButton(parent, text, order, customColor)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = customColor or Colors.Button
    btn.Text = text
    btn.TextColor3 = Colors.Text
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamMedium
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.LayoutOrder = order
    btn.Parent = parent

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    local strokeColor = customColor and Color3.new(customColor.R*1.2, customColor.G*1.2, customColor.B*1.2) or Colors.Stroke
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = strokeColor
    btnStroke.Thickness = 1
    btnStroke.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Colors.ButtonHover}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = customColor or Colors.Button}):Play()
    end)
    
    -- Click effect
    btn.MouseButton1Down:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(0.97, 0, 0, 38)}):Play()
    end)
    btn.MouseButton1Up:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 40)}):Play()
    end)
    return btn
end

local function SwitchMenu(showMenu)
    MainMenu.Visible = false; EggMenu.Visible = false; ExtraMenu.Visible = false
    showMenu.Visible = true
end

-- Menus
local BtnOpenEgg = MakeButton(MainMenu, "🥚 Buka Menu Telur", 1)
local BtnOpenExtra = MakeButton(MainMenu, "⚙️ Buka Menu Ekstra", 3)
BtnOpenEgg.MouseButton1Click:Connect(function() SwitchMenu(EggMenu) end)
BtnOpenExtra.MouseButton1Click:Connect(function() SwitchMenu(ExtraMenu) end)

local BackBtn1 = MakeButton(EggMenu, "← Kembali", 0, Colors.Background)
local BackBtn3 = MakeButton(ExtraMenu, "← Kembali", 0, Colors.Background)
BackBtn1.MouseButton1Click:Connect(function() SwitchMenu(MainMenu) end)
BackBtn3.MouseButton1Click:Connect(function() SwitchMenu(MainMenu) end)

-- Dropdown
Wayae.UI.dropdownOptions = {"Belum ada telur dilacak"}
local DropLabel = Instance.new("TextLabel")
DropLabel.Size = UDim2.new(1, 0, 0, 20)
DropLabel.BackgroundTransparency = 1
DropLabel.Text = "Pilih Telur Target:"
DropLabel.TextColor3 = Colors.SubText
DropLabel.TextSize = 12
DropLabel.Font = Enum.Font.Gotham
DropLabel.TextXAlignment = Enum.TextXAlignment.Left
DropLabel.LayoutOrder = 2
DropLabel.Parent = EggMenu

Wayae.UI.DropBtn = Instance.new("TextButton")
Wayae.UI.DropBtn.Size = UDim2.new(1, 0, 0, 36)
Wayae.UI.DropBtn.BackgroundColor3 = Colors.Button
Wayae.UI.DropBtn.Text = Wayae.UI.dropdownOptions[1] .. "  ▾"
Wayae.UI.DropBtn.TextColor3 = Colors.Text
Wayae.UI.DropBtn.TextSize = 13
Wayae.UI.DropBtn.Font = Enum.Font.GothamMedium
Wayae.UI.DropBtn.TextXAlignment = Enum.TextXAlignment.Left
Wayae.UI.DropBtn.BorderSizePixel = 0
Wayae.UI.DropBtn.AutoButtonColor = false
Wayae.UI.DropBtn.LayoutOrder = 3
Wayae.UI.DropBtn.Parent = EggMenu

local DropBtnCorner = Instance.new("UICorner")
DropBtnCorner.CornerRadius = UDim.new(0, 8)
DropBtnCorner.Parent = Wayae.UI.DropBtn
local DropBtnStroke = Instance.new("UIStroke")
DropBtnStroke.Color = Colors.Stroke
DropBtnStroke.Thickness = 1
DropBtnStroke.Parent = Wayae.UI.DropBtn
local DropPad = Instance.new("UIPadding")
DropPad.PaddingLeft = UDim.new(0, 12)
DropPad.PaddingRight = UDim.new(0, 12)
DropPad.Parent = Wayae.UI.DropBtn

local DropList = Instance.new("ScrollingFrame")
DropList.Size = UDim2.new(1, 0, 0, 0)
DropList.BackgroundColor3 = Colors.Background
DropList.BorderSizePixel = 0
DropList.Visible = false
DropList.ZIndex = 10
DropList.ScrollBarThickness = 2
DropList.CanvasSize = UDim2.new(0, 0, 0, 0)
DropList.LayoutOrder = 4
DropList.Parent = EggMenu

local DropListCorner = Instance.new("UICorner")
DropListCorner.CornerRadius = UDim.new(0, 6)
DropListCorner.Parent = DropList
local DropListStroke = Instance.new("UIStroke")
DropListStroke.Color = Colors.Stroke
DropListStroke.Parent = DropList
local DropListLayout = Instance.new("UIListLayout")
DropListLayout.SortOrder = Enum.SortOrder.LayoutOrder
DropListLayout.Parent = DropList

Wayae.UI.RefreshDropdown = function(options)
    Wayae.UI.dropdownOptions = options
    for _, c in pairs(DropList:GetChildren()) do if not c:IsA("UIListLayout") then c:Destroy() end end
    for i, opt in ipairs(options) do
        local item = Instance.new("TextButton")
        item.Size = UDim2.new(1, 0, 0, 32)
        item.BackgroundColor3 = Colors.Background
        item.Text = "  " .. opt
        item.TextColor3 = Colors.SubText
        item.TextSize = 12
        item.Font = Enum.Font.Gotham
        item.TextXAlignment = Enum.TextXAlignment.Left
        item.BorderSizePixel = 0
        item.ZIndex = 11
        item.LayoutOrder = i
        item.Parent = DropList

        item.MouseEnter:Connect(function() TweenService:Create(item, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Button, TextColor3 = Colors.Text}):Play() end)
        item.MouseLeave:Connect(function() TweenService:Create(item, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Background, TextColor3 = Colors.SubText}):Play() end)
        
        item.MouseButton1Click:Connect(function()
            Wayae.UI.DropBtn.Text = opt .. "  ▾"
            local idxStr = opt:match("^(%d+)%.")
            if idxStr then Wayae.selectedEggIndex = tonumber(idxStr) end
            DropList.Visible = false
            DropList.Size = UDim2.new(1, 0, 0, 0)
        end)
    end
    local totalH = math.min(#options * 32, 128)
    DropList.CanvasSize = UDim2.new(0, 0, 0, #options * 32)
    if DropList.Visible then TweenService:Create(DropList, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, totalH)}):Play() end
end

Wayae.UI.DropBtn.MouseButton1Click:Connect(function()
    DropList.Visible = not DropList.Visible
    if DropList.Visible then
        local totalH = math.min(#Wayae.UI.dropdownOptions * 32, 128)
        TweenService:Create(DropList, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, totalH)}):Play()
    else
        TweenService:Create(DropList, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 0)}):Play()
        task.delay(0.1, function() DropList.Visible = false end)
    end
end)
Wayae.UI.RefreshDropdown(Wayae.UI.dropdownOptions)

Wayae.UI.ScanBtn = MakeButton(EggMenu, "🔍 1. Lacak Telur Special", 1)
Wayae.UI.TeleportBtn = MakeButton(EggMenu, "🚀 2. Teleport ke Lokasi Telur", 5, Color3.fromRGB(35, 30, 45))
Wayae.UI.SellBtn = MakeButton(EggMenu, "🏕️ 3. Teleport ke My Plot / Ranch", 6)
Wayae.UI.AutoFarmBtn = MakeButton(EggMenu, "🤖 4. Auto Farm Egg: OFF", 7, Color3.fromRGB(45, 25, 30))

Wayae.UI.GetPosBtn = MakeButton(ExtraMenu, "📍 Ambil Posisi Saya Sekarang", 1)
Wayae.UI.SaveLocBtn = MakeButton(ExtraMenu, "💾 Save Last Location", 2)
Wayae.UI.TpLocBtn = MakeButton(ExtraMenu, "🔙 Teleport Last Location", 3)
Wayae.UI.VolcanicTestBtn = MakeButton(ExtraMenu, "🌋 Test Teleport Volcanic", 4)

-- Elegant Notifications
Wayae.UI.Notify = function(title, msg, duration)
    local notifyGui = playerGui:FindFirstChild("WayaeNotifyGui")
    if not notifyGui then
        notifyGui = Instance.new("ScreenGui")
        notifyGui.Name = "WayaeNotifyGui"
        notifyGui.ResetOnSpawn = false
        notifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        notifyGui.Parent = playerGui
    end

    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 260, 0, 80)
    notif.AnchorPoint = Vector2.new(1, 0)
    notif.Position = UDim2.new(1, 300, 0, 100) -- Start off-screen right
    notif.BackgroundColor3 = Colors.Background
    notif.BackgroundTransparency = 0.1
    notif.BorderSizePixel = 0
    notif.Parent = notifyGui

    local nc = Instance.new("UICorner")
    nc.CornerRadius = UDim.new(0, 8)
    nc.Parent = notif

    local ns = Instance.new("UIStroke")
    ns.Color = Colors.Stroke
    ns.Thickness = 1
    ns.Parent = notif
    
    local accentLine = Instance.new("Frame")
    accentLine.Size = UDim2.new(0, 4, 1, -20)
    accentLine.Position = UDim2.new(0, 10, 0, 10)
    accentLine.BackgroundColor3 = Colors.Accent
    accentLine.BorderSizePixel = 0
    accentLine.Parent = notif
    local alc = Instance.new("UICorner")
    alc.CornerRadius = UDim.new(1, 0)
    alc.Parent = accentLine

    local nt = Instance.new("TextLabel")
    nt.Size = UDim2.new(1, -30, 0, 20)
    nt.Position = UDim2.new(0, 22, 0, 12)
    nt.BackgroundTransparency = 1
    nt.Text = title
    nt.TextColor3 = Colors.Text
    nt.TextSize = 13
    nt.Font = Enum.Font.GothamBold
    nt.TextXAlignment = Enum.TextXAlignment.Left
    nt.Parent = notif

    local nm = Instance.new("TextLabel")
    nm.Size = UDim2.new(1, -30, 0, 35)
    nm.Position = UDim2.new(0, 22, 0, 32)
    nm.BackgroundTransparency = 1
    nm.Text = msg
    nm.TextColor3 = Colors.SubText
    nm.TextSize = 12
    nm.Font = Enum.Font.Gotham
    nm.TextXAlignment = Enum.TextXAlignment.Left
    nm.TextWrapped = true
    nm.Parent = notif

    -- Arrange existing notifications
    local existing = {}
    for _, child in pairs(notifyGui:GetChildren()) do
        if child:IsA("Frame") and child ~= notif then table.insert(existing, child) end
    end
    local yOffset = 100
    for i = #existing, 1, -1 do
        local e = existing[i]
        TweenService:Create(e, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(1, -15, 0, yOffset + 90 * (#existing - i + 1))}):Play()
    end

    -- Slide in
    TweenService:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(1, -15, 0, 100)}):Play()

    task.delay(duration or 4, function()
        if notif and notif.Parent then
            local fadeOut = TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, 300, 0, notif.Position.Y.Offset)})
            fadeOut:Play()
            fadeOut.Completed:Wait()
            notif:Destroy()
        end
    end)
end
