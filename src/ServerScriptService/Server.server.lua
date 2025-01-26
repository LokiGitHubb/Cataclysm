local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local SpawnPlayer = Remotes:WaitForChild("SpawnPlayer")
local DashEvent = Remotes:WaitForChild("Dash")
local Classes = ServerStorage:WaitForChild("Classes")
local ItemClass = require(Classes:WaitForChild("ItemClass"))
local CharacterClasses = require(Classes:WaitForChild("CharacterClasses"))
local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(Player)
	if not Player:HasAppearanceLoaded() then
		Player.CharacterAppearanceLoaded:Wait()
	end
end)

local DASHDISTANCE = 20
local function DashPlayer(Player: Player)
	local Character = Player.Character
	local Humanoid = Character:WaitForChild("Humanoid") :: Humanoid
	local HumanoidRootPart = Character.PrimaryPart
	local Params = RaycastParams.new()
	Params.FilterType = Enum.RaycastFilterType.Exclude
	Params.FilterDescendantsInstances = { Character }
	local PositionToGo
	local RaycastResult =
		Workspace:Raycast(HumanoidRootPart.Position, Humanoid.MoveDirection * DASHDISTANCE, Params)
	if RaycastResult then
		local FoundInstance = RaycastResult.Instance :: BasePart
		if FoundInstance.CanCollide == true then
			PositionToGo = RaycastResult.Position
		else
			PositionToGo = (HumanoidRootPart.CFrame + (Humanoid.MoveDirection * DASHDISTANCE)).Position
		end
	else
		PositionToGo = (HumanoidRootPart.CFrame + (Humanoid.MoveDirection * DASHDISTANCE)).Position
	end
    local Force = Instance.new("BodyPosition")
    Force.MaxForce = Vector3.new(math.huge, 50, math.huge)
    Force.D = 150
    Force.P = 800
    Force.Position = PositionToGo
    Force.Parent = HumanoidRootPart
	task.delay(0.5, function() 
        Force:Destroy()
    end)
end

SpawnPlayer.OnServerEvent:Connect(function(Player, Class)
	CharacterClasses.create(Class, Player)
	local NewItem = ItemClass.create("Shotgun", Player, Enum.KeyCode.One)
	task.wait(0.5)
	NewItem:equip()
end)


DashEvent.OnServerEvent:Connect(DashPlayer)
