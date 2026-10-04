local Wayae = getgenv().Wayae
local player = Wayae.player
local RunService = game:GetService("RunService")

-- State noclip permanen (aktif saat dalam gua, mati saat keluar)
Wayae.noclipActive = false
local noclipConn = nil

Wayae.StartNoclip = function()
    Wayae.noclipActive = true
    if noclipConn then noclipConn:Disconnect() end
    -- Setiap frame: paksa CanCollide = false selama noclip aktif
    -- Physics engine tidak punya kesempatan untuk fling sama sekali
    noclipConn = RunService.Stepped:Connect(function()
        if not Wayae.noclipActive then
            noclipConn:Disconnect()
            noclipConn = nil
            -- Restore collision saat noclip dimatikan
            if player.Character then
                for _, p in pairs(player.Character:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = true end
                end
            end
            return
        end
        if player.Character then
            for _, p in pairs(player.Character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end)
end

Wayae.StopNoclip = function()
    Wayae.noclipActive = false
    -- noclipConn akan cleanup sendiri di Stepped berikutnya
end

-- Safe teleport ke lokasi dalam gua (noclip permanen hingga teleport keluar)
Wayae.SafeCaveTeleport = function(targetCFrame)
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    Wayae.StartNoclip() -- Nyalakan noclip permanen
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    char:PivotTo(targetCFrame)
end

Wayae.TeleportToPlot = function(useBlink)
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
        if useBlink then
            Wayae.StartNoclip()
            hrp.AssemblyLinearVelocity = Vector3.zero
            local currentPos = hrp.Position
            local targetPos = plotTarget.Position
            local distance = (currentPos - targetPos).Magnitude
            local stepDistance = 120
            local steps = math.ceil(distance / stepDistance)
            for i = 1, steps do
                local alpha = i / steps
                local nextPos = currentPos:Lerp(targetPos, alpha)
                char:PivotTo(CFrame.new(nextPos))
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
                task.wait(0.1)
            end
            char:PivotTo(plotTarget)
            Wayae.StopNoclip()
            hrp.AssemblyLinearVelocity = Vector3.zero
        else
            Wayae.StopNoclip() -- Matikan noclip saat sudah sampai di plot
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            char:PivotTo(plotTarget)
        end
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
    
    -- Step 1: Teleport ke PINTU MASUK gua dulu (trigger zone server-side)
    Wayae.UI.Notify("🌋 Volcanic", "Masuk zona gua...", 2)
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.CFrame = CFrame.new(-4967, 41275, -3542)
    
    -- Tunggu sebentar agar server mendeteksi player sudah masuk zona
    task.wait(1.5)
    
    -- Step 2: Baru noclip ke posisi telur
    Wayae.SafeCaveTeleport(CFrame.new(-5336, 40912, -3542))
    Wayae.UI.Notify("🌋 Volcanic Teleport", "Berhasil! Silakan ambil telurnya.", 5)
end)
Wayae.UI.GetPosBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local p = hrp.Position
    -- Tampilkan dalam satu baris agar tidak terpotong
    local posText = string.format("X:%.0f Y:%.0f Z:%.0f", p.X, p.Y, p.Z)
    Wayae.UI.Notify(
        "📍 Posisi Kamu Sekarang",
        posText,
        15 -- Durasi lebih lama biar sempat dicatat
    )
    -- Juga print ke console executor sebagai backup
    print("[WAYAE] Posisi: " .. posText)
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
    Wayae.SafeCaveTeleport(Wayae.savedLocation)
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
                                if eggData.Name:find("Volcanic") then
                                    -- Step 1 khusus telur vulkanik: masuk pintu gua dulu untuk trigger zone
                                    hrp.AssemblyLinearVelocity = Vector3.zero
                                    hrp.AssemblyAngularVelocity = Vector3.zero
                                    char:PivotTo(CFrame.new(-4967, 41275, -3542))
                                    task.wait(1.5)
                                end
                                
                                local targetPos = eggCFrame.Position + Vector3.new(0, 1.5, 0)
                                Wayae.SafeCaveTeleport(CFrame.new(targetPos) * eggCFrame.Rotation)
                                
                                -- Tunggu sebentar agar posisi stabil sebelum pickup
                                task.wait(0.4)
                                
                                -- Ambil telur
                                local fired = false
                                for _, desc in pairs(realEgg:GetDescendants()) do
                                    if desc:IsA("ProximityPrompt") then
                                        if fireproximityprompt then
                                            fireproximityprompt(desc, 1)
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
                                
                                if not fired then
                                    hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, 1)
                                    task.wait(0.2)
                                    hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, -1)
                                end
                                
                                task.wait(1.5)
                                
                                if Wayae.autoFarmRunning then
                                    -- STRATEGI VELOCITY PUSH (Fix AT - server deteksi CFrame teleport)
                                    -- Kita dorong karakter menggunakan physics (Velocity) bukan CFrame
                                    -- Server tidak bisa membedakan ini dari berlari sangat cepat
                                    
                                    local hum = char:FindFirstChildOfClass("Humanoid")
                                    
                                    Wayae.StartNoclip()
                                    
                                    -- Hitung posisi dalam base dan luar base
                                    local insideBasePos = Vector3.new(164, 40322, 1059)
                                    local outsideBasePos = Vector3.new(71, 40326, 915) -- Sesuai screenshot dari user
                                    
                                    -- 1. Teleport cepat ke luar base terlebih dahulu
                                    char:PivotTo(CFrame.new(outsideBasePos))
                                    hrp.AssemblyLinearVelocity = Vector3.zero
                                    task.wait(0.5)
                                    
                                    -- 2. Berdiam di luar base selama 10 detik sambil lompat-lompat (Anti-Cheat bypass)
                                    local vim = game:GetService("VirtualInputManager")
                                    local waitTimeOutside = 10
                                    local elapsedOutside = 0
                                    
                                    while Wayae.autoFarmRunning and elapsedOutside < waitTimeOutside do
                                        -- Tekan spasi untuk lompat (berfungsi juga untuk pet)
                                        vim:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                                        task.wait(0.1)
                                        vim:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                                        
                                        -- Jeda antar lompatan
                                        local delay = math.random(5, 10) / 10
                                        task.wait(delay)
                                        
                                        elapsedOutside = elapsedOutside + 0.1 + delay
                                    end
                                    
                                    -- 3. Gerak bertahap (jalan kaki cepat) dari luar base ke dalam base
                                    -- Kecepatan dipercepat agar telur tidak keburu pecah (100 stud/detik)
                                    local stepSize = 10
                                    local stepInterval = 0.1
                                    
                                    while (hrp.Position - insideBasePos).Magnitude > 5 and Wayae.autoFarmRunning do
                                        local dir = (insideBasePos - hrp.Position).Unit
                                        local dist = (hrp.Position - insideBasePos).Magnitude
                                        local move = math.min(stepSize, dist)
                                        
                                        char:PivotTo(CFrame.new(hrp.Position + dir * move))
                                        hrp.AssemblyLinearVelocity = Vector3.zero
                                        
                                        -- Kadang-kadang lompat sambil jalan ke dalam
                                        if math.random() > 0.8 then
                                            vim:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                                            task.wait(0.05)
                                            vim:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                                            task.wait(0.05)
                                        else
                                            task.wait(stepInterval)
                                        end
                                    end
                                    
                                    -- Pastikan persis di titik akhir
                                    char:PivotTo(CFrame.new(insideBasePos))
                                    hrp.AssemblyLinearVelocity = Vector3.zero
                                    
                                    Wayae.StopNoclip()
                                    task.wait(1.0)
                                    Wayae.UI.Notify("🏠 Kembali ke Base", "Telur seharusnya sudah diterima!", 3)
                                end
                            end
                        end
                    end
                else
                    -- Tidak ada notifikasi agar tidak spam saat menunggu telur respawn
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

Wayae.antiAfkRunning = false
local antiAfkConnection = nil

Wayae.UI.AntiAfkBtn.MouseButton1Click:Connect(function()
    Wayae.antiAfkRunning = not Wayae.antiAfkRunning
    if Wayae.antiAfkRunning then
        Wayae.UI.AntiAfkBtn.Text = "🛡️ 5. Anti-AFK: ON"
        Wayae.UI.AntiAfkBtn.BackgroundColor3 = Color3.fromRGB(30, 60, 30)
        Wayae.UI.Notify("🛡️ Anti-AFK Aktif", "Anda tidak akan ditendang karena idle 20 menit.", 3)
        
        local VirtualUser = game:GetService("VirtualUser")
        antiAfkConnection = game:GetService("Players").LocalPlayer.Idled:Connect(function()
            -- Metode klasik (paling aman & tersembunyi)
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
            
            -- Fallback jika VirtualUser diblokir oleh eksekutor (Simulasi tekan spasi/lompat)
            pcall(function()
                local vim = game:GetService("VirtualInputManager")
                vim:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                task.wait(0.1)
                vim:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
            end)
        end)
    else
        Wayae.UI.AntiAfkBtn.Text = "🛡️ 5. Anti-AFK: OFF"
        Wayae.UI.AntiAfkBtn.BackgroundColor3 = Color3.fromRGB(45, 25, 30)
        Wayae.UI.Notify("🛡️ Anti-AFK Mati", "Fitur Anti-AFK dinonaktifkan.", 3)
        
        if antiAfkConnection then
            antiAfkConnection:Disconnect()
            antiAfkConnection = nil
        end
    end
end)

