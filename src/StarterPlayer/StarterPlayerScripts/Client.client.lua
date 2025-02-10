local RS = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")

local remotes = RS.Remotes

local player = players.LocalPlayer

local playerGui = player.PlayerGui

local classSelection = playerGui:WaitForChild("ClassSelection")
local selectionFrame = classSelection.SelectionFrame

for i, v:Instance in ipairs(selectionFrame:GetChildren()) do
    if not v:IsA("Frame") then continue; end

    v.Hitbox.Activated:Connect(function()
        classSelection.Enabled = false
        remotes.ClassSelect:FireServer(v.Name)
    end)
end

classSelection.Enabled = true