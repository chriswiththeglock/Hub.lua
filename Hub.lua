-- Universal Script Hub (Mobile) by Claude
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local camera = workspace.CurrentCamera

local toggles = { speed = false, fly = false, aimbot = false }
local espToggles = { box = false, tracer = false, skeleton = false }
local aimbotMode = "nearest"
local flyConnection, aimbotConnection, espConnection
local flyBodyVelocity, flyBodyGyro
local hubOpen = false

local espObjects = {}

local function getMyTeam()
    if player.Team then return player.Team end
    local char = player.Character
    if char then
        local tv = char:FindFirstChild("Team") or char:FindFirstChild("TeamColor")
        if tv then return tv.Value end
    end
    local ls = player:FindFirstChild("leaderstats")
    if ls then
        local tv = ls:FindFirstChild("Team") or ls:FindFirstChild("TeamColor")
        if tv then return tv.Value end
    end
    return nil
end

local function isEnemy(targetPlayer)
    if targetPlayer == player then return false end
    local char = targetPlayer.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    local myTeam = getMyTeam()
    if myTeam == nil then return true end
    local theirTeam = nil
    if targetPlayer.Team then
        theirTeam = targetPlayer.Team
    else
        local tc = targetPlayer.Character
        if tc then
            local tv = tc:FindFirstChild("Team") or tc:FindFirstChild("TeamColor")
            if tv then theirTeam = tv.Value end
        end
        local ls = targetPlayer:FindFirstChild("leaderstats")
        if ls then
            local tv = ls:FindFirstChild("Team") or ls:FindFirstChild("TeamColor")
            if tv then theirTeam = tv.Value end
        end
    end
    if theirTeam == myTeam then return false end
    return true
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ScriptHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = player.PlayerGui

local IconBtn = Instance.new("ImageButton")
IconBtn.Size = UDim2.new(0, 52, 0, 52)
IconBtn.Position = UDim2.new(1, -70, 0.5, -26)
IconBtn.BackgroundColor3 = Color3.fromRGB(100, 80, 220)
IconBtn.BorderSizePixel = 0
IconBtn.Image = ""
IconBtn.Active = true
IconBtn.Draggable = true
IconBtn.Parent = ScreenGui
Instance.new("UICorner", IconBtn).CornerRadius = UDim.new(1, 0)

local IconLabel = Instance.new("TextLabel")
IconLabel.Size = UDim2.new(1, 0, 1, 0)
IconLabel.BackgroundTransparency = 1
IconLabel.Text = "⚡"
IconLabel.TextSize = 24
IconLabel.Font = Enum.Font.GothamBold
IconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
IconLabel.Parent = IconBtn

local Main = Instance.new("Frame")
