-- ============================================================
--  FishIt Server Notifier - Final Custom Embed (Container Style)
--  Hanya memproses channel RBXGeneral (server) untuk ikan secret
--  Warna samping biru, dengan field-field seperti container
-- ============================================================

local WEBHOOK_URL = "https://discord.com/api/webhooks/1453111179546460412/vpgKcPCofqrGgIV5Ox_3jgJOtcc8Trsw3l2pdMSCf3VlApciOph-tJ2YoNasqWSqeBE6"
local MIN_RARITY  = 250000  -- Secret (1 in 250K)
local EMBED_COLOR = 3447003 -- Biru (0x3498db)

local HttpService = game:GetService("HttpService")
local TextChatService = game:GetService("TextChatService")

-- ─── UTILS ───────────────────────────────────────────────────

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

-- ─── PARSER ──────────────────────────────────────────────────

local function parseFishMessage(rawText)
    if not rawText then return nil end

    local text = trim(stripHtml(rawText))

    -- Harus diawali [Server]:
    if not text:match("^%[Server%]%s*:") then return nil end
    if not text:find("obtained") then return nil end
    if not text:find("1 in") then return nil end

    local username = text:match("%[Server%]%s*:%s*(%S+)%s+obtained")
    if not username then return nil end

    local rarityRaw = text:match("1 in ([%d%.]+[km]?)") or text:match("1 in ([%d%.]+)")
    if not rarityRaw then return nil end
    rarityRaw = rarityRaw:lower()

    local rarityNum = parseRarityNumber(rarityRaw)
    if rarityNum < MIN_RARITY then return nil end

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
        username   = username,
        fish_name  = fishName,
        mutation   = mutation,
        weight     = weight,
        rarity_num = rarityNum
    }
end

-- ─── KIRIM WEBHOOK DENGAN EMBED CUSTOM (Container Style) ───────

local sentCache = {}

local function sendWebhook(data)
    local key = data.username .. "|" .. data.fish_name
    if sentCache[key] then return end
    sentCache[key] = true
    task.delay(30, function() sentCache[key] = nil end)

    -- Field-field dengan nama kosong agar tampak seperti baris dalam container
    local fields = {
        { name = "", value = "", inline = false },  -- pembatas atas (lebih tebal)
        { name = "", value = "@" .. data.username .. " You have obtained a new **SECRET** fish!", inline = false },
        { name = "", value = "", inline = false },
        { name = "", value = "Fish name\n> " .. data.fish_name, inline = false },
        { name = "", value = "Fish tier\n> Secret", inline = false },  -- hanya secret
        { name = "", value = "Weight\n> " .. data.weight .. " kg", inline = false },
        { name = "", value = "Mutation\n> " .. data.mutation, inline = false },
        { name = "", value = "", inline = false },
    }

    local embed = {
        title  = "VECHNOST - WEBHOOK",
        color  = EMBED_COLOR,
        fields = fields,
        footer = { text = "Notification by **Vechnost Community**" },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }

    local payload = HttpService:JSONEncode({ embeds = { embed } })

    local success, response = pcall(function()
        return HttpService:RequestAsync({
            Url = WEBHOOK_URL,
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

-- ─── HOOK ─────────────────────────────────────────────────────

local function setupHook()
    TextChatService.OnIncomingMessage = function(message)
        if not message or not message.Text then return nil end

        local channel = message.TextChannel
        if not channel or channel.Name ~= "RBXGeneral" then
            return nil
        end

        local data = parseFishMessage(message.Text)
        if data then
            sendWebhook(data)
        end

        return nil
    end
end

-- ─── START ───────────────────────────────────────────────────

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("  FishIt Server Notifier ACTIVE")
print("  Channel: RBXGeneral (server only)")
print("  Min Rarity: 1 in 250K (secret)")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

local ok, err = pcall(setupHook)
if ok then
    print("[FishIt] ✅ Hook berhasil dipasang! Menunggu ikan secret...")
    local startupMsg = ""
    pcall(function()
        HttpService:RequestAsync({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode({ content = startupMsg })
        })
    end)
else
    warn("[FishIt] ❌ Gagal memasang hook: " .. tostring(err))
end
