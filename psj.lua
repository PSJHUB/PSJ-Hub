--[[
  Deep semantic recovery pass (best effort)
  - Previous string decoding and structural cleanup are preserved.
  - Clearly identifiable helper/function names were restored semantically.
  - Ambiguous locals remain intentionally stable to avoid changing behavior.
  - Names marked as semantic are inferred from usage, not claimed to be original.
]]


local bit32 = bit32 or bit

local _frameCounter = 0
local function everyNFrames(n)
    _frameCounter = _frameCounter + 1
    return (_frameCounter % n) == 0
end


-- Semantic index (inferred from usage):
-- silentAimEnabled, aimbotEnabled, triggerbotEnabled, ragebotOrKillAura
-- espEnabled / espBoxEnabled / espNameEnabled / espHealthEnabled / espWeaponEnabled
-- flyEnabled / heightLockEnabled / shaderEnabled / emoteHopEnabled
-- aimbotHitPart / silentAimHitPart / aimbotFovRadius / silentAimFovRadius
-- get_property / get_hit_part / has_line_of_sight / is_teammate

-- ============================================================================
-- SECTION: Anti-Kick / Anti-Remote / Cloaking
-- ============================================================================
pcall(function()
    local Players = game:GetService("Players")
    local RS = game:GetService("ReplicatedStorage")
    local LP = Players.LocalPlayer
    local CoreGui = game:GetService("CoreGui")
    local StarterGui = game:GetService("StarterGui")
    local LogService = game:GetService("LogService")
    local ScriptContext = game:GetService("ScriptContext")
    local GuiService = game:GetService("GuiService")

    
    pcall(function()
        if LP and typeof(LP.Kick) == "function" then
            local oldKick = LP.Kick
            LP.Kick = function(...) end
        end
    end)

    
    pcall(function()
        if not hookmetamethod or not getnamecallmethod then return end
        local bannedRemoteNames = {
            kick=true, ban=true, punish=true, anticheat=true, detect=true,
            report=true, flag=true, crash=true, log=true, screenshot=true,
            security=true, mod=true, admin=true, watchdog=true, sentinel=true,
        }
        local function isSuspiciousName(n)
            if type(n) ~= "string" then return false end
            n = string.lower(n)
            for k,_ in pairs(bannedRemoteNames) do
                if string.find(n, k, 1, true) then return true end
            end
            return false
        end
        local old
        old = hookmetamethod(game, "__namecall", newcclosure and newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if method == "Kick" or method == "kick" then
                return
            end
            return old(self, ...)
        end) or function(self, ...)
            local method = getnamecallmethod()
            if method == "Kick" then return end
            return old(self, ...)
        end)
    end)

    
    pcall(function()
        local function cloak(inst)
            if not inst then return end
            pcall(function()
                inst.Name = tostring(math.random(100000,999999))
            end)
        end
        task.defer(function()
            task.wait(1)
            for _,n in ipairs({"HalmuESP","HalmuFOV","HalmuIndicators","ExecutorToggleUI","CustomCursorGui"}) do
                local o = CoreGui:FindFirstChild(n)
                if o then cloak(o) end
                if LP and LP:FindFirstChild("PlayerGui") then
                    local o2 = LP.PlayerGui:FindFirstChild(n)
                    if o2 then cloak(o2) end
                end
            end
        end)
    end)

    
    pcall(function()
        if ScriptContext and ScriptContext.Error then
            ScriptContext.Error:Connect(function() end)
        end
    end)

    
    
    pcall(function()
        if getconnections then
            
        end
    end)

    
    pcall(function()
        if setfflag then
            pcall(setfflag, "DebugRunServiceHumanoidCheck", "False")
        end
    end)

    
    pcall(function()
        local RunService = game:GetService("RunService")
        local last = 0
        RunService.Heartbeat:Connect(function()
            if tick() - last < 3 then return end
            last = tick()
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp and hrp.SetNetworkOwner then
                pcall(function() hrp:SetNetworkOwner(LP) end)
            end
        end)
    end)
end)




local nexlib = {accentclr = Color3.fromRGB(128, 213, 247), dropdownframes = {}, colorpickerframes = {}}

local _IlI0I0llI = {[Enum.UserInputType.MouseButton1]="M1",[Enum.UserInputType.MouseButton2]="M2",[Enum.UserInputType.MouseButton3]="M3"}
local L387_17 = {Enum.KeyCode.Unknown,Enum.KeyCode.W,Enum.KeyCode.A,Enum.KeyCode.S,Enum.KeyCode.D,Enum.KeyCode.Up,Enum.KeyCode.Left,Enum.KeyCode.Down,Enum.KeyCode.Right,Enum.KeyCode.Slash,Enum.KeyCode.Tab,Enum.KeyCode.Backspace,Enum.KeyCode.Escape,Enum.KeyCode.RightShift}

local function table_contains(tbl, L619_44)
    for k, _01O001l00 in next, tbl do if _01O001l00 == L619_44 or k == L619_44 then return true end end 
end;

local function make_draggable(clickObject, dragObject)
    pcall(function()
        local L425_74 = false;
        local _1297x260, __AOjJzuXUq, _352_117;
        clickObject.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
                L425_74 = true;
                __AOjJzuXUq = input.Position;
                _352_117 = dragObject.Position;
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then L425_74 = false end 
                end)
            end 
        end)
        clickObject.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then _1297x260 = input end 
        end)
        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if input == _1297x260 and L425_74 then 
                local _0x3ba8 = input.Position - __AOjJzuXUq;
                dragObject.Position = UDim2.new(_352_117.X.Scale, _352_117.X.Offset + _0x3ba8.X, _352_117.Y.Scale, _352_117.Y.Offset + _0x3ba8.Y)
            end 
        end)
    end)
end;

local _7765x301 = Instance.new("ScreenGui")
_7765x301.Name = "nexlib"
setthreadidentity = setthreadidentity or function() end;
setthreadidentity(8)
_7765x301.Parent = game:GetService("CoreGui")
_7765x301.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;

local _0x8bd0 = Instance.new("ScreenGui")
_0x8bd0.Name = "CustomCursorGui"
_0x8bd0.ResetOnSpawn = false
_0x8bd0.Parent = _7765x301

local _lO1I110O0 = Instance.new("Frame")
_lO1I110O0.Name = "CursorBox"
_lO1I110O0.Size = UDim2.new(0, 6, 0, 6)
_lO1I110O0.BackgroundColor3 = Color3.fromRGB(128, 213, 247)
_lO1I110O0.BorderSizePixel = 0
_lO1I110O0.Visible = false
_lO1I110O0.Parent = _0x8bd0

local L857_11 = Instance.new("Folder")
L857_11.Name = "NotificationFolder"
L857_11.Parent = _7765x301;

local _IO1IllIllI = {}
local a78b48c88 = 22
local v11504 = 6
local __bTYMBRTlW = 8
local _lIl00l10I = 3
local v21929 = 40

local function refresh_notifications()
    local v53851 = game:GetService("TweenService")
    for i, a91b73c94 in ipairs(_IO1IllIllI) do
        if a91b73c94.bar and a91b73c94.bar.Parent then
            local _972_644 = v21929 + (i - 1) * (a78b48c88 + v11504)
            v53851:Create(a91b73c94.bar, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, 0, 0, _972_644)
            }):Play()
        end
    end
end

function nexlib:Notification(title, desc, duration)
    duration = duration or _lIl00l10I
    local __HXpPNMGTE = tostring(title or "")
    if desc and desc ~= "" then
        __HXpPNMGTE = __HXpPNMGTE .. "  ·  " .. tostring(desc)
    end

    local v53851 = game:GetService("TweenService")

    
    while #_IO1IllIllI >= __bTYMBRTlW do
        local __OZTNJRtqAUHo = table.remove(_IO1IllIllI)
        if __OZTNJRtqAUHo and __OZTNJRtqAUHo.bar and __OZTNJRtqAUHo.bar.Parent then
            local v41401 = v53851:Create(__OZTNJRtqAUHo.label, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                TextTransparency = 1
            })
            local L325_78 = v53851:Create(__OZTNJRtqAUHo.bar, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, a78b48c88),
                BackgroundTransparency = 1
            })
            local _2716x195 = v53851:Create(__OZTNJRtqAUHo.stroke, TweenInfo.new(0.2), { Transparency = 1 })
            v41401:Play()
            L325_78:Play()
            _2716x195:Play()
            L325_78.Completed:Connect(function()
                pcall(function() if __OZTNJRtqAUHo.bar then __OZTNJRtqAUHo.bar:Destroy() end end)
                refresh_notifications()
            end)
        end
    end

    local _356_632 = Instance.new("Frame")
    _356_632.Name = "Notification"
    _356_632.Parent = L857_11
    _356_632.AnchorPoint = Vector2.new(0.5, 0)
    _356_632.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
    _356_632.BorderSizePixel = 0
    _356_632.Position = UDim2.new(0.5, 0, 0, v21929)
    _356_632.Size = UDim2.new(0, 0, 0, a78b48c88)
    _356_632.ClipsDescendants = true
    _356_632.BackgroundTransparency = 0.05
    _356_632.ZIndex = 100

    local _3429x450 = Instance.new("UIStroke")
    _3429x450.Parent = _356_632
    _3429x450.Color = nexlib.accentclr
    _3429x450.Thickness = 1.5
    _3429x450.Transparency = 0.25

    local v17131 = Instance.new("Frame")
    v17131.Name = "AccentLine"
    v17131.Parent = _356_632
    v17131.BackgroundColor3 = nexlib.accentclr
    v17131.BorderSizePixel = 0
    v17131.Size = UDim2.new(0, 3, 1, 0)
    v17131.Position = UDim2.new(0, 0, 0, 0)

    local _0xf0da = Instance.new("TextLabel")
    _0xf0da.Parent = _356_632
    _0xf0da.BackgroundTransparency = 1
    _0xf0da.Position = UDim2.new(0, 14, 0, 0)
    _0xf0da.Size = UDim2.new(1, -28, 1, 0)
    _0xf0da.Font = Enum.Font.Code
    _0xf0da.Text = __HXpPNMGTE
    _0xf0da.TextColor3 = Color3.fromRGB(230, 230, 230)
    _0xf0da.TextSize = 13
    _0xf0da.TextXAlignment = Enum.TextXAlignment.Center
    _0xf0da.TextTransparency = 1
    _0xf0da.TextTruncate = Enum.TextTruncate.None

    local _2656x592 = game:GetService("TextService")
    local _9062x428 = _2656x592:GetTextSize(__HXpPNMGTE, 13, Enum.Font.Code, Vector2.new(2000, a78b48c88))
    local __HfSBWUAMD = math.clamp(_9062x428.X + 48, 200, 480)

    
    table.insert(_IO1IllIllI, 1, {
        _356_632 = _356_632,
        _0xf0da = _0xf0da,
        _3429x450 = _3429x450
    })

    refresh_notifications()

    local _0x1f6d = v53851:Create(_356_632, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, __HfSBWUAMD, 0, a78b48c88)
    })
    local _430_962 = v53851:Create(_0xf0da, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0
    })
    _0x1f6d:Play()
    task.delay(0.08, function() _430_962:Play() end)
    task.delay(duration, function()
        for i, a91b73c94 in ipairs(_IO1IllIllI) do
            if a91b73c94.bar == _356_632 then
                table.remove(_IO1IllIllI, i)
                break
            end
        end

        if not _356_632 or not _356_632.Parent then
            refresh_notifications()
            return
        end

        local v41401 = v53851:Create(_0xf0da, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            TextTransparency = 1
        })
        local L325_78 = v53851:Create(_356_632, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, a78b48c88),
            BackgroundTransparency = 1
        })
        local _2716x195 = v53851:Create(_3429x450, TweenInfo.new(0.22), { Transparency = 1 })
        v41401:Play()
        L325_78:Play()
        _2716x195:Play()
        L325_78.Completed:Connect(function()
            pcall(function() _356_632:Destroy() end)
            refresh_notifications()
        end)
    end)
end;
function nexlib:Window(windowTitle)
    local L561_63 = true;
    local _OlOlOlOI10 = false;
    local _1698x129 = {} 
    
    local _783_273 = Instance.new("Frame")
    local S = Instance.new("ImageLabel")
    local _949_992 = Instance.new("ImageLabel")
    local v24652 = Instance.new("Frame")
    local a32b52c52 = Instance.new("ScrollingFrame")
    local _938_452 = Instance.new("UIListLayout")
    local __lsZXoNZxGSX = Instance.new("UIPadding")
    local __gnHZJbMuHwp = Instance.new("Frame")
    local L408_99 = Instance.new("TextLabel")
    local _1181x706 = Instance.new("Frame")
    
    _783_273.Name = "MainFrame"
    _783_273.Parent = _7765x301;
    _783_273.AnchorPoint = Vector2.new(0.5, 0.5)
    _783_273.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    _783_273.BackgroundTransparency = 0.15 
    _783_273.BorderColor3 = Color3.fromRGB(60, 60, 60)
    _783_273.BorderSizePixel = 0;
    _783_273.Position = UDim2.new(0.5, 0, 0.5, 0)
    _783_273.Size = UDim2.new(0, 525, 0, 631)
    _783_273.Visible = true
    _783_273.ClipsDescendants = true
    
    S.Name = "OutlineMainFrame1"
    S.Parent = _783_273; S.BackgroundTransparency = 1; S.Position = UDim2.new(0, 1, 0, 1)
    S.Size = UDim2.new(1, -2, 1, -2) S.Image = "rbxassetid://2592362371"
    S.ImageColor3 = Color3.fromRGB(60, 60, 60) S.ScaleType = Enum.ScaleType.Slice; S.SliceCenter = Rect.new(2, 2, 62, 62)
    
    _949_992.Name = "OutlineMainFrame2"
    _949_992.Parent = _783_273; _949_992.BackgroundTransparency = 1; _949_992.Size = UDim2.new(1, 0, 1, 0)
    _949_992.Image = "rbxassetid://2592362371" _949_992.ImageColor3 = Color3.fromRGB(0, 0, 0)
    _949_992.ScaleType = Enum.ScaleType.Slice; _949_992.SliceCenter = Rect.new(2, 2, 62, 62)
    
    v24652.Name = "ContainerHolderFrame"
    v24652.Parent = _783_273; v24652.AnchorPoint = Vector2.new(0.5, 0)
    v24652.BackgroundColor3 = Color3.fromRGB(24, 24, 24) v24652.Position = UDim2.new(0.5, 0, 0.071, 10)
    v24652.Size = UDim2.new(1, -18, 1, -42)
    v24652.BackgroundTransparency = 1
    v24652.ClipsDescendants = true
    
    a32b52c52.Name = "TabHolderFrame"
    a32b52c52.Parent = v24652; a32b52c52.BackgroundTransparency = 1;
    a32b52c52.Size = UDim2.new(1, 0, 0, 32) a32b52c52.Visible = true;
    a32b52c52.CanvasSize = UDim2.new(0, 700, 0, 0)
    a32b52c52.ScrollBarThickness = 0;
    
    _938_452.Name = "TabHolderFrameLayout"
    _938_452.Parent = a32b52c52; _938_452.FillDirection = Enum.FillDirection.Horizontal;
    _938_452.SortOrder = Enum.SortOrder.LayoutOrder; _938_452.Padding = UDim.new(0, 4)
    
    __lsZXoNZxGSX.Name = "TabHolderFramePadding"
    __lsZXoNZxGSX.Parent = a32b52c52; __lsZXoNZxGSX.PaddingLeft = UDim.new(0, 5)
    
    __gnHZJbMuHwp.Name = "TopBar"
    __gnHZJbMuHwp.Parent = _783_273; __gnHZJbMuHwp.AnchorPoint = Vector2.new(0.5, 0)
    __gnHZJbMuHwp.BackgroundColor3 = Color3.fromRGB(24, 24, 24) __gnHZJbMuHwp.BorderSizePixel = 0;
    __gnHZJbMuHwp.Position = UDim2.new(0.5, 0, 0, 2) __gnHZJbMuHwp.Size = UDim2.new(1, -5, 0, 28)
    
    L408_99.Name = "TopBarTitle"
    L408_99.Parent = __gnHZJbMuHwp; L408_99.BackgroundTransparency = 1;
    L408_99.Position = UDim2.new(0, 7, 0, 5) L408_99.Size = UDim2.new(0, 0, 0, 16)
    L408_99.Font = Enum.Font.Code; L408_99.Text = windowTitle;
    L408_99.TextColor3 = Color3.fromRGB(230, 230, 230) L408_99.TextSize = 16; L408_99.TextXAlignment = Enum.TextXAlignment.Left;
    
    _1181x706.Name = "TopBarLine"
    _1181x706.Parent = __gnHZJbMuHwp; _1181x706.BackgroundColor3 = nexlib.accentclr;
    _1181x706.BorderSizePixel = 0; _1181x706.Position = UDim2.new(0, 0, 0, 27) _1181x706.Size = UDim2.new(1, 0, 0, 1)
    
    make_draggable(__gnHZJbMuHwp, _783_273)

    local v56079 = game:GetService("Lighting")
    local L429_28 = v56079:FindFirstChild("ValkUIBlur") or Instance.new("BlurEffect")
    L429_28.Name = "ValkUIBlur"
    L429_28.Size = 0
    L429_28.Parent = v56079

    local function a49b45c10()
        _783_273.Visible = L561_63
        _lO1I110O0.Visible = L561_63
        game:GetService("UserInputService").MouseBehavior = Enum.MouseBehavior.Default
        
        local v53851 = game:GetService("TweenService")
        if L561_63 then
            v53851:Create(L429_28, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 18}):Play()
            _783_273.BackgroundTransparency = 1
            v53851:Create(_783_273, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.15}):Play()
        else
            v53851:Create(L429_28, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 0}):Play()
        end
    end
    
    game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
        if input.KeyCode == Enum.KeyCode.RightShift then 
            L561_63 = not L561_63;
            a49b45c10()
        end
end)

    local a87b27c15 = game:GetService("CoreGui")
    if a87b27c15:FindFirstChild("ExecutorToggleUI") then
        a87b27c15.ExecutorToggleUI:Destroy()
    end
local _425_141 = Instance.new("ScreenGui")
    _425_141.Name = "ExecutorToggleUI"
    _425_141.ResetOnSpawn = false
    _425_141.Parent = a87b27c15

    local a81b35c84 = Instance.new("TextButton")
    a81b35c84.Name = "ToggleFrame"
    a81b35c84.Size = UDim2.new(0, 65, 0, 36)
    a81b35c84.Position = UDim2.new(0, 20, 0, 20)
    a81b35c84.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    a81b35c84.BorderSizePixel = 0
    a81b35c84.Active = true
    a81b35c84.Draggable = true
    a81b35c84.Parent = _425_141

    local L788_37 = Instance.new("UIStroke")
    L788_37.Color = nexlib.accentclr 
    L788_37.Thickness = 2
    L788_37.Parent = a81b35c84

    local _1160x364 = Instance.new("TextLabel")
    _1160x364.Size = UDim2.new(1, -6, 0, 16)
    _1160x364.Position = UDim2.new(0, 3, 0, 2)
    _1160x364.BackgroundTransparency = 1
    _1160x364.Text = "Toggle"
    _1160x364.TextColor3 = Color3.fromRGB(230, 230, 230)
    _1160x364.TextSize = 12
    _1160x364.Font = Enum.Font.GothamBold
    _1160x364.TextXAlignment = Enum.TextXAlignment.Left
    _1160x364.Parent = a81b35c84

    local _7658x168 = Instance.new("TextLabel")
    _7658x168.Size = UDim2.new(1, -6, 0, 16)
    _7658x168.Position = UDim2.new(0, 3, 0, 18)
    _7658x168.BackgroundTransparency = 1
    _7658x168.Text = "Look"
    _7658x168.TextColor3 = Color3.fromRGB(230, 230, 230)
    _7658x168.TextSize = 12
    _7658x168.Font = Enum.Font.GothamBold
    _7658x168.TextXAlignment = Enum.TextXAlignment.Left
    _7658x168.Parent = a81b35c84

    a81b35c84.MouseButton1Click:Connect(function()
        L561_63 = not L561_63
        a49b45c10()
    end)
    
    coroutine.wrap(function()
        while task.wait() do 
            _1181x706.BackgroundColor3 = nexlib.accentclr 
            L788_37.Color = nexlib.accentclr 
            _lO1I110O0.BackgroundColor3 = nexlib.accentclr
            
            if L561_63 then
                local _6588x624 = game:GetService("UserInputService"):GetMouseLocation()
                _lO1I110O0.Position = UDim2.new(0, _6588x624.X, 0, _6588x624.Y)
            end
        end 
    end)()

    local __hwEbYRFKK = {}
    
    function __hwEbYRFKK:Tab(tabName)
        local v87080 = 50;
        
        local __gCVqYDRdXmV = Instance.new("TextButton")
        __gCVqYDRdXmV.Name = tabName .. "_TabBtn"
        __gCVqYDRdXmV.Parent = a32b52c52
        __gCVqYDRdXmV.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        __gCVqYDRdXmV.BorderSizePixel = 0
        __gCVqYDRdXmV.Font = Enum.Font.Code
        __gCVqYDRdXmV.Text = tabName
        __gCVqYDRdXmV.TextColor3 = Color3.fromRGB(150, 150, 150)
        __gCVqYDRdXmV.TextSize = 14
        __gCVqYDRdXmV.AutoButtonColor = false
        
        local _9275x415 = game:GetService("TextService")
        local __BzTmvdpMcGg = _9275x415:GetTextSize(tabName, 14, Enum.Font.Code, Vector2.new(500, 500))
        __gCVqYDRdXmV.Size = UDim2.new(0, __BzTmvdpMcGg.X + 28, 0, 26)
        
        local _00l0IOll = Instance.new("Frame")
        _00l0IOll.Name = "TopLine"
        _00l0IOll.Parent = __gCVqYDRdXmV
        _00l0IOll.BackgroundColor3 = nexlib.accentclr
        _00l0IOll.BorderSizePixel = 0
        _00l0IOll.Position = UDim2.new(0, 0, 0, 0)
        _00l0IOll.Size = UDim2.new(1, 0, 0, 2)
        _00l0IOll.Visible = false
        
        local v77745 = Instance.new("ImageLabel")
        v77745.Name = "Outline"
        v77745.Parent = __gCVqYDRdXmV
        v77745.BackgroundTransparency = 1
        v77745.Size = UDim2.new(1, 0, 1, 0)
        v77745.Image = "rbxassetid://2592362371"
        v77745.ImageColor3 = Color3.fromRGB(45, 45, 45)
        v77745.ScaleType = Enum.ScaleType.Slice
        v77745.SliceCenter = Rect.new(2, 2, 62, 62)
        local _0x234e = Instance.new("ScrollingFrame")
        local _658_993 = Instance.new("UIPadding")
        local _0xfa7c = Instance.new("UIListLayout")
        local _203_856 = Instance.new("ScrollingFrame")
        local a36b16c67 = Instance.new("UIPadding")
        local _144_866 = Instance.new("UIListLayout")
        
        _0x234e.Name = tabName .. "_Holder1"
        _0x234e.Parent = v24652;
        _0x234e.Active = true; _0x234e.BackgroundTransparency = 1; _0x234e.BorderSizePixel = 0;
        _0x234e.Position = UDim2.new(0, 1, 0, 35) _0x234e.Size = UDim2.new(0, 245, 1, -40)
        _0x234e.Visible = false; _0x234e.CanvasSize = UDim2.new(0, 0, 0, 0) _0x234e.ScrollBarThickness = 4; _0x234e.ScrollingEnabled = true;
        
        _658_993.Parent = _0x234e; _658_993.PaddingTop = UDim.new(0, 5)
        _0xfa7c.Parent = _0x234e; _0xfa7c.SortOrder = Enum.SortOrder.LayoutOrder; _0xfa7c.Padding = UDim.new(0, 10)
        
        _203_856.Name = tabName .. "_Holder2"
        _203_856.Parent = v24652;
        _203_856.Active = true; _203_856.BackgroundTransparency = 1; _203_856.BorderSizePixel = 0;
        _203_856.Position = UDim2.new(0, 255, 0, 35) _203_856.Size = UDim2.new(0, 245, 1, -40)
        _203_856.Visible = false; _203_856.CanvasSize = UDim2.new(0, 0, 0, 0) _203_856.ScrollBarThickness = 4; _203_856.ScrollingEnabled = true;
        
        a36b16c67.Parent = _203_856; a36b16c67.PaddingTop = UDim.new(0, 5)
        _144_866.Parent = _203_856; _144_866.SortOrder = Enum.SortOrder.LayoutOrder; _144_866.Padding = UDim.new(0, 10)
        
        table.insert(_1698x129, {btn = __gCVqYDRdXmV, topLine = _00l0IOll, outline = v77745, h1 = _0x234e, h2 = _203_856})
        
        if _OlOlOlOI10 == false then 
            _OlOlOlOI10 = true;
            _0x234e.Visible = true;
            _203_856.Visible = true;
            __gCVqYDRdXmV.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
            __gCVqYDRdXmV.TextColor3 = Color3.fromRGB(230, 230, 230)
            _00l0IOll.Visible = true
            v77745.ImageColor3 = Color3.fromRGB(65, 65, 65)
        end;
        
        __gCVqYDRdXmV.MouseButton1Click:Connect(function()
            local _369_106 = game:GetService("TweenService")
            for __YEzeEiWEWFAS, t in ipairs(_1698x129) do
                if t.btn == __gCVqYDRdXmV then
                    _369_106:Create(t.btn, TweenInfo.new(0.12, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(33, 33, 33), TextColor3 = Color3.fromRGB(230, 230, 230)}):Play()
                    t.topLine.Visible = true
                    t.outline.ImageColor3 = Color3.fromRGB(65, 65, 65)
                    t.h1.Visible = true
                    t.h2.Visible = true
                else
                    _369_106:Create(t.btn, TweenInfo.new(0.12, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(22, 22, 22), TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
                    t.topLine.Visible = false
                    t.outline.ImageColor3 = Color3.fromRGB(45, 45, 45)
                    t.h1.Visible = false
                    t.h2.Visible = false
                end
end
        end)
        
        coroutine.wrap(function()
            while task.wait() do 
                if _00l0IOll.Visible then
                    _00l0IOll.BackgroundColor3 = nexlib.accentclr 
                end
            end 
        end)()
        
        local L926_31 = {}
        
        function L926_31:Section(sectionName, forceSide)
            v87080 = v87080 - 1;
            local L277_21 = nil;
            
            if forceSide == 1 then L277_21 = _0x234e
            elseif forceSide == 2 then L277_21 = _203_856
            else
                local _1672x889 = 0; local a89b99c60 = 0;
                for s, f in next, _0x234e:GetChildren() do if f.Name == "Section" or f.Name == "MultiSection" then _1672x889 = _1672x889 + 1 end end;
                for s, f in next, _203_856:GetChildren() do if f.Name == "Section" or f.Name == "MultiSection" then a89b99c60 = a89b99c60 + 1 end end;
                if _1672x889 == 0 and a89b99c60 == 0 then L277_21 = _0x234e 
                elseif _1672x889 == a89b99c60 then L277_21 = _0x234e 
                else L277_21 = _203_856 end;
            end
            
            local __dbloARWjl = Instance.new("Frame")
            local __PauMDmeitP = Instance.new("ImageLabel")
            local _0x848d = Instance.new("ImageLabel")
            local L349_81 = Instance.new("Frame")
            local v32876 = Instance.new("TextLabel")
            local _l10lO10l0l1 = Instance.new("Frame")
            local __ZZvUJOD = Instance.new("UIListLayout")
            
            __dbloARWjl.Name = "Section"
            __dbloARWjl.Parent = L277_21;
            __dbloARWjl.AnchorPoint = Vector2.new(0.5, 0)
            __dbloARWjl.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            __dbloARWjl.BorderSizePixel = 0;
            __dbloARWjl.Size = UDim2.new(1, -2, 0, 24)
            __dbloARWjl.ZIndex = v87080;
            
            __PauMDmeitP.Name = "SectionOutline2"
            __PauMDmeitP.Parent = __dbloARWjl; __PauMDmeitP.BackgroundTransparency = 1; __PauMDmeitP.Size = UDim2.new(1, 0, 1, 0)
            __PauMDmeitP.Image = "rbxassetid://2592362371" __PauMDmeitP.ImageColor3 = Color3.fromRGB(0, 0, 0)
            __PauMDmeitP.ScaleType = Enum.ScaleType.Slice; __PauMDmeitP.SliceCenter = Rect.new(2, 2, 62, 62)
            
            _0x848d.Name = "SectionOutline1"
            _0x848d.Parent = __dbloARWjl; _0x848d.BackgroundTransparency = 1; _0x848d.Position = UDim2.new(0, 1, 0, 1)
            _0x848d.Size = UDim2.new(1, -2, 1, -2) _0x848d.Image = "rbxassetid://2592362371"
            _0x848d.ImageColor3 = Color3.fromRGB(60, 60, 60) _0x848d.ScaleType = Enum.ScaleType.Slice; _0x848d.SliceCenter = Rect.new(2, 2, 62, 62)
            
            L349_81.Name = "SectionTitleFrame"
            L349_81.Parent = __dbloARWjl; L349_81.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            L349_81.BorderSizePixel = 0; L349_81.Position = UDim2.new(0, 10, 0, 0)
            
            v32876.Name = "SectionTitle"
            v32876.Parent = L349_81; v32876.BackgroundTransparency = 1; v32876.Position = UDim2.new(0, 0, 0, -3)
            v32876.Size = UDim2.new(1, 0, 0, 7) v32876.Font = Enum.Font.Code; v32876.Text = sectionName;
            v32876.TextColor3 = Color3.fromRGB(230, 230, 230) v32876.TextSize = 14;
            
            _l10lO10l0l1.Name = "SectionItemHolderFrame"
            _l10lO10l0l1.Parent = __dbloARWjl; _l10lO10l0l1.AnchorPoint = Vector2.new(0.5, 0)
            _l10lO10l0l1.BackgroundTransparency = 1; _l10lO10l0l1.Position = UDim2.new(0.5, 0, 0, 15)
            _l10lO10l0l1.Size = UDim2.new(1, -16, 0, 0)
            
            __ZZvUJOD.Parent = _l10lO10l0l1; __ZZvUJOD.SortOrder = Enum.SortOrder.LayoutOrder; __ZZvUJOD.Padding = UDim.new(0, 5)
            L349_81.Size = UDim2.new(0, v32876.TextBounds.X + 6, 0, 7)
            
            local function _6853x256()
                __dbloARWjl.Size = UDim2.new(1, -2, 0, __ZZvUJOD.AbsoluteContentSize.Y + 24)
                _0x234e.CanvasSize = UDim2.new(0, 0, 0, _0xfa7c.AbsoluteContentSize.Y + 20)
                _203_856.CanvasSize = UDim2.new(0, 0, 0, _144_866.AbsoluteContentSize.Y + 20)
            end

            local L429_27 = {}
            
            function L429_27:Toggle(text, default, callback)
                local __yJPdTAjBxLmN = Instance.new("TextButton")
                local _IO11IO100 = Instance.new("ImageLabel")
                local _3957x904 = Instance.new("ImageLabel")
                local __akbrmvrTgw = Instance.new("Frame")
                local _5527x333 = Instance.new("Frame")
                local v41003 = Instance.new("TextLabel")
                
                __yJPdTAjBxLmN.Name = "Toggle"
                __yJPdTAjBxLmN.Parent = _l10lO10l0l1
                __yJPdTAjBxLmN.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
                __yJPdTAjBxLmN.BorderSizePixel = 0
                __yJPdTAjBxLmN.Size = UDim2.new(1, 0, 0, 22)
                __yJPdTAjBxLmN.AutoButtonColor = false
                __yJPdTAjBxLmN.Text = ''
                
                _IO11IO100.Parent = __yJPdTAjBxLmN; _IO11IO100.BackgroundTransparency = 1; _IO11IO100.Size = UDim2.new(1, 0, 1, 0)
                _IO11IO100.Image = "rbxassetid://2592362371" _IO11IO100.ImageColor3 = Color3.fromRGB(60, 60, 60)
                _IO11IO100.ScaleType = Enum.ScaleType.Slice; _IO11IO100.SliceCenter = Rect.new(2, 2, 62, 62)
                
                _3957x904.Parent = __yJPdTAjBxLmN; _3957x904.BackgroundTransparency = 1; _3957x904.Position = UDim2.new(0, 1, 0, 1)
                _3957x904.Size = UDim2.new(1, -2, 1, -2) _3957x904.Image = "rbxassetid://2592362371"
                _3957x904.ImageColor3 = Color3.fromRGB(0, 0, 0) _3957x904.ScaleType = Enum.ScaleType.Slice; _3957x904.SliceCenter = Rect.new(2, 2, 62, 62)
                
                __akbrmvrTgw.Name = "Box"
                __akbrmvrTgw.Parent = __yJPdTAjBxLmN
                __akbrmvrTgw.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
                __akbrmvrTgw.BorderSizePixel = 0
                __akbrmvrTgw.Position = UDim2.new(0, 6, 0.5, -6)
                __akbrmvrTgw.Size = UDim2.new(0, 12, 0, 12)
                
                _5527x333.Name = "Check"
                _5527x333.Parent = __akbrmvrTgw
                _5527x333.BackgroundColor3 = nexlib.accentclr
                _5527x333.BorderSizePixel = 0
                _5527x333.Position = UDim2.new(0, 2, 0, 2)
                _5527x333.Size = UDim2.new(0, 8, 0, 8)
                _5527x333.Visible = default or false
                
                v41003.Parent = __yJPdTAjBxLmN
                v41003.BackgroundTransparency = 1
                v41003.Position = UDim2.new(0, 25, 0, 0)
                v41003.Size = UDim2.new(1, -25, 1, 0)
                v41003.Font = Enum.Font.Code
                v41003.Text = text
                v41003.TextColor3 = Color3.fromRGB(190, 190, 190)
                v41003.TextSize = 14
                v41003.TextXAlignment = Enum.TextXAlignment.Left
                
                local L248_33 = default or false
                __yJPdTAjBxLmN.MouseButton1Click:Connect(function()
                    L248_33 = not L248_33
                    _5527x333.Visible = L248_33
                    pcall(callback, L248_33)
                end)
                
                _6853x256()
                coroutine.wrap(function()
                    while task.wait() do _5527x333.BackgroundColor3 = nexlib.accentclr end
                end)()
                local a85b11c80 = {}
                function a85b11c80:Set(L619_44)
                    L248_33 = L619_44
                    _5527x333.Visible = L248_33
                    pcall(callback, L248_33)
                end
                return a85b11c80
            end
function L429_27:Button(text, callback)
                local _154_244 = Instance.new("TextButton")
                local _6024x853 = Instance.new("ImageLabel")
                local _974_367 = Instance.new("ImageLabel")
                
                _154_244.Name = "Button"
                _154_244.Parent = _l10lO10l0l1;
                _154_244.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
                _154_244.BorderColor3 = nexlib.accentclr;
                _154_244.BorderSizePixel = 0;
                _154_244.Size = UDim2.new(1, 0, 0, 20)
                _154_244.AutoButtonColor = false; _154_244.Font = Enum.Font.Code;
                _154_244.TextColor3 = Color3.fromRGB(230, 230, 230)
                _154_244.TextSize = 14; _154_244.Text = text;
                
                _6024x853.Name = "ButtonOutline1"
                _6024x853.Parent = _154_244; _6024x853.BackgroundTransparency = 1; _6024x853.Size = UDim2.new(1, 0, 1, 0)
                _6024x853.Image = "rbxassetid://2592362371" _6024x853.ImageColor3 = Color3.fromRGB(60, 60, 60)
                _6024x853.ScaleType = Enum.ScaleType.Slice; _6024x853.SliceCenter = Rect.new(2, 2, 62, 62)
                
                _974_367.Name = "ButtonOutline2"
                _974_367.Parent = _154_244; _974_367.BackgroundTransparency = 1; _974_367.Position = UDim2.new(0, 1, 0, 1)
                _974_367.Size = UDim2.new(1, -2, 1, -2) _974_367.Image = "rbxassetid://2592362371"
                _974_367.ImageColor3 = Color3.fromRGB(0, 0, 0) _974_367.ScaleType = Enum.ScaleType.Slice; _974_367.SliceCenter = Rect.new(2, 2, 62, 62)
                
                _154_244.MouseButton1Click:Connect(function() pcall(callback) end)
                _154_244.MouseEnter:Connect(function() _154_244.BorderSizePixel = 1 end)
                _154_244.MouseLeave:Connect(function() _154_244.BorderSizePixel = 0 end)
                
                _6853x256()
                coroutine.wrap(function()
                    while task.wait() do _154_244.BorderColor3 = nexlib.accentclr end 
                end)()
            end;
            
            function L429_27:Slider(text, min, max, default, rounding, callback)
                local _771_374 = Instance.new("TextButton")
                local _393_894 = Instance.new("Frame")
                local L180_65 = Instance.new("TextLabel")
                local _2281x495 = Instance.new("TextLabel")
                
                _771_374.Name = "SliderBar"
                _771_374.Parent = _l10lO10l0l1; _771_374.BackgroundColor3 = Color3.fromRGB(38, 38, 38); _771_374.BorderSizePixel = 0;
                _771_374.Size = UDim2.new(1, 0, 0, 16); _771_374.Text = ''; _771_374.AutoButtonColor = false;
                
                local L742_94 = Instance.new("ImageLabel")
                L742_94.Parent = _771_374; L742_94.BackgroundTransparency = 1; L742_94.Size = UDim2.new(1, 0, 1, 0)
                L742_94.Image = "rbxassetid://2592362371" L742_94.ImageColor3 = Color3.fromRGB(60, 60, 60)
                L742_94.ScaleType = Enum.ScaleType.Slice; L742_94.SliceCenter = Rect.new(2, 2, 62, 62)
                
                local L151_72 = Instance.new("ImageLabel")
                L151_72.Parent = _771_374; L151_72.BackgroundTransparency = 1; L151_72.Position = UDim2.new(0, 1, 0, 1)
                L151_72.Size = UDim2.new(1, -2, 1, -2) L151_72.Image = "rbxassetid://2592362371"
                L151_72.ImageColor3 = Color3.fromRGB(0, 0, 0) L151_72.ScaleType = Enum.ScaleType.Slice; L151_72.SliceCenter = Rect.new(2, 2, 62, 62)

                _393_894.Name = "SliderFill"
                _393_894.Parent = _771_374; _393_894.BackgroundColor3 = nexlib.accentclr; _393_894.BorderSizePixel = 0;
                _393_894.BackgroundTransparency = 0.55;
                _393_894.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                
                L180_65.Name = "SliderTitle"
                L180_65.Parent = _771_374; L180_65.BackgroundTransparency = 1; L180_65.Position = UDim2.new(0, 6, 0, 0)
                L180_65.Size = UDim2.new(0.7, 0, 1, 0)
                L180_65.Font = Enum.Font.Code; L180_65.Text = text; L180_65.TextColor3 = Color3.fromRGB(190, 190, 190); L180_65.TextSize = 13;
                L180_65.TextXAlignment = Enum.TextXAlignment.Left; L180_65.ZIndex = 2;
                
                _2281x495.Name = "SliderValue"
                _2281x495.Parent = _771_374; _2281x495.BackgroundTransparency = 1; _2281x495.Position = UDim2.new(1, -75, 0, 0)
                _2281x495.Size = UDim2.new(0, 70, 1, 0) _2281x495.Font = Enum.Font.Code; _2281x495.Text = tostring(default) .. "s";
                _2281x495.TextColor3 = Color3.fromRGB(240, 240, 240); _2281x495.TextSize = 13; _2281x495.TextXAlignment = Enum.TextXAlignment.Right; _2281x495.ZIndex = 5;
                
                local L425_74 = false
                local function _846_348(input)
                    local _7507x242 = math.clamp((input.Position.X - _771_374.AbsolutePosition.X) / _771_374.AbsoluteSize.X, 0, 1)
                    local L619_44 = min + (max - min) * _7507x242
                    if rounding == 0 then
                        L619_44 = math.floor(L619_44 + 0.5)
                    else
                        L619_44 = tonumber(string.format("%." .. rounding .. "f", L619_44))
                    end
                    _393_894.Size = UDim2.new(_7507x242, 0, 1, 0)
                    _2281x495.Text = tostring(L619_44) .. "s"
                    pcall(callback, L619_44)
                end
                
                _771_374.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        L425_74 = true
                        _846_348(input)
                    end
                end)
                game:GetService("UserInputService").InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then L425_74 = false end
                end)
                game:GetService("UserInputService").InputChanged:Connect(function(input)
                    if L425_74 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        _846_348(input)
                    end
                end)
                
                _6853x256()
                coroutine.wrap(function()
                    while task.wait() do _393_894.BackgroundColor3 = nexlib.accentclr end
end)()
            end

            function L429_27:Input(text, default, placeholder, callback)
                local __WpcgMLxB = Instance.new("Frame")
                local v26413 = Instance.new("TextLabel")
                local _0lOlII = Instance.new("TextBox")
                
                __WpcgMLxB.Name = "Input"
                __WpcgMLxB.Parent = _l10lO10l0l1; __WpcgMLxB.BackgroundTransparency = 1; __WpcgMLxB.Size = UDim2.new(1, 0, 0, 38)
                
                v26413.Name = "InputTitle"
                v26413.Parent = __WpcgMLxB; v26413.BackgroundTransparency = 1; v26413.Size = UDim2.new(1, 0, 0, 15)
                v26413.Font = Enum.Font.Code; v26413.Text = text; v26413.TextColor3 = Color3.fromRGB(190, 190, 190); v26413.TextSize = 14;
                v26413.TextXAlignment = Enum.TextXAlignment.Left;
                
                _0lOlII.Name = "InputBox"
                _0lOlII.Parent = __WpcgMLxB; _0lOlII.BackgroundColor3 = Color3.fromRGB(38, 38, 38); _0lOlII.BorderSizePixel = 0;
                _0lOlII.Position = UDim2.new(0, 0, 0, 18); _0lOlII.Size = UDim2.new(1, 0, 0, 20);
                _0lOlII.Font = Enum.Font.Code; _0lOlII.PlaceholderText = placeholder or ""; _0lOlII.Text = default or "";
                _0lOlII.TextColor3 = Color3.fromRGB(230, 230, 230); _0lOlII.TextSize = 14; _0lOlII.TextXAlignment = Enum.TextXAlignment.Left;
                
                _0lOlII.FocusLost:Connect(function(enterPressed)
                    pcall(callback, _0lOlII.Text)
                end)
                
                _6853x256()
            end

            function L429_27:Dropdown(text, list, default, callback)
                default = typeof(default) == "string" and default;
                if default == '' then default = nil end;
                
                local _0x12f8 = Instance.new("Frame")
                local _0x59ea = Instance.new("TextLabel")
                local _lOOO10lOI1I = Instance.new("TextButton")
                local a38b77c24 = Instance.new("ImageLabel")
                local _0xbce3 = Instance.new("ImageLabel")
                local _6434x601 = Instance.new("TextLabel")
                local _8206x386 = Instance.new("ImageLabel")
                
                _0x12f8.Name = "Dropdown"
                _0x12f8.Parent = _l10lO10l0l1; _0x12f8.BackgroundTransparency = 1; _0x12f8.Size = UDim2.new(1, 0, 0, 37)
                
                _0x59ea.Name = "DropdownTitle"
                _0x59ea.Parent = _0x12f8; _0x59ea.BackgroundTransparency = 1; _0x59ea.Size = UDim2.new(0, 0, 0, 13)
                _0x59ea.Font = Enum.Font.Code; _0x59ea.Text = text; _0x59ea.TextColor3 = Color3.fromRGB(230, 230, 230) _0x59ea.TextSize = 14;
                _0x59ea.TextXAlignment = Enum.TextXAlignment.Left;
                
                _lOOO10lOI1I.Name = "DropdownFrame"
                _lOOO10lOI1I.Parent = _0x12f8; _lOOO10lOI1I.BackgroundColor3 = Color3.fromRGB(38, 38, 38) _lOOO10lOI1I.BorderSizePixel = 0;
                _lOOO10lOI1I.Position = UDim2.new(0, 0, 1, -20) _lOOO10lOI1I.Size = UDim2.new(1, 0, 0, 20) _lOOO10lOI1I.Text = ''; _lOOO10lOI1I.AutoButtonColor = false;
                
                a38b77c24.Parent = _lOOO10lOI1I; a38b77c24.BackgroundTransparency = 1; a38b77c24.Size = UDim2.new(1, 0, 1, 0)
                a38b77c24.Image = "rbxassetid://2592362371" a38b77c24.ImageColor3 = Color3.fromRGB(60, 60, 60)
                a38b77c24.ScaleType = Enum.ScaleType.Slice; a38b77c24.SliceCenter = Rect.new(2, 2, 62, 62)
                
                _0xbce3.Parent = _lOOO10lOI1I; _0xbce3.BackgroundTransparency = 1; _0xbce3.Position = UDim2.new(0, 1, 0, 1)
                _0xbce3.Size = UDim2.new(1, -2, 1, -2) _0xbce3.Image = "rbxassetid://2592362371" _0xbce3.ImageColor3 = Color3.fromRGB(0, 0, 0)
                _0xbce3.ScaleType = Enum.ScaleType.Slice; _0xbce3.SliceCenter = Rect.new(2, 2, 62, 62)
                
                _6434x601.Name = "DropdownText"
                _6434x601.Parent = _lOOO10lOI1I; _6434x601.BackgroundTransparency = 1; _6434x601.Position = UDim2.new(0, 5, 0, 0)
                _6434x601.Size = UDim2.new(1, -5, 1, 0) _6434x601.Font = Enum.Font.Code; _6434x601.Text = typeof(default) == "string" and default or "...";
                _6434x601.TextColor3 = Color3.fromRGB(180, 180, 180) _6434x601.TextSize = 14; _6434x601.TextXAlignment = Enum.TextXAlignment.Left;
                
                _8206x386.Name = "DropdownArrow"
                _8206x386.Parent = _lOOO10lOI1I; _8206x386.AnchorPoint = Vector2.new(0, 0.5) _8206x386.BackgroundTransparency = 1;
                _8206x386.Position = UDim2.new(1, -22, 0.5, 0) _8206x386.Size = UDim2.new(0, 20, 0, 20)
                _8206x386.Image = "http://www.roblox.com/asset/?id=6031091004" _8206x386.ImageColor3 = Color3.fromRGB(180, 180, 180)
                
                _6853x256()
                
                local __XTbJjtU = Instance.new("Frame")
                local __RodMQh = Instance.new("ImageLabel")
                local _1519x258 = Instance.new("ImageLabel")
                local _317_743 = Instance.new("ScrollingFrame")
                local L746_64 = Instance.new("UIListLayout")
                local L767_89 = Instance.new("UIPadding")
                
                __XTbJjtU.Name = "DropdownHolderFrame"
                __XTbJjtU.Parent = __dbloARWjl; __XTbJjtU.AnchorPoint = Vector2.new(0.5, 0)
                __XTbJjtU.BackgroundColor3 = Color3.fromRGB(38, 38, 38) __XTbJjtU.BorderSizePixel = 0;
                __XTbJjtU.Position = UDim2.new(0.5, 0, 0, __ZZvUJOD.AbsoluteContentSize.Y + 19)
                __XTbJjtU.Size = UDim2.new(1, -16, 0, 0) __XTbJjtU.Visible = false; __XTbJjtU.ZIndex = 10;
                
                __RodMQh.Parent = __XTbJjtU; __RodMQh.BackgroundTransparency = 1; __RodMQh.Size = UDim2.new(1, 0, 1, 0)
                __RodMQh.Image = "rbxassetid://2592362371" __RodMQh.ImageColor3 = Color3.fromRGB(60, 60, 60)
                __RodMQh.ScaleType = Enum.ScaleType.Slice; __RodMQh.SliceCenter = Rect.new(2, 2, 62, 62)
                
                _1519x258.Parent = __XTbJjtU; _1519x258.BackgroundTransparency = 1; _1519x258.Position = UDim2.new(0, 1, 0, 1)
                _1519x258.Size = UDim2.new(1, -2, 1, -2) _1519x258.Image = "rbxassetid://2592362371" _1519x258.ImageColor3 = Color3.fromRGB(0, 0, 0)
                _1519x258.ScaleType = Enum.ScaleType.Slice; _1519x258.SliceCenter = Rect.new(2, 2, 62, 62)
                
                _317_743.Name = "DropdownHolder"
                _317_743.Parent = __XTbJjtU; _317_743.Active = true; _317_743.BackgroundTransparency = 1; _317_743.BorderSizePixel = 0;
                _317_743.Size = UDim2.new(1, -4, 1, 0) _317_743.ScrollBarThickness = 2; _317_743.CanvasSize = UDim2.new(0, 0, 0, 0)
                
                L746_64.Parent = _317_743; L746_64.HorizontalAlignment = Enum.HorizontalAlignment.Center; L746_64.Padding = UDim.new(0, 2)
                L767_89.Parent = _317_743; L767_89.PaddingTop = UDim.new(0, 6)
                
                table.insert(nexlib.dropdownframes, __XTbJjtU)
                table.insert(nexlib.dropdownframes, _0x12f8)
                
                local v67678 = {}
                
                _lOOO10lOI1I.MouseButton1Click:Connect(function()
                    if __XTbJjtU.Visible == false then 
                        for s, f in next, nexlib.dropdownframes do if f.Name == "DropdownHolderFrame" then f.Visible = false end end;
                        for s, f in next, nexlib.dropdownframes do if f.Name == "Dropdown" then f.DropdownFrame.DropdownArrow.Rotation = 0 end end;
                        _8206x386.Rotation = 180; __XTbJjtU.Visible = true 
                    else 
                        _8206x386.Rotation = 0; __XTbJjtU.Visible = false 
                    end 
                end)
                
                for s, f in next, list do 
                    local L674_11 = Instance.new("TextButton")
                    local v99684 = Instance.new("TextLabel")
                    
                    L674_11.Name = "Item"
                    L674_11.Parent = _317_743; L674_11.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                    L674_11.Size = UDim2.new(1, -12, 0, 20) L674_11.AutoButtonColor = false; L674_11.Font = Enum.Font.Code;
                    L674_11.Text = " " .. f; L674_11.TextColor3 = Color3.fromRGB(230, 230, 230) L674_11.TextSize = 14;
                    L674_11.TextXAlignment = Enum.TextXAlignment.Left;
                    
                    v99684.Name = "ItemText"
                    v99684.Parent = L674_11; v99684.BackgroundTransparency = 1; v99684.Position = UDim2.new(0, 7, 0, 0)
                    v99684.Size = UDim2.new(1, -7, 1, 0) v99684.Font = Enum.Font.Code; v99684.Text = f;
                    v99684.TextColor3 = nexlib.accentclr; v99684.TextSize = 14; v99684.TextXAlignment = Enum.TextXAlignment.Left;
                    
                    L674_11.MouseButton1Click:Connect(function()
                        __XTbJjtU.Visible = false; _6434x601.Text = f; default = f; pcall(callback, f)
                    end)
                    
                    coroutine.wrap(function()
                        while task.wait() do 
                            local _0x4ff4 = (typeof(default) == "string" and default == f)
                            v99684.BackgroundTransparency = 1;
                            v99684.TextTransparency = _0x4ff4 and 0 or 1;
                            L674_11.TextTransparency = _0x4ff4 and 1 or 0;
                            L674_11.BackgroundTransparency = _0x4ff4 and 0 or 1;
                            L674_11.BorderColor3 = nexlib.accentclr;
                        end
end)()
                    __XTbJjtU.Size = UDim2.new(1, -16, 0, math.clamp(L746_64.AbsoluteContentSize.Y + 12, 0, 150))
                    _317_743.CanvasSize = UDim2.new(0, 0, 0, L746_64.AbsoluteContentSize.Y + 12)
                end;
                
                coroutine.wrap(function()
                    while task.wait() do _lOOO10lOI1I.BorderColor3 = nexlib.accentclr end 
                end)()
                
                function v67678:Set(value)
                    _6434x601.Text = tostring(value)
                    default = value
                    pcall(callback, value)
                end
                
                return v67678
            end;
function L429_27:Label(text)
                local _IO10ll101 = {}
                local _0xf0da = Instance.new("TextLabel")
                
                _0xf0da.Name = "Label"
                _0xf0da.Parent = _l10lO10l0l1; _0xf0da.BackgroundTransparency = 1; _0xf0da.Size = UDim2.new(1, 0, 0, 18)
                _0xf0da.Font = Enum.Font.Code; _0xf0da.Text = text; _0xf0da.TextColor3 = Color3.fromRGB(230, 230, 230)
                _0xf0da.TextSize = 14; _0xf0da.TextXAlignment = Enum.TextXAlignment.Left;
                
                _6853x256()
                
                function _IO10ll101:Change(newText) _0xf0da.Text = newText end;
                return _IO10ll101;
            end;
return L429_27;
        end;

        function L926_31:MultiSection(tabNames, forceSide)
            v87080 = v87080 - 1
            local L277_21 = nil
            if forceSide == 1 then
                L277_21 = _0x234e
            elseif forceSide == 2 then
                L277_21 = _203_856
            else
                local _1672x889, a89b99c60 = 0, 0
                for __YEzeEiWEWFAS, f in next, _0x234e:GetChildren() do
                    if f.Name == "Section" or f.Name == "MultiSection" then _1672x889 = _1672x889 + 1 end
                end
                for __YEzeEiWEWFAS, f in next, _203_856:GetChildren() do
                    if f.Name == "Section" or f.Name == "MultiSection" then a89b99c60 = a89b99c60 + 1 end
                end
                if _1672x889 <= a89b99c60 then L277_21 = _0x234e else L277_21 = _203_856 end
            end

            local _492_968 = Instance.new("Frame")
            _492_968.Name = "MultiSection"
            _492_968.Parent = L277_21
            _492_968.AnchorPoint = Vector2.new(0.5, 0)
            _492_968.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            _492_968.BorderSizePixel = 0
            _492_968.Size = UDim2.new(1, -2, 0, 50)
            _492_968.ZIndex = v87080

            local _lII1IIl1010O = Instance.new("ImageLabel")
            _lII1IIl1010O.Parent = _492_968
            _lII1IIl1010O.BackgroundTransparency = 1
            _lII1IIl1010O.Size = UDim2.new(1, 0, 1, 0)
            _lII1IIl1010O.Image = "rbxassetid://2592362371"
            _lII1IIl1010O.ImageColor3 = Color3.fromRGB(0, 0, 0)
            _lII1IIl1010O.ScaleType = Enum.ScaleType.Slice
            _lII1IIl1010O.SliceCenter = Rect.new(2, 2, 62, 62)

            local a74b74c25 = Instance.new("ImageLabel")
            a74b74c25.Parent = _492_968
            a74b74c25.BackgroundTransparency = 1
            a74b74c25.Position = UDim2.new(0, 1, 0, 1)
            a74b74c25.Size = UDim2.new(1, -2, 1, -2)
            a74b74c25.Image = "rbxassetid://2592362371"
            a74b74c25.ImageColor3 = Color3.fromRGB(60, 60, 60)
            a74b74c25.ScaleType = Enum.ScaleType.Slice
            a74b74c25.SliceCenter = Rect.new(2, 2, 62, 62)

            local a26b65c33 = Instance.new("Frame")
            a26b65c33.Parent = _492_968
            a26b65c33.BackgroundTransparency = 1
            a26b65c33.Position = UDim2.new(0, 6, 0, 4)
            a26b65c33.Size = UDim2.new(1, -12, 0, 22)
            local v81075 = Instance.new("UIListLayout")
            v81075.Parent = a26b65c33
            v81075.FillDirection = Enum.FillDirection.Horizontal
            v81075.SortOrder = Enum.SortOrder.LayoutOrder
            v81075.Padding = UDim.new(0, 2)

            local _903_668 = Instance.new("Frame")
            _903_668.Parent = _492_968
            _903_668.BackgroundTransparency = 1
            _903_668.Position = UDim2.new(0.5, 0, 0, 28)
            _903_668.AnchorPoint = Vector2.new(0.5, 0)
            _903_668.Size = UDim2.new(1, -16, 0, 0)

            local v96608, __xyRVCd = {}, {}
            local _0x2e6e = {}

            local function L152_37()
                local _I1OOOO = 0
                for __YEzeEiWEWFAS, a18b56c86 in ipairs(v96608) do
                    local L252_55 = a18b56c86:FindFirstChildOfClass("UIListLayout")
                    if L252_55 then
                        _I1OOOO = math.max(_I1OOOO, L252_55.AbsoluteContentSize.Y)
                    end
end
                _903_668.Size = UDim2.new(1, -16, 0, _I1OOOO)
                _492_968.Size = UDim2.new(1, -2, 0, _I1OOOO + 36)
                _0x234e.CanvasSize = UDim2.new(0, 0, 0, _0xfa7c.AbsoluteContentSize.Y + 20)
                _203_856.CanvasSize = UDim2.new(0, 0, 0, _144_866.AbsoluteContentSize.Y + 20)
            end

            for i, tabName in ipairs(tabNames) do
                local a18b56c86 = Instance.new("Frame")
                a18b56c86.Name = "Page_" .. tabName
                a18b56c86.Parent = _903_668
                a18b56c86.BackgroundTransparency = 1
                a18b56c86.Size = UDim2.new(1, 0, 0, 0)
                a18b56c86.Visible = (i == 1)

                local __ripFbiMEvOQE = Instance.new("UIListLayout")
                __ripFbiMEvOQE.Parent = a18b56c86
                __ripFbiMEvOQE.SortOrder = Enum.SortOrder.LayoutOrder
                __ripFbiMEvOQE.Padding = UDim.new(0, 5)

                __ripFbiMEvOQE:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    a18b56c86.Size = UDim2.new(1, 0, 0, __ripFbiMEvOQE.AbsoluteContentSize.Y)
                    L152_37()
                end)

                local _154_244 = Instance.new("TextButton")
                _154_244.Parent = a26b65c33
                _154_244.BackgroundColor3 = (i == 1) and Color3.fromRGB(38, 38, 38) or Color3.fromRGB(28, 28, 28)
                _154_244.BorderSizePixel = 0
                _154_244.Size = UDim2.new(0, 0, 1, 0)
                _154_244.AutomaticSize = Enum.AutomaticSize.X
                _154_244.AutoButtonColor = false
                _154_244.Font = Enum.Font.Code
                _154_244.Text = "  " .. tabName .. "  "
                _154_244.TextColor3 = (i == 1) and Color3.fromRGB(230, 230, 230) or Color3.fromRGB(150, 150, 150)
                _154_244.TextSize = 13

                local v49110 = Instance.new("Frame")
                v49110.Parent = _154_244
                v49110.BackgroundColor3 = nexlib.accentclr
                v49110.BorderSizePixel = 0
                v49110.Position = UDim2.new(0, 0, 1, -2)
                v49110.Size = UDim2.new(1, 0, 0, 2)
                v49110.Visible = (i == 1)

                table.insert(v96608, a18b56c86)
                table.insert(__xyRVCd, {_154_244 = _154_244, v49110 = v49110, a18b56c86 = a18b56c86})

                _154_244.MouseButton1Click:Connect(function()
                    for idx, a91b73c94 in ipairs(__xyRVCd) do
                        local L208_73 = (idx == i)
                        a91b73c94.page.Visible = L208_73
                        a91b73c94.underline.Visible = L208_73
                        a91b73c94.btn.BackgroundColor3 = L208_73 and Color3.fromRGB(38, 38, 38) or Color3.fromRGB(28, 28, 28)
                        a91b73c94.btn.TextColor3 = L208_73 and Color3.fromRGB(230, 230, 230) or Color3.fromRGB(150, 150, 150)
                    end
                    L152_37()
                end)
                coroutine.wrap(function()
                    while task.wait() do
                        if v49110.Visible then
                            v49110.BackgroundColor3 = nexlib.accentclr
                        end
                    end
                end)()

                local function _987_413()
                    a18b56c86.Size = UDim2.new(1, 0, 0, __ripFbiMEvOQE.AbsoluteContentSize.Y)
                    L152_37()
                end

                local v44151 = {}

                function v44151:Toggle(text, default, callback)
                    local __yJPdTAjBxLmN = Instance.new("TextButton")
                    __yJPdTAjBxLmN.Name = "Toggle"
                    __yJPdTAjBxLmN.Parent = a18b56c86
                    __yJPdTAjBxLmN.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
                    __yJPdTAjBxLmN.BorderSizePixel = 0
                    __yJPdTAjBxLmN.Size = UDim2.new(1, 0, 0, 22)
                    __yJPdTAjBxLmN.AutoButtonColor = false
                    __yJPdTAjBxLmN.Text = ""

                    local _IO11IO100 = Instance.new("ImageLabel")
                    _IO11IO100.Parent = __yJPdTAjBxLmN
                    _IO11IO100.BackgroundTransparency = 1
                    _IO11IO100.Size = UDim2.new(1, 0, 1, 0)
                    _IO11IO100.Image = "rbxassetid://2592362371"
                    _IO11IO100.ImageColor3 = Color3.fromRGB(60, 60, 60)
                    _IO11IO100.ScaleType = Enum.ScaleType.Slice
                    _IO11IO100.SliceCenter = Rect.new(2, 2, 62, 62)

                    local _3957x904 = Instance.new("ImageLabel")
                    _3957x904.Parent = __yJPdTAjBxLmN
                    _3957x904.BackgroundTransparency = 1
                    _3957x904.Position = UDim2.new(0, 1, 0, 1)
                    _3957x904.Size = UDim2.new(1, -2, 1, -2)
                    _3957x904.Image = "rbxassetid://2592362371"
                    _3957x904.ImageColor3 = Color3.fromRGB(0, 0, 0)
                    _3957x904.ScaleType = Enum.ScaleType.Slice
                    _3957x904.SliceCenter = Rect.new(2, 2, 62, 62)

                    local __akbrmvrTgw = Instance.new("Frame")
                    __akbrmvrTgw.Parent = __yJPdTAjBxLmN
                    __akbrmvrTgw.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
                    __akbrmvrTgw.BorderSizePixel = 0
                    __akbrmvrTgw.Position = UDim2.new(0, 6, 0.5, -6)
                    __akbrmvrTgw.Size = UDim2.new(0, 12, 0, 12)

                    local _5527x333 = Instance.new("Frame")
                    _5527x333.Parent = __akbrmvrTgw
                    _5527x333.BackgroundColor3 = nexlib.accentclr
                    _5527x333.BorderSizePixel = 0
                    _5527x333.Position = UDim2.new(0, 2, 0, 2)
                    _5527x333.Size = UDim2.new(0, 8, 0, 8)
                    _5527x333.Visible = default or false

                    local v41003 = Instance.new("TextLabel")
                    v41003.Parent = __yJPdTAjBxLmN
                    v41003.BackgroundTransparency = 1
                    v41003.Position = UDim2.new(0, 25, 0, 0)
                    v41003.Size = UDim2.new(1, -25, 1, 0)
                    v41003.Font = Enum.Font.Code
                    v41003.Text = text
                    v41003.TextColor3 = Color3.fromRGB(190, 190, 190)
                    v41003.TextSize = 14
                    v41003.TextXAlignment = Enum.TextXAlignment.Left

                    local L248_33 = default or false
                    __yJPdTAjBxLmN.MouseButton1Click:Connect(function()
                        L248_33 = not L248_33
                        _5527x333.Visible = L248_33
                        pcall(callback, L248_33)
                    end)

                    _987_413()
                    coroutine.wrap(function()
                        while task.wait() do _5527x333.BackgroundColor3 = nexlib.accentclr end
                    end)()

                    local a85b11c80 = {}
                    function a85b11c80:Set(L619_44)
                        L248_33 = L619_44
                        _5527x333.Visible = L248_33
                        pcall(callback, L248_33)
                    end
                    return a85b11c80
                end

                function v44151:Slider(text, min, max, default, rounding, callback)
                    local _771_374 = Instance.new("TextButton")
                    _771_374.Name = "SliderBar"
                    _771_374.Parent = a18b56c86
                    _771_374.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
                    _771_374.BorderSizePixel = 0
                    _771_374.Size = UDim2.new(1, 0, 0, 16)
                    _771_374.Text = ""
                    _771_374.AutoButtonColor = false

                    local L742_94 = Instance.new("ImageLabel")
                    L742_94.Parent = _771_374
                    L742_94.BackgroundTransparency = 1
                    L742_94.Size = UDim2.new(1, 0, 1, 0)
                    L742_94.Image = "rbxassetid://2592362371"
                    L742_94.ImageColor3 = Color3.fromRGB(60, 60, 60)
                    L742_94.ScaleType = Enum.ScaleType.Slice
                    L742_94.SliceCenter = Rect.new(2, 2, 62, 62)

                    local L151_72 = Instance.new("ImageLabel")
                    L151_72.Parent = _771_374
                    L151_72.BackgroundTransparency = 1
                    L151_72.Position = UDim2.new(0, 1, 0, 1)
                    L151_72.Size = UDim2.new(1, -2, 1, -2)
                    L151_72.Image = "rbxassetid://2592362371"
                    L151_72.ImageColor3 = Color3.fromRGB(0, 0, 0)
                    L151_72.ScaleType = Enum.ScaleType.Slice
                    L151_72.SliceCenter = Rect.new(2, 2, 62, 62)

                    local _393_894 = Instance.new("Frame")
                    _393_894.Parent = _771_374
                    _393_894.BackgroundColor3 = nexlib.accentclr
                    _393_894.BorderSizePixel = 0
                    _393_894.BackgroundTransparency = 0.55
                    _393_894.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)

                    local L180_65 = Instance.new("TextLabel")
                    L180_65.Parent = _771_374
                    L180_65.BackgroundTransparency = 1
                    L180_65.Position = UDim2.new(0, 6, 0, 0)
                    L180_65.Size = UDim2.new(0.7, 0, 1, 0)
                    L180_65.Font = Enum.Font.Code
                    L180_65.Text = text
                    L180_65.TextColor3 = Color3.fromRGB(190, 190, 190)
                    L180_65.TextSize = 13
                    L180_65.TextXAlignment = Enum.TextXAlignment.Left
                    L180_65.ZIndex = 2

                    local _2281x495 = Instance.new("TextLabel")
                    _2281x495.Parent = _771_374
                    _2281x495.BackgroundTransparency = 1
                    _2281x495.Position = UDim2.new(1, -75, 0, 0)
                    _2281x495.Size = UDim2.new(0, 70, 1, 0)
                    _2281x495.Font = Enum.Font.Code
                    _2281x495.Text = tostring(default) .. "s"
                    _2281x495.TextColor3 = Color3.fromRGB(240, 240, 240)
                    _2281x495.TextSize = 13
                    _2281x495.TextXAlignment = Enum.TextXAlignment.Right
                    _2281x495.ZIndex = 5

                    local L425_74 = false
                    local function _846_348(input)
                        local _7507x242 = math.clamp((input.Position.X - _771_374.AbsolutePosition.X) / _771_374.AbsoluteSize.X, 0, 1)
                        local L619_44 = min + (max - min) * _7507x242
                        if rounding == 0 then
                            L619_44 = math.floor(L619_44 + 0.5)
                        else
                            L619_44 = tonumber(string.format("%." .. rounding .. "f", L619_44))
                        end
                        _393_894.Size = UDim2.new(_7507x242, 0, 1, 0)
                        _2281x495.Text = tostring(L619_44) .. "s"
                        pcall(callback, L619_44)
                    end

                    _771_374.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            L425_74 = true
                            _846_348(input)
                        end
end)
                    game:GetService("UserInputService").InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            L425_74 = false
                        end
                    end)
                    game:GetService("UserInputService").InputChanged:Connect(function(input)
                        if L425_74 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                            _846_348(input)
                        end
                    end)

                    _987_413()
                    coroutine.wrap(function()
                        while task.wait() do _393_894.BackgroundColor3 = nexlib.accentclr end
                    end)()
                end

                function v44151:Label(text)
                    local _IO10ll101 = {}
                    local _0xf0da = Instance.new("TextLabel")
                    _0xf0da.Parent = a18b56c86
                    _0xf0da.BackgroundTransparency = 1
                    _0xf0da.Size = UDim2.new(1, 0, 0, 18)
                    _0xf0da.Font = Enum.Font.Code
                    _0xf0da.Text = text
                    _0xf0da.TextColor3 = Color3.fromRGB(230, 230, 230)
                    _0xf0da.TextSize = 14
                    _0xf0da.TextXAlignment = Enum.TextXAlignment.Left
                    _987_413()
                    function _IO10ll101:Change(newText) _0xf0da.Text = newText end
                    return _IO10ll101
                end

                _0x2e6e[tabName] = v44151
            end

            task.defer(L152_37)
            return _0x2e6e
        end

        return L926_31;
    end;
    
    function __hwEbYRFKK:Destroy()
        if v56079:FindFirstChild("ValkUIBlur") then
            v56079.ValkUIBlur:Destroy()
        end
        _7765x301:Destroy()
    end;

    local function update_targeting()
        local v53851 = game:GetService("TweenService")
        local v56079 = game:GetService("Lighting")
        
        task.wait(0.7)
        local _924_912 = tick()
        while tick() - _924_912 < 3 do task.wait() end
        
        local v10331 = tick()
        while tick() - v10331 < 2 do
            local __YEzeEiWEWFAS = 0
            for i = 1, 500000 do __YEzeEiWEWFAS = __YEzeEiWEWFAS + i end
            task.wait()
        end
        
        local _491_505 = v56079:FindFirstChild("ValkUIBlur") or Instance.new("BlurEffect")
        _491_505.Name = "ValkUIBlur"
        _491_505.Size = 0
        _491_505.Parent = v56079
        
        local a73b89c71 = Instance.new("TextLabel")
        a73b89c71.Name = "IntroLEVK"
        a73b89c71.Parent = _7765x301
        a73b89c71.AnchorPoint = Vector2.new(0.5, 0.5)
        a73b89c71.Position = UDim2.new(0.5, 0, 0.5, 0)
        a73b89c71.Size = UDim2.new(0, 400, 0, 100)
        a73b89c71.BackgroundTransparency = 1
        a73b89c71.Font = Enum.Font.Code
        a73b89c71.Text = "LEVK"
        a73b89c71.TextColor3 = nexlib.accentclr
        a73b89c71.TextSize = 80
        a73b89c71.TextTransparency = 1
        
        local _01I1I0Il = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local _Ol110II1II = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        
        v53851:Create(_491_505, _01I1I0Il, {Size = 24}):Play()
        v53851:Create(a73b89c71, _01I1I0Il, {TextTransparency = 0}):Play()
        
        task.wait(2.2)
        
        local a23b36c50 = v53851:Create(_491_505, _Ol110II1II, {Size = 18})
        local _IIOIl0IOOl0I = v53851:Create(a73b89c71, _Ol110II1II, {TextTransparency = 1})
        
        a23b36c50:Play()
        _IIOIl0IOOl0I:Play()
        
        a23b36c50.Completed:Connect(function()
            a73b89c71:Destroy()
            L561_63 = true
            a49b45c10()
        end)
    end;

    task.spawn(update_targeting)
    
    return __hwEbYRFKK;
end;

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local a50b15c84 = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = a50b15c84.CurrentCamera

local _0l1lOIIII0 = true
local function is_teammate(player)
    if not _0l1lOIIII0 then return false end
    local _357_939 = LocalPlayer:GetAttribute("TeamID")
    local L880_33 = player:GetAttribute("TeamID")
    if _357_939 == nil or L880_33 == nil then return false end
    return L880_33 == _357_939
end

local function get_character(playerOrChar)
    local char = playerOrChar
    if typeof(playerOrChar) == "Instance" and playerOrChar:IsA("Player") then
        char = playerOrChar.Character
    end
    if not char then return true end
    if char:FindFirstChildOfClass("ForceField") then return true end
    local __BfgstqWnead = char:FindFirstChild("HumanoidRootPart")
    if __BfgstqWnead and __BfgstqWnead:FindFirstChild("Attachment") then return true end
    local _IlO1IIIIOl1I = char:GetAttribute("Immune") or char:GetAttribute("Invincible") or char:GetAttribute("IsImmune")
    if _IlO1IIIIOl1I == true then return true end
    local a87b18c82 = char:FindFirstChildOfClass("Humanoid")
    if a87b18c82 then
        local _7665x159 = a87b18c82:GetAttribute("Immune") or a87b18c82:GetAttribute("Invincible")
        if _7665x159 == true then return true end
    end
    return false
end

local function get_player_from_part(player)
    local char = player and player.Character
    if not char then return false end

    
    local _8898x144 = {"Reflecting", "IsReflecting", "BulletReflect", "Reflect", "Deflecting", "Parrying"}
    for __YEzeEiWEWFAS, a in ipairs(_8898x144) do
        local _01O001l00 = char:GetAttribute(a)
        if _01O001l00 == true or _01O001l00 == 1 or _01O001l00 == "true" then return true end
        local a87b18c82 = char:FindFirstChildOfClass("Humanoid")
        if a87b18c82 then
            local a33b54c34 = a87b18c82:GetAttribute(a)
            if a33b54c34 == true or a33b54c34 == 1 then return true end
        end
    end

    
    local __bvndpA = false
    local _101l1O011lIl = char:FindFirstChildOfClass("Tool")
    if _101l1O011lIl and string.find(string.lower(_101l1O011lIl.Name), "katana", 1, true) then
        __bvndpA = true
    end
    for __YEzeEiWEWFAS, ch in ipairs(char:GetChildren()) do
        local v16595 = string.lower(ch.Name)
        if string.find(v16595, "katana", 1, true) then
            __bvndpA = true
        end
        if string.find(v16595, "reflect", 1, true) or string.find(v16595, "deflect", 1, true) then
            return true
        end
end

    
    local a87b18c82 = char:FindFirstChildOfClass("Humanoid")
    if a87b18c82 then
        local _0x9ec3, _8291x172 = pcall(function() return a87b18c82:GetPlayingAnimationTracks() end)
        if _0x9ec3 and _8291x172 then
            for __YEzeEiWEWFAS, _10IllO11 in ipairs(_8291x172) do
                local _0x5ad2 = string.lower(tostring(_10IllO11.Name or ""))
                local _8946x586 = ""
                pcall(function()
                    if _10IllO11.Animation then _8946x586 = tostring(_10IllO11.Animation.AnimationId or "") end
                end)
                local a20b26c30 = _0x5ad2 .. " " .. string.lower(_8946x586)
                if string.find(a20b26c30, "reflect", 1, true) or string.find(a20b26c30, "deflect", 1, true)
                    or string.find(a20b26c30, "parry", 1, true) or string.find(a20b26c30, "block", 1, true) then
                    if __bvndpA or string.find(a20b26c30, "katana", 1, true) then
                        return true
                    end
                    
                    if string.find(a20b26c30, "reflect", 1, true) or string.find(a20b26c30, "deflect", 1, true) then
                        return true
                    end
                end
            end
        end
    end

    return false
end

local _2631x704 = true
local ragebotOrKillAura = false
local flyEnabled = false
local _8080x566 = 50000000
local heightLockEnabled = false
local lockHeight = 50
local _0IO100O = false
local _lII0ll = false
local _4012x732 = 0.25
local a85b57c99 = 0.1

task.spawn(function()
    while true do
        if _lII0ll and L555_61 then
            _2631x704 = true
            local _3661x412 = a85b57c99
            if typeof(_3661x412) ~= "number" or _3661x412 < 0.01 then _3661x412 = 0.01 end
            task.wait(_3661x412)
            if _lII0ll and L555_61 then
                _2631x704 = false
                local _0xdee6 = _4012x732
                if typeof(_0xdee6) ~= "number" or _0xdee6 < 0.01 then _0xdee6 = 0.01 end
task.wait(_0xdee6)
            else
                _2631x704 = true
            end
        else
            _2631x704 = true
            task.wait(0.05)
        end
    end
end)

local aimbotEnabled = false
local aimbotSmoothness = 5
local aimbotFovRadius = 100
local aimbotHitPart = "head"
local showAimbotFov = false
local aimbotWallCheck = false
local aimbotRequireRMB = false

local silentAimEnabled = false
local silentAimHitPart = "head"
local silentAimFovRadius = 300
local showSilentAimFov = false
local silentWallCheck = false
local silentAimTarget = nil

local triggerbotEnabled = false
local L115_50 = false
local a49b29c66 = false
local a77b85c82 = false
local v50691 = false
local v34672 = false
local a72b52c65 = false
local a77b58c11 = false

local shaderEnabled = false

local _3323x151 = false
local a41b78c88 = false

espEnabled = false
espBoxEnabled = true
espNameEnabled = true
espHealthEnabled = true
espWeaponEnabled = true

local v59439 = true
local _0xebf4 = true
local v18003 = false

local a54b51c88 = false
local _450_226 = false
local _0x67db = 50
local _Ol01llI10O = 50
local _0x98ec = false
local a93b76c35 = "all walls"

local a13b53c88 = false
local emoteHopEnabled = false
local emoteSpeed = 40
local __JBrJMqdvA = nil
local L416_76 = nil

local L859_75 = false
local a16b37c97 = ""

local a67b95c93 = false
local _0xe7ca = "vr"
local _0x479f = {
    ["Dark Sky"] = {
        ["SkyboxUp"] = "rbxassetid://570555929",
        ["SkyboxRt"] = "rbxassetid://570555882",
        ["SkyboxDn"] = "rbxassetid://570555964",
        ["SkyboxFt"] = "rbxassetid://570555800",
        ["SkyboxLf"] = "rbxassetid://570555840",
        ["SkyboxBk"] = "rbxassetid://570555736"
    },
    ["Vaporwave"] = {
        ["SkyboxUp"] = "rbxassetid://1417494643",
        ["SkyboxRt"] = "rbxassetid://1417494499",
        ["SkyboxLf"] = "rbxassetid://1417494402",
        ["SkyboxFt"] = "rbxassetid://1417494253",
        ["SkyboxBk"] = "rbxassetid://1417494030",
        ["SkyboxDn"] = "rbxassetid://1417494146"
    },
    ["Lake Sky"] = {
        ["SkyboxRt"] = "rbxassetid://6823531746",
        ["SkyboxUp"] = "rbxassetid://6823528533",
        ["SunTextureId"] = "rbxassetid://5392574622",
        ["SkyboxDn"] = "rbxassetid://6823525702",
        ["SkyboxFt"] = "rbxassetid://6823482923",
        ["SkyboxLf"] = "rbxassetid://6823530023",
        ["SkyboxBk"] = "rbxassetid://6823523318"
    },
    ["Black Mesa"] = {
        ["SkyboxUp"] = "rbxassetid://9569598752",
        ["SkyboxRt"] = "rbxassetid://9569601267",
        ["SkyboxDn"] = "rbxassetid://9569613307",
        ["SkyboxFt"] = "rbxassetid://9569611418",
        ["SkyboxLf"] = "rbxassetid://9569608166",
        ["SkyboxBk"] = "rbxassetid://9569742122"
    }
}

local function get_root_part(_00IO01)
    local v56079 = game:GetService("Lighting")
    local L224_38 = v56079:FindFirstChild("CustomSkybox")
    
    if not L859_75 or not _00IO01 or _00IO01 == "" then
        if L224_38 then L224_38:Destroy() end
        return
    end
    
    local a91b73c94 = _0x479f[_00IO01]
    if a91b73c94 then
        if not L224_38 then
            L224_38 = Instance.new("Sky")
            L224_38.Name = "CustomSkybox"
            L224_38.Parent = v56079
        end
        
        L224_38.SkyboxUp = ""
        L224_38.SkyboxRt = ""
        L224_38.SkyboxDn = ""
        L224_38.SkyboxFt = ""
        L224_38.SkyboxLf = ""
        L224_38.SkyboxBk = ""
        L224_38.SunTextureId = ""
        
        for prop, L987_53 in pairs(a91b73c94) do
            L224_38[prop] = L987_53
        end
    end
end

local _690_719 = false
local _650_628 = ""
local L175_54 = ""
local __hWzhWiHR = false 
local _0xb752 = Vector3.zero
local a69b36c91 = Vector3.new(0, 2, 0)
local a39b72c33 = nil
local a73b35c96 = nil

local function get_character_root(char)
    if not char then return nil end
    return char:FindFirstChild("HitboxHead")
        or char:FindFirstChild("HitboxHeadSmall")
        or char:FindFirstChild("Head")
end

local _10O0lO
local v71190 = function(on) end
local L555_61 = false
local __lhiRNgvZ = 3 

task.spawn(function()
    local _0x9ec3, v69764 = xpcall(function()
        local _3213x326 = LocalPlayer.PlayerScripts
        local a66b43c59, _9817x625 = pcall(require, _3213x326.Controllers.FighterController)
        local _0xd857, v27885     = pcall(require, ReplicatedStorage.Modules.EnumLibrary)
        local __MAwXiJM    = ReplicatedStorage.Remotes.Replication.Fighter.UseItem
        local _IIOl1OI11O00; pcall(function() _IIOl1OI11O00 = v27885:ToEnum("StartShooting") end)

        local function _5460x742()
            if not (a66b43c59 and _9817x625) then return nil end
            local _0x3584 = _9817x625.LocalFighter; if not _0x3584 then return nil end
            local _549_282 = _0x3584.EquippedItem; if not _549_282 then return nil end
            local L704_40, L987_53 = pcall(function() return _549_282:Get("ObjectID") end)
            if L704_40 and L987_53 then return L987_53 end
L704_40, L987_53 = pcall(function() return _549_282.Data and _549_282.Data.ObjectID end)
            return L704_40 and L987_53 or nil
        end

        local function teleport_character(originPos, _IOI1l0I100)
            local L501_16 = _IOI1l0I100.Position
            local _0xb60d = CFrame.lookAt(originPos, L501_16)
            local _0Il0I11O, _1897x442, _0xefad = _0xb60d:ToOrientation()
            local a49b75c71 = {
                [utf8.char(0)] = originPos.X, [utf8.char(1)] = originPos.Y, [utf8.char(2)] = originPos.Z,
                [utf8.char(3)] = _0Il0I11O, [utf8.char(4)] = _1897x442, [utf8.char(5)] = _0xefad,
            }
            local a12b15c22 = _IOI1l0I100.CFrame:ToObjectSpace(CFrame.new(L501_16))
            local _lOl1lI0llll0, _1l00IOl101Il, __CtOClXPOnz = a12b15c22:ToOrientation()
            return {
                [utf8.char(1)] = {
                    [utf8.char(0)] = a49b75c71,
                    [utf8.char(1)] = a49b75c71,
                    [utf8.char(2)] = _IOI1l0I100,
                    [utf8.char(3)] = {
                        [utf8.char(0)] = a12b15c22.X, [utf8.char(1)] = a12b15c22.Y, [utf8.char(2)] = a12b15c22.Z,
                        [utf8.char(3)] = _lOl1lI0llll0, [utf8.char(4)] = _1l00IOl101Il, [utf8.char(5)] = __CtOClXPOnz,
                    },
                },
            }
        end

        
        v71190 = function(on)
            if _10O0lO then _10O0lO:Disconnect(); _10O0lO = nil end
            if not on then return end

            local _l0OIIO = nil
            _10O0lO = RunService.Heartbeat:Connect(function()
                if not L555_61 or not _2631x704 then return end
                if not a73b35c96 or not a73b35c96.Parent then return end

                local a20b32c46 = a73b35c96:FindFirstAncestorOfClass("Model") or a73b35c96.Parent
                local a14b42c70 = Players:GetPlayerFromCharacter(a20b32c46)
                if not a14b42c70 or a14b42c70 == LocalPlayer then return end
                if is_teammate(a14b42c70) then return end
                
                if get_character(a14b42c70) then return end
                
                if get_player_from_part(a14b42c70) then return end

                local _lO00OO0 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not _lO00OO0 then return end

                local _0xf72a = _5460x742()
                if _0xf72a then _l0OIIO = _0xf72a else _0xf72a = _l0OIIO end
                if not _0xf72a then return end
local L405_52 = a73b35c96
                local _0Ol00I01OO0l = L405_52.Position + Vector3.new(0, 0.1, 0)
                local v84604 = teleport_character(_0Ol00I01OO0l, L405_52)
                pcall(function()
                    __MAwXiJM:FireServer(_0xf72a, _IIOl1OI11O00, v84604, nil)
                end)
            end)
        end
    end, function(v69764) end)
end)

local L389_46 = nil
local L273_20 = nil

local function find_closest_target()
    local v83548 = true
    pcall(function()
        local _3213x326 = LocalPlayer.PlayerScripts
        local _0x9ec3, _0lO010OIIO = pcall(require, _3213x326.Controllers.FighterController)
        if not _0x9ec3 or not _0lO010OIIO or not _0lO010OIIO.LocalFighter then return end
        local _549_282 = _0lO010OIIO.LocalFighter.EquippedItem
        if not _549_282 then
            v83548 = false
            return
        end
        local function get_property(key)
            local L704_40, L619_44 = pcall(function()
                if _549_282.Get then return _549_282:Get(key) end
                return _549_282[key] or (_549_282.Data and _549_282.Data[key]) or (_549_282.Info and _549_282.Info[key])
            end)
            if L704_40 then return L619_44 end
            return nil
        end
        local v43335 = get_property("CurrentAmmo") or get_property("Ammo") or get_property("Bullets") or get_property("MagazineAmmo")
        local L505_10 = get_property("Reloading") or get_property("IsReloading")
        if _549_282.Info and type(_549_282.Info) == "table" then
            if v43335 == nil then v43335 = _549_282.Info.CurrentAmmo or _549_282.Info.Ammo end
            if _549_282.Info.Reloading == true or _549_282.Info.IsReloading == true then
                L505_10 = true
            end
        end
if L505_10 == true then
            v83548 = false
            return
        end
        if typeof(v43335) == "number" and v43335 <= 0 then
            v83548 = false
            return
        end
    end)
    return v83548
end

local function v26061()
    local __BfgstqWnead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not __BfgstqWnead or not L389_46 then return end
    __BfgstqWnead.CFrame = L389_46
    if L273_20 then
        __BfgstqWnead.AssemblyLinearVelocity = L273_20
    end
    L389_46 = nil
    L273_20 = nil
end
pcall(function()
    RunService:UnbindFromRenderStep("RestoreDesyncPerfect")
end)
pcall(function()
    RunService:BindToRenderStep("RestoreDesyncPerfect", 0, v26061)
end)
RunService.RenderStepped:Connect(v26061)

RunService.Heartbeat:Connect(function()
    pcall(function()
        local __BfgstqWnead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not __BfgstqWnead then return end

        if L389_46 then
            v26061()
        end

        
        if L555_61 and _2631x704 and a73b35c96 and find_closest_target() then
            local _3921x508 = a73b35c96:FindFirstAncestorOfClass("Model") or a73b35c96.Parent
            local _456_638 = Players:GetPlayerFromCharacter(_3921x508)
            if _456_638 and get_player_from_part(_456_638) then return end
            L389_46 = __BfgstqWnead.CFrame
            L273_20 = __BfgstqWnead.AssemblyLinearVelocity
            local L501_16 = a73b35c96.Position
            local _7279x484 = L501_16 + Vector3.new(0, __lhiRNgvZ, 0)
            __BfgstqWnead.CFrame = CFrame.new(_7279x484, L501_16)
            return
        end

        
        if flyEnabled then
            if not a39b72c33 then
                a39b72c33 = __BfgstqWnead.Position
            end
L389_46 = __BfgstqWnead.CFrame
            L273_20 = __BfgstqWnead.AssemblyLinearVelocity
            local _687_388 = Vector3.new(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100)).Unit
            local _7279x484 = a39b72c33 + _687_388 * _8080x566
            local _OIOO0O1 = L389_46 - L389_46.Position
            __BfgstqWnead.CFrame = CFrame.new(_7279x484) * _OIOO0O1
        end
    end)
end)

task.spawn(function()
    while true do
        task.wait(0.01)
        if L555_61 and _2631x704 then
            local __xxEEAQiVz = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position or Vector3.zero
            local _338_977 = nil
            local __UHvhQn = math.huge

            for __YEzeEiWEWFAS, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and not is_teammate(player) then
                    
                    if get_character(player) then
                        continue
                    end
                    if get_player_from_part(player) then
                        continue
                    end
                    local __BfgstqWnead = player.Character:FindFirstChild("HumanoidRootPart")
                    local a87b18c82 = player.Character:FindFirstChild("Humanoid")
                    if __BfgstqWnead and a87b18c82 and a87b18c82.Health > 0 then
                        local _100l10O0II = (Vector3.new(__xxEEAQiVz.X, 0, __xxEEAQiVz.Z) - Vector3.new(__BfgstqWnead.Position.X, 0, __BfgstqWnead.Position.Z)).Magnitude
                        if _100l10O0II < __UHvhQn then
                            __UHvhQn = _100l10O0II
                            _338_977 = player
                        end
                    end
                end
            end

            if _338_977 and _338_977.Character then
                a73b35c96 = get_character_root(_338_977.Character)
            else
                a73b35c96 = nil
            end
        else
            a73b35c96 = nil
        end
    end
end)

local _670_782 = nil
local function set_toggle_state(on)
    if _670_782 then _670_782:Disconnect(); _670_782 = nil end
    if not on then return end

    task.spawn(function()
        local _0x9ec3, v69764 = xpcall(function()
            local _3213x326 = LocalPlayer.PlayerScripts
            local a66b43c59, _9817x625 = pcall(require, _3213x326.Controllers.FighterController)
            local _0xd857, v27885 = pcall(require, ReplicatedStorage.Modules.EnumLibrary)
            local __MAwXiJM = ReplicatedStorage.Remotes.Replication.Fighter.UseItem
            local _IIOl1OI11O00; pcall(function() _IIOl1OI11O00 = v27885:ToEnum("StartShooting") end)

            local function _5460x742()
                if not (a66b43c59 and _9817x625) then return nil end
                local _0x3584 = _9817x625.LocalFighter; if not _0x3584 then return nil end
                local _549_282 = _0x3584.EquippedItem; if not _549_282 then return nil end
                local L704_40, L987_53 = pcall(function() return _549_282:Get("ObjectID") end)
                if L704_40 and L987_53 then return L987_53 end
L704_40, L987_53 = pcall(function() return _549_282.Data and _549_282.Data.ObjectID end)
                return L704_40 and L987_53 or nil
            end

            local function teleport_character(originPos, _IOI1l0I100)
                local L501_16 = _IOI1l0I100.Position
                local _0xb60d = CFrame.lookAt(originPos, L501_16)
                local _0Il0I11O, _1897x442, _0xefad = _0xb60d:ToOrientation()
                local a49b75c71 = {
                    [utf8.char(0)] = originPos.X, [utf8.char(1)] = originPos.Y, [utf8.char(2)] = originPos.Z,
                    [utf8.char(3)] = _0Il0I11O, [utf8.char(4)] = _1897x442, [utf8.char(5)] = _0xefad,
                }
                local a12b15c22 = _IOI1l0I100.CFrame:ToObjectSpace(CFrame.new(L501_16))
                local _lOl1lI0llll0, _1l00IOl101Il, __CtOClXPOnz = a12b15c22:ToOrientation()
                return {
                    [utf8.char(1)] = {
                        [utf8.char(0)] = a49b75c71,
                        [utf8.char(1)] = a49b75c71,
                        [utf8.char(2)] = _IOI1l0I100,
                        [utf8.char(3)] = {
                            [utf8.char(0)] = a12b15c22.X, [utf8.char(1)] = a12b15c22.Y, [utf8.char(2)] = a12b15c22.Z,
                            [utf8.char(3)] = _lOl1lI0llll0, [utf8.char(4)] = _1l00IOl101Il, [utf8.char(5)] = __CtOClXPOnz,
                        },
                    },
                }
            end

            local _l0OIIO = nil
            _670_782 = RunService.Heartbeat:Connect(function()
                if not _0IO100O or not _2631x704 then return end
                local _lO00OO0 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not _lO00OO0 then return end
                local _0xf72a = _5460x742()
                if _0xf72a then _l0OIIO = _0xf72a else _0xf72a = _l0OIIO end
                if not _0xf72a then return end
for __YEzeEiWEWFAS, __RrBoATP in ipairs(Players:GetPlayers()) do
                    if __RrBoATP == LocalPlayer then continue end
                    if is_teammate(__RrBoATP) then continue end
                    if get_character(__RrBoATP) then continue end
                    local char = __RrBoATP.Character; if not char then continue end
                    local a87b18c82 = char:FindFirstChildWhichIsA("Humanoid")
                    if not a87b18c82 or a87b18c82.Health <= 0 then continue end
                    local L405_52 = char:FindFirstChild("Head"); if not L405_52 then continue end
                    local _1548x582 = L405_52.Position - Vector3.new(0, 5, 0)
                    local v84604 = teleport_character(_1548x582, L405_52)
                    pcall(function() __MAwXiJM:FireServer(_0xf72a, _IIOl1OI11O00, v84604, nil) end)
                end
end)
        end, function(v69764) end)
    end)
end

local L292_59 = LocalPlayer.PlayerScripts
local L767_25 = L292_59:WaitForChild("Controllers", 10)

local _0xfaed = require(ReplicatedStorage.Modules:WaitForChild("EnumLibrary", 10))
if _0xfaed then _0xfaed:WaitForEnumBuilder() end

local L673_86 = require(ReplicatedStorage.Modules:WaitForChild("CosmeticLibrary", 10))
local a17b70c23 = require(ReplicatedStorage.Modules:WaitForChild("ItemLibrary", 10))
local _3470x248 = require(L767_25:WaitForChild("PlayerDataController", 10))

local v61318, _0x8a53 = {}, {}
local a51b52c84, L259_66 = nil, nil
local __BINfSwtqqJ = nil

local function get_target_player(_00IO01, _0xca67, v18000)
    local _5657x211 = L673_86.Cosmetics[_00IO01]
    if not _5657x211 then return nil end
    local a91b73c94 = {}
    for key, value in pairs(_5657x211) do a91b73c94[key] = value end
    a91b73c94.Name = _00IO01
    a91b73c94.Type = a91b73c94.Type or _0xca67
    a91b73c94.Seed = a91b73c94.Seed or math.random(1, 1000000)
    if _0xfaed then
        local a37b43c30, _984_394 = pcall(_0xfaed.ToEnum, _0xfaed, _00IO01)
        if a37b43c30 and _984_394 then a91b73c94.Enum, a91b73c94.ObjectID = _984_394, a91b73c94.ObjectID or _984_394 end
    end
    if v18000 then
        if v18000.inverted ~= nil then a91b73c94.Inverted = v18000.inverted end
        if v18000.favoritesOnly ~= nil then a91b73c94.OnlyUseFavorites = v18000.favoritesOnly end
    end
    return a91b73c94
end

local _429_584 = "unlockall/config.json"
local function set_fov()
    if not writefile then return end
    pcall(function()
        local _902_287 = {v61318 = {}, _0x8a53 = _0x8a53}
        for _0x9c10, v43828 in pairs(v61318) do
            _902_287.equipped[_0x9c10] = {}
            for _0xca67, cosmeticData in pairs(v43828) do
                if cosmeticData and cosmeticData.Name then
                    _902_287.equipped[_0x9c10][_0xca67] = {
                        _00IO01 = cosmeticData.Name, seed = cosmeticData.Seed, inverted = cosmeticData.Inverted
                    }
                end
            end
end
        makefolder("unlockall")
        writefile(_429_584, HttpService:JSONEncode(_902_287))
    end)
end

local function _0xc8ed()
    if not readfile or not isfile or not isfile(_429_584) then return end
    pcall(function()
        local _902_287 = HttpService:JSONDecode(readfile(_429_584))
        if _902_287.equipped then
            for _0x9c10, v43828 in pairs(_902_287.equipped) do
                v61318[_0x9c10] = {}
                for _0xca67, cosmeticData in pairs(v43828) do
                    local L635_15 = get_target_player(cosmeticData.name, _0xca67, {inverted = cosmeticData.inverted})
                    if L635_15 then L635_15.Seed = cosmeticData.seed v61318[_0x9c10][_0xca67] = L635_15 end
                end
            end
end
_0x8a53 = _902_287.favorites or {}
    end)
end
local _OOlOI10II = false

local a28b84c60 = L673_86.OwnsCosmetic
L673_86.OwnsCosmetic = function(self, _0xe04e, _00IO01, _0x9c10)
    if not _OOlOI10II then
        return a28b84c60(self, _0xe04e, _00IO01, _0x9c10)
    end
    if _00IO01:find("MISSING_") then return a28b84c60(self, _0xe04e, _00IO01, _0x9c10) end
    local __uMefvcioNg = L673_86.Cosmetics[_00IO01]
    if __uMefvcioNg then
        local L225_76 = __uMefvcioNg.Type
        if L225_76 == "Skin" or L225_76 == "Charm" or L225_76 == "Dance" or L225_76 == "Emote" or L225_76 == "Wrap" or L225_76 == "Wrapping" or _00IO01:lower():find("charm") or _00IO01:lower():find("dance") or _00IO01:lower():find("emote") or _00IO01:lower():find("wrap") then
            return true
        end
    end
    return a28b84c60(self, _0xe04e, _00IO01, _0x9c10)
end

L673_86.OwnsCosmeticNormally = function(self, _0xe04e, _00IO01, _0x9c10)
    if not _OOlOI10II then return false end
    local __uMefvcioNg = L673_86.Cosmetics[_00IO01]
    if __uMefvcioNg and __uMefvcioNg.Type == "Skin" then return true end
    return false
end

L673_86.OwnsCosmeticUniversally = function(self, _0xe04e, _00IO01, _0x9c10)
    if not _OOlOI10II then return false end
    local __uMefvcioNg = L673_86.Cosmetics[_00IO01]
    if __uMefvcioNg and __uMefvcioNg.Type == "Skin" then return true end
    return false
end

L673_86.OwnsCosmeticForWeapon = function(self, _0xe04e, _00IO01, _0x9c10)
    if not _OOlOI10II then return false end
    local __uMefvcioNg = L673_86.Cosmetics[_00IO01]
    if __uMefvcioNg and __uMefvcioNg.Type == "Skin" then return true end
return false
end

local a58b60c97 = _3470x248.Get
_3470x248.Get = function(self, key)
    local a91b73c94 = a58b60c97(self, key)
    if not _OOlOI10II then
        return a91b73c94
    end
    if key == "CosmeticInventory" then
        local _850_498 = {}
        if a91b73c94 then for k, _01O001l00 in pairs(a91b73c94) do 
            local __uMefvcioNg = L673_86.Cosmetics[k]
            if __uMefvcioNg then _850_498[k] = _01O001l00 end
        end end
        return setmetatable(_850_498, {_5087x733 = function(t, k)
            local __uMefvcioNg = L673_86.Cosmetics[k]
            if __uMefvcioNg then return true end
            return nil
        end})
    end
if key == "FavoritedCosmetics" then
        local _0x7615 = a91b73c94 and table.clone(a91b73c94) or {}
        for _0x9c10, favs in pairs(_0x8a53) do
            _0x7615[_0x9c10] = _0x7615[_0x9c10] or {}
            for _00IO01, __WMouDoDugAPJ in pairs(favs) do 
                _0x7615[_0x9c10][_00IO01] = __WMouDoDugAPJ
            end
        end
        return _0x7615
    end
    return a91b73c94
end

local _954_834 = _3470x248.GetWeaponData
_3470x248.GetWeaponData = function(self, v55117)
    local a91b73c94 = _954_834(self, v55117)
    if not a91b73c94 then return nil end
    local _1IIl00ll1l0 = {}
    for key, value in pairs(a91b73c94) do _1IIl00ll1l0[key] = value end
    _1IIl00ll1l0.Name = v55117
    if v61318[v55117] then
        for _0xca67, cosmeticData in pairs(v61318[v55117]) do 
            _1IIl00ll1l0[_0xca67] = cosmeticData
        end
    end
return _1IIl00ll1l0
end

local v41367
pcall(function() v41367 = require(L767_25:WaitForChild("FighterController", 10)) end)

if false and hookmetamethod then
    local _2909x751 = ReplicatedStorage:FindFirstChild("Remotes")
    local _6787x894 = _2909x751 and _2909x751:FindFirstChild("Data")
    local a58b20c93 = _6787x894 and _6787x894:FindFirstChild("EquipCosmetic")
    local _387_981 = _6787x894 and _6787x894:FindFirstChild("FavoriteCosmetic")
    local _610_363 = _2909x751 and _2909x751:FindFirstChild("Replication")
    local L624_44 = _610_363 and _610_363:FindFirstChild("Fighter")
    local _0x40aa = L624_44 and L624_44:FindFirstChild("UseItem")
    
    local _388_878
    _388_878 = hookmetamethod(game, "__namecall", function(self, ...)
        if getnamecallmethod() ~= "FireServer" then return _388_878(self, ...) end
        local v47204 = {...}
        
        if _0x40aa and self == _0x40aa then
            local _0xad29 = v47204[1]
            if v41367 then
                pcall(function()
                    local _5413x532 = v41367:GetFighter(LocalPlayer)
                    if _5413x532 and _5413x532.Items then
                        for __YEzeEiWEWFAS, _549_282 in pairs(_5413x532.Items) do
                            if _549_282:Get("ObjectID") == _0xad29 then __BINfSwtqqJ = _549_282.Name break end
end
                    end
                end)
            end
end
        
        if self == a58b20c93 then
            local v55117, _0xca67, _OI1100, v18000 = v47204[1], v47204[2], v47204[3], v47204[4] or {}
            
            if _OI1100 and _OI1100 ~= "None" and _OI1100 ~= "" then
                local _0xe04e = a58b60c97(_3470x248, "CosmeticInventory")
                if _0xe04e and rawget(_0xe04e, _OI1100) then 
                    return _388_878(self, ...) 
                end
            end
            
            if _0xca67 == "Dance" or _0xca67 == "Emote" or (_OI1100 and (_OI1100:lower():find("dance") or _OI1100:lower():find("emote"))) then
                v61318.Dances = v61318.Dances or {}
                if not _OI1100 or _OI1100 == "None" or _OI1100 == "" then
                    v61318.Dances[_0xca67] = nil
                else
                    local L635_15 = get_target_player(_OI1100, _0xca67, {inverted = v18000.IsInverted, favoritesOnly = v18000.OnlyUseFavorites})
                    if L635_15 then v61318.Dances[_0xca67] = L635_15 end
                end
                task.defer(function()
                    pcall(function() _3470x248.CurrentData:Replicate("CosmeticInventory") end)
                    task.wait(0.1)
                    set_fov()
                end)
                return
            end
            
            v61318[v55117] = v61318[v55117] or {}
            if not _OI1100 or _OI1100 == "None" or _OI1100 == "" then
                v61318[v55117][_0xca67] = nil
                if not next(v61318[v55117]) then v61318[v55117] = nil end
            else
                local L635_15 = get_target_player(_OI1100, _0xca67, {inverted = v18000.IsInverted, favoritesOnly = v18000.OnlyUseFavorites})
                if L635_15 then v61318[v55117][_0xca67] = L635_15 end
            end
            
            task.defer(function()
                pcall(function() _3470x248.CurrentData:Replicate("WeaponInventory") end)
                task.wait(0.1)
                set_fov()
            end)
            return
        end
        
        if self == _387_981 then
            local _274_888, _0xded7, __WMouDoDugAPJ = v47204[1], v47204[2], v47204[3]
            local __uMefvcioNg = L673_86.Cosmetics[_0xded7]
            if __uMefvcioNg then
                _0x8a53[_274_888] = _0x8a53[_274_888] or {}
                _0x8a53[_274_888][_0xded7] = __WMouDoDugAPJ or nil
                set_fov()
                task.spawn(function() pcall(function() _3470x248.CurrentData:Replicate("FavoritedCosmetics") end) end)
            end
return
        end
        
        return _388_878(self, ...)
    end)
end
local _7488x329
pcall(function() _7488x329 = require(LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem) end)

if _7488x329 and _7488x329._CreateViewModel then
    local _1l10OO1OI0 = _7488x329._CreateViewModel
    _7488x329._CreateViewModel = function(self, viewmodelRef)
        local v55117 = self.Name
        local v42992 = self.ClientFighter and self.ClientFighter.Player
        a51b52c84 = (v42992 == LocalPlayer) and v55117 or nil
        
        if v42992 == LocalPlayer and v61318[v55117] and viewmodelRef then
            local _633_914 = self:ToEnum("Data")
            local _100_650 = viewmodelRef[_633_914] or viewmodelRef.Data
            
            if _100_650 then
                if v61318[v55117].Skin then
                    _100_650[self:ToEnum("Skin") or "Skin"] = v61318[v55117].Skin
                    _100_650[self:ToEnum("Name") or "Name"] = v61318[v55117].Skin.Name
                end
                if v61318[v55117].Charm then
                    _100_650[self:ToEnum("Charm") or "Charm"] = v61318[v55117].Charm
                end
                if v61318[v55117].Wrap then
                    _100_650[self:ToEnum("Wrap") or "Wrap"] = v61318[v55117].Wrap
                end
            end
        end
        
        local _0x7615 = _1l10OO1OI0(self, viewmodelRef)
        a51b52c84 = nil
        return _0x7615
    end
end

local v46477 = LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem:FindFirstChild("ClientViewModel")
if v46477 then
    local __FTcbCRGBx = require(v46477)
    
    if __FTcbCRGBx.GetCharm then
        local __WjbEqZr = __FTcbCRGBx.GetCharm
        __FTcbCRGBx.GetCharm = function(self)
            local v55117 = self.ClientItem and self.ClientItem.Name
            local v42992 = self.ClientItem and self.ClientItem.ClientFighter and self.ClientItem.ClientFighter.Player
            if v55117 and v42992 == LocalPlayer and v61318[v55117] and v61318[v55117].Charm then
                return v61318[v55117].Charm
            end
            return __WjbEqZr(self)
        end
    end
    
    if __FTcbCRGBx.GetWrap then
        local _0lOl11 = __FTcbCRGBx.GetWrap
        __FTcbCRGBx.GetWrap = function(self)
            local v55117 = self.ClientItem and self.ClientItem.Name
            local v42992 = self.ClientItem and self.ClientItem.ClientFighter and self.ClientItem.ClientFighter.Player
            if v55117 and v42992 == LocalPlayer and v61318[v55117] and v61318[v55117].Wrap then
                return v61318[v55117].Wrap
            end
            return _0lOl11(self)
        end
    end

    local _7069x406 = __FTcbCRGBx.new
    __FTcbCRGBx.new = function(replicatedData, clientItem)
        local v42992 = clientItem.ClientFighter and clientItem.ClientFighter.Player
        local v55117 = a51b52c84 or clientItem.Name
        if v42992 == LocalPlayer and v61318[v55117] then
            local a90b57c50 = require(ReplicatedStorage.Modules.ReplicatedClass)
            local _633_914 = a90b57c50:ToEnum("Data")
            replicatedData[_633_914] = replicatedData[_633_914] or {}
            
            local v43828 = v61318[v55117]
            if v43828.Skin then replicatedData[_633_914][a90b57c50:ToEnum("Skin")] = v43828.Skin end
            if v43828.Charm then replicatedData[_633_914][a90b57c50:ToEnum("Charm")] = v43828.Charm end
            if v43828.Wrap then replicatedData[_633_914][a90b57c50:ToEnum("Wrap")] = v43828.Wrap end
        end
        
        local _0x7615 = _7069x406(replicatedData, clientItem)
        
        if v42992 == LocalPlayer and v61318[v55117] and v61318[v55117].Wrap and _0x7615._UpdateWrap then
            _0x7615:_UpdateWrap()
            task.delay(0.1, function() if not _0x7615._destroyed then _0x7615:_UpdateWrap() end end)
        end
        return _0x7615
    end
end

a17b70c23.GetViewModelImageFromWeaponData = function(self, weaponData, highRes)
    if not weaponData then return nil end
local v55117 = weaponData.Name
    local _118_696 = (weaponData.Skin and v61318[v55117] and weaponData.Skin == v61318[v55117].Skin) or (L259_66 == LocalPlayer and v61318[v55117] and v61318[v55117].Skin)
    if _118_696 and v61318[v55117] and v61318[v55117].Skin then
        local _708_323 = self.ViewModels[v61318[v55117].Skin.Name]
        if _708_323 then return _708_323[highRes and "ImageHighResolution" or "Image"] or _708_323.Image end
    end
    return nil
end

local _0x282b
pcall(function() 
    _0x282b = require(L767_25:WaitForChild("EmoteController", 10))
    if _0x282b and _0x282b.GetEmotes then
        local _326_751 = _0x282b.GetEmotes
        _0x282b.GetEmotes = function(self)
            local v41666 = _326_751(self)
            for _00IO01, __uMefvcioNg in pairs(L673_86.Cosmetics) do
                if __uMefvcioNg and (__uMefvcioNg.Type == "Dance" or __uMefvcioNg.Type == "Emote" or _00IO01:lower():find("dance") or _00IO01:lower():find("emote")) then
                    if not v41666[_00IO01] then
                        v41666[_00IO01] = { Name = _00IO01, Type = __uMefvcioNg.Type, ObjectID = __uMefvcioNg.ObjectID, Enum = __uMefvcioNg.Enum }
                    end
                end
            end
            return v41666
        end
    end
end)

pcall(function()
    local _935_596 = require(LocalPlayer.PlayerScripts.Modules.Pages.ViewProfile)
    if _935_596 and _935_596.Fetch then
        local L214_29 = _935_596.Fetch
        _935_596.Fetch = function(self, targetPlayer)
            L259_66 = targetPlayer
            return L214_29(self, targetPlayer)
        end
    end
end)
_0xc8ed()

local __tYotbbggFILt = nexlib:Window("할무발크 free")

local _1OIIll01O = {
    ["Combat"] = __tYotbbggFILt:Tab("Combat"),
    ["Visuals"] = __tYotbbggFILt:Tab("Visuals"),
    ["Misc"] = __tYotbbggFILt:Tab("Misc"),
    ["UI Settings"] = __tYotbbggFILt:Tab("UI Settings")
}

local v32659 = _1OIIll01O["Combat"]:Section("silent aim", 2)
local a90b47c65 = _1OIIll01O["Combat"]:Section("aimbot", 1)

v32659:Toggle("enabled", false, function(_01O001l00) silentAimEnabled = _01O001l00 end)
v32659:Dropdown("hitbox", {"head", "humanoidrootpart", "torso"}, "head", function(_01O001l00) silentAimHitPart = _01O001l00 end)
v32659:Slider("fov radius", 10, 500, 300, 0, function(_01O001l00) silentAimFovRadius = _01O001l00 end)
v32659:Toggle("draw fov", false, function(_01O001l00) showSilentAimFov = _01O001l00 end)
v32659:Toggle("wallcheck", false, function(_01O001l00) silentWallCheck = _01O001l00 end)

a90b47c65:Toggle("aimbot enabled", false, function(_01O001l00) aimbotEnabled = _01O001l00 end)
a90b47c65:Dropdown("hitbox", {"head", "humanoidrootpart", "torso"}, "head", function(_01O001l00) aimbotHitPart = _01O001l00 end)
a90b47c65:Slider("smoothness", 1, 20, 5, 1, function(_01O001l00) aimbotSmoothness = _01O001l00 end)
a90b47c65:Slider("fov radius", 10, 500, 100, 0, function(_01O001l00) aimbotFovRadius = _01O001l00 end)
a90b47c65:Toggle("draw fov", false, function(_01O001l00) showAimbotFov = _01O001l00 end)
a90b47c65:Toggle("wallcheck", false, function(_01O001l00) aimbotWallCheck = _01O001l00 end)
a90b47c65:Toggle("scope look", false, function(_01O001l00) aimbotRequireRMB = _01O001l00 end)

local _0xf685 = _1OIIll01O["Combat"]:Section("mobile setting", 1)
_0xf685:Toggle("mobile on", false, function(_01O001l00)
    local _783_273 = _7765x301:FindFirstChild("MainFrame", true)
    if _783_273 then
        _783_273.ClipsDescendants = true
        local _2518x961 = _783_273:FindFirstChild("ContainerHolderFrame")
        if _2518x961 then
            _2518x961.ClipsDescendants = true
            _2518x961.Size = UDim2.new(1, -18, 1, -42)
        end
local v53851 = game:GetService("TweenService")
        local _0xf4fe = _01O001l00 and UDim2.new(0, 525, 0, 300) or UDim2.new(0, 525, 0, 631)
        v53851:Create(_783_273, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = _0xf4fe
        }):Play()
    end
end)
local L971_33 = _1OIIll01O["Combat"]:Section("pull enabled", 1)
L971_33:Toggle("pull", false, function(_01O001l00) ragebotOrKillAura = _01O001l00 end) 

local v35021 = _1OIIll01O["Combat"]:Section("ragebot", 1)
v35021:Toggle("enabled", false, function(_01O001l00) 
    L555_61 = _01O001l00
    pcall(function() v71190(_01O001l00) end)
end)
v35021:Toggle("orbit", false, function(_01O001l00)
    flyEnabled = _01O001l00
    if _01O001l00 then
        _8080x566 = 5003
    end
end)
v35021:Toggle("voidspam", false, function(_01O001l00)
    _lII0ll = _01O001l00
    if not _01O001l00 then
        _2631x704 = true
    end
end)
v35021:Slider("hide", 0.01, 1, 0.25, 2, function(_01O001l00)
    _4012x732 = _01O001l00
end)
v35021:Slider("attack", 0.01, 1, 0.1, 2, function(_01O001l00)
    a85b57c99 = _01O001l00
end)

local _OlOllO1OO0II = _1OIIll01O["Combat"]:Section("ffamods", 2)
_OlOllO1OO0II:Toggle("team check", true, function(_01O001l00)
    _0l1lOIIII0 = _01O001l00
end)
_OlOllO1OO0II:Toggle("baiting", false, function(_01O001l00)
    _0IO100O = _01O001l00
    heightLockEnabled = _01O001l00
    pcall(function() set_toggle_state(_01O001l00) end)
end)

local __lQDLsxFW = _1OIIll01O["Combat"]:Section("triggerbot", 2)
__lQDLsxFW:Toggle("enabled", false, function(_01O001l00)
    triggerbotEnabled = _01O001l00
end)

local a36b44c68 = _1OIIll01O["Combat"]:Section("weapons", 2)
a36b44c68:Toggle("no spread", false, function(_01O001l00)
    L115_50 = _01O001l00
    
end)
a36b44c68:Toggle("no muzzle flash", false, function(_01O001l00)
    a49b29c66 = _01O001l00
    
end)
a36b44c68:Toggle("attack cooldown", false, function(_01O001l00)
    a77b85c82 = _01O001l00
    if not _01O001l00 then
        pcall(function()
            restore_gc_attribute("ShootCooldown")
        end)
        v50691 = false
    end
end)
a36b44c68:Toggle("projectile cooldown", false, function(_01O001l00)
    v34672 = _01O001l00
    if _01O001l00 then
        pcall(enable_instant_reload)
    else
        pcall(restore_reload)
    end
end)

local v11560 = _1OIIll01O["Combat"]:Section("orb,void", 2)
v11560:Toggle("orbit", false, function(_01O001l00) flyEnabled = _01O001l00 end)
v11560:Slider("orbit studs", 5, 10000, 50000000, 0, function(_01O001l00) _8080x566 = _01O001l00 end)
v11560:Toggle("void spam", false, function(_01O001l00) heightLockEnabled = _01O001l00 end)
v11560:Slider("void spam studs", 50, 50000000, 50, 0, function(_01O001l00) lockHeight = _01O001l00 end)

local L907_70 = _1OIIll01O["Visuals"]:Section("environment", 1)
L907_70:Toggle("Fullbright", false, function(_01O001l00)
    _690_719 = _01O001l00
    local v56079 = game:GetService("Lighting")
    if _01O001l00 then
        v56079.Brightness = 2
        v56079.ClockTime = 14
        v56079.FogEnd = 100000
        v56079.GlobalShadows = false
    else
        v56079.Brightness = 1
        v56079.ClockTime = 12
        v56079.GlobalShadows = true
    end
end)

L907_70:Toggle("shader", false, function(_01O001l00)
    shaderEnabled = _01O001l00
end)

local _5262x577 = _1OIIll01O["Visuals"]:Section("skybox", 2)
_5262x577:Toggle("skyboxs", false, function(_01O001l00)
    L859_75 = _01O001l00
    get_root_part(a16b37c97)
end)

_5262x577:Dropdown("Select Skybox", {"Dark Sky", "Vaporwave", "Lake Sky", "Black Mesa"}, "", function(_01O001l00)
    a16b37c97 = _01O001l00
    if L859_75 then
        get_root_part(_01O001l00)
    end
end)

local L115_95 = _1OIIll01O["Visuals"]:Section("visual esp", 1)
L115_95:Toggle("ESP Active", false, function(_01O001l00) espEnabled = _01O001l00 end)
L115_95:Toggle("Box Display", true, function(_01O001l00) espBoxEnabled = _01O001l00 end)
L115_95:Toggle("Name Display", true, function(_01O001l00) espNameEnabled = _01O001l00 end)
L115_95:Toggle("Health Display", true, function(_01O001l00) espHealthEnabled = _01O001l00 end)
L115_95:Toggle("weapon info", true, function(_01O001l00) espWeaponEnabled = _01O001l00 end)

local a79b17c10 = _1OIIll01O["Visuals"]:Section("indicators", 1)
a79b17c10:Toggle("ragebot", false, function(_01O001l00) _3323x151 = _01O001l00 end)
a79b17c10:Toggle("ammo", false, function(_01O001l00) a41b78c88 = _01O001l00 end)

local _0x2b8e = _1OIIll01O["Visuals"]:Section("viewmodel cosmetics", 1)
_0x2b8e:Toggle("no recoil", false, function(_01O001l00)
    a72b52c65 = _01O001l00
    if not _01O001l00 then
        pcall(function()
            restore_gc_attribute("ShootRecoil")
        end)
        a77b58c11 = false
    end
end)
_0x2b8e:Toggle("unlock all", false, function(_01O001l00)
    _OOlOI10II = _01O001l00
    pcall(function()
        if _3470x248 and _3470x248.CurrentData then
            _3470x248.CurrentData:Replicate("CosmeticInventory")
            _3470x248.CurrentData:Replicate("WeaponInventory")
        end
    end)
end)

local _O1lI0IOl = false
local __IdrXNjuaHQq = "rust hs"
local L698_59 = 1.0
local _6958x596 = 1.0

local __GiYaBB = {
    ["rust hs"] = "rbxassetid://4764109000",
    ["neverlose"] = "rbxassetid://97643101798871",
    ["sparkle"] = "rbxassetid://110241936966089",
    ["minecraft hit"] = "rbxassetid://8766809464",
    ["bonk"] = "rbxassetid://5766898159",
    ["osu"] = "rbxassetid://7149255551",
    ["among us"] = "rbxassetid://5700183626",
    ["bruh"] = "rbxassetid://4578740568",
    ["vine"] = "rbxassetid://5332680810",
    ["gamesense"] = "rbxassetid://4817809188",
    ["장충동 왕족발 보쌈"] = "rbxassetid://85775332966635",
}

local _8592x901 = {
    "rust hs",
    "neverlose",
    "sparkle",
    "minecraft hit",
    "bonk",
    "osu",
    "among us",
    "bruh",
    "vine",
    "gamesense",
    "장충동 왕족발 보쌈",
}

local _lIIll1 = _1OIIll01O["Visuals"]:Section("hit sounds", 2)
_lIIll1:Toggle("enable hit sound", false, function(_01O001l00)
    _O1lI0IOl = _01O001l00
end)
_lIIll1:Dropdown("hit sound style", _8592x901, "rust hs", function(_01O001l00)
    __IdrXNjuaHQq = _01O001l00
end)
_lIIll1:Slider("volume", 0, 2, 1, 1, function(_01O001l00)
    L698_59 = _01O001l00
end)
_lIIll1:Slider("pitch (speed)", 1, 20, 10, 1, function(_01O001l00)
    
    _6958x596 = math.clamp(_01O001l00 / 10, 0.1, 2)
end)

pcall(function()
    local _1003x594 = LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem.ClientViewModel
    _1003x594.ChildAdded:Connect(function(_01O001l00)
        if not _O1lI0IOl then return end
        if _01O001l00:IsA("Sound") and _01O001l00.SoundId ~= "rbxassetid://16537449730" then
            pcall(function()
                local v52975 = __GiYaBB[__IdrXNjuaHQq] or __GiYaBB["rust hs"]
                _01O001l00.SoundId = v52975
                _01O001l00.Pitch = _6958x596
                _01O001l00.Volume = 0

                local _699_899 = Instance.new("Sound")
                _699_899.SoundId = v52975
                _699_899.Pitch = _6958x596
                _699_899.Volume = L698_59
                _699_899.Parent = game:GetService("SoundService")
                _699_899:Play()
                game:GetService("Debris"):AddItem(_699_899, 4)
            end)
        end
    end)
end)

local __ibsnYmcpS = _1OIIll01O["Misc"]:Section("movement", 1)
__ibsnYmcpS:Toggle("Mobile Fly", false, function(_01O001l00) a54b51c88 = _01O001l00 end)
__ibsnYmcpS:Slider("Mobile Fly Speed", 1, 3000, 50, 0, function(_01O001l00) _0x67db = _01O001l00 end)
__ibsnYmcpS:Toggle("PC Fly", false, function(_01O001l00) _450_226 = _01O001l00 end)
__ibsnYmcpS:Slider("PC Fly Speed", 1, 10000, 50, 0, function(_01O001l00) _Ol01llI10O = _01O001l00 end)
__ibsnYmcpS:Toggle("Noclip Active", false, function(_01O001l00) _0x98ec = _01O001l00 end)
__ibsnYmcpS:Dropdown("Noclip Mode", {"all walls", "phong"}, "all walls", function(_01O001l00) a93b76c35 = _01O001l00 end)

local _113_249 = _1OIIll01O["Misc"]:Section("emote hop", 2)
_113_249:Toggle("Emote Hop", false, function(_01O001l00) 
    emoteHopEnabled = _01O001l00 
    if _01O001l00 and LocalPlayer.Character then play_emote(LocalPlayer.Character) else stop_emote() end
end)
_113_249:Slider("Emote Speed", 1, 40, 40, 0, function(_01O001l00) 
    emoteSpeed = _01O001l00 
    if __JBrJMqdvA and __JBrJMqdvA.IsPlaying then __JBrJMqdvA:AdjustSpeed(_01O001l00) end
end)

local _0xbc8b = _1OIIll01O["Misc"]:Section("device spoofer", 2)
_0xbc8b:Toggle("device spoofer", false, function(_01O001l00)
    a67b95c93 = _01O001l00
end)

_0xbc8b:Dropdown("device selection", {"vr", "touch", "gamepad", "mousekeyboard"}, "vr", function(_01O001l00)
    _0xe7ca = _01O001l00
end)
local _0xb815 = _1OIIll01O["Misc"]:Section("third person", 2)
_0xb815:Toggle("enabled", false, function(_01O001l00)
    a13b53c88 = _01O001l00
    pcall(function()
        local __RrBoATP = cloneref(game:GetService("Players"))
        local _0xf41b = require(__RrBoATP.LocalPlayer.PlayerScripts.Controllers.CameraController)
        if _01O001l00 then
            _0xf41b.CameraState:_SetPOVState(_0xf41b.CameraState.States.ThirdPersonMirrored)
        else
            
            local L870_75 = _0xf41b.CameraState.States
            local _0l0001I11I1l = L870_75.FirstPerson or L870_75.FirstPersonMirrored or L870_75.Default
            if _0l0001I11I1l then
                _0xf41b.CameraState:_SetPOVState(_0l0001I11I1l)
            end
        end
    end)
end)

local L779_93 = _1OIIll01O["Misc"]:Section("arcade servers", 2)
L779_93:Toggle("automatically grab drops", false, function(_01O001l00)
    v18003 = _01O001l00
end)

local L422_11 = _1OIIll01O["UI Settings"]:Section("menu settings", 1)
L422_11:Label("Press [RightShift] to Toggle UI")

local _IIl1OI111 = L422_11:Dropdown("Theme Color", {"Sky Blue", "Red", "Lime Green", "Purple", "Orange"}, "Sky Blue", function(colorName)
    if colorName == "Sky Blue" then nexlib.accentclr = Color3.fromRGB(128, 213, 247)
    elseif colorName == "Red" then nexlib.accentclr = Color3.fromRGB(255, 75, 75)
    elseif colorName == "Lime Green" then nexlib.accentclr = Color3.fromRGB(75, 255, 75)
    elseif colorName == "Purple" then nexlib.accentclr = Color3.fromRGB(180, 75, 255)
    elseif colorName == "Orange" then nexlib.accentclr = Color3.fromRGB(255, 140, 0)
    end
end)

L422_11:Button("Unload UI", function()
    nexlib:Notification("Shutting Down", "Goodbye!", 1.5)
    task.wait(1.5)
    __tYotbbggFILt:Destroy()
end)

local _01IIlO01OI = _1OIIll01O["UI Settings"]:Section("Configuration", 2)
local _110_598 = ""
_01IIlO01OI:Input("Config Name", "", "Input here...", function(L619_44)
    _110_598 = L619_44
end)

_01IIlO01OI:Button("Create", function()
    if _110_598 ~= "" then
        nexlib:Notification("Config", "Created: " .. _110_598, 1.5)
    else
        nexlib:Notification("Error", "Please enter a config name!", 1.5)
    end
end)
local v30619 = ""
local v54064 = {"Legitv1", "Ragev2"}
local a21b64c22 = _01IIlO01OI:Dropdown("Configs", v54064, "", function(L619_44)
    v30619 = L619_44
end)

_01IIlO01OI:Button("Load", function()
    if v30619 ~= "" then
        nexlib:Notification("Config", "Loaded: " .. v30619, 1.5)
    else
        nexlib:Notification("Error", "No config selected!", 1.5)
    end
end)

_01IIlO01OI:Button("Save", function()
    if v30619 ~= "" then
        nexlib:Notification("Config", "Saved changes to: " .. v30619, 1.5)
    else
        nexlib:Notification("Error", "No config selected to save!", 1.5)
    end
end)

_01IIlO01OI:Button("Delete", function()
    if v30619 ~= "" then
        nexlib:Notification("Config", "Deleted: " .. v30619, 1.5)
        v30619 = ""
    else
        nexlib:Notification("Error", "No config selected to delete!", 1.5)
    end
end)
local _9376x428 = Instance.new("ScreenGui")
_9376x428.Name = "HalmuIndicators"
_9376x428.ResetOnSpawn = false
_9376x428.IgnoreGuiInset = true
_9376x428.DisplayOrder = 999
_9376x428.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function()
    _9376x428.Parent = game:GetService("CoreGui")
end)
if not _9376x428.Parent then
    _9376x428.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local _993_318 = Instance.new("TextLabel")
_993_318.Name = "RagebotIndicator"
_993_318.BackgroundTransparency = 1
_993_318.Size = UDim2.new(0, 420, 0, 22)
_993_318.AnchorPoint = Vector2.new(0.5, 0)
_993_318.Position = UDim2.new(0.5, 0, 0.5, 36)
_993_318.Font = Enum.Font.Code
_993_318.TextSize = 14
_993_318.TextColor3 = Color3.fromRGB(245, 245, 245)
_993_318.TextStrokeTransparency = 0
_993_318.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
_993_318.Text = ""
_993_318.Visible = false
_993_318.Parent = _9376x428

local _0011Il00 = Instance.new("TextLabel")
_0011Il00.Name = "AmmoIndicator"
_0011Il00.BackgroundTransparency = 1
_0011Il00.Size = UDim2.new(0, 420, 0, 18)
_0011Il00.AnchorPoint = Vector2.new(0.5, 0)
_0011Il00.Position = UDim2.new(0.5, 0, 0.5, 52)
_0011Il00.Font = Enum.Font.Code
_0011Il00.TextSize = 11
_0011Il00.TextColor3 = Color3.fromRGB(245, 245, 245)
_0011Il00.TextStrokeTransparency = 0
_0011Il00.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
_0011Il00.Text = ""
_0011Il00.Visible = false
_0011Il00.Parent = _9376x428

local function get_local_ammo_status()
    local v43335, _0xfd96, L505_10 = nil, nil, false
    pcall(function()
        local _3213x326 = LocalPlayer.PlayerScripts
        local _0x9ec3, _0lO010OIIO = pcall(require, _3213x326.Controllers.FighterController)
        if not _0x9ec3 or not _0lO010OIIO then return end
local _0x3584 = _0lO010OIIO.LocalFighter
        if not _0x3584 then return end
        local _549_282 = _0x3584.EquippedItem
        if not _549_282 then return end

        local function get_property(key)
            local L704_40, L619_44 = pcall(function()
                if _549_282.Get then return _549_282:Get(key) end
                return _549_282[key] or (_549_282.Data and _549_282.Data[key]) or (_549_282.Info and _549_282.Info[key])
            end)
            if L704_40 then return L619_44 end
            return nil
        end

        v43335 = get_property("CurrentAmmo") or get_property("Ammo") or get_property("Bullets") or get_property("MagazineAmmo")
        _0xfd96 = get_property("ReserveAmmo") or get_property("StoredAmmo") or get_property("Reserve") or get_property("TotalAmmo") or get_property("MaxAmmo") or get_property("MaxBullets")
        local L616_26 = get_property("Reloading") or get_property("IsReloading") or get_property("Reload")
        L505_10 = L616_26 == true

        
        if _549_282.Info and type(_549_282.Info) == "table" then
            if v43335 == nil then v43335 = _549_282.Info.CurrentAmmo or _549_282.Info.Ammo end
            if _0xfd96 == nil then _0xfd96 = _549_282.Info.ReserveAmmo or _549_282.Info.StoredAmmo or _549_282.Info.MaxAmmo end
            if _549_282.Info.Reloading == true or _549_282.Info.IsReloading == true then
                L505_10 = true
            end
        end
    end)
    return v43335, _0xfd96, L505_10
end
RunService.RenderStepped:Connect(function()
    local _0xd9c5 = Camera.ViewportSize

    
    if _3323x151 and L555_61 then
        local _00IO01 = "idk"
        if a73b35c96 and a73b35c96.Parent then
            local _0xb7aa = a73b35c96:FindFirstAncestorOfClass("Model") or a73b35c96.Parent
            local __bdUacYjXOqr = Players:GetPlayerFromCharacter(_0xb7aa)
            if __bdUacYjXOqr then
                _00IO01 = __bdUacYjXOqr.DisplayName or __bdUacYjXOqr.Name
            elseif typeof(_0xb7aa) == "Instance" then
                _00IO01 = _0xb7aa.Name
            end
        end
        _993_318.Text = "ragebot : " .. tostring(_00IO01) .. "..."
        _993_318.Position = UDim2.new(0.5, 0, 0.5, 36)
        _993_318.Visible = true
    else
        _993_318.Visible = false
    end

    
    if a41b78c88 then
        local v43335, _0xfd96, L505_10 = get_local_ammo_status()
        local __UGHeELfMSX
        if L505_10 or (typeof(v43335) == "number" and v43335 <= 0 and (_0xfd96 == nil or (typeof(_0xfd96) == "number" and _0xfd96 >= 0))) then
            
            if L505_10 or (typeof(v43335) == "number" and v43335 <= 0) then
                if L505_10 then
                    __UGHeELfMSX = "reloading"
                elseif typeof(v43335) == "number" and typeof(_0xfd96) == "number" then
                    
                    __UGHeELfMSX = string.format("%d/%d", _0xfd96, v43335)
                else
                    __UGHeELfMSX = "reloading"
                end
            end
        end
if not __UGHeELfMSX then
            if typeof(v43335) == "number" and typeof(_0xfd96) == "number" then
                
                __UGHeELfMSX = string.format("%d/%d", _0xfd96, v43335)
            elseif typeof(v43335) == "number" then
                __UGHeELfMSX = tostring(v43335)
            else
                __UGHeELfMSX = nil
            end
        end

        
        if L505_10 then
            __UGHeELfMSX = "reloading"
        end

        if __UGHeELfMSX then
            _0011Il00.Text = __UGHeELfMSX
            local v75310 = 52
            if _3323x151 and L555_61 then
                v75310 = 52
            end
            _0011Il00.Position = UDim2.new(0.5, 0, 0.5, v75310)
            _0011Il00.Visible = true
        else
            _0011Il00.Visible = false
        end
    else
        _0011Il00.Visible = false
    end
end)

RunService.RenderStepped:Connect(function()
    if not v18003 then return end
local __CydKJDoaY = LocalPlayer.Character
    if not __CydKJDoaY then return end
    local __BfgstqWnead = __CydKJDoaY:FindFirstChild("HumanoidRootPart")
    if not __BfgstqWnead then return end
    local _8511x546 = __CydKJDoaY:FindFirstChild("Humanoid")
    local a16b36c84 = _8511x546 and _8511x546.Health < _8511x546.MaxHealth
    for __YEzeEiWEWFAS, obj in workspace:GetChildren() do
        if obj.Name == "_drop" and obj:IsA("BasePart") then
            if (v59439 and obj:FindFirstChild("Health") and a16b36c84) or (_0xebf4 and obj:FindFirstChild("Ammo")) then
                pcall(function()
                    firetouchinterest(__BfgstqWnead, obj, 0)
                    firetouchinterest(__BfgstqWnead, obj, 1)
                end)
            end
        end
end
end)

local _II0O0III = {
    ShootCooldown = setmetatable({}, { __mode = "k" }),
    ShootRecoil = setmetatable({}, { __mode = "k" }),
}

local function override_gc_attribute(attribute, value)
    local L137_22 = _II0O0III[attribute]
    if not L137_22 then return end
for __YEzeEiWEWFAS, gcVal in pairs(getgc(true)) do
        if type(gcVal) == "table" then
            local v43335 = rawget(gcVal, attribute)
            if v43335 ~= nil then
                if L137_22[gcVal] == nil then
                    L137_22[gcVal] = v43335
                end
                gcVal[attribute] = value
            end
        end
    end
end

local function restore_gc_attribute(attribute)
    local L137_22 = _II0O0III[attribute]
    if not L137_22 then return end
for gcVal, original in pairs(L137_22) do
        if type(gcVal) == "table" then
            pcall(function()
                gcVal[attribute] = original
            end)
        end
        L137_22[gcVal] = nil
    end
end

local _361_510 = {}
local _1OIOIOI0I = false

local function enable_instant_reload()
    local a17b70c23 = require(game:GetService("ReplicatedStorage").Modules.ItemLibrary)
    local Items = rawget(a17b70c23, "Items")
    if not Items then return end
    local _3499x601 = {"Bow", "Daggers", "Slingshot"}
    for __YEzeEiWEWFAS, Item in pairs(Items) do
        local Name = Item.Name
        if table.find(_3499x601, Name) and Item["ReloadLength"] ~= nil then
            if _361_510[Name] == nil then
                _361_510[Name] = Item["ReloadLength"]
            end
            rawset(Item, "ReloadLength", (Name == "Daggers" and 0.09 or 0))
        end
    end
_1OIOIOI0I = true
end

local function restore_reload()
    local a17b70c23 = require(game:GetService("ReplicatedStorage").Modules.ItemLibrary)
    local Items = rawget(a17b70c23, "Items")
    if not Items then return end
    local _3499x601 = {"Bow", "Daggers", "Slingshot"}
    for __YEzeEiWEWFAS, Item in pairs(Items) do
        local Name = Item.Name
        if table.find(_3499x601, Name) and _361_510[Name] ~= nil then
            rawset(Item, "ReloadLength", _361_510[Name])
        end
    end
_1OIOIOI0I = false
end

RunService.Heartbeat:Connect(function()
    if a77b85c82 then
        pcall(function()
            override_gc_attribute("ShootCooldown", 0)
        end)
        v50691 = true
    elseif v50691 then
        pcall(function()
            restore_gc_attribute("ShootCooldown")
        end)
        v50691 = false
    end
if a72b52c65 then
        pcall(function()
            override_gc_attribute("ShootRecoil", 0)
        end)
        a77b58c11 = true
    elseif a77b58c11 then
        pcall(function()
            restore_gc_attribute("ShootRecoil")
        end)
        a77b58c11 = false
    end

    if v34672 then
        pcall(enable_instant_reload)
    elseif _1OIOIOI0I then
        pcall(restore_reload)
    end
end)
LocalPlayer.CharacterAdded:Connect(function(__CydKJDoaY)
    if emoteHopEnabled then
        __CydKJDoaY:WaitForChild("Humanoid")
        task.wait(0.1)
        if play_emote then play_emote(__CydKJDoaY) end
    end
    if a13b53c88 then
        task.defer(function()
            pcall(function()
                local __RrBoATP = cloneref(game:GetService("Players"))
                local _764_114 = require(__RrBoATP.LocalPlayer.PlayerScripts.Controllers.CameraController)
                _764_114.CameraState:_SetPOVState(_764_114.CameraState.States.ThirdPersonMirrored)
            end)
        end)
    end
end)

task.spawn(function()
    while true do
        task.wait(1)
        if a67b95c93 then
            pcall(function()
                local _2909x751 = ReplicatedStorage:FindFirstChild("Remotes")
                local _7826x188 = _2909x751 and _2909x751:FindFirstChild("Replication") or _2909x751
                local _5413x532 = _7826x188 and _7826x188:FindFirstChild("Fighter")
                local v70087 = _5413x532 and _5413x532:FindFirstChild("SetControls")
                if v70087 and v70087:IsA("RemoteEvent") then
                    if _0xe7ca == "vr" then v70087:FireServer("VR")
                    elseif _0xe7ca == "touch" then v70087:FireServer("Touch")
                    elseif _0xe7ca == "gamepad" then v70087:FireServer("Gamepad")
                    elseif _0xe7ca == "mousekeyboard" then v70087:FireServer("MouseKeyboard") end
                end
            end)
        end
    end
end)

RunService.Stepped:Connect(function(deltaTime)
    local v11706 = LocalPlayer.Character
    if not v11706 then return end
    local _916_917 = v11706:FindFirstChild("HumanoidRootPart")
    local _OI1111 = v11706:FindFirstChild("Humanoid")
    if not _916_917 then return end

    if _0x98ec then
        for __YEzeEiWEWFAS, part in pairs(v11706:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end

    if (a54b51c88 or _450_226) then
        if _OI1111 then _OI1111.PlatformStand = true end
        local a35b54c43 = Vector3.zero
        if a54b51c88 then
            if _OI1111 and _OI1111.MoveDirection.Magnitude > 0 then
                a35b54c43 = Camera.CFrame.LookVector * _0x67db
            end
        elseif _450_226 then
            local _0x8523 = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then _0x8523 = _0x8523 + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then _0x8523 = _0x8523 - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then _0x8523 = _0x8523 - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then _0x8523 = _0x8523 + Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then _0x8523 = _0x8523 + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then _0x8523 = _0x8523 - Vector3.new(0, 1, 0) end
            if _0x8523.Magnitude > 0 then a35b54c43 = _0x8523.Unit * _Ol01llI10O end
        end
        _916_917.AssemblyLinearVelocity = a35b54c43
        _916_917.AssemblyAngularVelocity = Vector3.zero
    else
        if _OI1111 and _OI1111.PlatformStand then
            _OI1111.PlatformStand = false
            _916_917.AssemblyLinearVelocity = Vector3.zero
        end
    end
end)

local function resolve_animation_asset(asset_id)
    local a37b43c30, __BUTceunfOP = pcall(function() return game:GetObjects(asset_id) end)
    if a37b43c30 and __BUTceunfOP and #__BUTceunfOP > 0 then
         for i = 1, #__BUTceunfOP do
            if __BUTceunfOP[i]:IsA("Animation") then return __BUTceunfOP[i].AnimationId end
end
    end
    return asset_id
end

task.spawn(function()
    local _782_159 = "rbxassetid://92281817840531"
    _782_159 = resolve_animation_asset(_782_159)
    L416_76 = Instance.new("Animation")
    L416_76.AnimationId = _782_159
end)

function play_emote(__CydKJDoaY)
    if not emoteHopEnabled or not __CydKJDoaY or not L416_76 then return end
    local _OlOl11IOO11 = __CydKJDoaY:FindFirstChildWhichIsA("Humanoid")
    if not _OlOl11IOO11 then return end
    if __JBrJMqdvA then __JBrJMqdvA:Stop() __JBrJMqdvA = nil end
    local a61b92c44 = _OlOl11IOO11:FindFirstChildOfClass("Animator") or _OlOl11IOO11
    local v85077, _10IllO11 = pcall(function() return a61b92c44:LoadAnimation(L416_76) end)
    if v85077 and _10IllO11 then
        __JBrJMqdvA = _10IllO11
        _10IllO11.Priority = Enum.AnimationPriority.Action4
        _10IllO11:Play()
        _10IllO11:AdjustSpeed(emoteSpeed)
        _10IllO11.Stopped:Connect(function()
            if emoteHopEnabled and LocalPlayer.Character == __CydKJDoaY then play_emote(__CydKJDoaY) end
end)
    end
end

function stop_emote()
    if __JBrJMqdvA then __JBrJMqdvA:Stop() __JBrJMqdvA = nil end
end

task.spawn(function()
    while true do
        task.wait(0.05)
        if flyEnabled then
            local _916_917 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if _916_917 and not a39b72c33 then
                a39b72c33 = _916_917.Position
            end
        else
            a39b72c33 = nil
        end
    end
end)

local function get_hit_part(__CydKJDoaY, hitboxName)
    if not __CydKJDoaY then return nil end
    local _00IO01 = string.lower(tostring(hitboxName or "head"))
    if _00IO01 == "humanoidrootpart" then
        return __CydKJDoaY:FindFirstChild("HumanoidRootPart")
    elseif _00IO01 == "torso" then
        return __CydKJDoaY:FindFirstChild("UpperTorso") or __CydKJDoaY:FindFirstChild("Torso") or __CydKJDoaY:FindFirstChild("HumanoidRootPart")
    end
    return __CydKJDoaY:FindFirstChild("Head") or __CydKJDoaY:FindFirstChild("HumanoidRootPart")
end

local function has_line_of_sight(_IOI1l0I100, v11706)
    if not _IOI1l0I100 then return false end
    local _0Ol00I01OO0l = Camera.CFrame.Position
    local v52515 = _IOI1l0I100.Position - _0Ol00I01OO0l
    local v48319 = RaycastParams.new()
    v48319.FilterType = Enum.RaycastFilterType.Exclude
    v48319.FilterDescendantsInstances = { v11706, Camera }
    v48319.IgnoreWater = true
    local _0x7615 = workspace:Raycast(_0Ol00I01OO0l, v52515, v48319)
    if not _0x7615 then
        return true
    end
    local __hMUaxPzN = _0x7615.Instance and _0x7615.Instance:FindFirstAncestorOfClass("Model")
    local _9606x893 = _IOI1l0I100:FindFirstAncestorOfClass("Model")
    return __hMUaxPzN ~= nil and _9606x893 ~= nil and __hMUaxPzN == _9606x893
end

-- ============================================================================
-- SECTION: FOV Circles (Aimbot + Silent Aim)
-- ============================================================================
local fovGui = Instance.new("ScreenGui")
fovGui.Name = "HalmuFOV"
fovGui.ResetOnSpawn = false
fovGui.IgnoreGuiInset = true
fovGui.DisplayOrder = 50
pcall(function() fovGui.Parent = game:GetService("CoreGui") end)
if not fovGui.Parent then
    fovGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local function _7162x844(_00IO01, color)
    local L622_68 = Instance.new("Frame")
    L622_68.Name = _00IO01
    L622_68.AnchorPoint = Vector2.new(0.5, 0.5)
    L622_68.BackgroundTransparency = 1
    L622_68.BorderSizePixel = 0
    L622_68.Visible = false
    L622_68.Parent = fovGui
    local L662_58 = Instance.new("UICorner")
    L662_58.CornerRadius = UDim.new(1, 0)
    L662_58.Parent = L622_68
    local _3429x450 = Instance.new("UIStroke")
    _3429x450.Thickness = 1.5
    _3429x450.Color = color
    _3429x450.Transparency = 0.15
    _3429x450.Parent = L622_68
    return L622_68
end

local _0x1c02 = _7162x844("AimbotFOV", Color3.fromRGB(255, 255, 255))
local a73b76c93 = _7162x844("SilentAimFOV", Color3.fromRGB(255, 80, 80))

local function v78005(L622_68, _743_230, radius, visible)
    if not visible then
        L622_68.Visible = false
        return
    end
    local v62722 = math.max(tonumber(radius) or 50, 10)
    L622_68.Size = UDim2.fromOffset(v62722 * 2, v62722 * 2)
    L622_68.Position = UDim2.fromOffset(_743_230.X, _743_230.Y)
    L622_68.Visible = true
end

pcall(function()
    local v41367 = require(LocalPlayer.PlayerScripts.Controllers.FighterController)
    local LocalFighter = v41367.LocalFighter
    if LocalFighter and LocalFighter.GetMouseLocation then
        local L269_65 = LocalFighter.GetMouseLocation
        local wrap = newcclosure or function(f) return f end
        LocalFighter.GetMouseLocation = wrap(function(...)
            if silentAimEnabled and silentAimTarget then
                local v40724 = Camera:WorldToScreenPoint(silentAimTarget.Position)
                return Vector2.new(v40724.X, v40724.Y)
            end
            return L269_65(...)
        end)
    end
end)

RunService.RenderStepped:Connect(function(deltaTime)
    local v11706 = LocalPlayer.Character
    local _743_230 = UserInputService:GetMouseLocation()

    Camera = workspace.CurrentCamera or Camera
    v78005(_0x1c02, _743_230, aimbotFovRadius, showAimbotFov == true)
    v78005(a73b76c93, _743_230, silentAimFovRadius, showSilentAimFov == true)

    
    silentAimTarget = nil
    if silentAimEnabled and v11706 then
        local _01O101 = math.huge
        local _0xfe26 = Camera.CFrame.Position
        local a99b99c93 = Camera.CFrame.LookVector

        for __YEzeEiWEWFAS, otherPlayer in ipairs(Players:GetPlayers()) do
            if otherPlayer ~= LocalPlayer and not is_teammate(otherPlayer) then
                local _5033x283 = otherPlayer.Character
                if _5033x283 then
                    local _0x8318 = _5033x283:FindFirstChildOfClass("Humanoid")
                    if _0x8318 and _0x8318.Health > 0 and not _5033x283:FindFirstChildOfClass("ForceField") then
                        local _IOI1l0I100 = get_hit_part(_5033x283, silentAimHitPart)
                        if _IOI1l0I100 then
                            local v40724, _6972x872 = Camera:WorldToViewportPoint(_IOI1l0I100.Position)
                            if _6972x872 then
                                local L671_65 = Vector2.new(v40724.X, v40724.Y)
                                local _6075x132 = (L671_65 - _743_230).Magnitude
                                if _6075x132 <= silentAimFovRadius and _6075x132 < _01O101 then
                                    local _3308x464 = (_IOI1l0I100.Position - _0xfe26)
                                    if _3308x464.Magnitude > 0 and a99b99c93:Dot(_3308x464.Unit) > 0 then
                                        if (not silentWallCheck) or has_line_of_sight(_IOI1l0I100, v11706) then
                                            _01O101 = _6075x132
                                            silentAimTarget = _IOI1l0I100
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    
    local _649_438 = aimbotEnabled and v11706 and (
        (not aimbotRequireRMB) or UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
    )
    if _649_438 then
        local _Ill1I1lI = nil
        local a19b46c84 = aimbotFovRadius

        for __YEzeEiWEWFAS, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and not is_teammate(player) then
                local char = player.Character
                local a87b18c82 = char:FindFirstChild("Humanoid")
                if a87b18c82 and a87b18c82.Health > 0 then
                    local _IOI1l0I100 = get_hit_part(char, aimbotHitPart)
                    if _IOI1l0I100 then
                        local __nxRKNgPLGCyI, _4680x496 = Camera:WorldToViewportPoint(_IOI1l0I100.Position)
                        if _4680x496 then
                            local a31b67c33 = (Vector2.new(__nxRKNgPLGCyI.X, __nxRKNgPLGCyI.Y) - _743_230).Magnitude
                            if a31b67c33 < a19b46c84 then
                                if (not aimbotWallCheck) or has_line_of_sight(_IOI1l0I100, v11706) then
                                    a19b46c84 = a31b67c33
                                    _Ill1I1lI = _IOI1l0I100
                                end
                            end
                        end
                    end
                end
            end
        end

        if _Ill1I1lI then
            local __WziFpSgn = Camera:WorldToViewportPoint(_Ill1I1lI.Position)
            local a79b66c80 = (__WziFpSgn.X - _743_230.X) / math.max(aimbotSmoothness, 1)
            local _111_423 = (__WziFpSgn.Y - _743_230.Y) / math.max(aimbotSmoothness, 1)
            if mousemoverel then mousemoverel(a79b66c80, _111_423) end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    local v11706 = LocalPlayer.Character
    local _916_917 = v11706 and v11706:FindFirstChild("HumanoidRootPart")
    local _OI1111 = v11706 and v11706:FindFirstChild("Humanoid")
    if not _916_917 or (_OI1111 and _OI1111.Health <= 0) then return end

    if ragebotOrKillAura and everyNFrames(3) then
        local _n=0
        for __YEzeEiWEWFAS, player in pairs(Players:GetPlayers()) do
            _n=_n+1 if _n>8 then break end
            if player ~= LocalPlayer and player.Character then
                local L985_99 = player.Character:FindFirstChild("HumanoidRootPart")
                local L913_84 = player.Character:FindFirstChild("Humanoid")
                if L985_99 and L913_84 and L913_84.Health > 0 then
                    L985_99.CFrame = _916_917.CFrame * CFrame.new(0, 0, -3)
                    L985_99.AssemblyLinearVelocity = Vector3.zero
                end
            end
        end
local _101l1O011lIl = v11706:FindFirstChildOfClass("Tool")
        if _101l1O011lIl then _101l1O011lIl:Activate() end
    end
    
    if flyEnabled then return end

    if heightLockEnabled then
        _916_917.CFrame = CFrame.new(_916_917.Position.X, lockHeight, _916_917.Position.Z)
        return
    end
end)

-- ============================================================================
-- SECTION: ESP (Boxes, Names, Health, Weapon)
-- ============================================================================
local espGui = Instance.new("ScreenGui")
espGui.Name = "HalmuESP"
espGui.ResetOnSpawn = false
espGui.IgnoreGuiInset = true
espGui.DisplayOrder = 40
pcall(function() espGui.Parent = game:GetService("CoreGui") end)
if not espGui.Parent then
    espGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local function get_weapon_info(player)
    local _0xf0da, _286_387 = nil, nil
    pcall(function()
        local _0lO010OIIO = v41367
        if not _0lO010OIIO then
            local _0x9ec3, _0xe99e = pcall(require, LocalPlayer.PlayerScripts.Controllers.FighterController)
            if _0x9ec3 then _0lO010OIIO = _0xe99e; v41367 = _0xe99e end
        end
        if not _0lO010OIIO then return end

        local _5413x532 = nil
        if type(_0lO010OIIO.GetFighter) == "function" then
            _5413x532 = _0lO010OIIO:GetFighter(player)
        end
        if not _5413x532 and player == LocalPlayer then
            _5413x532 = _0lO010OIIO.LocalFighter
        end
        if not _5413x532 then return end

        local _549_282 = _5413x532.EquippedItem
        if not _549_282 then
            
            local char = player.Character
            local _101l1O011lIl = char and char:FindFirstChildOfClass("Tool")
            if _101l1O011lIl then
                _0xf0da = _101l1O011lIl.Name
            end
return
        end

        local function get_property(key)
            local L704_40, L619_44 = pcall(function()
                if _549_282.Get then return _549_282:Get(key) end
                return _549_282[key] or (_549_282.Data and _549_282.Data[key]) or (_549_282.Info and _549_282.Info[key])
            end)
            if L704_40 then return L619_44 end
            return nil
        end

        local v43335 = get_property("CurrentAmmo") or get_property("Ammo") or get_property("Bullets") or get_property("MagazineAmmo")
        local _0xfd96 = get_property("ReserveAmmo") or get_property("StoredAmmo") or get_property("Reserve") or get_property("TotalAmmo")
        local L505_10 = get_property("Reloading") or get_property("IsReloading")
        if _549_282.Info and type(_549_282.Info) == "table" then
            if v43335 == nil then v43335 = _549_282.Info.CurrentAmmo or _549_282.Info.Ammo end
            if _0xfd96 == nil then _0xfd96 = _549_282.Info.ReserveAmmo or _549_282.Info.StoredAmmo end
            if _549_282.Info.Reloading == true or _549_282.Info.IsReloading == true then
                L505_10 = true
            end
        end
        local _Il1I1O1O = rawget(_549_282, "_reload_cooldown")
        if type(_Il1I1O1O) == "number" and _Il1I1O1O > tick() then
            L505_10 = true
        end

        local _00IO01 = _549_282.Name or get_property("Name") or "weapon"
        _0xf0da = (L505_10 == true) and "*Reloading*" or tostring(_00IO01)

        if typeof(v43335) == "number" and typeof(_0xfd96) == "number" then
            _286_387 = string.format("%d/%d", math.floor(v43335 + 0.5), math.floor(_0xfd96 + 0.5))
        elseif typeof(v43335) == "number" then
            _286_387 = tostring(math.floor(v43335 + 0.5))
        end
    end)

    if not _0xf0da then
        pcall(function()
            local char = player.Character
            local _101l1O011lIl = char and char:FindFirstChildOfClass("Tool")
            if _101l1O011lIl then _0xf0da = _101l1O011lIl.Name end
        end)
    end

    if not _0xf0da then return nil end
    if _286_387 and _286_387 ~= "" then
        return _0xf0da .. " | " .. _286_387
    end
    return _0xf0da
end
local _late=[===[

__LkyqXAIbS = {}
create_esp_entry = function(player)
    if __LkyqXAIbS[player] then return end

    local v78878 = Instance.new("Frame")
    v78878.Name = "Box"
    v78878.BackgroundTransparency = 1
    v78878.BorderSizePixel = 0
    v78878.Visible = false
    v78878.Parent = espGui
    local _IOIO01l0I1 = Instance.new("UIStroke")
    _IOIO01l0I1.Thickness = 1
    _IOIO01l0I1.Color = Color3.fromRGB(255, 70, 70)
    _IOIO01l0I1.Parent = v78878

    local _00IO01 = Instance.new("TextLabel")
    _00IO01.Name = "Name"
    _00IO01.BackgroundTransparency = 1
    _00IO01.Font = Enum.Font.Code
    _00IO01.TextSize = 13
    _00IO01.TextColor3 = Color3.fromRGB(255, 255, 255)
    _00IO01.TextStrokeTransparency = 0
    _00IO01.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    _00IO01.TextXAlignment = Enum.TextXAlignment.Center
    _00IO01.Size = UDim2.new(0, 160, 0, 16)
    _00IO01.Visible = false
    _00IO01.Parent = espGui

    local _722_723 = Instance.new("Frame")
    _722_723.Name = "HealthBg"
    _722_723.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    _722_723.BackgroundTransparency = 0.35
    _722_723.BorderSizePixel = 0
    _722_723.Visible = false
    _722_723.Parent = espGui

    local _1141x251 = Instance.new("Frame")
    _1141x251.Name = "HealthBar"
    _1141x251.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    _1141x251.BorderSizePixel = 0
    _1141x251.Visible = false
    _1141x251.Parent = espGui

    local _0x9c10 = Instance.new("TextLabel")
    _0x9c10.Name = "Weapon"
    _0x9c10.BackgroundTransparency = 1
    _0x9c10.Font = Enum.Font.Code
    _0x9c10.TextSize = 12
    _0x9c10.TextColor3 = Color3.fromRGB(220, 220, 220)
    _0x9c10.TextStrokeTransparency = 0
    _0x9c10.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    _0x9c10.TextXAlignment = Enum.TextXAlignment.Center
    _0x9c10.Size = UDim2.new(0, 180, 0, 14)
    _0x9c10.Visible = false
    _0x9c10.Parent = espGui

    __LkyqXAIbS[player] = {
        Box = v78878,
        BoxStroke = _IOIO01l0I1,
        Name = _00IO01,
        HealthBg = _722_723,
        HealthBar = _1141x251,
        Weapon = _0x9c10,
    }
end

destroy_esp_entry = function(player)
    if __LkyqXAIbS[player] then
        for k, d in pairs(__LkyqXAIbS[player]) do
            if typeof(d) == "Instance" then
                pcall(function() d:Destroy() end)
            end
        end
        __LkyqXAIbS[player] = nil
    end
end
for __YEzeEiWEWFAS, __RrBoATP in pairs(Players:GetPlayers()) do
    if __RrBoATP ~= LocalPlayer then create_esp_entry(__RrBoATP) end
end
Players.PlayerAdded:Connect(function(__RrBoATP)
    if __RrBoATP ~= LocalPlayer then create_esp_entry(__RrBoATP) end
end)
Players.PlayerRemoving:Connect(destroy_esp_entry)

RunService.RenderStepped:Connect(function()
    Camera = workspace.CurrentCamera or Camera
    local _916_917 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    if not everyNFrames(2) then return end
    for player, drawings in pairs(__LkyqXAIbS) do
        local v78878, _00IO01, _722_723, _1141x251 = drawings.Box, drawings.Name, drawings.HealthBg, drawings.HealthBar
        local _IOIO01l0I1 = drawings.BoxStroke
        local char = player.Character
        local __BfgstqWnead = char and char:FindFirstChild("HumanoidRootPart")
        local a87b18c82 = char and char:FindFirstChildOfClass("Humanoid")
        local a84b86c62 = char and (char:FindFirstChild("Head") or char:FindFirstChild("HitboxHead") or __BfgstqWnead)

        local _0x9c10 = drawings.Weapon
        local function a81b20c32()
            v78878.Visible = false
            _00IO01.Visible = false
            _722_723.Visible = false
            _1141x251.Visible = false
            if _0x9c10 then _0x9c10.Visible = false end
        end

        if espEnabled and __BfgstqWnead and a87b18c82 and a84b86c62 and a87b18c82.Health > 0 then
            local _0llIIII = a84b86c62.Position + Vector3.new(0, 0.6, 0)
            local _0x7be1 = __BfgstqWnead.Position - Vector3.new(0, 3, 0)
            local _1IOOlI1I, L660_86 = Camera:WorldToViewportPoint(_0llIIII)
            local a44b13c90, _O10OlOll1 = Camera:WorldToViewportPoint(_0x7be1)
            local _0xfe88, _9143x186 = Camera:WorldToViewportPoint(__BfgstqWnead.Position)

            if (_9143x186 or L660_86 or _O10OlOll1) and _0xfe88.Z > 0 then
                local a63b22c39 = math.abs(_1IOOlI1I.Y - a44b13c90.Y)
                if a63b22c39 < 8 then a63b22c39 = 40 end
                local L790_52 = a63b22c39 * 0.55
                local a70b91c70 = _0xfe88.X - L790_52 / 2
                local __CKlSQxN = _1IOOlI1I.Y

                if espBoxEnabled then
                    v78878.Size = UDim2.fromOffset(L790_52, a63b22c39)
                    v78878.Position = UDim2.fromOffset(a70b91c70, __CKlSQxN)
                    local v75099 = is_teammate(player) and Color3.fromRGB(80, 160, 255) or Color3.fromRGB(255, 70, 70)
                    if _IOIO01l0I1 then _IOIO01l0I1.Color = v75099 end
                    v78878.Visible = true
                else
                    v78878.Visible = false
                end

                if espNameEnabled then
                    local __qPdSkeeBv = ""
                    if _916_917 then
                        __qPdSkeeBv = " [" .. math.floor((__BfgstqWnead.Position - _916_917.Position).Magnitude) .. "m]"
                    end
_00IO01.Text = (player.DisplayName or player.Name) .. __qPdSkeeBv
                    _00IO01.Position = UDim2.fromOffset(_0xfe88.X - 80, __CKlSQxN - 16)
                    _00IO01.TextColor3 = is_teammate(player) and Color3.fromRGB(120, 180, 255) or Color3.fromRGB(255, 255, 255)
                    _00IO01.Visible = true
                else
                    _00IO01.Visible = false
                end

                if espHealthEnabled then
                    local _481_362 = math.clamp(a87b18c82.Health / math.max(a87b18c82.MaxHealth, 1), 0, 1)
                    _722_723.Size = UDim2.fromOffset(3, a63b22c39)
                    _722_723.Position = UDim2.fromOffset(a70b91c70 - 6, __CKlSQxN)
                    _722_723.Visible = true
                    local L299_69 = math.max(a63b22c39 * _481_362, 1)
                    _1141x251.Size = UDim2.fromOffset(3, L299_69)
                    _1141x251.Position = UDim2.fromOffset(a70b91c70 - 6, __CKlSQxN + (a63b22c39 - L299_69))
                    _1141x251.BackgroundColor3 = Color3.fromHSV(_481_362 * 0.33, 1, 1)
                    _1141x251.Visible = true
                else
                    _722_723.Visible = false
                    _1141x251.Visible = false
                end

                if espWeaponEnabled and _0x9c10 then
                    local _lIO1O1 = get_weapon_info(player)
                    if _lIO1O1 and _lIO1O1 ~= "" then
                        _0x9c10.Text = _lIO1O1
                        _0x9c10.Position = UDim2.fromOffset(_0xfe88.X - 90, __CKlSQxN + a63b22c39 + 2)
                        _0x9c10.TextColor3 = is_teammate(player) and Color3.fromRGB(140, 190, 255) or Color3.fromRGB(220, 220, 220)
                        _0x9c10.Visible = true
                    else
                        _0x9c10.Visible = false
                    end
                elseif _0x9c10 then
                    _0x9c10.Visible = false
                end
            else
                a81b20c32()
            end
        else
            a81b20c32()
        end
    end
end)

__WskCreglohw = false
_l11IOl10lO = 0
_0xd5a5 = RaycastParams.new()
_0xd5a5.FilterType = Enum.RaycastFilterType.Exclude

is_crosshair_enemy = function()
    local char = LocalPlayer.Character
    if not char then return false end

    _0xd5a5.FilterDescendantsInstances = {char, Camera}
    local _OOO0I1I = workspace:Raycast(Camera.CFrame.Position, Camera.CFrame.LookVector * 400, _0xd5a5)

    if _OOO0I1I and _OOO0I1I.Instance then
        local _0xb7aa = _OOO0I1I.Instance:FindFirstAncestorOfClass("Model")
        if _0xb7aa and _0xb7aa ~= char then
            local a87b18c82 = _0xb7aa:FindFirstChildOfClass("Humanoid")
            if a87b18c82 and a87b18c82.Health > 0 then
                local __bdUacYjXOqr = Players:GetPlayerFromCharacter(_0xb7aa)
                if __bdUacYjXOqr and is_teammate(__bdUacYjXOqr) then
                    return false
                end
                return true
            end
        end
end
    return false
end

RunService.RenderStepped:Connect(function()
    if not everyNFrames(2) then return end
    if not triggerbotEnabled then
        if __WskCreglohw then
            pcall(mouse1release)
            __WskCreglohw = false
        end
        return
    end

    if mouse1click and (isrbxactive or iswindowactive) and (isrbxactive() or iswindowactive()) then
        if is_crosshair_enemy() then
            if _l11IOl10lO < tick() then
                if __WskCreglohw then
                    pcall(mouse1release)
                    _l11IOl10lO = tick() + 0.07
                else
                    pcall(mouse1press)
                end
                __WskCreglohw = not __WskCreglohw
            end
        else
            if __WskCreglohw then
                pcall(mouse1release)
                __WskCreglohw = false
            end
        end
    end
end)
v56079 = game:GetService("Lighting")
_785_562 = {}
a36b74c54 = Instance.new("BlurEffect")
a36b74c54.Name = "ShaderBlur"
a36b74c54.Size = 6

v62908 = Instance.new("ColorCorrectionEffect")
v62908.Name = "ShaderColor"
v62908.Saturation = -0.35

enable_shader = function()
    _785_562 = {
        Ambient = v56079.Ambient,
        Brightness = v56079.Brightness,
        OutdoorAmbient = v56079.OutdoorAmbient,
        ShadowSoftness = v56079.ShadowSoftness,
        TimeOfDay = v56079.TimeOfDay,
        ColorShift_Top = v56079.ColorShift_Top,
        ColorShift_Bottom = v56079.ColorShift_Bottom
    }

    v56079.Ambient = Color3.fromRGB(94, 99, 188)
    v56079.Brightness = 3.5
    v56079.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
    v56079.ShadowSoftness = 2.5
    v56079.TimeOfDay = "00:30:00"
    v56079.ColorShift_Top = Color3.fromRGB(0, 0, 0)
    v56079.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)

    a36b74c54.Parent = v56079
    v62908.Parent = v56079
end

disable_shader = function()
    if next(_785_562) then
        v56079.Ambient = _785_562.Ambient
        v56079.Brightness = _785_562.Brightness
        v56079.OutdoorAmbient = _785_562.OutdoorAmbient
        v56079.ShadowSoftness = _785_562.ShadowSoftness
        v56079.TimeOfDay = _785_562.TimeOfDay
        v56079.ColorShift_Top = _785_562.ColorShift_Top
        v56079.ColorShift_Bottom = _785_562.ColorShift_Bottom
    end

    a36b74c54.Parent = nil
    v62908.Parent = nil
end

a69b44c55 = false
RunService.Heartbeat:Connect(function()
    if shaderEnabled ~= a69b44c55 then
        a69b44c55 = shaderEnabled
        if shaderEnabled then
            enable_shader()
        else
            disable_shader()
        end
    end
end)
]===]
local _f,_e=loadstring(_late)
if _f then _f() else warn("late:",_e) end

task.defer(function()
    pcall(function()
        local c=game:GetService("CoreGui")
        local n=c:FindFirstChild("nexlib")
        if n then
            for _,ch in ipairs(n:GetDescendants()) do
                if ch.Name=="MainFrame" then ch.Visible=true end
            end
        end
        game:GetService("UserInputService").MouseBehavior=Enum.MouseBehavior.Default
        game:GetService("UserInputService").MouseIconEnabled=true
    end)
end)
