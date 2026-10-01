local pcall = pcall
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local randomGuiName = "Wayae_" .. HttpService:GenerateGUID(false):sub(1, 8)

pcall(function()
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" or method == "kick" or method == "Ban" or method == "ban" then
            if self == LocalPlayer then
                return nil
            end
        end
        return oldNamecall(self, ...)
    end)

    local oldIndex
    oldIndex = hookmetamethod(game, "__index", function(self, key)
        if not checkcaller() and self:IsA("Humanoid") and self.Parent == LocalPlayer.Character then
            if key == "WalkSpeed" then
                return 16
            elseif key == "JumpPower" then
                return 50
            end
        end
        return oldIndex(self, key)
    end)
end)

local function SafeTweenTeleport(targetCFrame, speedMultiplier)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = character.HumanoidRootPart
    
    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    local duration = math.clamp(distance / (speedMultiplier or 120), 0.1, 1.5)
    
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
    tween.Completed:Wait()
end

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

for _, oldGui in pairs(CoreGui:GetChildren()) do
    if oldGui.Name:find("Wayae_") or oldGui.Name == "RideAPetToggleButton" then
        oldGui:Destroy()
    end
end

local ToggleGui = Instance.new("ScreenGui")
ToggleGui.Name = randomGuiName
if gethui then
    ToggleGui.Parent = gethui()
else
    ToggleGui.Parent = CoreGui
end

local ToggleButton = Instance.new("ImageButton")
ToggleButton.Name = HttpService:GenerateGUID(false):sub(1, 6)
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

local EggTab = Window:CreateTab("Egg Hunt (Safe)", 4483362458)
local PlayerTab = Window:CreateTab("Pemain & Speed", 4483362458)

local autoEggHunt = false

EggTab:CreateButton({
   Name = "Ambil Telur Terdekat & Balik ke Base (Safe Tween)",
   Callback = function()
       local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
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
               
               SafeTweenTeleport(eggPosition, 150)
               task.wait(0.3)

               SafeTweenTeleport(baseCFrame, 150)
               
               Rayfield:Notify({
                  Title = "Berhasil!",
                  Content = "Berhasil mengambil telur secara aman!",
                  Duration = 3,
               })
           else
               Rayfield:Notify({
                  Title = "Informasi",
                  Content = "Tidak ada telur yang ditemukan!",
                  Duration = 3,
               })
           end
       else
           Rayfield:Notify({
               Title = "Peringatan",
               Content = "Folder telur ('Eggs') tidak ditemukan!",
               Duration = 3,
           })
       end
   end,
})

EggTab:CreateToggle({
   Name = "Auto Loop Hunt All Eggs (Safe Mode)",
   CurrentValue = false,
   Flag = "AutoEggHuntToggle",
   Callback = function(Value)
       autoEggHunt = Value

       task.spawn(function()
           while autoEggHunt do
               local character = LocalPlayer.Character
               if character and character:FindFirstChild("HumanoidRootPart") then
                   local baseCFrame = character.HumanoidRootPart.CFrame
                   local eggFolder = workspace:FindFirstChild("Eggs") 
                       or workspace:FindFirstChild("EggSpawns") 
                       or workspace:FindFirstChild("Collectibles")

                   if eggFolder then
                       for _, egg in pairs(eggFolder:GetChildren()) do
                           if not autoEggHunt then break end
                           
                           local eggPos = egg:IsA("Model") and egg:GetPivot() or egg.CFrame
                           
                           SafeTweenTeleport(eggPos, 140)
                           task.wait(0.3)
                           
                           SafeTweenTeleport(baseCFrame, 140)
                           task.wait(0.4)
                       end
                   end
               end
               task.wait(1)
           end
       end)
   end,
})

PlayerTab:CreateSlider({
   Name = "Kecepatan Jalan Safe (WalkSpeed)",
   Range = {16, 120},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "WalkSpeedSlider",
   Callback = function(Value)
       if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
           LocalPlayer.Character.Humanoid.WalkSpeed = Value
       end
   end,
})

PlayerTab:CreateSlider({
   Name = "Kekuatan Lompat (JumpPower)",
   Range = {50, 250},
   Increment = 5,
   Suffix = "Power",
   CurrentValue = 50,
   Flag = "JumpPowerSlider",
   Callback = function(Value)
       if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
           LocalPlayer.Character.Humanoid.UseJumpPower = true
           LocalPlayer.Character.Humanoid.JumpPower = Value
       end
   end,
})

Rayfield:LoadConfiguration()
