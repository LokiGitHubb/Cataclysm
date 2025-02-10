local RS = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")

local playerData = RS.PlayerData

players.PlayerAdded:Connect(function(player:Player)
    local playerFolder = Instance.new("Folder")
    playerFolder.Name = player.Name
    playerFolder.Parent = playerData

    for i = 1, 2 do
        local gunFolder = Instance.new("Folder")
        gunFolder.Name = tostring(i)

        local weapon = Instance.new("StringValue")
        weapon.Name = "Weapon"
        weapon.Parent = gunFolder
        
        local ammo = Instance.new("IntValue")
        ammo.Name = "Ammo"
        ammo.Parent = gunFolder

        local maxAmmo = Instance.new("IntValue")
        maxAmmo.Name = "MaxAmmo"
        maxAmmo.Parent = gunFolder

        gunFolder.Parent = playerFolder
    end

    do
        local meleeFolder = Instance.new("Folder")
        meleeFolder.Name = "Melee"
    
        local weapon = Instance.new("StringValue")
        weapon.Name = "Weapon"
        weapon.Parent = meleeFolder
    
        meleeFolder.Parent = playerFolder 
    end
end)

players.PlayerRemoving:Connect(function(player:Player)
    local playerFolder = playerData:FindFirstChild(player.Name)
    playerFolder:Destroy()
end)