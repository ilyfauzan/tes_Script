-- Jalankan saat berdiri di lokasi Volcanic Egg!
local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
if hrp then
    local pos = hrp.Position
    print(string.format("VOLCANIC POS: X=%.2f, Y=%.2f, Z=%.2f", pos.X, pos.Y, pos.Z))
    
    -- Tampilkan juga di layar
    local gui = Instance.new("ScreenGui")
    gui.Name = "PosDebug"
    gui.ResetOnSpawn = false
    gui.Parent = game.Players.LocalPlayer.PlayerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 320, 0, 60)
    frame.Position = UDim2.new(0.5, -160, 0, 80)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    frame.BorderSizePixel = 0
    frame.Parent = gui
    
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = string.format("📍 X:%.1f  Y:%.1f  Z:%.1f", pos.X, pos.Y, pos.Z)
    label.TextColor3 = Color3.fromRGB(255, 220, 100)
    label.TextSize = 16
    label.Font = Enum.Font.GothamBold
    label.Parent = frame
    
    task.delay(15, function() gui:Destroy() end)
end
