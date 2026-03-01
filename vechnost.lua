-- Vechnost FishIt Notifier - GUI Version
-- Loadstring: loadstring(game:HttpGet("https://raw.githubusercontent.com/username/repo/main/VechnostFishIt.lua"))()

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/SaveManager.lua"))()

local Window = Library:CreateWindow({
    Title = "Vechnost | Beta script",
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

-- Tabs (sidebar) - hanya Info dan Webhook
local Tabs = {
    Info = Window:AddTab("Info"),
    Webhook = Window:AddTab("Webhook")
}

-- Options
local Options = {
    WebhookURL = "",
    Tier = "Secret",
    Enabled = false,
    MinRarity = 250000
}

-- Tier mapping
local TierThresholds = {
    Common = 0,
    Uncommon = 1000,
    Rare = 5000,
    Legendary = 10000,
    Epic = 50000,
    Mythic = 100000,
    Secret = 250000
}

local function updateMinRarity(tier)
    Options.MinRarity = TierThresholds[tier] or 250000
end

-- ========== INFO TAB ==========
local InfoGroup = Tabs.Info:AddLeftGroupbox("Vechnost Information")

InfoGroup:AddLabel("Vechnost | FishIt Notifier")
InfoGroup:AddLabel("Version: Beta")
InfoGroup:AddLabel("─────────────────────────")
InfoGroup:AddLabel("⚠️ Vechnost Alert!")
InfoGroup:AddLabel("Skrip masih dalam pengembangan.")
InfoGroup:AddLabel("Use at your own risk!")
InfoGroup:AddLabel("─────────────────────────")

InfoGroup:AddButton({
    Text = "📋 Copy Discord Community Link",
    Func = function()
        setclipboard("https://discord.gg/pFhdW9ZwwY")
        Library:Notify("✅ Link Discord disalin ke clipboard!", 3)
    end
})

-- ========== WEBHOOK TAB ==========
local WebhookGroup = Tabs.Webhook:AddLeftGroupbox("Webhook Settings")

WebhookGroup:AddLabel("Discord Webhook URL")
local WebhookInput = WebhookGroup:AddInput("WebhookURL", {
    Default = "",
    Placeholder = "https://discord.com/api/webhooks/...",
    Text = "",
    Numeric = false,
    Finished = false
})
WebhookInput:AddCallback(function(value)
    Options.WebhookURL = value
end)

WebhookGroup:AddLabel("Tier Filter (Min Rarity)")
local TierDropdown = WebhookGroup:AddDropdown("Tier", {
    Values = { "Common", "Uncommon", "Rare", "Legendary", "Epic", "Mythic", "Secret" },
    Default = 7,
    Multi = false
})
TierDropdown:AddCallback(function(value)
    Options.Tier = value
    updateMinRarity(value)
end)

WebhookGroup:AddLabel("─────────────────────────")
WebhookGroup:AddLabel("Send Fish Webhook Notification")
local EnableToggle = WebhookGroup:AddToggle("Enabled", { Text = "Enable Notifier", Default = false })
EnableToggle:AddCallback(function(value)
    Options.Enabled = value
    if value then
        startNotifier()
    else
        stopNotifier()
    end
end)

WebhookGroup:AddLabel("─────────────────────────")
WebhookGroup:AddButton({
    Text = "🔗 TEST WEBHOOK CONNECTION",
    Func = function()
        if Options.WebhookURL == "" then
            Library:Notify("❌ Masukkan webhook URL terlebih dahulu!", 3)
            return
        end
        testWebhook(Options.WebhookURL)
    end
})

-- ========== NOTIFIER LOGIC ==========
local HttpService = game:GetService("HttpService")
local TextChatService = game:GetService("TextChatService")
local isRunning = false

local function stripHtml(text)
    if not text then return "" end
    return (text:gsub("<[^>]+>", ""))
end

local function trim(s)
    return s and s:match("^%s*(.-)%s*$") or ""
end

local function parseRarityNumber(str)
    if not str then return 0 end
    str = str:lower():gsub(",", ""):gsub(" ", "")
    local numStr, suffix = str:match("^([%d%.]+)([km]?)$")
    if not numStr then return 0 end
    local num = tonumber(numStr) or 0
    if suffix == "k" then
        num = num * 1000
    elseif suffix == "m" then
        num = num * 1000000
    end
    return math.floor(num)
end

local function extractWeight(text)
    for match in text:gmatch("%(([^%)]+)%)") do
        if match:lower():find("kg") then
            local numStr = match:match("^([%d%.]+[km]?)")
            if numStr then
                return numStr
            end
        end
    end
    return "?"
end

local function parseFishMessage(rawText)
    if not rawText then return nil end
    local text = trim(stripHtml(rawText))
    if not text:match("^%[Server%]%s*:") then return nil end
    if not text:find("obtained") then return nil end
    if not text:find("1 in") then return nil end

    local username = text:match("%[Server%]%s*:%s*(%S+)%s+obtained")
    if not username then return nil end

    local rarityRaw = text:match("1 in ([%d%.]+[km]?)") or text:match("1 in ([%d%.]+)")
    if not rarityRaw then return nil end
    rarityRaw = rarityRaw:lower()
    local rarityNum = parseRarityNumber(rarityRaw)

    if rarityNum < Options.MinRarity then return nil end

    local weight = extractWeight(text)
    local middle = text:match("obtained a[n]?%s+(.-)%s+with a 1 in")
    if not middle then
        middle = text:match("obtained a[n]?%s+(.-)$")
    end
    if not middle then return nil end
    middle = trim(middle)

    local fishNameOnly = middle:gsub("%s*%([^%)]*%)", ""):gsub("^%s+", ""):gsub("%s+$", "")
    local mutation = "None"
    local fishName = fishNameOnly
    local firstWord, rest = fishNameOnly:match("^([A-Z][A-Z]+)%s+(.+)$")
    if firstWord and #firstWord >= 2 and rest then
        mutation = firstWord
        fishName = trim(rest)
    end

    return {
        username = username,
        fish_name = fishName,
        mutation = mutation,
        weight = weight,
        rarity_num = rarityNum,
        rarity_str = rarityRaw:gsub("k", "K"):gsub("m", "M")
    }
end

local sentCache = {}
local function sendWebhook(data)
    local key = data.username .. "|" .. data.fish_name
    if sentCache[key] then return end
    sentCache[key] = true
    task.delay(30, function() sentCache[key] = nil end)

    local embed = {
        title = "🎣 VECHNOST - FISH NOTIFIER",
        color = 3447003,
        fields = {
            { name = "", value = "━━━━━━━━━━━━━━━━━━━━", inline = false },
            { name = "", value = "**@" .. data.username .. "** obtained a new **" .. Options.Tier:upper() .. "** fish!", inline = false },
            { name = "", value = "━━━━━━━━━━━━━━━━━━━━", inline = false },
            { name = "🐟 Fish Name", value = "> " .. data.fish_name, inline = true },
            { name = "⭐ Fish Tier", value = "> " .. Options.Tier, inline = true },
            { name = "⚖️ Weight", value = "> " .. data.weight .. " kg", inline = true },
            { name = "✨ Mutation", value = "> " .. data.mutation, inline = true },
            { name = "🎲 Rarity", value = "> 1 in " .. data.rarity_str, inline = true },
            { name = "", value = "━━━━━━━━━━━━━━━━━━━━", inline = false }
        },
        footer = { text = "Notification by Vechnost Community" },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }

    local payload = HttpService:JSONEncode({ embeds = { embed } })
    local success, response = pcall(function()
        return HttpService:RequestAsync({
            Url = Options.WebhookURL,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = payload
        })
    end)

    if success and response.Success then
        Library:Notify("✅ Notifikasi terkirim: " .. data.username, 3)
    else
        warn("[Vechnost] Gagal kirim webhook")
        Library:Notify("❌ Gagal kirim webhook!", 3)
    end
end

local function onMessage(message)
    if not Options.Enabled then return nil end
    if not message or not message.Text then return nil end
    local channel = message.TextChannel
    if not channel or channel.Name ~= "RBXGeneral" then return nil end
    local data = parseFishMessage(message.Text)
    if data then
        sendWebhook(data)
    end
    return nil
end

function startNotifier()
    if isRunning then return end
    if Options.WebhookURL == "" then
        Library:Notify("❌ Webhook URL belum diisi!", 3)
        Options.Enabled = false
        EnableToggle:SetValue(false)
        return
    end
    isRunning = true
    TextChatService.OnIncomingMessage = onMessage
    Library:Notify("✅ Notifier aktif! Memantau RBXGeneral...", 3)
end

function stopNotifier()
    if not isRunning then return end
    isRunning = false
    TextChatService.OnIncomingMessage = nil
    Library:Notify("🛑 Notifier dihentikan.", 3)
end

function testWebhook(url)
    local testEmbed = {
        title = "🔗 Vechnost - Test Connection",
        color = 65280,
        description = "✅ Webhook berhasil terhubung!\nNotifier siap digunakan.",
        footer = { text = "Vechnost FishIt Notifier" },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }
    local payload = HttpService:JSONEncode({ embeds = { testEmbed } })
    local success, response = pcall(function()
        return HttpService:RequestAsync({
            Url = url,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = payload
        })
    end)
    if success and response.Success then
        Library:Notify("✅ Test berhasil! Cek Discord kamu.", 3)
    else
        Library:Notify("❌ Test gagal. Periksa URL webhook.", 3)
    end
end

-- ========== THEME & SAVE MANAGER ==========
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetFolder("VechnostFishIt")
SaveManager:BuildConfigSection(Tabs.Webhook)
ThemeManager:ApplyToTab(Tabs.Info)

SaveManager:Load()
updateMinRarity(Options.Tier)

Library:Notify("🎣 Vechnost FishIt loaded! Atur webhook di tab Webhook.", 5)
