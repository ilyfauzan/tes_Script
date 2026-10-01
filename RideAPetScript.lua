-- ====================================================================
-- RIDE A PET - EGG HUNT & UTILITY SCRIPT (RAYFIELD UI)
-- ====================================================================

-- 1. Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 2. Create Main Window
local Window = Rayfield:CreateWindow({
   Name = "Ride A Pet - Egg Hunt Hub",
   LoadingTitle = "Memuat Skrip...",
   LoadingSubtitle = "by Antigravity",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "RideAPetHub",
      FileName = "Config"
   },
   Discord = {
      Enabled = false,
   },
   KeySystem = false
})

-- ====================================================================
-- FLOATING TOGGLE BUTTON (SIMBOL UNTUK BUKA / TUTUP UI)
-- ====================================================================
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

-- Hapus tombol lama jika skrip di-execute ulang
if CoreGui:FindFirstChild("RideAPetToggleButton") then
    CoreGui.RideAPetToggleButton:Destroy()
end

local ToggleGui = Instance.new("ScreenGui")
ToggleGui.Name = "RideAPetToggleButton"
if gethui then
    ToggleGui.Parent = gethui()
else
    ToggleGui.Parent = CoreGui
end

local ToggleButton = Instance.new("ImageButton")
ToggleButton.Name = "OpenCloseButton"
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0.02, 0, 0.4, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ToggleButton.BorderSizePixel = 0
ToggleButton.Active = true
ToggleButton.Draggable = true
ToggleButton.Image = "rbxassetid://6031097225" -- Icon Pet / Egg
ToggleButton.Parent = ToggleGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0.5, 0) -- Lingkaran Sempurna
ToggleCorner.Parent = ToggleButton

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(0, 170, 255)
ToggleStroke.Thickness = 2
ToggleStroke.Parent = ToggleButton

local uiVisible = true
ToggleButton.MouseButton1Click:Connect(function()
    uiVisible = not uiVisible
    -- Rayfield builtin toggle / hide window
    if Window and Window.Modify then
        -- Jika Rayfield mendukung toggle bawaan
        Rayfield:ToggleUI()
    else
        -- Fallback toggle visual
        local mainFrame = CoreGui:FindFirstChild("Rayfield") or (gethui and gethui():FindFirstChild("Rayfield"))
        if mainFrame then
            mainFrame.Enabled = uiVisible
        end
    end
end)

-- 3. Create Tabs
local EggTab = Window:CreateTab("Egg Hunt", 4483362458)
local PlayerTab = Window:CreateTab("Pemain & Speed", 4483362458)

-- ====================================================================
-- TAB 1: EGG HUNT & BASE TELEPORT
-- ====================================================================

local autoEggHunt = false

-- Feature A: Ambil Telur Terdekat Instan & Balik ke Base (Single Action)
EggTab:CreateButton({
   Name = "Ambil Telur Terdekat & Balik ke Base",
   Callback = function()
       local player = game.Players.LocalPlayer
       local character = player.Character or player.CharacterAdded:Wait()
       local hrp = character:FindFirstChild("HumanoidRootPart")

       if not hrp then
           Rayfield:Notify({
               Title = "Error",
               Content = "Karakter tidak ditemukan!",
               Duration = 3,
           })
           return
       end

       -- Simpan Posisi Base (Posisi Pemain Saat Ini)
       local baseCFrame = hrp.CFrame

       -- Cari Folder Telur di Workspace
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
               -- Teleport Instan ke Telur
               local eggPosition = targetEgg:IsA("Model") and targetEgg:GetPivot() or targetEgg.CFrame
               hrp.CFrame = eggPosition
               
               task.wait(0.3) -- Jeda singkat agar server mencatat pengumpulan telur

               -- Teleport Instan Kembali ke Base
               hrp.CFrame = baseCFrame
               
               Rayfield:Notify({
                  Title = "Berhasil!",
                  Content = "Berhasil mengambil telur dan kembali ke Base.",
                  Duration = 3,
               })
           else
               Rayfield:Notify({
                  Title = "Informasi",
                  Content = "Tidak ada telur yang ditemukan di folder map!",
                  Duration = 3,
               })
           end
       else
           Rayfield:Notify({
               Title = "Peringatan",
               Content = "Folder telur ('Eggs') tidak ditemukan di Workspace!",
               Duration = 3,
           })
       end
   end,
})

-- Feature B: Auto Loop Hunt All Eggs to Base (Toggle)
EggTab:CreateToggle({
   Name = "Auto Loop Hunt All Eggs to Base",
   CurrentValue = false,
   Flag = "AutoEggHuntToggle",
   Callback = function(Value)
       autoEggHunt = Value

       task.spawn(function()
           local player = game.Players.LocalPlayer
           
           while autoEggHunt do
               local character = player.Character
               if character and character:FindFirstChild("HumanoidRootPart") then
                   local hrp = character.HumanoidRootPart
                   local baseCFrame = hrp.CFrame
                   local eggFolder = workspace:FindFirstChild("Eggs") 
                       or workspace:FindFirstChild("EggSpawns") 
                       or workspace:FindFirstChild("Collectibles")

                   if eggFolder then
                       for _, egg in pairs(eggFolder:GetChildren()) do
                           if not autoEggHunt then break end
                           
                           -- Teleport ke Telur
                           local eggPos = egg:IsA("Model") and egg:GetPivot() or egg.CFrame
                           hrp.CFrame = eggPos
                           
                           task.wait(0.25)
                           
                           -- Teleport Kembali ke Base
                           hrp.CFrame = baseCFrame
                           task.wait(0.3)
                       end
                   end
               end
               task.wait(1)
           end
       end)
   end,
})

-- ====================================================================
-- TAB 2: PEMAIN & UTILITY SPEED
-- ====================================================================

-- Slider WalkSpeed
PlayerTab:CreateSlider({
   Name = "Kecepatan Jalan (WalkSpeed)",
   Range = {16, 200},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "WalkSpeedSlider",
   Callback = function(Value)
       local player = game.Players.LocalPlayer
       if player.Character and player.Character:FindFirstChild("Humanoid") then
           player.Character.Humanoid.WalkSpeed = Value
       end
   end,
})

-- Slider JumpPower
PlayerTab:CreateSlider({
   Name = "Kekuatan Lompat (JumpPower)",
   Range = {50, 300},
   Increment = 5,
   Suffix = "Power",
   CurrentValue = 50,
   Flag = "JumpPowerSlider",
   Callback = function(Value)
       local player = game.Players.LocalPlayer
       if player.Character and player.Character:FindFirstChild("Humanoid") then
           player.Character.Humanoid.UseJumpPower = true
           player.Character.Humanoid.JumpPower = Value
       end
   end,
})

-- 4. Load Saved Configuration
Rayfield:LoadConfiguration()

print("[Ride A Pet Hub] Skrip berhasil dimuat!")
