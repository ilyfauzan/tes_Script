-- ====================================================================
-- SKRIP ROBLOX CUSTOM GUI (MEMBUAT UI DARI NOL TANPA LIBRARY)
-- ====================================================================

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

-- 1. Hapus GUI lama jika sudah ada (supaya tidak menumpuk)
if CoreGui:FindFirstChild("MyCustomHubScreen") then
    CoreGui.MyCustomHubScreen:Destroy()
end

-- 2. Buat Kontainer Utama (ScreenGui)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MyCustomHubScreen"

-- Tentukan parent GUI (mendukung executor dengan gethui/CoreGui)
if gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = CoreGui
end

-- 3. Buat Jendela Utama (Frame Window)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 380, 0, 280) -- Lebar 380px, Tinggi 280px
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -140) -- Di tengah layar
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30) -- Warna Dark Theme
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Membuat jendela bisa digeser (drag & drop)
MainFrame.Parent = ScreenGui

-- Sudut Tumpul (Rounded Corner) untuk Window Utama
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- 4. Buat Baris Judul (Header / Title Bar)
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, -40, 0, 45)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "WayaeHUB"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = MainFrame

-- Tombol Close (X) - Sekarang berfungsi sebagai Hide/Minimize
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -38, 0, 8)
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseButton.Text = "-"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 18
CloseButton.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

-- ====================================================================
-- FLOATING TOGGLE ICON (SIMBOL FLATING UNTUK BUKA/TUTUP UI)
-- ====================================================================
local ToggleButton = Instance.new("ImageButton")
ToggleButton.Name = "OpenCloseSimbol"
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0.02, 0, 0.4, 0) -- Di sebelah kiri layar
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ToggleButton.BorderSizePixel = 0
ToggleButton.Active = true
ToggleButton.Draggable = true -- Bisa digeser sesuka hati
ToggleButton.Image = "rbxassetid://6031097225" -- Icon Gambar Logo
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0.5, 0) -- Bulat Sempurna
ToggleCorner.Parent = ToggleButton

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(0, 170, 255)
ToggleStroke.Thickness = 2
ToggleStroke.Parent = ToggleButton

-- Event Buka / Tutup saat Simbol / Tombol diklik
local uiVisible = true
local function ToggleMainUI()
    uiVisible = not uiVisible
    MainFrame.Visible = uiVisible
end

CloseButton.MouseButton1Click:Connect(ToggleMainUI)
ToggleButton.MouseButton1Click:Connect(ToggleMainUI)

-- 5. Container Konten (Area Tombol)
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -30, 1, -65)
ContentContainer.Position = UDim2.new(0, 15, 0, 50)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- UIListLayout untuk Merapikan Tombol Secara Otomatis
local ListLayout = Instance.new("UIListLayout")
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 12)
ListLayout.Parent = ContentContainer

-- ====================================================================
-- FUNGSI MEMBUAT TOMBOL CUSTOM (HELPER FUNCTION)
-- ====================================================================
local function CreateCustomButton(text, onClickCallback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 42)
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(230, 230, 240)
    Button.Font = Enum.Font.GothamMedium
    Button.TextSize = 14
    Button.Parent = ContentContainer

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = Button

    -- Animasi Hover (Saat Kursor Mengarah ke Tombol)
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(0, 120, 215),
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
    end)

    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(40, 40, 50),
            TextColor3 = Color3.fromRGB(230, 230, 240)
        }):Play()
    end)

    -- Event Klik Tombol
    Button.MouseButton1Click:Connect(function()
        -- Animasi Klik Singkat
        TweenService:Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(0.98, 0, 0, 40)}):Play()
        task.wait(0.1)
        TweenService:Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 42)}):Play()
        
        if onClickCallback then
            onClickCallback()
        end
    end)

    return Button
end

-- ====================================================================
-- MENAMBAHKAN ELEMEN TOMBOL & MEKANIK KITA
-- ====================================================================

-- Tombol 1: Ambil Telur & Balik ke Base
CreateCustomButton("🥚 Ambil Telur Instan ke Base", function()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = character:FindFirstChild("HumanoidRootPart")

    if hrp then
        local baseCFrame = hrp.CFrame
        local eggFolder = workspace:FindFirstChild("Eggs") 
            or workspace:FindFirstChild("EggSpawns") 
            or workspace:FindFirstChild("Collectibles")

        if eggFolder then
            local targetEgg = nil
            for _, item in pairs(eggFolder:GetChildren()) do
                if item:IsA("Model") or item:IsA("BasePart") then
                    targetEgg = item
                    break
                end
            end

            if targetEgg then
                local eggPos = targetEgg:IsA("Model") and targetEgg:GetPivot() or targetEgg.CFrame
                hrp.CFrame = eggPos
                task.wait(0.3)
                hrp.CFrame = baseCFrame
                print("[Custom GUI] Berhasil mengambil telur dan kembali ke Base!")
            else
                print("[Custom GUI] Telur tidak ditemukan di map!")
            end
        end
    end
end)

-- Tombol 2: Toggle WalkSpeed Boost (16 vs 100)
local speedBoostActive = false
local SpeedBtn = nil
SpeedBtn = CreateCustomButton("⚡ WalkSpeed Boost: OFF", function()
    speedBoostActive = not speedBoostActive
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        if speedBoostActive then
            LocalPlayer.Character.Humanoid.WalkSpeed = 100
            SpeedBtn.Text = "⚡ WalkSpeed Boost: ON (100)"
        else
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
            SpeedBtn.Text = "⚡ WalkSpeed Boost: OFF"
        end
    end
end)

-- Tombol 3: Teleportasi ke Base
CreateCustomButton("🏠 Teleport ke Base/Spawn", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local spawn = workspace:FindFirstChildOfClass("SpawnLocation")
        if spawn then
            LocalPlayer.Character.HumanoidRootPart.CFrame = spawn.CFrame + Vector3.new(0, 3, 0)
            print("[Custom GUI] Teleport ke SpawnLocation!")
        end
    end
end)

print("[Custom GUI] UI dari nol berhasil dimuat!")
