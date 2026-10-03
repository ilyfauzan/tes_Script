local Wayae = getgenv().Wayae
local player = Wayae.player

Wayae.TeleportToPlot = function()
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    local plotTarget = nil
    local playerName = player.Name:lower()
    local playerDisplayName = player.DisplayName:lower()
    local possibleFolders = {"plots", "tycoons", "ranches", "bases", "islands", "playerplots"}
    local plotContainer = nil
    for _, child in pairs(workspace:GetChildren()) do
        if child:IsA("Folder") or child:IsA("Model") then
            local name = child.Name:lower()
            for _, pName in ipairs(possibleFolders) do
                if name:find(pName) then
                    plotContainer = child
                    break
                end
            end
        end
        if plotContainer then break end
    end
    local searchArea = plotContainer and plotContainer:GetDescendants() or workspace:GetDescendants()
    for _, obj in pairs(searchArea) do
        if char and (obj == char or obj:IsDescendantOf(char)) then continue end
        local foundPlot = false
        if obj:IsA("TextLabel") or obj:IsA("StringValue") then
            local text = (obj:IsA("TextLabel") and obj.Text or tostring(obj.Value)):lower()
            if text:find("ranch") or text:find("plot") or text:find("tycoon") or text:find("base") then
                if text:find(playerName) or text:find(playerDisplayName) or text:find("your") or text:find("my") then
                    foundPlot = true
                end
            end
        end
        if not foundPlot and obj:IsA("ObjectValue") and obj.Value == player then
            foundPlot = true
        end
        if foundPlot then
            local current = (obj:IsA("Model") or obj:IsA("Folder") or obj:IsA("BasePart")) and obj or obj.Parent
            local plotModel = current
            local temp = current
            while temp and temp ~= workspace and temp ~= plotContainer do
                if temp:IsA("Model") or temp:IsA("Folder") then
                    plotModel = temp
                end
                temp = temp.Parent
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
                local ok, cf, size = pcall(function()
                    if plotModel:IsA("Model") then return plotModel:GetBoundingBox() end
                    return plotModel.CFrame, plotModel.Size
                end)
                if ok and cf and size then
                    local groundY = cf.Position.Y - (size.Y/2) + 5
                    plotTarget = CFrame.new(cf.Position.X, groundY, cf.Position.Z) * cf.Rotation
                    break
                end
            end
        end
    end
    if not plotTarget then
        local playerGui = player:FindFirstChild("PlayerGui")
        if playerGui then
            for _, obj in pairs(playerGui:GetDescendants()) do
                if obj:IsA("TextButton") or obj:IsA("ImageButton") then
                    local text = ""
                    if obj:IsA("TextButton") then text = obj.Text:lower() end
                    if obj.Name:lower():find("teleport") or obj.Name:lower():find("home") or obj.Name:lower():find("ranch") or text:find("ranch") or text:find("plot") then
                        pcall(function()
                                                        local vim = game:GetService("VirtualInputManager")
                                                        local absSize = btn.AbsoluteSize
                                                        if absSize.X > 0 and absSize.Y > 0 then
                                                            local cx = btn.AbsolutePosition.X + (absSize.X / 2)
                                                            local cy = btn.AbsolutePosition.Y + (absSize.Y / 2)
                                                            vim:SendMouseButtonEvent(cx, cy, 0, true, btn, 1)
                                                            task.wait(0.05)
                                                            vim:SendMouseButtonEvent(cx, cy, 0, false, btn, 1)
                                                        end
                                                    end)
                                                    if getconnections then
                            for _, conn in pairs(getconnections(obj.MouseButton1Click)) do
                                pcall(function() conn:Function() end)
                            end
                            for _, conn in pairs(getconnections(obj.Activated)) do
                                pcall(function() conn:Function() end)
                            end
                            return true
                        end
                    end
                end
            end
        end
    end
    if plotTarget then
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        char:PivotTo(plotTarget)
        return true
    end
    return false
end
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
    local possibleFolders = {"plots", "tycoons", "ranches", "bases", "islands", "playerplots"}
    local plotContainer = nil
    for _, child in pairs(workspace:GetChildren()) do
        if child:IsA("Folder") or child:IsA("Model") then
            local name = child.Name:lower()
            for _, pName in ipairs(possibleFolders) do
                if name:find(pName) then
                    plotContainer = child
                    break
                end
            end
        end
        if plotContainer then break end
    end
    local searchArea = plotContainer and plotContainer:GetDescendants() or workspace:GetDescendants()
    for _, obj in pairs(searchArea) do
        if char and (obj == char or obj:IsDescendantOf(char)) then continue end
        local foundPlot = false
        if obj:IsA("TextLabel") or obj:IsA("StringValue") then
            local text = (obj:IsA("TextLabel") and obj.Text or tostring(obj.Value)):lower()
            if text:find("ranch") or text:find("plot") or text:find("tycoon") or text:find("base") then
                if text:find(playerName) or text:find(playerDisplayName) or text:find("your") or text:find("my") then
                    foundPlot = true
                end
            end
        end
        if not foundPlot and obj:IsA("ObjectValue") and obj.Value == player then
            foundPlot = true
        end
        if foundPlot then
            local current = (obj:IsA("Model") or obj:IsA("Folder") or obj:IsA("BasePart")) and obj or obj.Parent
            local plotModel = current
            local temp = current
            while temp and temp ~= workspace and temp ~= plotContainer do
                if temp:IsA("Model") or temp:IsA("Folder") then
                    plotModel = temp
                end
                temp = temp.Parent
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
                local ok, cf, size = pcall(function()
                    if plotModel:IsA("Model") then return plotModel:GetBoundingBox() end
                    return plotModel.CFrame, plotModel.Size
                end)
                if ok and cf and size then
                    local groundY = cf.Position.Y - (size.Y/2) + 5
                    plotTarget = CFrame.new(cf.Position.X, groundY, cf.Position.Z) * cf.Rotation
                    break
                end
            end
        end
    end
    if not plotTarget then
        local playerGui = player:FindFirstChild("PlayerGui")
        if playerGui then
            for _, obj in pairs(playerGui:GetDescendants()) do
                if obj:IsA("TextButton") or obj:IsA("ImageButton") then
                    local text = ""
                    if obj:IsA("TextButton") then text = obj.Text:lower() end
                    if obj.Name:lower():find("teleport") or obj.Name:lower():find("home") or obj.Name:lower():find("ranch") or text:find("ranch") or text:find("plot") then
                        pcall(function()
                                                        local vim = game:GetService("VirtualInputManager")
                                                        local absSize = btn.AbsoluteSize
                                                        if absSize.X > 0 and absSize.Y > 0 then
                                                            local cx = btn.AbsolutePosition.X + (absSize.X / 2)
                                                            local cy = btn.AbsolutePosition.Y + (absSize.Y / 2)
                                                            vim:SendMouseButtonEvent(cx, cy, 0, true, btn, 1)
                                                            task.wait(0.05)
                                                            vim:SendMouseButtonEvent(cx, cy, 0, false, btn, 1)
                                                        end
                                                    end)
                                                    if getconnections then
                            for _, conn in pairs(getconnections(obj.MouseButton1Click)) do
                                pcall(function() conn:Function() end)
                            end
                            for _, conn in pairs(getconnections(obj.Activated)) do
                                pcall(function() conn:Function() end)
                            end
                            Wayae.UI.Notify("🏕️ Teleport UI Bawaan", "Menggunakan fitur teleport bawaan dari game!", 4)
                            return
                        end
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
        Wayae.UI.Notify("⚠️ Plot Tidak Ditemukan", "Coba gunakan fitur Teleport bawaan game jika script tidak mendeteksinya.", 6)
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

Wayae.savedLocation = nil

Wayae.UI.SaveLocBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    Wayae.savedLocation = hrp.CFrame
    Wayae.UI.Notify("💾 Lokasi Disimpan", "Berhasil menyimpan lokasimu saat ini!", 3)
end)

Wayae.UI.TpLocBtn.MouseButton1Click:Connect(function()
    if not Wayae.savedLocation then
        Wayae.UI.Notify("⚠️ Gagal", "Kamu belum menyimpan lokasi apapun! Klik Save Last Location dulu.", 4)
        return
    end
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    char:PivotTo(Wayae.savedLocation)
    Wayae.UI.Notify("🔙 Teleport Berhasil", "Berhasil kembali ke lokasi yang disimpan!", 3)
end)

Wayae.autoFarmRunning = false
Wayae.UI.AutoFarmBtn.MouseButton1Click:Connect(function()
    Wayae.autoFarmRunning = not Wayae.autoFarmRunning
    if Wayae.autoFarmRunning then
        Wayae.UI.AutoFarmBtn.Text = "🤖 4. Auto Farm Egg: ON"
        Wayae.UI.AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(30, 60, 30)
        Wayae.UI.Notify("🤖 Auto Farm Aktif", "Sedang mencari telur di map...", 4)
        
        task.spawn(function()
            while Wayae.autoFarmRunning do
                local char = player.Character or player.CharacterAdded:Wait()
                local hrp = char:FindFirstChild("HumanoidRootPart")
                
                -- Cari Telur baru di map
                local eggs = Wayae.ScanSpecialEggs()
                
                if #eggs > 0 and hrp then
                    Wayae.UI.Notify("🤖 Auto Farm", "Menemukan " .. #eggs .. " telur! Mengambil...", 3)
                    for _, eggData in ipairs(eggs) do
                        if not Wayae.autoFarmRunning then break end
                        local realEgg = eggData.Instance
                        if realEgg and realEgg.Parent ~= nil then
                            -- Gunakan CFrame yang sudah dihitung oleh scanner
                            local eggCFrame = eggData.CFrame
                            if eggCFrame then
                                -- Teleport ke Telur
                                hrp.AssemblyLinearVelocity = Vector3.zero
                                hrp.AssemblyAngularVelocity = Vector3.zero
                                local targetPos = eggCFrame.Position + Vector3.new(0, 1.5, 0)
                                char:PivotTo(CFrame.new(targetPos) * eggCFrame.Rotation)
                                
                                -- Tunggu karakter stabil
                                task.wait(0.3)
                                
                                -- Ambil telur dengan cara Trigger / Klik
                                local fired = false
                                for _, desc in pairs(realEgg:GetDescendants()) do
                                    if desc:IsA("ProximityPrompt") then
                                        if fireproximityprompt then
                                            fireproximityprompt(desc, 1) -- angka 1 untuk bypass hold duration kadang diperlukan
                                            fireproximityprompt(desc)
                                            fired = true
                                        end
                                    elseif desc:IsA("ClickDetector") then
                                        if fireclickdetector then
                                            fireclickdetector(desc)
                                            fired = true
                                        end
                                    end
                                end
                                
                                -- Kalau cuma bisa disentuh, goyangin karakter dikit
                                if not fired then
                                    hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, 1)
                                    task.wait(0.2)
                                    hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, -1)
                                end
                                
                                -- Tunggu 1.5 detik untuk animasi ambil/pickup
                                task.wait(1.5)
                                
                                -- Langsung pulang ke plot setelah ambil 1 telur agar bisa disetorkan
                                if Wayae.autoFarmRunning then
                                    local tpSuccess = Wayae.TeleportToPlot()
                                    if tpSuccess then
                                        -- Tunggu 1.5 detik biar char stabil di plot
                                        task.wait(1.5)
                                        
                                        -- 1. Lepas telur dari tangan biar kosong
                                        local hum = char:FindFirstChildOfClass("Humanoid")
                                        if hum then
                                            hum:UnequipTools()
                                        end
                                        
                                        -- 2. Coba cari Nest / Incubator di sekitar plot dan tembak otomatis biar telur beneran disetor
                                        for _, prompt in pairs(workspace:GetDescendants()) do
                                            if prompt:IsA("ProximityPrompt") and prompt.Parent and prompt.Parent:IsA("BasePart") then
                                                local dist = (prompt.Parent.Position - hrp.Position).Magnitude
                                                if dist < 60 then
                                                    local actionText = prompt.ActionText:lower()
                                                    local objectText = prompt.ObjectText:lower()
                                                    local name = prompt.Name:lower()
                                                    local parentName = prompt.Parent.Name:lower()
                                                    
                                                    if actionText:find("deposit") or actionText:find("incubate") or actionText:find("hatch") or actionText:find("place") or actionText:find("put") or objectText:find("nest") or parentName:find("incubator") or parentName:find("nest") then
                                                        if fireproximityprompt then
                                                            fireproximityprompt(prompt, 1)
                                                            fireproximityprompt(prompt)
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                        
                                        -- 3. Auto-Tap tombol UI Hotbar (Bypass Custom Inventory)
                                        local playerGui = player:FindFirstChild("PlayerGui")
                                        if playerGui and getconnections then
                                            for _, obj in pairs(playerGui:GetDescendants()) do
                                                if obj:IsA("GuiButton") then
                                                    local isSlot = false
                                                    for _, child in pairs(obj:GetDescendants()) do
                                                        if child:IsA("TextLabel") and child.Text:upper():find("KG") then
                                                            isSlot = true
                                                            break
                                                        end
                                                    end
                                                    if isSlot then
                                                        local isEquipped = false
                                                        -- Deteksi apakah slot sedang dipilih (border putih/terang)
                                                        if obj.BorderSizePixel > 0 and obj.BorderColor3.R > 0.8 and obj.BorderColor3.G > 0.8 and obj.BorderColor3.B > 0.8 then
                                                            isEquipped = true
                                                        end
                                                        for _, child in pairs(obj:GetDescendants()) do
                                                            if child:IsA("UIStroke") and child.Enabled and child.Color.R > 0.8 and child.Color.G > 0.8 and child.Color.B > 0.8 then
                                                                isEquipped = true
                                                            end
                                                            if (child:IsA("Frame") or child:IsA("ImageLabel")) and child.Visible and (child.Name:lower():find("select") or child.Name:lower():find("equip") or child.Name:lower():find("highlight") or child.Name:lower():find("border")) then
                                                                isEquipped = true
                                                            end
                                                        end
                                                        if isEquipped then
                                                            for _, conn in pairs(getconnections(obj.MouseButton1Click)) do
                                                                pcall(function() conn:Function() end)
                                                            end
                                                            for _, conn in pairs(getconnections(obj.Activated)) do
                                                                pcall(function() conn:Function() end)
                                                            end
                                                            -- Berhasil tap slot, lanjut
                                                            break
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                        
                                        -- Tunggu sebentar lagi biar animasinya selesai
                                        task.wait(0.2)
                                    else
                                        Wayae.UI.Notify("⚠️ Auto Farm", "Gagal teleport ke Plot!", 3)
                                    end
                                end
                            end
                        end
                    end
                else
                    Wayae.UI.Notify("🤖 Auto Farm", "Mencari telur... (Belum ada yang cocok)", 2)
                end
                
                -- Tunggu 3 Detik lalu scan lagi
                local waitTime = 3
                while waitTime > 0 and Wayae.autoFarmRunning do
                    task.wait(0.2)
                    waitTime = waitTime - 1
                end
            end
        end)
    else
        Wayae.UI.AutoFarmBtn.Text = "🤖 4. Auto Farm Egg: OFF"
        Wayae.UI.AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(60, 30, 30)
        Wayae.UI.Notify("🤖 Auto Farm Mati", "Auto Farm dihentikan.", 4)
    end
end)

Wayae.autoLuckRunning = false
Wayae.UI.AutoLuckBtn.MouseButton1Click:Connect(function()
    Wayae.autoLuckRunning = not Wayae.autoLuckRunning
    if Wayae.autoLuckRunning then
        Wayae.UI.AutoLuckBtn.Text = "🍀 5. Auto Upgrade Luck: ON"
        Wayae.UI.AutoLuckBtn.BackgroundColor3 = Color3.fromRGB(30, 60, 30)
        Wayae.UI.Notify("🍀 Auto Luck", "Memindai khusus di area Workspace (Aman dari Screen UI)...", 3)
        
        task.spawn(function()
            local vim = game:GetService("VirtualInputManager")
            local guiService = game:GetService("GuiService")
            while Wayae.autoLuckRunning do
                local char = player.Character
                if char then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local areas = {workspace} -- HANYA WORKSPACE, jangan sentuh PlayerGui agar UI layar tidak rusak
                        
                        for _, area in ipairs(areas) do
                            for _, desc in pairs(area:GetDescendants()) do
                                -- 1. SurfaceGui / BillboardGui
                                if desc:IsA("SurfaceGui") or desc:IsA("BillboardGui") then
                                    local parentPart = desc.Parent
                                    if desc:IsA("BillboardGui") and desc.Adornee then
                                        parentPart = desc.Adornee
                                    end
                                    
                                    local dist = 0
                                    if parentPart and parentPart:IsA("BasePart") then
                                        dist = (parentPart.Position - hrp.Position).Magnitude
                                    end
                                    
                                    -- Hanya scan jarak dekat
                                    if dist > 0 and dist < 60 then
                                        for _, btn in pairs(desc:GetDescendants()) do
                                            if btn:IsA("TextButton") or btn:IsA("ImageButton") or btn:IsA("GuiButton") then
                                                local hasKeyword = false
                                                local n = btn.Name:lower()
                                                if n:find("max") or n:find("upgrade") or n:find("buy") then hasKeyword = true end
                                                
                                                if btn:IsA("TextButton") then
                                                    local t = btn.Text:lower()
                                                    if t:find("max") or t:find("%$") or t:find("luck") or t:find("upgrade") then hasKeyword = true end
                                                end
                                                
                                                -- Cek semua anak di dalamnya
                                                if not hasKeyword then
                                                    for _, child in pairs(btn:GetDescendants()) do
                                                        if child:IsA("TextLabel") or child:IsA("TextButton") then
                                                            local t = child.Text:lower()
                                                            if t:find("max") or t:find("%$") or t:find("luck") or t:find("upgrade") then
                                                                hasKeyword = true
                                                                break
                                                            end
                                                        end
                                                    end
                                                end
                                                
                                                if hasKeyword then
                                                    if getconnections then
                                                        pcall(function()
                                                            for _, conn in pairs(getconnections(btn.MouseButton1Click)) do conn:Function() end
                                                            for _, conn in pairs(getconnections(btn.Activated)) do conn:Function() end
                                                        end)
                                                    end
                                                    
                                                    pcall(function()
                                                        local absSize = btn.AbsoluteSize
                                                        if absSize.X > 0 and absSize.Y > 0 then
                                                            local cx = btn.AbsolutePosition.X + (absSize.X / 2)
                                                            local cy = btn.AbsolutePosition.Y + (absSize.Y / 2)
                                                            vim:SendMouseButtonEvent(cx, cy, 0, true, btn, 1)
                                                            task.wait(0.01)
                                                            vim:SendMouseButtonEvent(cx, cy, 0, false, btn, 1)
                                                        end
                                                    end)
                                                    
                                                    pcall(function()
                                                        local oldSelect = guiService.SelectedObject
                                                        guiService.SelectedObject = btn
                                                        task.wait(0.01)
                                                        vim:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                                                        task.wait(0.01)
                                                        vim:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                                                        guiService.SelectedObject = oldSelect
                                                    end)
                                                end
                                            end
                                        end
                                    end
                                end
                                
                                -- 2. ClickDetector
                                if desc:IsA("ClickDetector") then
                                    local p = desc.Parent
                                    if p and p:IsA("BasePart") then
                                        if (p.Position - hrp.Position).Magnitude < 60 then
                                            local n = p.Name:lower()
                                            if n:find("max") or n:find("luck") or n:find("upgrade") or n:find("button") or n:find("buy") then
                                                if fireclickdetector then pcall(function() fireclickdetector(desc) end) end
                                            end
                                        end
                                    end
                                end
                                
                                -- 3. ProximityPrompt
                                if desc:IsA("ProximityPrompt") then
                                    local p = desc.Parent
                                    if p and p:IsA("BasePart") then
                                        if (p.Position - hrp.Position).Magnitude < 60 then
                                            local n = desc.Name:lower()
                                            local a = desc.ActionText:lower()
                                            if n:find("max") or n:find("luck") or a:find("max") or a:find("upgrade") or a:find("buy") then
                                                if fireproximityprompt then 
                                                    pcall(function() 
                                                        fireproximityprompt(desc, 1)
                                                        fireproximityprompt(desc)
                                                    end)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
    else
        Wayae.UI.AutoLuckBtn.Text = "🍀 5. Auto Upgrade Luck: OFF"
        Wayae.UI.AutoLuckBtn.BackgroundColor3 = Color3.fromRGB(45, 25, 30)
        Wayae.UI.Notify("🍀 Auto Luck", "Auto Upgrade dihentikan.", 3)
    end
end)