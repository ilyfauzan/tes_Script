local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()

local Window = OrionLib:MakeWindow({
    Name = "WayaeHUB",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = "WayaeHUB"
})

local MainTab = Window:MakeTab({
    Name = "🥚 Special Egg Hunter",
    Icon = "rbxassetid://4483362458",
    PremiumOnly = false
})

local detectedEggsList = {}
local selectedEggIndex = 1
local eggDropdown = nil

local player = game.Players.LocalPlayer

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

-- Tombol 1: Lacak Telur
MainTab:AddButton({
    Name = "🔍 1. Lacak Posisi Telur Special (100B - 2.5T)",
    Callback = function()
        local eggs = ScanSpecialEggs()
        if #eggs > 0 then
            local options = {}
            for i, eggData in ipairs(eggs) do
                table.insert(options, tostring(i) .. ". " .. eggData.Name)
            end
            if eggDropdown then
                eggDropdown:Refresh(options)
            end
            OrionLib:MakeNotification({
                Name = "✅ Berhasil Melacak!",
                Content = "Ditemukan " .. tostring(#eggs) .. " Telur Special!",
                Image = "rbxassetid://4483362458",
                Time = 4
            })
        else
            OrionLib:MakeNotification({
                Name = "❌ Tidak Ada Telur",
                Content = "Telur 100B/300B/1T/2.5T belum spawn di map.",
                Image = "rbxassetid://4483362458",
                Time = 4
            })
        end
    end
})

-- Dropdown 2: Pilih Telur
eggDropdown = MainTab:AddDropdown({
    Name = "📌 2. Pilih Telur Target",
    Default = "Belum ada telur dilacak",
    Options = {"Belum ada telur dilacak"},
    Callback = function(Value)
        local idxStr = tostring(Value):match("^(%d+)%.")
        if idxStr then
            selectedEggIndex = tonumber(idxStr)
        end
    end
})

-- Tombol 3: Teleport ke Telur
MainTab:AddButton({
    Name = "🚀 3. Teleport ke Lokasi Telur",
    Callback = function()
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        if #detectedEggsList == 0 then ScanSpecialEggs() end

        if #detectedEggsList > 0 then
            local target = detectedEggsList[selectedEggIndex] or detectedEggsList[1]
            if target and target.CFrame then
                hrp.CFrame = target.CFrame + Vector3.new(0, 3, 0)
                OrionLib:MakeNotification({
                    Name = "🚀 Teleport Berhasil!",
                    Content = "Posisi: " .. target.Name,
                    Image = "rbxassetid://4483362458",
                    Time = 4
                })
            end
        else
            OrionLib:MakeNotification({
                Name = "⚠️ Gagal Teleport",
                Content = "Klik 'Lacak Posisi Telur' dulu!",
                Image = "rbxassetid://4483362458",
                Time = 4
            })
        end
    end
})

-- Tombol 4: Teleport ke Area Sell
MainTab:AddButton({
    Name = "🏪 Teleport ke Area Sell",
    Callback = function()
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
            OrionLib:MakeNotification({
                Name = "🏪 Teleport ke Sell!",
                Content = "Berhasil teleport ke area Sell!",
                Image = "rbxassetid://4483362458",
                Time = 3
            })
        else
            OrionLib:MakeNotification({
                Name = "⚠️ Sell Tidak Ditemukan",
                Content = "Objek Sell tidak ada di map saat ini.",
                Image = "rbxassetid://4483362458",
                Time = 5
            })
        end
    end
})

OrionLib:Init()
