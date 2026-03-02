-- FishIt Server Notifier with Key System
-- Load library Fluent dengan URL yang benar (branch master)
local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/saveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/interfaceManager.lua"))()

-- Jika gagal memuat Fluent, beri pesan error
if not Fluent then
    warn("Gagal memuat Fluent library. Periksa koneksi internet atau URL.")
    return
end

-- ========== KEY VALIDATION ==========
local validKeys = {"vechnost123", "testkey"}  -- Ganti dengan key yang diinginkan
local function validateKey(input)
    for _, k in ipairs(validKeys) do
        if k == input then return true end
    end
    return false
end

-- ========== KEY WINDOW ==========
local KeyWindow = Fluent:CreateWindow({
    Title = "VECHNOST | KEY SYSTEM",
    SubTitle = "Masukkan key untuk melanjutkan",
    TabWidth = 160,
    Size = UDim2.fromOffset(400, 200),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local KeyTab = KeyWindow:AddTab({ Title = "Key", Icon = "key" })

local KeyInput = KeyTab:AddInput({
    Title = "Key",
    Default = "",
    Placeholder = "Masukkan key...",
    Numeric = false,
    Finished = false,
})

KeyTab:AddButton({
    Title = "Submit",
    Callback = function()
        if validateKey(KeyInput.Value) then
            KeyWindow:Destroy()
            showMainGUI()
        else
            Fluent:Notify({ Title = "Error", Content = "Key salah!", Duration = 3 })
        end
    end
})

-- ========== MAIN GUI ==========
function showMainGUI()
    local Window = Fluent:CreateWindow({
        Title = "VECHNOST | SERVER WEBHOOK",
        SubTitle = "Pengaturan Notifikasi Ikan",
        TabWidth = 160,
        Size = UDim2.fromOffset(500, 400),
        Acrylic = false,
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.LeftControl
    })

    local Tabs = {
        Main = Window:AddTab({ Title = "Pengaturan", Icon = "settings" })
    }

    local Options = {}

    -- Input Webhook URL
    Tabs.Main:AddParagraph({ Title = "Discord Webhook URL", Content = "Masukkan URL webhook untuk notifikasi" })
    local WebhookInput = Tabs.Main:AddInput({
        Title = "Webhook URL",
        Default = "",
        Placeholder = "https://discord.com/api/webhooks/...",
        Numeric = false,
        Finished = true,
        Callback = function(value)
            Options.Webhook = value
        end
    })

    -- Dropdown Tier
    local tierOptions = {
        { value = "common", label = "Common (< 1K)" },
        { value = "uncommon", label = "Uncommon (1K - 5K)" },
        { value = "rare", label = "Rare (5K - 25K)" },
        { value = "epic", label = "Epic (25K - 100K)" },
        { value = "legendary", label = "Legendary (100K - 250K)" },
        { value = "mythic", label = "Mythic (250K - 500K)" },
        { value = "secret", label = "Secret (≥ 500K)" }
    }
    local TierDropdown = Tabs.Main:AddDropdown({
        Title = "Tier Fish",
        Values = tierOptions,
        Default = "secret",
        Multi = false,
        Callback = function(selected)
            Options.Tier = selected
        end
    })

    -- Tombol Start
    Tabs.Main:AddButton({
        Title = "Start Notifier",
        Callback = function()
            local webhook = Options.Webhook or WebhookInput.Value
            if not webhook or webhook == "" then
                Fluent:Notify({ Title = "Error", Content = "Webhook harus diisi!", Duration = 5 })
                return
            end
            local tier = Options.Tier or "secret"
            local minRarity = getMinRarityFromTier(tier)
            startNotifier(webhook, minRarity)
            Fluent:Notify({ Title = "Sukses", Content = "Notifier dimulai!", Duration = 5 })
            Window:Minimize()
        end
    })

    function getMinRarityFromTier(tier)
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
end

-- ========== NOTIFIER CORE ==========
function startNotifier(webhookUrl, minRarity)
    local HttpService = game:GetService("HttpService")
    local TextChatService = game:GetService("TextChatService")
    local EMBED_COLOR = 3447003

    -- Utility functions
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
                if numStr then return numStr end
            end
        end
        return "?"
    end

    -- Parser with dynamic minRarity
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
        if rarityNum < minRarity then return nil end

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
            rarity_num = rarityNum
        }
    end

    -- Send webhook
    local sentCache = {}
    local function sendWebhook(data)
        local key = data.username .. "|" .. data.fish_name
        if sentCache[key] then return end
        sentCache[key] = true
        task.delay(30, function() sentCache[key] = nil end)

        local fields = {
            { name = "", value = "━━━━━━━━━━━━━━━━━━━━", inline = false },
            { name = "", value = "@" .. data.username .. " You have obtained a new **SECRET** fish!", inline = false },
            { name = "", value = "━━━━━━━━━━━━━━━━━━━━", inline = false },
            { name = "", value = "Fish name\n> " .. data.fish_name, inline = false },
            { name = "", value = "Fish tier\n> " .. getTierFromRarity(data.rarity_num), inline = false },
            { name = "", value = "Weight\n> " .. data.weight .. " kg", inline = false },
            { name = "", value = "Mutation\n> " .. data.mutation, inline = false },
            { name = "", value = "━━━━━━━━━━━━━━━━━━━━", inline = false },
        }

        local embed = {
            title = "VECHNOST - WEBHOOK",
            color = EMBED_COLOR,
            fields = fields,
            footer = { text = "Notification by **Vechnost Community**" },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }

        local payload = HttpService:JSONEncode({ embeds = { embed } })

        local success, response = pcall(function()
            return HttpService:RequestAsync({
                Url = webhookUrl,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = payload
            })
        end)

        if success and response.Success then
            print("[FishIt] ✅ Terkirim: " .. data.username .. " - " .. data.fish_name)
        else
            warn("[FishIt] ❌ Gagal kirim. Status: " .. tostring(response and response.StatusCode or "unknown"))
        end
    end

    -- Helper to get tier label from rarity number
    function getTierFromRarity(num)
        if num < 1000 then return "Common"
        elseif num < 5000 then return "Uncommon"
        elseif num < 25000 then return "Rare"
        elseif num < 100000 then return "Epic"
        elseif num < 250000 then return "Legendary"
        elseif num < 500000 then return "Mythic"
        else return "Secret" end
    end

    -- Setup hook
    TextChatService.OnIncomingMessage = function(message)
        if not message or not message.Text then return nil end
        local channel = message.TextChannel
        if not channel or channel.Name ~= "RBXGeneral" then return nil end
        local data = parseFishMessage(message.Text)
        if data then
            sendWebhook(data)
        end
        return nil
    end

    print("[FishIt] Notifier aktif! Min Rarity: " .. minRarity)
    Fluent:Notify({ Title = "Notifier Aktif", Content = "Memantau channel RBXGeneral", Duration = 5 })
end
