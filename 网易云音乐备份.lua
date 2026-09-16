--[[
    网易云音乐 for Roblox  —— 免责声明 / Disclaimer
    ------------------------------------------------------------------
    1. 本项目为个人技术学习与交流用途，禁止用于任何商业用途。
    2. 音乐作品的著作权归网易云音乐及各自权利人所有；本项目不存储、
       不缓存、不分发任何音频文件，仅转发官方接口返回的临时直链。
    3. 登录功能调用网易云官方接口，请自行评估账号风险，建议使用小号；
       作者不对账号封禁、数据丢失等承担任何责任。
    4. 本项目依赖第三方服务与接口，可能随时失效或变更，作者不保证
       任何功能在当前或未来可用，亦不提供任何形式的担保。
    5. 下载或使用本脚本即视为您已阅读并同意上述条款；若不同意请立即
       停止使用并删除。请在支持正版的前提下合理使用。
    ------------------------------------------------------------------
]]
local __ncmErrLabel = nil
local __ncmErrGui  = nil
local __ncmErrWhy  = "no-error"
local __ea, __eb = pcall(function()
    local LP0 = game:GetService("Players").LocalPlayer
    local par
    pcall(function() par = game:GetService("CoreGui") end)
    if not par then
        par = LP0:FindFirstChildOfClass("PlayerGui")
        if not par then par = LP0:WaitForChild("PlayerGui", 5) end
    end
    if not par then return end
    local sg = Instance.new("ScreenGui")
    sg.Name = "NCM_ERROR"
    sg.ResetOnSpawn = false
    sg.DisplayOrder = 2147483647
    sg.Enabled = false
    sg.Parent = par
    local fr = Instance.new("Frame")
    fr.Size = UDim2.new(0.9, 0, 0.75, 0)
    fr.Position = UDim2.new(0.05, 0, 0.12, 0)
    fr.BackgroundColor3 = Color3.fromRGB(28, 8, 8)
    fr.BorderSizePixel = 0
    fr.Parent = sg
    pcall(function()
        local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 12); c.Parent = fr
    end)
    local sc = Instance.new("ScrollingFrame")
    sc.Size = UDim2.new(1, -20, 1, -50)
    sc.Position = UDim2.new(0, 10, 0, 40)
    sc.BackgroundTransparency = 1
    sc.ScrollBarThickness = 8
    sc.CanvasSize = UDim2.new(0, 0, 8, 0)
    sc.Parent = fr
    local ti = Instance.new("TextLabel")
    ti.Size = UDim2.new(1, -10, 0, 32)
    ti.Position = UDim2.new(0, 8, 0, 6)
    ti.BackgroundTransparency = 1
    ti.Text = "网易云音乐 - 运行错误 (截图发给开发者)"
    ti.TextColor3 = Color3.fromRGB(255, 90, 90)
    ti.TextScaled = true
    ti.Font = Enum.Font.GothamBold
    ti.Parent = fr
    local tb = Instance.new("TextLabel")
    tb.Size = UDim2.new(1, -10, 8, 0)
    tb.BackgroundTransparency = 1
    tb.Text = ""
    tb.TextColor3 = Color3.fromRGB(255, 230, 230)
    tb.TextSize = 15
    tb.Font = Enum.Font.Code
    tb.TextXAlignment = Enum.TextXAlignment.Left
    tb.TextYAlignment = Enum.TextYAlignment.Top
    tb.TextWrapped = true
    tb.Parent = sc
    __ncmErrLabel = tb
    __ncmErrGui = sg
end)
if not __ea then __ncmErrWhy = tostring(__eb) end

local function __ncmShow(msg)
    pcall(function()
        if __ncmErrLabel then
            __ncmErrLabel.Text = tostring(msg)
            __ncmErrGui.Enabled = true
        end
    end)
end

local function __NCM_Main()
local CFG = {
    Api     = "https://ncm-api.meisdad321.workers.dev",
    TempDir = "NetMusicTemp",
    VolDir  = "NetMusicCfg",
}

local task = task or {
    spawn = function(f, ...) return (spawn or coroutine.wrap)(f, ...) end,
    wait  = function(t) return (wait or function() end)(t) end,
    delay = function(t, f) return (delay or spawn)(t, f) end,
    cancel= function(t) end,
}
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local RunService  = game:GetService("RunService")
local UIS         = game:GetService("UserInputService")
local Camera      = workspace.CurrentCamera
local LP          = game:GetService("Players").LocalPlayer
local PlayerGui   = LP:WaitForChild("PlayerGui")

local AccCookie  = ""
local openArtist = nil
local COOKIE_FILE = CFG.VolDir .. "/cookie.json"

local CoreGui = nil
pcall(function() CoreGui = game:GetService("CoreGui") end)
local guiParent = PlayerGui
pcall(function()
    if CoreGui then
        local t = Instance.new("Folder"); t.Parent = CoreGui; t:Destroy()
        guiParent = CoreGui
    end
end)

local COL = {
    Red    = Color3.fromRGB(194, 12, 12),
    RedL   = Color3.fromRGB(236, 65, 65),
    Side   = Color3.fromRGB(246, 246, 248),
    Body   = Color3.fromRGB(255, 255, 255),
    Card   = Color3.fromRGB(255, 255, 255),
    CardH  = Color3.fromRGB(245, 245, 248),
    Bottom = Color3.fromRGB(250, 250, 252),
    Text   = Color3.fromRGB(51, 51, 51),
    Sub    = Color3.fromRGB(153, 153, 153),
    Line   = Color3.fromRGB(230, 230, 234),
    White  = Color3.fromRGB(255, 255, 255),
    Gold   = Color3.fromRGB(212, 167, 92),
}

local IC = {
    Close  = "X",
    Min    = "-",
    Play   = "▶",
    Pause  = "||",
    Prev   = "|<",
    Next   = ">|",
    Vol    = "♪",
    Lyric  = "≡",
    Search = "◎",
    FavOff = "♡",
    FavOn  = "♥",
    Collapse  = "»",
    CollapseL = "«",
    Dock   = "♪",
}

local SPEEDS = {
    {v = 0.50, t = "0.5x"},
    {v = 0.75, t = "0.75x"},
    {v = 1.00, t = "1.0x"},
    {v = 1.25, t = "1.25x"},
    {v = 1.50, t = "1.5x"},
    {v = 1.75, t = "1.75x"},
    {v = 2.00, t = "2.0x"},
}
local SPEED_MIN  = 0.5
local SPEED_STEP = 0.25
local function speedToRatio(v)
    return (v - SPEED_MIN) / (SPEED_STEP * (#SPEEDS - 1))
end
local function ratioToIndex(r)
    local i = math.floor(r * (#SPEEDS - 1) + 0.5) + 1
    if i < 1 then i = 1 end
    if i > #SPEEDS then i = #SPEEDS end
    return i
end

local function corner(p, r)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(r or 0.1, 0); c.Parent = p; return c
end
local function circle(p)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0.5, 0); c.Parent = p; return c
end
local function stroke(p, col, th)
    local s = Instance.new("UIStroke"); s.Color = col or COL.Line; s.Thickness = th or 1; s.Parent = p; return s
end
local function mkLabel(parent, size, pos, text, col, font, xalign)
    local l = Instance.new("TextLabel")
    l.Size = size; l.Position = pos
    l.BackgroundTransparency = 1
    l.Text = text or ""
    l.TextColor3 = col or COL.Text
    l.TextScaled = true
    l.Font = font or Enum.Font.Gotham
    l.TextXAlignment = xalign or Enum.TextXAlignment.Left
    l.Parent = parent
    return l
end
local function mkBtn(parent, size, pos, text, col, bgTrans)
    local b = Instance.new("TextButton")
    b.Size = size; b.Position = pos
    b.BackgroundTransparency = bgTrans or 1
    b.BackgroundColor3 = COL.Card
    b.BorderSizePixel = 0
    b.Text = text or ""
    b.TextColor3 = col or COL.Text
    b.TextScaled = true
    b.Font = Enum.Font.GothamBold
    b.AutoButtonColor = false
    b.Parent = parent
    return b
end
local function pressAnim(btn)
    local s = Instance.new("UIScale"); s.Scale = 1; s.Parent = btn
    btn.MouseButton1Down:Connect(function()
        TweenService:Create(s, TweenInfo.new(0.08, Enum.EasingStyle.Quad), {Scale = 0.86}):Play()
    end)
    local function up()
        TweenService:Create(s, TweenInfo.new(0.20, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
    end
    btn.MouseButton1Up:Connect(up)
    btn.MouseLeave:Connect(up)
    return s
end
local function popIn(obj, from, dur)
    local s = obj:FindFirstChildOfClass("UIScale")
    if not s then s = Instance.new("UIScale"); s.Parent = obj end
    s.Scale = from or 0.88
    TweenService:Create(s, TweenInfo.new(dur or 0.30, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
end
local UI = {}
UI.DeskCfg = {on = false, fs = 2, ol = true, dual = true, lock = false}

local function tw(obj, props, dur, style)
    pcall(function()
        local reg = UI._twreg
        if not reg then reg = {}; UI._twreg = reg end
        local m = reg[obj]
        if not m then m = {}; reg[obj] = m end
        for k in pairs(props) do
            local old = m[k]
            if old then pcall(function() old:Cancel() end); m[k] = nil end
        end
        local t = TweenService:Create(obj, TweenInfo.new(dur or 0.25, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
        for k in pairs(props) do m[k] = t end
        t:Play()
    end)
end

local function _get(name)
    local ok, v = pcall(function() return getfenv()[name] end)
    if ok and v ~= nil then return v end
    local ok2, v2 = pcall(function() return _G[name] end)
    if ok2 and v2 ~= nil then return v2 end
    return nil
end
local rawRequest = (type(_G.syn) == "table" and _G.syn.request) or _get("request") or _get("http_request") or _get("httprequest")
local fnWrite = _get("writefile")
local fnRead  = _get("readfile")
local fnIsFile = _get("isfile")
local fnIsFolder = _get("isfolder")
local fnMakeDir = _get("makefolder")
local fnDelFile = _get("delfile")
local fnList   = _get("listfiles")
local fnAsset  = _get("getcustomasset") or _get("getsynasset")

local function ensureDir(d)
    pcall(function() if fnIsFolder and not fnIsFolder(d) then fnMakeDir(d) end end)
end
local function fileExists(p)
    if not fnIsFile then return false end
    local ok, r = pcall(fnIsFile, p); return ok and r == true
end

local function isErrBody(b)
    if type(b) ~= "string" then return true end
    local h = b:sub(1, 1)
    if h == "{" or h == "<" then return true end
    if #b < 1024 then return true end
    return false
end

local function saveBody(body, path)
    if not fnWrite then return nil, "无 writefile" end
    local ok, err = pcall(fnWrite, path, body)
    if ok then return path end

    local p2 = path:gsub("/", "\\")
    local ok2 = pcall(fnWrite, p2, body)
    if ok2 then return p2 end
    return nil, "writefile 失败: " .. tostring(err)
end

local function urlEncode(s)
    return tostring(s or ""):gsub("([^%w%-_%.~])", function(c) return string.format("%%%02X", string.byte(c)) end)
end

local function cookieParam(path)
    if AccCookie == nil or AccCookie == "" then return "" end
    if type(path) == "string" then
        if path:find("/login/sms", 1, true) or path:find("/login/verify", 1, true) then return "" end
    end
    local sep = "?"
    if type(path) == "string" and path:find("?", 1, true) then sep = "&" end
    return sep .. "cookie=" .. urlEncode(AccCookie)
end

local function downloadViaWorker(id, path)
    if not rawRequest then return nil end
    local ok, res = pcall(function()
        local dlPath = "/dl?id=" .. tostring(id)
        return rawRequest({Url = CFG.Api .. dlPath .. cookieParam(dlPath), Method = "GET"})
    end)
    if ok and res and res.Body and not isErrBody(res.Body) then
                return saveBody(res.Body, path)
    end
    return nil
end

local function downloadDirect(url, path)
    if not rawRequest then return nil, "无 request" end
    local UA = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
    local urls
    if url:sub(1,5) == "https" then
        urls = { url, "http" .. url:sub(6) }
    else
        urls = { "https" .. url:sub(5), url }
    end
    local lastErr = "未知"
    for attempt = 1, 2 do
        for _, u in ipairs(urls) do
            local ok, res = pcall(function()
                return rawRequest({
                    Url = u, Method = "GET",
                    Headers = {
                        ["User-Agent"] = UA,
                        ["Referer"] = "https://music.163.com/",
                        ["Accept"] = "*/*",
                    },
                })
            end)
            if ok and res and res.Body then
                local b = res.Body
                local code = tostring(res.StatusCode or res.Status or "?")
                                if not isErrBody(b) then
                    local p, e = saveBody(b, path)
                    if p then return p end
                    lastErr = tostring(e)
                else
                    lastErr = "非音频 len=" .. tostring(#b)
                end
            else
                lastErr = "request 异常"
            end
        end
        task.wait(0.5)
    end
    return nil, lastErr
end

local function downloadMp3(url, path, id)
    if not rawRequest then return nil, "无 request 函数" end
    if not fnWrite then return nil, "无 writefile 函数" end

    if id then
        local p = downloadViaWorker(id, path)
        if p then return p end
            end

    return downloadDirect(url, path)
end

local function jsonDecode(s)
    local ok, r = pcall(function() return HttpService:JSONDecode(s) end)
    if ok then return r end
    return nil
end

local function apiGet(path)
    local url = CFG.Api .. path .. cookieParam(path)
    if rawRequest then
        local ok, res = pcall(function() return rawRequest({Url = url, Method = "GET"}) end)
        if ok and res and res.Body and res.Body ~= "" then
            local d = jsonDecode(res.Body)
            if d then return d end
        end
    end
    local ok2, r = pcall(function() return game:HttpGet(url, true) end)
    if ok2 and r and r ~= "" then return jsonDecode(r) end
    return nil
end
function splitNames(str)
    local list = {}
    for part in string.gmatch(tostring(str or ""), "[^/&、,，]+") do
        local t = string.gsub(part, "^%s+", "")
        t = string.gsub(t, "%s+$", "")
        if t ~= "" then table.insert(list, t) end
    end
    return list
end
function parseArtists(s, fbName, fbId)
    local list = {}
    for _, a in ipairs((s and (s.artists or s.ar)) or {}) do
        if type(a) == "table" then
            local nm = tostring(a.name or "")
            if nm ~= "" then table.insert(list, {name = nm, id = tostring(a.id or "")}) end
        end
    end
    if #list == 0 then
        for i, nm in ipairs(splitNames(fbName or (s and s.artist))) do
            table.insert(list, {name = nm, id = (i == 1 and fbId) or ""})
        end
    end
    return list
end
local function apiSearch(kw)
    local d = apiGet("/search?keywords=" .. urlEncode(kw) .. "&limit=30")
    if not d or not d.result or not d.result.songs then return {} end
    local out = {}
    for _, s in ipairs(d.result.songs) do
        local artists = parseArtists(s, nil, nil)
        local n = {}
        for _, a in ipairs(artists) do table.insert(n, a.name) end
        table.insert(out, {id = tostring(s.id), name = s.name or "未知",
            artist = table.concat(n, " / "), dur = (s.duration or 0)/1000, fee = s.fee or 0,
            artistId = (artists[1] and artists[1].id) or "", artists = artists})
    end
    return out
end
local function apiArtistSongs(artistName, artistId)
    local res = {}
    if artistId and artistId ~= "" then
        local d = apiGet("/artist?id=" .. urlEncode(artistId))
        local songs = d and (d.hotSongs or (d.artist and d.artist.hotSongs) or d.songs)
        if type(songs) == "table" and #songs > 0 then
            for _, s in ipairs(songs) do
                local artists = parseArtists(s, nil, artistId)
                local n = {}
                for _, a in ipairs(artists) do table.insert(n, a.name) end
                table.insert(res, {id = tostring(s.id), name = s.name or "未知",
                    artist = table.concat(n, " / "), dur = (s.dt or s.duration or 0)/1000,
                    fee = s.fee or 0, artistId = tostring(artistId), artists = artists})
            end
            return res
        end
    end
    local d = apiGet("/search?keywords=" .. urlEncode(artistName or "") .. "&limit=60")
    if not d or not d.result or not d.result.songs then return res end
    for _, s in ipairs(d.result.songs) do
        local hit = false
        local artists = parseArtists(s, nil, nil)
        local n = {}
        for _, a in ipairs(artists) do
            if artistId ~= "" then
                if a.id == tostring(artistId) then hit = true end
            elseif a.name == tostring(artistName or "") then
                hit = true
            end
            table.insert(n, a.name)
        end
        if hit then
            table.insert(res, {id = tostring(s.id), name = s.name or "未知",
                artist = table.concat(n, " / "), dur = (s.duration or 0)/1000,
                fee = s.fee or 0, artistId = tostring(artistId), artists = artists})
        end
    end
    return res
end

local function parseLrc(lrc)
    local list = {}
    for line in tostring(lrc or ""):gmatch("[^\r\n]+") do
        local m, s, txt = line:match("^%[(%d+):(%d+[%.%d]*)%]%s*(.*)$")
        if m and s then table.insert(list, {t = tonumber(m)*60+tonumber(s), text = (txt ~= "" and txt) or "..."}) end
    end
    table.sort(list, function(a,b) return a.t < b.t end)
    return list
end
local function apiUrl(id)
    local d = apiGet("/song/url/v1?id=" .. tostring(id))
    if d and d.data and d.data[1] and d.data[1].url then return d.data[1] end
    return nil
end

local ProbeCache = {}
local RowRefs    = {}
local ProbeRunning = false

local function setVipMark(lbl, st)
    if not lbl then return end
    if st == nil then
        lbl.Text = ".."
        lbl.TextColor3 = COL.Sub
    elseif st == false then
        lbl.Text = "VIP"
        lbl.TextColor3 = COL.Gold
    else
        lbl.Text = ""
        lbl.TextColor3 = COL.Sub
    end
end

local function markProbe(id, ok)
    ProbeCache[id] = ok
    for _, r in ipairs(RowRefs) do
        if r.song and r.song.id == id then
            setVipMark(r.vip, ok)
            if ok == false and r.row then
                r.row.BackgroundTransparency = 0.62
            end
        end
    end
end
local function apiLyricRaw(id)
    local d = apiGet("/lyric?id=" .. tostring(id))
    if not d then return "" end
    return (d.lrc and d.lrc.lyric) or ""
end

local State = {Queue = {}, Index = 0, Playing = false, Lyrics = {}, LyricLine = 0,
    Loading = false, Favorites = {}, SearchQueue = {}, ArtistQueue = {}, Mode = 1, CurPage = "home", CurNav = 1, LastListPage = "home", Volume = 0.7, Muted = false, SpeedIdx = 3, PitchLink = true, ArtistPickerSong = nil, Closed = false}
local ModeNames = {"顺序", "单曲", "随机"}
local ModeChars = {"→", "∞", "⇆"}
local CurrentSong = nil

function UI.setCol(btn, col)
    local reg = UI._twreg
    if reg and reg[btn] and reg[btn].TextColor3 then
        pcall(function() reg[btn].TextColor3:Cancel() end)
        reg[btn].TextColor3 = nil
    end
    btn.TextColor3 = col
end
local applyAudio = nil

pcall(function()
    if fnIsFile and fnRead then
        local f = CFG.VolDir .. "/volume.json"
        if fnIsFile(f) then
            local d = jsonDecode(fnRead(f))
            if d then
                if type(d.volume) == "number" then State.Volume = math.clamp(d.volume, 0, 1) end
                if type(d.muted) == "boolean" then State.Muted = d.muted end
            end
        end
    end
end)
local function saveVol()
    pcall(function()
        ensureDir(CFG.VolDir)
        if fnWrite then fnWrite(CFG.VolDir .. "/volume.json",
            HttpService:JSONEncode({volume = State.Volume, muted = State.Muted})) end
    end)
end

do
    local B64C = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local B64L = {}
    for i = 1, 64 do B64L[B64C:sub(i, i)] = i - 1 end
    local OBFK = "NCM-RBXL-SEC-2026"
    function __NCM_b64e(data)
        local out = {}
        for i = 1, #data, 3 do
            local a, b, c = data:byte(i, i + 2)
            local n = (a or 0) * 65536 + (b or 0) * 256 + (c or 0)
            local i1 = math.floor(n / 262144) % 64
            local i2 = math.floor(n / 4096) % 64
            local i3 = math.floor(n / 64) % 64
            local i4 = n % 64
            out[#out + 1] = B64C:sub(i1 + 1, i1 + 1)
            out[#out + 1] = B64C:sub(i2 + 1, i2 + 1)
            out[#out + 1] = b and B64C:sub(i3 + 1, i3 + 1) or "="
            out[#out + 1] = c and B64C:sub(i4 + 1, i4 + 1) or "="
        end
        return table.concat(out)
    end
    function __NCM_b64d(str)
        local out, acc, bits = {}, 0, 0
        for i = 1, #str do
            local ch = str:sub(i, i)
            if ch == "=" then break end
            local v = B64L[ch]
            if v then
                acc = acc * 64 + v
                bits = bits + 6
                if bits >= 8 then
                    bits = bits - 8
                    local p = 2 ^ bits
                    out[#out + 1] = string.char(math.floor(acc / p) % 256)
                    acc = acc % p
                end
            end
        end
        return table.concat(out)
    end
    function __NCM_maskPhone(p)
        if type(p) ~= "string" or #p < 8 then return "***" end
        return p:sub(1, 3) .. "****" .. p:sub(#p - 3)
    end
    function __NCM_enc(s)
        if type(s) ~= "string" or s == "" then return nil end
        local src, kl, out = s, #OBFK, {}
        for i = 1, #src do
            out[i] = string.char((src:byte(i) + OBFK:byte((i - 1) % kl + 1)) % 256)
        end
        local ok, r = pcall(function() return "NCM1:" .. __NCM_b64e(table.concat(out)) end)
        if ok then return r end
        return nil
    end
    function __NCM_dec(s)
        if type(s) ~= "string" or s:sub(1, 5) ~= "NCM1:" then return nil end
        local ok, raw = pcall(function() return __NCM_b64d(s:sub(6)) end)
        if not ok or type(raw) ~= "string" or raw == "" then return nil end
        local kl, out = #OBFK, {}
        for i = 1, #raw do
            out[i] = string.char((raw:byte(i) - OBFK:byte((i - 1) % kl + 1)) % 256)
        end
        return table.concat(out)
    end
end

local saveCookie

local function loadCookie()
    if not (fnRead and fnIsFile) then return end
    pcall(function()
        if fnIsFile(COOKIE_FILE) then
            local d = jsonDecode(fnRead(COOKIE_FILE) or "")
            if d then
                if type(d.d) == "string" then
                    local p = __NCM_dec(d.d)
                    if p and p ~= "" then AccCookie = p; return end
                end
                if type(d.cookie) == "string" and d.cookie ~= "" then
                    AccCookie = d.cookie
                    saveCookie(AccCookie)
                end
            end
        end
    end)
end

saveCookie = function(c)
    AccCookie = tostring(c or "")
    pcall(function()
        ensureDir(CFG.VolDir)
        if not fnWrite then return end
        local enc = __NCM_enc(AccCookie)
        if enc then
            fnWrite(COOKIE_FILE, HttpService:JSONEncode({v = 2, d = enc}))
        else
            fnWrite(COOKIE_FILE, HttpService:JSONEncode({v = 1, cookie = AccCookie}))
        end
    end)
end
loadCookie()

local AUD_FILE = CFG.VolDir .. "/audio.json"
local function snapSpeedIdx(v)
    if type(v) ~= "number" then return 2 end
    local best, bd = 2, 1e9
    for i, sp in ipairs(SPEEDS) do
        local d = math.abs(sp.v - v)
        if d < bd then bd = d; best = i end
    end
    return best
end
pcall(function()
    if fnIsFile and fnRead and fnIsFile(AUD_FILE) then
        local d = jsonDecode(fnRead(AUD_FILE))
        if d then
            if type(d.sv) == "number" then State.SpeedIdx = snapSpeedIdx(d.sv) end
            if type(d.link) == "boolean" then State.PitchLink = d.link end
        end
    end
end)
local function saveAudio()
    pcall(function()
        ensureDir(CFG.VolDir)
        if fnWrite then fnWrite(AUD_FILE, HttpService:JSONEncode({sv = (SPEEDS[State.SpeedIdx] or SPEEDS[3]).v, link = State.PitchLink})) end
    end)
end

local FAV_FILE = CFG.VolDir .. "/favorites.json"
local function saveFav()
    pcall(function()
        ensureDir(CFG.VolDir)
        if fnWrite then
            local arr = {}
            for id, s in pairs(State.Favorites) do
                if type(s) == "table" then
                    table.insert(arr, {id = id, name = s.name, artist = s.artist, dur = s.dur, fee = s.fee})
                end
            end
            fnWrite(FAV_FILE, HttpService:JSONEncode(arr))
        end
    end)
end

pcall(function()
    if fnIsFile and fnRead and fnIsFile(FAV_FILE) then
        local d = jsonDecode(fnRead(FAV_FILE))
        if type(d) == "table" then
            for _, it in ipairs(d) do
                if type(it) == "table" and type(it.id) == "string" then
                    State.Favorites[it.id] = {
                        id = it.id,
                        name = it.name or "未知",
                        artist = it.artist or "",
                        dur = it.dur or 0,
                        fee = it.fee or 0,
                    }
                end
            end
        end
    end
end)

local Sound = Instance.new("Sound")
Sound.Name = "NetMusic_Sound"; Sound.Volume = State.Muted and 0 or State.Volume; Sound.Parent = workspace
local PitchFx = nil
pcall(function()
    PitchFx = Instance.new("PitchShiftSoundEffect")
    PitchFx.Octave = 1
    PitchFx.Parent = Sound
end)

local function clearTemp()
    pcall(function()
        if fnIsFolder and fnIsFolder(CFG.TempDir) and fnList then
            for _, f in ipairs(fnList(CFG.TempDir)) do pcall(fnDelFile, f) end
        end
    end)
end

function trimCache()
    pcall(function()
        if not (fnIsFolder and fnList and fnDelFile) then return end
        if not fnIsFolder(CFG.TempDir) then return end
        local files = fnList(CFG.TempDir)
        if type(files) ~= "table" or #files <= 60 then return end
        for i = 1, #files do pcall(fnDelFile, files[i]) end
    end)
end

local function playSong(song)
    if not song or State.Loading then return end
    if State.Closed then return end
    if not rawRequest then
        if UI.SetStatus then UI.SetStatus("注入器缺少 request 函数") end
        return
    end
    if not fnWrite then
        if UI.SetStatus then UI.SetStatus("注入器缺少 writefile 函数") end
        return
    end
    if not fnAsset then
        if UI.SetStatus then UI.SetStatus("注入器缺少 getcustomasset 函数") end
        return
    end
    State.Loading = true
    CurrentSong = song
    if UI.OnSongChanged then UI.OnSongChanged(song) end
    if UI.SetStatus then UI.SetStatus("加载中...") end
    task.spawn(function()
        ensureDir(CFG.TempDir)
        local info = apiUrl(song.id)
        if not info then
            markProbe(song.id, false)
            State.Loading = false
            State.Playing = false
            if UI.SetStatus then UI.SetStatus("VIP歌曲 · 当前账号无法播放") end
            if UI.OnPlayStateChanged then UI.OnPlayStateChanged(false) end
            return
        end
        local path = CFG.TempDir .. "/" .. tostring(song.id) .. ".mp3"
        local hitCache = fileExists(path)
        if not hitCache then
            local _, err = downloadMp3(info.url, path, song.id)
            if err or not fileExists(path) then
                State.Loading = false
                if UI.SetStatus then UI.SetStatus("下载失败") end
                return
            end
        end
        markProbe(song.id, true)
        if hitCache then
            if UI.SetStatus then UI.SetStatus("加载中...") end
        end
        trimCache()
        local okA, asset = pcall(fnAsset, path)
        if not okA or not asset then State.Loading = false; return end
        if State.Closed then State.Loading = false; return end
        pcall(function() Sound:Stop() end)
        Sound.SoundId = asset
        pcall(function() Sound:Play() end)
        pcall(applyAudio)
        State.Playing = true
        State.Lyrics = parseLrc(apiLyricRaw(song.id))
        State.LyricLine = 0
        State.Loading = false
        if UI.BuildLyrics then UI.BuildLyrics() end
        if UI.OnSongChanged then UI.OnSongChanged(song) end
        if UI.OnPlayStateChanged then UI.OnPlayStateChanged(true) end
        if UI.SetStatus then UI.SetStatus("") end
    end)
end

local function playIndex(i)
    if #State.Queue == 0 then return end
    if i < 1 then i = #State.Queue end
    if i > #State.Queue then i = 1 end
    State.Index = i; playSong(State.Queue[i])
end
local function nextSong() playIndex(State.Index + 1) end
local function prevSong() playIndex(State.Index - 1) end
local function togglePlay()
    if not CurrentSong then if #State.Queue > 0 then playIndex(1) end return end
    if State.Playing then Sound:Pause(); State.Playing = false else Sound:Resume(); State.Playing = true end
    if UI.OnPlayStateChanged then UI.OnPlayStateChanged(State.Playing) end
end

local lastEndTime = 0
local function handleSongEnd()
    if State.Closed then return end
    if tick() - lastEndTime < 1.2 then return end
    lastEndTime = tick()
    local mode = ModeNames[State.Mode]
    if mode == "单曲" then
        pcall(function() Sound.TimePosition = 0; Sound:Play() end)
        State.Playing = true
    elseif mode == "随机" then
        playIndex(math.random(1, math.max(1, #State.Queue)))
    else
        nextSong()
    end
end

local gui = Instance.new("ScreenGui")
gui.Name = "NetMusicPlayerV14"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 2147483647
gui.Parent = guiParent
do
    local function killOld()
        pcall(function()
            for _, o in ipairs(guiParent:GetChildren()) do
                if o ~= gui and o:IsA("ScreenGui") and o.Name == "NetMusicPlayerV14" then
                    pcall(function() o:Destroy() end)
                end
            end
        end)
        pcall(function()
            for _, o in ipairs(workspace:GetChildren()) do
                if o ~= Sound and o:IsA("Sound") and o.Name == "NetMusic_Sound" then
                    pcall(function() o:Stop() end)
                    pcall(function() o:Destroy() end)
                end
            end
        end)
    end
    killOld()
end
pcall(function() if _get("syn") and _get("syn").protect_gui then _get("syn").protect_gui(gui) end end)

local Main = Instance.new("Frame")
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.BackgroundColor3 = COL.Body
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = gui
do local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,10); c.Parent=Main end stroke(Main, COL.Line, 1)
local MainScale = Instance.new("UIScale"); MainScale.Scale = 1; MainScale.Parent = Main
do
    local asp = Camera.ViewportSize.X / math.max(1, Camera.ViewportSize.Y)
    if asp >= 1 then Main.Size = UDim2.new(0.52, 0, 0.78, 0) else Main.Size = UDim2.new(0.94, 0, 0.66, 0) end
end

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0.075, 0)
TopBar.BackgroundColor3 = COL.Red
TopBar.BorderSizePixel = 0
TopBar.Parent = Main
do
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 10); c.Parent = TopBar
    local f = Instance.new("Frame")
    f.Size = UDim2.new(0,10,0,10); f.Position = UDim2.new(0,0,1,-10)
    f.BackgroundColor3 = COL.Red; f.BorderSizePixel = 0; f.Parent = TopBar
    f = Instance.new("Frame")
    f.Size = UDim2.new(0,10,0,10); f.Position = UDim2.new(1,-10,1,-10)
    f.BackgroundColor3 = COL.Red; f.BorderSizePixel = 0; f.Parent = TopBar
end
local LogoDot = Instance.new("Frame")
LogoDot.Size = UDim2.new(0.032, 0, 0.56, 0); LogoDot.Position = UDim2.new(0.022, 0, 0.22, 0)
LogoDot.BackgroundColor3 = COL.White; LogoDot.BorderSizePixel = 0; LogoDot.Parent = TopBar; circle(LogoDot)
local LogoIn = Instance.new("Frame")
LogoIn.Size = UDim2.new(0.5, 0, 0.5, 0); LogoIn.AnchorPoint = Vector2.new(0.5, 0.5)
LogoIn.Position = UDim2.new(0.5, 0, 0.5, 0); LogoIn.BackgroundColor3 = COL.Red
LogoIn.BorderSizePixel = 0; LogoIn.Parent = LogoDot; circle(LogoIn)
mkLabel(TopBar, UDim2.new(0.28, 0, 0.7, 0), UDim2.new(0.065, 0, 0.15, 0), "网易云音乐", COL.White, Enum.Font.GothamBold)

local SearchBoxBg = Instance.new("Frame")
SearchBoxBg.Size = UDim2.new(0.32, 0, 0.62, 0); SearchBoxBg.Position = UDim2.new(0.35, 0, 0.19, 0)
SearchBoxBg.BackgroundColor3 = COL.White; SearchBoxBg.BorderSizePixel = 0
SearchBoxBg.Parent = TopBar; circle(SearchBoxBg)
local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(0.86, 0, 0.8, 0); SearchBox.Position = UDim2.new(0.07, 0, 0.1, 0)
SearchBox.BackgroundTransparency = 1
SearchBox.PlaceholderText = "搜索音乐"
SearchBox.PlaceholderColor3 = Color3.fromRGB(150,150,155)
SearchBox.Text = ""; SearchBox.TextColor3 = Color3.fromRGB(40,40,45)
SearchBox.TextScaled = true; SearchBox.Font = Enum.Font.Gotham
SearchBox.TextXAlignment = Enum.TextXAlignment.Left
SearchBox.ClearTextOnFocus = false
SearchBox.Parent = SearchBoxBg

local BtnSearch = mkBtn(TopBar, UDim2.new(0.075, 0, 0.62, 0), UDim2.new(0.685, 0, 0.19, 0), IC.Search, COL.White, 0)
BtnSearch.BackgroundColor3 = Color3.fromRGB(168,10,10); corner(BtnSearch, 0.3); pressAnim(BtnSearch)

local BtnMin = mkBtn(TopBar, UDim2.new(0.062, 0, 0.62, 0), UDim2.new(0.775, 0, 0.19, 0), IC.Min, COL.White, 1)
pressAnim(BtnMin)

local BtnClose = mkBtn(TopBar, UDim2.new(0.062, 0, 0.62, 0), UDim2.new(0.855, 0, 0.19, 0), IC.Close, COL.White, 1)
pressAnim(BtnClose)

local SideBar = Instance.new("Frame")
SideBar.Size = UDim2.new(0.215, 0, 0.785, 0); SideBar.Position = UDim2.new(0, 0, 0.075, 0)
SideBar.BackgroundColor3 = COL.Side; SideBar.BorderSizePixel = 0; SideBar.Parent = Main
mkLabel(SideBar, UDim2.new(0.9, 0, 0.05, 0), UDim2.new(0.08, 0, 0.03, 0), "发现音乐", COL.Sub, Enum.Font.GothamBold)
do
    local NavHolder = Instance.new("ScrollingFrame")
    NavHolder.Size = UDim2.new(1, 0, 1, -134)
    NavHolder.Position = UDim2.new(0, 0, 0, 34)
    NavHolder.BackgroundTransparency = 1
    NavHolder.BorderSizePixel = 0
    NavHolder.ScrollBarThickness = 0
    NavHolder.ScrollingEnabled = true
    NavHolder.AutomaticCanvasSize = Enum.AutomaticSize.Y
    NavHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
    NavHolder.Parent = SideBar
    UI.NavHolder = NavHolder
    do
        local ll = Instance.new("UIListLayout")
        ll.SortOrder = Enum.SortOrder.LayoutOrder
        ll.Padding = UDim.new(0, 2)
        ll.Parent = NavHolder
    end
end

local NavItems = {}
local function highlightNav(b)
    for _, o in ipairs(NavItems) do tw(o, {BackgroundColor3 = COL.Side, TextColor3 = COL.Text}, 0.15) end
    if b then tw(b, {BackgroundColor3 = COL.Red, TextColor3 = COL.White}, 0.15) end
end
local function mkNav(i, text, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.88, 0, 0, 30); b.Position = UDim2.new(0.06, 0, 0, 0); b.LayoutOrder = i
    b.BackgroundColor3 = COL.Side; b.Text = text; b.TextColor3 = COL.Text
    b.TextScaled = true; b.Font = Enum.Font.Gotham; b.TextXAlignment = Enum.TextXAlignment.Left
    b.AutoButtonColor = false; b.BorderSizePixel = 0; b.Parent = UI.NavHolder
    corner(b, 0.25); pressAnim(b)
    local pad = Instance.new("UIPadding"); pad.PaddingLeft = UDim.new(0.09, 0); pad.Parent = b
    b.MouseButton1Click:Connect(function()
        highlightNav(b)
        cb()
    end)
    table.insert(NavItems, b)
    return b
end

local VipInfo = {ok = false, queried = false, isVip = false, nickname = "", vipName = "", inferred = false}
local UserName, UserBadge, UserBadgeTxt, UserAvatarTxt

local UserCard = Instance.new("Frame")
UserCard.Size = UDim2.new(0.92, 0, 0, 58)
UserCard.ClipsDescendants = true
UserCard.Position = UDim2.new(0.06, 0, 1, -70)
UserCard.BackgroundColor3 = COL.White
UserCard.BackgroundTransparency = 0
UserCard.BorderSizePixel = 0
UserCard.Parent = SideBar
do local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 10); c.Parent = UserCard end
stroke(UserCard, COL.Line, 1)

local UserAvatar = Instance.new("Frame")
UserAvatar.Size = UDim2.new(0, 26, 0, 26)
UserAvatar.Position = UDim2.new(0, 8, 0, 7)
UserAvatar.AnchorPoint = Vector2.new(0, 0)
UserAvatar.BackgroundColor3 = COL.Red
UserAvatar.BorderSizePixel = 0
UserAvatar.Parent = UserCard
circle(UserAvatar)
UserAvatarTxt = mkLabel(UserAvatar, UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), "♪", COL.White, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
UserAvatarTxt.TextScaled = false
UserAvatarTxt.TextSize = 13

UserName = mkLabel(UserCard, UDim2.new(1, -50, 0, 15), UDim2.new(0, 40, 0, 8), "未登录", COL.Text, Enum.Font.GothamBold)
UserName.TextScaled = false
UserName.TextSize = 12
UserName.TextTruncate = Enum.TextTruncate.AtEnd
do local p = Instance.new("UIPadding"); p.PaddingRight = UDim.new(0, 2); p.Parent = UserName end

UserBadge = Instance.new("Frame")
UserBadge.Size = UDim2.new(0, 34, 0, 16)
UserBadge.Position = UDim2.new(0, 8, 0, 36)
UserBadge.BackgroundColor3 = Color3.fromRGB(238, 238, 243)
UserBadge.BorderSizePixel = 0
UserBadge.Parent = UserCard
corner(UserBadge, 0.5)
UserBadgeTxt = mkLabel(UserBadge, UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), "检测中", COL.Sub, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
UserBadgeTxt.TextScaled = false
UserBadgeTxt.TextSize = 9

function UI.FitUserBadge()
    if not UserBadge or not UserBadgeTxt or not UserCard then return end
    local cw = 0
    pcall(function() cw = UserCard.AbsoluteSize.X end)
    if not cw or cw <= 0 then cw = 72 end
    local bx = 8
    pcall(function() bx = UserBadge.Position.X.Offset end)
    local avail = cw - bx - 8
    if avail < 26 then avail = 26 end
    local tw = 0
    pcall(function() tw = UserBadgeTxt.TextBounds.X end)
    local w = 34
    if tw > 0 then w = tw + 12 end
    if w > avail then w = avail end
    if w < 26 then w = 26 end
    UserBadge.Size = UDim2.new(0, w, 0, 16)
end

function UI.LayoutUserCard()
    if not UserCard or not UserAvatar or not UserName then return end
    local cw = 0
    pcall(function() cw = UserCard.AbsoluteSize.X end)
    if not cw or cw <= 0 then cw = 72 end
    local narrow = cw < 104
    local av = narrow and 26 or 32
    UserAvatar.Size = UDim2.new(0, av, 0, av)
    UserAvatar.Position = UDim2.new(0, 8, 0, narrow and 6 or 13)
    pcall(function() UserAvatarTxt.TextSize = narrow and 13 or 15 end)
    local x0 = 8 + av + 6
    if narrow then
        UserName.Position = UDim2.new(0, x0, 0, 7)
        UserName.Size = UDim2.new(1, -(x0 + 8), 0, 15)
        UserName.TextSize = 11
    else
        UserName.Position = UDim2.new(0, x0, 0, 15)
        UserName.Size = UDim2.new(1, -(x0 + 24), 0, 17)
        UserName.TextSize = 12
    end
    if UI.UserArrowRef then UI.UserArrowRef.Visible = not narrow end
    UI.FitUserBadge()
end
pcall(function()
    UserBadgeTxt:GetPropertyChangedSignal("TextBounds"):Connect(function() UI.FitUserBadge() end)
    UserCard:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() UI.LayoutUserCard() end)
end)

do
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 16, 0, 26)
    arrow.Position = UDim2.new(1, -20, 0.5, 0)
    arrow.AnchorPoint = Vector2.new(0, 0.5)
    arrow.BackgroundTransparency = 1
    arrow.Text = "›"
    arrow.TextColor3 = Color3.fromRGB(200, 200, 206)
    arrow.TextScaled = true
    arrow.Font = Enum.Font.GothamBold
    arrow.Visible = false
    arrow.Parent = UserCard
    UI.UserArrowRef = arrow
end

local function updateUserCard()
    if not UserName then return end
    local nick = VipInfo.nickname
    if nick == nil or nick == "" then nick = "未登录" end
    UserName.Text = nick

    if UserAvatarTxt then
        local first = "♪"
        if nick ~= "未登录" then
            local ok1, s = pcall(function() return string.sub(nick, 1, 1) end)
            if ok1 and s and s ~= "" then first = s end
        end
        UserAvatarTxt.Text = first
    end

    local txt, bg, fg
    if VipInfo.isVip then
        local nm = VipInfo.vipName
        if nm == nil or nm == "" then nm = "VIP" end
        if VipInfo.inferred then nm = nm .. "?" end
        txt = nm
        bg = COL.Gold
        fg = Color3.fromRGB(90, 60, 12)
    else
        txt = VipInfo.queried and "普通用户" or "检测中"
        bg = Color3.fromRGB(238, 238, 243)
        fg = Color3.fromRGB(120, 120, 128)
    end
    UserBadgeTxt.Text = txt
    UserBadge.BackgroundColor3 = bg
    UserBadgeTxt.TextColor3 = fg

    if UI.LayoutUserCard then UI.LayoutUserCard() end
end

local function queryVip()
    task.spawn(function()
        local d = apiGet("/vip")
        if d and d.ok then
            VipInfo.ok = true
            VipInfo.isVip = (d.isVip == true)
            VipInfo.nickname = tostring(d.nickname or "")
            VipInfo.vipName = tostring(d.vipName or "VIP")
        else
            VipInfo.ok = false
        end
        VipInfo.queried = true
        updateUserCard()
    end)
end

local function inferVipFromProbe()
    if VipInfo.ok then return end
    if VipInfo.isVip and VipInfo.inferred then return end
    VipInfo.isVip = true
    VipInfo.inferred = true
    if VipInfo.vipName == nil or VipInfo.vipName == "" then VipInfo.vipName = "VIP" end
    updateUserCard()
end
updateUserCard()

local LoginMask = Instance.new("TextButton")
LoginMask.Size = UDim2.new(1, 0, 1, 0)
LoginMask.Position = UDim2.new(0, 0, 0, 0)
LoginMask.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
LoginMask.BackgroundTransparency = 0.6
LoginMask.BorderSizePixel = 0
LoginMask.Text = ""
LoginMask.AutoButtonColor = false
LoginMask.Visible = false
LoginMask.ZIndex = 300
LoginMask.Parent = Main

local LoginCard = Instance.new("Frame")
LoginCard.Size = UDim2.new(0.80, 0, 0.74, 0)
LoginCard.Position = UDim2.new(0.5, 0, 0.5, 0)
LoginCard.AnchorPoint = Vector2.new(0.5, 0.5)
LoginCard.BackgroundColor3 = COL.Card
LoginCard.BorderSizePixel = 0
LoginCard.ZIndex = 301
LoginCard.Parent = LoginMask
corner(LoginCard, 0.05)

local LoginTitle = mkLabel(LoginCard, UDim2.new(0.60, 0, 0.075, 0), UDim2.new(0.06, 0, 0.035, 0), "账号登录", COL.Text, Enum.Font.GothamBold, Enum.TextXAlignment.Left)
LoginTitle.ZIndex = 302

local LoginClose = mkBtn(LoginCard, UDim2.new(0.10, 0, 0.075, 0), UDim2.new(0.86, 0, 0.032, 0), IC.Close, COL.Sub, 1)
LoginClose.ZIndex = 302
LoginClose.Font = Enum.Font.GothamBold

local function mkTab(x, text)
    local b = mkBtn(LoginCard, UDim2.new(0.40, 0, 0.085, 0), UDim2.new(x, 0, 0.135, 0), text, COL.Sub, 0)
    b.BackgroundColor3 = COL.Side
    b.ZIndex = 302
    b.Font = Enum.Font.GothamBold
    corner(b, 0.25)
    pressAnim(b)
    return b
end
local TabPhone  = mkTab(0.06, "手机号登录")
local TabCookie = mkTab(0.52, "Cookie 登录")

local PhonePage = Instance.new("Frame")
PhonePage.Size = UDim2.new(0.88, 0, 0.60, 0)
PhonePage.Position = UDim2.new(0.06, 0, 0.255, 0)
PhonePage.BackgroundTransparency = 1
PhonePage.ZIndex = 302
PhonePage.Parent = LoginCard

local CookiePage = Instance.new("Frame")
CookiePage.Size = UDim2.new(0.88, 0, 0.60, 0)
CookiePage.Position = UDim2.new(0.06, 0, 0.255, 0)
CookiePage.BackgroundTransparency = 1
CookiePage.ZIndex = 302
CookiePage.Parent = LoginCard

local function mkBox(parent, size, pos, ph, multi)
    local t = Instance.new("TextBox")
    t.Size = size
    t.Position = pos
    t.BackgroundColor3 = COL.Side
    t.BorderSizePixel = 0
    t.ZIndex = 303
    t.MultiLine = multi and true or false
    t.TextWrapped = true
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.TextYAlignment = multi and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center
    t.ClearTextOnFocus = false
    t.PlaceholderText = ph or ""
    t.PlaceholderColor3 = Color3.fromRGB(150, 150, 156)
    t.Text = ""
    t.TextColor3 = COL.Text
    t.Font = multi and Enum.Font.Code or Enum.Font.Gotham
    t.TextScaled = true
    t.Parent = parent
    corner(t, multi and 0.06 or 0.18)
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 10)
    pad.PaddingRight = UDim.new(0, 8)
    if multi then pad.PaddingTop = UDim.new(0, 6) end
    pad.Parent = t
    return t
end

local function mkAct(parent, x, y, w, h, text, bg, tc)
    local b = mkBtn(parent, UDim2.new(w, 0, h, 0), UDim2.new(x, 0, y, 0), text, tc, 0)
    b.BackgroundColor3 = bg
    b.ZIndex = 303
    b.Font = Enum.Font.GothamBold
    corner(b, 0.22)
    pressAnim(b)
    return b
end

function trim(s)
    local t = tostring(s or ""):gsub("^%s+", "")
    t = t:gsub("%s+$", "")
    return t
end

local PhoneTip = mkLabel(PhonePage, UDim2.new(1, 0, 0.13, 0), UDim2.new(0, 0, 0, 0),
    "输入手机号 → 获取验证码 → 填写短信里的验证码 → 登录",
    COL.Sub, Enum.Font.Gotham, Enum.TextXAlignment.Left)
PhoneTip.ZIndex = 303
PhoneTip.TextWrapped = true

local PhoneInput = mkBox(PhonePage, UDim2.new(0.62, 0, 0.20, 0), UDim2.new(0, 0, 0.16, 0), "手机号", false)
local CodeInput  = mkBox(PhonePage, UDim2.new(0.62, 0, 0.20, 0), UDim2.new(0, 0, 0.40, 0), "短信验证码", false)
local BtnSms        = mkAct(PhonePage, 0.66, 0.16, 0.34, 0.20, "获取验证码", COL.Red, COL.White)
local BtnPhoneLogin = mkAct(PhonePage, 0.66, 0.40, 0.34, 0.20, "登录", COL.Red, COL.White)
local BtnDefault    = mkAct(PhonePage, 0, 0.66, 0.48, 0.16, "默认账号", Color3.fromRGB(238, 238, 242), COL.Text)

local LoginMsg = mkLabel(PhonePage, UDim2.new(1, 0, 0.13, 0), UDim2.new(0, 0, 0.85, 0), "", COL.Sub, Enum.Font.Gotham, Enum.TextXAlignment.Left)
LoginMsg.ZIndex = 303
LoginMsg.TextWrapped = true

local CookieInput = mkBox(CookiePage, UDim2.new(1, 0, 0.36, 0), UDim2.new(0, 0, 0.02, 0), "MUSIC_U=xxxx; __csrf=xxxx", true)
local BtnCookieLogin   = mkAct(CookiePage, 0,    0.44, 0.30, 0.15, "登录",     COL.Red, COL.White)
local BtnCookieDefault = mkAct(CookiePage, 0.35, 0.44, 0.30, 0.15, "默认账号", Color3.fromRGB(238, 238, 242), COL.Text)
local BtnCookieClear   = mkAct(CookiePage, 0.70, 0.44, 0.30, 0.15, "清除",     Color3.fromRGB(238, 238, 242), COL.Text)

local CookieMsg = mkLabel(CookiePage, UDim2.new(1, 0, 0.13, 0), UDim2.new(0, 0, 0.64, 0), "", COL.Sub, Enum.Font.Gotham, Enum.TextXAlignment.Left)
CookieMsg.ZIndex = 303
CookieMsg.TextWrapped = true

local CookieHint = mkLabel(CookiePage, UDim2.new(1, 0, 0.18, 0), UDim2.new(0, 0, 0.80, 0),
    "电脑打开 music.163.com 登录 → F12 → Application → Cookies → 复制 MUSIC_U 与 __csrf 粘到上方",
    COL.Sub, Enum.Font.Gotham, Enum.TextXAlignment.Left)
CookieHint.ZIndex = 303
CookieHint.TextWrapped = true

function showLoginTab(isPhone)
    PhonePage.Visible = isPhone
    CookiePage.Visible = not isPhone
    TabPhone.BackgroundColor3  = isPhone and COL.Red or COL.Side
    TabPhone.TextColor3        = isPhone and COL.White or COL.Sub
    TabCookie.BackgroundColor3 = (not isPhone) and COL.Red or COL.Side
    TabCookie.TextColor3       = (not isPhone) and COL.White or COL.Sub
end
TabPhone.MouseButton1Click:Connect(function() showLoginTab(true) end)
TabCookie.MouseButton1Click:Connect(function() showLoginTab(false) end)

local SmsCd = 0
local LoginBusy = false

function refreshSmsBtn()
    if SmsCd > 0 then
        BtnSms.Text = tostring(SmsCd) .. "s"
        BtnSms.BackgroundColor3 = Color3.fromRGB(238, 238, 242)
    else
        BtnSms.Text = "获取验证码"
        BtnSms.BackgroundColor3 = COL.Red
    end
end

function startSmsCd()
    if SmsCd > 0 then return end
    SmsCd = 60
    refreshSmsBtn()
    task.spawn(function()
        while SmsCd > 0 do
            task.wait(1)
            SmsCd = SmsCd - 1
            refreshSmsBtn()
        end
    end)
end

function setMsg(lbl, txt, col)
    if not lbl then return end
    lbl.Text = txt or ""
    lbl.TextColor3 = col or COL.Sub
end

function errOf(d)
    if type(d) ~= "table" then return "请求失败" end
    local why = ""
    local raw = d.raw
    if type(raw) == "table" then
        for _, v in pairs(raw) do
            if type(v) == "table" then
                if v.message and tostring(v.message) ~= "" then why = tostring(v.message) end
                if why == "" and v.msg and tostring(v.msg) ~= "" then why = tostring(v.msg) end
            end
        end
    end
    if why == "" and type(d.data) == "table" then
        if d.data.message and tostring(d.data.message) ~= "" then why = tostring(d.data.message) end
        if why == "" and d.data.msg and tostring(d.data.msg) ~= "" then why = tostring(d.data.msg) end
    end
    if why == "" then why = "可能被风控拦截" end
    return why
end

function refreshLoginMsg()
    if AccCookie ~= "" then
        local s = AccCookie
        local show
        if #s > 16 then show = s:sub(1, 8) .. "****" .. s:sub(#s - 3)
        else show = string.rep("*", math.max(4, #s)) end
        local t = "已保存凭据: " .. show .. " · 已加密"
        setMsg(LoginMsg, t, COL.Gold)
        setMsg(CookieMsg, t, COL.Gold)
    else
        setMsg(LoginMsg, "当前: 作者默认账号", COL.Sub)
        setMsg(CookieMsg, "当前: 作者默认账号", COL.Sub)
    end
end

function closeLogin()
    LoginMask.Visible = false
end

function applyCookieAndRefresh(c, msg)
    saveCookie(c)
    for k in pairs(ProbeCache) do ProbeCache[k] = nil end
    VipInfo.queried = false
    VipInfo.ok = false
    VipInfo.isVip = false
    VipInfo.inferred = false
    VipInfo.nickname = ""
    updateUserCard()
    queryVip()
    refreshLoginMsg()
    if UI.SetStatus then UI.SetStatus(msg) end
    task.delay(1.8, function() if UI.SetStatus and not State.Loading then UI.SetStatus("") end end)
end

function openLogin()
    CookieInput.Text = ""
    refreshLoginMsg()
    refreshSmsBtn()
    LoginMask.Visible = true
    popIn(LoginCard)
end

BtnSms.MouseButton1Click:Connect(function()
    if SmsCd > 0 then return end
    local phone = trim(PhoneInput.Text)
    if not phone:match("^%d+$") or #phone ~= 11 then
        setMsg(LoginMsg, "请输入 11 位手机号", COL.RedL)
        return
    end
    setMsg(LoginMsg, "发送中...", COL.Sub)
    task.spawn(function()
        local d = apiGet("/login/sms?phone=" .. urlEncode(phone))
        if d and d.sent == true then
            setMsg(LoginMsg, "验证码已发送至 " .. __NCM_maskPhone(phone), COL.Gold)
            startSmsCd()
        else
            setMsg(LoginMsg, "发送失败: " .. errOf(d), COL.RedL)
        end
    end)
end)

BtnPhoneLogin.MouseButton1Click:Connect(function()
    if LoginBusy then return end
    local phone = trim(PhoneInput.Text)
    local code = trim(CodeInput.Text)
    if not phone:match("^%d+$") or #phone ~= 11 then
        setMsg(LoginMsg, "请输入 11 位手机号", COL.RedL)
        return
    end
    if code == "" then
        setMsg(LoginMsg, "请填写短信验证码", COL.RedL)
        return
    end
    LoginBusy = true
    BtnPhoneLogin.Text = "登录中"
    setMsg(LoginMsg, "验证中...", COL.Sub)
    task.spawn(function()
        local d = apiGet("/login/verify?phone=" .. urlEncode(phone) .. "&code=" .. urlEncode(code))
        BtnPhoneLogin.Text = "登录"
        LoginBusy = false
        if d and d.ok == true and type(d.cookie) == "string" and d.cookie ~= "" then
            closeLogin()
            PhoneInput.Text = ""
            CodeInput.Text = ""
            applyCookieAndRefresh(d.cookie, "登录成功，检测账号...")
        else
            setMsg(LoginMsg, "登录失败: " .. errOf(d), COL.RedL)
        end
    end)
end)

BtnDefault.MouseButton1Click:Connect(function()
    closeLogin()
    applyCookieAndRefresh("", "已用默认账号")
end)

BtnCookieLogin.MouseButton1Click:Connect(function()
    local txt = trim(CookieInput.Text)
    if txt == "" then
        setMsg(CookieMsg, "请先粘贴 Cookie", COL.RedL)
        return
    end
    if not txt:lower():find("music_u", 1, true) then
        setMsg(CookieMsg, "缺少 MUSIC_U，请检查", COL.RedL)
        return
    end
    closeLogin()
    applyCookieAndRefresh(txt, "已切换账号，检测中...")
end)

BtnCookieDefault.MouseButton1Click:Connect(function()
    closeLogin()
    applyCookieAndRefresh("", "已用默认账号")
end)

BtnCookieClear.MouseButton1Click:Connect(function()
    CookieInput.Text = ""
    closeLogin()
    applyCookieAndRefresh("", "已清除账号")
end)

LoginClose.MouseButton1Click:Connect(closeLogin)
LoginMask.MouseButton1Click:Connect(closeLogin)
showLoginTab(true)

local UserBtn = Instance.new("TextButton")
UserBtn.Size = UDim2.new(1, 0, 1, 0)
UserBtn.BackgroundTransparency = 1
UserBtn.Text = ""
UserBtn.AutoButtonColor = false
UserBtn.Parent = UserCard
UserBtn.MouseButton1Click:Connect(function()
    openLogin()
end)

local Body = Instance.new("Frame")
Body.Size = UDim2.new(0.785, 0, 0.785, 0); Body.Position = UDim2.new(0.215, 0, 0.075, 0)
Body.BackgroundTransparency = 1; Body.Parent = Main

local ListPage = Instance.new("Frame")
ListPage.Size = UDim2.new(1,0,1,0); ListPage.BackgroundTransparency = 1; ListPage.Parent = Body
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1,0,0.055,0); TitleBar.Position = UDim2.new(0,0,0,0)
TitleBar.BackgroundTransparency = 1; TitleBar.Parent = ListPage
local ListTitle = mkLabel(TitleBar, UDim2.new(0.72,0,0.9,0), UDim2.new(0.025,0,0.05,0), "搜索结果", COL.Text, Enum.Font.GothamBold)
local BtnArtistBack = mkBtn(TitleBar, UDim2.new(0.20,0,0.8,0), UDim2.new(0.775,0,0.1,0), "< 返回", COL.Sub, 1)
BtnArtistBack.Font = Enum.Font.Gotham
BtnArtistBack.Visible = false
pressAnim(BtnArtistBack)
UI.BtnRecommendBack = mkBtn(TitleBar, UDim2.new(0.20,0,0.8,0), UDim2.new(0.775,0,0.1,0), "< 推荐", COL.Sub, 1)
UI.BtnRecommendBack.Font = Enum.Font.Gotham
UI.BtnRecommendBack.Visible = false
pressAnim(UI.BtnRecommendBack)

local ListHead = Instance.new("Frame")
ListHead.Size = UDim2.new(1,0,0.06,0); ListHead.Position = UDim2.new(0,0,0.058,0)
ListHead.BackgroundTransparency = 1; ListHead.Parent = ListPage
mkLabel(ListHead, UDim2.new(0.10,0,1,0), UDim2.new(0.03,0,0,0), "#", COL.Sub, Enum.Font.Gotham, Enum.TextXAlignment.Center)
mkLabel(ListHead, UDim2.new(0.40,0,1,0), UDim2.new(0.14,0,0,0), "音乐标题", COL.Sub)
mkLabel(ListHead, UDim2.new(0.26,0,1,0), UDim2.new(0.56,0,0,0), "歌手", COL.Sub)
mkLabel(ListHead, UDim2.new(0.14,0,1,0), UDim2.new(0.84,0,0,0), "时长", COL.Sub)
local HeadLine = Instance.new("Frame")
HeadLine.Size = UDim2.new(0.96,0,0.012,0); HeadLine.Position = UDim2.new(0.02,0,0.99,0)
HeadLine.BackgroundColor3 = COL.Line; HeadLine.BorderSizePixel = 0; HeadLine.Parent = ListHead

local ListScroll = Instance.new("ScrollingFrame")
ListScroll.Size = UDim2.new(1,0,0.87,0); ListScroll.Position = UDim2.new(0,0,0.125,0)
ListScroll.BackgroundTransparency = 1; ListScroll.BorderSizePixel = 0
ListScroll.ScrollBarThickness = 4; ListScroll.ScrollBarImageColor3 = COL.RedL
ListScroll.ScrollingDirection = Enum.ScrollingDirection.Y
ListScroll.CanvasSize = UDim2.new(0,0,0,0); ListScroll.Active = true; ListScroll.Parent = ListPage
local ListLayout = Instance.new("UIListLayout")
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder; ListLayout.Padding = UDim.new(0,6)
ListLayout.Parent = ListScroll

local LyricPage = Instance.new("Frame")
LyricPage.Size = UDim2.new(1,0,1,0); LyricPage.BackgroundTransparency = 1
LyricPage.Visible = false; LyricPage.Parent = Body
local BtnBack = mkBtn(LyricPage, UDim2.new(0.16,0,0.055,0), UDim2.new(0.03,0,0.025,0), "< 返回", COL.Sub, 1)
BtnBack.Font = Enum.Font.Gotham; pressAnim(BtnBack)

local VinylWrap = Instance.new("Frame")
VinylWrap.Size = UDim2.new(0.30,0,0.32,0); VinylWrap.Position = UDim2.new(0.35,0,0.10,0)
VinylWrap.BackgroundTransparency = 1; VinylWrap.Parent = LyricPage
local Vinyl = Instance.new("Frame")
Vinyl.AnchorPoint = Vector2.new(0.5,0.5); Vinyl.Position = UDim2.new(0.5,0,0.5,0)
Vinyl.BackgroundColor3 = Color3.fromRGB(16,16,18); Vinyl.BorderSizePixel = 0
Vinyl.Parent = VinylWrap; circle(Vinyl); stroke(Vinyl, Color3.fromRGB(60,60,66), 2)
local VinylRing = Instance.new("Frame")
VinylRing.AnchorPoint = Vector2.new(0.5,0.5); VinylRing.Position = UDim2.new(0.5,0,0.5,0)
VinylRing.Size = UDim2.new(0.42,0,0.42,0); VinylRing.BackgroundColor3 = COL.Red
VinylRing.BorderSizePixel = 0; VinylRing.Parent = Vinyl; circle(VinylRing)
local VinylDot = Instance.new("Frame")
VinylDot.AnchorPoint = Vector2.new(0.5,0.5); VinylDot.Position = UDim2.new(0.5,0,0.5,0)
VinylDot.Size = UDim2.new(0.18,0,0.18,0); VinylDot.BackgroundColor3 = COL.White
VinylDot.BorderSizePixel = 0; VinylDot.Parent = VinylRing; circle(VinylDot)

local LyricName = mkLabel(LyricPage, UDim2.new(0.7,0,0.055,0), UDim2.new(0.15,0,0.45,0), "", COL.Text, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
local LyricArtist = mkBtn(LyricPage, UDim2.new(0.7,0,0.04,0), UDim2.new(0.15,0,0.51,0), "", COL.Sub, 1)
LyricArtist.Font = Enum.Font.Gotham
LyricArtist.TextXAlignment = Enum.TextXAlignment.Center
LyricArtist.TextTruncate = Enum.TextTruncate.AtEnd
LyricArtist.MouseEnter:Connect(function() if CurrentSong then LyricArtist.TextColor3 = COL.Gold end end)
LyricArtist.MouseLeave:Connect(function() LyricArtist.TextColor3 = COL.Sub end)
LyricArtist.MouseButton1Click:Connect(function()
    if CurrentSong then openArtistFromSong(CurrentSong) end
end)
do
    local function syncB1()
        if M_Lyric then
            if UI.DeskCfg.lock then
                M_Lyric.TextColor3 = COL.Gold
            elseif UI.DeskCfg.on then
                M_Lyric.TextColor3 = COL.Red
            else
                M_Lyric.TextColor3 = Color3.fromRGB(120, 120, 132)
            end
        end
        local db = UI.DeskBtn
        if db then
            if UI.DeskCfg.lock then
                UI.setCol(db, COL.Gold)
            elseif UI.DeskCfg.on then
                UI.setCol(db, COL.Red)
            else
                UI.setCol(db, COL.Sub)
            end
        end
    end
    UI.syncDeskBtn = syncB1
    syncB1()
end

local LyricBox = Instance.new("Frame")
LyricBox.Size = UDim2.new(0.86,0,0.38,0); LyricBox.Position = UDim2.new(0.07,0,0.58,0)
LyricBox.BackgroundTransparency = 1; LyricBox.ClipsDescendants = true; LyricBox.Parent = LyricPage
local LyricHolder = Instance.new("Frame")
LyricHolder.Size = UDim2.new(1,0,1,0); LyricHolder.BackgroundTransparency = 1; LyricHolder.Parent = LyricBox

do
    local grab = Instance.new("TextButton")
    grab.Name = "LyricGrab"; grab.Size = UDim2.new(1,0,1,0)
    grab.BackgroundTransparency = 1; grab.Text = ""; grab.AutoButtonColor = false
    grab.ZIndex = 12; grab.Parent = LyricBox
    UI.LyricGrab = grab

    local guide = Instance.new("Frame")
    guide.Name = "LyricGuide"; guide.Size = UDim2.new(0.86,0,0,1)
    guide.Position = UDim2.new(0.07,0,0.5,0); guide.AnchorPoint = Vector2.new(0,0.5)
    guide.BackgroundColor3 = COL.Sub; guide.BackgroundTransparency = 0.7
    guide.BorderSizePixel = 0; guide.Visible = false; guide.ZIndex = 13
    guide.Parent = LyricBox
    UI.LyricGuide = guide

    local tip = Instance.new("TextLabel")
    tip.Name = "LyricTip"; tip.Size = UDim2.new(0,66,0,18)
    tip.Position = UDim2.new(1,-8,0.5,0); tip.AnchorPoint = Vector2.new(1,0.5)
    tip.BackgroundTransparency = 1; tip.Text = ""
    tip.TextColor3 = COL.Red; tip.TextSize = 12; tip.Font = Enum.Font.GothamBold
    tip.TextXAlignment = Enum.TextXAlignment.Right
    tip.Visible = false; tip.ZIndex = 14; tip.Parent = LyricBox
    UI.LyricTip = tip

    local go = Instance.new("TextButton")
    go.Name = "LyricGo"; go.Size = UDim2.new(0,26,0,26)
    go.Position = UDim2.new(0,2,0.5,0); go.AnchorPoint = Vector2.new(0,0.5)
    go.BackgroundColor3 = COL.Red; go.BackgroundTransparency = 0.08
    go.BorderSizePixel = 0; go.Text = "\226\150\182"
    go.TextColor3 = Color3.new(1,1,1); go.TextSize = 11
    go.Font = Enum.Font.GothamBold; go.AutoButtonColor = false
    go.Visible = false; go.ZIndex = 14; go.Parent = LyricBox
    corner(go, 1)
    UI.LyricGo = go
end

UI.mkRow = function(parent, song, idx, onClick)
    local row = Instance.new("TextButton")
    row.Size = UDim2.new(1, -8, 0, 40)
    row.BackgroundColor3 = COL.Card
    row.BackgroundTransparency = 0.5
    row.BorderSizePixel = 0
    row.Text = ""
    row.AutoButtonColor = false
    row.Parent = parent
    corner(row, 0.22)
    mkLabel(row, UDim2.new(0, 28, 1, 0), UDim2.new(0, 8, 0, 0), tostring(idx), COL.Sub, Enum.Font.Gotham, Enum.TextXAlignment.Center)
    local nm = mkLabel(row, UDim2.new(0.46, -46, 1, 0), UDim2.new(0, 38, 0, 0), song.name or "未知", COL.Text, Enum.Font.Gotham)
    nm.TextTruncate = Enum.TextTruncate.AtEnd
    local ar = mkLabel(row, UDim2.new(0.28, -30, 1, 0), UDim2.new(0.46, -8, 0, 0), song.artist or "", COL.Sub, Enum.Font.Gotham)
    ar.TextTruncate = Enum.TextTruncate.AtEnd
    local vip = mkLabel(row, UDim2.new(0, 34, 1, 0), UDim2.new(1, -42, 0, 0), "", COL.Gold, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
    if (song.fee or 0) ~= 0 then vip.Text = "VIP" end
    row.MouseEnter:Connect(function() row.BackgroundTransparency = 0.22 end)
    row.MouseLeave:Connect(function() row.BackgroundTransparency = 0.5 end)
    row.MouseButton1Click:Connect(function() onClick(song) end)
    return row
end

UI.fitScroll = function(sc)
    pcall(function()
        local ll = sc:FindFirstChildOfClass("UIListLayout")
        if ll then sc.CanvasSize = UDim2.new(0, 0, 0, ll.AbsoluteContentSize.Y + 10) end
    end)
end

do
    local hp = Instance.new("Frame")
    hp.Size = UDim2.new(1,0,1,0); hp.BackgroundTransparency = 1; hp.Parent = Body
    UI.HomePage = hp
    mkLabel(hp, UDim2.new(0.7,0,0.075,0), UDim2.new(0.03,0,0.018,0), "推荐", COL.Text, Enum.Font.GothamBold)
    mkLabel(hp, UDim2.new(0.7,0,0.04,0), UDim2.new(0.03,0,0.098,0), "每日推荐 · 听听看", COL.Sub, Enum.Font.Gotham)
    local tagBox = Instance.new("Frame")
    tagBox.Size = UDim2.new(0.96,0,0.105,0); tagBox.Position = UDim2.new(0.02,0,0.15,0)
    tagBox.BackgroundTransparency = 1; tagBox.Parent = hp
    local tags = {"热歌", "华语", "流行", "民谣", "电子", "古风"}
    local bw = 1 / #tags
    for i, tg in ipairs(tags) do
        local b = mkBtn(tagBox, UDim2.new(bw - 0.012, 0, 0.44, 0), UDim2.new((i-1)*bw + 0.006, 0, 0.03, 0), tg, COL.Text, 0.5)
        b.Font = Enum.Font.Gotham
        corner(b, 0.3); pressAnim(b)
        b.MouseEnter:Connect(function() b.BackgroundTransparency = 0.2 end)
        b.MouseLeave:Connect(function() b.BackgroundTransparency = 0.5 end)
        b.MouseButton1Click:Connect(function()
            showPage("list")
            ListTitle.Text = "推荐 · " .. tg
            BtnArtistBack.Visible = false
            UI.BtnRecommendBack.Visible = true
            State.CurNav = 1
            highlightNav(NavItems[1])
            if UI.SetStatus then UI.SetStatus("加载推荐...") end
            task.spawn(function()
                local res = apiSearch(tg)
                State.SearchQueue = res
                renderList(res)
                if #res == 0 then UI.SetStatus("加载失败") else UI.SetStatus("") end
                probePlayable(res)
            end)
        end)
    end
    local sc = Instance.new("ScrollingFrame")
    sc.Size = UDim2.new(0.96,0,0.70,0); sc.Position = UDim2.new(0.02,0,0.28,0)
    sc.BackgroundTransparency = 1; sc.BorderSizePixel = 0
    sc.ScrollBarThickness = 4; sc.ScrollBarImageColor3 = COL.RedL
    sc.ScrollingDirection = Enum.ScrollingDirection.Y
    sc.CanvasSize = UDim2.new(0,0,0,0); sc.Active = true; sc.Parent = hp
    UI.HomeScroll = sc
    local ll = Instance.new("UIListLayout")
    ll.SortOrder = Enum.SortOrder.LayoutOrder; ll.Padding = UDim.new(0, 6); ll.Parent = sc
end

UI.renderHome = function(songs)
    local sc = UI.HomeScroll
    if not sc then return end
    for _, c in ipairs(sc:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    for i, s in ipairs(songs or {}) do
        UI.mkRow(sc, s, i, function(sg)
            local q = {}
            for _, x in ipairs(songs or {}) do table.insert(q, x) end
            State.Queue = q
            State.Index = i
            playSong(sg)
        end)
    end
    UI.fitScroll(sc)
end

do
    local ap = Instance.new("Frame")
    ap.Size = UDim2.new(1,0,1,0); ap.Position = UDim2.new(0,0,0,0)
    ap.BackgroundColor3 = COL.Body; ap.BorderSizePixel = 0
    ap.Visible = false; ap.ZIndex = 20; ap.Parent = Body
    UI.ArtistPage = ap
    local back = mkBtn(ap, UDim2.new(0.15,0,0.06,0), UDim2.new(0.025,0,0.018,0), "< 返回", COL.Sub, 1)
    back.Font = Enum.Font.Gotham
    do local cc = Instance.new("UICorner"); cc.CornerRadius = UDim.new(0.25, 0); cc.Parent = back end
    pressAnim(back)
    back.MouseButton1Click:Connect(function() UI.closeArtist() end)
    local nm = mkLabel(ap, UDim2.new(0.66,0,0.085,0), UDim2.new(0.17,0,0.10,0), "", COL.Text, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
    nm.TextScaled = true
    UI.ArtistNameLbl = nm
    mkLabel(ap, UDim2.new(0.66,0,0.04,0), UDim2.new(0.03,0,0.235,0), "热门歌曲", COL.Sub, Enum.Font.GothamBold)
    local sc = Instance.new("ScrollingFrame")
    sc.Size = UDim2.new(0.96,0,0.68,0); sc.Position = UDim2.new(0.02,0,0.285,0)
    sc.BackgroundTransparency = 1; sc.BorderSizePixel = 0
    sc.ScrollBarThickness = 4; sc.ScrollBarImageColor3 = COL.RedL
    sc.ScrollingDirection = Enum.ScrollingDirection.Y
    sc.CanvasSize = UDim2.new(0,0,0,0); sc.Active = true; sc.Parent = ap
    UI.ArtistScroll = sc
    local ll = Instance.new("UIListLayout")
    ll.SortOrder = Enum.SortOrder.LayoutOrder; ll.Padding = UDim.new(0, 6); ll.Parent = sc
end

UI.closeArtist = function()
    if UI.ArtistPage then UI.ArtistPage.Visible = false end
    if UI.ArtistPicker then UI.ArtistPicker.Visible = false end
end

function buildArtistPicker()
    local overlay = Instance.new("TextButton")
    overlay.Size = UDim2.new(1,0,1,0)
    overlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
    overlay.BackgroundTransparency = 0.38
    overlay.BorderSizePixel = 0
    overlay.Text = ""
    overlay.AutoButtonColor = false
    overlay.ZIndex = 200
    overlay.Visible = false
    overlay.Parent = Body
    UI.ArtistPicker = overlay
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0.72,0,0.72,0)
    card.Position = UDim2.new(0.5,0,0.5,0)
    card.AnchorPoint = Vector2.new(0.5,0.5)
    card.BackgroundColor3 = COL.White
    card.BorderSizePixel = 0
    card.Active = true
    card.ZIndex = 201
    card.Parent = overlay
    corner(card, 0.04)
    stroke(card, COL.Line, 1)
    local title = mkLabel(card, UDim2.new(0.72,0,0.10,0), UDim2.new(0.07,0,0.05,0), "选择歌手", COL.Text, Enum.Font.GothamBold)
    title.ZIndex = 202
    local sub = mkLabel(card, UDim2.new(0.72,0,0.06,0), UDim2.new(0.07,0,0.135,0), "这首歌包含多位合作歌手", COL.Sub, Enum.Font.Gotham)
    sub.ZIndex = 202
    local close = mkBtn(card, UDim2.new(0.12,0,0.09,0), UDim2.new(0.84,0,0.04,0), "×", COL.Sub, 1)
    close.ZIndex = 202
    close.Font = Enum.Font.Gotham
    pressAnim(close)
    close.MouseButton1Click:Connect(function() overlay.Visible = false end)
    local sc = Instance.new("ScrollingFrame")
    sc.Size = UDim2.new(0.86,0,0.70,0)
    sc.Position = UDim2.new(0.07,0,0.23,0)
    sc.BackgroundTransparency = 1
    sc.BorderSizePixel = 0
    sc.ScrollBarThickness = 4
    sc.ScrollBarImageColor3 = COL.RedL
    sc.Active = true
    sc.ZIndex = 202
    sc.Parent = card
    UI.ArtistPickerScroll = sc
    local ll = Instance.new("UIListLayout")
    ll.SortOrder = Enum.SortOrder.LayoutOrder
    ll.Padding = UDim.new(0,6)
    ll.Parent = sc
    pcall(function() sc.AutomaticCanvasSize = Enum.AutomaticSize.Y end)
    overlay.MouseButton1Click:Connect(function() overlay.Visible = false end)
    UI.ArtistPickerOpen = function(song, artistsIn)
        for _, c in ipairs(sc:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
        local artists = artistsIn
        if not artists or #artists == 0 then
            artists = (song and song.artists) or {}
        end
        if #artists == 0 and song then
            artists = parseArtists(song, song.artist, song.artistId)
            song.artists = artists
        end
        local count = 0
        for i, a in ipairs(artists) do
            count = count + 1
            local b = mkBtn(sc, UDim2.new(1,0,0,46), UDim2.new(0,0,0,0), tostring(a.name or "未知歌手"), COL.Text, 0)
            b.BackgroundColor3 = COL.CardH
            b.TextXAlignment = Enum.TextXAlignment.Left
            b.Font = Enum.Font.Gotham
            b.ZIndex = 203
            corner(b, 0.18)
            local pd = Instance.new("UIPadding")
            pd.PaddingLeft = UDim.new(0,16)
            pd.Parent = b
            pressAnim(b)
            b.MouseEnter:Connect(function() b.BackgroundColor3 = Color3.fromRGB(238,238,242) end)
            b.MouseLeave:Connect(function() b.BackgroundColor3 = COL.CardH end)
            b.MouseButton1Click:Connect(function()
                overlay.Visible = false
                openArtist(a.name, a.id)
            end)
        end
        pcall(function()
            sc.CanvasSize = UDim2.new(0,0,0, math.max(count * 52 + 10, sc.AbsoluteSize.Y + 2))
        end)
        overlay.Visible = true
        popIn(card, 0.94, 0.20)
    end
end
buildArtistPicker()

function openArtistFromSong(song)
    if not song then return end
    local artists = song.artists or {}
    if #artists == 0 then
        artists = parseArtists(song, song.artist, song.artistId)
        song.artists = artists
    end
    if #artists > 1 then
        if UI.ArtistPickerOpen then
            UI.ArtistPickerOpen(song, artists)
            return
        end
    end
    local id = (artists[1] and artists[1].id) or song.artistId or ""
    local name = (artists[1] and artists[1].name) or song.artist or ""
    if name == "" then
        if UI.SetStatus then UI.SetStatus("这首歌没有歌手信息") end
        return
    end
    openArtist(name, id)
end

UI.renderArtist = function(songs, name)
    if UI.ArtistNameLbl then UI.ArtistNameLbl.Text = tostring(name or "未知歌手") end
    local sc = UI.ArtistScroll
    if not sc then return end
    for _, c in ipairs(sc:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    for i, s in ipairs(songs or {}) do
        UI.mkRow(sc, s, i, function(sg)
            State.Queue = songs
            State.Index = i
            playSong(sg)
        end)
    end
    UI.fitScroll(sc)
    if UI.ArtistPage then UI.ArtistPage.Visible = true end
end

local BottomBar = Instance.new("Frame")
BottomBar.Size = UDim2.new(1,0,0.14,0); BottomBar.Position = UDim2.new(0,0,0.86,0)
BottomBar.BackgroundColor3 = COL.Bottom; BottomBar.BorderSizePixel = 0; BottomBar.Parent = Main
do
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 10); c.Parent = BottomBar
    local f = Instance.new("Frame")
    f.Size = UDim2.new(0,10,0,10); f.Position = UDim2.new(0,0,0,0)
    f.BackgroundColor3 = COL.Bottom; f.BorderSizePixel = 0; f.Parent = BottomBar
    f = Instance.new("Frame")
    f.Size = UDim2.new(0,10,0,10); f.Position = UDim2.new(1,-10,0,0)
    f.BackgroundColor3 = COL.Bottom; f.BorderSizePixel = 0; f.Parent = BottomBar
end
local BotLine = Instance.new("Frame")
BotLine.Size = UDim2.new(1,0,0.02,0); BotLine.BackgroundColor3 = COL.Line
BotLine.BorderSizePixel = 0; BotLine.Parent = BottomBar

local VinylBox = Instance.new("Frame")
VinylBox.Size = UDim2.new(0.09,0,0.96,0); VinylBox.Position = UDim2.new(0.015,0,0.02,0)
VinylBox.BackgroundTransparency = 1; VinylBox.Parent = BottomBar
local VinylS = Instance.new("Frame")
VinylS.AnchorPoint = Vector2.new(0.5,0.5); VinylS.Position = UDim2.new(0.5,0,0.5,0)
VinylS.BackgroundColor3 = Color3.fromRGB(16,16,18); VinylS.BorderSizePixel = 0
VinylS.Parent = VinylBox; circle(VinylS)
local VinylSRing = Instance.new("Frame")
VinylSRing.AnchorPoint = Vector2.new(0.5,0.5); VinylSRing.Position = UDim2.new(0.5,0,0.5,0)
VinylSRing.Size = UDim2.new(0.42,0,0.42,0); VinylSRing.BackgroundColor3 = COL.Red
VinylSRing.BorderSizePixel = 0; VinylSRing.Parent = VinylS; circle(VinylSRing)
local VinylSDot = Instance.new("Frame")
VinylSDot.AnchorPoint = Vector2.new(0.5,0.5); VinylSDot.Position = UDim2.new(0.5,0,0.5,0)
VinylSDot.Size = UDim2.new(0.22,0,0.22,0); VinylSDot.BackgroundColor3 = COL.White
VinylSDot.BorderSizePixel = 0; VinylSDot.Parent = VinylSRing; circle(VinylSDot)
local VinylBtn = mkBtn(BottomBar, UDim2.new(0.09,0,0.96,0), UDim2.new(0.015,0,0.02,0), "", COL.Text, 1)
pressAnim(VinylBtn)

local NowName = mkLabel(BottomBar, UDim2.new(0.16,0,0.24,0), UDim2.new(0.115,0,0.14,0), "未在播放", COL.Text, Enum.Font.GothamBold)
local NowArtist = mkBtn(BottomBar, UDim2.new(0.16,0,0.19,0), UDim2.new(0.115,0,0.42,0), "搜索一首歌开始", COL.Sub, 1)
NowArtist.Font = Enum.Font.Gotham
NowArtist.TextXAlignment = Enum.TextXAlignment.Left
NowArtist.TextTruncate = Enum.TextTruncate.AtEnd
NowArtist.MouseEnter:Connect(function() if CurrentSong then NowArtist.TextColor3 = COL.Gold end end)
NowArtist.MouseLeave:Connect(function() NowArtist.TextColor3 = COL.Sub end)
NowArtist.MouseButton1Click:Connect(function()
    if CurrentSong then openArtistFromSong(CurrentSong) end
end)
local StatusLbl = mkLabel(BottomBar, UDim2.new(0.16,0,0.16,0), UDim2.new(0.115,0,0.68,0), "", COL.RedL)

local CtrlArea = Instance.new("Frame")
CtrlArea.Size = UDim2.new(0.39,0,0.96,0); CtrlArea.Position = UDim2.new(0.285,0,0.02,0)
CtrlArea.BackgroundTransparency = 1; CtrlArea.Parent = BottomBar

local BtnPrev = mkBtn(CtrlArea, UDim2.new(0.13,0,0.34,0), UDim2.new(0.18,0,0.08,0), IC.Prev, COL.Text, 1)
pressAnim(BtnPrev)
local BtnPlayBg = Instance.new("Frame")
BtnPlayBg.Size = UDim2.new(0.20,0,0.52,0); BtnPlayBg.Position = UDim2.new(0.40,0,0,0)
BtnPlayBg.BackgroundColor3 = COL.RedL; BtnPlayBg.BorderSizePixel = 0; BtnPlayBg.Parent = CtrlArea; circle(BtnPlayBg)
local BtnPlay = mkBtn(BtnPlayBg, UDim2.new(1,0,1,0), UDim2.new(0,0,0,0), IC.Play, COL.White, 1)
pressAnim(BtnPlay)
local BtnNext = mkBtn(CtrlArea, UDim2.new(0.13,0,0.34,0), UDim2.new(0.70,0,0.08,0), IC.Next, COL.Text, 1)
pressAnim(BtnNext)

local ProgBg = Instance.new("TextButton")
ProgBg.Size = UDim2.new(0.64,0,0.10,0); ProgBg.Position = UDim2.new(0.04,0,0.67,0)
ProgBg.BackgroundColor3 = Color3.fromRGB(226, 226, 231); ProgBg.BorderSizePixel = 0
ProgBg.Text = ""; ProgBg.AutoButtonColor = false; ProgBg.Parent = CtrlArea; circle(ProgBg)
local ProgFill = Instance.new("Frame")
ProgFill.Size = UDim2.new(0,0,1,0); ProgFill.BackgroundColor3 = COL.RedL
ProgFill.BorderSizePixel = 0; ProgFill.Parent = ProgBg; circle(ProgFill)
local ProgKnob = Instance.new("Frame")
ProgKnob.Size = UDim2.new(0,12,0,12); ProgKnob.AnchorPoint = Vector2.new(0.5,0.5)
ProgKnob.Position = UDim2.new(0,0,0.5,0); ProgKnob.BackgroundColor3 = COL.Red
ProgKnob.BorderSizePixel = 0; ProgKnob.Parent = ProgBg; circle(ProgKnob)

local TimeLabel = mkLabel(CtrlArea, UDim2.new(0.18,0,0.18,0), UDim2.new(0.76,0,0.63,0), "00:00 / 00:00", COL.Sub, Enum.Font.Gotham, Enum.TextXAlignment.Right)
TimeLabel.TextScaled = true

BTN_H = 0.34
BTN_Y = 0.33
DIM = COL.Sub
function hoverIcon(btn, isActive)
    btn.MouseEnter:Connect(function() if not isActive() then tw(btn, {TextColor3 = COL.Text}, 0.12) end end)
    btn.MouseLeave:Connect(function() if not isActive() then tw(btn, {TextColor3 = DIM}, 0.12) end end)
end

do
    local bd = mkBtn(BottomBar, UDim2.new(0.042,0,BTN_H,0), UDim2.new(0.638,0,BTN_Y,0), "词", DIM, 1)
    bd.Font = Enum.Font.GothamBold
    pressAnim(bd)
    hoverIcon(bd, function()
        local fg = UI.DeskCfg
        return (fg and (fg.on or fg.lock)) and true or false
    end)
    UI.DeskBtn = bd
    bd.MouseButton1Click:Connect(function()
        local fg = UI.DeskCfg
        if fg and fg.lock then
            fg.lock = false
            UI.layoutDeskLyric()
            if UI.SetStatus then UI.SetStatus("桌面歌词已解锁") end
        else
            fg.on = not fg.on
            if UI.SetStatus then UI.SetStatus(fg.on and "桌面歌词已开启" or "桌面歌词已关闭") end
        end
        UI.refreshDeskLyric()
        if UI.saveDeskCfg then UI.saveDeskCfg() end
        if UI.syncDeskBtn then UI.syncDeskBtn() end
    end)
    if UI.syncDeskBtn then UI.syncDeskBtn() end
end

BtnMode = mkBtn(BottomBar, UDim2.new(0.042,0,BTN_H,0), UDim2.new(0.682,0,BTN_Y,0), ModeChars[1], DIM, 1)
BtnMode.Font = Enum.Font.GothamBold; pressAnim(BtnMode)
hoverIcon(BtnMode, function() return State.Mode ~= 1 end)

BtnSpeed = mkBtn(BottomBar, UDim2.new(0.064,0,BTN_H,0), UDim2.new(0.730,0,BTN_Y,0), SPEEDS[State.SpeedIdx].t, DIM, 1)
BtnSpeed.Font = Enum.Font.GothamBold; pressAnim(BtnSpeed)
hoverIcon(BtnSpeed, function() return (SPEEDS[State.SpeedIdx] or SPEEDS[3]).v ~= 1 end)

BtnFav = mkBtn(BottomBar, UDim2.new(0.038,0,BTN_H,0), UDim2.new(0.803,0,BTN_Y,0), IC.FavOff, DIM, 1)
pressAnim(BtnFav)
hoverIcon(BtnFav, function() return CurrentSong and State.Favorites[CurrentSong.id] and true or false end)

BtnLyric = mkBtn(BottomBar, UDim2.new(0.038,0,BTN_H,0), UDim2.new(0.860,0,BTN_Y,0), IC.Lyric, DIM, 1)
pressAnim(BtnLyric)
hoverIcon(BtnLyric, function() return State.CurPage == "lyric" end)

BtnVol = mkBtn(BottomBar, UDim2.new(0.038,0,BTN_H,0), UDim2.new(0.917,0,BTN_Y,0), IC.Vol, DIM, 1)
pressAnim(BtnVol)
hoverIcon(BtnVol, function() return State.Muted end)

local VolPanel
local SpdPanel, SpdBig, SpdFill, SpdKnob, SpdBg, BtnLink

function linkText()
    if State.PitchLink then return "跟随倍速" end
    return "锁定原调"
end

applyAudio = function()
    local sp = SPEEDS[State.SpeedIdx] or SPEEDS[3]
    pcall(function() Sound.PlaybackSpeed = sp.v end)
    local oct = 1
    if State.PitchLink then
        oct = 1
    else
        oct = 1 / sp.v
    end
    pcall(function() if PitchFx then PitchFx.Octave = oct end end)
    BtnSpeed.Text = sp.t
    UI.setCol(BtnSpeed, (sp.v == 1) and DIM or COL.Gold)
    if SpdBig then
        SpdBig.Text = sp.t
        UI.setCol(SpdBig, (sp.v == 1) and DIM or COL.Gold)
    end
    if SpdFill then SpdFill.Size = UDim2.new((State.SpeedIdx - 1) / (#SPEEDS - 1), 0, 1, 0) end
    if SpdKnob then SpdKnob.Position = UDim2.new((State.SpeedIdx - 1) / (#SPEEDS - 1), 0, 0.5, 0) end
    if BtnLink then
        BtnLink.Text = linkText()
        if State.PitchLink then
            BtnLink.BackgroundColor3 = COL.RedL
            UI.setCol(BtnLink, COL.White)
        else
            BtnLink.BackgroundColor3 = Color3.fromRGB(226, 226, 231)
            UI.setCol(BtnLink, COL.Sub)
        end
    end
end

SpdPanel = Instance.new("Frame")
SpdPanel.Size = UDim2.new(0.30, 0, 0.30, 0)
SpdPanel.AnchorPoint = Vector2.new(1, 1)
SpdPanel.Position = UDim2.new(0.985, 0, 0.855, 0)
SpdPanel.BackgroundColor3 = COL.Card
SpdPanel.BorderSizePixel = 0
SpdPanel.Visible = false
SpdPanel.Parent = Main
corner(SpdPanel, 0.10); stroke(SpdPanel, COL.Line, 1)

mkLabel(SpdPanel, UDim2.new(0.9,0,0.14,0), UDim2.new(0.05,0,0.04,0), "播放倍速", COL.Sub, Enum.Font.Gotham, Enum.TextXAlignment.Center)

SpdBig = mkLabel(SpdPanel, UDim2.new(0.9,0,0.22,0), UDim2.new(0.05,0,0.19,0), SPEEDS[State.SpeedIdx].t, COL.Text, Enum.Font.GothamBold, Enum.TextXAlignment.Center)

SpdBg = Instance.new("Frame")
SpdBg.Size = UDim2.new(0.84,0,0.16,0); SpdBg.Position = UDim2.new(0.08,0,0.44,0)
SpdBg.BackgroundColor3 = Color3.fromRGB(226, 226, 231); SpdBg.BorderSizePixel = 0
SpdBg.Parent = SpdPanel; circle(SpdBg)
SpdFill = Instance.new("Frame")
SpdFill.Size = UDim2.new(0,0,1,0); SpdFill.BackgroundColor3 = COL.RedL
SpdFill.BorderSizePixel = 0; SpdFill.Parent = SpdBg; circle(SpdFill)
SpdKnob = Instance.new("Frame")
SpdKnob.Size = UDim2.new(0,16,0,16); SpdKnob.AnchorPoint = Vector2.new(0.5,0.5)
SpdKnob.Position = UDim2.new(0,0,0.5,0); SpdKnob.BackgroundColor3 = COL.Red
SpdKnob.BorderSizePixel = 0; SpdKnob.Parent = SpdBg; circle(SpdKnob)

SpdHit = Instance.new("TextButton")
SpdHit.Size = UDim2.new(0.94,0,0.24,0); SpdHit.Position = UDim2.new(0.03,0,0.40,0)
SpdHit.BackgroundTransparency = 1
SpdHit.Text = ""
SpdHit.AutoButtonColor = false
SpdHit.Parent = SpdPanel

TickRow = Instance.new("Frame")
TickRow.Size = UDim2.new(0.84,0,0.10,0); TickRow.Position = UDim2.new(0.08,0,0.62,0)
TickRow.BackgroundTransparency = 1; TickRow.Parent = SpdPanel
do
    local n = #SPEEDS
    for ti, tv in ipairs(SPEEDS) do
        local show = (ti == 1) or (ti == n) or ((ti - 1) % 2 == 0)
        if show then
            local px = (ti - 1) / (n - 1) - 0.11
            if ti == 1 then px = 0 elseif ti == n then px = 0.78 end
            local tl = mkLabel(TickRow, UDim2.new(0.22,0,1,0), UDim2.new(px, 0, 0, 0), tv.t, COL.Sub, Enum.Font.Gotham, Enum.TextXAlignment.Center)
            tl.Name = "T" .. ti
        end
    end
end

BtnLink = mkBtn(SpdPanel, UDim2.new(0.9,0,0.19,0), UDim2.new(0.05,0,0.78,0), linkText(), COL.White, 0)
BtnLink.BackgroundColor3 = COL.RedL; BtnLink.Font = Enum.Font.GothamBold
corner(BtnLink, 0.3); pressAnim(BtnLink)

BtnSpeed.MouseButton1Click:Connect(function()
    if VolPanel then VolPanel.Visible = false end
    SpdPanel.Visible = not SpdPanel.Visible
    if SpdPanel.Visible then
        SpdPanel.ZIndex = 60
        popIn(SpdPanel, 0.85, 0.22)
    end
end)

BtnLink.MouseButton1Click:Connect(function()
    State.PitchLink = not State.PitchLink
    applyAudio()
    saveAudio()
    popIn(BtnLink, 0.86, 0.2)
    if UI.SetStatus then
        UI.SetStatus(State.PitchLink and "音调跟随倍速" or "音调锁定原调")
        task.delay(1.6, function() if UI.SetStatus and not State.Loading then UI.SetStatus("") end end)
    end
end)

spdDrag = false
function setSpeedAt(x)
    local rel = math.clamp((x - SpdBg.AbsolutePosition.X) / math.max(1, SpdBg.AbsoluteSize.X), 0, 1)
    local idx = ratioToIndex(rel)
    if idx ~= State.SpeedIdx then
        State.SpeedIdx = idx
        applyAudio()
        saveAudio()
    end
end
SpdHit.InputBegan:Connect(function(inp) if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and inp.UserInputType ~= Enum.UserInputType.Touch then return end spdDrag = true; setSpeedAt(inp.Position.X) end)
UIS.InputChanged:Connect(function(inp)
    if spdDrag and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
        setSpeedAt(inp.Position.X)
    end
end)
UIS.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        spdDrag = false
    end
end)

VolPanel = Instance.new("Frame")
VolPanel.Size = UDim2.new(0.30, 0, 0.26, 0)
VolPanel.AnchorPoint = Vector2.new(1, 1)
VolPanel.Position = UDim2.new(0.985, 0, 0.855, 0)
VolPanel.BackgroundColor3 = COL.Card
VolPanel.BorderSizePixel = 0
VolPanel.Visible = false
VolPanel.Parent = Main
corner(VolPanel, 0.10); stroke(VolPanel, COL.Line, 1)

VolPct = mkLabel(VolPanel, UDim2.new(0.9,0,0.24,0), UDim2.new(0.05,0,0.05,0), "70%", COL.Text, Enum.Font.GothamBold, Enum.TextXAlignment.Center)

VolBg = Instance.new("Frame")
VolBg.Size = UDim2.new(0.84,0,0.16,0); VolBg.Position = UDim2.new(0.08,0,0.38,0)
VolBg.BackgroundColor3 = Color3.fromRGB(226, 226, 231); VolBg.BorderSizePixel = 0
VolBg.Parent = VolPanel; circle(VolBg)
VolFill = Instance.new("Frame")
VolFill.Size = UDim2.new(0.7,0,1,0); VolFill.BackgroundColor3 = COL.RedL
VolFill.BorderSizePixel = 0; VolFill.Parent = VolBg; circle(VolFill)
VolKnob = Instance.new("Frame")
VolKnob.Size = UDim2.new(0,16,0,16); VolKnob.AnchorPoint = Vector2.new(0.5,0.5)
VolKnob.Position = UDim2.new(0.7,0,0.5,0); VolKnob.BackgroundColor3 = COL.Red
VolKnob.BorderSizePixel = 0; VolKnob.Parent = VolBg; circle(VolKnob)

VolHit = Instance.new("TextButton")
VolHit.Size = UDim2.new(0.94,0,0.44,0); VolHit.Position = UDim2.new(0.03,0,0.24,0)
VolHit.BackgroundTransparency = 1
VolHit.Text = ""
VolHit.AutoButtonColor = false
VolHit.Parent = VolPanel

BtnMute = mkBtn(VolPanel, UDim2.new(0.9,0,0.24,0), UDim2.new(0.05,0,0.68,0), "静音", COL.Text, 0)
BtnMute.BackgroundColor3 = Color3.fromRGB(226, 226, 231); BtnMute.Font = Enum.Font.Gotham
corner(BtnMute, 0.3); pressAnim(BtnMute)

MINI_GAP = 6
MiniPos = {X = 0.985, Y = 0.075}
DockSide = "right"
DockY = 0.5
dockMoved = false

function ncmSafeInset()
    local top = 0
    pcall(function() top = game:GetService("GuiService"):GetGuiInset().Y end)
    if type(top) ~= "number" or top < 0 then top = 0 end
    if top > 90 then top = 90 end
    return 8, 0, 14
end

MiniLayer = Instance.new("Frame")
MiniLayer.Name = "MiniLayer"
MiniLayer.Size = UDim2.new(1, 0, 1, 0)
MiniLayer.BackgroundTransparency = 1
MiniLayer.BorderSizePixel = 0
MiniLayer.ClipsDescendants = true
MiniLayer.Parent = gui

MiniTop = Instance.new("Frame")
MiniTop.Name = "MiniTop"
MiniTop.AnchorPoint = Vector2.new(1, 0)
MiniTop.Position = UDim2.new(MiniPos.X, 0, MiniPos.Y, 0)
MiniTop.BackgroundColor3 = COL.Bottom
MiniTop.BackgroundTransparency = 0.05
MiniTop.BorderSizePixel = 0
MiniTop.Visible = false
MiniTop.Parent = MiniLayer
corner(MiniTop, 0.18); stroke(MiniTop, COL.Line, 1)

MiniBot = Instance.new("Frame")
MiniBot.Name = "MiniBot"
MiniBot.AnchorPoint = Vector2.new(1, 0)
MiniBot.BackgroundColor3 = COL.Bottom
MiniBot.BackgroundTransparency = 0.05
MiniBot.BorderSizePixel = 0
MiniBot.Visible = false
MiniBot.Parent = MiniLayer
corner(MiniBot, 0.22); stroke(MiniBot, COL.Line, 1)

M_Vinyl = Instance.new("Frame")
M_Vinyl.BackgroundColor3 = Color3.fromRGB(16,16,18)
M_Vinyl.BorderSizePixel = 0; M_Vinyl.Parent = MiniTop; circle(M_Vinyl)
M_Ring = Instance.new("Frame")
M_Ring.AnchorPoint = Vector2.new(0.5,0.5); M_Ring.Position = UDim2.new(0.5,0,0.5,0)
M_Ring.Size = UDim2.new(0.42,0,0.42,0); M_Ring.BackgroundColor3 = COL.Red
M_Ring.BorderSizePixel = 0; M_Ring.Parent = M_Vinyl; circle(M_Ring)
M_Dot = Instance.new("Frame")
M_Dot.AnchorPoint = Vector2.new(0.5,0.5); M_Dot.Position = UDim2.new(0.5,0,0.5,0)
M_Dot.Size = UDim2.new(0.22,0,0.22,0); M_Dot.BackgroundColor3 = COL.White
M_Dot.BorderSizePixel = 0; M_Dot.Parent = M_Ring; circle(M_Dot)

M_Name = mkLabel(MiniTop, UDim2.new(0,0,0,0), UDim2.new(0,0,0,0), "未在播放", COL.Text, Enum.Font.GothamBold)
M_Name.TextTruncate = Enum.TextTruncate.AtEnd
M_Artist = mkLabel(MiniTop, UDim2.new(0,0,0,0), UDim2.new(0,0,0,0), "", COL.Sub, Enum.Font.Gotham)
M_Artist.TextTruncate = Enum.TextTruncate.AtEnd

M_Prev = mkBtn(MiniTop, UDim2.new(0,0,0,0), UDim2.new(0,0,0,0), IC.Prev, Color3.fromRGB(88,88,100), 0)
M_Prev.BackgroundColor3 = Color3.fromRGB(240,240,246)
M_Prev.Font = Enum.Font.GothamBold
circle(M_Prev); stroke(M_Prev, COL.Line, 1); pressAnim(M_Prev)
M_Vol = mkBtn(MiniTop, UDim2.new(0,0,0,0), UDim2.new(0,0,0,0), IC.Vol, Color3.fromRGB(88,88,100), 0)
M_Vol.BackgroundColor3 = Color3.fromRGB(240,240,246)
M_Vol.Font = Enum.Font.GothamBold
circle(M_Vol); stroke(M_Vol, COL.Line, 1); pressAnim(M_Vol)
M_Lyric = mkBtn(MiniTop, UDim2.new(0,0,0,0), UDim2.new(0,0,0,0), IC.Lyric, Color3.fromRGB(88,88,100), 0)
M_Lyric.BackgroundColor3 = Color3.fromRGB(240,240,246)
M_Lyric.Font = Enum.Font.GothamBold
M_Lyric.Visible = false
circle(M_Lyric); stroke(M_Lyric, COL.Line, 1); pressAnim(M_Lyric)
M_Play = mkBtn(MiniTop, UDim2.new(0,0,0,0), UDim2.new(0,0,0,0), IC.Play, COL.White, 0)
M_Play.BackgroundColor3 = COL.Red
M_Play.Font = Enum.Font.GothamBold
circle(M_Play); pressAnim(M_Play)
M_Next = mkBtn(MiniTop, UDim2.new(0,0,0,0), UDim2.new(0,0,0,0), IC.Next, Color3.fromRGB(88,88,100), 0)
M_Next.BackgroundColor3 = Color3.fromRGB(240,240,246)
M_Next.Font = Enum.Font.GothamBold
circle(M_Next); stroke(M_Next, COL.Line, 1); pressAnim(M_Next)
M_Expand = mkBtn(MiniTop, UDim2.new(0,0,0,0), UDim2.new(0,0,0,0), "", COL.Text, 1)

M_Collapse = mkBtn(MiniTop, UDim2.new(0,0,0,0), UDim2.new(0,0,0,0), IC.Collapse, Color3.fromRGB(120,120,132), 0)
M_Collapse.BackgroundColor3 = Color3.fromRGB(240,240,246)
M_Collapse.Font = Enum.Font.GothamBold
circle(M_Collapse); stroke(M_Collapse, COL.Line, 1); pressAnim(M_Collapse)

MiniDock = Instance.new("TextButton")
MiniDock.Name = "MiniDock"
MiniDock.AnchorPoint = Vector2.new(1, 0.5)
MiniDock.BackgroundColor3 = COL.Red
MiniDock.BackgroundTransparency = 0.04
MiniDock.BorderSizePixel = 0
MiniDock.Text = IC.Dock
MiniDock.TextColor3 = COL.White
MiniDock.Font = Enum.Font.GothamBold
MiniDock.TextScaled = false
MiniDock.AutoButtonColor = false
MiniDock.Visible = false
MiniDock.ZIndex = 6
MiniDock.Parent = MiniLayer
corner(MiniDock, 0.34); stroke(MiniDock, COL.White, 1)

function __NCM_DeskLyricBlock()
    local DL = Instance.new("Frame")
    DL.Name = "DeskLyric"
    DL.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    DL.BackgroundTransparency = 1
    DL.BorderSizePixel = 0
    DL.AnchorPoint = Vector2.new(0.5, 0)
    DL.Active = true
    DL.Visible = false
    DL.ZIndex = 7
    DL.ClipsDescendants = true
    DL.Parent = MiniLayer
    corner(DL, 0.26)
    UI.DeskLyric = DL

    local l1 = Instance.new("TextLabel")
    l1.BackgroundTransparency = 1
    l1.Text = ""
    l1.TextColor3 = COL.White
    l1.Font = Enum.Font.GothamBold
    l1.TextScaled = false
    l1.TextXAlignment = Enum.TextXAlignment.Center
    l1.TextYAlignment = Enum.TextYAlignment.Center
    l1.TextTruncate = Enum.TextTruncate.AtEnd
    l1.ZIndex = 8
    l1.Parent = DL
    do local s = Instance.new("UIStroke"); s.Color = Color3.fromRGB(0, 0, 0)
        s.Thickness = 1.7; s.Transparency = 0.30; s.Parent = l1; UI.DeskS1 = s end
    UI.DeskL1 = l1

    local l2 = Instance.new("TextLabel")
    l2.BackgroundTransparency = 1
    l2.Text = ""
    l2.TextColor3 = Color3.fromRGB(205, 205, 212)
    l2.Font = Enum.Font.Gotham
    l2.TextScaled = false
    l2.TextXAlignment = Enum.TextXAlignment.Center
    l2.TextYAlignment = Enum.TextYAlignment.Center
    l2.TextTruncate = Enum.TextTruncate.AtEnd
    l2.ZIndex = 8
    l2.Parent = DL
    do local s = Instance.new("UIStroke"); s.Color = Color3.fromRGB(0, 0, 0)
        s.Thickness = 1.3; s.Transparency = 0.45; s.Parent = l2; UI.DeskS2 = s end
    UI.DeskL2 = l2

    UI.DeskPos = {X = 0.5, Y = 0.72}
    do
        local def = {on = true, fs = 2, ol = true, dual = true, lock = false}
        UI.DeskCfg = {}
        for k, v in pairs(def) do UI.DeskCfg[k] = v end
        pcall(function()
            if fnIsFile and fnRead then
                local f = CFG.VolDir .. "/desklyric.json"
                if fnIsFile(f) then
                    local d = jsonDecode(fnRead(f) or "")
                    if type(d) == "table" then
                        for k, v in pairs(def) do
                            if type(d[k]) == type(v) then UI.DeskCfg[k] = d[k] end
                        end
                        if type(d.px) == "number" and type(d.py) == "number" then
                            UI.DeskPos.X = math.clamp(d.px, 0, 1)
                            UI.DeskPos.Y = math.clamp(d.py, 0, 1)
                        end
                        if type(d.fs) == "number" then UI.DeskCfg.fs = math.clamp(math.floor(d.fs), 1, 3) end
                    end
                end
            end
        end)
    end
    UI.saveDeskCfg = function()
        pcall(function()
            ensureDir(CFG.VolDir)
            if fnWrite then
                local c = UI.DeskCfg
                fnWrite(CFG.VolDir .. "/desklyric.json", HttpService:JSONEncode({
                    on = c.on, fs = c.fs, ol = c.ol, dual = c.dual, lock = c.lock,
                    px = (UI.DeskPos and UI.DeskPos.X) or 0.5,
                    py = (UI.DeskPos and UI.DeskPos.Y) or 0.72}))
            end
        end)
    end

    local setBtn = Instance.new("TextButton")
    setBtn.Name = "DeskSetBtn"
    setBtn.Size = UDim2.new(0, 22, 0, 22)
    setBtn.Position = UDim2.new(1, -26, 0, 3)
    setBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
    setBtn.BackgroundTransparency = 0.25
    setBtn.BorderSizePixel = 0
    setBtn.Text = "设"
    setBtn.TextColor3 = COL.White
    setBtn.TextSize = 10
    setBtn.Font = Enum.Font.GothamBold
    setBtn.AutoButtonColor = false
    setBtn.ZIndex = 11
    setBtn.Visible = false
    setBtn.Parent = DL
    circle(setBtn)
    UI.DeskSetBtn = setBtn

    local function inSetBtn(x, y)
        if not setBtn.Visible then return false end
        local ap = setBtn.AbsolutePosition
        local as = setBtn.AbsoluteSize
        if not ap or not as then return false end
        if as.X <= 0 or as.Y <= 0 then return false end
        return x >= ap.X - 2 and x <= ap.X + as.X + 2 and y >= ap.Y - 2 and y <= ap.Y + as.Y + 2
    end

    local setGen = 0
    local function hideSetBtn()
        setGen = setGen + 1
        setBtn.Visible = false
    end
    UI.hideDeskSetBtn = hideSetBtn
    UI.showDeskSetBtn = function()
        setBtn.Visible = true
        setGen = setGen + 1
        local g = setGen
        task.delay(6, function()
            if g == setGen then setBtn.Visible = false end
        end)
    end

    local hideSeq = 0
    local function deskFadeOut()
        if not DL.Visible then return end
        hideSeq = hideSeq + 1
        local sq = hideSeq
        pcall(function()
            tw(l1, {TextTransparency = 1}, 0.16)
            tw(l2, {TextTransparency = 1}, 0.16)
            if UI.DeskS1 then tw(UI.DeskS1, {Transparency = 1}, 0.16) end
            if UI.DeskS2 then tw(UI.DeskS2, {Transparency = 1}, 0.16) end
        end)
        task.delay(0.17, function()
            if sq == hideSeq then DL.Visible = false end
        end)
    end
    UI.deskFadeOut = deskFadeOut

    local function deskFadeIn(dur)
        local d = dur or 0.30
        local t1 = (UI.DeskS1 and UI.DeskS1.Enabled ~= false) and 0.30 or 1
        local t2 = (UI.DeskS2 and UI.DeskS2.Enabled ~= false) and 0.45 or 1
        pcall(function()
            l1.TextTransparency = 1
            l2.TextTransparency = 1
            if UI.DeskS1 then UI.DeskS1.Transparency = 1 end
            if UI.DeskS2 then UI.DeskS2.Transparency = 1 end
            tw(l1, {TextTransparency = 0}, d)
            tw(l2, {TextTransparency = 0}, d)
            if UI.DeskS1 then tw(UI.DeskS1, {Transparency = t1}, d) end
            if UI.DeskS2 then tw(UI.DeskS2, {Transparency = t2}, d) end
        end)
    end
    UI.deskFadeIn = deskFadeIn

    local l1Prev, l2Prev = nil, nil
    local function deskLineAnim()
        if not DL.Visible then return end
        local c1 = (l1.Text ~= l1Prev)
        local c2 = (l2.Text ~= l2Prev)
        l1Prev = l1.Text
        l2Prev = l2.Text
        if not (c1 or c2) then return end
        pcall(function()
            if c1 then
                l1.TextTransparency = 0.55
                tw(l1, {TextTransparency = 0}, 0.20)
            end
            if c2 then
                l2.TextTransparency = 0.75
                tw(l2, {TextTransparency = 0}, 0.20)
            end
        end)
    end
    UI.deskLineAnim = deskLineAnim

    function UI.layoutDeskLyric()
        local vw, vh = gui.AbsoluteSize.X, gui.AbsoluteSize.Y
        if vw <= 0 or vh <= 0 then return end
        local fg = UI.DeskCfg
        local w = math.min(vw * 0.86, 460)
        local fsm = (fg.fs == 1) and 0.020 or ((fg.fs == 3) and 0.034 or 0.026)
        local fs = math.clamp(vh * fsm, 11, 26)
        local fs2 = math.max(10, math.floor(fs * 0.76))
        local pad = math.max(8, math.floor(fs * 0.6))
        local h
        if fg.dual then
            l2.Visible = true
            h = math.floor(pad * 2 + fs + 5 + fs2 + 4)
        else
            l2.Visible = false
            h = math.floor(pad * 2 + fs + 4)
        end
        DL.Size = UDim2.new(0, w, 0, h)
        l1.Size = UDim2.new(1, -pad * 2, 0, fs + 5)
        l1.Position = UDim2.new(0, pad, 0, pad)
        l1.TextSize = fs
        l2.Size = UDim2.new(1, -pad * 2, 0, fs2 + 4)
        l2.Position = UDim2.new(0, pad, 0, pad + fs + 5)
        l2.TextSize = fs2
        DL.BackgroundTransparency = 1
        if UI.DeskS1 then UI.DeskS1.Enabled = (fg.ol ~= false) end
        if UI.DeskS2 then UI.DeskS2.Enabled = (fg.ol ~= false) end
        DL.Active = (fg.lock ~= true)
        if fg.lock == true then hideSetBtn() end
        local SX, ST, SB = ncmSafeInset()
        local lo = SX + w * 0.5
        local hi = vw - SX - w * 0.5
        if lo > hi then lo, hi = vw * 0.5, vw * 0.5 end
        local cx = math.clamp((UI.DeskPos.X or 0.5) * vw, lo, hi)
        local tMin = ST
        local tMax = vh - SB - h
        if tMax < tMin then tMax = tMin end
        local cy = math.clamp((UI.DeskPos.Y or 0.72) * vh, tMin, tMax)
        DL.Position = UDim2.new(0, cx, 0, cy)
        UI.DeskPos.X = cx / vw
        UI.DeskPos.Y = cy / vh
        UI.DeskW = w
        UI.DeskH = h
    end

    function UI.setDeskLyric(i)
        local n = (State.Lyrics and #State.Lyrics) or 0
        if n == 0 then
            l1.Text = ""
            l2.Text = ""
            DL.Visible = false
            return
        end
        i = math.clamp(i or 1, 1, n)
        l1.Text = (State.Lyrics[i] and State.Lyrics[i].text) or ""
        l2.Text = (State.Lyrics[i + 1] and State.Lyrics[i + 1].text) or ""
        if UI.deskLineAnim then UI.deskLineAnim() end
    end

    function UI.showDeskLyric(on)
        if not on then
            deskFadeOut()
            return
        end
        if not (UI.DeskCfg and UI.DeskCfg.on) then
            deskFadeOut()
            return
        end
        local n = (State.Lyrics and #State.Lyrics) or 0
        if n == 0 then
            DL.Visible = false
            return
        end
        UI.layoutDeskLyric()
        UI.setDeskLyric(State.LyricLine or 1)
        DL.Visible = true
        deskFadeIn(0.32)
    end

    function UI.refreshDeskLyric()
        if not (UI.DeskCfg and UI.DeskCfg.on) then
            deskFadeOut()
            return
        end
        local n = (State.Lyrics and #State.Lyrics) or 0
        if n == 0 then
            DL.Visible = false
            return
        end
        UI.layoutDeskLyric()
        UI.setDeskLyric(State.LyricLine or 1)
        if not DL.Visible then
            DL.Visible = true
            deskFadeIn(0.24)
        end
    end

    local dSt = {drag = false, sx = 0, sy = 0, bx = 0, by = 0, moved = false}
    local function inDL(x, y)
        local ap = DL.AbsolutePosition
        local as = DL.AbsoluteSize
        if not ap or not as then return false end
        if as.X <= 0 or as.Y <= 0 then return false end
        return x >= ap.X - 2 and x <= ap.X + as.X + 2 and y >= ap.Y - 2 and y <= ap.Y + as.Y + 2
    end
    UIS.InputBegan:Connect(function(inp)
        if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and inp.UserInputType ~= Enum.UserInputType.Touch then return end
        if not DL.Visible then return end
        if not inDL(inp.Position.X, inp.Position.Y) then return end
        if UI.DeskCfg and UI.DeskCfg.lock then return end
        local vw, vh = gui.AbsoluteSize.X, gui.AbsoluteSize.Y
        if vw <= 0 or vh <= 0 then return end
        dSt.drag = true; dSt.moved = false
        dSt.sx = inp.Position.X; dSt.sy = inp.Position.Y
        local bxx = (UI.DeskPos and UI.DeskPos.X) or 0.5
        local byy = (UI.DeskPos and UI.DeskPos.Y) or 0.72
        if type(bxx) ~= "number" or type(byy) ~= "number" then
            bxx = 0.5; byy = 0.72
        end
        dSt.bx = bxx * vw
        dSt.by = byy * vh
    end)
    UIS.InputChanged:Connect(function(inp)
        if not dSt.drag or not DL.Visible then return end
        if inp.UserInputType ~= Enum.UserInputType.MouseMovement and inp.UserInputType ~= Enum.UserInputType.Touch then return end
        local p = inp.Position
        local dx = p.X - dSt.sx
        local dy = p.Y - dSt.sy
        if not dSt.moved then
            if math.abs(dx) + math.abs(dy) < 6 then return end
            dSt.moved = true
            hideSetBtn()
        end
        local vw, vh = gui.AbsoluteSize.X, gui.AbsoluteSize.Y
        if vw <= 0 or vh <= 0 then return end
        local w = UI.DeskW or 200
        local h = UI.DeskH or 60
        if type(w) ~= "number" or w <= 0 then w = 200 end
        if type(h) ~= "number" or h <= 0 then h = 60 end
        local SX, ST, SB = ncmSafeInset()
        local lo = SX + w * 0.5
        local hi = vw - SX - w * 0.5
        if lo > hi then lo, hi = vw * 0.5, vw * 0.5 end
        local tMin = ST
        local tMax = vh - SB - h
        if tMax < tMin then tMax = tMin end
        local nx = math.clamp(dSt.bx + dx, lo, hi)
        local ny = math.clamp(dSt.by + dy, tMin, tMax)
        DL.Position = UDim2.new(0, nx, 0, ny)
        UI.DeskPos.X = nx / vw
        UI.DeskPos.Y = ny / vh
        if UI.saveDeskCfg then UI.saveDeskCfg() end
    end)
    UIS.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            if dSt.drag and not dSt.moved and DL.Visible then
                if not (UI.DeskCfg and UI.DeskCfg.lock) and inDL(dSt.sx, dSt.sy) then
                    if not inSetBtn(inp.Position.X, inp.Position.Y) then
                        if UI.showDeskSetBtn then UI.showDeskSetBtn() end
                    end
                end
            end
            dSt.drag = false
            dSt.moved = false
        end
    end)

    setBtn.MouseButton1Click:Connect(function()
        hideSetBtn()
        if UI.openDeskSetFromFloat then UI.openDeskSetFromFloat() end
    end)

    UI.openDeskSetFromFloat = function()
        MiniDock.Visible = false
        MiniTop.Visible = false
        MiniBot.Visible = false
        Main.Visible = true
        MainScale.Scale = 1
        if UI.showDeskLyric then UI.showDeskLyric(false) end
        showPage("lyric")
        if BtnLyric then UI.setCol(BtnLyric, COL.Gold) end
        if UI.syncDeskBtn then UI.syncDeskBtn() end
        if UI.openDeskSet then UI.openDeskSet() end
    end
end
__NCM_DeskLyricBlock()

M_Time = mkLabel(MiniBot, UDim2.new(0,0,0,0), UDim2.new(0,0,0,0), "00:00 / 00:00", COL.Sub, Enum.Font.Gotham)
M_ProgBg = Instance.new("TextButton")
M_ProgBg.BackgroundColor3 = Color3.fromRGB(226, 226, 231); M_ProgBg.BorderSizePixel = 0
M_ProgBg.Text = ""; M_ProgBg.AutoButtonColor = false; M_ProgBg.Parent = MiniBot; circle(M_ProgBg)
M_ProgFill = Instance.new("Frame")
M_ProgFill.BackgroundColor3 = COL.RedL; M_ProgFill.BorderSizePixel = 0; M_ProgFill.Parent = M_ProgBg; circle(M_ProgFill)
do
    local gd = Instance.new("UIGradient")
    gd.Color = ColorSequence.new(Color3.fromRGB(240,90,90), Color3.fromRGB(194,12,12))
    gd.Parent = M_ProgFill
end
M_ProgKnob = Instance.new("Frame")
M_ProgKnob.AnchorPoint = Vector2.new(0.5,0.5); M_ProgKnob.BackgroundColor3 = COL.Red
M_ProgKnob.BorderSizePixel = 0; M_ProgKnob.Parent = M_ProgBg; circle(M_ProgKnob)

function layoutMini()
    local vw = gui.AbsoluteSize.X
    local vh = gui.AbsoluteSize.Y
    if vw <= 0 or vh <= 0 then return end

    local topH = math.max(36, vh * 0.060)
    local botH = math.max(26, vh * 0.042)
    local w    = math.min(vw * 0.80, topH * 7.8)
    UI.MiniW = w
    UI.MiniTopH = topH
    UI.MiniBotH = botH
    UI.MiniH = topH + MINI_GAP + botH
    do
        local SX, ST, SB = ncmSafeInset()
        local hh = topH + MINI_GAP + botH
        local rMin = w + SX
        local rMax = vw - SX
        if rMin > rMax then rMin, rMax = vw * 0.5, vw * 0.5 end
        local tMin = ST
        local tMax = vh - hh - SB
        if tMax < tMin then tMax = math.max(tMin, vh - SB - hh * 0.5) end
        MiniPos.X = math.clamp((MiniPos.X or 0.985) * vw, rMin, rMax) / vw
        MiniPos.Y = math.clamp((MiniPos.Y or 0.075) * vh, tMin, tMax) / vh
    end

    MiniTop.Size = UDim2.new(0, w, 0, topH)
    MiniTop.Position = UDim2.new(MiniPos.X, 0, MiniPos.Y, 0)

    local side = topH * 0.70
    M_Vinyl.Size = UDim2.new(0, side, 0, side)
    M_Vinyl.Position = UDim2.new(0, topH * 0.15, 0, (topH - side) * 0.5)

    local nx = topH * 0.15 + side + topH * 0.16
    local btn = topH * 0.60
    local pbtn = btn * 1.16
    local cbtn = btn * 0.78
    local gap = topH * 0.09
    local rpad = topH * 0.14
    local tail = cbtn + gap + btn + gap + pbtn + gap + btn + gap + btn + rpad
    local nameW = math.max(10, w - nx - tail)

    M_Name.Size = UDim2.new(0, nameW, 0, topH * 0.34)
    M_Name.Position = UDim2.new(0, nx, 0, topH * 0.13)
    M_Name.TextSize = math.max(9, topH * 0.29)
    M_Artist.Size = UDim2.new(0, nameW, 0, topH * 0.26)
    M_Artist.Position = UDim2.new(0, nx, 0, topH * 0.52)
    M_Artist.TextSize = math.max(8, topH * 0.21)

    local xcol = w - rpad - cbtn
    M_Collapse.Size = UDim2.new(0, cbtn, 0, cbtn)
    M_Collapse.Position = UDim2.new(0, xcol, 0, (topH - cbtn) * 0.5)
    M_Collapse.Text = ((MiniPos.X or 0.985) > 0.5) and IC.Collapse or IC.CollapseL
    M_Next.Size = UDim2.new(0, btn, 0, btn)
    M_Next.Position = UDim2.new(0, xcol - gap - btn, 0, (topH - btn) * 0.5)
    M_Play.Size = UDim2.new(0, pbtn, 0, pbtn)
    local xplay = xcol - gap - btn - gap - pbtn
    M_Play.Position = UDim2.new(0, xplay, 0, (topH - pbtn) * 0.5)
    M_Prev.Size = UDim2.new(0, btn, 0, btn)
    M_Prev.Position = UDim2.new(0, xplay - gap - btn, 0, (topH - btn) * 0.5)
    M_Vol.Size = UDim2.new(0, btn, 0, btn)
    M_Vol.Position = UDim2.new(0, xplay - gap - btn - gap - btn, 0, (topH - btn) * 0.5)
    M_Lyric.Visible = false
    M_Lyric.Size = UDim2.new(0, 0, 0, 0)
    M_Expand.Size = UDim2.new(0, nx + nameW, 0, topH)
    M_Expand.Position = UDim2.new(0, 0, 0, 0)

    MiniBot.Size = UDim2.new(0, w, 0, botH)
    MiniBot.Position = UDim2.new(MiniPos.X, 0, MiniPos.Y, topH + MINI_GAP)

    M_Time.Size = UDim2.new(0, w * 0.42, 0, botH * 0.40)
    M_Time.Position = UDim2.new(0, w * 0.04, 0, botH * 0.06)
    M_Time.TextSize = math.max(8, botH * 0.34)

    local pbH = math.max(5, botH * 0.26)
    M_ProgBg.Size = UDim2.new(0, w * 0.92, 0, pbH)
    M_ProgBg.Position = UDim2.new(0, w * 0.04, 0, botH * 0.56)
    M_ProgFill.Size = UDim2.new(0, 0, 1, 0)
    M_ProgKnob.Size = UDim2.new(0, pbH * 1.7, 0, pbH * 1.7)
    M_ProgKnob.Position = UDim2.new(0, 0, 0.5, 0)

    local dw = math.max(20, topH * 0.62)
    local dh = math.max(54, topH + MINI_GAP + botH)
    UI.DockW = dw
    UI.DockH = dh
    MiniDock.Size = UDim2.new(0, dw, 0, dh)
    MiniDock.TextSize = math.max(10, math.floor(dw * 0.52))
    local SX, ST, SB = ncmSafeInset()
    local dyMin = (ST + dh * 0.5) / vh
    local dyMax = (vh - SB - dh * 0.5) / vh
    if dyMax < dyMin then dyMax = dyMin end
    local dy = math.clamp(DockY or 0.5, dyMin, dyMax)
    if DockSide == "left" then
        MiniDock.AnchorPoint = Vector2.new(0, 0.5)
        MiniDock.Position = UDim2.new(0, 4, dy, 0)
    else
        MiniDock.AnchorPoint = Vector2.new(1, 0.5)
        MiniDock.Position = UDim2.new(1, -4, dy, 0)
    end
    if UI.layoutDeskLyric then UI.layoutDeskLyric() end
end

function collapseMini()
    local vw, vh = gui.AbsoluteSize.X, gui.AbsoluteSize.Y
    if vw <= 0 or vh <= 0 then return end
    DockSide = ((MiniPos.X or 0.985) > 0.5) and "right" or "left"
    local th = UI.MiniH or (MiniTop.AbsoluteSize.Y + MINI_GAP + MiniBot.AbsoluteSize.Y)
    if type(th) ~= "number" or th <= 0 then th = math.max(70, vh * 0.11) end
    DockY = math.clamp(((MiniPos.Y or 0.075) * vh + th * 0.5) / vh, 0.0, 1.0)
    MiniTop.Visible = false
    MiniBot.Visible = false
    MiniDock.Visible = true
    if UI.refreshDeskLyric then UI.refreshDeskLyric() end
    layoutMini()
    popIn(MiniDock, 0.6, 0.28)
end

function expandFromDock()
    local vw, vh = gui.AbsoluteSize.X, gui.AbsoluteSize.Y
    local SX, ST, SB = ncmSafeInset()
    if vw > 0 and vh > 0 then
        local w = UI.MiniW or MiniTop.AbsoluteSize.X
        local th = UI.MiniH or (MiniTop.AbsoluteSize.Y + MINI_GAP + MiniBot.AbsoluteSize.Y)
        if type(w) ~= "number" or w <= 0 then w = vw * 0.6 end
        if type(th) ~= "number" or th <= 0 then th = math.max(70, vh * 0.11) end
        MiniPos.X = (DockSide == "left") and ((w + SX) / vw) or (1 - SX / vw)
        MiniPos.Y = math.clamp((DockY or 0.5) - (th * 0.5) / vh, ST / vh, math.max(ST / vh, (vh - th - SB) / vh))
    end
    MiniDock.Visible = false
    MiniTop.Visible = true
    MiniBot.Visible = true
    if UI.showDeskLyric then UI.showDeskLyric(true) end
    layoutMini()
    popIn(MiniTop, 0.86, 0.30)
    popIn(MiniBot, 0.86, 0.34)
end

ROW_SCALE = 0.14
function clearList()
    for _, c in ipairs(ListScroll:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
end
function layoutList()
    local vh = ListScroll.AbsoluteSize.Y
    if vh <= 0 then return end
    local rh = math.max(26, vh * ROW_SCALE)
    local pad = math.max(3, vh * 0.018)
    local n = 0
    for _, c in ipairs(ListScroll:GetChildren()) do
        if c:IsA("TextButton") then c.Size = UDim2.new(0.965, 0, 0, rh); n = n + 1 end
    end
    ListLayout.Padding = UDim.new(0, pad)
    ListScroll.CanvasSize = UDim2.new(0, 0, 0, n * rh + math.max(0, n-1) * pad + pad * 2)
end
function renderList(songs, keepQueue)
    clearList()
    if not keepQueue then State.Queue = songs end
    RowRefs = {}
    for i, s in ipairs(songs) do
        local row = Instance.new("TextButton")
        row.Size = UDim2.new(0.965, 0, 0, 40)
        row.BackgroundColor3 = COL.Card; row.BackgroundTransparency = 0.4
        row.BorderSizePixel = 0; row.Text = ""; row.AutoButtonColor = false
        row.LayoutOrder = i; row.Parent = ListScroll; corner(row, 0.2)
        mkLabel(row, UDim2.new(0.09,0,0.7,0), UDim2.new(0.02,0,0.15,0), tostring(i), COL.Sub, Enum.Font.Gotham, Enum.TextXAlignment.Center)
        local nm = mkLabel(row, UDim2.new(0.40,0,0.46,0), UDim2.new(0.13,0,0.08,0), s.name, COL.Text, Enum.Font.GothamBold)
        nm.TextTruncate = Enum.TextTruncate.AtEnd

        local vipLbl = mkLabel(row, UDim2.new(0.10,0,0.34,0), UDim2.new(0.13,0,0.58,0), "", COL.Gold, Enum.Font.GothamBold)
        local cached = ProbeCache[s.id]
        if cached ~= nil then
            setVipMark(vipLbl, cached)
            if cached == false then row.BackgroundTransparency = 0.62 end
        elseif (s.fee or 0) == 0 then
            setVipMark(vipLbl, true)
        else
            setVipMark(vipLbl, nil)
        end
        local ar = mkBtn(row, UDim2.new(0.26,0,0.46,0), UDim2.new(0.55,0,0.27,0), s.artist, COL.Sub, 1)
        ar.Font = Enum.Font.Gotham
        ar.TextXAlignment = Enum.TextXAlignment.Left
        ar.TextTruncate = Enum.TextTruncate.AtEnd
        ar.MouseEnter:Connect(function() ar.TextColor3 = COL.Gold end)
        ar.MouseLeave:Connect(function() ar.TextColor3 = COL.Sub end)
        ar.MouseButton1Click:Connect(function()
            openArtistFromSong(s)
        end)
        mkLabel(row, UDim2.new(0.14,0,0.46,0), UDim2.new(0.84,0,0.27,0),
            string.format("%02d:%02d", math.floor((s.dur or 0)/60), math.floor((s.dur or 0)%60)), COL.Sub)
        row.MouseEnter:Connect(function() tw(row, {BackgroundColor3 = COL.CardH}, 0.12) end)
        row.MouseLeave:Connect(function() tw(row, {BackgroundColor3 = COL.Card}, 0.12) end)
        row.MouseButton1Click:Connect(function() State.Index = i; playSong(s) end)
        table.insert(RowRefs, {row = row, vip = vipLbl, song = s})
    end
    layoutList()
end

PROBE_MAX = 20
function probePlayable(songs)
    if ProbeRunning then return end
    local pending = {}
    for _, s in ipairs(songs or {}) do
        if ProbeCache[s.id] == nil and (s.fee or 0) ~= 0 then
            table.insert(pending, s)
            if #pending >= PROBE_MAX then break end
        end
    end
    if #pending == 0 then return end
    ProbeRunning = true
    task.spawn(function()
        local total, done, idx = #pending, 0, 1
        local CONC = 3
        while idx <= total do
            local active = 0
            for k = 1, CONC do
                if idx > total then break end
                local s = pending[idx]; idx = idx + 1
                active = active + 1
                task.spawn(function()
                    local info = apiUrl(s.id)
                    markProbe(s.id, info ~= nil)
                    if info and (s.fee or 0) ~= 0 then inferVipFromProbe() end
                    done = done + 1
                    active = active - 1
                    if UI.SetStatus then UI.SetStatus("探测 " .. done .. "/" .. total) end
                end)
            end
            local guard = 0
            while active > 0 and guard < 200 do task.wait(0.1); guard = guard + 1 end
        end

        for _, r in ipairs(RowRefs) do
            if ProbeCache[r.song.id] == nil then
                setVipMark(r.vip, (r.song.fee or 0) == 0)
            end
        end
        if UI.SetStatus then UI.SetStatus("") end
        ProbeRunning = false
    end)
end

lyricLines = {}
LYRIC_ROW = 0.115
function layoutLyric()
    local bh = LyricBox.AbsoluteSize.Y
    if bh > 0 then
        local lh = math.max(18, bh * LYRIC_ROW)
        LyricHolder.Size = UDim2.new(1,0,0, math.max(1, #lyricLines) * lh)
        for i, l in ipairs(lyricLines) do
            l.Size = UDim2.new(1,0,0, lh)
            l.Position = UDim2.new(0,0,0, (i-1)*lh)
            l.TextSize = math.max(10, lh * (i == State.LyricLine and 0.62 or 0.52))
        end
    end
    local sd = math.min(VinylWrap.AbsoluteSize.X, VinylWrap.AbsoluteSize.Y)
    if sd > 0 then Vinyl.Size = UDim2.new(0, sd, 0, sd) end
    local sh = math.min(VinylBox.AbsoluteSize.X, VinylBox.AbsoluteSize.Y)
    if sh > 0 then VinylS.Size = UDim2.new(0, sh, 0, sh) end
end
function UI.BuildLyrics()
    if UI.lyricReset then UI.lyricReset() end
    for _, l in ipairs(lyricLines) do l:Destroy() end
    lyricLines = {}
    LyricHolder.Size = UDim2.new(1,0,0,0); LyricHolder.Position = UDim2.new(0,0,0,0)
    State.LyricLine = 0
    if UI.setDeskLyric then UI.setDeskLyric(0) end
    if #State.Lyrics == 0 then
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1,0,0,30); l.BackgroundTransparency = 1
        l.Text = "暂无歌词"; l.TextColor3 = COL.Sub; l.TextSize = 18
        l.Font = Enum.Font.Gotham; l.TextXAlignment = Enum.TextXAlignment.Center
        l.Parent = LyricHolder
        table.insert(lyricLines, l); layoutLyric(); return
    end
    for _, it in ipairs(State.Lyrics) do
        local l = Instance.new("TextLabel")
        l.BackgroundTransparency = 1; l.Text = it.text; l.TextColor3 = COL.Sub
        l.TextSize = 18; l.Font = Enum.Font.Gotham
        l.TextXAlignment = Enum.TextXAlignment.Center
        l.TextTruncate = Enum.TextTruncate.AtEnd
        l.Parent = LyricHolder
        table.insert(lyricLines, l)
    end
    layoutLyric()
end
function setLyricLine(i, force)
    if i == State.LyricLine and not force then return end
    local prev = State.LyricLine
    State.LyricLine = i
    local bh = LyricBox.AbsoluteSize.Y
    if bh <= 0 then return end
    local lh = math.max(18, bh * LYRIC_ROW)
    if lyricLines[prev] then
        lyricLines[prev].TextColor3 = COL.Sub
        lyricLines[prev].TextSize = math.max(10, lh * 0.52)
        lyricLines[prev].Font = Enum.Font.Gotham
    end
    if lyricLines[i] then
        lyricLines[i].TextColor3 = COL.Red
        lyricLines[i].TextSize = math.max(10, lh * 0.62)
        lyricLines[i].Font = Enum.Font.GothamBold
    end
    local target = bh * 0.5 - ((i-1) + 0.5) * lh
    tw(LyricHolder, {Position = UDim2.new(0,0,0, target)}, 0.35)
    if UI.setDeskLyric then UI.setDeskLyric(i) end
end

function seekLyricTime(t)
    if not CurrentSong or Sound.TimeLength <= 0 then return end
    local tt = math.clamp(t or 0, 0, math.max(0, Sound.TimeLength - 0.05))
    pcall(function() Sound.TimePosition = tt end)
    local r = math.clamp(tt / Sound.TimeLength, 0, 1)
    ProgFill.Size = UDim2.new(r,0,1,0)
    ProgKnob.Position = UDim2.new(r,0,0.5,0)
    M_ProgFill.Size = UDim2.new(r,0,1,0)
    M_ProgKnob.Position = UDim2.new(r,0,0.5,0)
    TimeLabel.Text = fmt(tt) .. " / " .. fmt(Sound.TimeLength)
    M_Time.Text = TimeLabel.Text
end

do
    local LD = {on=false, preview=false, moved=false, sy=0, sp=0, idx=1, timer=0}
    UI.LD = LD

    local function geom()
        local bh = LyricBox.AbsoluteSize.Y
        if bh <= 0 then return nil end
        return bh, math.max(18, bh * LYRIC_ROW)
    end
    local function clampPos(p)
        local bh, lh = geom()
        if not bh then return p end
        local n = math.max(1, #State.Lyrics)
        local hi = bh * 0.5 - 0.5 * lh
        local lo = bh * 0.5 - (n - 0.5) * lh
        if lo > hi then lo, hi = hi, lo end
        return math.clamp(p, lo, hi)
    end
    local function idxAt(p)
        local bh, lh = geom()
        if not bh then return 1 end
        local i = math.floor((bh * 0.5 - p) / lh + 0.5)
        return math.clamp(i, 1, math.max(1, #State.Lyrics))
    end
    local function paint(i)
        local bh, lh = geom()
        local base = lh or 18
        for k, l in ipairs(lyricLines) do
            if k == i then
                l.TextColor3 = COL.Red; l.Font = Enum.Font.GothamBold
                l.TextSize = math.max(10, base * 0.62)
            else
                l.TextColor3 = COL.Sub; l.Font = Enum.Font.Gotham
                l.TextSize = math.max(10, base * 0.52)
            end
        end
        local tt = (State.Lyrics[i] and State.Lyrics[i].t) or 0
        UI.LyricTip.Text = fmt(tt)
    end
    function UI.lyricReset()
        LD.on = false; LD.preview = false; LD.moved = false; LD.timer = 0
        if UI.LyricGuide then UI.LyricGuide.Visible = false end
        if UI.LyricTip then UI.LyricTip.Visible = false end
        if UI.LyricGo then UI.LyricGo.Visible = false end
    end
    local function resumeFollow()
        LD.preview = false; LD.timer = 0
        if UI.LyricGuide then UI.LyricGuide.Visible = false end
        if UI.LyricTip then UI.LyricTip.Visible = false end
        if UI.LyricGo then UI.LyricGo.Visible = false end
        local t = 0
        pcall(function() t = Sound.TimePosition end)
        local idx = 0
        for i, it in ipairs(State.Lyrics) do
            if it.t <= t then idx = i else break end
        end
        if idx > 0 then setLyricLine(idx, true) end
    end

    local function commit(i)
        if #State.Lyrics == 0 then UI.lyricReset(); return end
        i = math.clamp(i or 1, 1, #State.Lyrics)
        local t = (State.Lyrics[i] and State.Lyrics[i].t) or 0
        seekLyricTime(t)
        setLyricLine(i, true)
        UI.lyricReset()
    end

    UI.LyricGrab.InputBegan:Connect(function(inp)
        if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and inp.UserInputType ~= Enum.UserInputType.Touch then return end
        if #State.Lyrics == 0 then return end
        local bh = geom()
        if not bh then return end
        LD.on = true; LD.moved = false
        LD.sy = inp.Position.Y
        LD.sp = LyricHolder.Position.Y.Offset
        tw(LyricHolder, {Position = UDim2.new(0,0,0, LD.sp)}, 0.01)
        LD.preview = false
        UI.LyricGuide.Visible = true
        UI.LyricTip.Visible = true
        UI.LyricGo.Visible = false
        paint(idxAt(LD.sp))
    end)

    UIS.InputChanged:Connect(function(inp)
        if not LD.on then return end
        if inp.UserInputType ~= Enum.UserInputType.MouseMovement and inp.UserInputType ~= Enum.UserInputType.Touch then return end
        local dy = inp.Position.Y - LD.sy
        if math.abs(dy) > 4 then LD.moved = true end
        local p = clampPos(LD.sp + dy)
        LyricHolder.Position = UDim2.new(0,0,0,p)
        LD.idx = idxAt(p)
        paint(LD.idx)
    end)

    UIS.InputEnded:Connect(function(inp)
        if not LD.on then return end
        if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and inp.UserInputType ~= Enum.UserInputType.Touch then return end
        LD.on = false
        if not LD.moved then
            if LD.preview then resumeFollow() else UI.lyricReset() end
        else
            LD.preview = true
            LD.timer = 0
            UI.LyricGuide.Visible = true
            UI.LyricTip.Visible = true
            UI.LyricGo.Visible = true
        end
    end)

    UI.LyricGo.MouseButton1Click:Connect(function()
        if LD.preview then
            local i = idxAt(LyricHolder.Position.Y.Offset)
            commit(i)
        end
    end)

    RunService.RenderStepped:Connect(function(dt)
        if not LD.preview then return end
        if LD.on then LD.timer = 0; return end
        LD.timer = (LD.timer or 0) + dt
        if LD.timer >= 5 then resumeFollow() end
    end)
end

function applyVol()
    local v = State.Muted and 0 or State.Volume
    Sound.Volume = v
    VolFill.Size = UDim2.new(v, 0, 1, 0)
    VolKnob.Position = UDim2.new(v, 0, 0.5, 0)
    VolPct.Text = math.floor(v * 100) .. "%"
    BtnVol.Text = IC.Vol
    UI.setCol(BtnVol, (v == 0) and COL.RedL or DIM)
    M_Vol.Text = IC.Vol
    M_Vol.TextColor3 = (v == 0) and COL.RedL or COL.Sub
    BtnMute.Text = State.Muted and "取消静音" or "静音"
end
applyVol()
applyAudio()

BtnVol.MouseButton1Click:Connect(function()
    SpdPanel.Visible = false
    if SpdPanel then SpdPanel.Visible = false end
    VolPanel.Visible = not VolPanel.Visible
    if VolPanel.Visible then
        VolPanel.ZIndex = 60
        popIn(VolPanel, 0.85, 0.22)
    end
end)
M_Vol.MouseButton1Click:Connect(function() State.Muted = not State.Muted; applyVol(); saveVol() end)
BtnMute.MouseButton1Click:Connect(function() State.Muted = not State.Muted; applyVol(); saveVol() end)

volDrag = false
function setVolAt(x)
    local rel = math.clamp((x - VolBg.AbsolutePosition.X) / math.max(1, VolBg.AbsoluteSize.X), 0, 1)
    State.Volume = rel
    State.Muted = false
    applyVol()
end
VolHit.InputBegan:Connect(function(inp) if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and inp.UserInputType ~= Enum.UserInputType.Touch then return end volDrag = true; setVolAt(inp.Position.X) end)
UIS.InputChanged:Connect(function(inp)
    if volDrag and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
        setVolAt(inp.Position.X)
    end
end)
UIS.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        if volDrag then volDrag = false; saveVol() end
    end
end)

function UI.SetStatus(t) StatusLbl.Text = t or "" end
function UI.OnSongChanged(song)
    NowName.Text = song.name
    NowArtist.Text = song.artist
    M_Name.Text = song.name
    M_Artist.Text = song.artist
    LyricName.Text = song.name
    LyricArtist.Text = song.artist
    local fav = State.Favorites[song.id] and true or false
    BtnFav.Text = fav and IC.FavOn or IC.FavOff
    UI.setCol(BtnFav, fav and COL.Red or DIM)
end
function UI.OnPlayStateChanged(p)
    BtnPlay.Text = p and IC.Pause or IC.Play
    M_Play.Text = p and IC.Pause or IC.Play
end

function showPage(p)
    if State.CurPage == p then return end
    State.CurPage = p
    UI.closeArtist()
    ListPage.Visible = (p == "list")
    LyricPage.Visible = (p == "lyric")
    if p ~= "lyric" and UI.lyricReset then UI.lyricReset() end
    if UI.HomePage then UI.HomePage.Visible = (p == "home") end
    if UI.DeskSetPage then UI.DeskSetPage.Visible = (p == "deskset") end
    if UI.AboutPage then UI.AboutPage.Visible = (p == "about") end
    if p == "list" then
        popIn(ListPage, 0.97, 0.24)
    elseif p == "lyric" then
        popIn(LyricPage, 0.94, 0.30)
        layoutLyric()
    elseif p == "home" then
        popIn(UI.HomePage, 0.97, 0.24)
    elseif p == "deskset" then
        popIn(UI.DeskSetPage, 0.97, 0.24)
    end
end
openArtist = function(artistName, artistId)
    if not artistName or artistName == "" then return end
    artistId = tostring(artistId or "")
    BtnArtistBack.Visible = false
    UI.BtnRecommendBack.Visible = false
    State.CurNav = 0
    highlightNav(nil)
    if UI.SetStatus then UI.SetStatus("加载歌手歌曲...") end
    UI.renderArtist({}, artistName)
    task.spawn(function()
        local res = apiArtistSongs(artistName, artistId)
        State.ArtistQueue = res
        UI.renderArtist(res, artistName)
        if #res == 0 then UI.SetStatus("没找到该歌手的歌") else UI.SetStatus("") end
        probePlayable(res)
    end)
end

function backToSearch()
    BtnArtistBack.Visible = false
    UI.BtnRecommendBack.Visible = false
    ListTitle.Text = "搜索结果"
    State.CurNav = 1
    highlightNav(NavItems[1])
    renderList(State.SearchQueue)
end
BtnArtistBack.MouseButton1Click:Connect(backToSearch)
UI.BtnRecommendBack.MouseButton1Click:Connect(function()
    UI.BtnRecommendBack.Visible = false
    BtnArtistBack.Visible = false
    State.CurNav = 1
    highlightNav(NavItems[1])
    showPage("home")
end)

mkNav(1, "推荐", function()
    showPage("home"); State.CurNav = 1
end)
NavSearch = mkNav(2, "搜索结果", function()
    showPage("list"); State.CurNav = 2
    ListTitle.Text = "搜索结果"; BtnArtistBack.Visible = false; UI.BtnRecommendBack.Visible = false
    renderList(State.SearchQueue)
end)
function renderFavPage()
    local out = {}
    for id, s in pairs(State.Favorites) do
        if type(s) == "table" then table.insert(out, s) end
    end
    table.sort(out, function(a, b) return (a.name or "") < (b.name or "") end)
    if #out == 0 then
        clearList()
        RowRefs = {}
        layoutList()
        if UI.SetStatus then UI.SetStatus("还没有收藏") end
        return
    end
    if UI.SetStatus then UI.SetStatus("") end
    renderList(out)
end
mkNav(3, "我喜欢的", function()
    showPage("list")
    State.CurNav = 3
    ListTitle.Text = "我喜欢的"; BtnArtistBack.Visible = false; UI.BtnRecommendBack.Visible = false
    renderFavPage()
end)
mkNav(4, "播放队列", function()
    showPage("list"); State.CurNav = 4
    BtnArtistBack.Visible = false
    UI.BtnRecommendBack.Visible = false
    if #State.Queue == 0 then
        ListTitle.Text = "播放队列"
        clearList()
        RowRefs = {}
        layoutList()
        if UI.SetStatus then UI.SetStatus("播放队列是空的，先播放一首歌") end
        return
    end
    ListTitle.Text = "播放队列 · " .. tostring(math.max(1, State.Index)) .. "/" .. tostring(#State.Queue)
    if UI.SetStatus then UI.SetStatus("") end
    renderList(State.Queue, true)
end)
do
    local ap = Instance.new("Frame")
    ap.Size = UDim2.new(1,0,1,0); ap.Position = UDim2.new(0,0,0,0)
    ap.BackgroundColor3 = COL.Body; ap.BorderSizePixel = 0
    ap.Visible = false; ap.ZIndex = 25; ap.Parent = Body
    UI.AboutPage = ap
    local back = mkBtn(ap, UDim2.new(0.15,0,0.06,0), UDim2.new(0.025,0,0.018,0), "< 返回", COL.Sub, 1)
    back.Font = Enum.Font.Gotham
    do local cc = Instance.new("UICorner"); cc.CornerRadius = UDim.new(0.25, 0); cc.Parent = back end
    pressAnim(back)
    back.MouseButton1Click:Connect(function()
        UI.AboutPage.Visible = false
        highlightNav(NavItems[1])
        State.CurPage = "home"
        if UI.HomePage then UI.HomePage.Visible = true end
    end)
    mkLabel(ap, UDim2.new(0.7,0,0.07,0), UDim2.new(0.15,0,0.095,0), "关于 / 免责声明", COL.Text, Enum.Font.GothamBold, Enum.TextXAlignment.Center).TextScaled = true
    local box = Instance.new("Frame")
    box.Size = UDim2.new(0.94,0,0.70,0); box.Position = UDim2.new(0.03,0,0.16,0)
    box.BackgroundColor3 = COL.White; box.BorderSizePixel = 0; box.ZIndex = 26; box.Parent = ap
    do local cc = Instance.new("UICorner"); cc.CornerRadius = UDim.new(0, 10); cc.Parent = box end
    stroke(box, COL.Line, 1)
    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1,-24,1,-20); txt.Position = UDim2.new(0,12,0,10)
    txt.BackgroundTransparency = 1; txt.ZIndex = 27
    txt.TextColor3 = COL.Text; txt.Font = Enum.Font.Gotham
    txt.TextSize = 12; txt.TextWrapped = true; txt.TextScaled = false
    txt.TextXAlignment = Enum.TextXAlignment.Left; txt.TextYAlignment = Enum.TextYAlignment.Top
    txt.Text = "1. 本项目为个人技术学习与交流用途，禁止用于任何商业用途。\n\n2. 音乐作品的著作权归网易云音乐及各自权利人所有；本项目不存储、不缓存、不分发任何音频文件，仅转发官方接口返回的临时直链。\n\n3. 登录功能调用网易云官方接口，请自行评估账号风险，建议使用小号；作者不对账号封禁、数据丢失等承担任何责任。\n\n4. 本项目依赖第三方服务与接口，可能随时失效或变更，作者不保证任何功能在当前或未来可用。\n\n5. 下载或使用本脚本即视为您已阅读并同意上述条款；若不同意请立即停止使用并删除。\n\n请在支持正版的前提下合理使用。"
    txt.Parent = box
    mkLabel(ap, UDim2.new(0.9,0,0.04,0), UDim2.new(0.05,0,0.88,0), "网易云音乐 for Roblox  ·  仅供学习交流", COL.Sub, Enum.Font.Gotham, Enum.TextXAlignment.Center)
end
function __NCM_DeskSetBlock()
    local dp = Instance.new("Frame")
    dp.Size = UDim2.new(1,0,1,0)
    dp.BackgroundColor3 = COL.Body
    dp.BorderSizePixel = 0
    dp.Visible = false
    dp.ZIndex = 25
    dp.Parent = Body
    UI.DeskSetPage = dp
    local back = mkBtn(dp, UDim2.new(0.15,0,0.06,0), UDim2.new(0.025,0,0.018,0), "< 返回", COL.Sub, 1)
    back.Font = Enum.Font.Gotham
    do local cc = Instance.new("UICorner"); cc.CornerRadius = UDim.new(0.25, 0); cc.Parent = back end
    pressAnim(back)
    back.MouseButton1Click:Connect(function()
        dp.Visible = false
        if LyricPage then LyricPage.Visible = true end
        State.CurPage = "lyric"
        if BtnLyric then UI.setCol(BtnLyric, COL.Gold) end
        if UI.syncDeskBtn then UI.syncDeskBtn() end
    end)
    mkLabel(dp, UDim2.new(0.7,0,0.07,0), UDim2.new(0.15,0,0.095,0), "桌面歌词设置", COL.Text, Enum.Font.GothamBold, Enum.TextXAlignment.Center).TextScaled = true
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0.92,0,0.60,0)
    card.Position = UDim2.new(0.04,0,0.20,0)
    card.BackgroundColor3 = COL.White
    card.BorderSizePixel = 0
    card.ZIndex = 26
    card.Parent = dp
    do local cc = Instance.new("UICorner"); cc.CornerRadius = UDim.new(0, 10); cc.Parent = card end
    stroke(card, COL.Line, 1)
    local FS_TXT = {"小", "中", "大"}
    local btns = {}
    local specs = {
        {n = "显示桌面歌词", t = function() return UI.DeskCfg.on and "开" or "关" end,
         f = function() UI.DeskCfg.on = not UI.DeskCfg.on end},
        {n = "字号", t = function() return FS_TXT[UI.DeskCfg.fs] or "中" end,
         f = function() UI.DeskCfg.fs = (UI.DeskCfg.fs % 3) + 1 end},
        {n = "文字描边", t = function() return (UI.DeskCfg.ol ~= false) and "开" or "关" end,
         f = function() UI.DeskCfg.ol = (UI.DeskCfg.ol == false) end},
        {n = "双行预告", t = function() return UI.DeskCfg.dual and "开" or "关" end,
         f = function() UI.DeskCfg.dual = not UI.DeskCfg.dual end},
        {n = "锁定位置", t = function() return UI.DeskCfg.lock and "已锁定" or "未锁定" end,
         f = function() UI.DeskCfg.lock = not UI.DeskCfg.lock end},
    }
    for i, sp in ipairs(specs) do
        local y = 0.05 + (i - 1) * 0.175
        local lab = mkLabel(card, UDim2.new(0.44,0,0.085,0), UDim2.new(0.05,0,y,0), sp.n, COL.Text, Enum.Font.Gotham, Enum.TextXAlignment.Left)
        lab.TextScaled = true
        lab.ZIndex = 27
        local b = mkBtn(card, UDim2.new(0.36,0,0.115,0), UDim2.new(0.57,0,y - 0.015,0), sp.t(), COL.White, 0)
        b.BackgroundColor3 = COL.Red
        b.Font = Enum.Font.GothamBold
        b.TextScaled = true
        b.ZIndex = 27
        do local cc = Instance.new("UICorner"); cc.CornerRadius = UDim.new(0.25, 0); cc.Parent = b end
        pressAnim(b)
        b.MouseButton1Click:Connect(function()
            sp.f()
            b.Text = sp.t()
            UI.layoutDeskLyric()
            UI.refreshDeskLyric()
            if UI.saveDeskCfg then UI.saveDeskCfg() end
            if UI.syncDeskBtn then UI.syncDeskBtn() end
            if UI.SetStatus then UI.SetStatus("桌面歌词设置已更新") end
        end)
        btns[i] = b
    end
    local rb = mkBtn(card, UDim2.new(0.56,0,0.115,0), UDim2.new(0.22,0,0.86,0), "恢复默认位置并解锁", COL.White, 0)
    rb.BackgroundColor3 = COL.Sub
    rb.Font = Enum.Font.Gotham
    rb.TextScaled = true
    rb.ZIndex = 27
    do local cc = Instance.new("UICorner"); cc.CornerRadius = UDim.new(0.25, 0); cc.Parent = rb end
    pressAnim(rb)
    rb.MouseButton1Click:Connect(function()
        UI.DeskPos.X = 0.5
        UI.DeskPos.Y = 0.72
        UI.DeskCfg.fs = 2
        UI.DeskCfg.ol = true
        UI.DeskCfg.dual = true
        UI.DeskCfg.lock = false
        for i, b in ipairs(btns) do b.Text = specs[i].t() end
        UI.layoutDeskLyric()
        if UI.saveDeskCfg then UI.saveDeskCfg() end
        if UI.syncDeskBtn then UI.syncDeskBtn() end
        if UI.SetStatus then UI.SetStatus("桌面歌词已复位并解锁") end
    end)
    UI.openDeskSet = function()
        for i, b in ipairs(btns) do b.Text = specs[i].t() end
        if UI.closeArtist then UI.closeArtist() end
        showPage("deskset")
        if UI.DeskSetPage then UI.DeskSetPage.Visible = true end
    end
end
__NCM_DeskSetBlock()
function openAbout()
    if UI.closeArtist then UI.closeArtist() end
    showPage("about")
    if UI.AboutPage then UI.AboutPage.Visible = true end
end
mkNav(5, "账号登录/切换账号", function() openLogin() end)
function relayoutNav()
    local h = 0
    pcall(function() h = UI.NavHolder.AbsoluteSize.Y end)
    local n = #NavItems
    if h <= 0 or n == 0 then return end
    local gap = 2
    local ih = (h - (n - 1) * gap) / n
    if ih < 14 then ih = 14 end
    if ih > 36 then ih = 36 end
    for _, x in ipairs(NavItems) do x.Size = UDim2.new(0.88, 0, 0, ih) end
end
UI.relayoutNav = relayoutNav
do
    local ab = Instance.new("TextButton")
    ab.Size = UDim2.new(0.88, 0, 0, 20)
    ab.Position = UDim2.new(0.06, 0, 1, -100)
    ab.BackgroundTransparency = 0.08
    ab.BackgroundColor3 = COL.Side
    ab.Text = "关于 / 免责声明"
    ab.TextColor3 = COL.Sub
    ab.TextScaled = true
    ab.Font = Enum.Font.Gotham
    ab.BorderSizePixel = 0
    ab.AutoButtonColor = false
    ab.ZIndex = 10
    ab.Parent = SideBar
    corner(ab, 0.25)
    ab.MouseButton1Click:Connect(function() openAbout() end)
end
relayoutNav()
pcall(function()
    SideBar:GetPropertyChangedSignal("AbsoluteSize"):Connect(relayoutNav)
    UI.NavHolder:GetPropertyChangedSignal("AbsoluteSize"):Connect(relayoutNav)
end)
highlightNav(NavItems[1])
ListPage.Visible = false
LyricPage.Visible = false
if UI.HomePage then UI.HomePage.Visible = true end
State.CurPage = "home"

BtnSearch.MouseButton1Click:Connect(function()
    local kw = SearchBox.Text
    if kw == "" then return end
    BtnSearch.Text = "..."
    showPage("list")
    task.spawn(function()
        local res = apiSearch(kw)
        BtnSearch.Text = IC.Search
        State.SearchQueue = res
        ListTitle.Text = "搜索 · " .. kw
        BtnArtistBack.Visible = false
        UI.BtnRecommendBack.Visible = false
        State.CurNav = 1
        highlightNav(NavItems[1])
        renderList(res)
        if #res == 0 then UI.SetStatus("没搜到 / API 不可用") else UI.SetStatus("") end
        probePlayable(res)
    end)
end)
SearchBox.FocusLost:Connect(function(enter) if enter then BtnSearch.MouseButton1Click:Fire() end end)

BtnPlay.MouseButton1Click:Connect(togglePlay)
M_Play.MouseButton1Click:Connect(togglePlay)
BtnNext.MouseButton1Click:Connect(nextSong)
M_Prev.MouseButton1Click:Connect(prevSong)
M_Next.MouseButton1Click:Connect(nextSong)
BtnPrev.MouseButton1Click:Connect(prevSong)
VinylBtn.MouseButton1Click:Connect(function() showPage("lyric") end)
BtnLyric.MouseButton1Click:Connect(function()
    showPage(State.CurPage == "lyric" and "list" or "lyric")
    UI.setCol(BtnLyric, (State.CurPage == "lyric") and COL.Gold or DIM)
end)
BtnBack.MouseButton1Click:Connect(function() showPage("list") end)

BtnFav.MouseButton1Click:Connect(function()
    if not CurrentSong then return end
    local id = CurrentSong.id
    if State.Favorites[id] then
        State.Favorites[id] = nil
    else
        State.Favorites[id] = CurrentSong
    end
    saveFav()
    local fav = State.Favorites[id] and true or false
    BtnFav.Text = fav and IC.FavOn or IC.FavOff
    UI.setCol(BtnFav, fav and COL.Red or DIM)
    popIn(BtnFav, 0.7, 0.25)
    if State.CurNav == 2 then renderFavPage() end
end)

BtnMode.MouseButton1Click:Connect(function()
    State.Mode = State.Mode % 3 + 1
    BtnMode.Text = ModeChars[State.Mode]
    UI.setCol(BtnMode, (State.Mode == 1) and DIM or COL.Gold)
    popIn(BtnMode, 0.8, 0.22)
    if UI.SetStatus then UI.SetStatus(ModeNames[State.Mode] .. "播放") end
    task.delay(1.2, function()
        if UI.SetStatus and StatusLbl.Text == ModeNames[State.Mode] .. "播放" then UI.SetStatus("") end
    end)
end)

Sound.Ended:Connect(handleSongEnd)

dragging = false
dragRatio = 0
dragValid = false
function dragVisual(r)
    ProgFill.Size = UDim2.new(r, 0, 1, 0)
    ProgKnob.Position = UDim2.new(r, 0, 0.5, 0)
    M_ProgFill.Size = UDim2.new(r, 0, 1, 0)
    M_ProgKnob.Position = UDim2.new(r, 0, 0.5, 0)
    if CurrentSong and Sound.TimeLength > 0 then
        local tp = fmt(r * Sound.TimeLength) .. " / " .. fmt(Sound.TimeLength)
        TimeLabel.Text = tp
        M_Time.Text = tp
    end
end
function seekAt(x)
    if not CurrentSong or Sound.TimeLength <= 0 then return end
    dragRatio = math.clamp((x - ProgBg.AbsolutePosition.X) / math.max(1, ProgBg.AbsoluteSize.X), 0, 1)
    dragValid = true
    dragVisual(dragRatio)
end
function mSeekAt(x)
    if not CurrentSong or Sound.TimeLength <= 0 then return end
    dragRatio = math.clamp((x - M_ProgBg.AbsolutePosition.X) / math.max(1, M_ProgBg.AbsoluteSize.X), 0, 1)
    dragValid = true
    dragVisual(dragRatio)
end
function commitSeek()
    if dragValid and CurrentSong and Sound.TimeLength > 0 then
        pcall(function() Sound.TimePosition = dragRatio * Sound.TimeLength end)
    end
    dragging = false
    dragValid = false
end
ProgBg.InputBegan:Connect(function(inp) if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and inp.UserInputType ~= Enum.UserInputType.Touch then return end dragging = true; seekAt(inp.Position.X) end)
M_ProgBg.InputBegan:Connect(function(inp) if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and inp.UserInputType ~= Enum.UserInputType.Touch then return end dragging = true; mSeekAt(inp.Position.X) end)
UIS.InputChanged:Connect(function(inp)
    if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
        if Main.Visible then seekAt(inp.Position.X) else mSeekAt(inp.Position.X) end
    end
end)
UIS.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        if dragging then commitSeek() end
    end
end)

BtnMin.MouseButton1Click:Connect(function()
    tw(MainScale, {Scale = 0.86}, 0.14)
    task.wait(0.14)
    Main.Visible = false
    MiniDock.Visible = false
    MiniTop.Visible = true
    MiniBot.Visible = true
    layoutMini()
    popIn(MiniTop, 0.80, 0.30)
    popIn(MiniBot, 0.80, 0.34)
    MainScale.Scale = 1
    if UI.showDeskLyric then UI.showDeskLyric(true) end
end)
miniMoved = false
M_Expand.MouseButton1Click:Connect(function()
    if miniMoved then return end
    MiniDock.Visible = false
    MiniTop.Visible = false
    MiniBot.Visible = false
    Main.Visible = true
    MainScale.Scale = 0.92
    tw(MainScale, {Scale = 1}, 0.28, Enum.EasingStyle.Back)
    if UI.showDeskLyric then UI.showDeskLyric(false) end
end)
BtnClose.MouseButton1Click:Connect(function()
    State.Closed = true
    State.Playing = false
    State.Loading = false
    pcall(function() Sound:Stop() end)
    pcall(function() Sound.SoundId = "" end)
    if UI.OnPlayStateChanged then UI.OnPlayStateChanged(false) end
    if UI.SetStatus then UI.SetStatus("") end
    if UI.showDeskLyric then UI.showDeskLyric(false) end
    gui.Enabled = false
end)

M_Collapse.MouseButton1Click:Connect(function()
    if miniMoved then return end
    collapseMini()
end)

M_Lyric.MouseButton1Click:Connect(function()
    if miniMoved then return end
    local fg = UI.DeskCfg
    if fg.lock then
        fg.lock = false
        UI.layoutDeskLyric()
        UI.refreshDeskLyric()
        if UI.syncDeskBtn then UI.syncDeskBtn() end
        if UI.SetStatus then UI.SetStatus("桌面歌词已解锁 · 可拖动，再点一次可关闭") end
        return
    end
    fg.on = not fg.on
    UI.refreshDeskLyric()
    if UI.syncDeskBtn then UI.syncDeskBtn() end
    if UI.SetStatus then UI.SetStatus(fg.on and "桌面歌词已开启" or "桌面歌词已关闭") end
end)

MiniDock.MouseButton1Click:Connect(function()
    if dockMoved then return end
    expandFromDock()
end)

do
    local drag, lastP, sRight, sTop = false, nil, 0, 0
    local function miniMetrics()
        local vw = math.max(1, gui.AbsoluteSize.X)
        local vh = math.max(1, gui.AbsoluteSize.Y)
        local w = UI.MiniW or math.min(vw * 0.76, vh * 0.42)
        local h = UI.MiniH or math.max(70, vh * 0.11)
        return vw, vh, w, h
    end
    local function applyMiniRT(right, top)
        local vw, vh, w, h = miniMetrics()
        local SX, ST, SB = ncmSafeInset()
        local rMin = w + SX
        local rMax = vw - SX
        if rMin > rMax then rMin, rMax = vw * 0.5, vw * 0.5 end
        local tMin = ST
        local tMax = vh - h - SB
        if tMax < tMin then tMax = math.max(tMin, vh - SB - h * 0.5) end
        local nr = math.clamp(right, rMin, rMax)
        local nt = math.clamp(top, tMin, tMax)
        MiniPos.X = nr / vw
        MiniPos.Y = nt / vh
        MiniTop.Position = UDim2.new(MiniPos.X, 0, MiniPos.Y, 0)
        MiniBot.Position = UDim2.new(MiniPos.X, 0, MiniPos.Y, (UI.MiniTopH or 0) + MINI_GAP)
        return nr, nt
    end
    local function syncFromPos()
        local vw, vh = miniMetrics()
        sRight = (MiniPos.X or 0.985) * vw
        sTop = (MiniPos.Y or 0.075) * vh
    end
    M_Expand.InputBegan:Connect(function(inp)
        if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and inp.UserInputType ~= Enum.UserInputType.Touch then return end
        drag = true; miniMoved = false
        lastP = Vector2.new(inp.Position.X, inp.Position.Y)
        syncFromPos()
    end)
    UIS.InputChanged:Connect(function(inp)
        if not drag then return end
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
            if not lastP then
                lastP = Vector2.new(inp.Position.X, inp.Position.Y)
                syncFromPos()
                return
            end
            local dx = inp.Position.X - lastP.X
            local dy = inp.Position.Y - lastP.Y
            lastP = Vector2.new(inp.Position.X, inp.Position.Y)
            if math.abs(dx) > 4 or math.abs(dy) > 4 then miniMoved = true end
            sRight = sRight + dx
            sTop = sTop + dy
            sRight, sTop = applyMiniRT(sRight, sTop)
        end
    end)
    UIS.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            if drag then
                drag = false; lastP = nil
                task.delay(0.05, function() miniMoved = false end)
            end
        end
    end)
end

do
    local ddrag, dstart, dcur, dacc = false, nil, nil, 0
    local EDGE = 4
    local function dockGeom()
        local vw = math.max(1, gui.AbsoluteSize.X)
        local vh = math.max(1, gui.AbsoluteSize.Y)
        local w = UI.DockW or math.max(20, vh * 0.07)
        local h = UI.DockH or math.max(54, vh * 0.13)
        if type(w) ~= "number" or w <= 0 then w = 20 end
        if type(h) ~= "number" or h <= 0 then h = 54 end
        return vw, vh, w, h
    end
    local function dockCenter()
        local vw, vh, w, h = dockGeom()
        local SX, ST, SB = ncmSafeInset()
        local yLo = ST + h * 0.5
        local yHi = vh - SB - h * 0.5
        if yHi < yLo then yLo, yHi = vh * 0.5, vh * 0.5 end
        local cy = math.clamp((DockY or 0.5) * vh, yLo, yHi)
        local cx = (DockSide == "left") and (EDGE + w * 0.5) or (vw - EDGE - w * 0.5)
        cx = math.clamp(cx, w * 0.5, math.max(w * 0.5, vw - w * 0.5))
        return cx, cy
    end
    local function beginDockDrag(ip)
        ddrag = true
        dockMoved = false
        dacc = 0
        dstart = Vector2.new(ip.X, ip.Y)
        local cx, cy = dockCenter()
        dcur = Vector2.new(cx, cy)
        MiniDock.AnchorPoint = Vector2.new(0.5, 0.5)
        MiniDock.Position = UDim2.new(0, cx, 0, cy)
    end
    local function inDock(x, y)
        local ap = MiniDock.AbsolutePosition
        local as = MiniDock.AbsoluteSize
        if not ap or not as then return false end
        if as.X <= 0 or as.Y <= 0 then return false end
        return x >= ap.X - 2 and x <= ap.X + as.X + 2 and y >= ap.Y - 2 and y <= ap.Y + as.Y + 2
    end
    UIS.InputBegan:Connect(function(inp)
        if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and inp.UserInputType ~= Enum.UserInputType.Touch then return end
        if not MiniDock.Visible then return end
        if not inDock(inp.Position.X, inp.Position.Y) then return end
        beginDockDrag(inp.Position)
    end)
    UIS.InputChanged:Connect(function(inp)
        if not ddrag then return end
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
            if not dstart or not dcur then beginDockDrag(inp.Position) end
            if not dstart or not dcur then return end
            local dx = inp.Position.X - dstart.X
            local dy = inp.Position.Y - dstart.Y
            dstart = Vector2.new(inp.Position.X, inp.Position.Y)
            dacc = dacc + math.abs(dx) + math.abs(dy)
            if dacc > 5 then dockMoved = true end
            local vw, vh, w, h = dockGeom()
            local SX, ST, SB = ncmSafeInset()
            local xMin, xMax = w * 0.5, vw - w * 0.5
            local yMin, yMax = ST + h * 0.5, vh - SB - h * 0.5
            if xMin > xMax then xMin, xMax = vw * 0.5, vw * 0.5 end
            if yMin > yMax then yMin, yMax = vh * 0.5, vh * 0.5 end
            local px = math.clamp(dcur.X + dx, xMin, xMax)
            local py = math.clamp(dcur.Y + dy, yMin, yMax)
            dcur = Vector2.new(px, py)
            MiniDock.Position = UDim2.new(0, px, 0, py)
        end
    end)
    UIS.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            if ddrag then
                ddrag = false
                local c = dcur
                if dockMoved and c then
                    local vw = math.max(1, gui.AbsoluteSize.X)
                    local vh = math.max(1, gui.AbsoluteSize.Y)
                    DockSide = (c.X > vw * 0.5) and "right" or "left"
                    DockY = math.clamp(c.Y / vh, 0.0, 1.0)
                end
                dcur = nil
                dstart = nil
                layoutMini()
                task.delay(0.05, function() dockMoved = false end)
            end
        end
    end)
end

ListScroll:GetPropertyChangedSignal("AbsoluteSize"):Connect(layoutList)
LyricBox:GetPropertyChangedSignal("AbsoluteSize"):Connect(layoutLyric)
VinylWrap:GetPropertyChangedSignal("AbsoluteSize"):Connect(layoutLyric)
VinylBox:GetPropertyChangedSignal("AbsoluteSize"):Connect(layoutLyric)
gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(layoutMini)
Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    local asp = Camera.ViewportSize.X / math.max(1, Camera.ViewportSize.Y)
    if asp >= 1 then Main.Size = UDim2.new(0.52,0,0.78,0) else Main.Size = UDim2.new(0.94,0,0.66,0) end
    layoutMini()
end)

function fmt(t)
    t = math.max(0, t or 0)
    return string.format("%02d:%02d", math.floor(t/60), math.floor(t%60))
end
RunService.RenderStepped:Connect(function(dt)
    if State.Closed then
        pcall(function() if Sound.Playing then Sound:Stop() end end)
        return
    end
    if CurrentSong and Sound.TimeLength > 0 then
        local r = math.clamp(Sound.TimePosition / Sound.TimeLength, 0, 1)
        if not dragging then
            ProgFill.Size = UDim2.new(r, 0, 1, 0)
            ProgKnob.Position = UDim2.new(r, 0, 0.5, 0)
            M_ProgFill.Size = UDim2.new(r, 0, 1, 0)
            M_ProgKnob.Position = UDim2.new(r, 0, 0.5, 0)
            TimeLabel.Text = fmt(Sound.TimePosition) .. " / " .. fmt(Sound.TimeLength)
            M_Time.Text = TimeLabel.Text
        end

        if State.Playing and not State.Loading then
            if Sound.TimePosition >= Sound.TimeLength - 0.15 then
                handleSongEnd()
            end
        end
    end
    if State.Playing then
        Vinyl.Rotation = (Vinyl.Rotation + dt * 22) % 360
        VinylS.Rotation = (VinylS.Rotation + dt * 22) % 360
        M_Vinyl.Rotation = (M_Vinyl.Rotation + dt * 22) % 360
    end
    if #State.Lyrics > 0 and State.Playing and not (UI.LD and (UI.LD.on or UI.LD.preview)) then
        local t = Sound.TimePosition
        local idx = 0
        for i, it in ipairs(State.Lyrics) do
            if it.t <= t then idx = i else break end
        end
        if idx > 0 then setLyricLine(idx) end
    end
end)

do
    local function onExit()
        State.Closed = true
        State.Playing = false
        pcall(function() Sound:Stop() end)
    end
    pcall(function()
        local pg = LP:FindFirstChildWhichIsA("PlayerGui")
        if pg then
            pg.ChildRemoved:Connect(function(c)
                if c == gui then onExit() end
            end)
        end
    end)
    pcall(function()
        if gui.Destroying then
            gui.Destroying:Connect(onExit)
        end
    end)
    pcall(function()
        game:GetService("Players").LocalPlayer.OnTeleport:Connect(onExit)
    end)
end
ensureDir(CFG.TempDir)
layoutMini()
popIn(Main, 0.92, 0.35)
if not (rawRequest and fnWrite and fnAsset) then
    local miss = {}
    if not rawRequest then miss[#miss+1] = "request" end
    if not fnWrite then miss[#miss+1] = "writefile" end
    if not fnAsset then miss[#miss+1] = "getcustomasset" end
    if UI.SetStatus then UI.SetStatus("注入器缺少: " .. table.concat(miss, " / ")) end
end
queryVip()

task.spawn(function()
    local res = apiSearch("热歌")
    if res and #res > 0 then UI.renderHome(res) end
end)


end

local __ok, __err = xpcall(__NCM_Main, function(e)
    local tb = ""
    pcall(function() tb = debug.traceback(tostring(e), 2) end)
    return tostring(e) .. "\n" .. tostring(tb)
end)
if not __ok then
    __ncmShow(__err)
end
