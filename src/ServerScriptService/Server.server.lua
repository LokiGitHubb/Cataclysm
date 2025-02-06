local RS = game:GetService("ReplicatedStorage")

local modules = RS.Modules
local remotes = RS.Remotes

local Ballistics = require(modules.Ballistics)
local FX = require(modules.VisualEffects)

local random = Random.new(1234)

local bastic = Ballistics.new()
--bastic.Acceleration = Vector3.yAxis * -workspace.Gravity

remotes.Fire.OnServerEvent:Connect(function(player:Player,origin:Vector3, direction:Vector3)
	local character = player.Character
	if not character then return; end
	
	local tool = character:FindFirstChildOfClass("Tool")
	if not tool then return; end
	
	local weaponData = tool:FindFirstChild("WeaponSettings")
	if not weaponData then return; end
	weaponData = require(weaponData)
	
	local directionCF = CFrame.new(Vector3.zero, direction)
	local spreadDir = (directionCF * CFrame.fromOrientation(0, 0, random:NextNumber(0, math.pi * 2)) * CFrame.fromOrientation(math.rad(random:NextNumber(weaponData.MinSpread, weaponData.MaxSpread)), 0, 0)).LookVector
	
	bastic:Fire({Player = player, WeaponData = weaponData}, origin, direction, weaponData.MuzzleVelocity)
	remotes.Fire:FireAllClients(player, origin, direction, weaponData.MuzzleVelocity)
end)

bastic.Hit.Event:Connect(function(raycastResult:RaycastResult, userData:{[any]:any}?)
	local hitPart = raycastResult.Instance
	local hitPoint = raycastResult.Position
	local normal = raycastResult.Normal
	
	if hitPart ~= nil and hitPart.Parent ~= nil then
		local humanoid = hitPart.Parent:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid:TakeDamage(userData.WeaponData.Damage)
		end
	end
end)