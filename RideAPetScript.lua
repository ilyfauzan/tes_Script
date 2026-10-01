-- WayaeHUB Custom UI - No Library, No Branding
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ════════════════════════════════════════
--  HAPUS UI LAMA JIKA ADA
-- ════════════════════════════════════════
if playerGui:FindFirstChild("WayaeHUB") then
    playerGui:FindFirstChild("WayaeHUB"):Destroy()
end

-- ════════════════════════════════════════
--  BUAT SCREENGUI
-- ════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WayaeHUB"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = playerGui

-- ════════════════════════════════════════
--  WINDOW UTAMA
-- ════════════════════════════════════════
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 340, 0, 400)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(80, 60, 200)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- HEADER
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 48)
Header.BackgroundColor3 = Color3.fromRGB(30, 20, 60)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

-- Fix corner bawah header
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

-- Tombol Tutup (minimize ke floating button)
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

-- ════════════════════════════════════════
--  FLOATING TOGGLE BUTTON (draggable + tappable)
-- ════════════════════════════════════════
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "WayaeToggle"
ToggleBtn.Size = UDim2.new(0, 60, 0, 60)
ToggleBtn.Position = UDim2.new(1, -75, 0, 130) -- Pojok kanan atas, aman dari Shop/Rebirth
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

-- Glow berdenyut
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

-- ════ DRAG MANUAL pakai UIS (bekerja di mobile) ════
local UIS = game:GetService("UserInputService")
local dragStartPos = nil
local dragStartBtnPos = nil
local isDragging = false
local DRAG_THRESHOLD = 10

ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or
       input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragStartPos = input.Position
        dragStartBtnPos = ToggleBtn.Position
        isDragging = false
    end
end)

-- Pakai UIS global bukan ToggleBtn.InputChanged
-- Karena di mobile, event touch movement dikirim lewat UIS bukan dari GuiObject
UIS.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.Touch or
        input.UserInputType == Enum.UserInputType.MouseMovement) and dragStartPos then
        local delta = input.Position - dragStartPos
        if math.abs(delta.X) > DRAG_THRESHOLD or math.abs(delta.Y) > DRAG_THRESHOLD then
            isDragging = true
            ToggleBtn.Position = UDim2.new(
                dragStartBtnPos.X.Scale,
                dragStartBtnPos.X.Offset + delta.X,
                dragStartBtnPos.Y.Scale,
                dragStartBtnPos.Y.Offset + delta.Y
            )
        end
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or
       input.UserInputType == Enum.UserInputType.MouseButton1 then
        if dragStartPos and not isDragging then
            -- Tap singkat = buka menu
            if ToggleBtn.Visible then
                MainFrame.Visible = true
                ToggleBtn.Visible = false
            end
        end
        dragStartPos = nil
        isDragging = false
    end
end)

-- ════ CLOSE BUTTON ════
local function onClose()
    MainFrame.Visible = false
    ToggleBtn.Visible = true
end

CloseBtn.MouseButton1Click:Connect(onClose)
CloseBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        onClose()
    end
end)

-- CONTENT AREA
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

-- ════════════════════════════════════════
--  HELPER: BUAT TOMBOL
-- ════════════════════════════════════════
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

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(70, 50, 140)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(40, 30, 80)
    end)

    return btn
end

-- ════════════════════════════════════════
--  HELPER: NOTIFIKASI
-- ════════════════════════════════════════
local function Notify(title, msg, duration)
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 280, 0, 64)
    notif.Position = UDim2.new(1, -296, 1, -80)
    notif.BackgroundColor3 = Color3.fromRGB(25, 18, 50)
    notif.BorderSizePixel = 0
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
    nm.Size = UDim2.new(1, -12, 0, 28)
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

-- ════════════════════════════════════════
--  SCAN TELUR
-- ════════════════════════════════════════
local detectedEggsList = {}
local selectedEggIndex = 1

local function ScanSpecialEggs()
    detectedEggsList = {}

    local playerCharacters = {}
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr.Character then
            playerCharacters[plr.Character] = true
        end
    end

    local function IsInsideCharacter(obj)
        local current = obj.Parent
        while current do
            if playerCharacters[current] then return true end
            current = current.Parent
        end
        return false
    end

    local plotKeywords = {"plot", "base", "pen", "farm", "yard", "house", "home", "island", "territory"}

    local function IsInsidePlot(obj)
        local current = obj.Parent
        while current and current ~= workspace do
            local nameLower = current.Name:lower()
            for _, kw in ipairs(plotKeywords) do
                if nameLower:find(kw) then return true end
            end
            current = current.Parent
        end
        return false
    end

    local specialNames = {
        ["blackhole"] = "100B - Blackhole Egg",
        ["solaris"]   = "300B - Solaris Egg",
        ["cherub"]    = "1T - Cherub Egg",
        ["volcanic"]  = "2.5T - Volcanic Egg"
    }

    local function GetHighestPart(model)
        local highestPart = nil
        local highestY = -math.huge
        for _, part in pairs(model:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                if part.Position.Y > highestY then
                    highestY = part.Position.Y
                    highestPart = part
                end
            end
        end
        return highestPart
    end

    for _, obj in pairs(workspace:GetDescendants()) do
        if IsInsideCharacter(obj) then continue end
        if IsInsidePlot(obj) then continue end

        if obj:IsA("Model") or obj:IsA("BasePart") then
            local nameLower = obj.Name:lower()
            local foundTierName = nil

            for keyword, displayName in pairs(specialNames) do
                if nameLower:find(keyword) then
                    foundTierName = displayName
                    break
                end
            end

            if not foundTierName then
                for _, child in pairs(obj:GetChildren()) do
                    if child:IsA("TextLabel") or child:IsA("StringValue") then
                        local textVal = (child:IsA("TextLabel") and child.Text or tostring(child.Value)):lower()
                        for keyword, displayName in pairs(specialNames) do
                            if textVal:find(keyword) then
                                foundTierName = displayName
                                break
                            end
                        end
                    end
                    if foundTierName then break end
                end
            end

            if foundTierName then
                local eggCFrame
                if obj:IsA("Model") then
                    local topPart = GetHighestPart(obj)
                    if topPart then
                        eggCFrame = topPart.CFrame
                    elseif obj.PrimaryPart then
                        eggCFrame = obj.PrimaryPart.CFrame
                    else
                        local cf, _ = obj:GetBoundingBox()
                        eggCFrame = cf
                    end
                else
                    eggCFrame = obj.CFrame
                end

                local isDuplicate = false
                for _, existing in ipairs(detectedEggsList) do
                    if existing.CFrame and eggCFrame then
                        if (existing.CFrame.Position - eggCFrame.Position).Magnitude < 5 then
                            isDuplicate = true
                            break
                        end
                    end
                end

                if not isDuplicate then
                    table.insert(detectedEggsList, {
                        Name = foundTierName .. " [" .. obj.Name .. "]",
                        Instance = obj,
                        CFrame = eggCFrame
                    })
                end
            end
        end
    end

    return detectedEggsList
end

-- ════════════════════════════════════════
--  DROPDOWN CUSTOM
-- ════════════════════════════════════════
local dropdownOptions = {"Belum ada telur dilacak"}

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

local DropBtn = Instance.new("TextButton")
DropBtn.Size = UDim2.new(1, 0, 0, 38)
DropBtn.BackgroundColor3 = Color3.fromRGB(35, 25, 70)
DropBtn.Text = "▾  " .. dropdownOptions[1]
DropBtn.TextColor3 = Color3.fromRGB(200, 180, 255)
DropBtn.TextSize = 13
DropBtn.Font = Enum.Font.Gotham
DropBtn.TextXAlignment = Enum.TextXAlignment.Left
DropBtn.BorderSizePixel = 0
DropBtn.LayoutOrder = 3
DropBtn.Parent = ContentFrame

local DropBtnCorner = Instance.new("UICorner")
DropBtnCorner.CornerRadius = UDim.new(0, 8)
DropBtnCorner.Parent = DropBtn

local DropBtnStroke = Instance.new("UIStroke")
DropBtnStroke.Color = Color3.fromRGB(80, 60, 180)
DropBtnStroke.Thickness = 1
DropBtnStroke.Parent = DropBtn

local DropPad = Instance.new("UIPadding")
DropPad.PaddingLeft = UDim.new(0, 10)
DropPad.Parent = DropBtn

-- List dropdown (scroll)
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

local function RefreshDropdown(options)
    dropdownOptions = options
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
            DropBtn.Text = "▾  " .. opt
            local idxStr = opt:match("^(%d+)%.")
            if idxStr then selectedEggIndex = tonumber(idxStr) end
            DropList.Visible = false
            DropList.Size = UDim2.new(1, 0, 0, 0)
        end)
    end

    local totalH = math.min(#options * 34, 136)
    DropList.CanvasSize = UDim2.new(0, 0, 0, #options * 34)
    if DropList.Visible then
        DropList.Size = UDim2.new(1, 0, 0, totalH)
    end
end

DropBtn.MouseButton1Click:Connect(function()
    DropList.Visible = not DropList.Visible
    if DropList.Visible then
        local totalH = math.min(#dropdownOptions * 34, 136)
        DropList.Size = UDim2.new(1, 0, 0, totalH)
    else
        DropList.Size = UDim2.new(1, 0, 0, 0)
    end
end)

RefreshDropdown(dropdownOptions)

-- ════════════════════════════════════════
--  TOMBOL-TOMBOL
-- ════════════════════════════════════════
local ScanBtn = MakeButton(ContentFrame, "🔍  1. Lacak Telur Special (100B - 2.5T)", 1)

local TeleportBtn = MakeButton(ContentFrame, "🚀  2. Teleport ke Lokasi Telur", 5)

local SellBtn = MakeButton(ContentFrame, "🏪  3. Teleport ke Area Sell", 6)

-- ════════════════════════════════════════
--  LOGIKA TOMBOL
-- ════════════════════════════════════════
ScanBtn.MouseButton1Click:Connect(function()
    local eggs = ScanSpecialEggs()
    if #eggs > 0 then
        local options = {}
        for i, eggData in ipairs(eggs) do
            table.insert(options, tostring(i) .. ". " .. eggData.Name)
        end
        RefreshDropdown(options)
        DropBtn.Text = "▾  " .. options[1]
        selectedEggIndex = 1
        Notify("✅ Berhasil Melacak!", "Ditemukan " .. #eggs .. " Telur Special!", 4)
    else
        Notify("❌ Tidak Ada Telur", "Telur 100B/300B/1T/2.5T belum spawn di map.", 4)
    end
end)

TeleportBtn.MouseButton1Click:Connect(function()
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if #detectedEggsList == 0 then ScanSpecialEggs() end

    if #detectedEggsList > 0 then
        local target = detectedEggsList[selectedEggIndex] or detectedEggsList[1]
        if target and target.CFrame then
            hrp.CFrame = target.CFrame + Vector3.new(0, 3, 0)
            Notify("🚀 Teleport Berhasil!", "Posisi: " .. target.Name, 4)
        end
    else
        Notify("⚠️ Gagal Teleport", "Klik 'Lacak Telur' dulu saat telur spawn!", 4)
    end
end)

SellBtn.MouseButton1Click:Connect(function()
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local sellKeywords = {"sell", "selling", "sellzone", "sell zone", "shop", "store", "cashier", "vendor"}
    local sellTarget = nil

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local nameLower = obj.Name:lower()
            for _, kw in ipairs(sellKeywords) do
                if nameLower:find(kw) then
                    if obj:IsA("Model") then
                        local cf, _ = obj:GetBoundingBox()
                        sellTarget = cf
                    else
                        sellTarget = obj.CFrame
                    end
                    break
                end
            end
        end
        if sellTarget then break end
    end

    if sellTarget then
        hrp.CFrame = sellTarget + Vector3.new(0, 5, 0)
        Notify("🏪 Teleport ke Sell!", "Berhasil teleport ke area Sell!", 3)
    else
        Notify("⚠️ Sell Tidak Ditemukan", "Objek Sell tidak ada di map saat ini.", 5)
    end
end)
