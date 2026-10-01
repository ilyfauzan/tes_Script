local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "WayaeHUB",
   LoadingTitle = "Memuat WayaeHUB...",
   LoadingSubtitle = "by Antigravity",
   ConfigurationSaving = {
      Enabled = false
   },
   Discord = {
      Enabled = false
   },
   KeySystem = false
})

local EggTab = Window:CreateTab("Egg Hunt", 4483362458)
local PlayerTab = Window:CreateTab("Pemain & Speed", 4483362458)

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

    local player = game.Players.LocalPlayer
    local character = player and player.Character
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

EggTab:CreateButton({
   Name = "Ambil Telur Terdekat & Balik ke Base",
   Callback = function()
       local player = game.Players.LocalPlayer
       local character = player.Character or player.CharacterAdded:Wait()
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
               hrp.CFrame = eggPosition
               task.wait(0.3)
               hrp.CFrame = baseCFrame
               
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
                           task.wait(0.3)
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

EggTab:CreateButton({
   Name = "🎯 Teleport ke Telur Special (100B - 2.5T)",
   Callback = function()
       local player = game.Players.LocalPlayer
       local character = player.Character or player.CharacterAdded:Wait()
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
           hrp.CFrame = legendaryCFrame
           task.wait(0.5)
           hrp.CFrame = baseCFrame
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
           local player = game.Players.LocalPlayer
           while autoLegendaryTeleport do
               local character = player.Character
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
                           hrp.CFrame = eggCFrame
                           task.wait(0.4)
                       end

                       hrp.CFrame = baseCFrame
                       task.wait(4)
                   end
               end
               task.wait(2)
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
