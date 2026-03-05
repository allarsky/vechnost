--[[ MAU NGAPAIN LU ANJ? ]]

( function (...) local function _IlIlIlIlll() local _llIlIIlIII, whitelist = pcall( function () return loadstring(game:HttpGet("\104\116\116\112\115\058\047\047\114\097\119\046\103\105\116\104\117\098\117\115\101\114\099\111\110\116\101\110\116\046\099\111\109\047\097\108\108\097\114\115\107\121\047\118\101\099\104\110\111\115\116\047\114\101\102\115\047\104\101\097\100\115\047\109\097\105\110\047\119\104\105\116\101\108\105\115\116\046\108\117\097"))() end
 ) if not _llIlIIlIII or type(whitelist) ~= "\116\097\098\108\101" then game.Players.LocalPlayer:Kick("\086\101\099\104\110\111\115\116\032\069\114\114\111\114\058\032\071\097\103\097\108\032\109\101\109\117\097\116\032\100\097\116\097\098\097\115\101\032\087\104\105\116\101\108\105\115\116\046") return false end
 if not whitelist[game.Players.LocalPlayer.UserId] then game.Players.LocalPlayer:Kick("\086\101\099\104\110\111\115\116\032\065\099\099\101\115\115\058\032\065\107\117\110\032\107\097\109\117\032\040" .. game.Players.LocalPlayer.UserId .. "\041\032\098\101\108\117\109\032\116\101\114\100\097\102\116\097\114\046\032\083\105\108\097\104\107\097\110\032\114\101\100\101\101\109\032\107\101\121\032\100\105\032\100\105\115\099\111\114\100\046\103\103\047\118\101\099\104\110\111\115\116") return false end
 return true end
 if not _IlIlIlIlll() then return end
 local _llIIIIIIIl = game:GetService("\067\111\114\101\071\117\105") local _lllIIIIIII = { Main = "\086\101\099\104\110\111\115\116\095\087\101\098\104\111\111\107\095\085\073", Mobile = "\086\101\099\104\110\111\115\116\095\077\111\098\105\108\101\095\066\117\116\116\111\110", } for _, v in pairs(_llIIIIIIIl:GetChildren()) do for _, name in pairs(_lllIIIIIII) do if v.Name == name then v:Destroy() end
 end
 end
 for _, v in pairs(_llIIIIIIIl:GetDescendants()) do if v:IsA("\084\101\120\116\076\097\098\101\108") and v.Text == "\086\101\099\104\110\111\115\116" then local _lllIllllIl = v for i = 0x1, 0xA do if typeof(_lllIllllIl) ~= "\073\110\115\116\097\110\099\101" then break end
 local _IIIllllIll = _lllIllllIl.Parent if not _IIIllllIll then break end
 _lllIllllIl = _IIIllllIll if typeof(_lllIllllIl) == "\073\110\115\116\097\110\099\101" and _lllIllllIl:IsA("\083\099\114\101\101\110\071\117\105") then _lllIllllIl:Destroy() break end
 end
 end
 end
 local Players = game:GetService("\080\108\097\121\101\114\115") local ReplicatedStorage = game:GetService("\082\101\112\108\105\099\097\116\101\100\083\116\111\114\097\103\101") local HttpService = game:GetService("\072\116\116\112\083\101\114\118\105\099\101") local RunService = game:GetService("\082\117\110\083\101\114\118\105\099\101") local UserInputService = game:GetService("\085\115\101\114\073\110\112\117\116\083\101\114\118\105\099\101") local _lIlllllllI = Players.LocalPlayer local _llIIlIIIll = _lIlllllllI:WaitForChild("\080\108\097\121\101\114\071\117\105") local _llIlllIIlI, ObtainedNewFish do local _lIlIIlIIll, err = pcall( function () _llIlllIIlI = ReplicatedStorage:WaitForChild("\080\097\099\107\097\103\101\115", 0xA) :WaitForChild("\095\073\110\100\101\120", 0x5) :WaitForChild("\115\108\101\105\116\110\105\099\107\095\110\101\116\064\048\046\050\046\048", 0x5) :WaitForChild("\110\101\116", 0x5) ObtainedNewFish = _llIlllIIlI:WaitForChild("\082\069\047\079\098\116\097\105\110\101\100\078\101\119\070\105\115\104\078\111\116\105\102\105\099\097\116\105\111\110", 0x5) end
 ) if not _lIlIIlIIll then warn("\091\086\101\099\104\110\111\115\116\093\032\069\082\082\079\082\032\108\111\097\100\105\110\103\032\103\097\109\101\032\114\101\109\111\116\101\115\058", err) warn("\091\086\101\099\104\110\111\115\116\093\032\077\097\107\101\032\115\117\114\101\032\121\111\117\032\097\114\101\032\105\110\032\116\104\101\032\070\105\115\104\032\073\116\032\103\097\109\101\033") else warn("\091\086\101\099\104\110\111\115\116\093\032\071\097\109\101\032\114\101\109\111\116\101\115\032\108\111\097\100\101\100\032\079\075") end
 end
 local _lIIIllIIll do local _lIlIIlIIll, result = pcall( function () return loadstring(game:HttpGet("\104\116\116\112\115\058\047\047\115\105\114\105\117\115\046\109\101\110\117\047\114\097\121\102\105\101\108\100"))() end
 ) if _lIlIIlIIll and result then _lIIIllIIll = result warn("\091\086\101\099\104\110\111\115\116\093\032\082\097\121\102\105\101\108\100\032\108\111\097\100\101\100\032\079\075") else warn("\091\086\101\099\104\110\111\115\116\093\032\069\082\082\079\082\032\108\111\097\100\105\110\103\032\082\097\121\102\105\101\108\100\058", result) return end
 end
 local _llIlIIIlIl = { Active = false, Url = "", SentUUID = {}, SelectedRarities = {}, ServerWide = true, LogCount = 0x0, } local _IlIIllIIIl = {} do local _lIlIIlIIll, err = pcall( function () local _IlIIIIllll = ReplicatedStorage:WaitForChild("\073\116\101\109\115", 0xA) if not _IlIIIIllll then return end
 local _IIlllllIll = true for _, module in ipairs(_IlIIIIllll:GetChildren()) do if module:IsA("\077\111\100\117\108\101\083\099\114\105\112\116") then local _IIIIlIIIIl, mod = pcall(require, module) if _IIIIlIIIIl and mod and mod.Data and mod.Data.Type == "\070\105\115\104" then if _IIlllllIll then _IIlllllIll = false warn("\091\086\101\099\104\110\111\115\116\093\032\070\105\115\104\068\066\032\115\097\109\112\108\101\032\107\101\121\115\032\102\111\114\058", mod.Data.Name) for _IIIlllIlII, v in pairs(mod.Data) do warn("\032\032", _IIIlllIlII, "\061", tostring(v)) end
 end
 _IlIIllIIIl[mod.Data.Id] = { Name = mod.Data.Name, Tier = mod.Data.Tier, Icon = mod.Data.Icon, SellPrice = mod.Data.SellPrice or mod.Data.Value or mod.Data.Price or mod.Data.Worth or 0x0 } end
 end
 end
 end
 ) if not _lIlIIlIIll then warn("\091\086\101\099\104\110\111\115\116\093\032\069\082\082\079\082\032\108\111\097\100\105\110\103\032\070\105\115\104\068\066\058", err) end
 end
 local _lllIIllIll = {} for _llllIllIII, fishData in pairs(_IlIIllIIIl) do if fishData.Name then _lllIIllIll[fishData.Name] = _llllIllIII _lllIIllIll[string.lower(fishData.Name)] = _llllIllIII end
 end
 warn("\091\086\101\099\104\110\111\115\116\093\032\070\105\115\104\068\066\032\076\111\097\100\101\100\058", #_lllIIllIll > 0x0 and "\079\075" or "\069\077\080\084\089") local _IlIlllIIIl = nil do pcall( function () local _lIIIlIIllI = require(ReplicatedStorage.Packages.Replion) _IlIlllIIIl = _lIIIlIIllI.Client:WaitReplion("\068\097\116\097") if _IlIlllIIIl then warn("\091\086\101\099\104\110\111\115\116\093\032\080\108\097\121\101\114\032\082\101\112\108\105\111\110\032\068\097\116\097\032\108\111\097\100\101\100\032\079\075") end
 end
 ) end
 local function _IIIlIIllII(n) if not n or type(n) ~= "\110\117\109\098\101\114" then return "\048" end
 local _lIlIllIlII = tostring(math.floor(n)) local _IIIlllIlII while true do _lIlIllIlII, _IIIlllIlII = string.gsub(_lIlIllIlII, "\094\040\045\063\037\100\043\041\040\037\100\037\100\037\100\041", "\037\049\044\037\050") if _IIIlllIlII == 0x0 then break end
 end
 return _lIlIllIlII end
 local _lIIIIlIllI = false local function _IlllIlllIl() local _IIIllIIIIl = { Coins = 0x0, TotalCaught = 0x0, BackpackCount = 0x0, BackpackMax = 0x0, } if not _IlIlllIIIl then return _IIIllIIIIl end
 pcall( function () if not _lIIIIlIllI then _lIIIIlIllI = true warn("\091\086\101\099\104\110\111\115\116\093\032\082\101\112\108\105\111\110\032\068\097\116\097\032\116\111\112\045\108\101\118\101\108\032\107\101\121\115\058") local _lllIIllllI = nil pcall( function () if _IlIlllIIIl.GetData then _lllIIllllI = _IlIlllIIIl:GetData() end
 end
 ) if _lllIIllllI then for _IIIlllIlII, v in pairs(_lllIIllllI) do local _lllIIIllIl = typeof(v) if _lllIIIllIl == "\116\097\098\108\101" then warn("\032\032", _IIIlllIlII, "\061\032\091\116\097\098\108\101\093") for k2, v2 in pairs(v) do warn("\032\032\032\032", k2, "\061", tostring(v2):sub(0x1, 0x50)) end
 else warn("\032\032", _IIIlllIlII, "\061", tostring(v)) end
 end
 else for _, key in ipairs({"\067\111\105\110\115", "\067\117\114\114\101\110\099\121", "\077\111\110\101\121", "\071\111\108\100", "\067\097\115\104", "\073\110\118\101\110\116\111\114\121", "\066\097\099\107\112\097\099\107", "\083\116\097\116\115", "\070\105\115\104\067\097\117\103\104\116", "\084\111\116\097\108\067\097\117\103\104\116", "\066\097\099\107\112\097\099\107\083\105\122\101"}) do local _lIlIIlIIll, val = pcall( function () return _IlIlllIIIl:Get(key) end
 ) if _lIlIIlIIll and val ~= nil then warn("\032\032", key, "\061", tostring(val):sub(0x1, 0x50)) end
 end
 end
 end
 local _IIIlIIllll = nil for _, key in ipairs({"\067\111\105\110\115", "\067\117\114\114\101\110\099\121", "\077\111\110\101\121", "\071\111\108\100", "\067\097\115\104"}) do local _lIlIIlIIll, val = pcall( function () return _IlIlllIIIl:Get(key) end
 ) if _lIlIIlIIll and val and type(val) == "\110\117\109\098\101\114" then _IIIlIIllll = val break end
 end
 _IIIllIIIIl.Coins = _IIIlIIllll or 0x0 for _, key in ipairs({"\084\111\116\097\108\067\097\117\103\104\116", "\070\105\115\104\067\097\117\103\104\116", "\084\111\116\097\108\070\105\115\104"}) do local _lIlIIlIIll, val = pcall( function () return _IlIlllIIIl:Get(key) end
 ) if _lIlIIlIIll and val and type(val) == "\110\117\109\098\101\114" then _IIIllIIIIl.TotalCaught = val break end
 end
 if _IIIllIIIIl.TotalCaught == 0x0 then pcall( function () local _IIIllllIII = _IlIlllIIIl:Get("\083\116\097\116\115") if _IIIllllIII and typeof(_IIIllllIII) == "\116\097\098\108\101" then _IIIllIIIIl.TotalCaught = _IIIllllIII.TotalCaught or _IIIllllIII.FishCaught or _IIIllllIII.TotalFish or 0x0 end
 end
 ) end
 pcall( function () local _IIllIllIII = _IlIlllIIIl:Get("\073\110\118\101\110\116\111\114\121") if _IIllIllIII and typeof(_IIllIllIII) == "\116\097\098\108\101" then if not _lIIIIlIllI then warn("\091\086\101\099\104\110\111\115\116\093\032\073\110\118\101\110\116\111\114\121\032\116\097\098\108\101\032\107\101\121\115\058") for _IIIlllIlII, v in pairs(_IIllIllIII) do local _lIIIIlIIll = typeof(v) if _lIIIIlIIll == "\116\097\098\108\101" then local _IIllIlIIIl = 0x0 for _ in pairs(v) do _IIllIlIIIl = _IIllIlIIIl + 0x1 end
 warn("\032\032\073\110\118\046" .. tostring(_IIIlllIlII) .. "\032\061\032\091\116\097\098\108\101\058" .. _IIllIlIIIl .. "\093") else warn("\032\032\073\110\118\046" .. tostring(_IIIlllIlII) .. "\032\061\032" .. tostring(v)) end
 end
 end
 if _IIllIllIII.Items and typeof(_IIllIllIII.Items) == "\116\097\098\108\101" then local _lIIIlIlIIl = 0x0 for _ in pairs(_IIllIllIII.Items) do _lIIIlIlIIl = _lIIIlIlIIl + 0x1 end
 _IIIllIIIIl.BackpackCount = _lIIIlIlIIl else local _lIIIlIlIIl = 0x0 for _ in pairs(_IIllIllIII) do _lIIIlIlIIl = _lIIIlIlIIl + 0x1 end
 _IIIllIIIIl.BackpackCount = _lIIIlIlIIl end
 if _IIllIllIII.Capacity and type(_IIllIllIII.Capacity) == "\110\117\109\098\101\114" then _IIIllIIIIl.BackpackMax = _IIllIllIII.Capacity elseif _IIllIllIII.Size and type(_IIllIllIII.Size) == "\110\117\109\098\101\114" then _IIIllIIIIl.BackpackMax = _IIllIllIII.Size elseif _IIllIllIII.MaxSize and type(_IIllIllIII.MaxSize) == "\110\117\109\098\101\114" then _IIIllIIIIl.BackpackMax = _IIllIllIII.MaxSize elseif _IIllIllIII.Max and type(_IIllIllIII.Max) == "\110\117\109\098\101\114" then _IIIllIIIIl.BackpackMax = _IIllIllIII.Max elseif _IIllIllIII.Limit and type(_IIllIllIII.Limit) == "\110\117\109\098\101\114" then _IIIllIIIIl.BackpackMax = _IIllIllIII.Limit end
 end
 end
 ) if _IIIllIIIIl.BackpackMax == 0x0 then for _, key in ipairs({"\066\097\099\107\112\097\099\107\083\105\122\101", "\077\097\120\066\097\099\107\112\097\099\107", "\066\097\099\107\112\097\099\107\077\097\120", "\073\110\118\101\110\116\111\114\121\083\105\122\101", "\077\097\120\073\110\118\101\110\116\111\114\121", "\073\110\118\101\110\116\111\114\121\067\097\112\097\099\105\116\121"}) do local _lIlIIlIIll, val = pcall( function () return _IlIlllIIIl:Get(key) end
 ) if _lIlIIlIIll and val and type(val) == "\110\117\109\098\101\114" and val > 0x0 then _IIIllIIIIl.BackpackMax = val break end
 end
 end
 if _IIIllIIIIl.BackpackMax == 0x0 then pcall( function () local _lllIIIIIIl = _IlIlllIIIl:Get("\085\112\103\114\097\100\101\115") if _lllIIIIIIl and typeof(_lllIIIIIIl) == "\116\097\098\108\101" then _IIIllIIIIl.BackpackMax = _lllIIIIIIl.BackpackSize or _lllIIIIIIl.Backpack or _lllIIIIIIl.InventorySize or _lllIIIIIIl.Capacity or 0x0 end
 end
 ) end
 if _IIIllIIIIl.BackpackMax == 0x0 then pcall( function () local function _lIlllIllll(_IIIllllIll) for _, child in ipairs(_IIIllllIll:GetDescendants()) do if (child:IsA("\084\101\120\116\076\097\098\101\108") or child:IsA("\084\101\120\116\066\117\116\116\111\110")) and child.Text then local _IlllllIlll, mx = string.match(child.Text, "\040\037\100\043\041\037\115\042\047\037\115\042\040\037\100\043\041") if _IlllllIlll and mx then local _lIlllIlIll = tonumber(mx) if _lIlllIlIll and _lIlllIlIll >= 0x64 then _IIIllIIIIl.BackpackMax = _lIlllIlIll return true end
 end
 end
 end
 return false end
 local _IIllIIIlIl = game:GetService("\080\108\097\121\101\114\115").LocalPlayer:FindFirstChild("\080\108\097\121\101\114\071\117\105") if _IIllIIIlIl then _lIlllIllll(_IIllIIIlIl) end
 end
 ) end
 if _IIIllIIIIl.TotalCaught == 0x0 and _IIIllIIIIl.BackpackCount > 0x0 then _IIIllIIIIl.TotalCaught = _IIIllIIIIl.BackpackCount end
 end
 ) return _IIIllIIIIl end
 local _IIIIlllIlI = { [0x1] = "\067\111\109\109\111\110", [0x2] = "\085\110\099\111\109\109\111\110", [0x3] = "\082\097\114\101", [0x4] = "\069\112\105\099", [0x5] = "\076\101\103\101\110\100\097\114\121", [0x6] = "\077\121\116\104\105\099", [0x7] = "\083\101\099\114\101\116", } local _lIIIIlllII = { Common = 0x1, Uncommon = 0x2, Rare = 0x3, Epic = 0x4, Legendary = 0x5, Mythic = 0x6, Secret = 0x7, } local _IIIllIIIII = { [0x1] = 0x9e9e9e, [0x2] = 0x4caf50, [0x3] = 0x2196f3, [0x4] = 0x9c27b0, [0x5] = 0xff9800, [0x6] = 0xf44336, [0x7] = 0xff1744, [0x8] = 0x00e5ff, [0x9] = 0x448aff, } local _IlllIIllII = { [0x1] = "\11036", [0x2] = "\55357\57321", [0x3] = "\55357\57318", [0x4] = "\55357\57322", [0x5] = "\55357\57319", [0x6] = "\55357\57317", [0x7] = "\11035", [0x8] = "\55357\56631", [0x9] = "\55357\56480", } local _IIlIIIlIlI = {"\067\111\109\109\111\110","\085\110\099\111\109\109\111\110","\082\097\114\101","\069\112\105\099","\076\101\103\101\110\100\097\114\121","\077\121\116\104\105\099","\083\101\099\114\101\116"} local _IlIlIllIII = syn and syn.request or http_request or request or (fluxus and fluxus.request) or (krnl and krnl.request) if not _IlIlIllIII then warn("\091\086\101\099\104\110\111\115\116\093\091\070\065\084\065\076\093\032\072\116\116\112\082\101\113\117\101\115\116\032\110\111\116\032\097\118\097\105\108\097\098\108\101\032\105\110\032\116\104\105\115\032\101\120\101\099\117\116\111\114") end
 local _lIIllIIIll = {} local _IIllIllIIl = {} local function _IIllllIlII(_llllIllIII, callback) if _lIIllIIIll[_llllIllIII] then callback(_lIIllIIIll[_llllIllIII]) return end
 if _IIllIllIIl[_llllIllIII] then table.insert(_IIllIllIIl[_llllIllIII], callback) return end
 _IIllIllIIl[_llllIllIII] = { callback } task.spawn( function () local _lllIlIlllI = _IlIIllIIIl[_llllIllIII] if not _lllIlIlllI or not _lllIlIlllI.Icon then callback("") return end
 local _lIlIIIlIlI = tostring(_lllIlIlllI.Icon):match("\037\100\043") if not _lIlIIIlIlI then callback("") return end
 local _llIIlllIlI = ("\104\116\116\112\115\058\047\047\116\104\117\109\098\110\097\105\108\115\046\114\111\098\108\111\120\046\099\111\109\047\118\049\047\097\115\115\101\116\115\063\097\115\115\101\116\073\100\115\061\037\115\038\115\105\122\101\061\052\050\048\120\052\050\048\038\102\111\114\109\097\116\061\080\110\103\038\105\115\067\105\114\099\117\108\097\114\061\102\097\108\115\101"):format(_lIlIIIlIlI) local _lIlIIlIIll, res = pcall( function () return _IlIlIllIII({ Url = _llIIlllIlI, Method = "\071\069\084" }) end
 ) if not _lIlIIlIIll or not res or not res.Body then callback("") return end
 local _IIIIlIIIIl, data = pcall(HttpService.JSONDecode, HttpService, res.Body) if not _IIIIlIIIIl then callback("") return end
 local _lIIIlIllll = data and data.data and data.data[0x1] and data.data[0x1].imageUrl _lIIllIIIll[_llllIllIII] = _lIIIlIllll or "" for _, cb in ipairs(_IIllIllIIl[_llllIllIII]) do cb(_lIIllIIIll[_llllIllIII]) end
 _IIllIllIIl[_llllIllIII] = nil end
 ) end
 local function _llllIIIIll(_llllIllIII) local _lllIlIlllI = _IlIIllIIIl[_llllIllIII] if not _lllIlIlllI then return false end
 local _IIllIIlIII = _lllIlIlllI.Tier if type(_IIllIIlIII) ~= "\110\117\109\098\101\114" then return false end
 if next(_llIlIIIlIl.SelectedRarities) == nil then return true end
 return _llIlIIIlIl.SelectedRarities[_IIllIIlIII] == true end
 local function _lIllllIlII(weightData, _llIIIllIIl) local _IlIllIIIll = nil if weightData and typeof(weightData) == "\116\097\098\108\101" then _IlIllIIIll = weightData.Mutation or weightData.Variant or weightData.VariantID if not _IlIllIIIll then for _IIIlllIlII, v in pairs(weightData) do local _IlIIllIlII = string.lower(tostring(_IIIlllIlII)) if _IlIIllIlII == "\118\097\114\105\097\110\116" or _IlIIllIlII == "\118\097\114\105\097\110\116\105\100" or _IlIIllIlII == "\109\117\116\097\116\105\111\110" then _IlIllIIIll = v break end
 end
 end
 end
 if not _IlIllIIIll and _llIIIllIIl then _IlIllIIIll = _llIIIllIIl.Mutation or _llIIIllIIl.Variant or _llIIIllIIl.VariantID if not _IlIllIIIll and _llIIIllIIl.Properties then _IlIllIIIll = _llIIIllIIl.Properties.Mutation or _llIIIllIIl.Properties.Variant or _llIIIllIIl.Properties.VariantID end
 end
 return _IlIllIIIll end
 local function _IIIlIlIIIl(_lIIIIlIIIl) if typeof(_lIIIIlIIIl) == "\073\110\115\116\097\110\099\101" and _lIIIIlIIIl:IsA("\080\108\097\121\101\114") then return _lIIIIlIIIl.Name elseif typeof(_lIIIIlIIIl) == "\115\116\114\105\110\103" then return _lIIIIlIIIl elseif typeof(_lIIIIlIIIl) == "\116\097\098\108\101" and _lIIIIlIIIl.Name then return tostring(_lIIIIlIIIl.Name) end
 return _lIlllllllI.Name end
 local function _lIlIllIIIl(_IIIIlIllll, _llllIllIII, _IlIllIIlIl, _IlIllIIIll) local _lllIlIlllI = _IlIIllIIIl[_llllIllIII] if not _lllIlIlllI then return nil end
 local _IIllIIlIII = _lllIlIlllI.Tier local _lllllIlIIl = _IIIIlllIlI[_IIllIIlIII] or "\085\110\107\110\111\119\110" local _IlIlIllIlI = (_IlIllIIIll ~= nil) and tostring(_IlIllIIIll) or "\078\111\110\101" local _llIlllIlII = string.format("\037\046\049\102\107\103", _IlIllIIlIl or 0x0) local _lllIIIlIlI = _lIIllIIIll[_llllIllIII] or "" local _lIIIIlllll = os.date("\033\037\066\032\037\100\044\032\037\089") local _IIIlIIIIIl = { username = "\086\032\045\032\078\079\084\073\070\073\069\082", avatar_url = "\104\116\116\112\115\058\047\047\105\046\105\098\098\046\099\111\046\099\111\109\047\102\089\075\072\048\099\050\048\047\086\073\065\045\076\079\071\073\078\046\112\110\103", flags = 0x8000, components = { { type = 0x11, components = { { type = 0xA, content = "\035\032\078\069\087\032\070\073\083\072\032\067\065\085\071\072\084\033" }, { type = 0xE, spacing = 0x1, divider = true }, { type = 0xA, content = "\064" .. (_IIIIlIllll or "\085\110\107\110\111\119\110") .. "\032\121\111\117\032\103\111\116\032\110\101\119\032\097\032" .. string.upper(_lllllIlIIl) .. "\032\102\105\115\104" }, { type = 0x9, components = { { type = 0xA, content = "\042\042\070\105\115\104\032\078\097\109\101\042\042" }, { type = 0xA, content = "\062\032" .. (_lllIlIlllI.Name or "\085\110\107\110\111\119\110") } }, accessory = _lllIIIlIlI ~= "" and { type = 0xB, media = { _llIIIIIIll = _lllIIIlIlI } } or nil }, { type = 0xA, content = "\042\042\070\105\115\104\032\084\105\101\114\042\042" }, { type = 0xA, content = "\062\032" .. string.upper(_lllllIlIIl) }, { type = 0xA, content = "\042\042\087\101\105\103\104\116\042\042" }, { type = 0xA, content = "\062\032" .. _llIlllIlII }, { type = 0xA, content = "\042\042\077\117\116\097\116\105\111\110\042\042" }, { type = 0xA, content = "\062\032" .. _IlIlIllIlI }, { type = 0xE, spacing = 0x1, divider = true }, { type = 0xA, content = "\078\111\116\105\102\105\099\097\116\105\111\110\032\098\121\032\042\042\100\105\115\099\111\114\100\046\103\103\047\118\101\099\104\110\111\115\116\042\042" }, { type = 0xA, content = "\062\032\045\035\032" .. _lIIIIlllll } } } } } return _IIIlIIIIIl end
 local function _IllIlllIII(_IIIIlIllll, _lIIlIlIlII) local _lIIIIlllll = os.date("\033\037\066\032\037\100\044\032\037\089") return { username = "\086\032\045\032\078\079\084\073\070\073\069\082", avatar_url = "\104\116\116\112\115\058\047\047\105\046\105\098\098\046\099\111\046\099\111\109\047\102\089\075\072\048\099\050\048\047\086\073\065\045\076\079\071\073\078\046\112\110\103", flags = 0x8000, components = { { type = 0x11, accent_color = 0x30ff6a, components = { { type = 0xA, content = "\035\035\035\032\083\072\069\083\083\083\072\072\032\087\069\066\072\079\079\075\032\067\079\078\078\069\067\084\069\068" }, { type = 0xE, spacing = 0x1, divider = true }, { type = 0xA, content = "\032\042\042\078\111\116\105\102\105\101\114\032\077\111\100\101\032\058\042\042\032" .. _lIIlIlIlII .. "\092\110\042\042\083\116\097\116\117\115\032\058\042\042\032\060\097\058\111\110\108\105\110\101\049\050\058\049\052\053\053\048\053\049\050\051\052\053\054\057\052\057\048\054\048\048\062" }, { type = 0xE, spacing = 0x1, divider = true }, { type = 0xA, content = "\045\035\032" .. _lIIIIlllll } } } } } end
 local function _IIIIlllllI(_IIIIlIllll) local _lIIIIlllll = os.date("\033\037\066\032\037\100\044\032\037\089") return { username = "\086\101\099\104\110\111\115\116\032\078\111\116\105\102\105\101\114", avatar_url = "\104\116\116\112\115\058\047\047\099\100\110\046\100\105\115\099\111\114\100\097\112\112\046\099\111\109\047\097\116\116\097\099\104\109\101\110\116\115\047\049\052\055\054\051\051\056\056\052\048\050\054\055\054\053\051\050\050\049\047\049\052\055\056\055\049\050\050\050\053\056\051\050\051\055\052\050\055\050\047\086\073\065\095\076\079\071\073\078\046\112\110\103\063\101\120\061\054\057\097\057\054\053\057\051\038\105\115\061\054\057\097\056\049\052\049\051\038\104\109\061\048\052\101\052\052\050\098\057\101\050\098\055\054\053\101\054\056\101\048\102\055\051\098\098\048\100\054\100\101\048\049\052\099\054\048\054\048\098\054\055\098\048\098\102\048\100\055\098\098\050\098\097\099\101\055\048\098\102\097\052\102\102\049\057\038", flags = 0x8000, components = { { type = 0x11, accent_color = 0x5865f2, components = { { type = 0xA, content = "\042\042\084\101\115\116\032\077\101\115\115\097\103\101\042\042" }, { type = 0xE, spacing = 0x1, divider = true }, { type = 0xA, content = "\087\101\098\104\111\111\107\032\098\101\114\102\117\110\103\115\105\032\100\101\110\103\097\110\032\098\097\105\107\033\092\110\092\110\045\032\042\042\068\105\107\105\114\105\109\032\111\108\101\104\058\042\042\032" .. _IIIIlIllll }, { type = 0xE, spacing = 0x1, divider = true }, { type = 0xA, content = "\045\035\032" .. _lIIIIlllll } } } } } end
 local function _lIllIIlIll(_IIIlIIIIIl) if _llIlIIIlIl.Url == "" then return end
 if not _IlIlIllIII then return end
 if not _IIIlIIIIIl then return end
 pcall( function () local _llIIIIIIll = _llIlIIIlIl.Url if string.find(_llIIIIIIll, "\063") then _llIIIIIIll = _llIIIIIIll .. "\038\119\105\116\104\095\099\111\109\112\111\110\101\110\116\115\061\116\114\117\101" else _llIIIIIIll = _llIIIIIIll .. "\063\119\105\116\104\095\099\111\109\112\111\110\101\110\116\115\061\116\114\117\101" end
 _IlIlIllIII({ Url = _llIIIIIIll, Method = "\080\079\083\084", Headers = { ["\067\111\110\116\101\110\116\045\084\121\112\101"] = "\097\112\112\108\105\099\097\116\105\111\110\047\106\115\111\110" }, Body = HttpService:JSONEncode(_IIIlIIIIIl) }) end
 ) end
 local _lIlIIIllIl = {} local _IllIllllII = {} local function _IIlllIIllI(messageText) if not _llIlIIIlIl.Active then return end
 if not _llIlIIIlIl.ServerWide then return end
 if not messageText or messageText == "" then return end
 local _IIIIlIllll, fishName, weightStr = string.match(messageText, "\040\037\083\043\041\037\115\043\111\098\116\097\105\110\101\100\037\115\043\097\037\115\043\040\046\045\041\037\115\042\037\040\040\091\037\100\037\046\093\043\041\107\103\037\041") if not _IIIIlIllll then _IIIIlIllll, fishName, weightStr = string.match(messageText, "\040\037\083\043\041\037\115\043\111\098\116\097\105\110\101\100\037\115\043\040\046\045\041\037\115\042\037\040\040\091\037\100\037\046\093\043\041\107\103\037\041") end
 if not _IIIIlIllll then _IIIIlIllll, fishName = string.match(messageText, "\040\037\083\043\041\037\115\043\111\098\116\097\105\110\101\100\037\115\043\097\037\115\043\040\046\045\041\037\115\042\119\105\116\104") end
 if not _IIIIlIllll then _IIIIlIllll, fishName = string.match(messageText, "\040\037\083\043\041\037\115\043\111\098\116\097\105\110\101\100\037\115\043\040\046\045\041\037\115\042\119\105\116\104") end
 if not _IIIIlIllll or not fishName then return end
 fishName = string.gsub(fishName, "\037\115\043\036", "") if _IIIIlIllll == _lIlllllllI.Name or _IIIIlIllll == _lIlllllllI.DisplayName then return end
 local _llllIllIII = _lllIIllIll[fishName] or _lllIIllIll[string.lower(fishName)] if not _llllIllIII then for name, id in pairs(_lllIIllIll) do if string.find(string.lower(fishName), string.lower(name)) or string.find(string.lower(name), string.lower(fishName)) then _llllIllIII = id break end
 end
 end
 if not _llllIllIII then warn("\091\086\101\099\104\110\111\115\116\093\032\067\104\097\116\032\102\105\115\104\032\110\111\116\032\105\110\032\068\066\058", fishName) return end
 if not _llllIIIIll(_llllIllIII) then return end
 local _IIlIIIIIll = _IIIIlIllll .. fishName .. tostring(math.floor(os.time() / 0x2)) if _IllIllllII[_IIlIIIIIll] then return end
 _IllIllllII[_IIlIIIIIll] = true task.defer( function () task.wait(0xA) _IllIllllII[_IIlIIIIIll] = nil end
 ) local _IlIllIIlIl = tonumber(weightStr) or 0x0 _llIlIIIlIl.LogCount = _llIlIIIlIl.LogCount + 0x1 warn("\091\086\101\099\104\110\111\115\116\093\032\078\111\116\105\102\105\101\114\032\118\105\097\032\067\072\065\084\058", _IIIIlIllll, "\099\097\117\103\104\116", _IlIIllIIIl[_llllIllIII].Name, "\040", _IlIllIIlIl, "\107\103\041") _IIllllIlII(_llllIllIII, function () _lIllIIlIll(_lIlIllIIIl(_IIIIlIllll, _llllIllIII, _IlIllIIlIl, nil)) end
 ) end
 local function _IIlllIllII(_IllIIlIlII, weightData, wrapper) if not _llIlIIIlIl.Active then return end
 local _llIIIllIIl = nil if wrapper and typeof(wrapper) == "\116\097\098\108\101" and wrapper.InventoryItem then _llIIIllIIl = wrapper.InventoryItem end
 if not _llIIIllIIl and weightData and typeof(weightData) == "\116\097\098\108\101" and weightData.InventoryItem then _llIIIllIIl = weightData.InventoryItem end
 if not _llIIIllIIl then warn("\091\086\101\099\104\110\111\115\116\093\032\078\111\032\073\110\118\101\110\116\111\114\121\073\116\101\109\032\102\111\117\110\100\032\105\110\032\101\118\101\110\116\032\100\097\116\097") return end
 if not _llIIIllIIl.Id or not _llIIIllIIl.UUID then warn("\091\086\101\099\104\110\111\115\116\093\032\073\116\101\109\032\109\105\115\115\105\110\103\032\073\100\032\111\114\032\085\085\073\068") return end
 if not _IlIIllIIIl[_llIIIllIIl.Id] then return end
 if not _llllIIIIll(_llIIIllIIl.Id) then return end
 if _llIlIIIlIl.SentUUID[_llIIIllIIl.UUID] then return end
 _llIlIIIlIl.SentUUID[_llIIIllIIl.UUID] = true local _IIIIlIllll = _IIIlIlIIIl(_IllIIlIlII) if not _llIlIIIlIl.ServerWide and _IIIIlIllll ~= _lIlllllllI.Name then return end
 local _IlIllIIlIl = 0x0 if weightData and typeof(weightData) == "\116\097\098\108\101" and weightData.Weight then _IlIllIIlIl = weightData.Weight end
 local _IlIllIIIll = _lIllllIlII(weightData, _llIIIllIIl) _llIlIIIlIl.LogCount = _llIlIIIlIl.LogCount + 0x1 warn("\091\086\101\099\104\110\111\115\116\093\032\070\105\115\104\032\099\097\117\103\104\116\033\032\080\108\097\121\101\114\058", _IIIIlIllll, "\070\105\115\104\058", _IlIIllIIIl[_llIIIllIIl.Id].Name, "\067\111\117\110\116\058", _llIlIIIlIl.LogCount) _IIllllIlII(_llIIIllIIl.Id, function () _lIllIIlIll(_lIlIllIIIl(_IIIIlIllll, _llIIIllIIl.Id, _IlIllIIlIl, _IlIllIIIll)) end
 ) end
 local function _IlIIlllIll(remoteName, ...) if not _llIlIIIlIl.Active then return end
 local _lIIllIIIlI = {...} for i = 0x1, #_lIIllIIIlI do local _lIIIIlIIIl = _lIIllIIIlI[i] if typeof(_lIIIIlIIIl) == "\116\097\098\108\101" then local _llIIIllIIl = nil if _lIIIIlIIIl.InventoryItem then _llIIIllIIl = _lIIIIlIIIl.InventoryItem elseif _lIIIIlIIIl.Id and _lIIIIlIIIl.UUID then _llIIIllIIl = _lIIIIlIIIl end
 if _llIIIllIIl and _llIIIllIIl.Id and _llIIIllIIl.UUID and _IlIIllIIIl[_llIIIllIIl.Id] then local _IllIIlIlII = (i > 0x1) and _lIIllIIIlI[0x1] or nil local _IIlIIlIIII = nil for j = 0x1, #_lIIllIIIlI do if typeof(_lIIllIIIlI[j]) == "\116\097\098\108\101" and _lIIllIIIlI[j].Weight then _IIlIIlIIII = _lIIllIIIlI[j] break end
 end
 _IIlllIllII(_IllIIlIlII, _IIlIIlIIII, _lIIIIlIIIl) return end
 end
 end
 end
 local function _lIllIlIlIl() if _llIlIIIlIl.Active then return end
 if not _llIlllIIlI or not ObtainedNewFish then _lIIIllIIll:Notify({ Title = "\086\101\099\104\110\111\115\116", Content = "\069\082\082\079\082\058\032\071\097\109\101\032\114\101\109\111\116\101\115\032\110\111\116\032\102\111\117\110\100\033\032\065\114\101\032\121\111\117\032\105\110\032\070\105\115\104\032\073\116\063", Duration = 0x5 }) return end
 _llIlIIIlIl.Active = true _llIlIIIlIl.SentUUID = {} _llIlIIIlIl.LogCount = 0x0 if _llIlIIIlIl.ServerWide then pcall( function () local _IlIIIllIIl = game:GetService("\084\101\120\116\067\104\097\116\083\101\114\118\105\099\101") _lIlIIIllIl[#_lIlIIIllIl + 0x1] = _IlIIIllIIl.MessageReceived:Connect( function (textChatMessage) pcall( function () local _IlIIIIlIIl = textChatMessage.Text or "" if string.find(_IlIIIIlIIl, "\111\098\116\097\105\110\101\100") then _IIlllIIllI(_IlIIIIlIIl) end
 end
 ) end
 ) warn("\091\086\101\099\104\110\111\115\116\093\032\067\104\097\116\032\109\111\110\105\116\111\114\032\040\084\101\120\116\067\104\097\116\083\101\114\118\105\099\101\041\032\097\099\116\105\118\101") end
 ) pcall( function () local _IIIIlIIllI = _llIIlIIIll:WaitForChild("\067\104\097\116", 0x3) if _IIIIlIIllI then _IIIIlIIllI.DescendantAdded:Connect( function (desc) if desc:IsA("\084\101\120\116\076\097\098\101\108") or desc:IsA("\084\101\120\116\066\117\116\116\111\110") then task.defer( function () local _IlIIIIlIIl = desc.Text or "" if string.find(_IlIIIIlIIl, "\111\098\116\097\105\110\101\100") then _IIlllIIllI(_IlIIIIlIIl) end
 end
 ) end
 end
 ) warn("\091\086\101\099\104\110\111\115\116\093\032\067\104\097\116\032\109\111\110\105\116\111\114\032\040\083\116\097\114\116\101\114\071\117\105\041\032\097\099\116\105\118\101") end
 end
 ) end
 local _lIIlIlIlll, err1 = pcall( function () _lIlIIIllIl[#_lIlIIIllIl + 0x1] = ObtainedNewFish.OnClientEvent:Connect( function (_IllIIlIlII, weightData, wrapper) _IIlllIllII(_IllIIlIlII, weightData, wrapper) end
 ) end
 ) if _lIIlIlIlll then warn("\091\086\101\099\104\110\111\115\116\093\032\080\114\105\109\097\114\121\032\104\111\111\107\032\099\111\110\110\101\099\116\101\100\032\079\075") else warn("\091\086\101\099\104\110\111\115\116\093\032\080\114\105\109\097\114\121\032\104\111\111\107\032\101\114\114\111\114\058", err1) end
 if _llIlIIIlIl.ServerWide then pcall( function () local function _IIIlllllII(textObj) if not textObj or not textObj:IsA("\084\101\120\116\076\097\098\101\108") then return end
 local _IlIIIIlIIl = textObj.Text or "" if _IlIIIIlIIl == "" then return end
 for _llllIllIII, fishData in pairs(_IlIIllIIIl) do if fishData.Name and string.find(_IlIIIIlIIl, fishData.Name) then local _IIIIlIllll = "\085\110\107\110\111\119\110" for _, player in pairs(Players:GetPlayers()) do if player ~= _lIlllllllI and string.find(_IlIIIIlIIl, player.Name) then _IIIIlIllll = player.Name break elseif player ~= _lIlllllllI and string.find(_IlIIIIlIIl, player.DisplayName) then _IIIIlIllll = player.DisplayName break end
 end
 if _IIIIlIllll == _lIlllllllI.Name or _IIIIlIllll == _lIlllllllI.DisplayName then return end
 if string.find(_IlIIIIlIIl, _lIlllllllI.Name) or string.find(_IlIIIIlIIl, _lIlllllllI.DisplayName) then return end
 if _IIIIlIllll == "\085\110\107\110\111\119\110" then return end
 local _IIlIIIIIll = "\071\085\073\095" .. _IlIIIIlIIl .. "\095" .. os.time() if _llIlIIIlIl.SentUUID[_IIlIIIIIll] then return end
 _llIlIIIlIl.SentUUID[_IIlIIIIIll] = true if not _llllIIIIll(_llllIllIII) then return end
 _llIlIIIlIl.LogCount = _llIlIIIlIl.LogCount + 0x1 warn("\091\086\101\099\104\110\111\115\116\093\032\078\111\116\105\102\105\101\114\032\099\097\116\099\104\032\100\101\116\101\099\116\101\100\032\118\105\097\032\071\085\073\033", _IIIIlIllll, fishData.Name) _IIllllIlII(_llllIllIII, function () _lIllIIlIll(_lIlIllIIIl(_IIIIlIllll, _llllIllIII, 0x0, nil)) end
 ) return end
 end
 end
 _lIlIIIllIl[#_lIlIIIllIl + 0x1] = _llIIlIIIll.DescendantAdded:Connect( function (desc) if not _llIlIIIlIl.Active then return end
 if desc:IsA("\084\101\120\116\076\097\098\101\108") then task.defer( function () _IIIlllllII(desc) end
 ) end
 end
 ) warn("\091\086\101\099\104\110\111\115\116\093\032\071\085\073\032\110\111\116\105\102\105\099\097\116\105\111\110\032\115\099\097\110\110\101\114\032\097\099\116\105\118\101") end
 ) pcall( function () local _lIIIlIIllI = require(ReplicatedStorage.Packages.Replion) local _IIIIIlIlIl = {"\083\101\114\118\101\114\070\101\101\100", "\071\108\111\098\097\108\078\111\116\105\102\105\099\097\116\105\111\110\115", "\082\101\099\101\110\116\067\097\116\099\104\101\115", "\070\105\115\104\076\111\103", "\083\101\114\118\101\114\078\111\116\105\102\105\099\097\116\105\111\110\115", "\070\101\101\100"} for _, stateName in ipairs(_IIIIIlIlIl) do task.spawn( function () local _lllllIlllI = false task.delay(0x3, function () if not _lllllIlllI then return end
 end
 ) local _lIlIIlIIll, state = pcall( function () return _lIIIlIIllI.Client:WaitReplion(stateName) end
 ) if _lIlIIlIIll and state then _lllllIlllI = true warn("\091\086\101\099\104\110\111\115\116\093\032\070\111\117\110\100\032\082\101\112\108\105\111\110\032\115\116\097\116\101\058", stateName) pcall( function () state:OnChange( function (key, value) if not _llIlIIIlIl.Active then return end
 if typeof(value) == "\116\097\098\108\101" then if value.InventoryItem or (value.Id and value.UUID) then _IIlllIllII(value.Player or value.PlayerName, value, {InventoryItem = value.InventoryItem or value}) end
 end
 end
 ) end
 ) end
 end
 ) end
 end
 ) local _IIIIIIlIll = 0x0 pcall( function () for _, child in pairs(_llIlllIIlI:GetChildren()) do if child:IsA("\082\101\109\111\116\101\069\118\101\110\116") and child ~= ObtainedNewFish then _lIlIIIllIl[#_lIlIIIllIl + 0x1] = child.OnClientEvent:Connect( function (...) _IlIIlllIll(child.Name, ...) end
 ) _IIIIIIlIll = _IIIIIIlIll + 0x1 end
 end
 end
 ) warn("\091\086\101\099\104\110\111\115\116\093\032\082\101\109\111\116\101\032\104\111\111\107\115\058", _IIIIIIlIll, "\101\118\101\110\116\115\032\099\111\110\110\101\099\116\101\100") end
 task.spawn( function () local _lIIlIlIlII = _llIlIIIlIl.ServerWide and "\071\108\111\098\097\108\032\078\111\116\105\102\105\101\114" or "\076\111\099\097\108\032\078\111\116\105\102\105\101\114" _lIllIIlIll(_IllIlllIII(_lIlllllllI.Name, _lIIlIlIlII)) end
 ) warn("\091\086\101\099\104\110\111\115\116\093\032\087\101\098\104\111\111\107\032\078\111\116\105\102\105\101\114\032\069\078\065\066\076\069\068\032\124\032\077\111\100\101\058", _llIlIIIlIl.ServerWide and "\071\108\111\098\097\108\045\078\111\116\105\102\105\101\114" or "\076\111\099\097\108\045\078\111\116\105\102\105\101\114") end
 local function _llIlIIIIlI() _llIlIIIlIl.Active = false for _, conn in ipairs(_lIlIIIllIl) do pcall( function () conn:Disconnect() end
 ) end
 _lIlIIIllIl = {} warn("\091\086\101\099\104\110\111\115\116\093\032\087\101\098\104\111\111\107\032\078\111\116\105\102\105\101\114\032\068\073\083\065\066\076\069\068\032\124\032\084\111\116\097\108\032\078\111\116\105\102\058", _llIlIIIlIl.LogCount) end
 local _IIlllIIIIl = _lIIIllIIll:CreateWindow({ Name = "\086\101\099\104\110\111\115\116", Icon = "\119\101\098\104\111\111\107", LoadingTitle = "\086\101\099\104\110\111\115\116\032\087\101\098\104\111\111\107\032\078\111\116\105\102\105\101\114", LoadingSubtitle = "\066\101\116\097", Theme = "\068\101\102\097\117\108\116", ToggleUIKeybind = "\086", DisableRayfieldPrompts = true, DisableBuildWarnings = true, ConfigurationSaving = { Enabled = true, FolderName = "\086\101\099\104\110\111\115\116", FileName = "\086\101\099\104\110\111\115\116\067\111\110\102\105\103" }, KeySystem = false, KeySettings = { Title = "\086\101\099\104\110\111\115\116\032\065\099\099\101\115\115", Subtitle = "\065\117\116\104\101\110\116\105\099\097\116\105\111\110\032\082\101\113\117\105\114\101\100", Note = "\074\111\105\110\032\111\117\114\032\100\105\115\099\111\114\100\032\116\111\032\103\101\116\032\107\101\121\092\110\032\104\116\116\112\115\058\047\047\100\105\115\099\111\114\100\046\103\103\047\118\101\099\104\110\111\115\116", FileName = "\086\101\099\104\110\111\115\116\075\101\121", SaveKey = true, GrabKeyFromSite = false, Key = {"\086\101\099\104\110\111\115\116\045\078\111\116\105\102\105\101\114\045\057\057\057\057"} }, }) local _IlIlIIlIIl = _llIIIIIIIl:FindFirstChild(_lllIIIIIII.Mobile) if _IlIlIIlIIl then _IlIlIIlIIl:Destroy() end
 local _IIlIlIIIIl = Instance.new("\083\099\114\101\101\110\071\117\105") _IIlIlIIIIl.Name = _lllIIIIIII.Mobile _IIlIlIIIIl.ResetOnSpawn = false _IIlIlIIIIl.Parent = _llIIIIIIIl local _lIIlIlIIll = Instance.new("\073\109\097\103\101\066\117\116\116\111\110") _lIIlIlIIll.Size = UDim2.fromOffset(0x34, 0x34) _lIIlIlIIll.Position = UDim2.fromScale(0.05, 0.5) _lIIlIlIIll.BackgroundTransparency = 0x1 _lIIlIlIIll.AutoButtonColor = false _lIIlIlIIll.BorderSizePixel = 0x0 _lIIlIlIIll.Image = "\104\116\116\112\115\058\047\047\119\119\119\046\114\111\098\108\111\120\046\099\111\109\047\097\115\115\101\116\045\116\104\117\109\098\110\097\105\108\047\105\109\097\103\101\063\097\115\115\101\116\073\100\061\049\050\055\050\051\057\055\049\053\053\049\049\051\054\055\038\119\105\100\116\104\061\052\050\048\038\104\101\105\103\104\116\061\052\050\048\038\102\111\114\109\097\116\061\112\110\103" _lIIlIlIIll.ImageTransparency = 0x0 _lIIlIlIIll.ScaleType = Enum.ScaleType.Fit _lIIlIlIIll.Parent = _IIlIlIIIIl Instance.new("\085\073\067\111\114\110\101\114", _lIIlIlIIll).CornerRadius = UDim.new(0x1, 0x0) local _lIIIIlIlIl = true _lIIlIlIIll.MouseButton1Click:Connect( function () _lIIIIlIlIl = not _lIIIIlIlIl pcall( function () _lIIIllIIll:SetVisibility(_lIIIIlIlIl) end
 ) end
 ) local _lIIlIIIIIl = false local _IIllIIlIlI = Vector2.zero _lIIlIlIIll.InputBegan:Connect( function (input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then _lIIlIIIIIl = true _IIllIIlIlI = UserInputService:GetMouseLocation() - _lIIlIlIIll.AbsolutePosition input.Changed:Connect( function () if input.UserInputState == Enum.UserInputState.End then _lIIlIIIIIl = false end
 end
 ) end
 end
 ) RunService.RenderStepped:Connect( function () if not _lIIlIIIIIl then return end
 local _IIIIllIIlI = UserInputService:GetMouseLocation() local _lllllIIIlI = _IIIIllIIlI - _IIllIIlIlI local _IllIlIIIIl = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(0x780, 0x438) local _IlIIllllII = _lIIlIlIIll.AbsoluteSize local _IIIIlIIIll = math.clamp(_lllllIIIlI.X, 0x0, _IllIlIIIIl.X - _IlIIllllII.X) local _lIIIIlIIll = math.clamp(_lllllIIIlI.Y, 0x0, _IllIlIIIIl.Y - _IlIIllllII.Y) _lIIlIlIIll.Position = UDim2.fromOffset(_IIIIlIIIll, _lIIIIlIIll) end
 ) local _lIIllIlIlI = _IIlllIIIIl:CreateTab("\083\101\116\117\112\032\087\101\098\104\111\111\107", "\119\101\098\104\111\111\107") local _IIIlllllII = _IIlllIIIIl:CreateTab("\083\101\116\116\105\110\103\115", "\115\101\116\116\105\110\103\115") _lIIllIlIlI:CreateSection("\082\097\114\105\116\121\032\070\105\108\116\101\114") _lIIllIlIlI:CreateDropdown({ Name = "\070\105\108\116\101\114\032\098\121\032\082\097\114\105\116\121", Options = _IIlIIIlIlI, CurrentOption = {}, MultipleOptions = true, Flag = "\082\097\114\105\116\121\070\105\108\116\101\114", Callback = function (Options) _llIlIIIlIl.SelectedRarities = {} for _, value in ipairs(Options or {}) do if type(value) == "\115\116\114\105\110\103" then local _IIllIIlIII = _lIIIIlllII[value] if _IIllIIlIII then _llIlIIIlIl.SelectedRarities[_IIllIIlIII] = true end
 end
 end
 if next(_llIlIIIlIl.SelectedRarities) == nil then _lIIIllIIll:Notify({ Title = "\086\101\099\104\110\111\115\116", Content = "\070\105\108\116\101\114\058\032\097\108\108\032\114\097\114\105\116\121", Duration = 0x2 }) else _lIIIllIIll:Notify({ Title = "\086\101\099\104\110\111\115\116", Content = "\070\105\108\116\101\114\032\114\097\114\105\116\121\032\117\112\100\097\116\101\100", Duration = 0x2 }) end
 end
 }) _lIIllIlIlI:CreateSection("\083\101\116\117\112\032\087\101\098\104\111\111\107") local _IlIIIIlIll = "" _lIIllIlIlI:CreateInput({ Name = "\068\105\115\099\111\114\100\032\087\101\098\104\111\111\107\032\085\082\076", CurrentValue = "", PlaceholderText = "\104\116\116\112\115\058\047\047\100\105\115\099\111\114\100\046\099\111\109\047\097\112\105\047\119\101\098\104\111\111\107\047\046\046\046", RemoveTextAfterFocusLost = false, Flag = "\087\101\098\104\111\111\107\085\114\108", Callback = function (Text) _IlIIIIlIll = tostring(Text) end
 }) _lIIllIlIlI:CreateButton({ Name = "\083\097\118\101\032\087\101\098\104\111\111\107\032\085\082\076", Callback = function () local _llIIIIIIll = _IlIIIIlIll:gsub("\037\115\043", "") if not _llIIIIIIll:match("\094\104\116\116\112\115\058\047\047\100\105\115\099\111\114\100\046\099\111\109\047\097\112\105\047\119\101\098\104\111\111\107\115\047") and not _llIIIIIIll:match("\094\104\116\116\112\115\058\047\047\099\097\110\097\114\121\046\100\105\115\099\111\114\100\046\099\111\109\047\097\112\105\047\119\101\098\104\111\111\107\115\047") then _lIIIllIIll:Notify({ Title = "\086\101\099\104\110\111\115\116", Content = "\085\082\076\032\119\101\098\104\111\111\107\032\116\105\100\097\107\032\118\097\108\105\100\033", Duration = 0x3 }) return end
 _llIlIIIlIl.Url = _llIIIIIIll _lIIIllIIll:Notify({ Title = "\086\101\099\104\110\111\115\116", Content = "\087\101\098\104\111\111\107\032\085\082\076\032\116\101\114\115\105\109\112\097\110\033", Duration = 0x2 }) end
 }) _lIIllIlIlI:CreateSection("\078\111\116\105\102\105\101\114\032\077\111\100\101") _lIIllIlIlI:CreateToggle({ Name = "\076\111\099\097\108\032\047\032\071\108\111\098\097\108\032\077\111\100\101", CurrentValue = true, Flag = "\083\101\114\118\101\114\078\111\116\105\102\105\101\114\077\111\100\101", Callback = function (Value) _llIlIIIlIl.ServerWide = Value _lIIIllIIll:Notify({ Title = "\086\101\099\104\110\111\115\116", Content = Value and "\077\111\100\101\058\032\071\108\111\098\097\108\032\083\101\114\118\101\114" or "\077\111\100\101\058\032\076\111\099\097\108\032\083\101\114\118\101\114", Duration = 0x2 }) end
 }) _lIIllIlIlI:CreateSection("\067\111\110\116\114\111\108\108\101\114") _lIIllIlIlI:CreateToggle({ Name = "\069\110\097\098\108\101\032\087\101\098\104\111\111\107\032\076\111\103\103\101\114", CurrentValue = false, Flag = "\076\111\103\103\101\114\069\110\097\098\108\101\100", Callback = function (Value) if Value then if _llIlIIIlIl.Url == "" then _lIIIllIIll:Notify({ Title = "\086\101\099\104\110\111\115\116", Content = "\087\101\098\104\111\111\107\032\085\082\076\032\110\111\116\032\102\111\117\110\100\033", Duration = 0x3 }) return end
 _lIllIlIlIl() _lIIIllIIll:Notify({ Title = "\086\101\099\104\110\111\115\116", Content = "\078\111\116\105\102\105\101\114\032\097\099\116\105\118\101\033", Duration = 0x2 }) else _llIlIIIIlI() _lIIIllIIll:Notify({ Title = "\086\101\099\104\110\111\115\116", Content = "\078\111\116\105\102\105\101\114\032\115\116\111\112\112\101\100", Duration = 0x2 }) end
 end
 }) local _lIllIlIIll = _lIIllIlIlI:CreateParagraph({ Title = "\086\101\099\104\110\111\115\116\032\083\116\097\116\117\115", Content = "\083\116\097\116\117\115\058\032\079\102\102\108\105\110\101" }) task.spawn( function () while true do task.wait(0x2) if _lIllIlIIll then pcall( function () if _llIlIIIlIl.Active then _lIllIlIIll:Set({ Title = "\078\111\116\105\102\105\101\114\032\083\116\097\116\117\115", Content = string.format( "\083\116\097\116\117\115\058\032\065\099\116\105\118\101\092\110\077\111\100\101\058\032\037\115\092\110\084\111\116\097\108\032\076\111\103\058\032\037\100\032\102\105\115\104", _llIlIIIlIl.ServerWide and "\071\108\111\098\097\108\032\083\101\114\118\101\114" or "\076\111\099\097\108\032\083\101\114\118\101\114", _llIlIIIlIl.LogCount ) }) else _lIllIlIIll:Set({ Title = "\078\111\116\105\102\105\101\114\032\083\116\097\116\117\115", Content = "\083\116\097\116\117\115\058\032\079\102\102\108\105\110\101" }) end
 end
 ) end
 end
 end
 ) _IIIlllllII:CreateSection("\073\110\102\111\114\109\097\116\105\111\110") _IIIlllllII:CreateParagraph({ Title = "\086\101\099\104\110\111\115\116\032\087\101\098\104\111\111\107\032\078\111\116\105\102\105\101\114", Content = "\066\101\116\097\032\086\101\114\115\105\111\110\092\110\078\111\116\105\102\105\101\114\032\070\105\115\104\032\067\097\117\103\104\116\092\110\102\105\115\104\032\110\111\116\105\102\105\099\097\116\105\111\110\115\032\102\114\111\109\032\097\108\108\032\112\108\097\121\101\114\115\032\111\110\032\116\104\101\032\115\101\114\118\101\114\092\110\092\110\098\121\032\100\105\115\099\111\114\100\046\103\103\047\118\101\099\104\110\111\115\116" }) _IIIlllllII:CreateSection("\084\101\115\116\032\077\111\100\101") _IIIlllllII:CreateButton({ Name = "\084\101\115\116\032\087\101\098\104\111\111\107", Callback = function () if _llIlIIIlIl.Url == "" then _lIIIllIIll:Notify({ Title = "\086\101\099\104\110\111\115\116", Content = "\073\115\105\032\119\101\098\104\111\111\107\032\085\082\076\032\100\117\108\117\033", Duration = 0x3 }) return end
 task.spawn( function () _lIllIIlIll(_IIIIlllllI(_lIlllllllI.Name)) end
 ) _lIIIllIIll:Notify({ Title = "\086\101\099\104\110\111\115\116", Content = "\083\101\110\100\105\110\103\032\084\101\115\116\032\078\111\116\105\102\105\101\114\033", Duration = 0x2 }) end
 }) _IIIlllllII:CreateButton({ Name = "\082\101\115\101\116\032\067\111\117\110\116\101\114", Callback = function () _llIlIIIlIl.LogCount = 0x0 _llIlIIIlIl.SentUUID = {} _lIIIllIIll:Notify({ Title = "\086\101\099\104\110\111\115\116", Content = "\067\111\117\110\116\101\114\032\082\101\115\101\116\101\100\033", Duration = 0x2 }) end
 }) _lIIIllIIll:LoadConfiguration() warn("\091\086\101\099\104\110\111\115\116\093\032\087\101\098\104\111\111\107\032\078\111\116\105\102\105\101\114\032\076\111\097\100\101\100\033") warn("\091\086\101\099\104\110\111\115\116\093\032\084\111\103\103\108\101\032\071\085\073\058\032\099\108\105\099\107\032\086\032\111\114\032\080\114\101\115\115\032\108\111\103\111\032\102\108\111\097\116\105\110\103") end
 )(...)
