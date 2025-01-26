--!strict
local ServerStorage = game:GetService("ServerStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Classes = ServerStorage:WaitForChild("Classes")
local CharacterClass = require(Classes:WaitForChild("CharacterClasses"))
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local RegisterEvent = Remotes:WaitForChild("RegisterDoubleJumper") :: RemoteEvent
local RegisterButtonBinding = Remotes:WaitForChild("RegisterButtonBinding") :: RemoteEvent
local RegisterButtonEnded = Remotes:WaitForChild("RegisterInputEnded")
local StartDropKick = Remotes:WaitForChild("StartChargerDK")
local EndDropKick = Remotes:WaitForChild("EndChargerDK")
local startGameCamera = Remotes:WaitForChild("StartBobbing")
local Packets = require(ReplicatedStorage:WaitForChild("Packet"))
local updateChargerPercentage = Packets["UpateChargerPercentage"]
local Lighting = game:GetService("Lighting")
local PercentUpdateTask:thread = nil
local autoStopThead:thread = nil

return function(Class: CharacterClass.CharacterClass)
	local Player = Class.Player
	local Character = Class.Character
	local VelocityObject: BodyPosition
	local UpdateConnection: RBXScriptConnection
	RegisterEvent:FireClient(Player)
	local ForceTween: Tween
	local TINfo = TweenInfo.new(4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
	local deaccelerationTI = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
	local UpdateTI = TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
	local Audio = Character:WaitForChild("Torso"):WaitForChild("ChargeSound")::Sound
	local function StopDropkick(PlayerIncoming:Player)
		if PlayerIncoming == Player then
			Audio:Stop()
			Remotes.ResetDropkick:FireClient(PlayerIncoming)
			Remotes.ChargerGreenFlash:FireClient(PlayerIncoming, false)
			print("stopping dropkick")
			if PercentUpdateTask then
				task.cancel(PercentUpdateTask)
			end
			local PropertyTable = {
				["MaxForce"] = Vector3.zero,
				["P"] = 0
			}
			local SlowdownTween = TweenService:Create(VelocityObject, deaccelerationTI, PropertyTable)
			SlowdownTween:Play()
			
			task.wait(0.5)
			startGameCamera:FireClient(Player)
			if UpdateConnection then
				UpdateConnection:Disconnect()
			end
			if VelocityObject then
				VelocityObject:Destroy()
			end
			if ForceTween and ForceTween.PlaybackState == Enum.PlaybackState.Playing then
				ForceTween:Cancel()
			end
			updateChargerPercentage.sendTo(0, PlayerIncoming)
		end
	end
	StartDropKick.OnServerEvent:Connect(function(PlayerIncoming:Player)
		if PlayerIncoming == Player then
			Audio.TimePosition = 0
			Audio:Play()
			print("Starting Dropkick")
			local DamagePercentage = 0
			
			PercentUpdateTask = task.spawn(function()
				for _ = 1, 100 do
					DamagePercentage += 1
					updateChargerPercentage.sendTo(DamagePercentage, PlayerIncoming)
					task.wait(0.05)
				end
			end)
			if UpdateConnection then
				UpdateConnection:Disconnect()
			end
			if VelocityObject then
				VelocityObject:Destroy()
			end
			if ForceTween then
				ForceTween:Cancel()
			end
			Remotes.ChargerGreenFlash:FireClient(PlayerIncoming, true)
			VelocityObject = Instance.new("BodyPosition")
			VelocityObject.Parent = Character.PrimaryPart
			local Params = RaycastParams.new()
			Params.FilterType = Enum.RaycastFilterType.Exclude
			Params.FilterDescendantsInstances = { Character }
			local UpdateTween:Tween
			UpdateConnection = RunService.Heartbeat:Connect(function()
				local PositionToGo
				local HumanoidRootPart = Character.PrimaryPart::BasePart
				local NewPosition = HumanoidRootPart.CFrame + HumanoidRootPart.CFrame.LookVector * 40
				local RaycastPosition = HumanoidRootPart.CFrame + HumanoidRootPart.CFrame.LookVector
				local RaycastResult = Workspace:Raycast(HumanoidRootPart.Position, RaycastPosition.Position, Params)
				PositionToGo = NewPosition.Position
				local PropertyTable = {
					["Position"] = PositionToGo
				}
				print("Running")
				UpdateTween = TweenService:Create(VelocityObject, UpdateTI, PropertyTable)
				UpdateTween:Play()
				task.wait(0.85)
			end)
			VelocityObject.MaxForce = Vector3.zero
			VelocityObject.P = 0
			local PropertyTable = {
				["MaxForce"] = Vector3.new(50000, 10, 50000),
				["P"] = 5250
			}
			autoStopThead = task.spawn(function()
				Remotes.StartFillingBar:FireClient(PlayerIncoming)
				task.wait(8)
				StopDropkick(PlayerIncoming)
				
				if autoStopThead then
					task.cancel(autoStopThead)
				end
			end)
			ForceTween = TweenService:Create(VelocityObject, TINfo, PropertyTable)
			ForceTween:Play()
			task.wait(2)
			Remotes.StopBobbing:FireClient(Player)
		end
	end)
	EndDropKick.OnServerEvent:Connect(StopDropkick)
	RegisterButtonBinding:FireClient(Player, Enum.KeyCode.C, Remotes:WaitForChild("Dash"))
	RegisterButtonBinding:FireClient(Player, Enum.KeyCode.Q, StartDropKick)
	RegisterButtonEnded:FireClient(Player, Enum.KeyCode.Q, EndDropKick)
end
