local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Bytenet = require(Packages:WaitForChild("bytenet"))


return Bytenet.defineNamespace("Main", function()  
    return {
        ["UpateChargerPercentage"] = Bytenet.definePacket({
            value = Bytenet.int8
        })
    }
end)