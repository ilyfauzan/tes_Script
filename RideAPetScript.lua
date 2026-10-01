local repo = "https://raw.githubusercontent.com/ilyfauzan/tes_Script/main/"
local function import(file)
    return loadstring(game:HttpGet(repo .. file .. ".lua?t=" .. tostring(tick())))()
end
if not getgenv().Wayae then
    getgenv().Wayae = {
        detectedEggsList = {},
        selectedEggIndex = 1,
        player = game.Players.LocalPlayer,
        UI = {}
    }
end
import("Wayae_UI_v3")
import("Wayae_Scanner_v3")
import("Wayae_Actions_v3")
if getgenv().Wayae and getgenv().Wayae.UI and getgenv().Wayae.UI.Notify then
    getgenv().Wayae.UI.Notify("✅ Loaded!", "WayaeHUB berhasil dimuat dari modul terpisah!", 3)
end
