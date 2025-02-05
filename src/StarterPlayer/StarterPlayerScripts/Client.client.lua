if not game:IsLoaded() then game.Loaded:Wait(); end

task.wait(1)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local Character = Player.Character :: Model
local CharacterTorso = Character:WaitForChild("Torso") :: BasePart
local Humanoid = Character:WaitForChild("Humanoid") :: Humanoid
local PlayerGui = Player.PlayerGui
if not Player:HasAppearanceLoaded() then
	Player.CharacterAdded:Wait()
end

local Modules = ReplicatedStorage:WaitForChild("Modules")
local FastCast = require(Modules:WaitForChild("FastCastRedux"))
local FastCastType = require(Modules.FastCastRedux.TypeDefinitions)
local GameCamera = require(Modules:WaitForChild("gameCamera"))
local Ballistics = require(Modules:WaitForChild("Ballistics"))

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local RemoteFunctions = Remotes:WaitForChild("Functions")
local GameCameraRemotes = Remotes:WaitForChild("GameCamera")
local RegisterJumpEvent = Remotes:WaitForChild("RegisterDoubleJumper")

local PlayerScripts = script.Parent
local ClassScripts = PlayerScripts:WaitForChild("ClassScripts")
local ClassModels = ReplicatedStorage:WaitForChild("ClassModels")
local Items = ReplicatedStorage:WaitForChild("Items")

local CreatedGameCam: GameCamera.GameCamera
local CreateGameCamera = GameCameraRemotes:WaitForChild("CreateGameCamera")
local CreateVisualTool = GameCameraRemotes:WaitForChild("CreateVisualTool")

local CastGun = Remotes:WaitForChild("CastGun")
local RegisterHit = Remotes:WaitForChild("RegisterHit")
FastCast.VisualizeCasts = true

for _, classScript: LocalScript in pairs(ClassScripts:GetChildren()) do
	classScript.Enabled = false
end

export type ButtonBinding = {
	name: string,
	remote: RemoteEvent,
}

local function onCreateGameCam(bobbingSpeed, tiltSpeed)
	print("CREATING GAME CAMERA")
	CreatedGameCam = GameCamera.create(bobbingSpeed, tiltSpeed) :: GameCamera.GameCamera
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
	for _, part in pairs(VisualItem:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = false
		end
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

local JumpsRemaining = 1
local StateChangedConnection: RBXScriptConnection

local function RegisterDoubleJump()
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if not gameProcessed then
			if input.KeyCode == Enum.KeyCode.Space then
				if Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
					if JumpsRemaining >= 1 then
						JumpsRemaining -= 1
						Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
					end
				end
			end
		end
	end)
	StateChangedConnection = Humanoid.StateChanged:Connect(function(_, new)
		if new == Enum.HumanoidStateType.Landed then
			JumpsRemaining = 1
		end
	end)
end

local keybinds: {} = {}
local endedKeybinds: {} = {}

local function registerButtonBind(keybind: Enum.KeyCode, remote, name)
	local keybindExisting = keybinds[keybind]
	if keybindExisting then
		warn("OVERWRITING KEYBIND EXISTANCE")
	end
	print(keybind)
	keybinds[keybind] = { ["remote"] = remote, ["name"] = name }
end

local function registerInputEnded(keybind: Enum.KeyCode, remote, name)
	local keybindExisting = endedKeybinds[keybind]
	if keybindExisting then
		warn("OVERWRITING KEYBIND EXISTANCE")
	end
	endedKeybinds[keybind] = { ["remote"] = remote, ["name"] = name }
end

local function processInput(Input: InputObject, gameProcessed)
	if not gameProcessed then
		local callback = keybinds[Input.KeyCode]
		if callback then
			local remote = callback["remote"]
			if callback then
				remote:FireServer(callback["name"])
			end
		end
	end
end

local function processInputEnded(Input: InputObject, gameProcessed)
	if not gameProcessed then
		local callback = endedKeybinds[Input.KeyCode]
		if callback then
			local remote = callback["remote"]
			if callback then
				remote:FireServer(callback["name"])
			end
		end
	end
end

local function ResumeBobbing()
	if CreatedGameCam.cameraUpdateConnection then
		CreatedGameCam.cameraUpdateConnection:Disconnect()
	end
	CreatedGameCam:reconnectEffects()
end

local function stopBobbing()
	CreatedGameCam.cameraUpdateConnection:Disconnect()
end

local function enableClassScript(class)
	local classScript = ClassScripts:FindFirstChild(class)
	if classScript then
		classScript.Enabled = true
	else
		warn("CLASS SCRIPT NOT FOUND")
	end
end

local Caster = FastCast.new()
local function Cast(Origin, Direction, Velocity, Params: RaycastParams)
	print("CASTING")
	local NewBehavior = FastCast.newBehavior()
	NewBehavior.RaycastParams = Params
	Caster:Fire(Origin, Direction, Velocity, NewBehavior)
end

Caster.RayHit:Connect(function(_, b)
	print(b)
end)

local CurrentClassSelection
local function ShowClassSelection()
	local ClassSelection = PlayerGui:WaitForChild("ClassSelection"):Clone()
	CurrentClassSelection = ClassSelection
	local ClassGrid = ClassSelection:WaitForChild("SelectionFrame")
	local Template = ClassGrid:WaitForChild("ClassSelect")
	local IconFolder = ReplicatedStorage:WaitForChild("ClassIcons")
	Template.Parent = ReplicatedStorage
	for _, Class: Folder in pairs(ClassModels:GetChildren()) do

		local NewTemplate = Template:Clone()
		NewTemplate.Name = Class.Name
		local ImageLabel = NewTemplate:WaitForChild("Icon")
		local Image = IconFolder:FindFirstChild(Class.Name) :: ImageButton
		local Hitbox = NewTemplate:WaitForChild("Hitbox") :: TextButton
		Hitbox.Activated:Connect(function()
			Remotes:WaitForChild("SpawnPlayer"):FireServer(Class.Name)
			CurrentClassSelection:Destroy()
		end)
		print("Connected")
		if Image then
			ImageLabel.Image = Image.Value
		end

		NewTemplate.Parent = ClassGrid
	end
	ClassSelection.Enabled = true
	ClassSelection.Parent = PlayerGui
end

ShowClassSelection()

CreateGameCamera.OnClientEvent:Connect(onCreateGameCam)
CreateVisualTool.OnClientEvent:Connect(CreateVisualItem)
RegisterJumpEvent.OnClientEvent:Connect(RegisterDoubleJump)
UserInputService.InputBegan:Connect(processInput)
UserInputService.InputEnded:Connect(processInputEnded)
Remotes.RegisterButtonBinding.OnClientEvent:Connect(registerButtonBind)
Remotes.RegisterInputEnded.OnClientEvent:Connect(registerInputEnded)
Remotes.StopBobbing.OnClientEvent:Connect(stopBobbing)
Remotes.StartBobbing.OnClientEvent:Connect(ResumeBobbing)
Remotes.EnableCharacterClient.OnClientEvent:Connect(enableClassScript)
Remotes.CastGun.OnClientEvent:Connect(Cast)
