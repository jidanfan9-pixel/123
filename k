local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local gui

local CONFIG = {
    Title    = "纸脚本加载器",
    Subtitle = "选择要加载的脚本",
    Version  = "v1.0",
    Width    = 340,

    Demo = false,

    LogoURL  = "https://raw.githubusercontent.com/kkkjjjhhhkkk9-sketch/zhi./refs/heads/main/%E7%BA%B8logo.jpg",
    LogoFile = "zhi_paper_logo.jpg",

    Accent  = Color3.fromRGB(91, 110, 245),
    Accent2 = Color3.fromRGB(139, 92, 246),
    Accent3 = Color3.fromRGB(236, 72, 153),

    Scripts = {
        {
            Name    = "纸脚本中心",
            Kind    = "url",
            Source  = "https://raw.githubusercontent.com/zhifeijiyutggddfbe/zhisp/refs/heads/main/%E7%BA%B8%E8%84%9A%E6%9C%AC.v2",
            Default = true,
        },
        {
            Name    = "纸.监狱人生",
            Kind    = "url",
            Source  = "https://raw.githubusercontent.com/kkkjjjhhhkkk9-sketch/zhi./refs/heads/main/%E7%BA%B8.%E7%9B%91%E7%8B%B1%E4%BA%BA%E7%94%9F",
            Default = false,
        },
        {
            Name    = "纸.拾取树叶",
            Kind    = "url",
            Source  = "https://raw.githubusercontent.com/kkkjjjhhhkkk9-sketch/zhi./refs/heads/main/%E7%BA%B8.%E6%8B%BE%E5%8F%96%E6%89%80%E6%9C%89%E6%A0%91%E5%8F%B6",
            Default = false,
        },
        {
            Name    = "纸.重型钓鱼",
            Kind    = "url",
            Source  = "https://raw.githubusercontent.com/kkkjjjhhhkkk9-sketch/zhi./refs/heads/main/%E7%BA%B8.%E9%87%8D%E5%9E%8B%E9%92%93%E9%B1%BC",
            Default = false,
        },
        {
            Name    = "纸.海上100天",
            Kind    = "url",
            Source  = "https://raw.githubusercontent.com/kkkjjjhhhkkk9-sketch/zhi./refs/heads/main/%E7%BA%B8.%E6%B5%B7%E4%B8%8A100%E5%A4%A9",
            Default = false,
        },
    },
}

local C_TEXT   = Color3.fromRGB(24, 28, 38)
local C_SUB    = Color3.fromRGB(110, 118, 138)
local C_BORDER = Color3.fromRGB(226, 230, 240)
local C_CARD   = Color3.fromRGB(255, 255, 255)
local C_SOFT   = Color3.fromRGB(247, 248, 252)
local C_SOFT_HV= Color3.fromRGB(240, 242, 250)
local C_ERR    = Color3.fromRGB(239, 68, 68)

local ROW_H    = 40
local ROW_GAP  = 6

local loading = false

local function corner(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = obj
    return c
end

local function triGradient(obj, rot)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, CONFIG.Accent),
        ColorSequenceKeypoint.new(0.5, CONFIG.Accent2),
        ColorSequenceKeypoint.new(1, CONFIG.Accent3),
    })
    g.Rotation = rot or 45
    g.Parent = obj
    return g
end

local function spacer(parent, h, order)
    local f = Instance.new("Frame")
    f.BackgroundTransparency = 1
    f.Size = UDim2.new(1, 0, 0, h)
    f.LayoutOrder = order
    f.ZIndex = 2
    f.Parent = parent
    return f
end

local function burstRing()
    local ring = Instance.new("Frame")
    ring.Size = UDim2.fromOffset(30, 30)
    ring.Position = UDim2.fromScale(0.5, 0.5)
    ring.AnchorPoint = Vector2.new(0.5, 0.5)
    ring.BackgroundTransparency = 1
    ring.BorderSizePixel = 0
    ring.ZIndex = 60
    ring.Parent = gui
    corner(ring, 999)

    local s = Instance.new("UIStroke")
    s.Color = CONFIG.Accent
    s.Thickness = 4
    s.Transparency = 0.2
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = ring
    triGradient(s, 45)

    TweenService:Create(ring, TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(220, 220),
    }):Play()
    TweenService:Create(s, TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Transparency = 1, Thickness = 0.5,
    }):Play()

    task.delay(1, function() ring:Destroy() end)
end

local function addShine(btn, radius)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.fromScale(1, 1)
    holder.BackgroundTransparency = 1
    holder.ClipsDescendants = true
    holder.ZIndex = btn.ZIndex + 1
    holder.Parent = btn
    corner(holder, radius)

    local shine = Instance.new("Frame")
    shine.Size = UDim2.new(0, 50, 2, 0)
    shine.Position = UDim2.new(0, -100, -0.5, 0)
    shine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    shine.BackgroundTransparency = 0.55
    shine.BorderSizePixel = 0
    shine.Rotation = 20
    shine.ZIndex = btn.ZIndex + 2
    shine.Parent = holder

    local g = Instance.new("UIGradient")
    g.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.2),
        NumberSequenceKeypoint.new(1, 1),
    })
    g.Parent = shine

    return function()
        shine.Position = UDim2.new(0, -100, -0.5, 0)
        TweenService:Create(shine, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(1, 50, -0.5, 0),
        }):Play()
    end
end

local function makeCard(name)
    local card = Instance.new("Frame")
    card.Name = name
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.Position = UDim2.fromScale(0.5, 0.5)
    card.Size = UDim2.new(0, CONFIG.Width, 0, 0)
    card.AutomaticSize = Enum.AutomaticSize.Y
    card.BackgroundColor3 = C_CARD
    card.BorderSizePixel = 0
    card.Visible = false
    card.ZIndex = 10
    card.Parent = gui
    corner(card, 20)

    local bgGrad = Instance.new("UIGradient")
    bgGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(244, 247, 255)),
    })
    bgGrad.Rotation = 90
    bgGrad.Parent = card

    local glow1 = Instance.new("UIStroke")
    glow1.Color = CONFIG.Accent
    glow1.Thickness = 12
    glow1.Transparency = 0.95
    glow1.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    glow1.Parent = card

    local glow2 = Instance.new("UIStroke")
    glow2.Color = CONFIG.Accent2
    glow2.Thickness = 6
    glow2.Transparency = 0.88
    glow2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    glow2.Parent = card

    local mainStroke = Instance.new("UIStroke")
    mainStroke.Thickness = 1.5
    mainStroke.Transparency = 0
    mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    mainStroke.Parent = card
    triGradient(mainStroke, 45)

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 22)
    pad.PaddingBottom = UDim.new(0, 22)
    pad.PaddingLeft = UDim.new(0, 22)
    pad.PaddingRight = UDim.new(0, 22)
    pad.Parent = card

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 0)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Parent = card

    return card
end

local function loadLogoAsset()
    local url  = CONFIG.LogoURL
    local file = CONFIG.LogoFile
    if not url or not file then return nil end

    local getCustom = getcustomasset or getsynasset
    if type(getCustom) ~= "function" then return nil end
    if type(writefile) ~= "function" then return nil end

    local fileExists = false
    if type(isfile) == "function" then
        local okI, exists = pcall(isfile, file)
        fileExists = (okI and exists) and true or false
    end

    if not fileExists then
        local okD = pcall(function()
            local content = game:HttpGet(url)
            if type(content) ~= "string" or #content < 100 then
                error("下载失败或内容为空")
            end
            writefile(file, content)
        end)
        if not okD then return nil end
    end

    local okG, asset = pcall(getCustom, file)
    if okG and type(asset) == "string" and asset ~= "" then
        return asset
    end
    return nil
end

local LOGO_ASSET = loadLogoAsset()

local function buildLogo(parent, sizePx, layoutOrder, radius)
    local r = radius or 14
    local wrap = Instance.new("Frame")
    wrap.Size = UDim2.new(0, sizePx, 0, sizePx)
    wrap.BackgroundColor3 = CONFIG.Accent
    wrap.BorderSizePixel = 0
    wrap.LayoutOrder = layoutOrder
    wrap.ZIndex = 3
    wrap.Parent = parent
    corner(wrap, r)
    triGradient(wrap, 45)

    local halo = Instance.new("UIStroke")
    halo.Color = CONFIG.Accent
    halo.Thickness = 5
    halo.Transparency = 0.82
    halo.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    halo.Parent = wrap

    if LOGO_ASSET then
        local img = Instance.new("ImageLabel")
        img.Size = UDim2.fromScale(1, 1)
        img.BackgroundTransparency = 1
        img.Image = LOGO_ASSET
        img.ScaleType = Enum.ScaleType.Crop
        img.ZIndex = 4
        img.Parent = wrap
        corner(img, r)
    else
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.fromScale(1, 1)
        lbl.BackgroundTransparency = 1
        lbl.Text = "纸"
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        lbl.TextSize = math.floor(sizePx * 0.42)
        lbl.Font = Enum.Font.GothamBlack
        lbl.ZIndex = 4
        lbl.Parent = wrap
    end

    return wrap
end

local function resolveModulePath(source)
    if typeof(source) == "Instance" then
        if not source:IsA("ModuleScript") then
            return nil, "不是 ModuleScript：" .. source:GetFullName()
        end
        return source, nil
    elseif type(source) == "string" then
        local current = game
        for seg in string.gmatch(source, "[^%.]+") do
            local nxt = current:FindFirstChild(seg)
            if not nxt then return nil, "路径不存在：" .. source end
            current = nxt
        end
        if not current:IsA("ModuleScript") then
            return nil, "不是 ModuleScript：" .. source
        end
        return current, nil
    end
    return nil, "不支持的来源类型"
end

local function executeItem(item)
    local src  = item.Source
    local kind = item.Kind

    if not kind then
        if type(src) == "string" and src:match("^https?://") then
            kind = "url"
        else
            kind = "module"
        end
    end

    if kind == "url" then
        if type(loadstring) ~= "function" then
            return false, "当前环境不支持 loadstring"
        end
        local ok, body = pcall(function()
            return game:HttpGet(src)
        end)
        if not ok then
            return false, "下载失败：" .. tostring(body)
        end
        if type(body) ~= "string" or body == "" then
            return false, "下载内容为空"
        end
        local fn, compileErr = loadstring(body)
        if not fn then
            return false, "编译失败：" .. tostring(compileErr)
        end
        local ok2, runErr = pcall(fn)
        if not ok2 then
            return false, "运行出错：" .. tostring(runErr)
        end
        return true
    elseif kind == "module" then
        local resolved, err = resolveModulePath(src)
        if not resolved then return false, err end
        local ok, res = pcall(require, resolved)
        if not ok then return false, tostring(res) end
        return true
    end

    return false, "未知 Kind：" .. tostring(kind)
end

local old = PlayerGui:FindFirstChild("ScriptLoaderUI")
if old then old:Destroy() end

gui = Instance.new("ScreenGui")
gui.Name = "ScriptLoaderUI"
gui.ResetOnSpawn = false
gui.DisplayOrder = 1000
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = PlayerGui

local overlay = Instance.new("Frame")
overlay.Name = "Overlay"
overlay.Size = UDim2.fromScale(1, 1)
overlay.BackgroundColor3 = Color3.fromRGB(10, 12, 24)
overlay.BackgroundTransparency = 1
overlay.BorderSizePixel = 0
overlay.ZIndex = 1
overlay.Parent = gui

TweenService:Create(overlay, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
    BackgroundTransparency = 0.5,
}):Play()

local card1 = makeCard("Card_Loader")

local topRow = Instance.new("Frame")
topRow.Size = UDim2.new(1, 0, 0, 54)
topRow.BackgroundTransparency = 1
topRow.LayoutOrder = 1
topRow.ZIndex = 2
topRow.Parent = card1

local logoWrap = buildLogo(topRow, 44, 1)
logoWrap.Position = UDim2.new(0, 0, 0, 5)

local titleBlock = Instance.new("Frame")
titleBlock.Size = UDim2.new(1, -54 - 72, 0, 54)
titleBlock.Position = UDim2.new(0, 54, 0, 0)
titleBlock.BackgroundTransparency = 1
titleBlock.ZIndex = 2
titleBlock.Parent = topRow

local titleLbl = Instance.new("TextLabel")
titleLbl.Size = UDim2.new(1, 0, 0, 26)
titleLbl.Position = UDim2.new(0, 0, 0, 6)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = CONFIG.Title
titleLbl.TextColor3 = C_TEXT
titleLbl.TextSize = 17
titleLbl.Font = Enum.Font.GothamBold
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.TextTruncate = Enum.TextTruncate.AtEnd
titleLbl.ZIndex = 3
titleLbl.Parent = titleBlock

local tg = Instance.new("UIGradient")
tg.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, C_TEXT),
    ColorSequenceKeypoint.new(1, CONFIG.Accent),
})
tg.Rotation = 0
tg.Parent = titleLbl

local subLbl = Instance.new("TextLabel")
subLbl.Size = UDim2.new(1, 0, 0, 18)
subLbl.Position = UDim2.new(0, 0, 0, 30)
subLbl.BackgroundTransparency = 1
subLbl.Text = CONFIG.Subtitle
subLbl.TextColor3 = C_SUB
subLbl.TextSize = 12
subLbl.Font = Enum.Font.Gotham
subLbl.TextXAlignment = Enum.TextXAlignment.Left
subLbl.TextTruncate = Enum.TextTruncate.AtEnd
subLbl.ZIndex = 3
subLbl.Parent = titleBlock

local versionPill = Instance.new("TextLabel")
versionPill.AnchorPoint = Vector2.new(1, 0)
versionPill.Position = UDim2.new(1, 0, 0, 0)
versionPill.Size = UDim2.new(0, 64, 0, 22)
versionPill.BackgroundColor3 = Color3.fromRGB(240, 242, 255)
versionPill.BorderSizePixel = 0
versionPill.Text = CONFIG.Version
versionPill.TextColor3 = CONFIG.Accent
versionPill.TextSize = 11
versionPill.Font = Enum.Font.GothamBold
versionPill.ZIndex = 4
versionPill.Parent = topRow
corner(versionPill, 11)

local vs = Instance.new("UIStroke")
vs.Thickness = 1
vs.Transparency = 0.5
vs.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
vs.Parent = versionPill
triGradient(vs, 45)

spacer(card1, 16, 2)

local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, 0, 0, 1)
divider.BackgroundColor3 = C_BORDER
divider.BackgroundTransparency = 0.2
divider.BorderSizePixel = 0
divider.LayoutOrder = 3
divider.ZIndex = 2
divider.Parent = card1
triGradient(divider, 0)

spacer(card1, 12, 4)

local STATE_COLOR = {
    wait    = Color3.fromRGB(205, 210, 220),
    loading = CONFIG.Accent,
    success = Color3.fromRGB(16, 185, 129),
    error   = C_ERR,
}
local STATE_ICON = { wait = "", loading = "…", success = "✓", error = "✗" }

local headerRow = Instance.new("Frame")
headerRow.Size = UDim2.new(1, 0, 0, 20)
headerRow.BackgroundTransparency = 1
headerRow.LayoutOrder = 5
headerRow.ZIndex = 2
headerRow.Parent = card1

local progressLbl = Instance.new("TextLabel")
progressLbl.Size = UDim2.new(1, -60, 1, 0)
progressLbl.BackgroundTransparency = 1
progressLbl.Text = ""
progressLbl.TextColor3 = C_SUB
progressLbl.TextSize = 11
progressLbl.Font = Enum.Font.Gotham
progressLbl.TextXAlignment = Enum.TextXAlignment.Left
progressLbl.TextTruncate = Enum.TextTruncate.AtEnd
progressLbl.ZIndex = 2
progressLbl.Parent = headerRow

local modePill = Instance.new("TextLabel")
modePill.AnchorPoint = Vector2.new(1, 0.5)
modePill.Position = UDim2.new(1, 0, 0.5, 0)
modePill.Size = UDim2.new(0, 52, 0, 18)
modePill.BackgroundColor3 = Color3.fromRGB(240, 242, 255)
modePill.BorderSizePixel = 0
modePill.Text = "单选"
modePill.TextColor3 = CONFIG.Accent
modePill.TextSize = 10
modePill.Font = Enum.Font.GothamBold
modePill.ZIndex = 3
modePill.Parent = headerRow
corner(modePill, 9)

local modeStroke = Instance.new("UIStroke")
modeStroke.Thickness = 1
modeStroke.Transparency = 0.4
modeStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
modeStroke.Parent = modePill
triGradient(modeStroke, 45)

spacer(card1, 8, 6)

local scriptListHeight = #CONFIG.Scripts * ROW_H
    + math.max(0, #CONFIG.Scripts - 1) * ROW_GAP

local scriptList = Instance.new("Frame")
scriptList.Size = UDim2.new(1, 0, 0, scriptListHeight)
scriptList.BackgroundTransparency = 1
scriptList.LayoutOrder = 7
scriptList.ZIndex = 2
scriptList.Parent = card1

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, ROW_GAP)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = scriptList

local rows = {}

local defaultIdx = 1
for i, item in ipairs(CONFIG.Scripts) do
    if item.Default then defaultIdx = i; break end
end

local function updateRow(row)
    local state = row.state
    if state == "wait" then
        if row.selected then
            row.dot.BackgroundColor3 = CONFIG.Accent
            row.cbStroke.Transparency = 1
            row.dotLbl.Text = "✓"
            row.nameLbl.TextColor3 = C_TEXT
            row.statusLbl.Text = "已选"
            row.statusLbl.TextColor3 = CONFIG.Accent
        else
            row.dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            row.cbStroke.Transparency = 0
            row.cbStroke.Color = C_BORDER
            row.dotLbl.Text = ""
            row.nameLbl.TextColor3 = C_TEXT
            row.statusLbl.Text = ""
        end
    else
        local color = STATE_COLOR[state] or STATE_COLOR.wait
        row.dot.BackgroundColor3 = color
        row.cbStroke.Transparency = 1
        row.dotLbl.Text = STATE_ICON[state] or ""
        row.nameLbl.TextColor3 = C_TEXT
        if state == "loading" then
            row.statusLbl.Text = "加载中…"
        elseif state == "success" then
            row.statusLbl.Text = (row.ms and (row.ms .. " ms")) or "完成"
        elseif state == "error" then
            row.statusLbl.Text = "失败"
        end
        row.statusLbl.TextColor3 = color
    end
end

local function updateSelectionSummary()
    local name = nil
    for _, r in ipairs(rows) do
        if r.selected then
            name = r.nameLbl.Text
            break
        end
    end
    if name then
        progressLbl.Text = "已选：" .. name
    else
        progressLbl.Text = "未选择脚本"
    end
end

for i, item in ipairs(CONFIG.Scripts) do
    local row = Instance.new("TextButton")
    row.Size = UDim2.new(1, 0, 0, ROW_H)
    row.BackgroundColor3 = C_SOFT
    row.BorderSizePixel = 0
    row.AutoButtonColor = false
    row.Text = ""
    row.LayoutOrder = i
    row.ZIndex = 2
    row.Parent = scriptList
    corner(row, 10)

    local rowStroke = Instance.new("UIStroke")
    rowStroke.Color = C_BORDER
    rowStroke.Thickness = 1
    rowStroke.Transparency = 0.6
    rowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    rowStroke.Parent = row

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 20, 0, 20)
    dot.Position = UDim2.new(0, 10, 0.5, 0)
    dot.AnchorPoint = Vector2.new(0, 0.5)
    dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    dot.BorderSizePixel = 0
    dot.ZIndex = 3
    dot.Parent = row
    corner(dot, 10)

    local cbStroke = Instance.new("UIStroke")
    cbStroke.Color = C_BORDER
    cbStroke.Thickness = 1.5
    cbStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    cbStroke.Parent = dot

    local dotLbl = Instance.new("TextLabel")
    dotLbl.Size = UDim2.fromScale(1, 1)
    dotLbl.BackgroundTransparency = 1
    dotLbl.Text = ""
    dotLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    dotLbl.TextSize = 12
    dotLbl.Font = Enum.Font.GothamBold
    dotLbl.ZIndex = 4
    dotLbl.Parent = dot

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(1, -38 - 80, 1, 0)
    nameLbl.Position = UDim2.new(0, 38, 0, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = item.Name
    nameLbl.TextColor3 = C_TEXT
    nameLbl.TextSize = 13
    nameLbl.Font = Enum.Font.GothamMedium
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
    nameLbl.ZIndex = 3
    nameLbl.Parent = row

    local statusLbl = Instance.new("TextLabel")
    statusLbl.AnchorPoint = Vector2.new(1, 0.5)
    statusLbl.Position = UDim2.new(1, -12, 0.5, 0)
    statusLbl.Size = UDim2.new(0, 76, 1, 0)
    statusLbl.BackgroundTransparency = 1
    statusLbl.Text = ""
    statusLbl.TextColor3 = C_SUB
    statusLbl.TextSize = 11
    statusLbl.Font = Enum.Font.Gotham
    statusLbl.TextXAlignment = Enum.TextXAlignment.Right
    statusLbl.ZIndex = 3
    statusLbl.Parent = row

    local rowData = {
        frame = row, dot = dot, cbStroke = cbStroke, dotLbl = dotLbl,
        nameLbl = nameLbl, statusLbl = statusLbl,
        state = "wait",
        selected = (i == defaultIdx),
        ms = nil,
    }
    rows[i] = rowData
    updateRow(rowData)

    row.MouseEnter:Connect(function()
        if loading or rowData.state ~= "wait" then return end
        if rowData.selected then return end
        TweenService:Create(row, TweenInfo.new(0.15), { BackgroundColor3 = C_SOFT_HV }):Play()
    end)
    row.MouseLeave:Connect(function()
        TweenService:Create(row, TweenInfo.new(0.15), { BackgroundColor3 = C_SOFT }):Play()
    end)

    row.MouseButton1Click:Connect(function()
        if loading then return end
        if rowData.state ~= "wait" then return end
        if rowData.selected then return end

        for _, r in ipairs(rows) do
            if r.selected then
                r.selected = false
                updateRow(r)
            end
        end
        rowData.selected = true
        updateRow(rowData)
        updateSelectionSummary()
    end)
end

updateSelectionSummary()

spacer(card1, 12, 8)

local progressBg = Instance.new("Frame")
progressBg.Size = UDim2.new(1, 0, 0, 6)
progressBg.BackgroundColor3 = C_SOFT
progressBg.BorderSizePixel = 0
progressBg.ClipsDescendants = true
progressBg.LayoutOrder = 9
progressBg.ZIndex = 2
progressBg.Parent = card1
corner(progressBg, 3)

local progressFill = Instance.new("Frame")
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = CONFIG.Accent
progressFill.BorderSizePixel = 0
progressFill.ZIndex = 3
progressFill.Parent = progressBg
corner(progressFill, 3)
triGradient(progressFill, 0)

spacer(card1, 18, 10)

local startBtn = Instance.new("TextButton")
startBtn.Size = UDim2.new(1, 0, 0, 46)
startBtn.BackgroundColor3 = CONFIG.Accent
startBtn.BorderSizePixel = 0
startBtn.AutoButtonColor = false
startBtn.Text = "加载选中脚本"
startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
startBtn.TextSize = 15
startBtn.Font = Enum.Font.GothamBold
startBtn.LayoutOrder = 11
startBtn.ZIndex = 3
startBtn.Parent = card1
corner(startBtn, 12)
triGradient(startBtn, 0)

local startShine = addShine(startBtn, 12)
local startScale = Instance.new("UIScale")
startScale.Parent = startBtn
local startHover = false

startBtn.MouseEnter:Connect(function()
    if loading then return end
    startHover = true
    TweenService:Create(startScale, TweenInfo.new(0.2), { Scale = 1.02 }):Play()
    startShine()
end)
startBtn.MouseLeave:Connect(function()
    startHover = false
    TweenService:Create(startScale, TweenInfo.new(0.2), { Scale = 1 }):Play()
end)
startBtn.MouseButton1Down:Connect(function()
    if loading then return end
    TweenService:Create(startScale, TweenInfo.new(0.08), { Scale = 0.96 }):Play()
end)
startBtn.MouseButton1Up:Connect(function()
    TweenService:Create(startScale, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = startHover and 1.02 or 1,
    }):Play()
end)

card1.Visible = true

local card2 = makeCard("Card_Result")

local resultLogoRow = Instance.new("Frame")
resultLogoRow.Size = UDim2.new(1, 0, 0, 64)
resultLogoRow.BackgroundTransparency = 1
resultLogoRow.LayoutOrder = 1
resultLogoRow.ZIndex = 2
resultLogoRow.Parent = card2

local resultLogo = buildLogo(resultLogoRow, 56, 1, 16)
resultLogo.Position = UDim2.new(0.5, -28, 0, 0)

spacer(card2, 14, 2)

local resultTitle = Instance.new("TextLabel")
resultTitle.Size = UDim2.new(1, 0, 0, 26)
resultTitle.BackgroundTransparency = 1
resultTitle.Text = "加载完成"
resultTitle.TextColor3 = C_TEXT
resultTitle.TextSize = 18
resultTitle.Font = Enum.Font.GothamBold
resultTitle.LayoutOrder = 3
resultTitle.ZIndex = 2
resultTitle.Parent = card2

local tg3 = Instance.new("UIGradient")
tg3.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, C_TEXT),
    ColorSequenceKeypoint.new(0.6, CONFIG.Accent2),
    ColorSequenceKeypoint.new(1, CONFIG.Accent3),
})
tg3.Rotation = 0
tg3.Parent = resultTitle

spacer(card2, 8, 4)

local resultDesc = Instance.new("TextLabel")
resultDesc.Size = UDim2.new(1, 0, 0, 70)
resultDesc.BackgroundTransparency = 1
resultDesc.Text = ""
resultDesc.TextColor3 = C_SUB
resultDesc.TextSize = 13
resultDesc.Font = Enum.Font.Gotham
resultDesc.TextWrapped = true
resultDesc.LineHeight = 1.4
resultDesc.TextXAlignment = Enum.TextXAlignment.Left
resultDesc.TextYAlignment = Enum.TextYAlignment.Top
resultDesc.LayoutOrder = 5
resultDesc.ZIndex = 2
resultDesc.Parent = card2

spacer(card2, 18, 6)

local retryBtn = Instance.new("TextButton")
retryBtn.Size = UDim2.new(1, 0, 0, 46)
retryBtn.BackgroundColor3 = CONFIG.Accent
retryBtn.BorderSizePixel = 0
retryBtn.AutoButtonColor = false
retryBtn.Text = "重新加载"
retryBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
retryBtn.TextSize = 15
retryBtn.Font = Enum.Font.GothamBold
retryBtn.LayoutOrder = 7
retryBtn.ZIndex = 3
retryBtn.Parent = card2
corner(retryBtn, 12)
triGradient(retryBtn, 0)

local retryShine = addShine(retryBtn, 12)
local retryScale = Instance.new("UIScale")
retryScale.Parent = retryBtn

retryBtn.MouseEnter:Connect(function()
    TweenService:Create(retryScale, TweenInfo.new(0.2), { Scale = 1.02 }):Play()
    retryShine()
end)
retryBtn.MouseLeave:Connect(function()
    TweenService:Create(retryScale, TweenInfo.new(0.2), { Scale = 1 }):Play()
end)
retryBtn.MouseButton1Down:Connect(function()
    TweenService:Create(retryScale, TweenInfo.new(0.08), { Scale = 0.96 }):Play()
end)
retryBtn.MouseButton1Up:Connect(function()
    TweenService:Create(retryScale, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1,
    }):Play()
end)

spacer(card2, 10, 8)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(1, 0, 0, 46)
closeBtn.BackgroundColor3 = C_SOFT
closeBtn.BorderSizePixel = 0
closeBtn.AutoButtonColor = false
closeBtn.Text = "关闭"
closeBtn.TextColor3 = C_TEXT
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.GothamMedium
closeBtn.LayoutOrder = 9
closeBtn.ZIndex = 3
closeBtn.Parent = card2
corner(closeBtn, 12)

local closeStroke = Instance.new("UIStroke")
closeStroke.Color = C_BORDER
closeStroke.Thickness = 1
closeStroke.Transparency = 0
closeStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
closeStroke.Parent = closeBtn

local closeScale = Instance.new("UIScale")
closeScale.Parent = closeBtn
local closeHover = false

closeBtn.MouseEnter:Connect(function()
    closeHover = true
    TweenService:Create(closeBtn, TweenInfo.new(0.2), { BackgroundColor3 = C_SOFT_HV }):Play()
    TweenService:Create(closeStroke, TweenInfo.new(0.2), {
        Color = CONFIG.Accent, Transparency = 0.2,
    }):Play()
    TweenService:Create(closeScale, TweenInfo.new(0.2), { Scale = 1.02 }):Play()
end)
closeBtn.MouseLeave:Connect(function()
    closeHover = false
    TweenService:Create(closeBtn, TweenInfo.new(0.2), { BackgroundColor3 = C_SOFT }):Play()
    TweenService:Create(closeStroke, TweenInfo.new(0.2), {
        Color = C_BORDER, Transparency = 0,
    }):Play()
    TweenService:Create(closeScale, TweenInfo.new(0.2), { Scale = 1 }):Play()
end)
closeBtn.MouseButton1Down:Connect(function()
    TweenService:Create(closeScale, TweenInfo.new(0.08), { Scale = 0.96 }):Play()
end)
closeBtn.MouseButton1Up:Connect(function()
    TweenService:Create(closeScale, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = closeHover and 1.02 or 1,
    }):Play()
end)

local function switchCard(fromCard, toCard)
    local fromScale = fromCard:FindFirstChildOfClass("UIScale")
    if fromScale then
        TweenService:Create(fromScale, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Scale = 0.88,
        }):Play()
    end
    TweenService:Create(fromCard, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = UDim2.new(0.5, 0, 0.5, -30),
    }):Play()

    task.delay(0.3, function()
        fromCard.Visible = false
        toCard.Visible = true

        local oldScale = toCard:FindFirstChildOfClass("UIScale")
        if oldScale then oldScale:Destroy() end

        local toScale = Instance.new("UIScale")
        toScale.Parent = toCard
        toScale.Scale = 0.85
        toCard.Position = UDim2.new(0.5, 0, 0.5, 40)

        burstRing()

        TweenService:Create(toScale, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = 1,
        }):Play()
        TweenService:Create(toCard, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = UDim2.fromScale(0.5, 0.5),
        }):Play()
    end)
end

local function updateProgress(ratio, text)
    TweenService:Create(progressFill, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(math.clamp(ratio, 0, 1), 0, 1, 0),
    }):Play()
    if text then progressLbl.Text = text end
end

local function resetAll()
    for _, r in ipairs(rows) do
        r.state = "wait"
        r.ms = nil
        updateRow(r)
    end
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    updateSelectionSummary()
    startBtn.Text = "加载选中脚本"
    startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
end

local function runLoad()
    if loading then return end

    local current = nil
    for _, r in ipairs(rows) do
        if r.selected then current = r; break end
    end
    if not current then return end

    local currentItem = nil
    for i, item in ipairs(CONFIG.Scripts) do
        if rows[i] == current then currentItem = item; break end
    end
    if not currentItem then return end

    loading = true
    startBtn.Text = "加载中…"
    startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

    current.state = "loading"
    current.ms = nil
    updateRow(current)
    updateProgress(0, "正在加载 · 0/1")

    task.wait()

    local t0 = os.clock()
    local success, err
    if CONFIG.Demo then
        task.wait(0.8)
        success = true
    else
        success, err = executeItem(currentItem)
    end
    local ms = math.floor((os.clock() - t0) * 1000)

    updateProgress(1, "已完成 · 1/1")

    if success then
        current.state = "success"
        current.ms = ms
        updateRow(current)

        startBtn.Text = "✓ 加载完毕"
        startBtn.TextColor3 = Color3.fromRGB(220, 255, 235)

        resultTitle.Text = "加载成功"
        resultDesc.Text = ("脚本：%s\n耗时：%d ms\n所有内容已就绪"):format(currentItem.Name, ms)
    else
        current.state = "error"
        updateRow(current)

        startBtn.Text = "✗ 加载失败"
        startBtn.TextColor3 = Color3.fromRGB(255, 220, 220)

        resultTitle.Text = "加载失败"
        resultDesc.Text = ("脚本：%s\n原因：%s"):format(currentItem.Name, tostring(err))
        warn(("[纸脚本加载器] %s 失败：%s"):format(currentItem.Name, tostring(err)))
    end

    task.wait(1.4)

    loading = false
    switchCard(card1, card2)
end

startBtn.MouseButton1Click:Connect(runLoad)

retryBtn.MouseButton1Click:Connect(function()
    switchCard(card2, card1)
    task.delay(0.75, function()
        resetAll()
        runLoad()
    end)
end)

closeBtn.MouseButton1Click:Connect(function()
    local s = card2:FindFirstChildOfClass("UIScale")
    if s then
        TweenService:Create(s, TweenInfo.new(0.3), { Scale = 0.85 }):Play()
    end
    TweenService:Create(card2, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = UDim2.new(0.5, 0, 0.5, 40),
    }):Play()
    TweenService:Create(overlay, TweenInfo.new(0.3), { BackgroundTransparency = 1 }):Play()

    task.delay(0.32, function()
        gui:Destroy()
    end)
end)

local card1Scale = Instance.new("UIScale")
card1Scale.Parent = card1
card1Scale.Scale = 0.85
card1.Position = UDim2.new(0.5, 0, 0.5, 40)

task.spawn(function()
    task.wait(0.12)
    burstRing()
    TweenService:Create(card1Scale, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1,
    }):Play()
    TweenService:Create(card1, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = UDim2.fromScale(0.5, 0.5),
    }):Play()
end)