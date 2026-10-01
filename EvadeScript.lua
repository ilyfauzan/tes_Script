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
    -- Simple notification logic (using Roblox's built-in StarterGui or custom text)
    game.StarterGui:SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = 3;
    })
end

-- ========================================================
-- FITUR EVADE
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

-- Nama emote yang mau di-inject
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

local InjectBtn = CreateButton("💉 Inject Emote ke Picker UI", ScrollingFrame)
InjectBtn.BackgroundColor3 = Color3.fromRGB(120, 60, 0)

local ScanRemoteBtn = CreateButton("🔍 Scan RemoteEvent Emote", ScrollingFrame)
ScanRemoteBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 100)

-- Tombol untuk fire remote secara langsung
local FireRemoteBtn = CreateButton("🚀 Fire Emote Remote Langsung", ScrollingFrame)
FireRemoteBtn.BackgroundColor3 = Color3.fromRGB(100, 40, 120)

-- Simpan remote yang ditemukan
local foundEmoteRemote = nil

ScanRemoteBtn.MouseButton1Click:Connect(function()
    foundEmoteRemote = nil
    local playerGui = player:FindFirstChild("PlayerGui")
    local results = {}
    
    -- Scan semua RemoteEvent di ReplicatedStorage
    for _, obj in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local n = obj.Name:lower()
            if n:find("emote") or n:find("equip") or n:find("item") or n:find("cosmetic") then
                table.insert(results, obj.Name .. " [" .. obj.ClassName .. "]")
                if not foundEmoteRemote then
                    foundEmoteRemote = obj
                end
            end
        end
    end
    
    if #results > 0 then
        Notify("✅ Remote Ketemu!", table.concat(results, " | "):sub(1, 200))
    else
        Notify("❌ Tidak ada Remote Emote/Equip ditemukan.", "Coba inject ke UI langsung!")
    end
end)

FireRemoteBtn.MouseButton1Click:Connect(function()
    local emoteName = EmoteNameInput.Text
    if not foundEmoteRemote then
        Notify("❌ Scan dulu!", "Pencet 'Scan RemoteEvent Emote' dulu ya Bang!")
        return
    end
    
    -- Coba berbagai cara fire remotenya
    local tries = {
        function() foundEmoteRemote:FireServer(emoteName) end,
        function() foundEmoteRemote:FireServer(1, emoteName) end,
        function() foundEmoteRemote:FireServer({EmoteName = emoteName}) end,
        function() foundEmoteRemote:FireServer({Emote = emoteName, Slot = 1}) end,
        function() foundEmoteRemote:FireServer("Equip", emoteName) end,
    }
    
    local fired = 0
    for _, fn in ipairs(tries) do
        if pcall(fn) then fired = fired + 1 end
    end
    
    Notify("🚀 Tembak " .. fired .. " variasi!", "Cek emote slot Abang sekarang!")
end)

InjectBtn.MouseButton1Click:Connect(function()
    local emoteName = EmoteNameInput.Text
    local playerGui = player:FindFirstChild("PlayerGui")
    if not playerGui then Notify("❌", "PlayerGui tidak ditemukan!") return end
    
    -- Cari UI "EQUIP AN ITEM" di dalam PlayerGui
    local itemPickerFrame = nil
    local existingBtn = nil
    
    for _, obj in pairs(playerGui:GetDescendants()) do
        local nameL = obj.Name:lower()
        -- Cari frame picker emote
        if obj:IsA("TextLabel") and (obj.Text:lower():find("equip") or obj.Text:lower():find("item")) then
            itemPickerFrame = obj.Parent
        end
        -- Cari tombol emote yang sudah ada (Catjam dll)
        if obj:IsA("TextButton") or obj:IsA("ImageButton") then
            if obj.Name:lower():find("catjam") or 
               (obj.Parent and obj.Parent.Name:lower():find("emote")) or
               (obj.Parent and obj.Parent.Name:lower():find("item")) then
                existingBtn = obj
            end
        end
    end
    
    local debugInfo = {}
    if itemPickerFrame then table.insert(debugInfo, "Frame: " .. itemPickerFrame.Name) end
    if existingBtn then table.insert(debugInfo, "Btn: " .. existingBtn.Name .. " Parent: " .. existingBtn.Parent.Name) end
    
    if existingBtn then
        -- Clone tombol yang ada dan ubah jadi Rockin' Stride
        local newBtn = existingBtn:Clone()
        newBtn.Parent = existingBtn.Parent
        
        -- Ganti semua text di dalam clone
        if newBtn:IsA("TextButton") then
            newBtn.Text = emoteName
        end
        for _, child in pairs(newBtn:GetDescendants()) do
            if child:IsA("TextLabel") then
                if child.Text:lower():find("catjam") or child.Text:lower():find("emote") then
                    child.Text = emoteName
                end
            end
        end
        
        -- Konek ke event click dari tombol asli dan fire dengan nama baru
        local connections = {}
        pcall(function() connections = getconnections(existingBtn.MouseButton1Click) end)
        
        newBtn.MouseButton1Click:Connect(function()
            -- Fire semua connection yang ada di tombol asli tapi dengan emote baru
            for _, conn in pairs(connections) do
                pcall(function() conn:Fire() end)
            end
            -- Juga coba fire remote langsung
            if foundEmoteRemote then
                pcall(function() foundEmoteRemote:FireServer(emoteName) end)
            end
            Notify("💉 " .. emoteName .. " diklik!", "Semoga server menerimanya!")
        end)
        
        Notify("✅ Berhasil inject '" .. emoteName .. "' ke picker!", "Buka menu Emote Evade, tombol baru sudah muncul!")
    else
        -- Buka dulu menu emote Evade baru inject
        Notify("⚠️ Buka menu EMOTES Evade dulu!", "Masuk ke Customization > EMOTES > klik slot, LALU pencet inject lagi!")
        if #debugInfo > 0 then
            Notify("🔍 Debug:", table.concat(debugInfo, " | "):sub(1, 150))
        end
    end
end)


PlayByIDBtn.BackgroundColor3 = Color3.fromRGB(100, 40, 120)

local LoopBtn = CreateButton("🔁 Loop Mode: OFF", ScrollingFrame)
LoopBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local StopBtn = CreateButton("⛔ Stop Animasi", ScrollingFrame)
StopBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 30)

local function PlayAnimNow(idStr)
    local char = player.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    local animator = hum:FindFirstChildOfClass("Animator") or hum
    
    local ok = pcall(function()
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://" .. idStr
        local track = animator:LoadAnimation(anim)
        track.Priority = Enum.AnimationPriority.Action4
        track:Play()
    end)
    return ok
end

LoopBtn.MouseButton1Click:Connect(function()
    loopActive = not loopActive
    if loopActive then
        LoopBtn.Text = "🔁 Loop Mode: ON"
        LoopBtn.BackgroundColor3 = Color3.fromRGB(30, 100, 30)
        
        local idStr = IDInput.Text:match("%d+") or "3360686498"
        loopThread = task.spawn(function()
            while loopActive do
                PlayAnimNow(idStr)
                task.wait(0.3)
            end
        end)
        Notify("🔁 Loop Aktif!", "Animasi akan terus diputar ulang tiap 0.3 detik!")
    else
        loopActive = false
        LoopBtn.Text = "🔁 Loop Mode: OFF"
        LoopBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Notify("⏹️ Loop Berhenti", "Loop animasi dihentikan.")
    end
end)

StopBtn.MouseButton1Click:Connect(function()
    loopActive = false
    LoopBtn.Text = "🔁 Loop Mode: OFF"
    LoopBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    
    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        local animator = hum and (hum:FindFirstChildOfClass("Animator") or hum)
        if animator then
            for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                pcall(function() track:Stop(0) end)
            end
        end
    end
    Notify("⛔ Animasi Dihentikan", "Semua animasi paksa sudah di-stop.")
end)

PlayByIDBtn.MouseButton1Click:Connect(function()
    local idStr = IDInput.Text:match("%d+")
    if not idStr then
        Notify("❌ ID Salah", "Masukkan angka ID animasi yang valid!")
        return
    end
    
    local ok = PlayAnimNow(idStr)
    if ok then
        Notify("✅ ID " .. idStr .. " diputar!", "Kalau karakter masih diam, aktifkan Loop Mode!")
    else
        Notify("❌ Gagal", "Error saat memutar ID " .. idStr)
    end
end)

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

local function PlayAnimById(animId, animName)
    local char = player.Character
    if not char then Notify("❌", "Karakter tidak ada!") return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator") or hum
    
    local anim = Instance.new("Animation")
    anim.AnimationId = animId
    
    local ok, err = pcall(function()
        local track = animator:LoadAnimation(anim)
        track:Play()
    end)
    
    if ok then
        Notify("✅ Animasi Dimainkan!", "'" .. animName .. "' berhasil diputar!")
    else
        Notify("❌ Error", tostring(err):sub(1, 100))
    end
end

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
        btn.MouseButton1Click:Connect(function()
            PlayAnimById(capturedId, capturedName)
        end)
    end
    
    AnimContainer.Size = UDim2.new(1, 0, 0, AnimListLayout.AbsoluteContentSize.Y)
end

-- Filter real-time saat Abang ngetik
FilterInput:GetPropertyChangedSignal("Text"):Connect(function()
    if #allAnimations > 0 then
        RefreshAnimList(FilterInput.Text)
    end
end)

ScanBtn.MouseButton1Click:Connect(function()
    allAnimations = {}
    local char = player.Character
    local searchRoots = {
        game:GetService("ReplicatedStorage"),
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
        -- Logic ESP Sederhana
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

local CloseBtn = CreateButton("❌ Sembunyikan UI", ScrollingFrame)
CloseBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Tombol Floating untuk Munculin/Sembunyiin UI
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 10, 0, 10) -- Pojok kiri atas
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
ToggleBtn.Text = "👽"
ToggleBtn.TextSize = 24
ToggleBtn.Parent = WayaeUI

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0) -- Bikin bulat
ToggleCorner.Parent = ToggleBtn

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Update konten scroll
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
end)

Notify("Alien Wayae", "Berhasil inject Evade Script! (Klik icon 👽 di pojok untuk buka/tutup menu)")
