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

local selectedEggIndex = 1
local eggDropdown = nil

MainTab:CreateButton({
   Name = "🔍 1. Lacak Posisi Telur Special (100B - 2.5T)",
   Callback = function()
       local eggs = ScanSpecialEggs()
       if #eggs > 0 then
           local options = {}
           for i, eggData in ipairs(eggs) do
               table.insert(options, tostring(i) .. ". " .. eggData.Name)
           end
           
           if eggDropdown then
               eggDropdown:Refresh(options, true)
           end
           
           Rayfield:Notify({
               Title = "🎯 BERHASIL MELACAK!",
               Content = "Ditemukan " .. tostring(#eggs) .. " Telur Special!",
               Duration = 4,
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

eggDropdown = MainTab:CreateDropdown({
   Name = "📌 2. Pilih Telur Target",
   Options = {"Belum ada telur dilacak"},
   CurrentOption = {"Belum ada telur dilacak"},
   MultipleOptions = false,
   Flag = "SelectedEggDropdown",
   Callback = function(Option)
       local selectedText = type(Option) == "table" and Option[1] or Option
       local idxStr = selectedText:match("^(%d+)%.")
       if idxStr then
           selectedEggIndex = tonumber(idxStr)
       end
   end,
})

MainTab:CreateButton({
   Name = "🚀 3. Teleport & Diam di Lokasi Telur",
   Callback = function()
       local player = game.Players.LocalPlayer
       local character = player.Character or player.CharacterAdded:Wait()
       local hrp = character:FindFirstChild("HumanoidRootPart")

       if not hrp then return end

       if #detectedEggsList == 0 then
           ScanSpecialEggs()
       end

       if #detectedEggsList > 0 then
           local target = detectedEggsList[selectedEggIndex] or detectedEggsList[1]
           if target and target.CFrame then
               hrp.CFrame = target.CFrame + Vector3.new(0, 3, 0)
               
               Rayfield:Notify({
                   Title = "🚀 Berhasil Teleport!",
                   Content = "Anda sekarang berada di posisi " .. target.Name .. "!",
                   Duration = 4,
               })
           end
       else
           Rayfield:Notify({
               Title = "⚠️ Gagal Teleport",
               Content = "Klik 'Lacak Posisi Telur' dulu saat telur spawn!",
               Duration = 4,
           })
       end
   end,
})

Rayfield:LoadConfiguration()

