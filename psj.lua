-- Rayfield
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "동굴 HUB",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "by PSJ",
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false },
    KeySystem = false
})

local Main = Window:CreateTab("inf총알", 4483362458)
local PlayerTab = Window:CreateTab("플레이어 기능", 4483362458)
local TeamTab = Window:CreateTab("팀변경", 4483362458)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local TeamsService = game:GetService("Teams")
local InsertService = game:GetService("InsertService")

local InfiniteAmmo = false
local ESPEnabled = false
local NoclipEnabled = false
local FlyEnabled = false
local FlySpeed = 50
local ESPObjects = {}
local FlyBodyVelocity = nil
local FlyBodyGyro = nil
local NoclipConnection = nil
local ESPConnection = nil

--------------------------------------------------
-- 킬 카운트 + 킥
--------------------------------------------------
local KillCount = 0
local MaxKills = 15
local KickEnabled = true
local CountedDeaths = {}

local function OnPlayerDied(victim)
    if not victim or victim == LocalPlayer then return end
    if CountedDeaths[victim] then return end

    local character = victim.Character
    if not character then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health > 0 then return end

    local creator = humanoid:FindFirstChild("creator")
    if creator and creator.Value then
        local killer = creator.Value
        if killer == LocalPlayer or (typeof(killer) == "Instance" and killer:IsDescendantOf(LocalPlayer.Character)) then
            CountedDeaths[victim] = true
            KillCount += 1
            Rayfield:Notify({
                Title = "킬 카운트",
                Content = string.format("현재 킬: %d / %d", KillCount, MaxKills),
                Duration = 2
            })
            if KillCount >= MaxKills and KickEnabled then
                LocalPlayer:Kick("PSJ 허브를 사용해주시는 플레이어분들 더이상에 무단사살은 영창에 들어갈수있습니다!")
            end
        end
    end
end

local function ConnectPlayer(player)
    if player == LocalPlayer then return end

    player.CharacterAdded:Connect(function(char)
        CountedDeaths[player] = nil
        task.wait(0.5)
        local humanoid = char:WaitForChild("Humanoid", 5)
        if humanoid then
            humanoid.Died:Connect(function()
                OnPlayerDied(player)
            end)
        end
    end)

    if player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Died:Connect(function()
                OnPlayerDied(player)
            end)
        end
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    ConnectPlayer(player)
end
Players.PlayerAdded:Connect(ConnectPlayer)

--------------------------------------------------
-- 스켈레톤 ESP
--------------------------------------------------
local R15Joints = {
    {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
    {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
    {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
    {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
    {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"},
}

local R6Joints = {
    {"Head", "Torso"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"},
    {"Torso", "Left Leg"}, {"Torso", "Right Leg"},
}

local function HasDrawing()
    return typeof(Drawing) == "table" or typeof(Drawing) == "userdata"
end

local function GetJoints(character)
    if character:FindFirstChild("UpperTorso") then
        return R15Joints
    else
        return R6Joints
    end
end

local function CreateESP(player)
    if player == LocalPlayer then return end
    if ESPObjects[player] then return end

    local character = player.Character
    if not character then return end

    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local head = character:FindFirstChild("Head")
    if not humanoidRootPart or not head then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Adornee = character
    highlight.FillColor = Color3.fromRGB(255, 50, 50)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.65
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = character

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Billboard"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3.2, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = head

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0.3
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = billboard

    local distLabel = Instance.new("TextLabel")
    distLabel.Name = "DistLabel"
    distLabel.Size = UDim2.new(1, 0, 0.5, 0)
    distLabel.Position = UDim2.new(0, 0, 0.5, 0)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "0m"
    distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    distLabel.TextStrokeTransparency = 0.3
    distLabel.TextScaled = true
    distLabel.Font = Enum.Font.Gotham
    distLabel.Parent = billboard

    local skeletonLines = {}
    local tracer = nil

    if HasDrawing() then
        for i = 1, 14 do
            local line = Drawing.new("Line")
            line.Visible = false
            line.Color = Color3.fromRGB(0, 255, 128)
            line.Thickness = 1.6
            line.Transparency = 1
            table.insert(skeletonLines, line)
        end

        tracer = Drawing.new("Line")
        tracer.Visible = false
        tracer.Color = Color3.fromRGB(255, 80, 80)
        tracer.Thickness = 1.3
        tracer.Transparency = 0.75
    end

    ESPObjects[player] = {
        Highlight = highlight,
        Billboard = billboard,
        DistLabel = distLabel,
        SkeletonLines = skeletonLines,
        Tracer = tracer
    }
end

local function RemoveESP(player)
    if not ESPObjects[player] then return end
    pcall(function()
        if ESPObjects[player].Highlight then ESPObjects[player].Highlight:Destroy() end
        if ESPObjects[player].Billboard then ESPObjects[player].Billboard:Destroy() end
        if ESPObjects[player].SkeletonLines then
            for _, line in ipairs(ESPObjects[player].SkeletonLines) do
                if line and line.Remove then line:Remove() end
            end
        end
        if ESPObjects[player].Tracer and ESPObjects[player].Tracer.Remove then
            ESPObjects[player].Tracer:Remove()
        end
    end)
    ESPObjects[player] = nil
end

local function ClearAllESP()
    for player in pairs(ESPObjects) do
        RemoveESP(player)
    end
end

local function WorldToScreen(position)
    local screenPos, onScreen = Camera:WorldToViewportPoint(position)
    return Vector2.new(screenPos.X, screenPos.Y), onScreen
end

local function UpdateESP()
    if not ESPEnabled then return end

    local screenSize = Camera.ViewportSize
    local bottomCenter = Vector2.new(screenSize.X / 2, screenSize.Y - 2)
    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    for player, data in pairs(ESPObjects) do
        local character = player.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then
            if data.Tracer then data.Tracer.Visible = false end
            if data.SkeletonLines then
                for _, line in ipairs(data.SkeletonLines) do line.Visible = false end
            end
            continue
        end

        local hrp = character.HumanoidRootPart
        local head = character:FindFirstChild("Head")

        if myHRP then
            local dist = (hrp.Position - myHRP.Position).Magnitude
            data.DistLabel.Text = string.format("%dm", math.floor(dist))
        end

        if not HasDrawing() or not data.SkeletonLines then continue end

        local targetPos = head and head.Position or hrp.Position
        local screenPos, onScreen = WorldToScreen(targetPos)

        if data.Tracer then
            data.Tracer.From = bottomCenter
            data.Tracer.To = screenPos
            data.Tracer.Visible = onScreen
        end

        local joints = GetJoints(character)
        for i, joint in ipairs(joints) do
            local line = data.SkeletonLines[i]
            if not line then continue end

            local part0 = character:FindFirstChild(joint[1])
            local part1 = character:FindFirstChild(joint[2])

            if part0 and part1 then
                local pos0, on0 = WorldToScreen(part0.Position)
                local pos1, on1 = WorldToScreen(part1.Position)
                if on0 and on1 then
                    line.From = pos0
                    line.To = pos1
                    line.Visible = true
                else
                    line.Visible = false
                end
            else
                line.Visible = false
            end
        end

        for i = #joints + 1, #data.SkeletonLines do
            if data.SkeletonLines[i] then data.SkeletonLines[i].Visible = false end
        end
    end
end

--------------------------------------------------
-- Noclip / Fly
--------------------------------------------------
local function SetNoclip(state)
    local character = LocalPlayer.Character
    if not character then return end
    for _, part in ipairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = not state
        end
    end
end

local function StartFly()
    local character = LocalPlayer.Character
    if not character then return end

    local hrp = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not hrp or not humanoid then return end

    humanoid.PlatformStand = true

    FlyBodyVelocity = Instance.new("BodyVelocity")
    FlyBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    FlyBodyVelocity.Velocity = Vector3.zero
    FlyBodyVelocity.Parent = hrp

    FlyBodyGyro = Instance.new("BodyGyro")
    FlyBodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    FlyBodyGyro.P = 9e4
    FlyBodyGyro.Parent = hrp

    task.spawn(function()
        while FlyEnabled and character and hrp and hrp.Parent do
            local moveDirection = Vector3.zero
            local camCF = Camera.CFrame

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection += camCF.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection -= camCF.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection -= camCF.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection += camCF.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection += Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.C) then
                moveDirection -= Vector3.new(0, 1, 0)
            end

            if moveDirection.Magnitude > 0 then
                moveDirection = moveDirection.Unit * FlySpeed
            end

            FlyBodyVelocity.Velocity = moveDirection
            FlyBodyGyro.CFrame = camCF
            RunService.RenderStepped:Wait()
        end
    end)
end

local function StopFly()
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.PlatformStand = false end
    end
    if FlyBodyVelocity then FlyBodyVelocity:Destroy() FlyBodyVelocity = nil end
    if FlyBodyGyro then FlyBodyGyro:Destroy() FlyBodyGyro = nil end
end

--------------------------------------------------
-- 팀 복장 데이터
--------------------------------------------------
local TeamOutfits = {
    ["육군"] = {
        Shirt = 79985917986699,
        Pants = 127700059925361,
        Accessories = {83982474387274, 83099803300505}
    },
    ["취사병"] = {
        Shirt = 79985917986699,
        Pants = 127700059925361,
        Accessories = {18934391028}
    },
    ["의무병"] = {
        Shirt = 79985917986699,
        Pants = 127700059925361,
        Accessories = {107996542380666, 73825095710058}
    },
    ["군사경찰"] = {
        Shirt = 1240175738,
        Pants = 2773535966,
        Accessories = {138911539348252, 108634717681676}
    },
    ["특수임무대"] = {
        Shirt = 132763156221390,
        Pants = 9182181797,
        Accessories = {89788676232070, 85396301843767}
    },
    ["특수전사령부"] = {
        Shirt = 132763156221390,
        Pants = 9182181797,
        Accessories = {71364927733047, 85396301843767}
    },
    ["조교"] = {
        Shirt = 1975096281,
        Pants = 5345636999,
        Accessories = {14585469642}
    },
    ["교관"] = {
        Shirt = 8204885676,
        Pants = 2548613878,
        Accessories = {9883022320}
    },
    ["부사관"] = {
        Shirt = 130145885960432,
        Pants = 12255488047,
        Accessories = {140508359474711}
    },
    ["장교"] = {
        Shirt = 130145885960432,
        Pants = 12255488047,
        Accessories = {106533573066392}
    },
    ["교육사령부"] = {
        Shirt = 130145885960432,
        Pants = 12255488047,
        Accessories = {106533573066392}
    },
    ["본부"] = {
        Shirt = 10644088877,
        Pants = 263559062,
        Accessories = {}
    },
    ["레이더"] = {
        Shirt = 126131032543110,
        Pants = 9542447042,
        Accessories = {12653276918}
    }
}

local function ClearAppearance(character)
    for _, v in ipairs(character:GetChildren()) do
        if v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic")
            or v:IsA("Accessory") or v:IsA("Hat") or v:IsA("BodyColors")
            or v:IsA("CharacterMesh") then
            pcall(function() v:Destroy() end)
        end
    end
end

local function ApplyOutfit(teamName)
    local data = TeamOutfits[teamName]
    if not data then return end

    local character = LocalPlayer.Character
    if not character then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    ClearAppearance(character)
    task.wait(0.3)

    if data.Shirt then
        pcall(function()
            local shirt = Instance.new("Shirt")
            shirt.ShirtTemplate = "rbxassetid://" .. data.Shirt
            shirt.Parent = character
        end)
        pcall(function()
            local graphic = Instance.new("ShirtGraphic")
            graphic.Graphic = "rbxassetid://" .. data.Shirt
            graphic.Parent = character
        end)
    end

    if data.Pants then
        pcall(function()
            local pants = Instance.new("Pants")
            pants.PantsTemplate = "rbxassetid://" .. data.Pants
            pants.Parent = character
        end)
    end

    task.wait(0.2)

    for _, assetId in ipairs(data.Accessories or {}) do
        task.spawn(function()
            local success, objs = pcall(function()
                return game:GetObjects("rbxassetid://" .. assetId)
            end)
            if success and objs and objs[1] then
                pcall(function()
                    humanoid:AddAccessory(objs[1])
                end)
            end
        end)
    end
end

local function ChangeTeam(teamName)
    local team = TeamsService:FindFirstChild(teamName)
    if not team then
        for _, t in ipairs(TeamsService:GetChildren()) do
            if string.find(t.Name, teamName) or string.find(teamName, t.Name) then
                team = t
                break
            end
        end
    end

    if team then
        pcall(function()
            LocalPlayer.Team = team
            LocalPlayer.TeamColor = team.TeamColor
        end)
    end

    ApplyOutfit(teamName)

    Rayfield:Notify({
        Title = "팀변경",
        Content = teamName .. " 적용 시도 완료 (복장은 실행기에 따라 안 바뀔 수 있음)",
        Duration = 3
    })
end

--------------------------------------------------
-- inf총알 탭
--------------------------------------------------
Main:CreateToggle({
    Name = "킬 제한 킥",
    CurrentValue = true,
    Flag = "KickEnabled",
    Callback = function(Value)
        KickEnabled = Value
        Rayfield:Notify({
            Title = "킬 제한 킥",
            Content = Value and "킥 기능 활성화" or "킥 기능 비활성화",
            Duration = 2
        })
    end
})

Main:CreateInput({
    Name = "최대 킬 수 설정",
    PlaceholderText = "숫자 입력 후 엔터",
    CurrentValue = "15",
    Flag = "MaxKillsInput",
    Callback = function(Text)
        local num = tonumber(Text)
        if num and num >= 1 then
            MaxKills = math.floor(num)
            Rayfield:Notify({
                Title = "최대 킬 수 변경",
                Content = "최대 킬수가 " .. MaxKills .. "킬로 설정되었습니다!",
                Duration = 3
            })
        else
            Rayfield:Notify({
                Title = "오류",
                Content = "올바른 숫자를 입력해주세요 (1 이상)",
                Duration = 2
            })
        end
    end
})

Main:CreateLabel("최대 권장 킬수는 15킬입니다!")

Main:CreateToggle({
    Name = "무한총알",
    CurrentValue = false,
    Flag = "InfiniteAmmo",
    Callback = function(Value)
        InfiniteAmmo = Value
        if Value then
            task.spawn(function()
                while InfiniteAmmo do
                    pcall(function()
                        for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
                            if tool:FindFirstChild("Info") then
                                tool:SetAttribute("ammo", math.huge)
                            end
                        end
                        if LocalPlayer.Character then
                            for _, tool in ipairs(LocalPlayer.Character:GetChildren()) do
                                if tool:FindFirstChild("Info") then
                                    tool:SetAttribute("ammo", math.huge)
                                end
                            end
                        end
                    end)
                    task.wait(0.15)
                end
            end)
        end
    end
})

--------------------------------------------------
-- 플레이어 기능 탭
--------------------------------------------------
PlayerTab:CreateToggle({
    Name = "플레이어 ESP",
    CurrentValue = false,
    Flag = "ESP",
    Callback = function(Value)
        ESPEnabled = Value
        if Value then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    CreateESP(player)
                end
            end
            ESPConnection = RunService.Heartbeat:Connect(UpdateESP)
            Rayfield:Notify({ Title = "ESP", Content = "플레이어 ESP + 스켈레톤 + 트레이서 활성화", Duration = 2 })
        else
            if ESPConnection then ESPConnection:Disconnect() ESPConnection = nil end
            ClearAllESP()
            Rayfield:Notify({ Title = "ESP", Content = "플레이어 ESP 비활성화", Duration = 2 })
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "Noclip",
    Callback = function(Value)
        NoclipEnabled = Value
        if Value then
            NoclipConnection = RunService.Stepped:Connect(function() SetNoclip(true) end)
            Rayfield:Notify({ Title = "Noclip", Content = "Noclip 활성화", Duration = 2 })
        else
            if NoclipConnection then NoclipConnection:Disconnect() NoclipConnection = nil end
            SetNoclip(false)
            Rayfield:Notify({ Title = "Noclip", Content = "Noclip 비활성화", Duration = 2 })
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "Fly",
    Callback = function(Value)
        FlyEnabled = Value
        if Value then
            StartFly()
            Rayfield:Notify({ Title = "Fly", Content = "Fly 활성화 (WASD + Space/Ctrl)", Duration = 2 })
        else
            StopFly()
            Rayfield:Notify({ Title = "Fly", Content = "Fly 비활성화", Duration = 2 })
        end
    end
})

PlayerTab:CreateSlider({
    Name = "Fly 속도",
    Range = {10, 250},
    Increment = 5,
    CurrentValue = 50,
    Flag = "FlySpeed",
    Callback = function(Value) FlySpeed = Value end
})

--------------------------------------------------
-- 팀변경 탭
--------------------------------------------------
TeamTab:CreateLabel("⚠️ 이 팀은 자신에게만 보이며, 복장은 실행기에 따라 안 바뀔 수 있습니다")
TeamTab:CreateLabel("재미로만 사용해주세요 (옷이 벗겨질 수 있음)")

local teamList = {
    "육군", "취사병", "의무병", "군사경찰",
    "특수임무대", "특수전사령부",
    "조교", "교관", "부사관", "장교",
    "교육사령부", "본부", "레이더"
}

for _, teamName in ipairs(teamList) do
    TeamTab:CreateButton({
        Name = teamName,
        Callback = function()
            ChangeTeam(teamName)
        end
    })
end

--------------------------------------------------
-- 캐릭터 리스폰 처리
--------------------------------------------------
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if NoclipEnabled then SetNoclip(true) end
    if FlyEnabled then StartFly() end
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(1)
        if ESPEnabled then CreateESP(player) end
    end)
end)

Players.PlayerRemoving:Connect(RemoveESP)

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function()
            task.wait(1)
            if ESPEnabled then CreateESP(player) end
        end)
    end
end

--------------------------------------------------
-- 순간이동 탭
--------------------------------------------------
local ATMTab = Window:CreateTab("순간이동", 4483362458)

local function TeleportTo(position, locationName)
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local HRP = Character:WaitForChild("HumanoidRootPart")
    HRP.CFrame = CFrame.new(position)
    Rayfield:Notify({
        Title = "순간이동",
        Content = locationName .. "으로 이동했습니다.",
        Duration = 2
    })
end

ATMTab:CreateButton({ Name = "연병장", Callback = function() TeleportTo(Vector3.new(-70.83, 170.67, 60.71), "연병장") end })
ATMTab:CreateButton({ Name = "의무실", Callback = function() TeleportTo(Vector3.new(-82.45, 174.33, 237.50), "의무실") end })
ATMTab:CreateButton({ Name = "영창", Callback = function() TeleportTo(Vector3.new(-30.41, 141.50, 44.96), "영창") end })
ATMTab:CreateButton({ Name = "지하", Callback = function() TeleportTo(Vector3.new(6.04, 141.21, 67.40), "지하") end })
ATMTab:CreateButton({ Name = "레이더 기지", Callback = function() TeleportTo(Vector3.new(-197.16, 141.21, 139.67), "레이더 기지") end })
ATMTab:CreateButton({ Name = "PX", Callback = function() TeleportTo(Vector3.new(-225.69, 197.70, -80.57), "PX") end })
ATMTab:CreateButton({ Name = "오비", Callback = function() TeleportTo(Vector3.new(-362.60, 197.44, 30.94), "오비") end })
ATMTab:CreateButton({ Name = "급식소", Callback = function() TeleportTo(Vector3.new(-283.68, 198.90, 229.38), "급식소") end })
ATMTab:CreateButton({ Name = "육군 본부 건물", Callback = function() TeleportTo(Vector3.new(-283.31, 204.91, -211.72), "육군 본부 건물") end })
ATMTab:CreateButton({ Name = "동굴 교육소", Callback = function() TeleportTo(Vector3.new(84.52, 203.41, -192.80), "동굴 교육소") end })
ATMTab:CreateButton({ Name = "궁금하면 눌러보든가ㅋ", Callback = function() TeleportTo(Vector3.new(4.66, 141.21, -23.95), "궁금하면 눌러보든가ㅋ") end })
ATMTab:CreateButton({ Name = "중심건물", Callback = function() TeleportTo(Vector3.new(-245.75, 199.18, 46.98), "중심건물") end })
ATMTab:CreateButton({ Name = "벽위쪽", Callback = function() TeleportTo(Vector3.new(321.85, 255.69, 18.44), "벽위쪽") end })

local TeleportPoints = {
    CFrame.new(203.51, 170.92, 181.98),
    CFrame.new(96.34, 171.13, 107.97),
    CFrame.new(-106.45, 174.33, 214.28),
    CFrame.new(-228.43, 197.95, 137.09),
    CFrame.new(-271.83, 197.76, -31.15),
    CFrame.new(-17.31, 203.32, -225.11),
}
local CurrentPoint = 1

ATMTab:CreateButton({
    Name = "ATM기 순간이동",
    Callback = function()
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local HRP = Character:WaitForChild("HumanoidRootPart")
        HRP.CFrame = TeleportPoints[CurrentPoint]
        CurrentPoint += 1
        if CurrentPoint > #TeleportPoints then CurrentPoint = 1 end
        Rayfield:Notify({ Title = "순간이동", Content = "다음 ATM기로 이동했습니다.", Duration = 2 })
    end
})

--------------------------------------------------
-- hitbox 탭
--------------------------------------------------
local HeadTab = Window:CreateTab("hitbox", 4483362458)

local BigHeadEnabled = false
local HeadSizeValue = 4
local OriginalSizes = {}

local function SaveOriginal(player)
    if not player.Character then return end
    local head = player.Character:FindFirstChild("Head")
    if not head or OriginalSizes[player] then return end
    OriginalSizes[player] = { Size = head.Size, Transparency = head.Transparency }
    local mesh = head:FindFirstChildOfClass("SpecialMesh") or head:FindFirstChildOfClass("FileMesh")
    if mesh then OriginalSizes[player].MeshScale = mesh.Scale end
end

local function ApplyHeadSize(player, size)
    if player == LocalPlayer or not player.Character then return end
    local head = player.Character:FindFirstChild("Head")
    if not head then return end
    SaveOriginal(player)
    pcall(function()
        head.Size = Vector3.new(size, size, size)
        local mesh = head:FindFirstChildOfClass("SpecialMesh") or head:FindFirstChildOfClass("FileMesh")
        if mesh then mesh.Scale = Vector3.new(size, size, size) end
        head.Transparency = 0.5
        head.CanCollide = false
        head.Massless = true
    end)
end

local function RestoreHead(player)
    if not OriginalSizes[player] or not player.Character then return end
    local head = player.Character:FindFirstChild("Head")
    if not head then return end
    pcall(function()
        head.Size = OriginalSizes[player].Size
        head.Transparency = OriginalSizes[player].Transparency or 0
        local mesh = head:FindFirstChildOfClass("SpecialMesh") or head:FindFirstChildOfClass("FileMesh")
        if mesh and OriginalSizes[player].MeshScale then mesh.Scale = OriginalSizes[player].MeshScale end
        head.CanCollide = true
        head.Massless = false
    end)
end

HeadTab:CreateToggle({
    Name = "상대방 머리 크게",
    CurrentValue = false,
    Flag = "BigHead",
    Callback = function(Value)
        BigHeadEnabled = Value
        if Value then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then ApplyHeadSize(player, HeadSizeValue) end
            end
            Rayfield:Notify({ Title = "hitbox", Content = "상대방 히트박스 확대 활성화", Duration = 2 })
        else
            for _, player in ipairs(Players:GetPlayers()) do RestoreHead(player) end
            Rayfield:Notify({ Title = "hitbox", Content = "비활성화됨", Duration = 2 })
        end
    end
})

HeadTab:CreateSlider({
    Name = "히트박스 크기",
    Range = {1, 150},
    Increment = 0.5,
    Suffix = "배",
    CurrentValue = 4,
    Flag = "HeadSize",
    Callback = function(Value)
        HeadSizeValue = Value
        if BigHeadEnabled then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then ApplyHeadSize(player, HeadSizeValue) end
            end
        end
    end
})

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(1)
        if BigHeadEnabled then ApplyHeadSize(player, HeadSizeValue) end
    end)
end)

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function()
            task.wait(1)
            if BigHeadEnabled then ApplyHeadSize(player, HeadSizeValue) end
        end)
    end
end
