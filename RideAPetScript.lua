local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "WayaeHUB",
   LoadingTitle = "Memuat WayaeHUB Simple...",
   LoadingSubtitle = "by Antigravity",
   ConfigurationSaving = {
      Enabled = false
   },
   Discord = {
      Enabled = false
   },
   KeySystem = false
})

local MainTab = Window:CreateTab("Special Egg Hunter", 4483362458)

local detectedEggsList = {}

local function ScanSpecialEggs()
    detectedEggsList = {}
    
    local eggFolder = workspace:FindFirstChild("Eggs") 
        or workspace:FindFirstChild("EggSpawns") 
        or workspace:FindFirstChild("Collectibles") 
        or workspace:FindFirstChild("Map") 
        or workspace

    for _, obj in pairs(eggFolder:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("BasePart") then
            local nameLower = obj.Name:lower()
            
            local isSpecial = nameLower:find("100b") 
                or nameLower:find("300b") 
                or nameLower:find("1t") 
                or nameLower:find("2.5t")

            if not isSpecial then
                for _, child in pairs(obj:GetDescendants()) do
                    if child:IsA("TextLabel") or child:IsA("StringValue") then
                        local valText = (child:IsA("TextLabel") and child.Text or tostring(child.Value)):lower()
                        if valText:find("100b") or valText:find("300b") or valText:find("1t") or valText:find("2.5t") then
                            isSpecial = true
                            break
                        end
                    end
                end
            end

            if isSpecial then
                local eggCFrame = obj:IsA("Model") and obj:GetPivot() or obj.CFrame
                table.insert(detectedEggsList, {
                    Name = obj.Name,
                    Instance = obj,
                    CFrame = eggCFrame
                })
            end
        end
    end

    return detectedEggsList
end

MainTab:CreateButton({
   Name = "🔍 1. Lacak Posisi Telur Special (100B - 2.5T)",
   Callback = function()
       local eggs = ScanSpecialEggs()
       if #eggs > 0 then
           local listText = ""
           for i, eggData in ipairs(eggs) do
               listText = listText .. tostring(i) .. ". " .. eggData.Name .. " | "
           end
           
           Rayfield:Notify({
               Title = "🎯 BERHASIL MELACAK!",
               Content = "Ditemukan " .. tostring(#eggs) .. " Telur: " .. listText,
               Duration = 6,
           })
       else
           Rayfield:Notify({
               Title = "❌ Tidak Ada Telur Special",
               Content = "Telur 100B/300B/1T/2.5T belum spawn di map saat ini.",
               Duration = 4,
           })
       end
   end,
})

MainTab:CreateButton({
   Name = "🚀 2. Teleport ke Telur Hasil Lacak",
   Callback = function()
       local player = game.Players.LocalPlayer
       local character = player.Character or player.CharacterAdded:Wait()
       local hrp = character:FindFirstChild("HumanoidRootPart")

       if not hrp then return end

       if #detectedEggsList == 0 then
           ScanSpecialEggs()
       end

       if #detectedEggsList > 0 then
           local target = detectedEggsList[1]
           hrp.CFrame = target.CFrame
           
           Rayfield:Notify({
               Title = "🚀 Teleport Berhasil!",
               Content = "Teleport ke lokasi: " .. target.Name,
               Duration = 4,
           })
       else
           Rayfield:Notify({
               Title = "⚠️ Gagal Teleport",
               Content = "Lacak telur terlebih dahulu atau tunggu telur spawn!",
               Duration = 4,
           })
       end
   end,
})

Rayfield:LoadConfiguration()
