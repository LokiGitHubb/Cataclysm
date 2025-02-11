local SWAY_CLAMP = 0.5
local SWAY_DIVISION = Vector3.new(500, 200, 0)
local BOB_VECTOR = Vector3.new(5, 10, 5)
local BOBBLE_INTENSITY_MULTIPLIER = 0.05

local RS = game:GetService("ReplicatedStorage")
local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local players = game:GetService("Players")

local aimAlpha = Instance.new("NumberValue")
aimAlpha.Value = 0

local function getBob(alpha:number)
	return math.sin(tick() * 2 * alpha) * 0.5
end

local MainModule = {}
MainModule.Tracks = {}
MainModule.CurrentPlaying = nil

function MainModule.updateViewmodel(viewmodel:Model, gun:Model, dt:number, recoilSpring, bobbleSpring, swaySpring)
	viewmodel.HumanoidRootPart.CFrame = workspace.CurrentCamera.CFrame
	
	local char = players.LocalPlayer.Character or players.LocalPlayer.CharacterAdded:Wait()
	
	local bobble = Vector3.new(getBob(BOB_VECTOR.X), getBob(BOB_VECTOR.Y), getBob(BOB_VECTOR.Z))
	bobbleSpring:shove(bobble * BOBBLE_INTENSITY_MULTIPLIER * math.clamp(char.HumanoidRootPart.AssemblyLinearVelocity.Magnitude, 0, 32) * BOBBLE_INTENSITY_MULTIPLIER)
	
	local mouseDelta = UIS:GetMouseDelta()
	swaySpring:shove(Vector3.new(-mouseDelta.X/SWAY_DIVISION.X, mouseDelta.Y/SWAY_DIVISION.Y, 0))

	local recoilSpring = recoilSpring:update(dt)
	local bobbleSpring = bobbleSpring:update(dt)
	local swaySpring = swaySpring:update(dt)
	
	viewmodel.HumanoidRootPart.CFrame = viewmodel.HumanoidRootPart.CFrame:ToWorldSpace(CFrame.new(bobbleSpring.X, bobbleSpring.Y, bobbleSpring.Z))
	viewmodel.HumanoidRootPart.CFrame *= CFrame.new(math.clamp(swaySpring.X, -SWAY_CLAMP, SWAY_CLAMP), math.clamp(swaySpring.Y, -SWAY_CLAMP, SWAY_CLAMP), 0)
	
	viewmodel.HumanoidRootPart.CFrame *= CFrame.Angles(math.rad(recoilSpring.X) * 2, 0, 0)
	workspace.CurrentCamera.CFrame *= CFrame.Angles(math.rad(recoilSpring.X), math.rad(recoilSpring.Y), math.rad(recoilSpring.Z))
	
	if gun then
		gun.Nodes.AimPart.CFrame = gun.Nodes.AimPart.CFrame:Lerp(viewmodel.HumanoidRootPart.CFrame, aimAlpha.Value)
	end
end

function MainModule.weldGun(gun:Model)
	local main:BasePart = gun.Nodes:FindFirstChild("Handle")
	
	for i, v in ipairs(gun:GetDescendants()) do
		if not v:IsA("BasePart") or v == main then continue; end
		
		local newMotor:Motor6D = Instance.new("Motor6D") do
			newMotor.Name = v.Name
			newMotor.Part0 = main
			newMotor.Part1 = v
			newMotor.C0 = newMotor.Part0.CFrame:Inverse() * newMotor.Part1.CFrame
			newMotor.Parent = main
		end
	end
end

function MainModule.playAnimation(viewmodel:Model, anim:Animation)
	if not MainModule.Tracks[anim] then MainModule.Tracks[anim] = viewmodel.AnimationController:LoadAnimation(anim); end
    MainModule.Tracks[anim].Looped = (anim:FindFirstChild("Looped") and anim.Looped.Value == true and true) or false
	MainModule.Tracks[anim]:Play(0)
	MainModule.CurrentlyPlaying = MainModule.Tracks[anim]
end

function MainModule.stopAnimation(viewmodel:Model)
	MainModule.CurrentlyPlaying:Stop()
	MainModule.CurrentlyPlaying = nil
end

function MainModule.equip(viewmodel:Model, gun:Model)
	local handle = gun.Nodes:FindFirstChild("Handle")
	local hrpMotor = viewmodel.HumanoidRootPart:FindFirstChild("Handle")
	
	gun.Parent = viewmodel
	hrpMotor.Part1 = handle
	
	MainModule.playAnimation(viewmodel, RS.GunAnimation:FindFirstChild(gun.Name).Hold)
end

function MainModule.aim(toaim:boolean, viewmodel:Model, gun:Model, aimTime:number)
	if toaim then
		TS:Create(aimAlpha, TweenInfo.new(aimTime), {Value = 1}):Play()
	else
		TS:Create(aimAlpha, TweenInfo.new(aimTime), {Value = 0}):Play()
	end
end

return MainModule
