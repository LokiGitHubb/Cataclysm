if not game:IsLoaded() then
    game.Loaded:Wait()
end
task.wait(1)
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
if not Player:HasAppearanceLoaded() then
    Player.CharacterAdded:Wait()
end

local Character = Player.Character::Model
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local CharacterTorso = Character:WaitForChild("Torso")::BasePart
local GameCamera = require(Modules:WaitForChild("gameCamera"))
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local GameCameraRemotes = Remotes:WaitForChild("GameCamera")
local CreateGameCamera = GameCameraRemotes:WaitForChild("CreateGameCamera")
local CreateVisualTool = GameCameraRemotes:WaitForChild("CreateVisualTool")
local CreatedGameCam: GameCamera.GameCamera
local Items = ReplicatedStorage:WaitForChild("Items")

local function onCreateGameCam(bobbingSpeed, tiltSpeed)
	print("CREATING GAME CAMERA")
	CreatedGameCam = GameCamera.create(bobbingSpeed, tiltSpeed)
	CreatedGameCam:resume()
	print("RESUMED GAME CAMERA")
end

local function CreateVisualItem(ItemName)
	local ViewModel = CreatedGameCam.ViewModel
	local VMTorso = ViewModel:WaitForChild("Torso") :: BasePart
	local OldGrip = VMTorso:FindFirstChild("VisualGrip")
	local OldItem = VMTorso:FindFirstChild("VisualItem")
	if OldGrip then
		OldGrip:Destroy()
	end
	if OldItem then
		OldItem:Destroy()
	end
    local GlobalToolGrip = CharacterTorso:WaitForChild("GlobalToolGrip")
    GlobalToolGrip:Destroy()
	local VisualItem = Items:FindFirstChild(ItemName) :: Model
	if VisualItem then
		VisualItem = VisualItem:Clone()
	else
		return nil
	end
	local ToolGrip = Instance.new("Motor6D")
	ToolGrip.Name = "VisualToolGrip"
	ToolGrip.Part0 = VMTorso
	ToolGrip.Part1 = VisualItem.PrimaryPart
	ToolGrip.Name = "VisualGrip"
	ToolGrip.Parent = ViewModel.Torso
	VisualItem.Name = "VisualItem"
	VisualItem.Parent = VMTorso
    return nil
end

CreateGameCamera.OnClientEvent:Connect(onCreateGameCam)
CreateVisualTool.OnClientEvent:Connect(CreateVisualItem)