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

ChargerHud.Enabled = true

local ChargeBar = ChargerHud:WaitForChild("Charge")
local ChargePercentage = ChargerHud:WaitForChild("ChargePercentage")

local FillTInfo = TweenInfo.new(8, Enum.EasingStyle.Sine)
local ResetTInfo = TweenInfo.new(0.1, Enum.EasingStyle.Sine)

local PropertyTableFill = {
    ["Size"] = UDim2.fromScale(1, 1)
}

local PropertyTableReset = {
    ["Size"] = UDim2.fromScale(0, 1)
}

local FillTween = TweenService:Create(ChargeBar:WaitForChild("Bar"), FillTInfo, PropertyTableFill)
local ResetTween = TweenService:Create(ChargeBar:WaitForChild("Bar"), ResetTInfo, PropertyTableReset)

StartBarFill.OnClientEvent:Connect(function()
    FillTween:Play()
end)

EndBarFill.OnClientEvent:Connect(function()
    ResetTween:Play()
end)

local function updateChargerPercentage(newPercentage)
    ChargePercentage.TextLabel.Text = newPercentage
end

local function changeGreenFlash(bool)
    local GreenFlash = Lighting:WaitForChild("ChargerCharge")
    GreenFlash.Enabled = bool
end

Packet.UpateChargerPercentage.listen(updateChargerPercentage)
Remotes:WaitForChild("ChargerGreenFlash").OnClientEvent:Connect(changeGreenFlash)