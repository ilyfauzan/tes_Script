local Wayae = getgenv().Wayae
local player = Wayae.player
local playerGui = player:WaitForChild("PlayerGui")
if playerGui:FindFirstChild("WayaeHUB") then
    playerGui:FindFirstChild("WayaeHUB"):Destroy()
end
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WayaeHUB"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 420)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 45)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(120, 80, 255)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 20, 60)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar
local TitleBlocker = Instance.new("Frame")
TitleBlocker.Size = UDim2.new(1, 0, 0, 10)
TitleBlocker.Position = UDim2.new(0, 0, 1, -10)
TitleBlocker.BackgroundColor3 = Color3.fromRGB(30, 20, 60)
TitleBlocker.BorderSizePixel = 0
TitleBlocker.Parent = TitleBar
local TitleIcon = Instance.new("TextLabel")
TitleIcon.Size = UDim2.new(0, 30, 0, 30)
TitleIcon.Position = UDim2.new(0, 10, 0, 5)
TitleIcon.BackgroundTransparency = 1
TitleIcon.Text = "🥚"
TitleIcon.TextSize = 20
TitleIcon.Parent = TitleBar
local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -90, 1, 0)
TitleText.Position = UDim2.new(0, 45, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "WayaeHUB"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 18
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 70)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.Parent = TitleBar
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn
local ToggleBtn = Instance.new("ImageButton")
ToggleBtn.Name = "ToggleWayaeHUB"
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0.5, -25, 0, 10)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 20, 60)
ToggleBtn.Image = "rbxassetid://134720935532299"
ToggleBtn.Visible = false
ToggleBtn.Active = true
ToggleBtn.Draggable = false
ToggleBtn.Parent = ScreenGui
local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleBtn
local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(140, 80, 255)
ToggleStroke.Thickness = 2.5
ToggleStroke.Parent = ToggleBtn
task.spawn(function()
    local colors = {Color3.fromRGB(100, 50, 220), Color3.fromRGB(180, 100, 255)}
    local i = 1
    while true do
        task.wait(0.7)
        if ToggleBtn and ToggleBtn.Parent then
            ToggleStroke.Color = colors[i]
            i = (i % #colors) + 1
        end
    end
end)
local UIS = game:GetService("UserInputService")
local dragActive = false
local dragStartPos = nil
local dragStartBtnPos = nil
local isDragging = false
local DRAG_THRESHOLD = 8
ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragActive = true
        dragStartPos = input.Position
        dragStartBtnPos = ToggleBtn.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if not dragActive or not dragStartPos then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
    local delta = input.Position - dragStartPos
    if math.abs(delta.X) > DRAG_THRESHOLD or math.abs(delta.Y) > DRAG_THRESHOLD then
        isDragging = true
        ToggleBtn.Position = UDim2.new(
            dragStartBtnPos.X.Scale, dragStartBtnPos.X.Offset + delta.X,
            dragStartBtnPos.Y.Scale, dragStartBtnPos.Y.Offset + delta.Y
        )
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.Touch and input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
    if dragActive and not isDragging then
        if ToggleBtn.Visible then
            MainFrame.Visible = true
            ToggleBtn.Visible = false
        end
    end
    dragActive = false
    dragStartPos = nil
    isDragging = false
end)
local function onClose()
    MainFrame.Visible = false
    ToggleBtn.Visible = true
end
CloseBtn.MouseButton1Click:Connect(onClose)
CloseBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then onClose() end
end)

local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Size = UDim2.new(1, -24, 0, 30)
TabBar.Position = UDim2.new(0, 12, 0, 52)
TabBar.BackgroundTransparency = 1
TabBar.Parent = MainFrame

local MainTabBtn = Instance.new("TextButton")
MainTabBtn.Size = UDim2.new(0.48, 0, 1, 0)
MainTabBtn.Position = UDim2.new(0, 0, 0, 0)
MainTabBtn.BackgroundColor3 = Color3.fromRGB(70, 50, 140)
MainTabBtn.Text = "Utama"
MainTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MainTabBtn.Font = Enum.Font.GothamBold
MainTabBtn.TextSize = 13
MainTabBtn.Parent = TabBar
local MainTabCorner = Instance.new("UICorner")
MainTabCorner.CornerRadius = UDim.new(0, 6)
MainTabCorner.Parent = MainTabBtn

local ExtraTabBtn = Instance.new("TextButton")
ExtraTabBtn.Size = UDim2.new(0.48, 0, 1, 0)
ExtraTabBtn.Position = UDim2.new(0.52, 0, 0, 0)
ExtraTabBtn.BackgroundColor3 = Color3.fromRGB(30, 20, 60)
ExtraTabBtn.Text = "Ekstra"
ExtraTabBtn.TextColor3 = Color3.fromRGB(150, 130, 200)
ExtraTabBtn.Font = Enum.Font.GothamBold
ExtraTabBtn.TextSize = 13
ExtraTabBtn.Parent = TabBar
local ExtraTabCorner = Instance.new("UICorner")
ExtraTabCorner.CornerRadius = UDim.new(0, 6)
ExtraTabCorner.Parent = ExtraTabBtn

local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Name = "Content"
ContentFrame.Size = UDim2.new(1, -24, 1, -94)
ContentFrame.Position = UDim2.new(0, 12, 0, 88)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ScrollBarThickness = 2
ContentFrame.BorderSizePixel = 0
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 300)
ContentFrame.Parent = MainFrame
local ContentLayout = Instance.new("UIListLayout")
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Padding = UDim.new(0, 8)
ContentLayout.Parent = ContentFrame

local ExtraFrame = Instance.new("ScrollingFrame")
ExtraFrame.Name = "ExtraContent"
ExtraFrame.Size = UDim2.new(1, -24, 1, -94)
ExtraFrame.Position = UDim2.new(0, 12, 0, 88)
ExtraFrame.BackgroundTransparency = 1
ExtraFrame.ScrollBarThickness = 2
ExtraFrame.BorderSizePixel = 0
ExtraFrame.CanvasSize = UDim2.new(0, 0, 0, 300)
ExtraFrame.Visible = false
ExtraFrame.Parent = MainFrame
local ExtraLayout = Instance.new("UIListLayout")
ExtraLayout.SortOrder = Enum.SortOrder.LayoutOrder
ExtraLayout.Padding = UDim.new(0, 8)
ExtraLayout.Parent = ExtraFrame

MainTabBtn.MouseButton1Click:Connect(function()
    MainTabBtn.BackgroundColor3 = Color3.fromRGB(70, 50, 140)
    MainTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ExtraTabBtn.BackgroundColor3 = Color3.fromRGB(30, 20, 60)
    ExtraTabBtn.TextColor3 = Color3.fromRGB(150, 130, 200)
    ContentFrame.Visible = true
    ExtraFrame.Visible = false
end)

ExtraTabBtn.MouseButton1Click:Connect(function()
    ExtraTabBtn.BackgroundColor3 = Color3.fromRGB(70, 50, 140)
    ExtraTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MainTabBtn.BackgroundColor3 = Color3.fromRGB(30, 20, 60)
    MainTabBtn.TextColor3 = Color3.fromRGB(150, 130, 200)
    ContentFrame.Visible = false
    ExtraFrame.Visible = true
end)

local function MakeButton(parent, text, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 42)
    btn.BackgroundColor3 = Color3.fromRGB(40, 30, 80)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(210, 190, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.Gotham
    btn.BorderSizePixel = 0
    btn.LayoutOrder = order
    btn.Parent = parent
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(80, 60, 180)
    btnStroke.Thickness = 1
    btnStroke.Parent = btn
    btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(70, 50, 140) end)
    btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(40, 30, 80) end)
    return btn
end
Wayae.UI.Notify = function(title, msg, duration)
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 280, 0, 90)
    notif.AnchorPoint = Vector2.new(1, 0)
    notif.Position = UDim2.new(1, -8, 0, 165)
    notif.BackgroundColor3 = Color3.fromRGB(25, 18, 50)
    notif.BorderSizePixel = 0
    notif.ZIndex = 50
    notif.Parent = ScreenGui
    local nc = Instance.new("UICorner")
    nc.CornerRadius = UDim.new(0, 10)
    nc.Parent = notif
    local ns = Instance.new("UIStroke")
    ns.Color = Color3.fromRGB(100, 70, 220)
    ns.Thickness = 1
    ns.Parent = notif
    local nt = Instance.new("TextLabel")
    nt.Size = UDim2.new(1, -12, 0, 24)
    nt.Position = UDim2.new(0, 10, 0, 6)
    nt.BackgroundTransparency = 1
    nt.Text = title
    nt.TextColor3 = Color3.fromRGB(200, 170, 255)
    nt.TextSize = 13
    nt.Font = Enum.Font.GothamBold
    nt.TextXAlignment = Enum.TextXAlignment.Left
    nt.Parent = notif
    local nm = Instance.new("TextLabel")
    nm.Size = UDim2.new(1, -12, 0, 50)
    nm.Position = UDim2.new(0, 10, 0, 28)
    nm.BackgroundTransparency = 1
    nm.Text = msg
    nm.TextColor3 = Color3.fromRGB(170, 150, 220)
    nm.TextSize = 12
    nm.Font = Enum.Font.Gotham
    nm.TextXAlignment = Enum.TextXAlignment.Left
    nm.TextWrapped = true
    nm.Parent = notif
    task.delay(duration or 4, function()
        if notif and notif.Parent then notif:Destroy() end
    end)
end
Wayae.UI.dropdownOptions = {"Belum ada telur dilacak"}
local DropLabel = Instance.new("TextLabel")
DropLabel.Size = UDim2.new(1, 0, 0, 20)
DropLabel.BackgroundTransparency = 1
DropLabel.Text = "📌 Pilih Telur Target:"
DropLabel.TextColor3 = Color3.fromRGB(160, 140, 210)
DropLabel.TextSize = 13
DropLabel.Font = Enum.Font.Gotham
DropLabel.TextXAlignment = Enum.TextXAlignment.Left
DropLabel.LayoutOrder = 2
DropLabel.Parent = ContentFrame
Wayae.UI.DropBtn = Instance.new("TextButton")
Wayae.UI.DropBtn.Size = UDim2.new(1, 0, 0, 38)
Wayae.UI.DropBtn.BackgroundColor3 = Color3.fromRGB(35, 25, 70)
Wayae.UI.DropBtn.Text = "▾  " .. Wayae.UI.dropdownOptions[1]
Wayae.UI.DropBtn.TextColor3 = Color3.fromRGB(200, 180, 255)
Wayae.UI.DropBtn.TextSize = 13
Wayae.UI.DropBtn.Font = Enum.Font.Gotham
Wayae.UI.DropBtn.TextXAlignment = Enum.TextXAlignment.Left
Wayae.UI.DropBtn.BorderSizePixel = 0
Wayae.UI.DropBtn.LayoutOrder = 3
Wayae.UI.DropBtn.Parent = ContentFrame
local DropBtnCorner = Instance.new("UICorner")
DropBtnCorner.CornerRadius = UDim.new(0, 8)
DropBtnCorner.Parent = Wayae.UI.DropBtn
local DropBtnStroke = Instance.new("UIStroke")
DropBtnStroke.Color = Color3.fromRGB(80, 60, 180)
DropBtnStroke.Thickness = 1
DropBtnStroke.Parent = Wayae.UI.DropBtn
local DropPad = Instance.new("UIPadding")
DropPad.PaddingLeft = UDim.new(0, 10)
DropPad.Parent = Wayae.UI.DropBtn
local DropList = Instance.new("ScrollingFrame")
DropList.Size = UDim2.new(1, 0, 0, 0)
DropList.BackgroundColor3 = Color3.fromRGB(28, 20, 58)
DropList.BorderSizePixel = 0
DropList.Visible = false
DropList.ZIndex = 10
DropList.ScrollBarThickness = 4
DropList.CanvasSize = UDim2.new(0, 0, 0, 0)
DropList.LayoutOrder = 4
DropList.Parent = ContentFrame
local DropListCorner = Instance.new("UICorner")
DropListCorner.CornerRadius = UDim.new(0, 8)
DropListCorner.Parent = DropList
local DropListLayout = Instance.new("UIListLayout")
DropListLayout.SortOrder = Enum.SortOrder.LayoutOrder
DropListLayout.Parent = DropList
Wayae.UI.RefreshDropdown = function(options)
    Wayae.UI.dropdownOptions = options
    for _, c in pairs(DropList:GetChildren()) do
        if not c:IsA("UIListLayout") then c:Destroy() end
    end
    for i, opt in ipairs(options) do
        local item = Instance.new("TextButton")
        item.Size = UDim2.new(1, 0, 0, 34)
        item.BackgroundColor3 = Color3.fromRGB(35, 25, 70)
        item.Text = "  " .. opt
        item.TextColor3 = Color3.fromRGB(200, 180, 255)
        item.TextSize = 12
        item.Font = Enum.Font.Gotham
        item.TextXAlignment = Enum.TextXAlignment.Left
        item.BorderSizePixel = 0
        item.ZIndex = 11
        item.LayoutOrder = i
        item.Parent = DropList
        item.MouseButton1Click:Connect(function()
            Wayae.UI.DropBtn.Text = "▾  " .. opt
            local idxStr = opt:match("^(%d+)%.")
            if idxStr then Wayae.selectedEggIndex = tonumber(idxStr) end
            DropList.Visible = false
            DropList.Size = UDim2.new(1, 0, 0, 0)
        end)
    end
    local totalH = math.min(#options * 34, 136)
    DropList.CanvasSize = UDim2.new(0, 0, 0, #options * 34)
    if DropList.Visible then DropList.Size = UDim2.new(1, 0, 0, totalH) end
end
Wayae.UI.DropBtn.MouseButton1Click:Connect(function()
    DropList.Visible = not DropList.Visible
    if DropList.Visible then
        local totalH = math.min(#Wayae.UI.dropdownOptions * 34, 136)
        DropList.Size = UDim2.new(1, 0, 0, totalH)
    else
        DropList.Size = UDim2.new(1, 0, 0, 0)
    end
end)
Wayae.UI.RefreshDropdown(Wayae.UI.dropdownOptions)

Wayae.UI.ScanBtn = MakeButton(ContentFrame, "🔍  1. Lacak Telur Special", 1)
Wayae.UI.TeleportBtn = MakeButton(ContentFrame, "🚀  2. Teleport ke Lokasi Telur", 5)
Wayae.UI.SellBtn = MakeButton(ContentFrame, "🏕️  3. Teleport ke My Plot / Ranch", 6)

Wayae.UI.VolcanicTestBtn = MakeButton(ExtraFrame, "🌋  Test Teleport Volcanic", 1)
Wayae.UI.GetPosBtn = MakeButton(ExtraFrame, "📍  Ambil Posisi Saya Sekarang", 2)
Wayae.UI.SaveLocBtn = MakeButton(ExtraFrame, "💾  Save Last Location", 3)
Wayae.UI.TpLocBtn = MakeButton(ExtraFrame, "🔙  Teleport Last Location", 4)
