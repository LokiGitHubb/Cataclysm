local ServerStorage = game:GetService("ServerStorage")
local Classes = ServerStorage:WaitForChild("Classes")
local ItemClass = require(Classes:WaitForChild("ItemClass"))
local CharacterClasses = require(Classes:WaitForChild("CharacterClasses"))
local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(Player)
    if not Player:HasAppearanceLoaded() then
        Player.CharacterAppearanceLoaded:Wait()
    end
    print("CreatingCharacter")
    CharacterClasses.create("Charger", Player)
    task.wait(5)
    local NewItem = ItemClass.create("Shotgun", Player)
    NewItem:equip()
end)
