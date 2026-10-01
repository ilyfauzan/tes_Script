local Wayae = getgenv().Wayae
local player = Wayae.player

Wayae.UI.ScanBtn.MouseButton1Click:Connect(function()
    local eggs = Wayae.ScanSpecialEggs()
    if #eggs > 0 then
        local options = {}
        for i, eggData in ipairs(eggs) do
            table.insert(options, tostring(i) .. ". " .. eggData.Name)
        end
        Wayae.UI.RefreshDropdown(options)
        Wayae.UI.DropBtn.Text = "▾  " .. options[1]
        Wayae.selectedEggIndex = 1
        Wayae.UI.Notify("✅ Berhasil Melacak!", "Ditemukan " .. #eggs .. " Telur Special!", 4)
    else
        Wayae.UI.Notify("❌ Tidak Ada Telur", "Telur 100B/300B/1T/2.5T belum spawn di map.", 4)
    end
end)

Wayae.UI.TeleportBtn.MouseButton1Click:Connect(function()
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if #Wayae.detectedEggsList == 0 then Wayae.ScanSpecialEggs() end

    if #Wayae.detectedEggsList > 0 then
        local target = Wayae.detectedEggsList[Wayae.selectedEggIndex] or Wayae.detectedEggsList[1]
        if target and target.CFrame then
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            local targetPos = target.CFrame.Position + Vector3.new(0, 1.5, 0)
            character:PivotTo(CFrame.new(targetPos) * target.CFrame.Rotation)
            Wayae.UI.Notify("🚀 Teleport Berhasil!", "Posisi: " .. target.Name, 4)
        end
    else
        Wayae.UI.Notify("⚠️ Gagal Teleport", "Klik 'Lacak Telur' dulu saat telur spawn!", 4)
    end
end)

Wayae.UI.SellBtn.MouseButton1Click:Connect(function()
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local plotTarget = nil
    local playerName = player.Name:lower()
    local playerDisplayName = player.DisplayName:lower()

    for _, obj in pairs(workspace:GetDescendants()) do
        if char and obj:IsDescendantOf(char) then continue end

        local foundPlot = false

        -- 1. Cek dari nama objek (misal: "Plot_Fauzan")
        if (obj:IsA("Model") or obj:IsA("Folder")) and (obj.Name:lower():find(playerName) or obj.Name:lower():find(playerDisplayName)) then
            foundPlot = true
        end

        -- 2. Cek dari TextLabel atau StringValue (misal: "Fauzan's Ranch" atau "Your Ranch")
        if not foundPlot and (obj:IsA("TextLabel") or obj:IsA("StringValue")) then
            local text = (obj:IsA("TextLabel") and obj.Text or tostring(obj.Value)):lower()
            if text:find(playerName) or text:find(playerDisplayName) or text:find("your ranch") or text:find("my ranch") or text:find("your plot") or text:find("my plot") then
                foundPlot = true
            end
        end

        -- 3. Cek dari ObjectValue (misal: Owner = Player)
        if not foundPlot and obj:IsA("ObjectValue") and obj.Value == player then
            foundPlot = true
        end

        if foundPlot then
            local current = (obj:IsA("Model") or obj:IsA("Folder")) and obj or obj.Parent
            local plotModel = nil
            
            while current and current ~= workspace do
                if current:IsA("Model") or current:IsA("Folder") then
                    plotModel = current
                end
                current = current.Parent
            end
            
            if plotModel then
                local spawnPad = nil
                for _, child in pairs(plotModel:GetDescendants()) do
                    if child:IsA("SpawnLocation") or (child:IsA("BasePart") and child.Name:lower():find("spawn")) then
                        spawnPad = child
                        break
                    end
                end

                if spawnPad and spawnPad:IsA("BasePart") then
                    plotTarget = spawnPad.CFrame + Vector3.new(0, 5, 0)
                    break
                end

                local ok, cf, size = pcall(function() return plotModel:GetBoundingBox() end)
                if ok and cf and size then
                    local groundY = cf.Position.Y - (size.Y/2) + 5
                    plotTarget = CFrame.new(cf.Position.X, groundY, cf.Position.Z) * cf.Rotation
                    break
                end
            end
        end
    end

    if plotTarget then
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        char:PivotTo(plotTarget)
        Wayae.UI.Notify("🏕️ Teleport Plot", "Berhasil pulang ke ranch/plot kamu!", 4)
    else
        Wayae.UI.Notify("⚠️ Plot Tidak Ditemukan", "Script tidak bisa mendeteksi area atas namamu. Mungkin kamu belum klaim plot?", 6)
    end
end)

Wayae.UI.VolcanicTestBtn.MouseButton1Click:Connect(function()
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local targetPos = Vector3.new(-5332, 40912, -3542)
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    hrp.CFrame = CFrame.new(targetPos) * hrp.CFrame.Rotation
    Wayae.UI.Notify("🌋 Volcanic Teleport", "Berhasil teleport dengan aman!", 4)
end)

Wayae.UI.GetPosBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local p = hrp.Position
    Wayae.UI.Notify(
        "📍 Posisi Kamu Sekarang",
        string.format("X: %.0f\nY: %.0f\nZ: %.0f", p.X, p.Y, p.Z),
        10
    )
end)
