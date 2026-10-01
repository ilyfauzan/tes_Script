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

local LabelEmote = Instance.new("TextLabel")
LabelEmote.Size = UDim2.new(1, 0, 0, 20)
LabelEmote.BackgroundTransparency = 1
LabelEmote.Text = "🎭 Emote Hack"
LabelEmote.TextColor3 = Color3.fromRGB(200, 200, 200)
LabelEmote.Font = Enum.Font.GothamBold
LabelEmote.TextSize = 14
LabelEmote.TextXAlignment = Enum.TextXAlignment.Left
LabelEmote.Parent = ScrollingFrame

local EmoteInput = Instance.new("TextBox")
EmoteInput.Size = UDim2.new(1, 0, 0, 40)
EmoteInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
EmoteInput.TextColor3 = Color3.fromRGB(255, 255, 255)
EmoteInput.Font = Enum.Font.Gotham
EmoteInput.TextSize = 14
EmoteInput.PlaceholderText = "Ketik Nama Emote (contoh: Rockin' Stride)"
EmoteInput.Text = "Rockin' Stride"
EmoteInput.Parent = ScrollingFrame

local cornerInput = Instance.new("UICorner")
cornerInput.CornerRadius = UDim.new(0, 6)
cornerInput.Parent = EmoteInput

local PlayEmoteBtn = CreateButton("🚀 Paksa Play Emote!", ScrollingFrame)
PlayEmoteBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 40)

PlayEmoteBtn.MouseButton1Click:Connect(function()
    local emoteName = EmoteInput.Text
    if emoteName == "" then return end
    
    local char = player.Character
    if not char then 
        Notify("❌ Gagal", "Karakter tidak ditemukan!")
        return 
    end
    
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator") or hum
    
    local targetAnimation = nil
    
    -- TAHAP 1: Cari di SELURUH GAME (bukan cuma ReplicatedStorage)
    local searchRoots = {
        game:GetService("ReplicatedStorage"),
        game:GetService("ReplicatedFirst"),
        game:GetService("Workspace"),
        player.Character,
        player:FindFirstChild("PlayerGui"),
        player:FindFirstChild("Backpack"),
    }
    
    for _, root in pairs(searchRoots) do
        if root == nil then continue end
        for _, obj in pairs(root:GetDescendants()) do
            if obj:IsA("Animation") then
                if obj.Name:lower() == emoteName:lower() or obj.Name:lower():find(emoteName:lower()) then
                    targetAnimation = obj
                    break
                end
            end
            if obj:IsA("StringValue") or obj:IsA("Folder") or obj:IsA("ModuleScript") then
                if obj.Name:lower():find(emoteName:lower()) then
                    local anim = obj:FindFirstChildOfClass("Animation")
                    if anim then
                        targetAnimation = anim
                        break
                    end
                end
            end
        end
        if targetAnimation then break end
    end
    
    -- TAHAP 2: Cari dari HumanoidDescription (Emote yang sudah di-equip player)
    if not targetAnimation then
        local hd = hum:FindFirstChildOfClass("HumanoidDescription")
        if hd then
            local emoteSlots = {"Emote1","Emote2","Emote3","Emote4","Emote5","Emote6","Emote7","Emote8"}
            for _, slot in pairs(emoteSlots) do
                local val = hd:FindFirstChild(slot)
                if val and tostring(val.Value):lower():find(emoteName:lower()) then
                    local anim = Instance.new("Animation")
                    anim.AnimationId = "rbxassetid://" .. tostring(val.Value)
                    targetAnimation = anim
                    break
                end
            end
        end
    end
    
    -- TAHAP 3: Cari di AnimationTracks yang pernah di-load (cached di Animator)
    if not targetAnimation then
        for _, track in pairs(animator:GetPlayingAnimationTracks()) do
            if track.Animation and track.Animation.Name:lower():find(emoteName:lower()) then
                targetAnimation = track.Animation
                break
            end
        end
    end
    
    -- TAHAP 4: Kalau tetap tidak ketemu, print daftar semua animasi yang ada biar kita tau namanya
    if not targetAnimation then
        local found = {}
        for _, root in pairs(searchRoots) do
            if root == nil then continue end
            for _, obj in pairs(root:GetDescendants()) do
                if obj:IsA("Animation") then
                    table.insert(found, obj.Name .. " | " .. obj.AnimationId)
                end
            end
        end
        if #found > 0 then
            Notify("🔍 Daftar Animasi Tersedia:", table.concat(found, ", "):sub(1, 200))
        else
            Notify("❌ Tidak Ada Animasi", "Evade tidak nyimpen animasi di client. Coba nama emote lain.")
        end
        return
    end
    
    -- MAIN: Play animasi yang ketemu
    local ok, err = pcall(function()
        for _, track in pairs(animator:GetPlayingAnimationTracks()) do
            track:Stop()
        end
        local track = animator:LoadAnimation(targetAnimation)
        track:Play()
    end)
    
    if ok then
        Notify("✅ Emote Berhasil!", "'" .. emoteName .. "' sedang dimainkan via Animation Bypass!")
    else
        Notify("❌ Error", tostring(err):sub(1, 100))
    end
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
