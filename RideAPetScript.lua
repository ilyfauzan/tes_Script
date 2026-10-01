local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "WayaeHUB",
   LoadingTitle = "Memuat WayaeHUB...",
   LoadingSubtitle = "by Antigravity",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "WayaeHUBConfig",
      FileName = "Config"
   },
   Discord = {
      Enabled = false,
   },
   KeySystem = false
})

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

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
ToggleButton.Image = "rbxassetid://6031097225"
ToggleButton.Parent = ToggleGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0.5, 0)
ToggleCorner.Parent = ToggleButton

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(0, 170, 255)
ToggleStroke.Thickness = 2
ToggleStroke.Parent = ToggleButton

local uiVisible = true
ToggleButton.MouseButton1Click:Connect(function()
    uiVisible = not uiVisible
    if Window and Window.Modify then
        Rayfield:ToggleUI()
    else
        local mainFrame = CoreGui:FindFirstChild("Rayfield") or (gethui and gethui():FindFirstChild("Rayfield"))
        if mainFrame then
            mainFrame.Enabled = uiVisible
        end
    end
end)

local EggTab = Window:CreateTab("Egg Hunt", 4483362458)
local PlayerTab = Window:CreateTab("Pemain & Speed", 4483362458)

local autoEggHunt = false

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
               local eggPosition = targetEgg:IsA("Model") and targetEgg:GetPivot() or targetEgg.CFrame
               hrp.CFrame = eggPosition
               
               task.wait(0.3)

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
                           
                           local eggPos = egg:IsA("Model") and egg:GetPivot() or egg.CFrame
                           hrp.CFrame = eggPos
                           
                           task.wait(0.25)
                           
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

Rayfield:LoadConfiguration()

print("[WayaeHUB] Skrip berhasil dimuat!")
