local NEWBINDABLE = Instance.new("RemoteEvent")
NEWBINDABLE.Name = "Test"
NEWBINDABLE.Parent = workspace

NEWBINDABLE.OnServerEvent:Connect(function()
	for _ = 1, 10, 1 do
		local direction = Vector3.new(-100, 0, 0)
		local directionCF = CFrame.new(Vector3.zero, direction)
		local spreadDirection = CFrame.fromOrientation(0, 0, math.random(0, math.pi * 2))
		local SpreadAngle = CFrame.fromOrientation(math.rad(math.random(0, 4)), 0, 0)
		direction = (directionCF * spreadDirection * SpreadAngle).LookVector
        game.ReplicatedStorage.Remotes.CastGun:FireAllClients(game.Workspace.Testy.Position, direction, 100, RaycastParams.new())
	end
end)
