-- FishIt Server Notifier with Key System
local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/saveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/interfaceManager.lua"))()

if not Fluent then
    warn("Gagal memuat Fluent library.")
    return
end

-- Tentukan variabel di awal agar bisa diakses secara global di dalam script
local Options = {}

-- ========== FUNGSI HELPER (Taruh di Atas) ==========

local function getMinRarityFromTier(tier)
    local tiers = {
        common = 0,
        uncommon = 1000,
        rare = 5000,
        epic = 25000,
        legendary = 100000,
        mythic = 250000,
        secret = 500000
    }
    return tiers[tier] or 250000
end

local function getTierFromRarity(num)
    if num < 1000 then return "Common"
    elseif num < 5000 then return "Uncommon"
    elseif num < 25000 then return "Rare"
    elseif num < 100000 then return "Epic"
    elseif num < 250000 then return "Legendary"
    elseif num < 500000 then return "Mythic"
    else return "Secret" end
end

-- ========== NOTIFIER CORE ==========
local function startNotifier(webhookUrl, minRarity)
    local HttpService = game:GetService("HttpService")
    local TextChatService = game:GetService("TextChatService")
    
    local function stripHtml(text) return (text:gsub("<[^>]+>", "")) end
    
    local function parseRarityNumber(str)
        if not str then return 0 end
        str = str:lower():gsub(",", ""):gsub(" ", "")
        local numStr, suffix = str:match("^([%d%.]+)([km]?)$")
        if not numStr then return 0 end
        local num = tonumber(numStr) or 0
        if suffix == "k" then num = num * 1000
        elseif suffix == "m" then num = num * 1000000 end
        return math.floor(num)
    end

    -- Hook Chat
    TextChatService.OnIncomingMessage = function(message)
        local rawText = message.Text
        if not rawText or not rawText:find("obtained") then return nil end
        
        local cleanText = stripHtml(rawText)
        local rarityRaw = cleanText:match("1 in ([%d%.]+[km]?)")
        if not rarityRaw then return nil end
        
        local rarityNum = parseRarityNumber(rarityRaw)
        if rarityNum >= minRarity then
            -- Logika pengiriman webhook di sini (sesuai script asli kamu)
            print("Ikan Langka Terdeteksi: " .. cleanText)
            -- (Tambahkan logic pcall RequestAsync kamu di sini agar lebih aman)
        end
        return nil
    end
    
    Fluent:Notify({ Title = "Notifier Aktif", Content = "Memantau ikan di atas " .. minRarity, Duration = 5 })
end

-- ========== MAIN GUI FUNCTION ==========
local function showMainGUI()
    local Window = Fluent:CreateWindow({
        Title = "VECHNOST | SERVER WEBHOOK",
        SubTitle = "Pengaturan Notifikasi Ikan",
        TabWidth = 160,
        Size = UDim2.fromOffset(500, 400),
        Theme = "Dark"
    })

    local MainTab = Window:AddTab({ Title = "Pengaturan", Icon = "settings" })

    local WebhookInput = MainTab:AddInput("WebhookURL", {
        Title = "Webhook URL",
        Default = "",
        Placeholder = "https://discord.com/api/webhooks/...",
        Callback = function(Value) Options.Webhook = Value end
    })

    local TierDropdown = MainTab:AddDropdown("TierSelect", {
        Title = "Tier Fish",
        Values = {"common", "uncommon", "rare", "epic", "legendary", "mythic", "secret"},
        Default = "secret",
        Callback = function(Value) Options.Tier = Value end
    })

    MainTab:AddButton({
        Title = "Start Notifier",
        Callback = function()
            local url = Options.Webhook or ""
            if url == "" then 
                Fluent:Notify({Title = "Error", Content = "Isi Webhook!"}) 
                return 
            end
            startNotifier(url, getMinRarityFromTier(Options.Tier or "secret"))
        end
    })
end

-- ========== KEY WINDOW (Jalankan Pertama) ==========
local function startKeySystem()
    local KeyWindow = Fluent:CreateWindow({
        Title = "VECHNOST | KEY SYSTEM",
        Size = UDim2.fromOffset(400, 220),
        Theme = "Dark"
    })

    local KeyTab = KeyWindow:AddTab({ Title = "Key", Icon = "key" })
    local KeyInput = KeyTab:AddInput("KeyInp", { Title = "Masukkan Key", Default = "" })

    KeyTab:AddButton({
        Title = "Submit",
        Callback = function()
            if KeyInput.Value == "vechnost123" or KeyInput.Value == "testkey" then
                KeyWindow:Destroy()
                showMainGUI()
            else
                Fluent:Notify({ Title = "Error", Content = "Key Salah!", Duration = 3 })
            end
        end
    })
end

startKeySystem()
