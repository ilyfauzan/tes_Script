local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local randomGuiName = "Wayae_" .. HttpService:GenerateGUID(false):sub(1, 8)

local function SafeTweenTeleport(targetCFrame, speedMultiplier)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = character.HumanoidRootPart
    
    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    local duration = math.clamp(distance / (speedMultiplier or 140), 0.15, 1.5)
    
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
PlayerTab = Window:CreateTab("Pemain & Speed", 4483362458)

local autoEggHunt = false
local autoLegendaryTeleport = false

local function FindAllSpecialEggs()
    local foundEggs = {}
    local searchLocations = {
        workspace:FindFirstChild("Eggs"),
        workspace:FindFirstChild("EggSpawns"),
        workspace:FindFirstChild("Collectibles"),
        workspace:FindFirstChild("Map"),
        workspace
    }

    local targetKeywords = {"100b", "300b", "1t", "2.5t", "legend", "mythic", "eternal", "secret", "special"}

    for _, location in pairs(searchLocations) do
        if location then
            for _, obj in pairs(location:GetDescendants()) do
                local nameLower = obj.Name:lower()
                local matched = false
                for _, kw in pairs(targetKeywords) do
                    if nameLower:find(kw) then
                        matched = true
                        break
                    end
                end

                if matched then
                    local targetInst = obj:IsA("Model") and obj or (obj:IsA("BasePart") and obj or nil)
                    if targetInst and not table.find(foundEggs, targetInst) then
                        table.insert(foundEggs, targetInst)
                    end
                end

                if obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") or obj:IsA("TextLabel") then
                    if obj:IsA("TextLabel") then
                        local txt = obj.Text:lower()
                        if txt:find("100b") or txt:find("300b") or txt:find("1t") or txt:find("2.5t") or txt:find("in map") then
                            local parentModel = obj:FindFirstAncestorOfClass("Model") or obj:FindFirstAncestorOfClass("BasePart")
                            if parentModel and not table.find(foundEggs, parentModel) then
                                table.insert(foundEggs, parentModel)
                            end
                        end
                    end
                end
            end
        end
    end

    local character = LocalPlayer.Character
    if character then
        for _, child in pairs(character:GetDescendants()) do
            if child:IsA("Beam") and child.Attachment1 then
                local targetPart = child.Attachment1.Parent
                if targetPart then
                    local parentInst = targetPart:IsA("Model") and targetPart or targetPart.Parent
                    if parentInst and not table.find(foundEggs, parentInst) then
                        table.insert(foundEggs, parentInst)
                    end
                end
            end
        end
    end

    return foundEggs
end

local function FindLegendaryEgg()
    local eggs = FindAllSpecialEggs()
    if #eggs > 0 then
        local first = eggs[1]
        return first:IsA("Model") and first:GetPivot() or first.CFrame
    end
    return nil
end

local legendHighlight = nil
local function HighlightLegendaryEgg()
    local eggs = FindAllSpecialEggs()
    if #eggs > 0 then
        local targetObj = eggs[1]
        if not legendHighlight or legendHighlight.Parent ~= targetObj then
            if legendHighlight then legendHighlight:Destroy() end
            legendHighlight = Instance.new("Highlight")
            legendHighlight.Name = "WayaeEggESP"
            legendHighlight.FillColor = Color3.fromRGB(255, 215, 0)
            legendHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            legendHighlight.FillTransparency = 0.3
            legendHighlight.Parent = targetObj
        end
        return true
    else
        if legendHighlight then
            legendHighlight:Destroy()
            legendHighlight = nil
        end
        return false
    end
end

EggTab:CreateButton({
   Name = "Ambil Telur Terdekat & Balik ke Base",
   Callback = function()
       local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
       local hrp = character:FindFirstChild("HumanoidRootPart")

       if not hrp then return end

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
                  Content = "Berhasil mengambil telur!",
                  Duration = 3,
               })
           end
       end
   end,
})

EggTab:CreateToggle({
   Name = "Auto Loop Hunt All Eggs",
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

EggTab:CreateButton({
   Name = "🎯 Teleport ke Telur Special (100B - 2.5T)",
   Callback = function()
       local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
       local hrp = character:FindFirstChild("HumanoidRootPart")

       if not hrp then return end
       local baseCFrame = hrp.CFrame

       local legendaryCFrame = FindLegendaryEgg()
       if legendaryCFrame then
           Rayfield:Notify({
               Title = "Telur Special Ditemukan!",
               Content = "Meluncur ke lokasi...",
               Duration = 3,
           })
           SafeTweenTeleport(legendaryCFrame, 150)
           task.wait(0.5)
           SafeTweenTeleport(baseCFrame, 150)
       else
           Rayfield:Notify({
               Title = "Tidak Ditemukan",
               Content = "Belum ada Telur Special (100B-2.5T) yang spawn!",
               Duration = 4,
           })
       end
   end,
})

EggTab:CreateToggle({
   Name = "⚡ Auto Sweep Semua Telur Special (100B - 2.5T)",
   CurrentValue = false,
   Flag = "AutoLegendaryToggle",
   Callback = function(Value)
       autoLegendaryTeleport = Value
       task.spawn(function()
           while autoLegendaryTeleport do
               local character = LocalPlayer.Character
               if character and character:FindFirstChild("HumanoidRootPart") then
                   local hrp = character.HumanoidRootPart
                   local baseCFrame = hrp.CFrame
                   local specialEggs = FindAllSpecialEggs()
                   
                   if #specialEggs > 0 then
                       Rayfield:Notify({
                           Title = "⚡ Telur Special Terdeteksi!",
                           Content = "Mengambil " .. tostring(#specialEggs) .. " Telur Special...",
                           Duration = 3,
                       })

                       for _, eggInst in pairs(specialEggs) do
                           if not autoLegendaryTeleport then break end
                           local eggCFrame = eggInst:IsA("Model") and eggInst:GetPivot() or eggInst.CFrame
                           
                           SafeTweenTeleport(eggCFrame, 160)
                           task.wait(0.4)
                       end

                       SafeTweenTeleport(baseCFrame, 160)
                       task.wait(4)
                   end
               end
               task.wait(2)
           end
       end)
   end,
})

local espEnabled = false
EggTab:CreateToggle({
   Name = "✨ Sorot Telur Special (Golden ESP)",
   CurrentValue = false,
   Flag = "LegendaryESPToggle",
   Callback = function(Value)
       espEnabled = Value
       task.spawn(function()
           while espEnabled do
               HighlightLegendaryEgg()
               task.wait(3)
           end
           if legendHighlight then
               legendHighlight:Destroy()
               legendHighlight = nil
           end
       end)
   end,
})

PlayerTab:CreateSlider({
   Name = "Kecepatan Jalan (WalkSpeed)",
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
