--!strict
local run  = game:GetService("RunService")

local Ballistics = {}
Ballistics.__index = Ballistics

type self = {
	Acceleration:Vector3,
	
	CosmeticBullet:BasePart,
	CosmeticBulletContainer:Instance,
	RayParams:RaycastParams,
	MaxDist:number,
	
	Hit:BindableEvent
}

export type Ballistics = typeof(setmetatable({{} :: self, Ballistics}))

function Ballistics.new(): Ballistics
	local self = setmetatable({} :: self, Ballistics)
	
	self.Acceleration = Vector3.zero
	
	self.CosmeticBullet = nil
	self.CosmeticBulletContainer = nil
	self.RayParams = RaycastParams.new()
	self.MaxDist = 1000
	
	self.Hit = Instance.new("BindableEvent")
	
	return self
end

function Ballistics.Fire(self:Ballistics, userData:{[any]:any}?, origin:Vector3, direction:Vector3, velocity:number)
	local bulletVelocity = Vector3.new(0, 0, -velocity)
	local cframe = CFrame.new(origin, origin + direction)
	local prevCframe = cframe
	local direction = CFrame.new(prevCframe.Position, cframe.Position)
	
	local bullet = self.CosmeticBullet and self.CosmeticBullet:Clone()
	if bullet then
		bullet.CFrame = cframe
		bullet.Parent = self.CosmeticBulletContainer and self.CosmeticBulletContainer or workspace
	end
	
	local connection; connection = run.Heartbeat:Connect(function(dt:number)
		bulletVelocity += self.Acceleration * dt
		cframe *= CFrame.new(bulletVelocity * dt)
		direction = CFrame.new(prevCframe.Position, cframe.Position)
		
		local raycastResult = workspace:Raycast(prevCframe.Position, (cframe.Position - prevCframe.Position), self.RayParams)
		if raycastResult  then
			connection:Disconnect()
			self.Hit:Fire(raycastResult, userData);
			
			if bullet then bullet:Destroy(); end
		end
		
		if (cframe.Position - origin).Magnitude > self.MaxDist then
			connection:Disconnect()
			if bullet then bullet:Destroy(); end
		end
		
		if bullet then bullet.CFrame = direction; end
		prevCframe = cframe
	end)
end

return Ballistics
