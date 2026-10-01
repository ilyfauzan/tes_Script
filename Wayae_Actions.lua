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
            character:PivotTo(target.CFrame + Vector3.new(0, 1.5, 0))
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
        Wayae.UI.Notify("🏪 Teleport ke Sell!", "Berhasil teleport ke area Sell!", 3)
    else
        Wayae.UI.Notify("⚠️ Sell Tidak Ditemukan", "Objek Sell tidak ada di map saat ini.", 5)
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
