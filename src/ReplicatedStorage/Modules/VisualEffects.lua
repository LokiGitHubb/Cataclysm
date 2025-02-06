local debris 			= game:GetService("Debris")
local TS 				= game:GetService('TweenService')

local glass 			= {"4668969235"; "1565825075"; "1565824613"; "4668969774"; "4668969602"; "4668970218"; "4668970412";}
local metal 			= {"282954522"; "282954538"; "282954576"; "1565756607"; "1565756818";}
local grass 			= {"1565830611"; "1565831129"; "1565831468"; "1565832329";}
local wood 				= {"287772625"; "287772674"; "287772718"; "287772829"; "287772902";}
local concrete 			= {"287769261"; "287769348"; "287769415"; "287769483"; "287769538";}
local explosion 		= {"287390459"; "287390954"; "287391087"; "287391197"; "287391361"; "287391499"; "287391567";}
local cracks 			= {"342190504"; "342190495"; "342190488"; "342190510";} -- Bullet cracks
local hits 				= {"3744371091"; "3744371584"; "1565837588"; "1565836522"; "1565734495"; "3744371864"; "1565734259", "3744371342"} -- Player
local body 				= {"4635529646"; "4635529872"; "4635529434"; "4635529230";"363818432"; "363818488"; "363818567"; "363818611"; "363818653"} -- body Shots
local whizz 			= {"342190005"; "342190012"; "342190017"; "342190024";} -- Bullet whizz

local bloods 			= {"4117590991";"4117588426";"4117589176";"4117589687";"4117590335";}

local FX 		= {}

function FX.HitEffect(ray_Ignore, position, hitPart, normal, material, settings)
	if hitPart ~= nil then
		local attachment = Instance.new("Attachment", workspace.Terrain)
		attachment.CFrame = CFrame.new(position, position + normal)

		if hitPart.Name == "Head" or hitPart.Parent.Name == "Top" then
			local bulletWhizz = Instance.new("Sound")
			bulletWhizz.Parent = attachment
			bulletWhizz.Volume = math.random(20,30)/10
			bulletWhizz.MaxDistance = 100
			bulletWhizz.EmitterSize = 5
			bulletWhizz.PlaybackSpeed = math.random(34, 50)/40
			bulletWhizz.SoundId = "rbxassetid://" .. hits[math.random(1, #hits)]

			bulletWhizz:Play()

			local particles = Instance.new("ParticleEmitter")
			particles.Enabled = false
			particles.Color = ColorSequence.new(Color3.fromRGB(125, 0, 0))
			particles.LightEmission = 0
			particles.LightInfluence = 1
			particles.Size = NumberSequence.new(.25,2.5)
			particles.Texture = "rbxasset://textures/particles/smoke_main.dds"
			particles.Transparency = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0.5, 0);
					NumberSequenceKeypoint.new(1, 1);
				}
			)
			particles.Acceleration = Vector3.new(0, 5, 0)
			particles.Lifetime = NumberRange.new(.25, 1)
			particles.Rate = 2000
			particles.Drag = 10
			particles.RotSpeed = NumberRange.new(-150,150)
			particles.Speed = NumberRange.new(7 ,15)
			particles.VelocitySpread = math.random(2,20)
			particles.SpreadAngle = Vector2.new(-150,150)
			particles.LockedToPart = true
			particles.Parent = attachment
			particles.EmissionDirection = "Front"
			particles:Emit(50)
			debris:AddItem(attachment, particles.Lifetime.Max)


		elseif hitPart.Name == "HumanoidRootPart" or hitPart.Name == "Torso" or hitPart.Name == "UpperTorso" or hitPart.Name == "LowerTorso" or hitPart.Name == "Right Arm" or hitPart.Name == "Left Arm" or hitPart.Name == "Right Leg" or hitPart.Name == "Left Leg" or hitPart.Name == "RightUpperArm" or hitPart.Name == "RightLowerArm" or hitPart.Name == "RightHand" or hitPart.Name == "LeftUpperArm" or hitPart.Name == "LeftLowerArm" or hitPart.Name == "LeftHand" or hitPart.Name == "RightUpperLeg" or hitPart.Name == "RightLowerLeg" or hitPart.Name == "RightFoot" or hitPart.Name == "LeftUpperLeg" or hitPart.Name == "LeftLowerLeg" or hitPart.Name == "LeftFoot" or hitPart.Parent.Name == "Chest" or hitPart.Parent.Name == "Back" then

			local bulletWhizz = Instance.new("Sound")
			bulletWhizz.Parent = attachment
			bulletWhizz.Volume = math.random(20,30)/10
			bulletWhizz.MaxDistance = 100
			bulletWhizz.EmitterSize = 5
			bulletWhizz.PlaybackSpeed = math.random(34, 46)/40
			bulletWhizz.SoundId = "rbxassetid://" .. body[math.random(1, #body)]

			bulletWhizz:Play()

			local particles = Instance.new("ParticleEmitter")
			particles.Enabled = false
			particles.Color = ColorSequence.new(Color3.fromRGB(125, 0, 0))
			particles.LightEmission = 0
			particles.LightInfluence = 1
			particles.Size = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0.5, 0);
					NumberSequenceKeypoint.new(1, 2);
				})
			particles.Texture = "rbxasset://textures/particles/smoke_main.dds"
			particles.Transparency = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0.5, 0);
					NumberSequenceKeypoint.new(1, 1);
				}
			)
			particles.Acceleration = Vector3.new(0, 0, 0)
			particles.Lifetime = NumberRange.new(.5, 1)
			particles.Rate = 500
			particles.Drag = 10
			particles.Rotation = NumberRange.new(-360,360)
			particles.RotSpeed = NumberRange.new(-100,100)
			particles.Speed = NumberRange.new(-25 ,10)
			particles.VelocitySpread = math.random(2,20)
			particles.SpreadAngle = Vector2.new(25,25)
			particles.LockedToPart = true
			particles.Parent = attachment
			particles.EmissionDirection = "Front"
			particles:Emit(25)
			debris:AddItem(attachment, particles.Lifetime.Max)


		elseif  hitPart.Parent:IsA('Accessory') then
			local bulletWhizz = Instance.new("Sound")
			bulletWhizz.Parent = attachment
			bulletWhizz.Volume = math.random(20,30)/10
			bulletWhizz.MaxDistance = 100
			bulletWhizz.EmitterSize = 5
			bulletWhizz.PlaybackSpeed = math.random(34, 50)/40
			bulletWhizz.SoundId = "rbxassetid://" .. hits[math.random(1, #hits)]

			bulletWhizz:Play()

			local particles = Instance.new("ParticleEmitter")
			particles.Enabled = false
			particles.Color = ColorSequence.new(Color3.fromRGB(125, 0, 0))
			particles.LightEmission = 0
			particles.LightInfluence = 1
			particles.Size = NumberSequence.new(0,2.5)
			particles.Texture = "rbxasset://textures/particles/smoke_main.dds"
			particles.Transparency = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0, 0);
					NumberSequenceKeypoint.new(1, 1);
				}
			)
			particles.Acceleration = Vector3.new(0, 0, 0)
			particles.Lifetime = NumberRange.new(.5, .5)
			particles.Rate = 2000
			particles.RotSpeed = NumberRange.new(-350,350)
			particles.Speed = NumberRange.new(2 ,7)
			particles.SpreadAngle = Vector2.new(-380,380)
			particles.LockedToPart = true
			particles.Parent = attachment
			particles.EmissionDirection = "Front"
			particles:Emit(25)
			debris:AddItem(attachment, particles.Lifetime.Max)


		elseif  hitPart.Name == "Glass" then
			local bulletWhizz = Instance.new("Sound")
			bulletWhizz.Parent = attachment
			bulletWhizz.Volume = math.random(20,30)/10
			bulletWhizz.MaxDistance = 100
			bulletWhizz.EmitterSize = 5
			bulletWhizz.PlaybackSpeed = math.random(32, 60)/40
			bulletWhizz.SoundId = "rbxassetid://" .. glass[math.random(1, #glass)]

			bulletWhizz:Play()

			local bg = Instance.new("BillboardGui", attachment)
			bg.Adornee = attachment
			local flashsize = math.random(10, 15)/10
			bg.Size = UDim2.new(flashsize, 0, flashsize, 0)
			local flash = Instance.new("ImageLabel", bg)
			flash.BackgroundTransparency = 1
			flash.Size = UDim2.new(0.05, 0, 0.05, 0)
			flash.Position = UDim2.new(0.5, 0, 0.5, 0)
			flash.Image = "http://www.roblox.com/asset/?id=5984841909"
			flash.ImageTransparency = math.random(0, .5)
			flash.Rotation = math.random(0, 360)
			flash:TweenSizeAndPosition(UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.1)	
			debris:AddItem(bg, 0.1)
			hitPart:Destroy()

		--elseif hitPart.Name == "DoorHinge" and settings.CanBreachDoor == true then
		--	local DoorModel = hitPart.Parent


		--	local bulletWhizz = Instance.new("Sound")
		--	bulletWhizz.Parent = attachment
		--	bulletWhizz.Volume = math.random(20,30)/10
		--	bulletWhizz.MaxDistance = 100
		--	bulletWhizz.EmitterSize = 5
		--	bulletWhizz.PlaybackSpeed = math.random(38, 58)/40
		--	bulletWhizz.SoundId = "rbxassetid://" .. metal[math.random(1, #metal)]

		--	bulletWhizz:Play()

		--	local particles = Instance.new("ParticleEmitter")
		--	particles.Color = ColorSequence.new(Color3.fromRGB(255, 150, 0))
		--	particles.LightEmission = 1
		--	particles.LightInfluence = 0
		--	particles.Texture = "rbxasset://textures/particles/sparkles_main.dds"
		--	particles.Size = NumberSequence.new(
		--		{
		--			NumberSequenceKeypoint.new(0, 0.25, 0);
		--			NumberSequenceKeypoint.new(1, 0.1);
		--		}
		--	)
		--	particles.Acceleration = Vector3.new(0, -50, 0)
		--	particles.Lifetime = NumberRange.new(0.15 - 0.05, 0.15 + 0.5)
		--	particles.Rate = 1000
		--	particles.Drag = 10
		--	particles.RotSpeed = NumberRange.new(360)
		--	particles.Speed = NumberRange.new(50 - 25, 50 + 25)
		--	particles.VelocitySpread = math.random(5,20)
		--	particles.Parent = attachment
		--	particles.EmissionDirection = "Front"
		--	delay(.1,function()
		--		particles.Enabled = false
		--		debris:AddItem(attachment, particles.Lifetime.Max)
		--	end)
		--	local bg = Instance.new("BillboardGui", attachment)
		--	bg.Adornee = attachment
		--	local flashsize = math.random(15, 30)/10
		--	bg.Size = UDim2.new(flashsize, 0, flashsize, 0)
		--	local flash = Instance.new("ImageLabel", bg)
		--	flash.BackgroundTransparency = 1
		--	flash.Size = UDim2.new(0.05, 0, 0.05, 0)
		--	flash.Position = UDim2.new(0.45, 0, 0.45, 0)
		--	flash.Image = "http://www.roblox.com/asset/?id=233113663"
		--	flash.ImageTransparency = math.random(0, .5)
		--	flash.Rotation = math.random(0, 360)
		--	flash:TweenSizeAndPosition(UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.15)	
		--	debris:AddItem(bg, 0.07)


		--	hitPart:Destroy()
		--	if DoorModel:FindFirstChild("DoorHinge") == nil then
		--		DoorModel.Hinge:Destroy()
		--	end

		--elseif hitPart.Name == "Knob" and settings.CanBreachDoor == true then
		--	local bulletWhizz = Instance.new("Sound")
		--	bulletWhizz.Parent = attachment
		--	bulletWhizz.Volume = math.random(20,30)/10
		--	bulletWhizz.MaxDistance = 100
		--	bulletWhizz.EmitterSize = 5
		--	bulletWhizz.PlaybackSpeed = math.random(38, 58)/40
		--	bulletWhizz.SoundId = "rbxassetid://" .. metal[math.random(1, #metal)]

		--	bulletWhizz:Play()

		--	local particles = Instance.new("ParticleEmitter")
		--	particles.Color = ColorSequence.new(Color3.fromRGB(255, 150, 0))
		--	particles.LightEmission = 1
		--	particles.LightInfluence = 0
		--	particles.Texture = "rbxasset://textures/particles/sparkles_main.dds"
		--	particles.Size = NumberSequence.new(
		--		{
		--			NumberSequenceKeypoint.new(0, 0.25, 0);
		--			NumberSequenceKeypoint.new(1, 0.1);
		--		}
		--	)
		--	particles.Acceleration = Vector3.new(0, -50, 0)
		--	particles.Lifetime = NumberRange.new(0.15 - 0.05, 0.15 + 0.5)
		--	particles.Rate = 1000
		--	particles.Drag = 10
		--	particles.RotSpeed = NumberRange.new(-360,360)
		--	particles.Speed = NumberRange.new(50 - 25, 50 + 25)
		--	particles.VelocitySpread = math.random(5,20)
		--	particles.Parent = attachment
		--	particles.EmissionDirection = "Front"
		--	delay(.1,function()
		--		particles.Enabled = false
		--		debris:AddItem(attachment, particles.Lifetime.Max)
		--	end)
		--	local bg = Instance.new("BillboardGui", attachment)
		--	bg.Adornee = attachment
		--	local flashsize = math.random(15, 30)/10
		--	bg.Size = UDim2.new(flashsize, 0, flashsize, 0)
		--	local flash = Instance.new("ImageLabel", bg)
		--	flash.BackgroundTransparency = 1
		--	flash.Size = UDim2.new(0.05, 0, 0.05, 0)
		--	flash.Position = UDim2.new(0.45, 0, 0.45, 0)
		--	flash.Image = "http://www.roblox.com/asset/?id=233113663"
		--	flash.ImageTransparency = math.random(0, .5)
		--	flash.Rotation = math.random(0, 360)
		--	flash:TweenSizeAndPosition(UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.15)	
		--	debris:AddItem(bg, 0.07)


		--	local DoorModel = hitPart
		--	if DoorModel.Parent:FindFirstChild("Hinge") ~= nil then
		--		DoorModel.Parent.Hinge.HingeConstraint.ActuatorType = Enum.ActuatorType.Motor
		--	end
		--	hitPart:Destroy()

		elseif material == Enum.Material.Concrete or material == Enum.Material.Slate or material == Enum.Material.Cobblestone or material == Enum.Material.Brick or material == Enum.Material.Granite or material == Enum.Material.Basalt or material == Enum.Material.Rock or material == Enum.Material.CrackedLava or material == Enum.Material.Limestone or material == Enum.Material.Asphalt or material == Enum.Material.Sandstone then
			local bulletWhizz = Instance.new("Sound")
			bulletWhizz.Parent = attachment
			bulletWhizz.Volume = math.random(20,30)/10
			bulletWhizz.MaxDistance = 100
			bulletWhizz.EmitterSize = 5
			bulletWhizz.PlaybackSpeed = math.random(38, 46)/40
			bulletWhizz.SoundId = "rbxassetid://" .. concrete[math.random(1, #concrete)]

			bulletWhizz:Play()	

			local particles = Instance.new("ParticleEmitter")
			particles.Enabled = false
			particles.Color = ColorSequence.new(Color3.new(50, 50, 50))
			particles.LightEmission = 0
			particles.LightInfluence = 1
			particles.Size = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0.1, 0.1);
					NumberSequenceKeypoint.new(1, 2);
				}
			)
			particles.Texture = "rbxasset://textures/particles/smoke_main.dds"
			particles.Transparency = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0.75, 0);
					NumberSequenceKeypoint.new(1, 1);
				}
			)
			particles.Acceleration = Vector3.new(0, 0, 0)
			particles.Lifetime = NumberRange.new(0.5, 1)
			particles.Rate = 1000
			particles.Drag = 20
			particles.RotSpeed = NumberRange.new(-360,360)
			particles.Speed = NumberRange.new(15,30)
			particles.SpreadAngle = Vector2.new(180,360)
			particles.Parent = attachment
			particles.EmissionDirection = "Front"
			particles:Emit(50)

			debris:AddItem(attachment, particles.Lifetime.Max)

			local bg = Instance.new("BillboardGui", attachment)
			bg.Adornee = attachment
			local flashsize = math.random(10, 15)/10
			bg.Size = UDim2.new(flashsize, 0, flashsize, 0)
			local flash = Instance.new("ImageLabel", bg)
			flash.BackgroundTransparency = 1
			flash.Size = UDim2.new(0.05, 0, 0.05, 0)
			flash.Position = UDim2.new(0.5, 0, 0.5, 0)
			flash.Image = "http://www.roblox.com/asset/?id=476778304"
			flash.ImageTransparency = math.random(0, .5)
			flash.Rotation = math.random(0, 360)
			flash:TweenSizeAndPosition(UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.1)	
			debris:AddItem(bg, 0.1)

		elseif material == Enum.Material.Wood or material == Enum.Material.WoodPlanks then
			local bulletWhizz = Instance.new("Sound")
			bulletWhizz.Parent = attachment
			bulletWhizz.Volume = math.random(20,30)/10
			bulletWhizz.MaxDistance = 100
			bulletWhizz.EmitterSize = 5
			bulletWhizz.PlaybackSpeed = math.random(38, 50)/40
			bulletWhizz.SoundId = "rbxassetid://" .. wood[math.random(1, #wood)]

			bulletWhizz:Play()

			local particles = Instance.new("ParticleEmitter")
			particles.Enabled = false
			particles.Color = ColorSequence.new(hitPart.Color)
			particles.LightEmission = 0
			particles.LightInfluence = 1
			particles.Size = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0.25, 0);
					NumberSequenceKeypoint.new(1, .25);
				}
			)
			particles.Texture = "http://www.roblox.com/asset/?id=434255560"
			particles.Transparency = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0, 0);
					NumberSequenceKeypoint.new(1, 1);
				}
			)
			particles.Acceleration = Vector3.new(0, -50, 0)
			particles.Lifetime = NumberRange.new(0.5 - 0.05, 0.5 + 0.05)
			particles.Rate = 100
			particles.Drag = 5
			particles.RotSpeed = NumberRange.new(-360,360)
			particles.Speed = NumberRange.new(35 - 5, 35 + 5)
			particles.VelocitySpread = 50
			particles.Parent = attachment
			particles.EmissionDirection = "Front"
			particles:Emit(10)
			debris:AddItem(attachment, particles.Lifetime.Max)

			local bg = Instance.new("BillboardGui", attachment)
			bg.Adornee = attachment
			local flashsize = math.random(10, 15)/10
			bg.Size = UDim2.new(flashsize, 0, flashsize, 0)
			local flash = Instance.new("ImageLabel", bg)
			flash.BackgroundTransparency = 1
			flash.Size = UDim2.new(0.05, 0, 0.05, 0)
			flash.Position = UDim2.new(0.5, 0, 0.5, 0)
			flash.Image = "http://www.roblox.com/asset/?id=476778304"
			flash.ImageTransparency = math.random(0, .5)
			flash.Rotation = math.random(0, 360)
			flash:TweenSizeAndPosition(UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.1)	
			debris:AddItem(bg, 0.1)


		elseif material == Enum.Material.Fabric then
			local bulletWhizz = Instance.new("Sound")
			bulletWhizz.Parent = attachment
			bulletWhizz.Volume = math.random(20,30)/10
			bulletWhizz.MaxDistance = 100
			bulletWhizz.EmitterSize = 5
			bulletWhizz.PlaybackSpeed = math.random(38, 50)/40
			bulletWhizz.SoundId = "rbxassetid://" .. grass[math.random(1, #grass)]

			bulletWhizz:Play()

			local particles = Instance.new("ParticleEmitter")
			particles.Enabled = false
			particles.Color = ColorSequence.new(hitPart.Color)
			particles.LightEmission = 0
			particles.LightInfluence = 1
			particles.Size = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0.1, 0.1);
					NumberSequenceKeypoint.new(1, 5);
				}
			)
			particles.Texture = "rbxasset://textures/particles/smoke_main.dds"
			particles.Transparency = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0.75, 0);
					NumberSequenceKeypoint.new(1, 1);
				}
			)
			particles.Acceleration = Vector3.new(0, 0, 0)
			particles.Lifetime = NumberRange.new(0.9 - 0.05, 0.9 + 0.05)
			particles.Rate = 200
			particles.Drag = 100
			particles.RotSpeed = NumberRange.new(-360,360)
			particles.Speed = NumberRange.new(35 - 5, 35 + 5)
			particles.VelocitySpread = 100
			particles.Parent = attachment
			particles.EmissionDirection = "Front"
			particles:Emit(50)

			debris:AddItem(attachment, particles.Lifetime.Max)

			local bg = Instance.new("BillboardGui", attachment)
			bg.Adornee = attachment
			local flashsize = math.random(10, 15)/10
			bg.Size = UDim2.new(flashsize, 0, flashsize, 0)
			local flash = Instance.new("ImageLabel", bg)
			flash.BackgroundTransparency = 1
			flash.Size = UDim2.new(0.05, 0, 0.05, 0)
			flash.Position = UDim2.new(0.5, 0, 0.5, 0)
			flash.Image = "http://www.roblox.com/asset/?id=476778304"
			flash.ImageTransparency = math.random(0, .5)
			flash.Rotation = math.random(0, 360)
			flash:TweenSizeAndPosition(UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.1)	
			debris:AddItem(bg, 0.1)

		elseif material == Enum.Material.Grass or material == Enum.Material.Sand or material == Enum.Material.Ground or material == Enum.Material.Snow or material == Enum.Material.Mud or material == Enum.Material.LeafyGrass then
			local bulletWhizz = Instance.new("Sound")
			bulletWhizz.Parent = attachment
			bulletWhizz.Volume = math.random(20,30)/10
			bulletWhizz.MaxDistance = 100
			bulletWhizz.EmitterSize = 5
			bulletWhizz.PlaybackSpeed = math.random(38, 50)/40
			bulletWhizz.SoundId = "rbxassetid://" .. grass[math.random(1, #grass)]

			bulletWhizz:Play()

			local particles = Instance.new("ParticleEmitter")
			particles.Enabled = false
			particles.Color = ColorSequence.new(workspace.Terrain:GetMaterialColor(material))
			particles.LightEmission = 0
			particles.LightInfluence = 1
			particles.Size = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0.1, 0.1);
					NumberSequenceKeypoint.new(1, 5);
				}
			)
			particles.Texture = "rbxasset://textures/particles/smoke_main.dds"
			particles.Transparency = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0.75, 0);
					NumberSequenceKeypoint.new(1, 1);
				}
			)
			particles.Acceleration = Vector3.new(0, 0, 0)
			particles.Lifetime = NumberRange.new(0.5, 1)
			particles.Rate = 1000
			particles.Drag = 20
			particles.RotSpeed = NumberRange.new(-360,360)
			particles.Speed = NumberRange.new(15,30)
			particles.SpreadAngle = Vector2.new(180,360)
			particles.Parent = attachment
			particles.EmissionDirection = "Front"
			particles:Emit(25)

			debris:AddItem(attachment, particles.Lifetime.Max)

			local particles = Instance.new("ParticleEmitter")
			particles.Enabled = false
			particles.Color = ColorSequence.new(Color3.new(50, 50, 50))
			particles.LightEmission = 0
			particles.LightInfluence = 1
			particles.Size = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0.25, 0.1);
					NumberSequenceKeypoint.new(1, 2);
				}
			)
			particles.Texture = "http://www.roblox.com/asset/?id=159998966"
			particles.Transparency = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0, 0);
					NumberSequenceKeypoint.new(1, 1);
				}
			)
			particles.Acceleration = Vector3.new(0, -192, 0)
			particles.Lifetime = NumberRange.new(.5, .5)
			particles.Drag = 5
			particles.RotSpeed = NumberRange.new(-15,15)
			particles.Rotation = NumberRange.new(-360,360)
			particles.Speed = NumberRange.new(50,50)
			particles.SpreadAngle = Vector2.new(15,15)
			particles.Parent = attachment
			particles.EmissionDirection = "Front"
			particles:Emit(1)


			local bg = Instance.new("BillboardGui", attachment)
			bg.Adornee = attachment
			local flashsize = math.random(10, 15)/10
			bg.Size = UDim2.new(flashsize, 0, flashsize, 0)
			local flash = Instance.new("ImageLabel", bg)
			flash.BackgroundTransparency = 1
			flash.Size = UDim2.new(0.05, 0, 0.05, 0)
			flash.Position = UDim2.new(0.5, 0, 0.5, 0)
			flash.Image = "http://www.roblox.com/asset/?id=476778304"
			flash.ImageTransparency = math.random(0, .5)
			flash.Rotation = math.random(0, 360)
			flash:TweenSizeAndPosition(UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.1)	
			debris:AddItem(bg, 0.1)

		elseif material == Enum.Material.Plastic or material == Enum.Material.SmoothPlastic then

			local bulletWhizz = Instance.new("Sound")
			bulletWhizz.Parent = attachment
			bulletWhizz.Volume = math.random(20,30)/10
			bulletWhizz.MaxDistance = 100
			bulletWhizz.EmitterSize = 5
			bulletWhizz.PlaybackSpeed = math.random(32, 50)/40
			bulletWhizz.SoundId = "rbxassetid://" .. cracks[math.random(1, #cracks)]

			bulletWhizz:Play()
			local particles = Instance.new("ParticleEmitter")
			particles.Enabled = false
			particles.Color = ColorSequence.new(Color3.new(50, 50, 50))
			particles.LightEmission = 0
			particles.LightInfluence = 1
			particles.Size = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0.1, 0.1);
					NumberSequenceKeypoint.new(1, 2);
				}
			)
			particles.Texture = "rbxasset://textures/particles/smoke_main.dds"
			particles.Transparency = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0.85, 0);
					NumberSequenceKeypoint.new(1, 1);
				}
			)
			particles.Acceleration = Vector3.new(0, -10, 0)
			particles.Lifetime = NumberRange.new(0.7 - 0.5, 0.7 + 0.5)
			particles.Rate = 1000
			particles.Drag = 20
			particles.RotSpeed = NumberRange.new(-360,360)
			particles.Speed = NumberRange.new(25 - 5, 25 + 5)
			particles.SpreadAngle = Vector2.new(35,360)
			particles.Parent = attachment
			particles.EmissionDirection = "Top"
			particles:Emit(25)
			debris:AddItem(attachment, particles.Lifetime.Max)

			local bg = Instance.new("BillboardGui", attachment)
			bg.Adornee = attachment
			local flashsize = math.random(10, 15)/10
			bg.Size = UDim2.new(flashsize, 0, flashsize, 0)
			local flash = Instance.new("ImageLabel", bg)
			flash.BackgroundTransparency = 1
			flash.Size = UDim2.new(0.05, 0, 0.05, 0)
			flash.Position = UDim2.new(0.5, 0, 0.5, 0)
			flash.Image = "http://www.roblox.com/asset/?id=476778304"
			flash.ImageTransparency = math.random(0, .5)
			flash.Rotation = math.random(0, 360)
			flash:TweenSizeAndPosition(UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.1)	
			debris:AddItem(bg, 0.1)

		elseif material == Enum.Material.ForceField then

			local bulletWhizz = Instance.new("Sound")
			bulletWhizz.Parent = attachment
			bulletWhizz.Volume = math.random(20,30)/10
			bulletWhizz.MaxDistance = 100
			bulletWhizz.EmitterSize = 5
			bulletWhizz.PlaybackSpeed = math.random(32, 50)/40
			bulletWhizz.SoundId = "rbxassetid://" .. whizz[math.random(1, #whizz)]

			bulletWhizz:Play()
			local bg = Instance.new("BillboardGui", attachment)
			bg.Adornee = attachment
			local flashsize = math.random(15, 30)/10
			bg.Size = UDim2.new(flashsize, 0, flashsize, 0)
			local flash = Instance.new("ImageLabel", bg)
			flash.BackgroundTransparency = 1
			flash.Size = UDim2.new(0.05, 0, 0.05, 0)
			flash.Position = UDim2.new(0.45, 0, 0.45, 0)
			flash.Image = "http://www.roblox.com/asset/?id=233113663"
			flash.ImageTransparency = math.random(0, .5)
			flash.Rotation = math.random(0, 360)
			flash:TweenSizeAndPosition(UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.15)	
			debris:AddItem(bg, 0.07)
			debris:AddItem(attachment, 1)			



		elseif material == Enum.Material.CorrodedMetal or material == Enum.Material.Metal or material == Enum.Material.DiamondPlate then
			local bulletWhizz = Instance.new("Sound")
			bulletWhizz.Parent = attachment
			bulletWhizz.Volume = math.random(20,30)/10
			bulletWhizz.MaxDistance = 100
			bulletWhizz.EmitterSize = 5
			bulletWhizz.PlaybackSpeed = math.random(38, 58)/40
			bulletWhizz.SoundId = "rbxassetid://" .. metal[math.random(1, #metal)]

			bulletWhizz:Play()

			local particles = Instance.new("ParticleEmitter")
			particles.Enabled = false
			particles.Color = ColorSequence.new(Color3.fromRGB(255, 150, 0))
			particles.LightEmission = 1
			particles.LightInfluence = 0
			particles.Texture = "rbxasset://textures/particles/sparkles_main.dds"
			particles.Size = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0.25, 0);
					NumberSequenceKeypoint.new(1, 0.1);
				}
			)
			particles.Acceleration = Vector3.new(0, -50, 0)
			particles.Lifetime = NumberRange.new(0.15 - 0.05, 0.15 + 0.5)
			particles.Rate = 1000
			particles.Drag = 10
			particles.RotSpeed = NumberRange.new(-360,360)
			particles.Speed = NumberRange.new(50 - 25, 50 + 25)
			particles.VelocitySpread = math.random(5,20)
			particles.Parent = attachment
			particles.EmissionDirection = "Front"
			particles:Emit(50)
			debris:AddItem(attachment, particles.Lifetime.Max)
			local bg = Instance.new("BillboardGui", attachment)
			bg.Adornee = attachment
			local flashsize = math.random(15, 30)/10
			bg.Size = UDim2.new(flashsize, 0, flashsize, 0)
			local flash = Instance.new("ImageLabel", bg)
			flash.BackgroundTransparency = 1
			flash.Size = UDim2.new(0.05, 0, 0.05, 0)
			flash.Position = UDim2.new(0.45, 0, 0.45, 0)
			flash.Image = "http://www.roblox.com/asset/?id=233113663"
			flash.ImageTransparency = math.random(0, .5)
			flash.Rotation = math.random(0, 360)
			flash:TweenSizeAndPosition(UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.15)	
			debris:AddItem(bg, 0.07)

		elseif material == Enum.Material.Glass or material == Enum.Material.Ice or material == Enum.Material.Glacier then
			local bulletWhizz = Instance.new("Sound")
			bulletWhizz.Parent = attachment
			bulletWhizz.Volume = math.random(20,30)/10
			bulletWhizz.MaxDistance = 100
			bulletWhizz.EmitterSize = 5
			bulletWhizz.PlaybackSpeed = math.random(32, 60)/40
			bulletWhizz.SoundId = "rbxassetid://" .. glass[math.random(1, #glass)]

			bulletWhizz:Play()


			local particles = Instance.new("ParticleEmitter")
			particles.Enabled = false
			particles.Color = ColorSequence.new(Color3.new(50, 50, 50))
			particles.LightEmission = 0
			particles.LightInfluence = 1
			particles.Size = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 1, 0.1);
					NumberSequenceKeypoint.new(1, 1);
				}
			)
			particles.Texture = "http://www.roblox.com/asset/?id=5984841909"
			particles.Transparency = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0, 0);
					NumberSequenceKeypoint.new(1, 1);
				}
			)
			particles.Acceleration = Vector3.new(0, -50, 0)
			particles.Lifetime = NumberRange.new(0.5, 0.5)
			particles.Rate = 100
			particles.Drag = 5
			particles.RotSpeed = NumberRange.new(-360,360)
			particles.Speed = NumberRange.new(25, 25)
			particles.VelocitySpread = 50
			particles.Parent = attachment
			particles.EmissionDirection = "Front"
			particles:Emit(5)
			debris:AddItem(attachment, particles.Lifetime.Max)

			local bg = Instance.new("BillboardGui", attachment)
			bg.Adornee = attachment
			local flashsize = math.random(10, 15)/10
			bg.Size = UDim2.new(flashsize, 0, flashsize, 0)
			local flash = Instance.new("ImageLabel", bg)
			flash.BackgroundTransparency = 1
			flash.Size = UDim2.new(0.05, 0, 0.05, 0)
			flash.Position = UDim2.new(0.5, 0, 0.5, 0)
			flash.Image = "http://www.roblox.com/asset/?id=476778304"
			flash.ImageTransparency = math.random(0, .5)
			flash.Rotation = math.random(0, 360)
			flash:TweenSizeAndPosition(UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.1)	
			debris:AddItem(bg, 0.1)

		else
			local bulletWhizz = Instance.new("Sound")
			bulletWhizz.Parent = attachment
			bulletWhizz.Volume = math.random(20,30)/10
			bulletWhizz.MaxDistance = 100
			bulletWhizz.EmitterSize = 5
			bulletWhizz.PlaybackSpeed = math.random(32, 50)/40
			bulletWhizz.SoundId = "rbxassetid://" .. cracks[math.random(1, #cracks)]

			bulletWhizz:Play()

			local particles = Instance.new("ParticleEmitter")
			particles.Enabled = false
			particles.Color = ColorSequence.new(Color3.new(50, 50, 50))
			particles.LightEmission = 0
			particles.LightInfluence = 1
			particles.Size = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0.1, 0.1);
					NumberSequenceKeypoint.new(1, 2);
				}
			)
			particles.Texture = "rbxasset://textures/particles/smoke_main.dds"
			particles.Transparency = NumberSequence.new(
				{
					NumberSequenceKeypoint.new(0, 0.75, 0);
					NumberSequenceKeypoint.new(1, 1);
				}
			)
			particles.Acceleration = Vector3.new(0, 0, 0)
			particles.Lifetime = NumberRange.new(0.5, 1)
			particles.Rate = 1000
			particles.Drag = 20
			particles.RotSpeed = NumberRange.new(-360,360)
			particles.Speed = NumberRange.new(15,30)
			particles.SpreadAngle = Vector2.new(180,360)
			particles.Parent = attachment
			particles.EmissionDirection = "Front"
			particles:Emit(50)

			debris:AddItem(attachment, particles.Lifetime.Max)

			local bg = Instance.new("BillboardGui", attachment)
			bg.Adornee = attachment
			local flashsize = math.random(10, 15)/10
			bg.Size = UDim2.new(flashsize, 0, flashsize, 0)
			local flash = Instance.new("ImageLabel", bg)
			flash.BackgroundTransparency = 1
			flash.Size = UDim2.new(0.05, 0, 0.05, 0)
			flash.Position = UDim2.new(0.5, 0, 0.5, 0)
			flash.Image = "http://www.roblox.com/asset/?id=476778304"
			flash.ImageTransparency = math.random(0, .5)
			flash.Rotation = math.random(0, 360)
			flash:TweenSizeAndPosition(UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.1)	
			debris:AddItem(bg, 0.1)
		end

		--if  hitPart.Name == "Hitmaker" then

		--	local Marca = Instance.new("Part")
		--	Marca.material = Enum.Material.Neon
		--	Marca.Anchored = true
		--	Marca.CanCollide = false
		--	Marca.Color = Color3.fromRGB(255,0,0)
		--	Marca.Size = Vector3.new(0.2,0.2,0.01)
		--	Marca.Parent = SE_Workspace.Server
		--	Marca.CFrame = CFrame.new(position, position + normal)
		--	--table.insert(Ray_Ignore, Marca)

		--	TS:Create(Marca,TweenInfo.new(5,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,0,false,5),{Color = Color3.fromRGB(0,0,255)}):Play()
		--	TS:Create(Marca,TweenInfo.new(5,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut,0,false,15),{Transparency = 1, Size = Vector3.new(0,0,0.01)}):Play()
		--	debris:AddItem(attachment, 5)
		--	debris:AddItem(Marca, 20)

		--elseif  hitPart.Name == "alvo" then

		--	local Marca = Instance.new("Part")
		--	Marca.Anchored = true
		--	Marca.CanCollide = false
		--	Marca.Transparency = 1
		--	Marca.Size = Vector3.new(0.2,0.2,0.01)
		--	Marca.Parent = SE_Workspace.Server
		--	Marca.CFrame = CFrame.new(position, position + normal)
		--	debris:AddItem(attachment, 5)
		--	debris:AddItem(Marca, 20)
		--	table.insert(ray_Ignore, Marca)
		--	local Dec = Instance.new("Decal")
		--	Dec.Texture = "rbxassetid://359667865"
		--	Dec.Parent = Marca
		--end
	end
end

function FX.Explosion(position, hitPart, normal)

	local hitMark = Instance.new("Attachment")
	hitMark.CFrame = CFrame.new(position, position + normal)
	hitMark.Parent = workspace.Terrain

	local S = Instance.new("Sound")
	S.EmitterSize = 50
	S.MaxDistance = 1500
	S.SoundId = "rbxassetid://".. explosion[math.random(1, 7)]
	S.PlaybackSpeed = math.random(30,55)/40
	S.Volume = 2
	S.Parent = hitMark
	S.PlayOnRemove = true
	S:Destroy()

	local exp = Instance.new("Explosion")
	exp.BlastPressure = 0
	exp.BlastRadius = 0
	exp.DestroyJointRadiusPercent = 0
	exp.Position = hitMark.Position
	exp.Parent = hitMark

	debris:AddItem(hitMark, 5)
end

return FX