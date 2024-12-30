local GameCamera = {}
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local Spring = require(Modules:WaitForChild("Spring"))
local UserInputService = game:GetService("UserInputService")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local ViewmodelRemotes = Remotes:WaitForChild("GameCamera")
local PlayViewmodelAnim = ViewmodelRemotes:WaitForChild("playAnimation")
local StopViewmodelAnim = ViewmodelRemotes:WaitForChild("stopAnimation")
GameCamera.__index = GameCamera

export type GameCamera = {
	Camera: Camera,
	Player: Player,
	bobbingSpeed: number,
	tiltSpeed: number,
	viewModelUpdate: RBXScriptConnection,
	animationConnections: { RBXScriptConnection },
	cameraUpdateConnection: RBXScriptConnection,
	Character: Model,
	ViewModel: Model,
	bobbleSpring: any,
	swaySpring: any,
	recoilSpring: any,
	resume: (self: GameCamera) -> nil,
	reconnectEffects: (self:GameCamera) -> nil,
}

local function getBobbing(addition)
	return math.sin(tick() * addition * 1.3) * 0.5
end

local function lerp(a, b, t)
	local value = a + (b - a) * t
	return value
end

function GameCamera.create(bobbingSpeed, tiltSpeed)
	local self: GameCamera = setmetatable({} :: any, GameCamera) :: GameCamera
	self.Camera = Workspace.CurrentCamera
	self.Player = Players.LocalPlayer
	self.bobbingSpeed = bobbingSpeed
	self.tiltSpeed = tiltSpeed
	local Character = self.Player.Character
	Character.Archivable = true
	local NewViewModel = self.Player.Character :: Model
	NewViewModel.Archivable = true
	NewViewModel = NewViewModel:Clone()
	local Humanoid = NewViewModel:WaitForChild("Humanoid") :: Humanoid
	Humanoid.EvaluateStateMachine = false
	self.ViewModel = NewViewModel
	for _, part in pairs(NewViewModel:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = false
			part.Anchored = false
			if not part:IsAncestorOf(NewViewModel:WaitForChild("Left Arm")) or not part:IsAncestorOf("Right Arm") then
				part.Transparency = 1
			end
		end
	end
	NewViewModel["Left Arm"].Transparency = 0
	NewViewModel["Right Arm"].Transparency = 0
	self.bobbleSpring = Spring.new()
	self.swaySpring = Spring.new()
	self.recoilSpring = Spring.new()
	self.animationConnections = {}
	print("CREATED GAME CAMERA")
	return self
end

function GameCamera.resume(self: GameCamera)
	print("RESUMING / STARTING GAME CAMERA")
	for _, newInstance: BasePart in pairs(self.ViewModel:GetDescendants() :: any) do
		if newInstance:IsA("BasePart") then
			newInstance.CanCollide = false
		end
	end
	self.ViewModel.Parent = self.Camera
	self.Character = self.Player.Character :: Model
	local primaryPart = self.Character.PrimaryPart
	local camera = self.Camera
	local characterHumanoid = self.Character:WaitForChild("Humanoid") :: Humanoid
	local tiltSpeed = self.tiltSpeed
	local bobbingSpeed = self.bobbingSpeed
	local ViewmodelPrimary = self.ViewModel.PrimaryPart
	local ViewmodelHumanoid = self.ViewModel:WaitForChild("Humanoid")
	local Player = self.Player
	Player.CameraMode = Enum.CameraMode.LockFirstPerson
	self.Camera.CameraSubject = self.Character:WaitForChild("Humanoid") :: any
	local ViewModelAnimator = ViewmodelHumanoid:WaitForChild("Animator") :: Animator

	local previousSineX = 0
	local previousSineY = 0
	local BodyColors = self.Character:WaitForChild("Body Colors")
	BodyColors.Parent = self.ViewModel
	local tilt = 0
	local sinValue = 0
	local function calculateSine(speed, intensity)
		sinValue += speed
		if sinValue > (math.pi * 2) then
			sinValue = 0
		end
		local sineY = intensity * math.sin(2 * sinValue)
		local sineX = intensity * math.sin(sinValue)
		local sineCFrame = CFrame.new(sineX, sineY, 0)
		return sineCFrame
	end
	self.cameraUpdateConnection = RunService.RenderStepped:Connect(function()
		local movementVector =
			camera.CFrame:VectorToObjectSpace(primaryPart.Velocity / math.max(characterHumanoid.WalkSpeed, 0.01))
		local speedModifier = (characterHumanoid.WalkSpeed / 16)
		tilt = math.clamp(lerp(tilt, movementVector.X * self.tiltSpeed, 0.1), -0.05, 0.1) / 2
		local sineCFrame = calculateSine(self.bobbingSpeed * speedModifier, movementVector.Z * speedModifier / 2)
		local lerpedSineX = lerp(previousSineX, sineCFrame.X, 0.1)
		local lerpedSineY = lerp(previousSineY, sineCFrame.Y, 0.1)

		camera.CFrame *= CFrame.Angles(0, 0, 0) * CFrame.new(lerpedSineX, lerpedSineY, 0)
		previousSineX = lerpedSineX
		previousSineY = lerpedSineY
	end)

	self.viewModelUpdate = RunService.RenderStepped:Connect(function(deltaTime)
		if not self.ViewModel.PrimaryPart then
			self.ViewModel:Destroy()
			self.ViewModel = ReplicatedStorage:WaitForChild("ViewModel"):Clone()
			BodyColors = self.Character:WaitForChild("Body Colors"):Clone()
			BodyColors.Parent = self.ViewModel
			self.ViewModel.Parent = camera
		end
		local VMTorso = self.ViewModel:WaitForChild("Torso")
		VMTorso.CanCollide = false
		ViewmodelPrimary.CFrame = camera.CFrame
		local bobble = Vector3.new(getBobbing(1), getBobbing(1), getBobbing(1))
		local mouseDelta = UserInputService:GetMouseDelta()
		self.swaySpring:shove(Vector3.new(-mouseDelta.X / 500, mouseDelta.Y / 200, 0))
		self.bobbleSpring:shove(bobble / 50 * primaryPart.Velocity.Magnitude / 50)

		local updatedBobbleSpring = self.bobbleSpring:update(deltaTime)
		local updatedSwaySpring = self.swaySpring:update(deltaTime)
		local updatedRecoilSpring = self.recoilSpring:update(deltaTime)
		ViewmodelPrimary.CFrame *= CFrame.Angles(math.rad(updatedRecoilSpring.X) * 2, 0, 0)
		camera.CFrame *= CFrame.Angles(
			math.rad(updatedRecoilSpring.X),
			math.rad(updatedRecoilSpring.Y),
			math.rad(updatedRecoilSpring.Z)
		)
		ViewmodelPrimary.CFrame =
			ViewmodelPrimary.CFrame:ToWorldSpace(CFrame.new(updatedBobbleSpring.Y, updatedBobbleSpring.X, 0))
		ViewmodelPrimary.CFrame *= CFrame.new(updatedSwaySpring.X, updatedSwaySpring.Y, 0)
	end)
	local playingTrack = nil
	table.insert(
		self.animationConnections,
		PlayViewmodelAnim.OnClientEvent:Connect(function(name)
			if playingTrack then
				playingTrack:Stop()
			end
			local vmAnim = ReplicatedStorage.Animations.ViewmodelAnimations:FindFirstChild(name)
			if vmAnim then
				local track = ViewModelAnimator:LoadAnimation(vmAnim)
				track:Play()
				playingTrack = track
			end
		end)
	)
	table.insert(
		self.animationConnections,
		StopViewmodelAnim.OnClientEvent:Connect(function()
			if playingTrack then
				playingTrack:Stop()
			end
			playingTrack = nil
		end)
	)
end

function GameCamera.reconnectEffects(self: GameCamera)
	if self.cameraUpdateConnection then
		self.cameraUpdateConnection:Disconnect()
	end
	local camera = self.Camera
	local Character = self.Character
	local primaryPart = Character.PrimaryPart
	local characterHumanoid = Character:WaitForChild("Humanoid")
	local tilt = 0
	local sinValue = 0
	local function calculateSine(speed, intensity)
		sinValue += speed
		if sinValue > (math.pi * 2) then
			sinValue = 0
		end
		local sineY = intensity * math.sin(2 * sinValue)
		local sineX = intensity * math.sin(sinValue)
		local sineCFrame = CFrame.new(sineX, sineY, 0)
		return sineCFrame
	end
	local previousSineX = 0
	local previousSineY = 0
	self.cameraUpdateConnection = RunService.RenderStepped:Connect(function()
		local movementVector =
			camera.CFrame:VectorToObjectSpace(primaryPart.Velocity / math.max(characterHumanoid.WalkSpeed, 0.01))
		local speedModifier = (characterHumanoid.WalkSpeed / 16)
		tilt = math.clamp(lerp(tilt, movementVector.X * self.tiltSpeed, 0.1), -0.05, 0.1) / 2
		local sineCFrame = calculateSine(self.bobbingSpeed * speedModifier, movementVector.Z * speedModifier / 2)
		local lerpedSineX = lerp(previousSineX, sineCFrame.X, 0.1)
		local lerpedSineY = lerp(previousSineY, sineCFrame.Y, 0.1)

		camera.CFrame *= CFrame.Angles(0, 0, 0) * CFrame.new(lerpedSineX, lerpedSineY, 0)
		previousSineX = lerpedSineX
		previousSineY = lerpedSineY
	end)
end

return GameCamera
