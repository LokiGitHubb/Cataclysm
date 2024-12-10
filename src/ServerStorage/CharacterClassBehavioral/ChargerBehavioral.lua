local ServerStorage = game:GetService("ServerStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Classes = ServerStorage:WaitForChild("Classes")
local CharacterClass = require(Classes:WaitForChild("CharacterClasses"))
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local RegisterEvent = Remotes:WaitForChild("RegisterDoubleJumper") :: RemoteEvent
local RegisterButtonBinding = Remotes:WaitForChild("RegisterButtonBinding") :: RemoteEvent
local RegisterButtonEnded = Remotes:WaitForChild("RegisterInputEnded")
local StartDropKick = Remotes:WaitForChild("StartChargerDK")
local EndDropKick = Remotes:WaitForChild("EndChargerDK")

return function(Class: CharacterClass.CharacterClass)
	local Player = Class.Player
	local Character = Class.Character
	local VelocityObject: BodyPosition
	local UpdateConnection: RBXScriptConnection
	RegisterEvent:FireClient(Player)
	local ForceTween: Tween
	local TINfo = TweenInfo.new(5, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut)
	StartDropKick.OnServerEvent:Connect(function(PlayerIncoming)
		if PlayerIncoming == Player then
			if UpdateConnection then
				UpdateConnection:Disconnect()
			end
			if VelocityObject then
				VelocityObject:Destroy()
			end
			if ForceTween and ForceTween.PlaybackState == Enum.PlaybackState.Playing then
				ForceTween:Cancel()
			end
			VelocityObject = Instance.new("BodyPosition")
			local Params = RaycastParams.new()
			Params.FilterType = Enum.RaycastFilterType.Exclude
			Params.FilterDescendantsInstances = { Character }
			UpdateConnection = RunService.Heartbeat:Connect(function()
				local PositionToGo
				local HumanoidRootPart = Character.PrimaryPart
				local RaycastResult = Workspace:Raycast(HumanoidRootPart.Position, Vector3.new(0, 0, 20) * 5, Params)
				if RaycastResult then
					local FoundInstance = RaycastResult.Instance :: BasePart
					if FoundInstance.CanCollide == true then
						PositionToGo = RaycastResult.Position
					else
						PositionToGo = (HumanoidRootPart.CFrame + (Vector3.new(0, 0, 20) * 10)).Position
					end
				else
					PositionToGo = (HumanoidRootPart.CFrame + (Vector3.new(0, 0, 20) * 10)).Position
				end
				VelocityObject.Position = PositionToGo
			end)
			VelocityObject.MaxForce = Vector3.new(0, 0, 0)
			local PropertyTable = {
				["MaxForce"] = Vector3.new(50000, 50000, 50000),
			}
			ForceTween = TweenService:Create(VelocityObject, TINfo, PropertyTable)
		end
	end)
	EndDropKick.OnServerEvent:Connect(function(PlayerIncoming)
		if PlayerIncoming == Player then
			if UpdateConnection then
				UpdateConnection:Disconnect()
			end
			if VelocityObject then
				VelocityObject:Destroy()
			end
			if ForceTween and ForceTween.PlaybackState == Enum.PlaybackState.Playing then
				ForceTween:Cancel()
			end
		end
	end)
	RegisterButtonBinding:FireClient(Player, Enum.KeyCode.C, Remotes:WaitForChild("Dash"))
	RegisterButtonBinding:FireClient(Player, Enum.KeyCode.LeftShift, StartDropKick)
	RegisterButtonEnded:FireClient(Player, Enum.KeyCode.LeftShift, EndDropKick)
end
