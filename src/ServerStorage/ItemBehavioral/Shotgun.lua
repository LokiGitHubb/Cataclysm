local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local AnimationManager = require(Modules:WaitForChild("AnimationManager"))

local item = {}

item.init = function()

end

item.use = function()
    
end


item.equip = function()
   
end

item.unequip = function()
    
end

item.config = {
    ["inputType"] = "click",
    ["AnimationName"] = "Charger_ShotgunHold"
}

return item