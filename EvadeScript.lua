local player = game.Players.LocalPlayer
local coreGui = game:GetService("CoreGui")
local replicatedStorage = game:GetService("ReplicatedStorage") -- FIX: Sekarang konsisten dipakai di seluruh kode

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
Title.Text = "👽 Wayae Hub | Evade"
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

-- ===================================================
-- TOMBOL TOGGLE MENGAMBANG - SELALU KELIATAN!
-- FIX: Hanya ada 1 tombol toggle, tidak ada duplikat
-- ===================================================
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
ToggleCorner.CornerRadius = UDim.new(1, 0) -- FIX: Bulat penuh (gabungan dari kedua versi lama)
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

local loopActive = false
local currentTrack = nil
local loopThread = nil
local currentFakeChar = nil

local function PlayAnimNow(idStr)
    local char = player.Character
    if not char then return false end

    local numId = idStr:match("%d+")
    if not numId then return false end
    local formattedId = "rbxassetid://" .. numId

    local ok, err = pcall(function()
        if currentTrack then
            pcall(function() currentTrack:Stop(0) end)
            currentTrack = nil
        end
        if currentFakeChar then
            currentFakeChar:Destroy()
            currentFakeChar = nil
        end

        -- Langsung putar di tubuh asli (tanpa kloning)
        local hum = char:FindFirstChildOfClass("Humanoid") or char:FindFirstChildOfClass("AnimationController")
        if not hum then return false end

        local animator = hum:FindFirstChildOfClass("Animator")
        if not animator then
            animator = Instance.new("Animator", hum)
        end

        local anim = Instance.new("Animation")
        anim.AnimationId = formattedId

        currentTrack = animator:LoadAnimation(anim)
        currentTrack.Priority = Enum.AnimationPriority.Action4 -- Paksa override
        currentTrack.Looped = loopActive
        currentTrack:Play(0.1, 99, 1) -- Weight 99 agar sangat memaksa

        -- FIX: Loop protector hanya aktif jika loopActive = true
        if loopThread then task.cancel(loopThread) end
        if loopActive then
            loopThread = task.spawn(function()
                while loopActive do
                    task.wait(0.1)
                    if currentTrack and not currentTrack.IsPlaying then
                        currentTrack:Play(0.1, 99, 1)
                    end
                end
            end)
        end
    end)
    return ok
end

PlayByIDBtn.MouseButton1Click:Connect(function()
    local id = IDInput.Text:match("%d+")
    if id then
        local ok = PlayAnimNow(id)
        if ok then
            -- FIX: Pesan notifikasi diperbaiki (tidak lagi sebut "Kloning")
            Notify("✅ Animasi Diputar!", "Animasi berhasil dijalankan! Klik Stop untuk berhenti.")
        else
            Notify("❌ Gagal", "Character belum siap atau ID tidak valid!")
        end
    else
        Notify("❌ Input Salah", "Masukkan angka ID yang benar!")
    end
end)

-- FIX: LoopBtn sekarang benar-benar mengontrol loopThread, bukan hanya property .Looped
LoopBtn.MouseButton1Click:Connect(function()
    loopActive = not loopActive
    if loopActive then
        LoopBtn.Text = "🔁 Loop Mode: ON"
        LoopBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
        -- Aktifkan loop protector jika animasi sedang berjalan
        if currentTrack then
            currentTrack.Looped = true
            if loopThread then task.cancel(loopThread) end
            loopThread = task.spawn(function()
                while loopActive do
                    task.wait(0.1)
                    if currentTrack and not currentTrack.IsPlaying then
                        currentTrack:Play(0.1, 99, 1)
                    end
                end
            end)
        end
    else
        LoopBtn.Text = "🔁 Loop Mode: OFF"
        LoopBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        -- FIX: Matikan loopThread dengan benar agar animasi bisa berhenti sendiri
        if loopThread then
            task.cancel(loopThread)
            loopThread = nil
        end
        if currentTrack then
            currentTrack.Looped = false
        end
    end
end)

StopBtn.MouseButton1Click:Connect(function()
    -- FIX: StopBtn juga mematikan loopThread
    if loopThread then
        task.cancel(loopThread)
        loopThread = nil
    end
    if currentTrack then
        pcall(function() currentTrack:Stop() end)
        currentTrack = nil
    end
    if currentFakeChar then
        currentFakeChar:Destroy()
        currentFakeChar = nil
    end

    -- Kembalikan badan asli jadi kelihatan lagi
    local char = player.Character
    if char then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
                v.Transparency = 0
            elseif v:IsA("Decal") then
                v.Transparency = 0
            end
        end
    end

    Notify("⏹️ Dihentikan", "Animasi dihentikan.")
end)

-- ========================================================
-- 🎭 FITUR EVADE - EMOTE INJECTOR
-- ========================================================

local LabelEmoteInject = Instance.new("TextLabel")
LabelEmoteInject.Size = UDim2.new(1, 0, 0, 20)
LabelEmoteInject.BackgroundTransparency = 1
LabelEmoteInject.Text = "🎭 Emote Injector"
LabelEmoteInject.TextColor3 = Color3.fromRGB(200, 200, 200)
LabelEmoteInject.Font = Enum.Font.GothamBold
LabelEmoteInject.TextSize = 14
LabelEmoteInject.TextXAlignment = Enum.TextXAlignment.Left
LabelEmoteInject.Parent = ScrollingFrame

local EmoteNameInput = Instance.new("TextBox")
EmoteNameInput.Size = UDim2.new(1, 0, 0, 40)
EmoteNameInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
EmoteNameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
EmoteNameInput.Font = Enum.Font.Gotham
EmoteNameInput.TextSize = 14
EmoteNameInput.PlaceholderText = "Nama emote yang mau di-inject..."
EmoteNameInput.Text = "Rockin' Stride"
EmoteNameInput.Parent = ScrollingFrame
local cornerEI = Instance.new("UICorner")
cornerEI.CornerRadius = UDim.new(0, 6)
cornerEI.Parent = EmoteNameInput

local InjectBtn = CreateButton("🕵️ Spy & Replay Emote Catjam", ScrollingFrame)
InjectBtn.BackgroundColor3 = Color3.fromRGB(120, 60, 0)

local ScanRemoteBtn = CreateButton("🔍 Scan RemoteEvent Emote", ScrollingFrame)
ScanRemoteBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 100)

local FireRemoteBtn = CreateButton("🚀 Fire Emote Remote Langsung", ScrollingFrame)
FireRemoteBtn.BackgroundColor3 = Color3.fromRGB(100, 40, 120)

local foundEmoteRemote = nil
local equipRemote = nil

ScanRemoteBtn.MouseButton1Click:Connect(function()
    foundEmoteRemote = nil
    equipRemote = nil
    local results = {}

    -- FIX: Gunakan variabel replicatedStorage yang sudah dideklarasi
    for _, obj in pairs(replicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local n = obj.Name:lower()
            if n:find("emote") or n:find("equip") or n:find("item") or n:find("cosmetic") then
                table.insert(results, obj.Name)
                if not foundEmoteRemote then foundEmoteRemote = obj end
                if n == "equip" then equipRemote = obj end
            end
        end
    end

    if #results > 0 then
        Notify("✅ Remote: " .. table.concat(results, " | "):sub(1, 150), equipRemote and "Equip remote siap!" or "Scan lagi kalau perlu")
    else
        Notify("❌ Tidak ada Remote ditemukan.", "")
    end
end)

-- SPY: Cegat click Catjam dan rekam argumentnya, lalu replay dengan nama emote target
InjectBtn.MouseButton1Click:Connect(function()
    local emoteName = EmoteNameInput.Text
    local playerGui = player:FindFirstChild("PlayerGui")
    if not playerGui then Notify("❌", "PlayerGui tidak ada!") return end

    local catjamBtn = nil
    for _, obj in pairs(playerGui:GetDescendants()) do
        if (obj:IsA("TextButton") or obj:IsA("ImageButton") or obj:IsA("Frame")) then
            for _, child in pairs(obj:GetDescendants()) do
                if child:IsA("TextLabel") and child.Text:lower():find("catjam") then
                    catjamBtn = obj
                    break
                end
            end
            if obj:IsA("TextButton") and obj.Text:lower():find("catjam") then
                catjamBtn = obj
            end
        end
        if catjamBtn then break end
    end

    if not catjamBtn then
        Notify("⚠️ Catjam button tidak terlihat!", "Buka dulu menu Emote > klik slot emote, LALU pencet tombol ini!")
        return
    end

    local spySuccess = false
    pcall(function()
        local conns = getconnections(catjamBtn.MouseButton1Click)
        if #conns > 0 then
            Notify("🕵️ Spy sukses!", #conns .. " koneksi ditemukan di Catjam. Mencoba replay...")

            if equipRemote then
                local tries = {
                    emoteName,
                    {Name = emoteName},
                    {EmoteName = emoteName},
                    {Emote = emoteName, Slot = 1},
                    {item = emoteName},
                    {ItemName = emoteName},
                }
                for _, args in ipairs(tries) do
                    pcall(function() equipRemote:FireServer(args) end)
                end
                spySuccess = true
            end
        end
    end)

    if spySuccess then
        Notify("🚀 Replay dikirim!", "Cek emote slot kamu sekarang!")
    else
        Notify("❌ getconnections tidak tersedia", "Coba 'Fire Emote Remote Langsung' sebagai gantinya!")
    end
end)

FireRemoteBtn.MouseButton1Click:Connect(function()
    local emoteName = EmoteNameInput.Text
    local remote = equipRemote or foundEmoteRemote
    if not remote then
        Notify("❌ Scan dulu!", "Pencet Scan RemoteEvent dulu!")
        return
    end

    local fired = 0
    local tries = {
        function() remote:FireServer(emoteName) end,
        function() remote:FireServer(1, emoteName) end,
        function() remote:FireServer({Name = emoteName}) end,
        function() remote:FireServer({EmoteName = emoteName}) end,
        function() remote:FireServer({Emote = emoteName, Slot = 1}) end,
        function() remote:FireServer("Equip", emoteName) end,
        function() remote:FireServer({item = emoteName}) end,
        function() remote:FireServer({ItemName = emoteName}) end,
        function() remote:FireServer(emoteName, 1) end,
        function() remote:FireServer(emoteName, "Emote") end,
    }
    for _, fn in ipairs(tries) do
        if pcall(fn) then fired = fired + 1 end
    end

    Notify("🚀 " .. fired .. " variasi dikirim ke '" .. remote.Name .. "'!", "Cek emote slot kamu!")
end)

local DeepScanBtn = CreateButton("🌐 HACK API ROBLOX (Cari Data Developer)", ScrollingFrame)
DeepScanBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 150)

DeepScanBtn.MouseButton1Click:Connect(function()
    Notify("⚠️ MENGHACK API ROBLOX...", "Mengambil daftar semua animasi yang pernah dibuat oleh developer Evade...")

    task.spawn(function()
        local success, err = pcall(function()
            -- Hexagon Development Community Group ID: 10854488
            local url = "https://catalog.roproxy.com/v1/search/items/details?Category=12&CreatorTargetId=10854488&CreatorType=2&Limit=120"

            local responseStr = ""
            if type(request) == "function" then
                local res = request({Url = url, Method = "GET"})
                responseStr = res.Body
            elseif type(http_request) == "function" then
                local res = http_request({Url = url, Method = "GET"})
                responseStr = res.Body
            else
                responseStr = game:HttpGet(url)
            end

            local data = game:GetService("HttpService"):JSONDecode(responseStr)

            local foundId = nil
            local emoteName = EmoteNameInput.Text:lower()

            if data and data.data then
                for _, item in ipairs(data.data) do
                    if item.name and item.name:lower():find(emoteName) then
                        foundId = tostring(item.id)
                        break
                    end
                end
            end

            if foundId then
                Notify("🎯 HACK BERHASIL!", "ID Ketemu dari database pusat Roblox: " .. foundId)
                if IDInput then IDInput.Text = foundId end
                local ok = PlayAnimNow(foundId)
                if ok then
                    Notify("✅ Animasi Diputar!", "Jika macet, nyalakan Loop Mode!")
                end
            else
                Notify("❌ API GAGAL", "Animasi '" .. EmoteNameInput.Text .. "' disembunyikan dari publik.")
            end
        end)

        if not success then
            Notify("❌ HTTP Error", "Emulator kamu mungkin memblokir script internet: " .. tostring(err))
        end
    end)
end)

-- ========================================================
-- 📡 RADAR PENCURI EMOTE (SNIFFER)
-- ========================================================
local LabelRadar = Instance.new("TextLabel")
LabelRadar.Size = UDim2.new(1, 0, 0, 20)
LabelRadar.BackgroundTransparency = 1
LabelRadar.Text = "📡 Radar Pencuri Emote (Sniffer)"
LabelRadar.TextColor3 = Color3.fromRGB(200, 200, 200)
LabelRadar.Font = Enum.Font.GothamBold
LabelRadar.TextSize = 14
LabelRadar.TextXAlignment = Enum.TextXAlignment.Left
LabelRadar.Parent = ScrollingFrame

local RadarBtn = CreateButton("📡 Aktifkan Radar: OFF", ScrollingFrame)
RadarBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)

local LastSniffedLabel = Instance.new("TextLabel")
LastSniffedLabel.Size = UDim2.new(1, 0, 0, 20)
LastSniffedLabel.BackgroundTransparency = 1
LastSniffedLabel.Text = "Belum ada yang dicuri..."
LastSniffedLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
LastSniffedLabel.Font = Enum.Font.Gotham
LastSniffedLabel.TextSize = 12
LastSniffedLabel.Parent = ScrollingFrame

local PlaySniffedBtn = CreateButton("▶️ Mainkan Emote Curian", ScrollingFrame)
PlaySniffedBtn.BackgroundColor3 = Color3.fromRGB(150, 100, 0)

local radarActive = false
local seenAnims = {}
local lastSniffedId = nil

RadarBtn.MouseButton1Click:Connect(function()
    radarActive = not radarActive
    if radarActive then
        RadarBtn.Text = "📡 Radar Aktif: MENCARI..."
        RadarBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
        Notify("📡 Radar Menyala!", "Berdiri di dekat player lain yang lagi pakai emote. Radar akan menyedot ID-nya otomatis!")

        task.spawn(function()
            while radarActive do
                for _, p in pairs(game:GetService("Players"):GetPlayers()) do
                    if p ~= player and p.Character then
                        local hum = p.Character:FindFirstChildOfClass("Humanoid")
                        local animator = hum and (hum:FindFirstChildOfClass("Animator") or hum)
                        if animator then
                            pcall(function()
                                for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                                    if track.Animation and track.Animation.AnimationId then
                                        local idStr = track.Animation.AnimationId:match("%d+")
                                        if idStr and not seenAnims[idStr] then
                                            -- Abaikan ID animasi dasar (jalan, lari, diam, dll)
                                            if not idStr:match("^50777") then
                                                seenAnims[idStr] = true
                                                lastSniffedId = idStr
                                                LastSniffedLabel.Text = "Emote Curian: " .. idStr .. " (dari " .. p.Name .. ")"
                                                if IDInput then IDInput.Text = idStr end
                                                Notify("🚨 TARGET TERKUNCI!", p.Name .. " memakai emote baru (ID: " .. idStr .. "). Pencet tombol Play Curian!")
                                            end
                                        end
                                    end
                                end
                            end)
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
    else
        RadarBtn.Text = "📡 Aktifkan Radar: OFF"
        RadarBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        Notify("📡 Radar Mati", "Berhenti mencuri emote.")
    end
end)

PlaySniffedBtn.MouseButton1Click:Connect(function()
    if not lastSniffedId then
        Notify("❌ Belum Ada Curian", "Nyalakan radar dan tunggu player lain pakai emote!")
        return
    end

    local ok = PlayAnimNow(lastSniffedId)
    if ok then
        Notify("✅ Emote Curian Diputar!", "Jika macet, nyalakan Loop Mode!")
        if IDInput then IDInput.Text = lastSniffedId end
    end
end)

-- ========================================================
-- 🔍 SCAN ANIMASI GAME
-- ========================================================
local LabelScan = Instance.new("TextLabel")
LabelScan.Size = UDim2.new(1, 0, 0, 20)
LabelScan.BackgroundTransparency = 1
LabelScan.Text = "🔍 Scan Animasi Game"
LabelScan.TextColor3 = Color3.fromRGB(200, 200, 200)
LabelScan.Font = Enum.Font.GothamBold
LabelScan.TextSize = 14
LabelScan.TextXAlignment = Enum.TextXAlignment.Left
LabelScan.Parent = ScrollingFrame

local FilterInput = Instance.new("TextBox")
FilterInput.Size = UDim2.new(1, 0, 0, 40)
FilterInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
FilterInput.TextColor3 = Color3.fromRGB(255, 255, 255)
FilterInput.Font = Enum.Font.Gotham
FilterInput.TextSize = 14
FilterInput.PlaceholderText = "Filter animasi... (contoh: emote, cheer, rockin)"
FilterInput.Text = ""
FilterInput.Parent = ScrollingFrame

local cornerFilter = Instance.new("UICorner")
cornerFilter.CornerRadius = UDim.new(0, 6)
cornerFilter.Parent = FilterInput

local ScanBtn = CreateButton("🔍 Scan Semua Animasi", ScrollingFrame)
ScanBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 40)

-- Simpan semua animasi yang ditemukan
local allAnimations = {}

-- Label untuk hasil scan
local AnimListLabel = Instance.new("TextLabel")
AnimListLabel.Size = UDim2.new(1, 0, 0, 20)
AnimListLabel.BackgroundTransparency = 1
AnimListLabel.Text = "-- Klik Scan dulu --"
AnimListLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
AnimListLabel.Font = Enum.Font.Gotham
AnimListLabel.TextSize = 12
AnimListLabel.TextXAlignment = Enum.TextXAlignment.Left
AnimListLabel.TextWrapped = true
AnimListLabel.Parent = ScrollingFrame

-- Container untuk tombol-tombol hasil scan
local AnimContainer = Instance.new("Frame")
AnimContainer.Size = UDim2.new(1, 0, 0, 0)
AnimContainer.BackgroundTransparency = 1
AnimContainer.Parent = ScrollingFrame

local AnimListLayout = Instance.new("UIListLayout")
AnimListLayout.Padding = UDim.new(0, 5)
AnimListLayout.Parent = AnimContainer

local function RefreshAnimList(filterText)
    -- Bersihkan tombol lama
    for _, child in pairs(AnimContainer:GetChildren()) do
        if not child:IsA("UIListLayout") then child:Destroy() end
    end

    local filtered = {}
    for _, animData in ipairs(allAnimations) do
        if filterText == "" or animData.Name:lower():find(filterText:lower(), 1, true) then
            table.insert(filtered, animData)
        end
    end

    AnimListLabel.Text = "✅ " .. #filtered .. " dari " .. #allAnimations .. " animasi. Klik buat mainkan:"

    for _, animData in ipairs(filtered) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 35)
        btn.BackgroundColor3 = Color3.fromRGB(20, 60, 20)
        btn.Text = "▶ " .. animData.Name
        btn.TextColor3 = Color3.fromRGB(200, 255, 200)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 12
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.TextTruncate = Enum.TextTruncate.AtEnd
        btn.Parent = AnimContainer

        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 5)
        c.Parent = btn

        local capturedId = animData.Id
        local capturedName = animData.Name
        -- FIX: Gunakan PlayAnimNow (lebih kuat, tidak bisa di-stop Evade)
        btn.MouseButton1Click:Connect(function()
            local numId = capturedId:match("%d+")
            if numId then
                local ok = PlayAnimNow(numId)
                if ok then
                    Notify("✅ Animasi Dimainkan!", "'" .. capturedName .. "' berhasil diputar!")
                else
                    Notify("❌ Error", "Gagal memutar animasi.")
                end
            end
        end)
    end

    AnimContainer.Size = UDim2.new(1, 0, 0, AnimListLayout.AbsoluteContentSize.Y)
end

-- Filter real-time saat ngetik
FilterInput:GetPropertyChangedSignal("Text"):Connect(function()
    if #allAnimations > 0 then
        RefreshAnimList(FilterInput.Text)
    end
end)

ScanBtn.MouseButton1Click:Connect(function()
    allAnimations = {}
    local char = player.Character
    local searchRoots = {
        replicatedStorage, -- FIX: pakai variabel
        game:GetService("ReplicatedFirst"),
        game:GetService("Workspace"),
        char,
        player:FindFirstChild("PlayerGui"),
        player:FindFirstChild("Backpack"),
    }

    local seen = {}
    for _, root in pairs(searchRoots) do
        if root == nil then continue end
        for _, obj in pairs(root:GetDescendants()) do
            if obj:IsA("Animation") and not seen[obj.AnimationId] then
                seen[obj.AnimationId] = true
                table.insert(allAnimations, {Name = obj.Name, Id = obj.AnimationId})
            end
        end
    end

    if #allAnimations == 0 then
        AnimListLabel.Text = "❌ Tidak ada animasi ditemukan!"
        AnimContainer.Size = UDim2.new(1, 0, 0, 0)
    else
        RefreshAnimList(FilterInput.Text)
    end

    Notify("🔍 Scan Selesai", "Ditemukan " .. #allAnimations .. " animasi! Ketik di kotak filter untuk cari nama spesifik.")
end)

-- ========================================================
-- 💯 VERIFIED EMOTES (PASTI GERAK - ASLI ROBLOX)
-- ========================================================
local LabelVerified = Instance.new("TextLabel")
LabelVerified.Size = UDim2.new(1, 0, 0, 20)
LabelVerified.BackgroundTransparency = 1
LabelVerified.Text = "💯 VERIFIED EMOTES (PASTI GERAK!)"
LabelVerified.TextColor3 = Color3.fromRGB(0, 255, 100)
LabelVerified.Font = Enum.Font.GothamBold
LabelVerified.TextSize = 14
LabelVerified.TextXAlignment = Enum.TextXAlignment.Left
LabelVerified.Parent = ScrollingFrame

local verifiedEmotes = {
    -- Jika Evade R6 (sangat mungkin)
    {Name = "🕺 R6 Dance 1", Id = "183264076", Color = Color3.fromRGB(20, 80, 20)},
    {Name = "🕺 R6 Dance 2", Id = "183268422", Color = Color3.fromRGB(20, 80, 20)},
    {Name = "🕺 R6 Dance 3", Id = "183269374", Color = Color3.fromRGB(20, 80, 20)},
    {Name = "👋 R6 Wave",    Id = "128777973", Color = Color3.fromRGB(20, 60, 80)},

    -- Jika Evade R15
    {Name = "🤖 R15 Dance 1", Id = "507771019", Color = Color3.fromRGB(80, 40, 0)},
    {Name = "🤖 R15 Dance 2", Id = "507776043", Color = Color3.fromRGB(80, 40, 0)},
    {Name = "🤖 R15 Dance 3", Id = "507777268", Color = Color3.fromRGB(80, 40, 0)},
    {Name = "👋 R15 Wave",    Id = "507770239", Color = Color3.fromRGB(80, 30, 80)},
}

for _, emoteData in ipairs(verifiedEmotes) do
    local btn = CreateButton(emoteData.Name, ScrollingFrame)
    btn.BackgroundColor3 = emoteData.Color

    local animId = emoteData.Id
    local animName = emoteData.Name
    btn.MouseButton1Click:Connect(function()
        if IDInput then IDInput.Text = animId end
        local ok = PlayAnimNow(animId)
        if ok then
            -- FIX: Pesan notifikasi tidak lagi menyebut "Kloning Bayangan"
            Notify("✅ Berhasil!", animName .. " diputar!")
        else
            Notify("❌ Gagal", "Mungkin salah pilih R6/R15.")
        end
    end)
end

-- ========================================================
-- 👋 CUSTOM CFRAME WAVE (ANTI-BLOCK EVADE)
-- ========================================================
local CustomWaveBtn = CreateButton("👋 BIKIN SENDIRI: Custom Wave (Murni Fisika CFrame)", ScrollingFrame)
CustomWaveBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 150)

local customWaveLoop = nil
local savedRightShoulder = nil
local savedC0 = nil

CustomWaveBtn.MouseButton1Click:Connect(function()
    if customWaveLoop then
        customWaveLoop:Disconnect()
        customWaveLoop = nil
        if savedRightShoulder and savedC0 then
            savedRightShoulder.C0 = savedC0
        end
        CustomWaveBtn.Text = "👋 BIKIN SENDIRI: Custom Wave (Murni Fisika CFrame)"
        CustomWaveBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 150)
        Notify("🛑 Wave Dimatikan", "Tangan kembali normal.")
        return
    end

    local char = game.Players.LocalPlayer.Character
    if not char then return end

    local rightShoulder = nil
    -- Cari sendi bahu kanan (dukung R6 dan R15, bahkan custom rig Evade)
    for _, obj in pairs(char:GetDescendants()) do
        if obj:IsA("Motor6D") and (obj.Name:lower():match("right.*shoulder") or obj.Name:lower():match("rightupperarm")) then
            rightShoulder = obj
            break
        end
    end

    if not rightShoulder then
        Notify("❌ Gagal", "Sendi tangan kanan tidak ditemukan di karakter ini.")
        return
    end

    savedRightShoulder = rightShoulder
    savedC0 = rightShoulder.C0

    CustomWaveBtn.Text = "🛑 Hentikan Custom Wave"
    CustomWaveBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    Notify("👋 Custom Wave Aktif!", "Menggunakan peretasan C0 Murni! Anti-block!")

    local startTime = tick()
    -- RenderStepped untuk menimpa semua hal yang dilakukan Evade di frame yang sama
    customWaveLoop = game:GetService("RunService").RenderStepped:Connect(function()
        local t = tick() - startTime
        local waveAngle = math.sin(t * 10) * 0.5
        rightShoulder.C0 = savedC0 * CFrame.Angles(math.rad(150), math.rad(waveAngle * 60), 0)
    end)
end)

-- ========================================================
-- 🧬 INJECT DATA EMOTE (MEMBAJAK SYSTEM EVADE)
-- ========================================================
local InjectDataBtn = CreateButton("💉 INJECT DATA: Masukkan Semua Emote ke Inventory", ScrollingFrame)
InjectDataBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 150)

InjectDataBtn.MouseButton1Click:Connect(function()
    Notify("⏳ Mengekstrak Data...", "Membongkar ModuleScript Evade untuk mencari data Emote asli...")
    task.wait(0.1)

    local foundModules = 0
    local injected = false

    -- FIX: Gunakan variabel replicatedStorage
    for _, obj in pairs(replicatedStorage:GetDescendants()) do
        if obj:IsA("ModuleScript") then
            local ok, data = pcall(function() return require(obj) end)
            if ok and type(data) == "table" then
                local isEmoteTable = false
                for k, v in pairs(data) do
                    if type(v) == "table" and (v.AnimationId or v.Price or v.Tier or tostring(k):match("Rockin")) then
                        isEmoteTable = true
                        break
                    end
                end

                if isEmoteTable then
                    foundModules = foundModules + 1
                    -- Paksa ubah semua emote menjadi "Owned" = true
                    for emoteName, emoteData in pairs(data) do
                        if type(emoteData) == "table" then
                            emoteData.Owned = true
                            emoteData.Unlocked = true
                            emoteData.Purchased = true
                            injected = true
                        end
                    end
                end
            end
        end
    end

    if injected then
        Notify("✅ BERHASIL MENCURI DATA!", "Semua Emote berhasil di-unlock secara lokal! Coba buka menu Emote (G) di game sekarang!")
    else
        Notify("❌ Gagal", "Data Emote dienkripsi atau disembunyikan oleh Evade.")
    end
end)

-- ========================================================
-- 🎃 HALLOWEEN 2022 EVENT ROLLBACK & BYPASS
-- ========================================================

local LabelHalloween = Instance.new("TextLabel")
LabelHalloween.Size = UDim2.new(1, 0, 0, 20)
LabelHalloween.BackgroundTransparency = 1
LabelHalloween.Text = "🎃 HALLOWEEN 2022 EVENT BYPASS"
LabelHalloween.TextColor3 = Color3.fromRGB(255, 120, 0)
LabelHalloween.Font = Enum.Font.GothamBold
LabelHalloween.TextSize = 14
LabelHalloween.TextXAlignment = Enum.TextXAlignment.Left
LabelHalloween.Parent = ScrollingFrame

local HallowSpoofBtn = CreateButton("🕵️ AKTIFKAN SPOOFER EMOTE (Paling Ampuh!)", ScrollingFrame)
HallowSpoofBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 0)

local spooferActive = false
local spoofTarget = "Rockin' Stride"

HallowSpoofBtn.MouseButton1Click:Connect(function()
    spooferActive = not spooferActive
    if spooferActive then
        HallowSpoofBtn.Text = "🕵️ SPOOFER AKTIF! (Pakai Emote Apapun di Game!)"
        HallowSpoofBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        Notify("🕵️ Spoofer Aktif!", "Sekarang, buka menu Emote bawaan Evade, lalu pakai emote GRATIS (misal: Dance). Skrip akan menukarnya menjadi target emote di server!")
    else
        HallowSpoofBtn.Text = "🕵️ AKTIFKAN SPOOFER EMOTE (Paling Ampuh!)"
        HallowSpoofBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 0)
        Notify("🛑 Spoofer Mati", "Spoofer emote dimatikan.")
    end
end)

-- Hook RemoteEvents untuk menukar Emote secara langsung ke Server Evade
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if spooferActive and (method == "FireServer" or method == "InvokeServer") then
        local changed = false
        for i, v in ipairs(args) do
            if type(v) == "string" then
                -- Jika argument berupa nama emote gratis, tukar ke target
                if v:lower():find("dance") or v:lower():find("wave") or v:lower():find("cheer") or v:lower():find("point") or v:lower():find("laugh") then
                    args[i] = spoofTarget
                    changed = true
                end
            elseif type(v) == "table" then
                for k, val in pairs(v) do
                    if type(val) == "string" and (val:lower():find("dance") or val:lower():find("wave") or val:lower():find("cheer")) then
                        v[k] = spoofTarget
                        changed = true
                    end
                end
            end
        end

        -- Bypass khusus jika nama Remote berkaitan dengan Emote
        if self.Name:lower():match("emote") or self.Name:lower():match("equip") then
            if type(args[1]) == "string" and not changed then
                args[1] = spoofTarget
                changed = true
            elseif type(args[2]) == "string" and not changed then
                args[2] = spoofTarget
                changed = true
            end
        end

        if changed then
            return oldNamecall(self, unpack(args))
        end
    end

    return oldNamecall(self, ...)
end)

local SpooferTargetInput = Instance.new("TextBox")
SpooferTargetInput.Size = UDim2.new(1, 0, 0, 30)
SpooferTargetInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SpooferTargetInput.TextColor3 = Color3.fromRGB(255, 255, 255)
SpooferTargetInput.Font = Enum.Font.Gotham
SpooferTargetInput.TextSize = 12
SpooferTargetInput.PlaceholderText = "Ketik nama emote yg mau dispoof (Cth: Rockin' Stride)"
SpooferTargetInput.Text = "Rockin' Stride"
SpooferTargetInput.Parent = ScrollingFrame

SpooferTargetInput:GetPropertyChangedSignal("Text"):Connect(function()
    spoofTarget = SpooferTargetInput.Text
end)

local BruteForceBtn = CreateButton("🔥 BRUTE-FORCE SERVER (Paksa Putar!)", ScrollingFrame)
BruteForceBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
BruteForceBtn.MouseButton1Click:Connect(function()
    local eventsFired = 0
    -- FIX: Gunakan variabel replicatedStorage
    for _, obj in pairs(replicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            pcall(function() obj:FireServer("Equip", spoofTarget) end)
            pcall(function() obj:FireServer("EquipEmote", spoofTarget) end)
            pcall(function() obj:FireServer("Emote", spoofTarget) end)
            pcall(function() obj:FireServer("PlayEmote", spoofTarget) end)
            pcall(function() obj:FireServer({Emote = spoofTarget}) end)
            pcall(function() obj:FireServer({EmoteName = spoofTarget}) end)
            pcall(function() obj:FireServer("Communication", {"Equip", spoofTarget}) end)
            eventsFired = eventsFired + 1
        end
    end
    Notify("🔥 Brute-Force Selesai", "Telah mengirim perintah paksa ke " .. eventsFired .. " RemoteEvent!")
end)

local VisualEmoteBtn = CreateButton("👀 VISUAL ONLY: Putar Rockin' Stride", ScrollingFrame)
VisualEmoteBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)

VisualEmoteBtn.MouseButton1Click:Connect(function()
    Notify("⏳ Mencari...", "Sedang mencari file animasi Rockin' Stride di dalam memori game...")
    task.wait(0.1)

    local foundAnimId = nil
    local searchRoots = {
        replicatedStorage, -- FIX: pakai variabel
        game:GetService("ReplicatedFirst"),
        game.Players.LocalPlayer:FindFirstChild("PlayerGui")
    }

    for _, root in pairs(searchRoots) do
        if root then
            for _, obj in pairs(root:GetDescendants()) do
                if obj:IsA("Animation") then
                    local name = obj.Name:lower()
                    if name:match("rockin") or name:match("stride") then
                        foundAnimId = obj.AnimationId
                        break
                    end
                end
            end
        end
        if foundAnimId then break end
    end

    if foundAnimId then
        local numId = foundAnimId:match("%d+")
        if numId then
            local ok = PlayAnimNow(numId)
            if ok then
                Notify("👀 Berhasil!", "Animasi Rockin' Stride internal (" .. numId .. ") ditemukan dan diputar!")
            else
                Notify("❌ Gagal", "Gagal memutar animasi internal.")
            end
        else
            Notify("❌ Gagal", "ID internal tidak valid: " .. tostring(foundAnimId))
        end
    else
        Notify("❌ Tidak Ditemukan", "File animasi Rockin' Stride disembunyikan kuat oleh developer.")
    end
end)

local HallowAtmosBtn = CreateButton("🌕 Suasana Map Blood Moon Halloween 2022", ScrollingFrame)
HallowAtmosBtn.BackgroundColor3 = Color3.fromRGB(90, 0, 120)

local hallowAtmosConn = nil
HallowAtmosBtn.MouseButton1Click:Connect(function()
    if hallowAtmosConn then
        hallowAtmosConn:Disconnect()
        hallowAtmosConn = nil
        HallowAtmosBtn.Text = "🌕 Suasana Map Blood Moon Halloween 2022"
        HallowAtmosBtn.BackgroundColor3 = Color3.fromRGB(90, 0, 120)
        Notify("🛑 Blood Moon Mati", "Pencahayaan kembali dikontrol oleh Evade.")
        return
    end

    HallowAtmosBtn.Text = "🌕 Matikan Blood Moon 2022"
    HallowAtmosBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    Notify("🌕 Blood Moon 2022!", "Memaksa suasana Halloween 2022 setiap detik! (Anti-Reset Evade)")

    local lighting = game:GetService("Lighting")

    local cc    = lighting:FindFirstChildOfClass("ColorCorrectionEffect") or Instance.new("ColorCorrectionEffect", lighting)
    local bloom = lighting:FindFirstChildOfClass("BloomEffect")           or Instance.new("BloomEffect", lighting)
    local atmos = lighting:FindFirstChildOfClass("Atmosphere")            or Instance.new("Atmosphere", lighting)

    -- Paksa setiap frame agar Evade tidak bisa meresetnya
    hallowAtmosConn = game:GetService("RunService").RenderStepped:Connect(function()
        lighting.ClockTime    = 0
        lighting.Brightness   = 0.8
        lighting.GlobalShadows= true
        lighting.Ambient      = Color3.fromRGB(50, 10, 60)
        lighting.OutdoorAmbient = Color3.fromRGB(80, 25, 10)
        lighting.FogColor     = Color3.fromRGB(30, 10, 5)
        lighting.FogStart     = 0
        lighting.FogEnd       = 250

        cc.Brightness  = -0.05
        cc.Contrast    = 0.35
        cc.Saturation  = 0.2
        cc.TintColor   = Color3.fromRGB(255, 160, 90)

        bloom.Intensity = 0.7
        bloom.Size      = 30
        bloom.Threshold = 0.4

        atmos.Density = 0.6
        atmos.Color   = Color3.fromRGB(90, 30, 10)
        atmos.Decay   = Color3.fromRGB(40, 10, 5)
    end)
end)

local HallowMusicBtn = CreateButton("🎵 Play Halloween 2022 Chase Soundtrack", ScrollingFrame)
HallowMusicBtn.BackgroundColor3 = Color3.fromRGB(60, 90, 0)

local currentHallowSound = nil
HallowMusicBtn.MouseButton1Click:Connect(function()
    if currentHallowSound then
        currentHallowSound:Stop()
        currentHallowSound:Destroy()
        currentHallowSound = nil
        Notify("🎵 Musik Dimatikan", "Soundtrack Halloween 2022 di-stop.")
    else
        currentHallowSound = Instance.new("Sound")
        currentHallowSound.SoundId = "rbxassetid://1837849405"
        currentHallowSound.Volume  = 1
        currentHallowSound.Looped  = true
        currentHallowSound.Parent  = game:GetService("SoundService")
        currentHallowSound:Play()
        Notify("🎵 Halloween Soundtrack!", "Memutar musik tema Halloween 2022.")
    end
end)

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
-- 👿 X-RAY DUMMY SNIFFER (LIVE TRACKER)
-- ========================================================
local LabelGod = Instance.new("TextLabel")
LabelGod.Size = UDim2.new(1, 0, 0, 20)
LabelGod.BackgroundTransparency = 1
LabelGod.Text = "👿 X-Ray Sniffer (Curian Dummy)"
LabelGod.TextColor3 = Color3.fromRGB(255, 50, 50)
LabelGod.Font = Enum.Font.GothamBold
LabelGod.TextSize = 14
LabelGod.TextXAlignment = Enum.TextXAlignment.Left
LabelGod.Parent = ScrollingFrame

local GodHookBtn = CreateButton("👿 Sedot Animasi dari Dummy Shop", ScrollingFrame)
GodHookBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)

local GodStatus = Instance.new("TextLabel")
GodStatus.Size = UDim2.new(1, 0, 0, 30)
GodStatus.BackgroundTransparency = 1
GodStatus.Text = "Belum menyedot apa-apa..."
GodStatus.TextColor3 = Color3.fromRGB(200, 200, 200)
GodStatus.Font = Enum.Font.Gotham
GodStatus.TextSize = 12
GodStatus.TextWrapped = true
GodStatus.Parent = ScrollingFrame

local XRayContainer = Instance.new("Frame")
XRayContainer.Size = UDim2.new(1, 0, 0, 0)
XRayContainer.BackgroundTransparency = 1
XRayContainer.Parent = ScrollingFrame
local XRayLayout = Instance.new("UIListLayout")
XRayLayout.SortOrder = Enum.SortOrder.LayoutOrder
XRayLayout.Padding = UDim.new(0, 5)
XRayLayout.Parent = XRayContainer

local isSniffing = false

-- FIX: ID animasi dasar dijadikan tabel lookup agar tidak ada pengulangan string panjang
local baseAnimIds = {
    ["507770239"] = true, ["507777826"] = true, ["507766388"] = true,
    ["507766951"] = true, ["507766666"] = true, ["507765000"] = true,
    ["507765644"] = true, ["507767714"] = true, ["507768375"] = true,
    ["507767202"] = true,
}

GodHookBtn.MouseButton1Click:Connect(function()
    if isSniffing then return end
    isSniffing = true
    GodHookBtn.Text = "👿 MENGX-RAY SELURUH MAP..."
    GodHookBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
    Notify("👿 X-RAY AKTIF", "Mencari Dummy Shop yang lagi joget...")

    task.spawn(function()
        local foundIds = {}

        -- Cari semua Animator di dalam Workspace (termasuk dummy shop)
        for _, obj in pairs(game:GetService("Workspace"):GetDescendants()) do
            if obj:IsA("Animator") then
                for _, track in pairs(obj:GetPlayingAnimationTracks()) do
                    if track.Animation and track.Animation.AnimationId then
                        local id = track.Animation.AnimationId:match("%d+")
                        -- FIX: Gunakan tabel lookup untuk filter animasi dasar
                        if id and not baseAnimIds[id] then
                            foundIds[id] = true
                        end
                    end
                end
            end
        end

        -- Cari juga di LocalPlayer (ViewportFrame di UI Shop)
        for _, obj in pairs(game:GetService("Players").LocalPlayer:GetDescendants()) do
            if obj:IsA("Animator") then
                for _, track in pairs(obj:GetPlayingAnimationTracks()) do
                    if track.Animation and track.Animation.AnimationId then
                        local id = track.Animation.AnimationId:match("%d+")
                        if id and not baseAnimIds[id] then
                            foundIds[id] = true
                        end
                    end
                end
            end
        end

        -- Bersihkan hasil sebelumnya
        for _, child in ipairs(XRayContainer:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end

        local count = 0
        for id, _ in pairs(foundIds) do
            count = count + 1
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.BackgroundColor3 = Color3.fromRGB(150, 80, 0)
            btn.Text = "▶️ Coba Play ID: " .. id
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 12
            btn.Parent = XRayContainer

            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 5)
            c.Parent = btn

            btn.MouseButton1Click:Connect(function()
                if IDInput then IDInput.Text = id end
                local ok = PlayAnimNow(id)
                if ok then
                    Notify("✅ Animasi Diputar!", "Jika cocok, nyalakan Loop Mode!")
                end
            end)
        end

        XRayContainer.Size = UDim2.new(1, 0, 0, count * 35)

        if count > 0 then
            GodStatus.Text = "Ketemu " .. count .. " animasi! Coba satu-satu di bawah:"
            Notify("🎯 TARGET DIKUNCI!", "Ditemukan beberapa animasi! Coba klik tombol di bawah untuk ngetes.")
        else
            GodStatus.Text = "❌ Tidak ada dummy yang lagi joget."
            Notify("❌ GAGAL", "Pastikan Dummy di Shop SEDANG BERGERAK, lalu klik tombol ini lagi!")
        end

        task.wait(1)
        isSniffing = false
        GodHookBtn.Text = "👿 Sedot Animasi dari Dummy Shop"
        GodHookBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    end)
    -- FIX: Dead code (~50 baris) setelah "if true then return end" sudah dihapus sepenuhnya
end)

-- ========================================================
-- 🎬 AUTO-CATCH VISUAL EMOTE (TANGKAP OTOMATIS DARI SHOP)
-- ========================================================
-- Cara pakai:
--   1. Aktifkan tombol "Auto-Catch"
--   2. Buka Shop Evade (walau belum beli)
--   3. Hover/klik emote → dummy preview joget
--   4. ID otomatis tertangkap dan muncul sebagai tombol
--   5. Klik tombol → emote langsung dimainkan di karakter kamu (visual only)
-- ========================================================

local LabelAutoCatch = Instance.new("TextLabel")
LabelAutoCatch.Size = UDim2.new(1, 0, 0, 20)
LabelAutoCatch.BackgroundTransparency = 1
LabelAutoCatch.Text = "🎬 Auto-Catch Visual Emote (dari Shop)"
LabelAutoCatch.TextColor3 = Color3.fromRGB(100, 220, 255)
LabelAutoCatch.Font = Enum.Font.GothamBold
LabelAutoCatch.TextSize = 14
LabelAutoCatch.TextXAlignment = Enum.TextXAlignment.Left
LabelAutoCatch.Parent = ScrollingFrame

local LabelAutoCatchInfo = Instance.new("TextLabel")
LabelAutoCatchInfo.Size = UDim2.new(1, 0, 0, 40)
LabelAutoCatchInfo.BackgroundTransparency = 1
LabelAutoCatchInfo.Text = "Aktifkan → buka shop Evade → hover emote → ID otomatis tertangkap!"
LabelAutoCatchInfo.TextColor3 = Color3.fromRGB(160, 160, 160)
LabelAutoCatchInfo.Font = Enum.Font.Gotham
LabelAutoCatchInfo.TextSize = 11
LabelAutoCatchInfo.TextXAlignment = Enum.TextXAlignment.Left
LabelAutoCatchInfo.TextWrapped = true
LabelAutoCatchInfo.Parent = ScrollingFrame

local AutoCatchBtn = CreateButton("🎬 Auto-Catch: OFF", ScrollingFrame)
AutoCatchBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 80)

local ClearCatchBtn = CreateButton("🗑️ Hapus Semua Hasil Tangkapan", ScrollingFrame)
ClearCatchBtn.BackgroundColor3 = Color3.fromRGB(60, 30, 30)

local CatchStatusLabel = Instance.new("TextLabel")
CatchStatusLabel.Size = UDim2.new(1, 0, 0, 20)
CatchStatusLabel.BackgroundTransparency = 1
CatchStatusLabel.Text = "Belum menangkap emote apapun..."
CatchStatusLabel.TextColor3 = Color3.fromRGB(255, 220, 80)
CatchStatusLabel.Font = Enum.Font.Gotham
CatchStatusLabel.TextSize = 12
CatchStatusLabel.TextXAlignment = Enum.TextXAlignment.Left
CatchStatusLabel.Parent = ScrollingFrame

-- Container untuk tombol-tombol emote hasil tangkapan
local CatchContainer = Instance.new("Frame")
CatchContainer.Size = UDim2.new(1, 0, 0, 0)
CatchContainer.BackgroundTransparency = 1
CatchContainer.Parent = ScrollingFrame

local CatchLayout = Instance.new("UIListLayout")
CatchLayout.Padding = UDim.new(0, 5)
CatchLayout.SortOrder = Enum.SortOrder.LayoutOrder
CatchLayout.Parent = CatchContainer

local autoCatchActive = false
local autoCatchThread = nil
local caughtEmotes = {}      -- { [id] = true } untuk cek duplikat
local caughtEmoteCount = 0
local baselineIds = {}       -- Snapshot ID yang sudah ada SEBELUM Auto-Catch aktif

-- FIX: Hanya scan PlayerGui (tempat ViewportFrame shop Evade berada)
-- Workspace sengaja TIDAK discan agar tidak tangkap NPC/player lain
local function GetShopAnimatorIds()
    local found = {}
    local playerGui = player:FindFirstChild("PlayerGui")
    if not playerGui then return found end

    for _, obj in pairs(playerGui:GetDescendants()) do
        -- FIX: Hanya ambil dari ViewportFrame (tempat dummy shop)
        -- dan pastikan bukan Animator milik karakter player sendiri
        if obj:IsA("Animator") then
            -- Pastikan Animator ini bukan milik karakter kita sendiri
            local isOwnChar = false
            if player.Character then
                local parent = obj
                while parent do
                    if parent == player.Character then
                        isOwnChar = true
                        break
                    end
                    parent = parent.Parent
                end
            end
            if not isOwnChar then
                pcall(function()
                    for _, track in pairs(obj:GetPlayingAnimationTracks()) do
                        if track.Animation and track.Animation.AnimationId then
                            local id = track.Animation.AnimationId:match("%d+")
                            if id then
                                found[id] = true
                            end
                        end
                    end
                end)
            end
        end
    end
    return found
end

local function AddCaughtEmoteButton(id)
    caughtEmoteCount = caughtEmoteCount + 1
    local label = "Emote #" .. caughtEmoteCount

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(10, 60, 80)
    btn.TextColor3 = Color3.fromRGB(100, 220, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.TextTruncate = Enum.TextTruncate.AtEnd
    btn.Text = "▶️ " .. label .. "  |  ID: " .. id
    btn.Parent = CatchContainer

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    -- Tombol copy ID kecil di kanan
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

    -- Klik tombol utama → langsung play di karakter
    btn.MouseButton1Click:Connect(function()
        if IDInput then IDInput.Text = id end
        local ok = PlayAnimNow(id)
        if ok then
            Notify("✅ Visual Emote Dimainkan!", "ID: " .. id .. " | Hanya kamu yang bisa lihat!")
        else
            Notify("❌ Gagal", "Karakter tidak siap atau animasi tidak valid.")
        end
    end)

    -- Klik copy → taruh ID ke input box
    copyBtn.MouseButton1Click:Connect(function()
        if IDInput then IDInput.Text = id end
        copyBtn.Text = "✅ Copied!"
        task.delay(1.5, function()
            if copyBtn and copyBtn.Parent then
                copyBtn.Text = "📋 Copy"
            end
        end)
    end)

    -- Update ukuran container
    CatchContainer.Size = UDim2.new(1, 0, 0, CatchLayout.AbsoluteContentSize.Y)
end

local function ScanAndCatch()
    -- FIX: Hanya ambil dari PlayerGui (ViewportFrame shop), bukan seluruh game
    local currentIds = GetShopAnimatorIds()

    for id, _ in pairs(currentIds) do
        -- FIX: Abaikan jika ID sudah ada sebelum Auto-Catch aktif (baseline)
        -- Abaikan juga animasi dasar Roblox
        if not caughtEmotes[id] and not baselineIds[id] and not baseAnimIds[id] then
            caughtEmotes[id] = true
            task.spawn(function()
                AddCaughtEmoteButton(id)
                CatchStatusLabel.Text = "🎯 " .. caughtEmoteCount .. " emote tertangkap! Klik untuk mainkan."
                Notify("🎬 Emote Tertangkap!", "ID: " .. id .. " | Klik tombol biru untuk mainkan!")
            end)
        end
    end
end

AutoCatchBtn.MouseButton1Click:Connect(function()
    autoCatchActive = not autoCatchActive
    if autoCatchActive then
        -- FIX: Ambil snapshot semua ID yang SUDAH ADA sekarang sebagai baseline
        -- Agar animasi yang sudah berjalan sebelum shop dibuka tidak ikut tertangkap
        baselineIds = {}
        local existing = GetShopAnimatorIds()
        for id, _ in pairs(existing) do
            baselineIds[id] = true
        end
        -- Tandai juga ID yang sudah pernah ditangkap sebelumnya
        for id, _ in pairs(caughtEmotes) do
            baselineIds[id] = true
        end

        AutoCatchBtn.Text = "🎬 Auto-Catch: ON (Buka Shop Sekarang!)"
        AutoCatchBtn.BackgroundColor3 = Color3.fromRGB(0, 130, 180)
        Notify("🎬 Auto-Catch Aktif!", "Buka Shop Evade lalu klik/hover emote. Hanya emote BARU yang akan tertangkap!")

        -- Jalankan scanner di background setiap 0.3 detik
        autoCatchThread = task.spawn(function()
            while autoCatchActive do
                ScanAndCatch()
                task.wait(0.3)
            end
        end)
    else
        autoCatchActive = false
        if autoCatchThread then
            task.cancel(autoCatchThread)
            autoCatchThread = nil
        end
        AutoCatchBtn.Text = "🎬 Auto-Catch: OFF"
        AutoCatchBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 80)
        Notify("🎬 Auto-Catch Dimatikan", caughtEmoteCount .. " emote tersimpan. Klik tombol biru untuk mainkan.")
    end
end)

ClearCatchBtn.MouseButton1Click:Connect(function()
    -- Bersihkan semua tombol hasil tangkapan
    for _, child in pairs(CatchContainer:GetChildren()) do
        if not child:IsA("UIListLayout") then child:Destroy() end
    end
    caughtEmotes = {}
    caughtEmoteCount = 0
    CatchContainer.Size = UDim2.new(1, 0, 0, 0)
    CatchStatusLabel.Text = "Belum menangkap emote apapun..."
    Notify("🗑️ Dibersihkan", "Semua hasil tangkapan dihapus.")
end)

-- Update otomatis ukuran container saat ada button baru
CatchLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    CatchContainer.Size = UDim2.new(1, 0, 0, CatchLayout.AbsoluteContentSize.Y)
end)

-- FIX: CloseBtn sekarang juga sinkronkan state isVisible dan tampilan ToggleBtn
local CloseBtn = CreateButton("❌ Sembunyikan UI", ScrollingFrame)
CloseBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    isVisible = false
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 80, 0)
    ToggleBtn.Text = "👁️"
end)

-- Update konten scroll
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
end)

Notify("Alien Wayae", "Berhasil inject Evade Script! (Klik icon 👽 di pojok untuk buka/tutup menu)")
