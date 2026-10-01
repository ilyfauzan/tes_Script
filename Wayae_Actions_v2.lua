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
    local playerName = player.Name
    local playerDisplayName = player.DisplayName

    for _, obj in pairs(workspace:GetDescendants()) do
        -- Abaikan karakter kita sendiri (biar nametag karakter nggak dianggap plot)
        if char and obj:IsDescendantOf(char) then continue end

        if obj:IsA("TextLabel") or obj:IsA("StringValue") then
            local text = (obj:IsA("TextLabel") and obj.Text or tostring(obj.Value))
            -- Cari text yang mengandung nama kita
            if text:find(playerName) or text:find(playerDisplayName) then
                local current = obj.Parent
                local plotModel = nil
                
                -- Cari model teratas (biasanya itu folder/model Plot nya)
                while current and current ~= workspace do
                    if current:IsA("Model") or current:IsA("Folder") then
                        plotModel = current
                    end
                    current = current.Parent
                end
                
                if plotModel then
                    -- Cari spawn pad di dalam plot
                    local spawnPad = nil
                    for _, child in pairs(plotModel:GetDescendants()) do
                        if child:IsA("SpawnLocation") or child:IsA("BasePart") and child.Name:lower():find("spawn") then
                            spawnPad = child
                            break
                        end
                    end

                    if spawnPad and spawnPad:IsA("BasePart") then
                        plotTarget = spawnPad.CFrame + Vector3.new(0, 5, 0)
                        break
                    end

                    -- Cadangan kalau nggak ada pad khusus: ambil tengah-tengah plot tapi nempel tanah
                    local ok, cf, size = pcall(function() return plotModel:GetBoundingBox() end)
                    if ok and cf and size then
                        local groundY = cf.Position.Y - (size.Y/2) + 5
                        plotTarget = CFrame.new(cf.Position.X, groundY, cf.Position.Z) * cf.Rotation
                        break
                    end
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
