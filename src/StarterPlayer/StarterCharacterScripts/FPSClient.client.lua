local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local players = game:GetService("Players")
local run = game:GetService("RunService")
local debris = game:GetService("Debris")

local player = players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local mouse = player:GetMouse()

local modules = RS.Modules
local gunModels = RS.GunModels
local assets = RS.Assets
local remotes = RS.Remotes
local playerData = RS.PlayerData:FindFirstChild(player.Name)

local Main = require(modules.MainModule)
local Ballistics = require(modules.Ballistics)
local FX = require(modules.VisualEffects)
--local FastCast = require(modules.FastCastRedux)
local Spring = require(modules.Spring)

local playerVM = assets.Viewmodel:Clone()
playerVM.Parent = workspace.CurrentCamera
playerVM.LeftArm.Transparency = 1
playerVM.RightArm.Transparency = 1

local recoilSpring = Spring.new()
local bobbleSpring = Spring.new()
local swaySpring = Spring.new()

--local caster = FastCast.new()

local random = Random.new(1234)

local rayParams = RaycastParams.new()
rayParams.FilterDescendantsInstances = {workspace.Bullets, playerVM, char}
rayParams.FilterType = Enum.RaycastFilterType.Exclude

local bastic = Ballistics.new()
--bastic.Acceleration = Vector3.yAxis * -workspace.Gravity
bastic.CosmeticBulletContainer = workspace.Bullets
bastic.CosmeticBullet = assets.Bullet

local isLMBDown = false
local canFire = true

local gun = nil
local weaponData = nil

--equip gun
local function equipGun(tool:Tool)
    player.CameraMode = Enum.CameraMode.LockFirstPerson

	gun = gunModels:FindFirstChild(tool.Name):Clone()

	Main.weldGun(gun)
	Main.equip(playerVM, gun)
	weaponData = require(tool:WaitForChild("WeaponSettings"))
	
	playerVM.LeftArm.Transparency = 0
	playerVM.RightArm.Transparency = 0

	UIS.MouseIconEnabled = false
end

--unequip gun
local function unequipGun()
	Main.stopAnimation(playerVM)
	playerVM.LeftArm.Transparency = 1
	playerVM.RightArm.Transparency = 1

	gun.Parent = nil
	gun:Destroy()
	gun = nil
	weaponData = nil

    player.CameraMode = Enum.CameraMode.Classic
end

--main
run.RenderStepped:Connect(function(dt)
	Main.updateViewmodel(playerVM, gun, dt, recoilSpring, bobbleSpring, swaySpring)

	if isLMBDown then
		if canFire and gun and gun:FindFirstChild("Nodes") and playerData[gun.Name].Ammo.Value > 0 then
			canFire = false

			local muzzle = gun.Nodes.MuzzlePart
			local handle = gun.Nodes.Handle
			
			local origin = muzzle.Position
			local directionCF = CFrame.new(Vector3.zero, muzzle.CFrame.LookVector)
			local spreadDir = (directionCF * CFrame.fromOrientation(0, 0, random:NextNumber(0, math.pi * 2)) * CFrame.fromOrientation(math.rad(random:NextNumber(weaponData.MinSpread, weaponData.MaxSpread)), 0, 0)).LookVector

			bastic:Fire(nil, origin, spreadDir, weaponData.MuzzleVelocity)
			remotes.Fire:FireServer(origin, directionCF.LookVector)

			recoilSpring:shove(Vector3.new(weaponData.VerticalRecoil, math.random(-weaponData.HorizontalRecoil, weaponData.HorizontalRecoil), math.random(-weaponData.RotationalRecoil, weaponData.RotationalRecoil)))
			coroutine.wrap(function()
				task.wait(0.05)
				recoilSpring:shove(Vector3.new(-weaponData.VerticalRecoil, math.random(-weaponData.HorizontalRecoil, weaponData.HorizontalRecoil) * math.random(90, 110)/100, 0))
			end)()

			coroutine.wrap(function()
				for i, v in ipairs(muzzle:GetChildren()) do
					if v:IsA("ParticleEmitter") then
						v:Emit()
					end
				end

				local firesound = handle.Fire:Clone()
				firesound.PlayOnRemove = true
				firesound.Parent = muzzle
				firesound.Parent = nil
				firesound:Destroy()

				local light = handle.Flash:Clone()
				light.Enabled = true
				light.Parent = muzzle
				debris:AddItem(light, 0.05)
			end)()

			task.wait(60/weaponData.RateOfFire)
			canFire = true
		end
	end
end)

--input handling
UIS.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return; end
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		isLMBDown = true
	elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
        if not gun then return; end
		Main.aim(true, playerVM, gun, weaponData.ADSTime)
    elseif input.KeyCode == Enum.KeyCode.R then
        remotes.Reload:FireServer()
        Main.playAnimation(playerVM, RS.GunAnimation:FindFirstChild(gun.Name).Reload)
	end
end)

UIS.InputEnded:Connect(function(input, gameProcessed) 
	if gameProcessed then return; end
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		isLMBDown = false
	elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
        if not gun then return; end
		Main.aim(false, playerVM, gun, weaponData.ADSTime)
	end
end)

--tool handling
char.ChildAdded:Connect(function(child:Instance)
	if not child:IsA("Tool") then return; end
	if not gunModels:FindFirstChild(child.Name) then return; end
	equipGun(child)
end)

char.ChildRemoved:Connect(function(child:Instance)
	if gun == nil then return; end
	if child.Name ~= gun.Name then return; end
	unequipGun()
end)

--replication
remotes.Fire.OnClientEvent:Connect(function(plr:Player, origin:Vector3, direction:Vector3, velocity:number)
	if player == plr then return; end
	bastic:Fire(nil, origin, direction, velocity)
end)

bastic.Hit.Event:Connect(function(raycastResult:RaycastResult, userData:{[any]:any}?)
	FX.HitEffect({}, raycastResult.Position, raycastResult.Instance, raycastResult.Normal, raycastResult.Material)
end)

--caster.LengthChanged:Connect(function(cast, segmentOrigin, segmentDirection, length, segmentVelocity, cosmeticBulletObject)
--	if cosmeticBulletObject == nil then return end
--	local bulletLength = cosmeticBulletObject.Size.Z / 2 -- This is used to move the bullet to the right spot based on a CFrame offset
--	local baseCFrame = CFrame.new(segmentOrigin, segmentOrigin + segmentDirection)
--	cosmeticBulletObject.CFrame = baseCFrame * CFrame.new(0, 0, -(length - bulletLength))
--end)

--caster.CastTerminating:Connect(function(cast)
--	local cosmeticBullet = cast.RayInfo.CosmeticBulletObject
--	cosmeticBullet:Destroy()
--end)