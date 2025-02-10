local RS = game:GetService("ReplicatedStorage")
local SS = game:GetService("ServerStorage")
local players = game:GetService("Players")

local modules = RS.Modules
local remotes = RS.Remotes
local playerData = RS.PlayerData

local items = SS.Items

local Loadouts = require(modules.Loadouts)

remotes.ClassSelect.OnServerEvent:Connect(function(player:Player, className:string)
    local class = Loadouts[className]
    local playerFolder = playerData:FindFirstChild(player.Name)

    for i, v in ipairs(class) do
        local item = items:FindFirstChild(v):Clone()
        item.Parent = player.Backpack

        if item:FindFirstChild("WeaponSettings") then
            local weaponData = require(item.WeaponSettings)

            local weaponFolder = Instance.new("Folder")
            weaponFolder.Name = item.Name
            weaponFolder.Parent = playerFolder

            local ammo = Instance.new("IntValue")
            ammo.Name = "Ammo"
            ammo.Value = weaponData.MagCapacity
            ammo.Parent = weaponFolder

            local maxAmmo = Instance.new("IntValue")
            maxAmmo.Name = "MaxAmmo"
            maxAmmo.Value = weaponData.MaxAmmo
            maxAmmo.Parent = weaponFolder
        end
    end
end)

players.PlayerAdded:Connect(function(player:Player)
    local playerFolder = Instance.new("Folder")
    playerFolder.Name = player.Name
    playerFolder.Parent = playerData
end)

players.PlayerRemoving:Connect(function(player:Player)
    local playerFolder = playerData:FindFirstChild(player.Name)
    playerFolder:Destroy()
end)