local Wayae = getgenv().Wayae

Wayae.ScanSpecialEggs = function()
    Wayae.detectedEggsList = {}

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
        ["volcanic"]  = "2.5T - Volcanic Egg",
        ["tidal"]     = "2.5T - Volcanic Egg" 
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
                -- FILTER SUPER KETAT: Telur asli PASTI punya ProximityPrompt buat diklaim (Pick Up).
                -- Kalau nggak ada ProximityPrompt, berarti itu cuma patung pajangan atau papan skor!
                local hasPrompt = false
                for _, desc in pairs(obj:GetDescendants()) do
                    if desc:IsA("ProximityPrompt") and desc.Enabled == true then
                        hasPrompt = true
                        break
                    end
                end
                
                -- Skip kalau ini bukan telur sungguhan
                if not hasPrompt then continue end

                local eggCFrame

                if obj:IsA("Model") then
                    local promptPart = nil
                    for _, desc in pairs(obj:GetDescendants()) do
                        if desc:IsA("ProximityPrompt") and desc.Parent:IsA("BasePart") then
                            promptPart = desc.Parent
                            break
                        end
                    end

                    local ok, cf, size = pcall(function()
                        return obj:GetBoundingBox()
                    end)
                    
                    if ok and cf and size then
                        local targetPos = cf.Position + Vector3.new(0, -size.Y/2 + 1.5, 0)
                        eggCFrame = CFrame.new(targetPos) * cf.Rotation
                    elseif promptPart then
                        eggCFrame = promptPart.CFrame
                    elseif obj.PrimaryPart then
                        eggCFrame = obj.PrimaryPart.CFrame
                    else
                        eggCFrame = obj:GetPivot()
                    end
                else
                    eggCFrame = obj.CFrame
                end

                -- FILTER KHUSUS VOLCANIC EGG:
                -- Karena developer menaruh patung "Tidal Egg" di lobby, patung itu sering terdeteksi.
                -- Telur Volcanic yang ASLI pasti spawn di dalam gua (koordinat sekitar X: -5332, Y: 40912, Z: -3542).
                if foundTierName == "2.5T - Volcanic Egg" then
                    local cavePos = Vector3.new(-5332, 40912, -3542)
                    -- Kalau jarak telur ini lebih dari 200 stud dari gua, berarti ini patung lobby! SKIP!
                    if (eggCFrame.Position - cavePos).Magnitude > 200 then
                        continue
                    end
                    -- Gunakan posisi paksa agar aman dari dinding
                    eggCFrame = CFrame.new(cavePos)
                end

                local isDuplicate = false
                for _, existing in ipairs(Wayae.detectedEggsList) do
                    if existing.CFrame and eggCFrame then
                        if (existing.CFrame.Position - eggCFrame.Position).Magnitude < 5 then
                            isDuplicate = true
                            break
                        end
                    end
                end

                if not isDuplicate then
                    table.insert(Wayae.detectedEggsList, {
                        Name = foundTierName .. " [" .. obj.Name .. "]",
                        Instance = obj,
                        CFrame = eggCFrame
                    })
                end
            end
        end
    end

    return Wayae.detectedEggsList
end
