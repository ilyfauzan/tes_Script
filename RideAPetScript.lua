local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "WayaeHUB",
   LoadingTitle = "Memuat WayaeHUB Simple...",
   LoadingSubtitle = "by Antigravity",
   ConfigurationSaving = {
      Enabled = false
   },
   Discord = {
      Enabled = false
   },
   KeySystem = false
})

local MainTab = Window:CreateTab("Special Egg Hunter", 4483362458)

local detectedEggsList = {}

local function ScanSpecialEggs()
    detectedEggsList = {}
    
    local specialNames = {
        ["blackhole"] = "100B - Blackhole Egg",
        ["solaris"] = "300B - Solaris Egg",
        ["cherub"] = "1T - Cherub Egg",
        ["volcanic"] = "2.5T - Volcanic Egg"
    }

    for _, obj in pairs(workspace:GetDescendants()) do
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
                    -- Cari PrimaryPart dulu (lebih akurat)
                    if obj.PrimaryPart then
                        eggCFrame = obj.PrimaryPart.CFrame
                    else
                        -- Pakai BoundingBox biar dapat posisi tengah model (bukan alas)
                        local cf, size = obj:GetBoundingBox()
                        eggCFrame = cf
                    end
                else
                    eggCFrame = obj.CFrame
                end
                table.insert(detectedEggsList, {
                    Name = foundTierName .. " [" .. obj.Name .. "]",
                    Instance = obj,
                    CFrame = eggCFrame
                })
            end
        end
    end

    return detectedEggsList
end



local selectedEggIndex = 1
local eggDropdown = nil

MainTab:CreateButton({
   Name = "🔍 1. Lacak Posisi Telur Special (100B - 2.5T)",
   Callback = function()
       local eggs = ScanSpecialEggs()
       if #eggs > 0 then
           local options = {}
           for i, eggData in ipairs(eggs) do
               table.insert(options, tostring(i) .. ". " .. eggData.Name)
           end
           
           if eggDropdown then
               eggDropdown:Refresh(options, true)
           end
           
           Rayfield:Notify({
               Title = "🎯 BERHASIL MELACAK!",
               Content = "Ditemukan " .. tostring(#eggs) .. " Telur Special!",
               Duration = 4,
           })
       else
           Rayfield:Notify({
               Title = "❌ Tidak Ada Telur Special",
               Content = "Telur 100B/300B/1T/2.5T belum spawn di map saat ini.",
               Duration = 4,
           })
       end
   end,
})

eggDropdown = MainTab:CreateDropdown({
   Name = "📌 2. Pilih Telur Target",
   Options = {"Belum ada telur dilacak"},
   CurrentOption = {"Belum ada telur dilacak"},
   MultipleOptions = false,
   Flag = "SelectedEggDropdown",
   Callback = function(Option)
       local selectedText = type(Option) == "table" and Option[1] or Option
       local idxStr = selectedText:match("^(%d+)%.")
       if idxStr then
           selectedEggIndex = tonumber(idxStr)
       end
   end,
})

MainTab:CreateButton({
   Name = "🚀 3. Teleport & Diam di Lokasi Telur",
   Callback = function()
       local player = game.Players.LocalPlayer
       local character = player.Character or player.CharacterAdded:Wait()
       local hrp = character:FindFirstChild("HumanoidRootPart")

       if not hrp then return end

       if #detectedEggsList == 0 then
           ScanSpecialEggs()
       end

       if #detectedEggsList > 0 then
           local target = detectedEggsList[selectedEggIndex] or detectedEggsList[1]
           if target and target.CFrame then
               hrp.CFrame = target.CFrame + Vector3.new(0, 3, 0)
               
               Rayfield:Notify({
                   Title = "🚀 Berhasil Teleport!",
                   Content = "Anda sekarang berada di posisi " .. target.Name .. "!",
                   Duration = 4,
               })
           end
       else
           Rayfield:Notify({
               Title = "⚠️ Gagal Teleport",
               Content = "Klik 'Lacak Posisi Telur' dulu saat telur spawn!",
               Duration = 4,
           })
       end
   end,
})

Rayfield:LoadConfiguration()

