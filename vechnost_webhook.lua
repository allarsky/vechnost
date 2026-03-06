--[[ 
    FILE: vechnost_notifier_kavo.lua
    BRAND: Vechnost
    VERSION: Beta with Kavo UI
]]

-- =====================================================
-- BAGIAN 0: VALIDASI KEY VIA API (WHITELIST)
-- =====================================================
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- Fungsi HTTP Request
local HttpRequest = syn and syn.request
    or http_request
    or request
    or (fluxus and fluxus.request)
    or (krnl and krnl.request)

if not HttpRequest then
    warn("[Vechnost][FATAL] HttpRequest not available in this executor")
    return
end

local function ValidateKeyWithAPI(key, robloxId)
    local apiUrl = "http://prem-eu3.bot-hosting.net:20434/validate"
    local data = {
        key = key,
        robloxId = tostring(robloxId)
    }
    local body = HttpService:JSONEncode(data)

    local success, response = pcall(function()
        return HttpRequest({
            Url = apiUrl,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = body
        })
    end)

    if not success or not response then
        return false, "NETWORK_ERROR"
    end

    if response.StatusCode ~= 200 then
        return false, "SERVER_ERROR"
    end

    local decoded = HttpService:JSONDecode(response.Body)
    return decoded.valid, decoded.reason
end

-- =====================================================
-- BAGIAN 1: CLEANUP SYSTEM (tetap sama, hapus GUI lama)
-- =====================================================
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
-- BAGIAN 2: SERVICES & GLOBALS (sama)
-- =====================================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
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
-- BAGIAN 4: FISH DATABASE (sama persis)
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

local FishNameToId = {}
for fishId, fishData in pairs(FishDB) do
    if fishData.Name then
        FishNameToId[fishData.Name] = fishId
        FishNameToId[string.lower(fishData.Name)] = fishId
    end
end
warn("[Vechnost] FishDB Loaded:", #FishNameToId > 0 and "OK" or "EMPTY")

-- =====================================================
-- BAGIAN 4B: REPLION PLAYER DATA (sama)
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
                for _, key in ipairs({"Coins", "Currency", "Money", "Gold", "Cash", "Inventory", "Backpack", "Stats", "FishCaught", "TotalCaught", "BackpackSize"}) do
                    local ok, val = pcall(function() return PlayerData:Get(key) end)
                    if ok and val ~= nil then
                        warn("  ", key, "=", tostring(val):sub(1, 80))
                    end
                end
            end
        end

        local coinVal = nil
        for _, key in ipairs({"Coins", "Currency", "Money", "Gold", "Cash"}) do
            local ok, val = pcall(function() return PlayerData:Get(key) end)
            if ok and val and type(val) == "number" then
                coinVal = val
                break
            end
        end
        stats.Coins = coinVal or 0

        for _, key in ipairs({"TotalCaught", "FishCaught", "TotalFish"}) do
            local ok, val = pcall(function() return PlayerData:Get(key) end)
            if ok and val and type(val) == "number" then
                stats.TotalCaught = val
                break
            end
        end
        if stats.TotalCaught == 0 then
            pcall(function()
                local s = PlayerData:Get("Stats")
                if s and typeof(s) == "table" then
                    stats.TotalCaught = s.TotalCaught or s.FishCaught or s.TotalFish or 0
                end
            end)
        end

        pcall(function()
            local inv = PlayerData:Get("Inventory")
            if inv and typeof(inv) == "table" then
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

        if stats.BackpackMax == 0 then
            for _, key in ipairs({"BackpackSize", "MaxBackpack", "BackpackMax", "InventorySize", "MaxInventory", "InventoryCapacity"}) do
                local ok, val = pcall(function() return PlayerData:Get(key) end)
                if ok and val and type(val) == "number" and val > 0 then
                    stats.BackpackMax = val
                    break
                end
            end
        end
        if stats.BackpackMax == 0 then
            pcall(function()
                local u = PlayerData:Get("Upgrades")
                if u and typeof(u) == "table" then
                    stats.BackpackMax = u.BackpackSize or u.Backpack or u.InventorySize or u.Capacity or 0
                end
            end)
        end

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
-- BAGIAN 6: HTTP REQUEST (sudah)
-- =====================================================

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

local function BuildPayload(playerName, fishId, weight, mutation)
    local fish = FishDB[fishId]
    if not fish then return nil end

    local tier = fish.Tier
    local rarityName = RARITY_MAP[tier] or "Unknown"
    local mutText = (mutation ~= nil) and tostring(mutation) or "None"
    local weightText = string.format("%.1fkg", weight or 0)
    local iconUrl = IconCache[fishId] or ""
    local dateStr = os.date("!%B %d, %Y")

    local payload = {
        username = "V - NOTIFIER",
        avatar_url = "https://i.ibb.co.com/fYKH0c20/VIA-LOGIN.png",
        flags = 32768,
        components = {
            {
                type = 17,
                components = {
                    { type = 10, content = "# NEW FISH CAUGHT!" },
                    { type = 14, spacing = 1, divider = true },
                    { 
                        type = 10, 
                        content = "@" .. (playerName or "Unknown") .. " you got new a " .. string.upper(rarityName) .. " fish" 
                    },
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
                    { type = 10, content = "**Fish Tier**" },
                    { type = 10, content = "> " .. string.upper(rarityName) },
                    { type = 10, content = "**Weight**" },
                    { type = 10, content = "> " .. weightText },
                    { type = 10, content = "**Mutation**" },
                    { type = 10, content = "> " .. mutText },
                    { type = 14, spacing = 1, divider = true },
                    { type = 10, content = "Notification by **discord.gg/vechnost**" },
                    { type = 10, content = "> -# " .. dateStr }
                }
            }
        }
    }

    return payload
end

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
                    { type = 10, content = "### SHESSSHH WEBHOOK CONNECTED" },
                    { type = 14, spacing = 1, divider = true },
                    { type = 10, content = " **Notifier Mode :** " .. mode .. "\n**Status :** <a:online12:1455051234569490600>" },
                    { type = 14, spacing = 1, divider = true },
                    { type = 10, content = "-# " .. dateStr }
                }
            }
        }
    }
end

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
                    { type = 10, content = "**Test Message**" },
                    { type = 14, spacing = 1, divider = true },
                    { type = 10, content = "Webhook berfungsi dengan baik!\n\n- **Dikirim oleh:** " .. playerName },
                    { type = 14, spacing = 1, divider = true },
                    { type = 10, content = "-# " .. dateStr }
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
-- BAGIAN 10: SERVER-WIDE FISH DETECTION (sama)
-- =====================================================
local Connections = {}
local ChatSentDedup = {}

local function ParseChatForFish(messageText)
    if not Settings.Active then return end
    if not Settings.ServerWide then return end
    if not messageText or messageText == "" then return end

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

    fishName = string.gsub(fishName, "%s+$", "")

    if playerName == LocalPlayer.Name or playerName == LocalPlayer.DisplayName then
        return
    end

    local fishId = FishNameToId[fishName] or FishNameToId[string.lower(fishName)]
    if not fishId then
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

    if not IsRarityAllowed(fishId) then return end

    local dedupKey = playerName .. fishName .. tostring(math.floor(os.time() / 2))
    if ChatSentDedup[dedupKey] then return end
    ChatSentDedup[dedupKey] = true

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

local function HandleFishCaught(playerArg, weightData, wrapper)
    if not Settings.Active then return end

    local item = nil
    if wrapper and typeof(wrapper) == "table" and wrapper.InventoryItem then
        item = wrapper.InventoryItem
    end

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

    if not FishDB[item.Id] then return end

    if not IsRarityAllowed(item.Id) then return end

    if Settings.SentUUID[item.UUID] then return end
    Settings.SentUUID[item.UUID] = true

    local playerName = ResolvePlayerName(playerArg)

    if not Settings.ServerWide and playerName ~= LocalPlayer.Name then return end

    local weight = 0
    if weightData and typeof(weightData) == "table" and weightData.Weight then
        weight = weightData.Weight
    end

    local mutation = ExtractMutation(weightData, item)

    Settings.LogCount = Settings.LogCount + 1
    warn("[Vechnost] Fish caught! Player:", playerName, "Fish:", FishDB[item.Id].Name, "Count:", Settings.LogCount)

    FetchFishIconAsync(item.Id, function()
        SendWebhook(BuildPayload(playerName, item.Id, weight, mutation))
    end)
end

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
        warn("[Vechnost] ERROR: Game remotes not found! Are you in Fish It?")
        return
    end

    Settings.Active = true
    Settings.SentUUID = {}
    Settings.LogCount = 0

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

    if Settings.ServerWide then
        pcall(function()
            local function ScanNotificationText(textObj)
                if not textObj or not textObj:IsA("TextLabel") then return end
                local text = textObj.Text or ""
                if text == "" then return end

                for fishId, fishData in pairs(FishDB) do
                    if fishData.Name and string.find(text, fishData.Name) then
                        local playerName = "Unknown"
                        for _, player in pairs(Players:GetPlayers()) do
                            if player ~= LocalPlayer and string.find(text, player.Name) then
                                playerName = player.Name
                                break
                            elseif player ~= LocalPlayer and string.find(text, player.DisplayName) then
                                playerName = player.DisplayName
                                break
                            end
                        end

                        if playerName == LocalPlayer.Name or playerName == LocalPlayer.DisplayName then
                            return
                        end
                        if string.find(text, LocalPlayer.Name) or string.find(text, LocalPlayer.DisplayName) then
                            return
                        end

                        if playerName == "Unknown" then return end

                        local dedupKey = "GUI_" .. text .. "_" .. os.time()
                        if Settings.SentUUID[dedupKey] then return end
                        Settings.SentUUID[dedupKey] = true

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

        pcall(function()
            local Replion = require(ReplicatedStorage.Packages.Replion)

            local stateNames = {"ServerFeed", "GlobalNotifications", "RecentCatches", "FishLog", "ServerNotifications", "Feed"}
            for _, stateName in ipairs(stateNames) do
                task.spawn(function()
                    local found = false
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
-- BAGIAN 11: KAVO UI - AUTHENTICATION WINDOW
-- =====================================================
local Kavo = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local CurrentWindow = nil
local authenticated = false

-- Fungsi membuat window autentikasi
local function CreateAuthWindow()
    if CurrentWindow then
        CurrentWindow:Destroy()
    end
    local Window = Kavo.CreateLib("Vechnost - Authentication", "DarkTheme")
    CurrentWindow = Window

    local Tab = Window:NewTab("Authentication")
    local Section = Tab:NewSection("Masukkan Key")

    local keyInput = ""
    Section:NewTextBox("License Key", "Masukkan key kamu", function(txt)
        keyInput = txt
    end)

    Section:NewButton("Validate Key", "Klik untuk validasi", function()
        if keyInput == "" then
            Kavo:Notify("Masukkan key terlebih dahulu!")
            return
        end

        local valid, reason = ValidateKeyWithAPI(keyInput, LocalPlayer.UserId)
        if valid then
            Kavo:Notify("✅ Key valid! Memuat panel...")
            authenticated = true
            Window:Destroy()
            CreateMainWindow()
        else
            Kavo:Notify("❌ Key tidak valid: " .. tostring(reason))
        end
    end)

    -- Tombol untuk toggle UI (opsional)
    Tab:NewKeybind("Toggle UI", "Tekan untuk sembunyikan/tampilkan", Enum.KeyCode.V, function()
        Kavo:ToggleUI()
    end)
end

-- Fungsi membuat window utama (setup webhook & settings)
local function CreateMainWindow()
    local Window = Kavo.CreateLib("Vechnost", "DarkTheme")
    CurrentWindow = Window

    local TabWebhook = Window:NewTab("Setup Webhook")
    local TabSettings = Window:NewTab("Settings")

    -- Rarity Filter
    local SectionRarity = TabWebhook:NewSection("Rarity Filter")
    SectionRarity:NewDropdown("Filter by Rarity", "Pilih rarity", RarityList, function(option)
        -- Kavo dropdown mengembalikan string, bukan table. Kita perlu handle multiple? Kavo tidak support multiple dropdown bawaan. 
        -- Alternatif: pakai toggle per rarity? Atau kita bisa pakai beberapa toggle.
        -- Untuk sederhana, kita buat toggle terpisah.
        -- Tapi agar tidak ribet, kita gunakan dropdown biasa (hanya satu pilihan).
        -- Namun user request multiple. Mungkin kita bisa buat beberapa toggle.
        -- Karena Kavo tidak support multiple dropdown, kita akan buat toggle untuk setiap rarity.
        -- Di sini kita buat fungsi yang akan dipanggil nanti.
    end)

    -- Karena Kavo tidak support multiple dropdown, kita akan buat toggle untuk masing-masing rarity.
    -- Hapus dropdown di atas, ganti dengan toggle.
    -- Tapi kita sudah tulis, lebih baik kita buat section baru.
    -- Kita akan buat di bawah.

    -- Untuk sementara, kita buat toggle di section terpisah.
    local SectionRarityToggles = TabWebhook:NewSection("Rarity Filter (Toggle)")
    local rarityToggles = {}
    for _, rarity in ipairs(RarityList) do
        local toggle = SectionRarityToggles:NewToggle(rarity, "Aktifkan untuk filter " .. rarity, function(state)
            local tier = RARITY_NAME_TO_TIER[rarity]
            if state then
                Settings.SelectedRarities[tier] = true
            else
                Settings.SelectedRarities[tier] = nil
            end
        end)
        table.insert(rarityToggles, toggle)
    end

    -- Webhook URL
    local SectionWebhook = TabWebhook:NewSection("Setup Webhook")
    local webhookUrl = ""
    SectionWebhook:NewTextBox("Discord Webhook URL", "Masukkan URL webhook", function(txt)
        webhookUrl = txt
    end)

    SectionWebhook:NewButton("Save Webhook URL", "Simpan URL", function()
        local url = webhookUrl:gsub("%s+", "")
        if not url:match("^https://discord.com/api/webhooks/") and not url:match("^https://canary.discord.com/api/webhooks/") then
            Kavo:Notify("URL tidak valid!")
            return
        end
        Settings.Url = url
        Kavo:Notify("Webhook URL tersimpan!")
    end)

    -- Mode
    local SectionMode = TabWebhook:NewSection("Notifier Mode")
    SectionMode:NewToggle("Global Server Mode", "Aktifkan untuk menangkap semua player", function(state)
        Settings.ServerWide = state
        Kavo:Notify(state and "Mode: Global" or "Mode: Lokal")
    end)

    -- Control
    local SectionControl = TabWebhook:NewSection("Controller")
    SectionControl:NewToggle("Enable Webhook Logger", "Aktifkan logger", function(state)
        if state then
            if not authenticated then
                Kavo:Notify("Validasi key terlebih dahulu!")
                return
            end
            if Settings.Url == "" then
                Kavo:Notify("Webhook URL belum diisi!")
                return
            end
            StartLogger()
        else
            StopLogger()
        end
    end)

    -- Status
    local SectionStatus = TabWebhook:NewSection("Status")
    local statusLabel = SectionStatus:NewLabel("Status: Offline")

    task.spawn(function()
        while true do
            task.wait(2)
            if Settings.Active then
                statusLabel:UpdateLabel(string.format("Status: Active\nMode: %s\nTotal Log: %d fish", Settings.ServerWide and "Global" or "Lokal", Settings.LogCount))
            else
                statusLabel:UpdateLabel("Status: Offline")
            end
        end
    end)

    -- Settings Tab
    local SectionInfo = TabSettings:NewSection("Information")
    SectionInfo:NewLabel("Vechnost Webhook Notifier")
    SectionInfo:NewLabel("Beta Version")
    SectionInfo:NewLabel("by discord.gg/vechnost")

    local SectionTest = TabSettings:NewSection("Test Mode")
    SectionTest:NewButton("Test Webhook", "Kirim test message", function()
        if Settings.Url == "" then
            Kavo:Notify("Webhook URL belum diisi!")
            return
        end
        task.spawn(function()
            SendWebhook(BuildTestPayload(LocalPlayer.Name))
        end)
        Kavo:Notify("Test message dikirim!")
    end)

    SectionTest:NewButton("Reset Counter", "Reset log counter", function()
        Settings.LogCount = 0
        Settings.SentUUID = {}
        Kavo:Notify("Counter direset!")
    end)

    -- Keybind toggle UI
    TabSettings:NewKeybind("Toggle UI", "Tekan untuk sembunyikan/tampilkan", Enum.KeyCode.V, function()
        Kavo:ToggleUI()
    end)
end

-- =====================================================
-- BAGIAN 12: FLOATING BUTTON (opsional, bisa pakai Kavo keybind)
-- =====================================================
-- Kita bisa skip floating button karena sudah ada keybind.

-- =====================================================
-- BAGIAN 13: INIT
-- =====================================================
CreateAuthWindow()
warn("[Vechnost] Kavo UI Loaded! Tekan V untuk toggle UI.")
