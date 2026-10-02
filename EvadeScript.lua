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

local function Notify(title, text)
    game.StarterGui:SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = 3;
    })
end

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
local activeAnimId = nil
local renderConn = nil

local function GetActiveCharacter()
    local bestChar = nil
    local bestDist = 99999
    local camPos = workspace.CurrentCamera and workspace.CurrentCamera.CFrame.Position or Vector3.new(0,0,0)

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and (obj.Name == "VisualModel" or obj.Name == player.Name) and (obj:FindFirstChildOfClass("Humanoid") or obj:FindFirstChildOfClass("AnimationController")) then
            local dist = 99999
            pcall(function() dist = (obj:GetPivot().Position - camPos).Magnitude end)
            if dist < bestDist then
                bestDist = dist
                bestChar = obj
            end
        end
    end
    
    if bestChar and bestDist < 100 then
        return bestChar
    end

    local cam = workspace.CurrentCamera
    if cam and cam.CameraSubject then
        local subject = cam.CameraSubject
        if subject:IsA("Humanoid") or subject:IsA("BasePart") then
            return subject.Parent
        end
    end
    
    return player.Character
end

local function StopAllAnimations()
    if renderConn then
        renderConn:Disconnect()
        renderConn = nil
    end
    for _, track in pairs(activeTracks) do
        pcall(function() track:Stop(0) end)
    end
    activeTracks = {}
    activeAnimId = nil
end

local function KillScriptsInModel(model)
    local killed = 0
    for _, desc in pairs(model:GetDescendants()) do
        if desc:IsA("LocalScript") or desc:IsA("Script") then
            pcall(function() desc.Disabled = true end)
            pcall(function() desc:Destroy() end)
            killed = killed + 1
        end
    end
    return killed
end

local function PlayAnimNow(idStr)
    local char = GetActiveCharacter()
    if not char then return false end

    local numId = idStr:match("%d+")
    if not numId then return false end
    local formattedId = "rbxassetid://" .. numId

    StopAllAnimations()
    activeAnimId = formattedId

    -- LANGKAH 1: Matikan SEMUA script di dalam model (bunuh controller animasi Evade)
    local killed = KillScriptsInModel(char)

    local ok, err = pcall(function()
        -- LANGKAH 2: Cari semua Animator
        local animators = {}
        for _, desc in pairs(char:GetDescendants()) do
            if desc:IsA("Animator") then
                table.insert(animators, desc)
            end
        end

        -- LANGKAH 3: Kalau tidak ada Animator, cari Humanoid/AnimationController dan buat Animator baru
        if #animators == 0 then
            local hum = char:FindFirstChildOfClass("Humanoid") or char:FindFirstChildOfClass("AnimationController")
            if not hum then
                hum = Instance.new("Humanoid", char)
            end
            local animator = Instance.new("Animator", hum)
            table.insert(animators, animator)
        end

        -- LANGKAH 4: Hentikan SEMUA animasi yang sedang jalan
        for _, animator in ipairs(animators) do
            pcall(function()
                for _, existingTrack in pairs(animator:GetPlayingAnimationTracks()) do
                    existingTrack:Stop(0)
                    existingTrack:AdjustWeight(0)
                end
            end)
        end

        -- LANGKAH 5: Muat dan mainkan animasi kita
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

        -- LANGKAH 6: RenderStepped override setiap frame
        renderConn = RunService.RenderStepped:Connect(function()
            if #activeTracks == 0 then return end
            for _, track in pairs(activeTracks) do
                pcall(function()
                    if not track.IsPlaying then
                        track:Play(0, 99, 1)
                    end
                    track:AdjustWeight(99)
                end)
            end
        end)
    end)
    
    if not ok then
        Notify("❌ Play Error", tostring(err))
    else
        Notify("☢️ NUKLIR v2 di " .. char.Name, "Script Evade dimatikan: " .. killed .. " | Animasi dipaksa!")
    end
    return ok, char.Name
end

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
    Notify("⏹️ Dihentikan", "Animasi dan sistem NUKLIR dihentikan.")
end)

-- 🔬 DEBUG: Tombol untuk melihat isi VisualModel
local DebugBtn = CreateButton("🔬 Debug: Lihat Isi VisualModel", ScrollingFrame)
DebugBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 80)
DebugBtn.MouseButton1Click:Connect(function()
    local char = GetActiveCharacter()
    if not char then
        Notify("❌ Tidak ditemukan", "VisualModel tidak ada!")
        return
    end
    
    local info = "Model: " .. char.Name .. " | Parent: " .. tostring(char.Parent and char.Parent.Name) .. "\n"
    local humanoids = 0
    local animControllers = 0
    local animators = 0
    local motor6ds = 0
    local scripts = 0
    local parts = 0
    
    for _, desc in pairs(char:GetDescendants()) do
        if desc:IsA("Humanoid") then humanoids = humanoids + 1 end
        if desc:IsA("AnimationController") then animControllers = animControllers + 1 end
        if desc:IsA("Animator") then animators = animators + 1 end
        if desc:IsA("Motor6D") then motor6ds = motor6ds + 1 end
        if desc:IsA("LocalScript") or desc:IsA("Script") then scripts = scripts + 1 end
        if desc:IsA("BasePart") then parts = parts + 1 end
    end
    
    info = info .. "Humanoid: " .. humanoids .. " | AnimController: " .. animControllers
    info = info .. " | Animator: " .. animators .. " | Motor6D: " .. motor6ds
    info = info .. " | Scripts: " .. scripts .. " | Parts: " .. parts
    
    -- Cek apakah rig R6 atau R15
    local hasR15 = char:FindFirstChild("UpperTorso") or char:FindFirstChild("RightUpperArm")
    local hasR6 = char:FindFirstChild("Torso") or char:FindFirstChild("Right Arm")
    local rigType = "Unknown"
    if hasR15 then rigType = "R15" elseif hasR6 then rigType = "R6" end
    info = info .. " | Rig: " .. rigType
    
    Notify("🔬 Debug " .. char.Name, info)
end)

-- 🎮 TOMBOL FIRE REMOTE: Coba pakai sistem internal Evade
local RemoteBtn = CreateButton("🎮 Fire Emote via Remote Evade", ScrollingFrame)
RemoteBtn.BackgroundColor3 = Color3.fromRGB(0, 60, 100)
RemoteBtn.MouseButton1Click:Connect(function()
    local id = IDInput.Text:match("%d+")
    if not id then
        Notify("❌ Input Salah", "Masukkan ID dulu!")
        return
    end
    
    local fired = 0
    -- Cari semua RemoteEvent yang mungkin berhubungan dengan emote
    for _, obj in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            local name = obj.Name:lower()
            if name:find("emote") or name:find("anim") or name:find("dance") or name:find("play") or name:find("cosmetic") then
                pcall(function()
                    obj:FireServer(id)
                    obj:FireServer(tonumber(id))
                    obj:FireServer("rbxassetid://" .. id)
                end)
                fired = fired + 1
                Notify("🎮 Remote Fired", obj.Name .. " (" .. fired .. ")")
            end
        end
    end
    
    if fired == 0 then
        Notify("⚠️ Tidak Ada Remote", "Tidak ditemukan RemoteEvent terkait emote di ReplicatedStorage.")
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
