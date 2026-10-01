local WayaeHUB = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = WayaeHUB:CreateWindow({
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
local player = game.Players.LocalPlayer

-- ============================================================
-- UTILITY: Teleport Bertahap (Anti Position-Check)
-- Gerak perlahan step-by-step agar tidak terdeteksi sebagai
-- instant teleport oleh server-side anti-cheat
-- ============================================================
local function SafeTeleport(hrp, targetCF)
    local steps = 12
    local startCF = hrp.CFrame
    -- Tambah offset posisi random kecil agar tidak selalu sama persis
    local randX = math.random(-2, 2)
    local randZ = math.random(-2, 2)
    local finalCF = targetCF + Vector3.new(randX, 3, randZ)
    for i = 1, steps do
        if not hrp or not hrp.Parent then break end
        hrp.CFrame = startCF:Lerp(finalCF, i / steps)
        task.wait(0.04) -- ~0.5 detik total jalan
    end
end

-- ============================================================
-- UTILITY: Delay Human-like (Anti Bot Detection)
-- Jeda random agar pola aksi tidak terlihat seperti bot
-- ============================================================
local function HumanDelay()
    task.wait(math.random(8, 18) / 10) -- 0.8 - 1.8 detik random
end

-- ============================================================
-- SCAN TELUR SPECIAL
-- Filter telur di dalam karakter & base/plot pemain
-- ============================================================
local function ScanSpecialEggs()
    detectedEggsList = {}

    -- Kumpulkan semua karakter pemain agar tidak ikut di-scan
    local playerCharacters = {}
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr.Character then
            playerCharacters[plr.Character] = true
        end
    end

    -- Cek apakah objek adalah bagian dari karakter pemain manapun
    local function IsInsideCharacter(obj)
        local current = obj.Parent
        while current do
            if playerCharacters[current] then
                return true
            end
            current = current.Parent
        end
        return false
    end

    -- Keyword nama folder/model yang biasanya adalah base/plot milik pemain
    local plotKeywords = {"plot", "base", "pen", "farm", "yard", "house", "home", "island", "territory"}

    -- Cek apakah objek berada di dalam base/plot pemain
    local function IsInsidePlot(obj)
        local current = obj.Parent
        while current and current ~= workspace do
            local nameLower = current.Name:lower()
            for _, kw in ipairs(plotKeywords) do
                if nameLower:find(kw) then
                    return true
                end
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

                -- Cari BasePart paling tinggi dalam model (= telur, bukan alas platform)
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

                -- Hindari duplikat posisi yang sangat berdekatan
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
                        Name     = foundTierName .. " [" .. obj.Name .. "]",
                        Instance = obj,
                        CFrame   = eggCFrame
                    })
                end
            end
        end
    end

    return detectedEggsList
end

-- ============================================================
-- UI
-- ============================================================
local selectedEggIndex = 1
local eggDropdown = nil
local isTeleporting = false -- Cooldown guard agar tidak spam

MainTab:CreateButton({
   Name = "🔍 1. Lacak Posisi Telur Special (100B - 2.5T)",
   Callback = function()
       -- Delay human-like sebelum scan
       HumanDelay()
       local eggs = ScanSpecialEggs()
       if #eggs > 0 then
           local options = {}
           for i, eggData in ipairs(eggs) do
               table.insert(options, tostring(i) .. ". " .. eggData.Name)
           end
           if eggDropdown then
               eggDropdown:Refresh(options, true)
           end
           WayaeHUB:Notify({
               Title   = "🎯 BERHASIL MELACAK!",
               Content = "Ditemukan " .. tostring(#eggs) .. " Telur Special!",
               Duration = 4,
           })
       else
           WayaeHUB:Notify({
               Title   = "❌ Tidak Ada Telur Special",
               Content = "Telur 100B/300B/1T/2.5T belum spawn di map saat ini.",
               Duration = 4,
           })
       end
   end,
})

eggDropdown = MainTab:CreateDropdown({
   Name          = "📌 2. Pilih Telur Target",
   Options       = {"Belum ada telur dilacak"},
   CurrentOption = {"Belum ada telur dilacak"},
   MultipleOptions = false,
   Flag          = "SelectedEggDropdown",
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
       -- Cooldown guard: cegah spam klik
       if isTeleporting then
           WayaeHUB:Notify({
               Title   = "⏳ Harap Tunggu",
               Content = "Sedang dalam proses teleport...",
               Duration = 2,
           })
           return
       end

       local character = player.Character or player.CharacterAdded:Wait()
       local hrp = character:FindFirstChild("HumanoidRootPart")
       if not hrp then return end

       if #detectedEggsList == 0 then
           ScanSpecialEggs()
       end

       if #detectedEggsList > 0 then
           local target = detectedEggsList[selectedEggIndex] or detectedEggsList[1]
           if target and target.CFrame then
               isTeleporting = true

               -- Delay human-like sebelum teleport
               HumanDelay()

               -- Teleport bertahap (anti position-check)
               SafeTeleport(hrp, target.CFrame)

               WayaeHUB:Notify({
                   Title   = "🚀 Berhasil Teleport!",
                   Content = "Anda sekarang berada di posisi " .. target.Name .. "!",
                   Duration = 4,
               })

               isTeleporting = false
           end
       else
           WayaeHUB:Notify({
               Title   = "⚠️ Gagal Teleport",
               Content = "Klik 'Lacak Posisi Telur' dulu saat telur spawn!",
               Duration = 4,
           })
       end
   end,
})

MainTab:CreateButton({
   Name = "🏪 Teleport ke Area Sell",
   Callback = function()
       if isTeleporting then return end

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
           isTeleporting = true
           HumanDelay()
           SafeTeleport(hrp, sellTarget)
           WayaeHUB:Notify({
               Title   = "🏪 Teleport ke Sell!",
               Content = "Berhasil teleport ke area Sell!",
               Duration = 3,
           })
           isTeleporting = false
       else
           WayaeHUB:Notify({
               Title   = "⚠️ Area Sell Tidak Ditemukan",
               Content = "Objek 'Sell' tidak ditemukan di map.",
               Duration = 5,
           })
       end
   end,
})

WayaeHUB:LoadConfiguration()
