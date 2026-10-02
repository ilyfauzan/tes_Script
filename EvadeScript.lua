local player = game.Players.LocalPlayer
local coreGui = game:GetService("CoreGui")
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Hapus UI lama jika ada
for _, gui in pairs(coreGui:GetChildren()) do
    if gui.Name == "Wayae_EvadeUI" then
        gui:Destroy()
    end
end

-- Setup UI (Tema Merah Hitam khas Wayae)
local WayaeUI = Instance.new("ScreenGui")
WayaeUI.Name = "Wayae_EvadeUI"
WayaeUI.Parent = coreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 450)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = WayaeUI

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
Title.Text = "👽 Wayae Hub | Evade (Clean)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- Fix sudut bawah title biar ga melengkung
local TitleBlocker = Instance.new("Frame")
TitleBlocker.Size = UDim2.new(1, 0, 0, 10)
TitleBlocker.Position = UDim2.new(0, 0, 1, -10)
TitleBlocker.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
TitleBlocker.BorderSizePixel = 0
TitleBlocker.Parent = Title

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, -20, 1, -60)
ScrollingFrame.Position = UDim2.new(0, 10, 0, 50)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.ScrollBarThickness = 4
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 1500) -- Hardcoded to bypass executor UI bugs
ScrollingFrame.Parent = MainFrame

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
ToggleBtn.Text = "👽"
ToggleBtn.TextSize = 28
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.ZIndex = 10
ToggleBtn.Parent = WayaeUI

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleBtn

local isVisible = true
ToggleBtn.MouseButton1Click:Connect(function()
    isVisible = not isVisible
    MainFrame.Visible = isVisible
    ToggleBtn.BackgroundColor3 = isVisible
        and Color3.fromRGB(30, 0, 0)
        or Color3.fromRGB(0, 80, 0)
    ToggleBtn.Text = isVisible and "👽" or "👁️"
end)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ScrollingFrame

local function CreateButton(text, parent)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    return btn
end

local function CreateInput(placeholder, parent)
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, 0, 0, 40)
    input.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.Font = Enum.Font.Gotham
    input.TextSize = 14
    input.PlaceholderText = placeholder
    input.Text = ""
    input.ClearTextOnFocus = false
    input.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = input
    
    return input
end

local function Notify(title, text)
    game.StarterGui:SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = 3;
    })
end

-- ========================================================
-- 👽 GANTI AVATAR (KHUSUS DI MENU LOBBY)
-- ========================================================
local HijackBtn = CreateButton("🚀 [MENU ONLY] Ganti Avatar (Biar Bisa Joget)", ScrollingFrame)
HijackBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)

-- ========================================================
-- 🎸 MAIN ANIMASI BY ID (MANUAL)
-- ========================================================
local LabelPlayID = Instance.new("TextLabel")
LabelPlayID.Size = UDim2.new(1, 0, 0, 20)
LabelPlayID.BackgroundTransparency = 1
LabelPlayID.Text = "🎸 Play Animasi Langsung"
LabelPlayID.TextColor3 = Color3.fromRGB(200, 200, 200)
LabelPlayID.Font = Enum.Font.GothamBold
LabelPlayID.TextSize = 14
LabelPlayID.TextXAlignment = Enum.TextXAlignment.Left
LabelPlayID.Parent = ScrollingFrame

local IDInput = Instance.new("TextBox")
IDInput.Size = UDim2.new(1, 0, 0, 40)
IDInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
IDInput.TextColor3 = Color3.fromRGB(255, 255, 255)
IDInput.Font = Enum.Font.Gotham
IDInput.TextSize = 14
IDInput.PlaceholderText = "Ketik/Paste ID Animasi di sini..."
IDInput.Text = "12686575749"
IDInput.ClearTextOnFocus = false
IDInput.Parent = ScrollingFrame
local cornerID = Instance.new("UICorner")
cornerID.CornerRadius = UDim.new(0, 6)
cornerID.Parent = IDInput

local PlayByIDBtn = CreateButton("▶️ Play Animasi (by ID)", ScrollingFrame)
PlayByIDBtn.BackgroundColor3 = Color3.fromRGB(100, 40, 120)

local LoopBtn = CreateButton("🔁 Loop Mode: OFF", ScrollingFrame)
LoopBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local StopBtn = CreateButton("⛔ Stop Animasi", ScrollingFrame)
StopBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 30)

local RunService = game:GetService("RunService")
local activeTracks = {}
local renderConn = nil
local clonedChar = nil

local function StopAllAnimations()
    if renderConn then
        renderConn:Disconnect()
        renderConn = nil
    end
    for _, track in pairs(activeTracks) do
        pcall(function() track:Stop(0) end)
    end
    activeTracks = {}
end

local function GetAnyR15Dummy()
    -- 1. Coba cari karakter kita sendiri
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("UpperTorso") then
        return player.Character
    end
    if workspace:FindFirstChild("Players") then
        local char = workspace.Players:FindFirstChild(player.Name)
        if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("UpperTorso") then
            return char
        end
    end
    
    -- 2. Kalau kita mati/belum spawn, CURI karakter pemain lain atau NPC yang punya sendi R15!
    for _, plr in pairs(game.Players:GetPlayers()) do
        local char = plr.Character
        if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("UpperTorso") then
            return char
        end
        if workspace:FindFirstChild("Players") then
            local pChar = workspace.Players:FindFirstChild(plr.Name)
            if pChar and pChar:FindFirstChild("HumanoidRootPart") and pChar:FindFirstChild("UpperTorso") then
                return pChar
            end
        end
    end
    
    -- 3. Pencarian sapu jagat (Cari dummy R15 apapun di seluruh map)
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") and obj:FindFirstChild("UpperTorso") then
            if obj.Name ~= "VisualModel" and not string.find(obj.Name, "WayaeClone_") then
                return obj
            end
        end
    end
    
    return nil
end

local function GetVisualRig()
    if workspace:FindFirstChild("Rigs") then
        local char = workspace.Rigs:FindFirstChild(player.Name)
        if char and char:IsA("Model") then
            return char
        end
    end
    return nil
end

local function StartMenuHijack()
    local visualModel = nil
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name == "VisualModel" then
            visualModel = obj
            break
        end
    end
    
    if not visualModel then
        Notify("❌ Gagal", "Buka menu EQUIPMENT dulu (biar patung menunya muncul)!")
        return false
    end
    
    pcall(function() game:GetService("RunService"):UnbindFromRenderStep("WayaeHideVisual") end)
    
    local visualRig = GetVisualRig()
    if not visualRig then
        Notify("❌ Gagal", "Baju aslimu belum di-load oleh game. Pindah-pindah tab dulu!")
        return false
    end
    
    for _, obj in pairs(workspace.CurrentCamera:GetChildren()) do
        if obj:IsA("Model") and string.find(obj.Name, "WayaeClone_") then
            obj:Destroy()
        end
    end
    
    visualRig.Archivable = true
    clonedChar = visualRig:Clone()
    clonedChar.Name = "WayaeClone_" .. player.Name
    
    for _, desc in pairs(clonedChar:GetDescendants()) do
        if desc:IsA("Script") or desc:IsA("LocalScript") then
            desc.Disabled = true
            desc:Destroy()
        end
    end
    
    local hum = clonedChar:FindFirstChildOfClass("Humanoid")
    if not hum then
        hum = Instance.new("Humanoid")
        hum.Parent = clonedChar
    end
    
    -- Evade menghapus HumanoidRootPart dari Rigs, kita buat ulang!
    local hrp = clonedChar:FindFirstChild("HumanoidRootPart")
    if not hrp then
        hrp = Instance.new("Part")
        hrp.Name = "HumanoidRootPart"
        hrp.Size = Vector3.new(2, 2, 1)
        hrp.Transparency = 1
        hrp.CanCollide = false
        hrp.Parent = clonedChar
        clonedChar.PrimaryPart = hrp
        
        local torso = clonedChar:FindFirstChild("LowerTorso") or clonedChar:FindFirstChild("Torso")
        if torso then
            hrp.CFrame = torso.CFrame
        end
    end
    
    -- AJAIB: Minta engine Roblox buatkan semua tulang sendi (Motor6D) secara otomatis!
    -- Engine akan menghubungkan part-part R15 berdasarkan Attachment yang ada di dalamnya
    pcall(function() hum:BuildRigFromAttachments() end)
    
    -- BuildRigFromAttachments nggak bikin Root joint, jadi kita bikin manual
    local torso = clonedChar:FindFirstChild("LowerTorso") or clonedChar:FindFirstChild("Torso")
    if torso then
        local rootJoint = hrp:FindFirstChild("Root") or torso:FindFirstChild("Root")
        if not rootJoint then
            rootJoint = Instance.new("Motor6D")
            rootJoint.Name = "Root"
            rootJoint.Part0 = hrp
            rootJoint.Part1 = torso
            rootJoint.Parent = hrp
        end
    end
    
    for _, desc in pairs(clonedChar:GetDescendants()) do
        if desc:IsA("BasePart") then
            desc.CanCollide = false
            if desc.Name == "HumanoidRootPart" then
                desc.Anchored = true
                desc.Transparency = 1
            else
                desc.Anchored = false
            end
        end
    end
    
    clonedChar.Parent = workspace.CurrentCamera
    
    local pivot = visualModel:GetPivot()
    if pivot.Y < -1000 then pivot = CFrame.new(0, 10, 0) end
    clonedChar:PivotTo(pivot)
    
    RunService:BindToRenderStep("WayaeHideVisual", 300, function()
        if not clonedChar or not clonedChar.Parent then return end
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj.Name == "VisualModel" then
                local vPivot = obj:GetPivot()
                if vPivot.Y > -1000 then clonedChar:PivotTo(vPivot) end
                for _, desc in pairs(obj:GetDescendants()) do
                    if desc:IsA("BasePart") or desc:IsA("Decal") then
                        pcall(function() 
                            desc.Transparency = 1 
                            desc.LocalTransparencyModifier = 1
                        end)
                    end
                end
            end
        end
    end)
    
    Notify("🚀 Sukses", "Avatar diganti! Sekarang kamu bisa play animasi apa saja!")
    return true
end

local function GetRealCharacters()
    local chars = {}
    if clonedChar and clonedChar.Parent then
        table.insert(chars, clonedChar)
        return chars -- Kalau ada clonedChar (di menu), cukup ini saja
    end
    
    -- Prioritaskan custom in-game characters Evade
    if workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Players") then
        local c = workspace.Game.Players:FindFirstChild(player.Name)
        if c then table.insert(chars, c) end
    end
    
    if workspace:FindFirstChild("Players") then
        local c = workspace.Players:FindFirstChild(player.Name)
        if c then table.insert(chars, c) end
    end
    
    local wChar = workspace:FindFirstChild(player.Name)
    if wChar and wChar:IsA("Model") and wChar:FindFirstChildOfClass("Humanoid") then
        table.insert(chars, wChar)
    end
    
    -- Terakhir cek player.Character (kadang ini cuma dummy invisible di Evade)
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        table.insert(chars, player.Character)
    end
    
    return chars
end

local function PlayAnimNow(idStr)
    local numId = idStr:match("%d+")
    if not numId then return false end
    local formattedId = "rbxassetid://" .. numId

    StopAllAnimations()

    local chars = GetRealCharacters()
    if #chars == 0 then
        Notify("❌ Gagal", "Karakter tidak ditemukan sama sekali di dalam map.")
        return false
    end
    
    local ok, err = pcall(function()
        local animators = {}
        for _, char in pairs(chars) do
            for _, desc in pairs(char:GetDescendants()) do
                if desc:IsA("Animator") then
                    table.insert(animators, desc)
                end
            end
            
            -- Kalau nggak ada animator sama sekali di karakter ini, buatin
            local found = false
            for _, desc in pairs(char:GetDescendants()) do
                if desc:IsA("Animator") then found = true break end
            end
            if not found then
                local hum = char:FindFirstChildOfClass("Humanoid") or char:FindFirstChildOfClass("AnimationController")
                if not hum then hum = Instance.new("Humanoid", char) end
                local animator = Instance.new("Animator", hum)
                table.insert(animators, animator)
            end
        end

        if #animators == 0 then return end

        local anim = Instance.new("Animation")
        anim.AnimationId = formattedId

        for _, animator in ipairs(animators) do
            local track = animator:LoadAnimation(anim)
            track.Priority = Enum.AnimationPriority.Action4
            track.Looped = true
            track:Play(0, 99, 1)
            pcall(function() track:AdjustWeight(99) end)
            table.insert(activeTracks, track)
        end

        -- RenderStepped override
        renderConn = RunService.RenderStepped:Connect(function()
            if #activeTracks == 0 then return end
            for _, track in pairs(activeTracks) do
                pcall(function()
                    if not track.IsPlaying then track:Play(0, 99, 1) end
                    track:AdjustWeight(99)
                end)
            end
        end)
    end)
    
    if not ok then
        Notify("❌ Play Error", tostring(err))
    end
    return ok
end

HijackBtn.MouseButton1Click:Connect(function()
    StartMenuHijack()
end)

PlayByIDBtn.MouseButton1Click:Connect(function()
    local id = IDInput.Text:match("%d+")
    if id then
        PlayAnimNow(id)
    else
        Notify("❌ Input Salah", "Masukkan angka ID yang benar!")
    end
end)

LoopBtn.MouseButton1Click:Connect(function()
    Notify("ℹ️ Info", "Loop otomatis aktif! Animasi dipaksa jalan setiap frame.")
end)

StopBtn.MouseButton1Click:Connect(function()
    StopAllAnimations()
    Notify("⏹️ Dihentikan", "Animasi dihentikan.")
end)

-- 🔬 DEBUG LENGKAP: Bandingkan VisualModel vs player.Character
local DebugBtn = CreateButton("🔬 Debug: Cek Status Hijack", ScrollingFrame)
DebugBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 80)
DebugBtn.MouseButton1Click:Connect(function()
    local realChar = GetRealCharacter()
    if realChar then
        Notify("✅ Karakter Asli", "Ditemukan: " .. realChar.Name .. " (Ada Motor6D)")
    else
        Notify("❌ Karakter Asli", "Tidak Ditemukan!")
    end
    
    local vmFound = false
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name == "VisualModel" then
            vmFound = true
            Notify("✅ VisualModel", "Patung menu ditemukan!")
            break
        end
    end
    if not vmFound then Notify("❌ VisualModel", "Buka menu Equipment dulu!") end
end)

-- 🎮 TOMBOL FIRE REMOTE: Coba pakai sistem internal Evade
local RemoteBtn = CreateButton("🎮 Tampilkan Ulang Patung Asli", ScrollingFrame)
RemoteBtn.BackgroundColor3 = Color3.fromRGB(0, 60, 100)
RemoteBtn.MouseButton1Click:Connect(function()
    StopAllAnimations()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name == "VisualModel" then
            for _, desc in pairs(obj:GetDescendants()) do
                if desc:IsA("BasePart") and desc.Name ~= "HumanoidRootPart" then
                    pcall(function() desc.Transparency = 0 end)
                end
                if desc:IsA("Decal") then
                    pcall(function() desc.Transparency = 0 end)
                end
            end
        end
    end
    Notify("🔄 Reset", "Patung menu dikembalikan seperti semula.")
end)

-- ========================================================
-- 🎸 INTERNAL EVADE EMOTES (ROCKIN STRIDE DLL)
-- ========================================================
local function GetInternalEmote(keyword)
    keyword = string.lower(keyword)
    local services = {game:GetService("ReplicatedStorage"), workspace, player}
    for _, service in pairs(services) do
        local objects = {}
        pcall(function() objects = service:GetDescendants() end)
        for _, obj in pairs(objects) do
            if obj:IsA("Animation") then
                local nameMatch = string.find(string.lower(obj.Name), keyword)
                local parentMatch = obj.Parent and string.find(string.lower(obj.Parent.Name), keyword)
                if nameMatch or parentMatch then
                    return obj
                end
            end
        end
    end
    return nil
end

local InternalEmoteLabel = Instance.new("TextLabel")
InternalEmoteLabel.Size = UDim2.new(1, 0, 0, 20)
InternalEmoteLabel.BackgroundTransparency = 1
InternalEmoteLabel.Text = "🎸 IN-GAME EMOTES (ROCKIN STRIDE DLL)"
InternalEmoteLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
InternalEmoteLabel.Font = Enum.Font.GothamBold
InternalEmoteLabel.TextXAlignment = Enum.TextXAlignment.Left
InternalEmoteLabel.Parent = ScrollingFrame
local EvadeEmoteInput = CreateInput("Nama Emote (cth: BoldMarch, Conga)", ScrollingFrame)
local PlayEvadeBtn = CreateButton("🎭 Play Emote Evade", ScrollingFrame)
PlayEvadeBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)

PlayEvadeBtn.MouseButton1Click:Connect(function()
    local emoteName = EvadeEmoteInput.Text
    if emoteName == "" or emoteName == "Nama Emote (cth: BoldMarch, Conga)" then 
        emoteName = "BoldMarch" 
    end 
    
    local rs = game:GetService("ReplicatedStorage")
    local targetModule = nil
    
    local allObjects = {}
    pcall(function() 
        for _, obj in ipairs(rs:GetDescendants()) do table.insert(allObjects, obj) end
        for _, obj in ipairs(workspace:GetDescendants()) do table.insert(allObjects, obj) end
    end)
    
    local id = nil
    
    for _, child in pairs(allObjects) do
        if string.lower(child.Name) == string.lower(emoteName) then
            if child:IsA("ModuleScript") then
                targetModule = child
            elseif child:IsA("Folder") then
                -- LANGSUNG CEK kalau dia Folder, apakah dia punya Animations/R15/Animation
                local anims = child:FindFirstChild("Animations")
                if anims then
                    local r15 = anims:FindFirstChild("R15")
                    if r15 then
                        local anim = r15:FindFirstChild("Animation")
                        if anim and anim:IsA("Animation") then
                            id = anim.AnimationId:match("%d+")
                            if id then break end -- Langsung stop kalau ketemu ID asli!
                        end
                    end
                end
            end
        end
    end
    
    -- PRIORITAS 2: Kalau bukan folder animasi, bongkar ModuleScript-nya
    if not id and targetModule then
        local animObj = targetModule:FindFirstChildOfClass("Animation")
        if animObj then id = animObj.AnimationId:match("%d+") end
        
        if not id then
            local success, data = pcall(function() return require(targetModule) end)
            if success and type(data) == "table" then
                -- Fungsi rekursif pencari ID
                local function findID(tbl)
                    for k, v in pairs(tbl) do
                        local key = tostring(k):lower()
                        if key == "animation" or key == "animationid" or key == "anim" or key == "id" or key == "asset" then
                            if type(v) == "number" then return tostring(v) end
                            if type(v) == "string" and v:match("%d+") then return v:match("%d+") end
                            if typeof(v) == "Instance" and v:IsA("Animation") then return v.AnimationId:match("%d+") end
                        end
                    end
                    for k, v in pairs(tbl) do
                        if type(v) == "string" and v:match("rbxassetid://(%d+)") then
                            return v:match("%d+")
                        end
                        -- HAPUS BRUTE FORCE: Jangan sembarangan ngambil angka panjang
                        -- karena nyatanya developer pakai angka 1000000000 sbg jebakan!
                    end
                    for k, v in pairs(tbl) do
                        if type(v) == "table" then
                            local res = findID(v)
                            if res then return res end
                        end
                    end
                    return nil
                end
                id = findID(data)
                
                -- DEBUG DUMP KALAU GAGAL
                if not id then
                    local keys = {}
                    for k, v in pairs(data) do
                        table.insert(keys, tostring(k) .. ":" .. type(v))
                    end
                    EvadeEmoteInput.Text = "Isi: " .. table.concat(keys, ", ")
                end
            end
        end
    end
    
    if id then
        if IDInput then IDInput.Text = id end
        PlayAnimNow(id)
        Notify("✅ BERHASIL BONGKAR!", "Memutar " .. emoteName .. " (ID: " .. id .. ")")
    elseif targetModule or targetFolder then
        Notify("❌ Gagal", "Module/Folder ada, tapi ID terlalu rahasia. Cek teks debug!")
    else
        Notify("❌ Gagal", "Emote '" .. emoteName .. "' tidak ada di folder Evade.")
    end
end)

-- ========================================================
-- 🔍 SMART SCANNER (CARI DUMMY SHOP)
-- ========================================================
local LabelAutoCatch = Instance.new("TextLabel")
LabelAutoCatch.Size = UDim2.new(1, 0, 0, 20)
LabelAutoCatch.BackgroundTransparency = 1
LabelAutoCatch.Text = "🔍 Smart Scanner (Pilih Manual!)"
LabelAutoCatch.TextColor3 = Color3.fromRGB(100, 220, 255)
LabelAutoCatch.Font = Enum.Font.GothamBold
LabelAutoCatch.TextSize = 14
LabelAutoCatch.TextXAlignment = Enum.TextXAlignment.Left
LabelAutoCatch.Parent = ScrollingFrame

local LabelAutoCatchInfo = Instance.new("TextLabel")
LabelAutoCatchInfo.Size = UDim2.new(1, 0, 0, 40)
LabelAutoCatchInfo.BackgroundTransparency = 1
LabelAutoCatchInfo.Text = "Klik emote di shop agar bergerak, lalu tekan Scan. Cari ID yang namanya [Dummy]!"
LabelAutoCatchInfo.TextColor3 = Color3.fromRGB(160, 160, 160)
LabelAutoCatchInfo.Font = Enum.Font.Gotham
LabelAutoCatchInfo.TextSize = 11
LabelAutoCatchInfo.TextXAlignment = Enum.TextXAlignment.Left
LabelAutoCatchInfo.TextWrapped = true
LabelAutoCatchInfo.Parent = ScrollingFrame

local ScanBtn = CreateButton("🔍 Scan Emote Sekarang", ScrollingFrame)
ScanBtn.BackgroundColor3 = Color3.fromRGB(0, 130, 180)

local SniperBtn = CreateButton("🎯 Sniper Mode: Siap Menembak", ScrollingFrame)
SniperBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)

local CatchContainer = Instance.new("Frame")
CatchContainer.Size = UDim2.new(1, 0, 0, 0)
CatchContainer.BackgroundTransparency = 1
CatchContainer.Parent = ScrollingFrame

local CatchLayout = Instance.new("UIListLayout")
CatchLayout.Padding = UDim.new(0, 5)
CatchLayout.SortOrder = Enum.SortOrder.LayoutOrder
CatchLayout.Parent = CatchContainer

local baseAnimIds = {
    ["507770239"] = true, ["507777826"] = true, ["507766388"] = true,
    ["507766951"] = true, ["507766666"] = true, ["507765000"] = true,
    ["507765644"] = true, ["507767714"] = true, ["507768375"] = true,
    ["507767202"] = true,
}

local sniperActive = false
SniperBtn.MouseButton1Click:Connect(function()
    sniperActive = not sniperActive
    if sniperActive then
        SniperBtn.Text = "🎯 Sniper: ON (KLIK EMOTE DI SHOP SEKARANG!)"
        SniperBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        Notify("🎯 Sniper Aktif", "Cepat klik emote di shop! Script akan menangkap 1 animasi yang paling baru diload.")
    else
        SniperBtn.Text = "🎯 Sniper Mode: Siap Menembak"
        SniperBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    end
end)

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    if sniperActive then
        local method = getnamecallmethod()
        if method == "LoadAnimation" or method == "Play" then
            local anim = nil
            if method == "LoadAnimation" then
                anim = select(1, ...)
            elseif typeof(self) == "Instance" and self:IsA("AnimationTrack") then
                anim = self.Animation
            end
            
            if anim and typeof(anim) == "Instance" and anim:IsA("Animation") then
                local id = anim.AnimationId:match("%d+")
                if id and not baseAnimIds[id] then
                    sniperActive = false
                    task.spawn(function()
                        SniperBtn.Text = "🎯 Sniper Mode: Siap Menembak"
                        SniperBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
                        if IDInput then IDInput.Text = id end
                        Notify("🎯 HEADSHOT!", "ID " .. id .. " tertangkap!")
                        PlayAnimNow(id)
                    end)
                end
            end
        end
    end
    return oldNamecall(self, ...)
end)

ScanBtn.MouseButton1Click:Connect(function()
    ScanBtn.Text = "⏳ Scanning..."
    task.wait(0.1)

    for _, child in pairs(CatchContainer:GetChildren()) do
        if not child:IsA("UIListLayout") then child:Destroy() end
    end

    local uniqueAnims = {}
    local roots = { game:GetService("Workspace"), player:FindFirstChild("PlayerGui") }
    local camPos = workspace.CurrentCamera and workspace.CurrentCamera.CFrame.Position or Vector3.new(0,0,0)
    
    for _, root in pairs(roots) do
        if root then
            for _, obj in pairs(root:GetDescendants()) do
                if obj:IsA("Animator") then
                    local model = obj.Parent and obj.Parent.Parent
                    local modelName = "Unknown"
                    local isPlayer = false
                    local dist = 9999

                    if model and model:IsA("Model") then
                        modelName = model.Name
                        if game:GetService("Players"):GetPlayerFromCharacter(model) then
                            isPlayer = true
                        end
                        pcall(function() dist = (model:GetPivot().Position - camPos).Magnitude end)
                    elseif obj.Parent then
                        modelName = obj.Parent.Name
                    end
                    
                    if not isPlayer and dist < 50 then
                        pcall(function()
                            for _, track in pairs(obj:GetPlayingAnimationTracks()) do
                                if track.Animation and track.Animation.AnimationId then
                                    local id = track.Animation.AnimationId:match("%d+")
                                    if id and not baseAnimIds[id] then
                                        local key = modelName .. "_" .. id
                                        if not uniqueAnims[key] then
                                            uniqueAnims[key] = {Model = modelName, Id = id, Dist = math.floor(dist)}
                                        end
                                    end
                                end
                            end
                        end)
                    end
                end
            end
        end
    end

    local sortedAnims = {}
    for _, data in pairs(uniqueAnims) do
        table.insert(sortedAnims, data)
    end
    table.sort(sortedAnims, function(a, b) return a.Dist < b.Dist end)

    local count = 0
    for _, data in ipairs(sortedAnims) do
        count = count + 1
        local btnText = "[" .. data.Model .. "] Jarak: " .. data.Dist .. " | ID: " .. data.Id
        
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 38)
        
        if count == 1 then
            btn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
            btnText = "🎯 TERDEKAT: " .. btnText
        else
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        end
        
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 12
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.TextTruncate = Enum.TextTruncate.AtEnd
        btn.Text = "  " .. btnText
        btn.Parent = CatchContainer

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = btn

        local copyBtn = Instance.new("TextButton")
        copyBtn.Size = UDim2.new(0, 60, 1, 0)
        copyBtn.Position = UDim2.new(1, -62, 0, 0)
        copyBtn.BackgroundColor3 = Color3.fromRGB(20, 80, 100)
        copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        copyBtn.Font = Enum.Font.GothamBold
        copyBtn.TextSize = 11
        copyBtn.Text = "📋 Copy"
        copyBtn.ZIndex = 2
        copyBtn.Parent = btn

        local copyCorner = Instance.new("UICorner")
        copyCorner.CornerRadius = UDim.new(0, 5)
        copyCorner.Parent = copyBtn

        btn.MouseButton1Click:Connect(function()
            if IDInput then IDInput.Text = data.Id end
            pcall(function() setclipboard(tostring(data.Id)) end)
            local ok = PlayAnimNow(data.Id)
            if ok then
                Notify("✅ Dimainkan!", "Animasi dari " .. data.Model .. " diputar!")
            end
        end)

        copyBtn.MouseButton1Click:Connect(function()
            if IDInput then IDInput.Text = data.Id end
            pcall(function() setclipboard(tostring(data.Id)) end)
            copyBtn.Text = "✅ Copied!"
            task.delay(1.5, function()
                if copyBtn and copyBtn.Parent then copyBtn.Text = "📋 Copy" end
            end)
        end)
    end

    CatchContainer.Size = UDim2.new(1, 0, 0, CatchLayout.AbsoluteContentSize.Y)
    ScanBtn.Text = "🔍 Scan Emote Sekarang"
    
    if count > 0 then
        Notify("✅ Selesai!", "Cari dan klik tombol berwarna ORANYE (Dummy)")
    else
        Notify("❌ Kosong", "Pastikan emote sedang bergerak di shop lalu klik Scan!")
    end
end)

CatchLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    CatchContainer.Size = UDim2.new(1, 0, 0, CatchLayout.AbsoluteContentSize.Y)
end)

-- ========================================================
-- 💯 VERIFIED EMOTES (PASTI GERAK - ASLI ROBLOX)
-- ========================================================
local LabelVerified = Instance.new("TextLabel")
LabelVerified.Size = UDim2.new(1, 0, 0, 20)
LabelVerified.BackgroundTransparency = 1
LabelVerified.Text = "💯 VERIFIED EMOTES (ASLI ROBLOX)"
LabelVerified.TextColor3 = Color3.fromRGB(0, 255, 100)
LabelVerified.Font = Enum.Font.GothamBold
LabelVerified.TextSize = 14
LabelVerified.TextXAlignment = Enum.TextXAlignment.Left
LabelVerified.Parent = ScrollingFrame

local verifiedEmotes = {
    {Name = "🕺 R6 Dance 1", Id = "183264076", Color = Color3.fromRGB(20, 80, 20)},
    {Name = "🕺 R6 Dance 2", Id = "183268422", Color = Color3.fromRGB(20, 80, 20)},
    {Name = "🕺 R6 Dance 3", Id = "183269374", Color = Color3.fromRGB(20, 80, 20)},
    {Name = "👋 R6 Wave",    Id = "128777973", Color = Color3.fromRGB(20, 60, 80)},
    {Name = "🤖 R15 Dance 1", Id = "507771019", Color = Color3.fromRGB(80, 40, 0)},
    {Name = "🤖 R15 Dance 2", Id = "507776043", Color = Color3.fromRGB(80, 40, 0)},
    {Name = "🤖 R15 Dance 3", Id = "507777268", Color = Color3.fromRGB(80, 40, 0)},
    {Name = "👋 R15 Wave",    Id = "507770239", Color = Color3.fromRGB(80, 30, 80)},
}

for _, emoteData in ipairs(verifiedEmotes) do
    local btn = CreateButton(emoteData.Name, ScrollingFrame)
    btn.BackgroundColor3 = emoteData.Color
    btn.MouseButton1Click:Connect(function()
        if IDInput then IDInput.Text = emoteData.Id end
        pcall(function() setclipboard(tostring(emoteData.Id)) end)
        local ok = PlayAnimNow(emoteData.Id)
        if ok then
            Notify("✅ Berhasil!", emoteData.Name .. " diputar!")
        else
            Notify("❌ Gagal", "Mungkin salah pilih R6/R15.")
        end
    end)
end

-- ========================================================
-- 🛠️ UTILITAS LAINNYA
-- ========================================================
local LabelUtilitas = Instance.new("TextLabel")
LabelUtilitas.Size = UDim2.new(1, 0, 0, 20)
LabelUtilitas.BackgroundTransparency = 1
LabelUtilitas.Text = "🛠️ Utilitas Lainnya"
LabelUtilitas.TextColor3 = Color3.fromRGB(200, 200, 200)
LabelUtilitas.Font = Enum.Font.GothamBold
LabelUtilitas.TextSize = 14
LabelUtilitas.TextXAlignment = Enum.TextXAlignment.Left
LabelUtilitas.Parent = ScrollingFrame

local ESPBtn = CreateButton("👁️ Toggle ESP (Cheat Kacamata)", ScrollingFrame)
local espOn = false
ESPBtn.MouseButton1Click:Connect(function()
    espOn = not espOn
    if espOn then
        ESPBtn.Text = "👁️ Toggle ESP: ON"
        ESPBtn.BackgroundColor3 = Color3.fromRGB(30, 80, 30)
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local hl = Instance.new("Highlight")
                hl.Name = "WayaeESP"
                hl.FillColor = Color3.fromRGB(0, 255, 0)
                hl.Parent = plr.Character
            end
        end
        Notify("👁️ ESP Nyala", "Pemain terlihat tembus pandang!")
    else
        ESPBtn.Text = "👁️ Toggle ESP: OFF"
        ESPBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr.Character then
                local hl = plr.Character:FindFirstChild("WayaeESP")
                if hl then hl:Destroy() end
            end
        end
    end
end)

-- ========================================================
-- CLOSE BUTTON & FINAL SETUP
-- ========================================================
local CloseBtn = CreateButton("❌ Sembunyikan UI", ScrollingFrame)
CloseBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    isVisible = false
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 80, 0)
    ToggleBtn.Text = "👁️"
end)

ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
end)

Notify("Alien Wayae", "Berhasil inject Evade Script Clean Version!")
