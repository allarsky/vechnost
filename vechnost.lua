-- FishIt Server Notifier with Key System
local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/saveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/interfaceManager.lua"))()

if not Fluent then
    warn("Gagal memuat Fluent library.")
    return
end

local Options = {}
local NotifierActive = false
local MessageConnection = nil
local HttpService = game:GetService("HttpService")
local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")

-- ========== FUNGSI HELPER ========== 

local function getTierAndColor(num)
    if num < 1000 then return "Common", 9807270
    elseif num < 5000 then return "Uncommon", 6694581
    elseif num < 25000 then return "Rare", 5814783
    elseif num < 100000 then return "Epic", 10181046
    elseif num < 250000 then return "Legendary", 15105570
    elseif num < 500000 then return "Mythic", 15158332
    else return "Secret", 3066993 end
end

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

local function stripHtml(text)
    return (text:gsub("<[^>]+", "")
end

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

-- ========== WEBHOOK FUNCTION ========== 

local function sendWebhook(webhookUrl, playerName, fishData, tier, rarity, color)
    if not webhookUrl or webhookUrl == "" then return end
    
    local success, err = pcall(function()
        HttpService:PostAsync(
            webhookUrl,
            HttpService:JSONEncode({
                content = "@here",
                embeds = {{
                    title = "🐟 Fish It - Ikan Langka Tertangkap!",
                    description = fishData,
                    color = color,
                    fields = {
                        {name = "👤 Player", value = playerName, inline = true},
                        {name = "⭐ Rarity", value = tier, inline = true},
                        {name = "🎲 Odds", value = "1 in " .. rarity, inline = true},
                        {name = "⏰ Waktu", value = os.date("%Y-%m-%d %H:%M:%S"), inline = true}
                    },
                    footer = {
                        text = "VECHNOST | Fish Notifier v1.0"
                    }
                }}
            }),
            Enum.HttpContentType.ApplicationJson
        )
    end)
    
    if not success then
        warn("❌ Webhook Error: " .. tostring(err))
    end
end

-- ========== NOTIFIER CORE ========== 

local function startNotifier(webhookUrl, minRarity)
    if NotifierActive then 
        Fluent:Notify({Title = "⚠️ Info", Content = "Notifier sudah aktif!"})
        return 
    end
    
    NotifierActive = true
    
    if MessageConnection then
        MessageConnection:Disconnect()
    end
    
    -- Wait untuk TextChatService siap
    local generalChannel
    pcall(function()
        generalChannel = TextChatService:WaitForChild("TextChannels"):WaitForChild("RBXGeneral")
    end)
    
    if not generalChannel then
        Fluent:Notify({Title = "❌ Error", Content = "RBXGeneral channel tidak ditemukan!"})
        NotifierActive = false
        return
    end
    
    -- Connect ke MessageReceived
    MessageConnection = generalChannel.MessageReceived:Connect(function(message)
        local rawText = message.Text
        if not rawText or not rawText:find("obtained") then return end
        
        local cleanText = stripHtml(rawText)
        local rarityRaw = cleanText:match("1 in ([%d%.]+[km]?)")
        if not rarityRaw then return end
        
        local rarityNum = parseRarityNumber(rarityRaw)
        if rarityNum >= minRarity then
            local tier, color = getTierAndColor(rarityNum)
            local playerName = message.PrefixText and message.PrefixText:gsub("<[^>]+>", "") or "Unknown"
            
            sendWebhook(webhookUrl, playerName, cleanText, tier, rarityRaw, color)
            
            Fluent:Notify({
                Title = "🎣 Ikan Terdeteksi!",
                Content = playerName .. " - " .. tier,
                Duration = 3
            })
        end
    end)
    
    Fluent:Notify({
        Title = "✅ Notifier Aktif",
        Content = "Memantau ikan di atas Rarity: " .. minRarity,
        Duration = 5
    })
end

local function stopNotifier()
    if MessageConnection then
        MessageConnection:Disconnect()
        MessageConnection = nil
    end
    NotifierActive = false
    Fluent:Notify({Title = "⏹️ Notifier Stopped", Content = "Notifier telah dihentikan"})
end

-- ========== MAIN GUI FUNCTION ========== 

local function showMainGUI()
    local Window = Fluent:CreateWindow({
        Title = "VECHNOST | SERVER WEBHOOK",
        SubTitle = "Pengaturan Notifikasi Ikan",
        TabWidth = 160,
        Size = UDim2.fromOffset(600, 500),
        Theme = "Dark"
    })

    local MainTab = Window:AddTab({Title = "⚙️ Pengaturan", Icon = "settings"})

    MainTab:AddParagraph({
        Title = "📌 Informasi",
        Content = "Masukkan Webhook URL Discord dan pilih tier minimum untuk menerima notifikasi ikan langka dari pemain lain."
    })

    MainTab:AddInput("WebhookURL", {
        Title = "🔗 Webhook URL Discord",
        Default = "",
        Placeholder = "https://discord.com/api/webhooks/...",
        Callback = function(Value) Options.Webhook = Value end
    })

    MainTab:AddDropdown("TierSelect", {
        Title = "⭐ Tier Minimum Fish",
        Values = {"common", "uncommon", "rare", "epic", "legendary", "mythic", "secret"},
        Default = "secret",
        Callback = function(Value) Options.Tier = Value end
    })

    MainTab:AddDivider()

    MainTab:AddButton({
        Title = "▶️ Start Notifier",
        Callback = function()
            local url = Options.Webhook or ""
            if url == "" then
                Fluent:Notify({Title = "❌ Error", Content = "Isi Webhook URL terlebih dahulu!"})
                return
            end
            startNotifier(url, getMinRarityFromTier(Options.Tier or "secret"))
        end
    })

    MainTab:AddButton({
        Title = "⏹️ Stop Notifier",
        Callback = function()
            stopNotifier()
        end
    })

    local InfoTab = Window:AddTab({Title = "ℹ️ Panduan", Icon = "info"})
    
    InfoTab:AddParagraph({
        Title = "📖 Cara Mendapatkan Webhook URL",
        Content = "1. Buka Discord Server Anda\n2. Klik Settings di sebelah nama server\n3. Buka menu Webhooks atau Integrasi\n4. Klik 'Buat Webhook' atau 'New Webhook'\n5. Beri nama (contoh: Fish Notifier)\n6. Pilih channel tujuan\n7. Klik 'Copy Webhook URL'\n8. Paste di sini"
    })

    InfoTab:AddParagraph({
        Title = "❓ Bagaimana Cara Kerjanya?",
        Content = "Script ini mendengarkan chat server Fish It dan mengirim notifikasi ke Discord ketika ada pemain yang menangkap ikan dengan rarity di atas tier yang Anda pilih."
    })

    InfoTab:AddParagraph({
        Title = "⚠️ Catatan Penting",
        Content = "- Script hanya bekerja di game Fish It\n- Webhook URL harus valid\n- Script mendengarkan channel RBXGeneral\n- Status notifier akan ditampilkan di notifikasi Roblox"
    })
end

-- ========== KEY SYSTEM WINDOW ========== 

local function startKeySystem()
    local KeyWindow = Fluent:CreateWindow({
        Title = "VECHNOST | KEY SYSTEM",
        Size = UDim2.fromOffset(450, 280),
        Theme = "Dark"
    })

    local KeyTab = KeyWindow:AddTab({Title = "🔑 Verifikasi", Icon = "key"})
    
    KeyTab:AddParagraph({
        Title = "Verifikasi Key",
        Content = "Masukkan key yang valid untuk mengakses Fish Notifier"
    })

    local KeyInput = KeyTab:AddInput("KeyInp", {
        Title = "Masukkan Key",
        Default = "",
        Placeholder = "Contoh: vechnost123"
    })

    KeyTab:AddDivider()

    KeyTab:AddButton({
        Title = "✓ Verifikasi Key",
        Callback = function()
            if KeyInput.Value == "vechnost123" or KeyInput.Value == "testkey" then
                Fluent:Notify({Title = "✅ Berhasil!", Content = "Key valid! Membuka GUI utama..."})
                task.wait(0.5)
                KeyWindow:Destroy()
                showMainGUI()
            else
                Fluent:Notify({Title = "❌ Gagal", Content = "Key yang Anda masukkan salah!", Duration = 3})
            end
        end
    })

    KeyTab:AddParagraph({
        Title = "💡 Butuh Key?",
        Content = "Hubungi developer untuk mendapatkan key akses."
    })
end

-- ========== START ========== 

startKeySystem()