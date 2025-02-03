local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packet = require(ReplicatedStorage:WaitForChild("Packet"))
local Lighting = game:GetService("Lighting")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local TweenService = game:GetService("TweenService")
local StartBarFill = Remotes:WaitForChild("StartFillingBar")
local EndBarFill = Remotes:WaitForChild("ResetDropkick")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")::PlayerGui
local ClassHuds = PlayerGui:WaitForChild("ClassHuds")
local ChargerHud = ClassHuds:WaitForChild("Charger")
local ChargeInfo = ChargerHud:WaitForChild("Charge"):WaitForChild("CanvasGroup")

ChargerHud.Enabled = true
ChargerHud:WaitForChild("Charge").Enabled = true


local ChargeBar = ChargeInfo:WaitForChild("Background").Left.Progress
local ChargePercentage = ChargeInfo:WaitForChild("Percent").T1
local ChargePercentage2 = ChargeInfo:WaitForChild("Percent").T2


local FillTInfo = TweenInfo.new(8, Enum.EasingStyle.Sine)
local ResetTInfo = TweenInfo.new(0.1, Enum.EasingStyle.Sine)

local PropertyTableFill = {
    ["Size"] = UDim2.fromScale(1, 1)
}

local PropertyTableReset = {
    ["Size"] = UDim2.fromScale(0, 1)
}

local FillTween = TweenService:Create(ChargeBar, FillTInfo, PropertyTableFill)
local ResetTween = TweenService:Create(ChargeBar, ResetTInfo, PropertyTableReset)

StartBarFill.OnClientEvent:Connect(function()
    FillTween:Play()
end)

EndBarFill.OnClientEvent:Connect(function()
    ResetTween:Play()
end)

local function updateChargerPercentage(newPercentage)
    ChargePercentage.Text = tostring(newPercentage) .. "%"
    ChargePercentage2.Text = tostring(newPercentage) .. "%"
end

local function changeGreenFlash(bool)
    local GreenFlash = Lighting:WaitForChild("ChargerCharge")
    GreenFlash.Enabled = bool
end

Packet.UpateChargerPercentage.listen(updateChargerPercentage)
Remotes:WaitForChild("ChargerGreenFlash").OnClientEvent:Connect(changeGreenFlash)