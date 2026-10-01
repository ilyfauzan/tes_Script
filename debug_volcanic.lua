-- Script Debug Koordinat Roblox
-- Buka F9 (Developer Console) di Roblox untuk melihat outputnya!

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function getPos()
    if LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local pos = LocalPlayer.Character.HumanoidRootPart.Position
        local posStr = string.format("Vector3.new(%.1f, %.1f, %.1f)", pos.X, pos.Y, pos.Z)
        
        -- Print ke F9 Developer Console
        print("========================================")
        print("📍 KOORDINAT KAMU SAAT INI:")
        print(posStr)
        print("X:", pos.X, "Y:", pos.Y, "Z:", pos.Z)
        print("========================================")
        
        -- Copy ke Clipboard (jika executor mendukung setclipboard)
        if setclipboard then
            setclipboard(posStr)
            print("✅ Koordinat sudah tersimpan di Clipboard (paste dengan Ctrl+V)!")
        end
        return posStr
    else
        warn("❌ Karakter belum loaded!")
        return nil
    end
end

-- Jalankan sekali saat di-execute
getPos()
