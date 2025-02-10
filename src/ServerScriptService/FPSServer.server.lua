local RS = game:GetService("ReplicatedStorage")

local modules = RS.Modules
local remotes = RS.Remotes
local playerData = RS.PlayerData

local Ballistics = require(modules.Ballistics)

local random = Random.new(1234)

local bastic = Ballistics.new()
--bastic.Acceleration = Vector3.yAxis * -workspace.Gravity

remotes.Fire.OnServerEvent:Connect(function(player:Player,origin:Vector3, direction:Vector3)
    local playerData = playerData:FindFirstChild(player.Name)

	local character = player.Character
	if not character then return; end
	
	local tool = character:FindFirstChildOfClass("Tool")
	if not tool then return; end
	
	local weaponData = tool:FindFirstChild("WeaponSettings")
	if not weaponData then return; end
	weaponData = require(weaponData)

    local gunFolder = playerData:FindFirstChild(weaponData.Name)
    local ammo = gunFolder.Ammo
	
    if ammo.Value <= 0 then return; end

    local directionCF = CFrame.new(Vector3.zero, direction)
    local spreadDir = (directionCF * CFrame.fromOrientation(0, 0, random:NextNumber(0, math.pi * 2)) * CFrame.fromOrientation(math.rad(random:NextNumber(weaponData.MinSpread, weaponData.MaxSpread)), 0, 0)).LookVector
    
    bastic:Fire({Player = player, WeaponData = weaponData}, origin, spreadDir, weaponData.MuzzleVelocity)
    ammo.Value -= 1
    remotes.Fire:FireAllClients(player, origin, spreadDir, weaponData.MuzzleVelocity) 
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