local ReplicatedStorage = game:GetService("ReplicatedStorage")
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

local FillTInfo = TweenInfo.new(8, Enum.EasingStyle.Sine)
local ResetTInfo = TweenInfo.new(1, Enum.EasingStyle.Sine)

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
