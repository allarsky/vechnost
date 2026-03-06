-- Vechnost Notifier
-- FILE: vechnost_webhook.lua
-- BRAND: Vechnost
-- VERSION: Beta
-- DESC: Webhook Notifier for Roblox "Fish It"
-- =====================================================
-- BAGIAN 0: AUTHENTICATION (WHITELIST) – HASHED VERSION
-- =====================================================

-- Pastikan bit32 tersedia (hampir semua executor modern mendukung)
if not bit32 then
    error("Vechnost Error: Executor tidak mendukung bit32. Gunakan executor lain (Synapse/Krnl/Delta).")
end

-- Implementasi SHA256 menggunakan bit32
local function sha256(msg)
    local bit = bit32
    local function ror(n, b)
        return bit.bor(bit.rshift(n, b), bit.lshift(n, 32 - b))
    end

    local H = {
        0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
        0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19
    }

    local K = {
        0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5,
        0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
        0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
        0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
        0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc,
        0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
        0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7,
        0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
        0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
        0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
        0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3,
        0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
        0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5,
        0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
        0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
        0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
    }

    local function preprocess(str)
        local bits = {}
        for i = 1, #str do
            local byte = string.byte(str, i)
            for j = 1, 8 do
                bits[#bits + 1] = bit.rshift(byte, 8 - j) & 1
            end
        end
        local len = #bits
        bits[#bits + 1] = 1
        while (#bits + 64) % 512 ~= 0 do
            bits[#bits + 1] = 0
        end
        for i = 1, 64 do
            bits[#bits + 1] = bit.rshift(len, 64 - i) & 1
        end
        return bits
    end

    local bits = preprocess(msg)
    for chunk_start = 1, #bits, 512 do
        local w = {}
        for i = 0, 15 do
            local num = 0
            for j = 1, 32 do
                num = bit.bor(bit.lshift(num, 1), bits[chunk_start + i * 32 + j - 1] or 0)
            end
            w[i] = num
        end
        for i = 16, 63 do
            local s0 = bit.bxor(bit.bxor(ror(w[i - 15], 7), ror(w[i - 15], 18)), bit.rshift(w[i - 15], 3))
            local s1 = bit.bxor(bit.bxor(ror(w[i - 2], 17), ror(w[i - 2], 19)), bit.rshift(w[i - 2], 10))
            w[i] = bit.band(w[i - 16] + s0 + w[i - 7] + s1, 0xFFFFFFFF)
        end

        local a, b, c, d, e, f, g, h = H[1], H[2], H[3], H[4], H[5], H[6], H[7], H[8]

        for i = 0, 63 do
            local S1 = bit.bxor(bit.bxor(ror(e, 6), ror(e, 11)), ror(e, 25))
            local ch = bit.bxor(bit.band(e, f), bit.band(bit.bnot(e), g))
            local temp1 = bit.band(h + S1 + ch + K[i + 1] + w[i], 0xFFFFFFFF)
            local S0 = bit.bxor(bit.bxor(ror(a, 2), ror(a, 13)), ror(a, 22))
            local maj = bit.bxor(bit.bxor(bit.band(a, b), bit.band(a, c)), bit.band(b, c))
            local temp2 = bit.band(S0 + maj, 0xFFFFFFFF)

            h, g, f, e, d, c, b, a = g, f, e, bit.band(d + temp1, 0xFFFFFFFF), c, b, a, bit.band(temp1 + temp2, 0xFFFFFFFF)
        end

        H[1] = bit.band(H[1] + a, 0xFFFFFFFF)
        H[2] = bit.band(H[2] + b, 0xFFFFFFFF)
        H[3] = bit.band(H[3] + c, 0xFFFFFFFF)
        H[4] = bit.band(H[4] + d, 0xFFFFFFFF)
        H[5] = bit.band(H[5] + e, 0xFFFFFFFF)
        H[6] = bit.band(H[6] + f, 0xFFFFFFFF)
        H[7] = bit.band(H[7] + g, 0xFFFFFFFF)
        H[8] = bit.band(H[8] + h, 0xFFFFFFFF)
    end

    local digest = ""
    for i = 1, 8 do
        digest = digest .. string.format("%08x", H[i])
    end
    return digest
end

local function CheckWhitelist()
    local success, whitelist = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/allarsky/vechnost/refs/heads/main/whitelist.lua"))()
    end)

    if not success or type(whitelist) ~= "table" then
        game.Players.LocalPlayer:Kick("Vechnost Error: Gagal memuat database Whitelist.")
        return false
    end

    local playerHash = sha256(tostring(game.Players.LocalPlayer.UserId))

    if not whitelist[playerHash] then
        game.Players.LocalPlayer:Kick("Vechnost Access: Akun kamu (ID: " .. game.Players.LocalPlayer.UserId .. ") belum terdaftar. Silahkan redeem key di discord.gg/vechnost")
        return false
    end
    return true
end

if not CheckWhitelist() then return end

-- =====================================================
-- LANJUTKAN DENGAN SCRIPT UTAMA (COPY DARI FILE LAMA ANDA)
-- =====================================================
-- [[ Tempelkan semua kode setelah bagian autentikasi dari file lama Anda ]]
-- Misalnya, mulai dari BAGIAN 1: CLEANUP SYSTEM hingga akhir.
-- Pastikan tidak ada duplikasi fungsi CheckWhitelist atau sha256.

-- =====================================================
-- BAGIAN 1: CLEANUP SYSTEM
-- =====================================================
local CoreGui = game:GetService("CoreGui")
local GUI_NAMES = {
    Main = "Vechnost_Webhook_UI",
    Mobile = "Vechnost_Mobile_Button",
}

for _, v in pairs(CoreGui:GetChildren()) do
    for _, name in pairs(GUI_NAMES) do
        if v.Name == name then v:Destroy() end
    end
end

for _, v in pairs(CoreGui:GetDescendants()) do
    if v:IsA("TextLabel") and v.Text == "Vechnost" then
        local container = v
        for i = 1, 10 do
            if typeof(container) ~= "Instance" then break end
            local parent = container.Parent
            if not parent then break end
            container = parent
            if typeof(container) == "Instance" and container:IsA("ScreenGui") then
                container:Destroy()
                break
            end
        end
    end
end

-- =====================================================
-- BAGIAN 2: SERVICES & GLOBALS
-- =====================================================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Safe load game-specific remotes
local net, ObtainedNewFish
do
    local ok, err = pcall(function()
        net = ReplicatedStorage:WaitForChild("Packages", 10)
            :WaitForChild("_Index", 5)
            :WaitForChild("sleitnick_net@0.2.0", 5)
            :WaitForChild("net", 5)
        ObtainedNewFish = net:WaitForChild("RE/ObtainedNewFishNotification", 5)
    end)
    if not ok then
        warn("[Vechnost] ERROR loading game remotes:", err)
        warn("[Vechnost] Make sure you are in the Fish It game!")
    else
        warn("[Vechnost] Game remotes loaded OK")
    end
end

-- Safe load Rayfield
local Rayfield
do
    local ok, result = pcall(function()
        return loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
    end)
    if ok and result then
        Rayfield = result
        warn("[Vechnost] Rayfield loaded OK")
    else
        warn("[Vechnost] ERROR loading Rayfield:", result)
        return
    end
end

-- =====================================================
-- BAGIAN 3: SETTINGS STATE
-- =====================================================
local Settings = {
    Active = false,
    Url = "",
    SentUUID = {},
    SelectedRarities = {},
    ServerWide = true,
    LogCount = 0,
}

-- =====================================================
-- BAGIAN 4: FISH DATABASE
-- =====================================================
local FishDB = {}
do
    local ok, err = pcall(function()
        local Items = ReplicatedStorage:WaitForChild("Items", 10)
        if not Items then return end
        local debugOnce = true
        for _, module in ipairs(Items:GetChildren()) do
            if module:IsA("ModuleScript") then
                local ok2, mod = pcall(require, module)
                if ok2 and mod and mod.Data and mod.Data.Type == "Fish" then
                    -- Debug: print all data keys for first fish
                    if debugOnce then
                        debugOnce = false
                        warn("[Vechnost] FishDB sample keys for:", mod.Data.Name)
                        for k, v in pairs(mod.Data) do
                            warn("  ", k, "=", tostring(v))
                        end
                    end
                    FishDB[mod.Data.Id] = {
                        Name = mod.Data.Name,
                        Tier = mod.Data.Tier,
                        Icon = mod.Data.Icon,
                        SellPrice = mod.Data.SellPrice or mod.Data.Value or mod.Data.Price or mod.Data.Worth or 0
                    }
                end
            end
        end
    end)
    if not ok then
        warn("[Vechnost] ERROR loading FishDB:", err)
    end
end

-- Build reverse lookup: Fish Name -> Fish ID (for chat parsing)
local FishNameToId = {}
for fishId, fishData in pairs(FishDB) do
    if fishData.Name then
        FishNameToId[fishData.Name] = fishId
        FishNameToId[string.lower(fishData.Name)] = fishId
    end
end
warn("[Vechnost] FishDB Loaded:", #FishNameToId > 0 and "OK" or "EMPTY")

-- =====================================================
-- BAGIAN 4B: REPLION PLAYER DATA (Coins, Stats, Backpack)
-- =====================================================
local PlayerData = nil
do
    pcall(function()
        local Replion = require(ReplicatedStorage.Packages.Replion)
        PlayerData = Replion.Client:WaitReplion("Data")
        if PlayerData then
            warn("[Vechnost] Player Replion Data loaded OK")
        end
    end)
end

-- Helper: Format number with commas (1234567 -> 1,234,567)
local function FormatNumber(n)
    if not n or type(n) ~= "number" then return "0" end
    local formatted = tostring(math.floor(n))
    local k
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1,%2")
        if k == 0 then break end
    end
    return formatted
end

-- Helper: Get player stats from Replion data (uses :Get() API)
local _debugStatsDone = false
local function GetPlayerStats()
    local stats = {
        Coins = 0,
        TotalCaught = 0,
        BackpackCount = 0,
        BackpackMax = 0,
    }

    if not PlayerData then return stats end

    pcall(function()
        -- Debug: print all top-level keys on first call
        if not _debugStatsDone then
            _debugStatsDone = true
            warn("[Vechnost] Replion Data top-level keys:")
            local allData = nil
            pcall(function()
                if PlayerData.GetData then
                    allData = PlayerData:GetData()
                end
            end)
            if allData then
                for k, v in pairs(allData) do
                    local vType = typeof(v)
                    if vType == "table" then
                        warn("  ", k, "= [table]")
                        for k2, v2 in pairs(v) do
                            warn("    ", k2, "=", tostring(v2):sub(1, 80))
                        end
                    else
                        warn("  ", k, "=", tostring(v))
                    end
                end
            else
                -- Try :Get() for common keys
                for _, key in ipairs({"Coins", "Currency", "Money", "Gold", "Cash", "Inventory", "Backpack", "Stats", "FishCaught", "TotalCaught", "BackpackSize"}) do
                    local ok, val = pcall(function() return PlayerData:Get(key) end)
                    if ok and val ~= nil then
                        warn("  ", key, "=", tostring(val):sub(1, 80))
                    end
                end
            end
        end

        -- Try :Get() API (Fish It uses Replion :Get())
        local coinVal = nil
        for _, key in ipairs({"Coins", "Currency", "Money", "Gold", "Cash"}) do
            local ok, val = pcall(function() return PlayerData:Get(key) end)
            if ok and val and type(val) == "number" then
                coinVal = val
                break
            end
        end
        stats.Coins = coinVal or 0

        -- Total caught
        for _, key in ipairs({"TotalCaught", "FishCaught", "TotalFish"}) do
            local ok, val = pcall(function() return PlayerData:Get(key) end)
            if ok and val and type(val) == "number" then
                stats.TotalCaught = val
                break
            end
        end
        -- Nested in Stats
        if stats.TotalCaught == 0 then
            pcall(function()
                local s = PlayerData:Get("Stats")
                if s and typeof(s) == "table" then
                    stats.TotalCaught = s.TotalCaught or s.FishCaught or s.TotalFish or 0
                end
            end)
        end

        -- Inventory/Backpack count + max
        pcall(function()
            local inv = PlayerData:Get("Inventory")
            if inv and typeof(inv) == "table" then
                -- Debug: print ALL inventory keys (once)
                if not _debugStatsDone then
                    warn("[Vechnost] Inventory table keys:")
                    for k, v in pairs(inv) do
                        local t = typeof(v)
                        if t == "table" then
                            local c = 0
                            for _ in pairs(v) do c = c + 1 end
                            warn("  Inv." .. tostring(k) .. " = [table:" .. c .. "]")
                        else
                            warn("  Inv." .. tostring(k) .. " = " .. tostring(v))
                        end
                    end
                end
                if inv.Items and typeof(inv.Items) == "table" then
                    local count = 0
                    for _ in pairs(inv.Items) do count = count + 1 end
                    stats.BackpackCount = count
                else
                    local count = 0
                    for _ in pairs(inv) do count = count + 1 end
                    stats.BackpackCount = count
                end
                -- BackpackMax from Inventory table
                if inv.Capacity and type(inv.Capacity) == "number" then
                    stats.BackpackMax = inv.Capacity
                elseif inv.Size and type(inv.Size) == "number" then
                    stats.BackpackMax = inv.Size
                elseif inv.MaxSize and type(inv.MaxSize) == "number" then
                    stats.BackpackMax = inv.MaxSize
                elseif inv.Max and type(inv.Max) == "number" then
                    stats.BackpackMax = inv.Max
                elseif inv.Limit and type(inv.Limit) == "number" then
                    stats.BackpackMax = inv.Limit
                end
            end
        end)

        -- Backpack max from top-level keys
        if stats.BackpackMax == 0 then
            for _, key in ipairs({"BackpackSize", "MaxBackpack", "BackpackMax", "InventorySize", "MaxInventory", "InventoryCapacity"}) do
                local ok, val = pcall(function() return PlayerData:Get(key) end)
                if ok and val and type(val) == "number" and val > 0 then
                    stats.BackpackMax = val
                    break
                end
            end
        end
        -- Nested in Upgrades
        if stats.BackpackMax == 0 then
            pcall(function()
                local u = PlayerData:Get("Upgrades")
                if u and typeof(u) == "table" then
                    stats.BackpackMax = u.BackpackSize or u.Backpack or u.InventorySize or u.Capacity or 0
                end
            end)
        end

        -- Scan PlayerGui for backpack label (e.g. "914 / 4500")
        if stats.BackpackMax == 0 then
            pcall(function()
                local function scanGui(parent)
                    for _, child in ipairs(parent:GetDescendants()) do
                        if (child:IsA("TextLabel") or child:IsA("TextButton")) and child.Text then
                            local cur, mx = string.match(child.Text, "(%d+)%s*/%s*(%d+)")
                            if cur and mx then
                                local maxNum = tonumber(mx)
                                if maxNum and maxNum >= 100 then
                                    stats.BackpackMax = maxNum
                                    return true
                                end
                            end
                        end
                    end
                    return false
                end
                local pg = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
                if pg then scanGui(pg) end
            end)
        end

        -- TotalCaught fallback: count Inventory items if no direct field
        if stats.TotalCaught == 0 and stats.BackpackCount > 0 then
            stats.TotalCaught = stats.BackpackCount
        end
    end)

    return stats
end

-- =====================================================
-- BAGIAN 5: RARITY SYSTEM
-- =====================================================
local RARITY_MAP = {
    [1] = "Common", [2] = "Uncommon", [3] = "Rare", [4] = "Epic",
    [5] = "Legendary", [6] = "Mythic", [7] = "Secret",
}

local RARITY_NAME_TO_TIER = {
    Common = 1, Uncommon = 2, Rare = 3, Epic = 4,
    Legendary = 5, Mythic = 6, Secret = 7,
}

local RARITY_COLOR = {
    [1] = 0x9e9e9e, [2] = 0x4caf50, [3] = 0x2196f3, [4] = 0x9c27b0,
    [5] = 0xff9800, [6] = 0xf44336, [7] = 0xff1744,
    [8] = 0x00e5ff, [9] = 0x448aff,
}

local RARITY_EMOJI = {
    [1] = "⬜", [2] = "🟩", [3] = "🟦", [4] = "🟪",
    [5] = "🟧", [6] = "🟥", [7] = "⬛", [8] = "🔷", [9] = "💠",
}

local RarityList = {"Common","Uncommon","Rare","Epic","Legendary","Mythic","Secret"}

-- =====================================================
-- BAGIAN 6: HTTP REQUEST (Executor Compatible)
-- =====================================================
local HttpRequest =
    syn and syn.request
    or http_request
    or request
    or (fluxus and fluxus.request)
    or (krnl and krnl.request)

if not HttpRequest then
    warn("[Vechnost][FATAL] HttpRequest not available in this executor")
end

-- =====================================================
-- BAGIAN 7: ICON CACHE
-- =====================================================
local IconCache = {}
local IconWaiter = {}

local function FetchFishIconAsync(fishId, callback)
    if IconCache[fishId] then
        callback(IconCache[fishId])
        return
    end

    if IconWaiter[fishId] then
        table.insert(IconWaiter[fishId], callback)
        return
    end

    IconWaiter[fishId] = { callback }

    task.spawn(function()
        local fish = FishDB[fishId]
        if not fish or not fish.Icon then
            callback("")
            return
        end

        local assetId = tostring(fish.Icon):match("%d+")
        if not assetId then
            callback("")
            return
        end

        local api = ("https://thumbnails.roblox.com/v1/assets?assetIds=%s&size=420x420&format=Png&isCircular=false"):format(assetId)

        local ok, res = pcall(function()
            return HttpRequest({ Url = api, Method = "GET" })
        end)

        if not ok or not res or not res.Body then
            callback("")
            return
        end

        local ok2, data = pcall(HttpService.JSONDecode, HttpService, res.Body)
        if not ok2 then
            callback("")
            return
        end

        local imageUrl = data and data.data and data.data[1] and data.data[1].imageUrl
        IconCache[fishId] = imageUrl or ""

        for _, cb in ipairs(IconWaiter[fishId]) do
            cb(IconCache[fishId])
        end
        IconWaiter[fishId] = nil
    end)
end

-- =====================================================
-- BAGIAN 8: FILTER & HELPERS
-- =====================================================
local function IsRarityAllowed(fishId)
    local fish = FishDB[fishId]
    if not fish then return false end
    local tier = fish.Tier
    if type(tier) ~= "number" then return false end
    if next(Settings.SelectedRarities) == nil then return true end
    return Settings.SelectedRarities[tier] == true
end

local function ExtractMutation(weightData, item)
    local mutation = nil

    if weightData and typeof(weightData) == "table" then
        mutation = weightData.Mutation or weightData.Variant or weightData.VariantID
        if not mutation then
            for k, v in pairs(weightData) do
                local lk = string.lower(tostring(k))
                if lk == "variant" or lk == "variantid" or lk == "mutation" then
                    mutation = v
                    break
                end
            end
        end
    end

    if not mutation and item then
        mutation = item.Mutation or item.Variant or item.VariantID
        if not mutation and item.Properties then
            mutation = item.Properties.Mutation or item.Properties.Variant or item.Properties.VariantID
        end
    end

    return mutation
end

local function ResolvePlayerName(arg)
    if typeof(arg) == "Instance" and arg:IsA("Player") then
        return arg.Name
    elseif typeof(arg) == "string" then
        return arg
    elseif typeof(arg) == "table" and arg.Name then
        return tostring(arg.Name)
    end
    return LocalPlayer.Name
end

-- =====================================================
-- BAGIAN 9: WEBHOOK ENGINE (Discord Components V2)
-- =====================================================

-- Helper: Build a Components V2 fish catch payload (Final Custom Style)
local function BuildPayload(playerName, fishId, weight, mutation)
    local fish = FishDB[fishId]
    if not fish then return nil end

    local tier = fish.Tier
    local rarityName = RARITY_MAP[tier] or "Unknown"
    local mutText = (mutation ~= nil) and tostring(mutation) or "None"
    local weightText = string.format("%.1fkg", weight or 0)
    local iconUrl = IconCache[fishId] or ""
    local dateStr = os.date("!%B %d, %Y")

    -- Components V2 payload
    local payload = {
        username = "V - NOTIFIER",
        avatar_url = "https://i.ibb.co.com/fYKH0c20/VIA-LOGIN.png",
        flags = 32768,
        components = {
            {
                type = 17,
                components = {
                    -- Header: # NEW FISH CAUGHT!
                    { type = 10, content = "# NEW FISH CAUGHT!" },
                    
                    -- Pembatas Garis Pertama
                    { type = 14, spacing = 1, divider = true },
                    
                    -- @username you got new [RARITY] fish
                    { 
                        type = 10, 
                        content = "@" .. (playerName or "Unknown") .. " you got new a " .. string.upper(rarityName) .. " fish" 
                    },
                    
                    -- Fish Name Section dengan Thumbnail
                    {
                        type = 9,
                        components = {
                            { type = 10, content = "**Fish Name**" },
                            { type = 10, content = "> " .. (fish.Name or "Unknown") }
                        },
                        accessory = iconUrl ~= "" and {
                            type = 11,
                            media = { url = iconUrl }
                        } or nil
                    },
                    
                    -- Fish Tier Section
                    { type = 10, content = "**Fish Tier**" },
                    { type = 10, content = "> " .. string.upper(rarityName) },
                    
                    -- Weight Section
                    { type = 10, content = "**Weight**" },
                    { type = 10, content = "> " .. weightText },
                    
                    -- Mutation Section
                    { type = 10, content = "**Mutation**" },
                    { type = 10, content = "> " .. mutText },

                    -- Pembatas Garis Kedua
                    { type = 14, spacing = 1, divider = true },

                    -- Footer: Notification by discord.gg/vechnost
                    { type = 10, content = "Notification by **discord.gg/vechnost**" },
                    { type = 10, content = "> -# " .. dateStr }
                }
            }
        }
    }

    return payload
end

-- Helper: Build activation payload (Vechnost Style)
local function BuildActivationPayload(playerName, mode)
    local dateStr = os.date("!%B %d, %Y")
    return {
        username = "V - NOTIFIER",
        avatar_url = "https://i.ibb.co.com/fYKH0c20/VIA-LOGIN.png",
        flags = 32768,
        components = {
            {
                type = 17,
                accent_color = 0x30ff6a,
                components = {
                    {
                        type = 10,
                        content = "### SHESSSHH WEBHOOK CONNECTED"
                    },
                    { type = 14, spacing = 1, divider = true },
                    {
                        type = 10,
                        content =  " **Notifier Mode :** " .. mode .. "\n**Status :** <a:online12:1455051234569490600>"
                    },
                    { type = 14, spacing = 1, divider = true },
                    {
                        type = 10,
                        content = "-# " .. dateStr
                    }
                }
            }
        }
    }
end

-- Helper: Build test payload (Vechnost Style)
local function BuildTestPayload(playerName)
    local dateStr = os.date("!%B %d, %Y")
    return {
        username = "Vechnost Notifier",
        avatar_url = "https://cdn.discordapp.com/attachments/1476338840267653221/1478712225832374272/VIA_LOGIN.png?ex=69a96593&is=69a81413&hm=04e442b9e2b765e68e0f73bb0d6de014c6060b67b0bf0d7bb2bace70bfa4ff19&",
        flags = 32768,
        components = {
            {
                type = 17,
                accent_color = 0x5865f2,
                components = {
                    {
                        type = 10,
                        content = "**Test Message**"
                    },
                    { type = 14, spacing = 1, divider = true },
                    {
                        type = 10,
                        content = "Webhook berfungsi dengan baik!\n\n- **Dikirim oleh:** " .. playerName
                    },
                    { type = 14, spacing = 1, divider = true },
                    {
                        type = 10,
                        content = "-# " .. dateStr
                    }
                }
            }
        }
    }
end

local function SendWebhook(payload)
    if Settings.Url == "" then return end
    if not HttpRequest then return end
    if not payload then return end

    pcall(function()
        -- Append ?with_components=true for Components V2
        local url = Settings.Url
        if string.find(url, "?") then
            url = url .. "&with_components=true"
        else
            url = url .. "?with_components=true"
        end

        HttpRequest({
            Url = url,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(payload)
        })
    end)
end

-- =====================================================
-- BAGIAN 10: SERVER-WIDE FISH DETECTION
-- =====================================================
local Connections = {}
local ChatSentDedup = {}

-- CHAT MONITOR: Parse server chat messages
-- Format: "[Server]: PLAYER obtained a FISHNAME (WEIGHTkg) with a 1 in X chance!"
local function ParseChatForFish(messageText)
    if not Settings.Active then return end
    if not Settings.ServerWide then return end
    if not messageText or messageText == "" then return end

    -- Pattern: "PLAYER obtained a FISHNAME (WEIGHTkg)"
    -- Also try: "PLAYER obtained FISHNAME" without "a"
    local playerName, fishName, weightStr = string.match(messageText, "(%S+)%s+obtained%s+a%s+(.-)%s*%(([%d%.]+)kg%)")

    if not playerName then
        playerName, fishName, weightStr = string.match(messageText, "(%S+)%s+obtained%s+(.-)%s*%(([%d%.]+)kg%)")
    end

    if not playerName then
        playerName, fishName = string.match(messageText, "(%S+)%s+obtained%s+a%s+(.-)%s*with")
    end

    if not playerName then
        playerName, fishName = string.match(messageText, "(%S+)%s+obtained%s+(.-)%s*with")
    end

    if not playerName or not fishName then return end

    -- Clean up fish name (remove trailing spaces)
    fishName = string.gsub(fishName, "%s+$", "")

    -- Skip own catches (handled by primary hook)
    if playerName == LocalPlayer.Name or playerName == LocalPlayer.DisplayName then
        return
    end

    -- Lookup fish in database by name
    local fishId = FishNameToId[fishName] or FishNameToId[string.lower(fishName)]
    if not fishId then
        -- Try partial match
        for name, id in pairs(FishNameToId) do
            if string.find(string.lower(fishName), string.lower(name)) or string.find(string.lower(name), string.lower(fishName)) then
                fishId = id
                break
            end
        end
    end

    if not fishId then
        warn("[Vechnost] Chat fish not in DB:", fishName)
        return
    end

    -- Rarity filter
    if not IsRarityAllowed(fishId) then return end

    -- Dedup by message content + timestamp
    local dedupKey = playerName .. fishName .. tostring(math.floor(os.time() / 2))
    if ChatSentDedup[dedupKey] then return end
    ChatSentDedup[dedupKey] = true

    -- Clean up old dedup entries periodically
    task.defer(function()
        task.wait(10)
        ChatSentDedup[dedupKey] = nil
    end)

    local weight = tonumber(weightStr) or 0

    Settings.LogCount = Settings.LogCount + 1
    warn("[Vechnost] Notifier via CHAT:", playerName, "caught", FishDB[fishId].Name, "(", weight, "kg)")

    FetchFishIconAsync(fishId, function()
        SendWebhook(BuildPayload(playerName, fishId, weight, nil))
    end)
end

-- DIRECT HANDLER: Matches exact UQiLL data format
-- ObtainedNewFishNotification fires with: (playerOrNil, weightData, wrapper)
local function HandleFishCaught(playerArg, weightData, wrapper)
    if not Settings.Active then return end

    -- Extract item from wrapper
    local item = nil
    if wrapper and typeof(wrapper) == "table" and wrapper.InventoryItem then
        item = wrapper.InventoryItem
    end

    -- If wrapper didn't work, maybe weightData IS the wrapper
    if not item and weightData and typeof(weightData) == "table" and weightData.InventoryItem then
        item = weightData.InventoryItem
    end

    if not item then
        warn("[Vechnost] No InventoryItem found in event data")
        return
    end

    if not item.Id or not item.UUID then
        warn("[Vechnost] Item missing Id or UUID")
        return
    end

    -- Check if fish exists in database
    if not FishDB[item.Id] then return end

    -- Rarity filter
    if not IsRarityAllowed(item.Id) then return end

    -- UUID dedup
    if Settings.SentUUID[item.UUID] then return end
    Settings.SentUUID[item.UUID] = true

    -- Resolve player name
    local playerName = ResolvePlayerName(playerArg)

    -- Skip non-local if not server-wide
    if not Settings.ServerWide and playerName ~= LocalPlayer.Name then return end

    -- Extract weight
    local weight = 0
    if weightData and typeof(weightData) == "table" and weightData.Weight then
        weight = weightData.Weight
    end

    -- Extract mutation
    local mutation = ExtractMutation(weightData, item)

    Settings.LogCount = Settings.LogCount + 1
    warn("[Vechnost] Fish caught! Player:", playerName, "Fish:", FishDB[item.Id].Name, "Count:", Settings.LogCount)

    FetchFishIconAsync(item.Id, function()
        SendWebhook(BuildPayload(playerName, item.Id, weight, mutation))
    end)
end

-- GENERIC SCANNER: For other remotes that might carry fish data
local function TryProcessGeneric(remoteName, ...)
    if not Settings.Active then return end

    local args = {...}
    for i = 1, #args do
        local arg = args[i]
        if typeof(arg) == "table" then
            local item = nil
            if arg.InventoryItem then
                item = arg.InventoryItem
            elseif arg.Id and arg.UUID then
                item = arg
            end

            if item and item.Id and item.UUID and FishDB[item.Id] then
                -- Found fish data, delegate to main handler
                local playerArg = (i > 1) and args[1] or nil
                local weightArg = nil
                for j = 1, #args do
                    if typeof(args[j]) == "table" and args[j].Weight then
                        weightArg = args[j]
                        break
                    end
                end
                HandleFishCaught(playerArg, weightArg, arg)
                return
            end
        end
    end
end

local function StartLogger()
    if Settings.Active then return end

    if not net or not ObtainedNewFish then
            Rayfield:Notify({ Title = "Vechnost", Content = "ERROR: Game remotes not found! Are you in Fish It?", Duration = 5 })
        return
    end

    Settings.Active = true
    Settings.SentUUID = {}
    Settings.LogCount = 0

    -- CHAT MONITOR: Listen to server chat for fish catch announcements
    if Settings.ServerWide then
        pcall(function()
            local TextChatService = game:GetService("TextChatService")
            Connections[#Connections + 1] = TextChatService.MessageReceived:Connect(function(textChatMessage)
                pcall(function()
                    local text = textChatMessage.Text or ""
                    if string.find(text, "obtained") then
                        ParseChatForFish(text)
                    end
                end)
            end)
            warn("[Vechnost] Chat monitor (TextChatService) active")
        end)

        -- Fallback: Old chat system via StarterGui
        pcall(function()
            local chatFrame = PlayerGui:WaitForChild("Chat", 3)
            if chatFrame then
                chatFrame.DescendantAdded:Connect(function(desc)
                    if desc:IsA("TextLabel") or desc:IsA("TextButton") then
                        task.defer(function()
                            local text = desc.Text or ""
                            if string.find(text, "obtained") then
                                ParseChatForFish(text)
                            end
                        end)
                    end
                end)
                warn("[Vechnost] Chat monitor (StarterGui) active")
            end
        end)
    end

    -- PRIMARY: ObtainedNewFishNotification (exact format from UQiLL)
    local ok1, err1 = pcall(function()
        Connections[#Connections + 1] = ObtainedNewFish.OnClientEvent:Connect(function(playerArg, weightData, wrapper)
            HandleFishCaught(playerArg, weightData, wrapper)
        end)
    end)
    if ok1 then
        warn("[Vechnost] Primary hook connected OK")
    else
        warn("[Vechnost] Primary hook error:", err1)
    end

    -- SECONDARY: GUI Notification Scanner
    -- Fish It shows server-wide notifications when players catch rare fish
    -- We scan PlayerGui for these notification GUIs and parse the text
    if Settings.ServerWide then
        pcall(function()
            local function ScanNotificationText(textObj)
                if not textObj or not textObj:IsA("TextLabel") then return end
                local text = textObj.Text or ""
                if text == "" then return end

                -- Look for patterns like "PlayerName caught FishName" or similar
                -- Check if any fish name from our DB appears in the text
                for fishId, fishData in pairs(FishDB) do
                    if fishData.Name and string.find(text, fishData.Name) then
                        -- Found a fish name in notification text!
                        -- Try to extract player name (usually before the fish name)
                        local playerName = "Unknown"

                        -- Try common patterns
                        for _, player in pairs(Players:GetPlayers()) do
                            if player ~= LocalPlayer and string.find(text, player.Name) then
                                playerName = player.Name
                                break
                            elseif player ~= LocalPlayer and string.find(text, player.DisplayName) then
                                playerName = player.DisplayName
                                break
                            end
                        end

                        -- Skip if it's our own catch (already handled by primary hook)
                        if playerName == LocalPlayer.Name or playerName == LocalPlayer.DisplayName then
                            return
                        end
                        if string.find(text, LocalPlayer.Name) or string.find(text, LocalPlayer.DisplayName) then
                            return
                        end

                        -- Skip if we can't identify another player
                        if playerName == "Unknown" then return end

                        -- Create dedup key from text
                        local dedupKey = "GUI_" .. text .. "_" .. os.time()
                        if Settings.SentUUID[dedupKey] then return end
                        Settings.SentUUID[dedupKey] = true

                        -- Rarity filter
                        if not IsRarityAllowed(fishId) then return end

                        Settings.LogCount = Settings.LogCount + 1
                        warn("[Vechnost] Notifier catch detected via GUI!", playerName, fishData.Name)

                        FetchFishIconAsync(fishId, function()
                            SendWebhook(BuildPayload(playerName, fishId, 0, nil))
                        end)
                        return
                    end
                end
            end

            -- Watch for new GUI elements appearing in PlayerGui
            Connections[#Connections + 1] = PlayerGui.DescendantAdded:Connect(function(desc)
                if not Settings.Active then return end
                if desc:IsA("TextLabel") then
                    task.defer(function()
                        ScanNotificationText(desc)
                    end)
                end
            end)
            warn("[Vechnost] GUI notification scanner active")
        end)

        -- TERTIARY: Replion shared state listener (NON-BLOCKING)
        -- Runs in background threads so it never blocks the main script
        pcall(function()
            local Replion = require(ReplicatedStorage.Packages.Replion)

            local stateNames = {"ServerFeed", "GlobalNotifications", "RecentCatches", "FishLog", "ServerNotifications", "Feed"}
            for _, stateName in ipairs(stateNames) do
                task.spawn(function()
                    local found = false
                    -- Timeout: cancel after 3 seconds
                    task.delay(3, function()
                        if not found then return end
                    end)
                    local ok, state = pcall(function()
                        return Replion.Client:WaitReplion(stateName)
                    end)
                    if ok and state then
                        found = true
                        warn("[Vechnost] Found Replion state:", stateName)
                        pcall(function()
                            state:OnChange(function(key, value)
                                if not Settings.Active then return end
                                if typeof(value) == "table" then
                                    if value.InventoryItem or (value.Id and value.UUID) then
                                        HandleFishCaught(value.Player or value.PlayerName, value, {InventoryItem = value.InventoryItem or value})
                                    end
                                end
                            end)
                        end)
                    end
                end)
            end
        end)

        -- QUATERNARY: Hook ALL RemoteEvents for fish data
        local hookCount = 0
        pcall(function()
            for _, child in pairs(net:GetChildren()) do
                if child:IsA("RemoteEvent") and child ~= ObtainedNewFish then
                    Connections[#Connections + 1] = child.OnClientEvent:Connect(function(...)
                        TryProcessGeneric(child.Name, ...)
                    end)
                    hookCount = hookCount + 1
                end
            end
        end)
        warn("[Vechnost] Remote hooks:", hookCount, "events connected")
    end

    -- Send activation message (Components V2)
    task.spawn(function()
        local mode = Settings.ServerWide and "Global Notifier" or "Local Notifier"
        SendWebhook(BuildActivationPayload(LocalPlayer.Name, mode))
    end)

    warn("[Vechnost] Webhook Notifier ENABLED | Mode:", Settings.ServerWide and "Global-Notifier" or "Local-Notifier")
end

local function StopLogger()
    Settings.Active = false

    for _, conn in ipairs(Connections) do
        pcall(function() conn:Disconnect() end)
    end
    Connections = {}

    warn("[Vechnost] Webhook Notifier DISABLED | Total Notif:", Settings.LogCount)
end

-- =====================================================
-- BAGIAN 11: RAYFIELD UI
-- =====================================================
local Window = Rayfield:CreateWindow({
    Name = "Vechnost",
    Icon = "webhook",
    LoadingTitle = "Vechnost Webhook Notifier",
    LoadingSubtitle = "Beta",
    Theme = "Default",
    ToggleUIKeybind = "V",
    DisableRayfieldPrompts = true,
    DisableBuildWarnings = true,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "Vechnost",
        FileName = "VechnostConfig"
    },
    KeySystem = false,
    KeySettings = {
        Title = "Vechnost Access",
        Subtitle = "Authentication Required",
        Note = "Join our discord to get key\n https://discord.gg/vechnost",
        FileName = "VechnostKey",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"Vechnost-Notifier-9999"}
    },
})

-- =====================================================
-- BAGIAN 12: FLOATING TOGGLE BUTTON
-- =====================================================
local oldBtn = CoreGui:FindFirstChild(GUI_NAMES.Mobile)
if oldBtn then oldBtn:Destroy() end

local BtnGui = Instance.new("ScreenGui")
BtnGui.Name = GUI_NAMES.Mobile
BtnGui.ResetOnSpawn = false
BtnGui.Parent = CoreGui

local Button = Instance.new("ImageButton")
Button.Size = UDim2.fromOffset(52, 52)
Button.Position = UDim2.fromScale(0.05, 0.5)
Button.BackgroundTransparency = 1
Button.AutoButtonColor = false
Button.BorderSizePixel = 0
Button.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=127239715511367&width=420&height=420&format=png"
Button.ImageTransparency = 0
Button.ScaleType = Enum.ScaleType.Fit
Button.Parent = BtnGui

Instance.new("UICorner", Button).CornerRadius = UDim.new(1, 0)

local windowVisible = true
Button.MouseButton1Click:Connect(function()
    windowVisible = not windowVisible
    pcall(function() Rayfield:SetVisibility(windowVisible) end)
end)

-- Drag system
local dragging = false
local dragOffset = Vector2.zero

Button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragOffset = UserInputService:GetMouseLocation() - Button.AbsolutePosition
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

RunService.RenderStepped:Connect(function()
    if not dragging then return end
    local mouse = UserInputService:GetMouseLocation()
    local target = mouse - dragOffset
    local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
    local sz = Button.AbsoluteSize
    local cx = math.clamp(target.X, 0, vp.X - sz.X)
    local cy = math.clamp(target.Y, 0, vp.Y - sz.Y)
    Button.Position = UDim2.fromOffset(cx, cy)
end)

-- BAGIAN 13: TABS & UI ELEMENTS
-- =====================================================
local TabWebhook = Window:CreateTab("Setup Webhook", "webhook")
local TabSettings = Window:CreateTab("Settings", "settings")

-- -- RARITY FILTER --
TabWebhook:CreateSection("Rarity Filter")

TabWebhook:CreateDropdown({
    Name = "Filter by Rarity",
    Options = RarityList,
    CurrentOption = {},
    MultipleOptions = true,
    Flag = "RarityFilter",
    Callback = function(Options)
        Settings.SelectedRarities = {}

        for _, value in ipairs(Options or {}) do
            if type(value) == "string" then
                local tier = RARITY_NAME_TO_TIER[value]
                if tier then Settings.SelectedRarities[tier] = true end
            end
        end

        if next(Settings.SelectedRarities) == nil then
            Rayfield:Notify({ Title = "Vechnost", Content = "Filter: all rarity", Duration = 2 })
        else
            Rayfield:Notify({ Title = "Vechnost", Content = "Filter rarity updated", Duration = 2 })
        end
    end
})

-- -- WEBHOOK URL --
TabWebhook:CreateSection("Setup Webhook")

local WebhookUrlBuffer = ""

TabWebhook:CreateInput({
    Name = "Discord Webhook URL",
    CurrentValue = "",
    PlaceholderText = "https://discord.com/api/webhook/...",
    RemoveTextAfterFocusLost = false,
    Flag = "WebhookUrl",
    Callback = function(Text)
        WebhookUrlBuffer = tostring(Text)
    end
})

TabWebhook:CreateButton({
    Name = "Save Webhook URL",
    Callback = function()
        local url = WebhookUrlBuffer:gsub("%s+", "")

        if not url:match("^https://discord.com/api/webhooks/")
        and not url:match("^https://canary.discord.com/api/webhooks/") then
            Rayfield:Notify({ Title = "Vechnost", Content = "URL webhook tidak valid!", Duration = 3 })
            return
        end

        Settings.Url = url
        Rayfield:Notify({ Title = "Vechnost", Content = "Webhook URL tersimpan!", Duration = 2 })
    end
})

-- -- MODE --
TabWebhook:CreateSection("Notifier Mode")

TabWebhook:CreateToggle({
    Name = "Local / Global Mode",
    CurrentValue = true,
    Flag = "ServerNotifierMode",
    Callback = function(Value)
        Settings.ServerWide = Value
        Rayfield:Notify({
            Title = "Vechnost",
            Content = Value and "Mode: Global Server" or "Mode: Local Server",
            Duration = 2
        })
    end
})

-- -- CONTROL --
TabWebhook:CreateSection("Controller")

TabWebhook:CreateToggle({
    Name = "Enable Webhook Logger",
    CurrentValue = false,
    Flag = "LoggerEnabled",
    Callback = function(Value)
        if Value then
            if Settings.Url == "" then
                Rayfield:Notify({ Title = "Vechnost", Content = "Webhook URL not found!", Duration = 3 })
                return
            end
            StartLogger()
            Rayfield:Notify({ Title = "Vechnost", Content = "Notifier active!", Duration = 2 })
        else
            StopLogger()
            Rayfield:Notify({ Title = "Vechnost", Content = "Notifier stopped", Duration = 2 })
        end
    end
})

-- -- STATUS --
local StatusLabel = TabWebhook:CreateParagraph({
    Title = "Vechnost Status",
    Content = "Status: Offline"
})

task.spawn(function()
    while true do
        task.wait(2)
        if StatusLabel then
            pcall(function()
                if Settings.Active then
                    StatusLabel:Set({
                        Title = "Notifier Status",
                        Content = string.format(
                            "Status: Active\nMode: %s\nTotal Log: %d fish",
                            Settings.ServerWide and "Global Server" or "Local Server",
                            Settings.LogCount
                        )
                    })
                else
                    StatusLabel:Set({
                        Title = "Notifier Status",
                        Content = "Status: Offline"
                    })
                end
            end)
        end
    end
end)

-- -- SETTINGS TAB --
TabSettings:CreateSection("Information")

TabSettings:CreateParagraph({
    Title = "Vechnost Webhook Notifier",
    Content = "Beta Version\nNotifier Fish Caught\nfish notifications from all players on the server\n\nby discord.gg/vechnost"
})

TabSettings:CreateSection("Test Mode")

TabSettings:CreateButton({
    Name = "Test Webhook",
    Callback = function()
        if Settings.Url == "" then
            Rayfield:Notify({ Title = "Vechnost", Content = "Isi webhook URL dulu!", Duration = 3 })
            return
        end

        task.spawn(function()
            SendWebhook(BuildTestPayload(LocalPlayer.Name))
        end)

        Rayfield:Notify({ Title = "Vechnost", Content = "Sending Test Notifier!", Duration = 2 })
    end
})

TabSettings:CreateButton({
    Name = "Reset Counter",
    Callback = function()
        Settings.LogCount = 0
        Settings.SentUUID = {}
        Rayfield:Notify({ Title = "Vechnost", Content = "Counter Reseted!", Duration = 2 })
    end
})

-- =====================================================
-- BAGIAN 14: INIT
-- =====================================================
Rayfield:LoadConfiguration()
warn("[Vechnost] Webhook Notifier Loaded!")
warn("[Vechnost] Toggle GUI: click V or Press logo floating")
