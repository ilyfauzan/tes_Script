local Wayae = getgenv().Wayae
local player = Wayae.player
local playerGui = player:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("WayaeHUB") then
    playerGui:FindFirstChild("WayaeHUB"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WayaeHUB"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = playerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0.85, 0, 0.85, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = false
MainFrame.Parent = ScreenGui

local SizeConstraint = Instance.new("UISizeConstraint")
SizeConstraint.MaxSize = Vector2.new(340, 480)
SizeConstraint.MinSize = Vector2.new(240, 300)
SizeConstraint.Parent = MainFrame

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(80, 60, 200)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 48)
Header.BackgroundColor3 = Color3.fromRGB(30, 20, 60)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 12)
HeaderFix.Position = UDim2.new(0, 0, 1, -12)
HeaderFix.BackgroundColor3 = Color3.fromRGB(30, 20, 60)
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = Header

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -60, 1, 0)
TitleLabel.Position = UDim2.new(0, 16, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🥚  WayaeHUB"
TitleLabel.TextColor3 = Color3.fromRGB(220, 200, 255)
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -42, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 80)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = Header

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 8)
CloseBtnCorner.Parent = CloseBtn

local UISwin = game:GetService("UserInputService")
local winDragActive = false
local winDragStartPos = nil
local winDragStartFramePos = nil

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        winDragActive = true
        winDragStartPos = input.Position
        winDragStartFramePos = MainFrame.Position
    end
end)
UISwin.InputChanged:Connect(function(input)
    if not winDragActive or not winDragStartPos then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
    local delta = input.Position - winDragStartPos
    MainFrame.Position = UDim2.new(
        winDragStartFramePos.X.Scale, winDragStartFramePos.X.Offset + delta.X,
        winDragStartFramePos.Y.Scale, winDragStartFramePos.Y.Offset + delta.Y
    )
end)
UISwin.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        winDragActive = false
        winDragStartPos = nil
    end
end)

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "WayaeToggle"
ToggleBtn.Size = UDim2.new(0, 60, 0, 60)
ToggleBtn.Position = UDim2.new(1, -75, 0, 130)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 30, 110)
ToggleBtn.Text = "🥚"
ToggleBtn.TextSize = 28
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Visible = false
ToggleBtn.ZIndex = 100
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
        isDragging = false
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

local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "Content"
ContentFrame.Size = UDim2.new(1, -24, 1, -68)
ContentFrame.Position = UDim2.new(0, 12, 0, 58)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Padding = UDim.new(0, 8)
ContentLayout.Parent = ContentFrame

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

Wayae.UI.ScanBtn = MakeButton(ContentFrame, "🔍  1. Lacak Telur Special (100B - 2.5T)", 1)
Wayae.UI.TeleportBtn = MakeButton(ContentFrame, "🚀  2. Teleport ke Lokasi Telur", 5)
Wayae.UI.SellBtn = MakeButton(ContentFrame, "🏕️  3. Teleport ke My Plot / Ranch", 6)
Wayae.UI.VolcanicTestBtn = MakeButton(ContentFrame, "🌋  4. Test Teleport Volcanic Egg", 7)
Wayae.UI.GetPosBtn = MakeButton(ContentFrame, "📍  5. Ambil Posisi Saya Sekarang", 8)
