if not game:IsLoaded() then
	game.Loaded:Wait()
end
task.wait(1)
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
if not Player:HasAppearanceLoaded() then
	Player.CharacterAdded:Wait()
end
local Character = Player.Character :: Model
local Humanoid = Character:WaitForChild("Humanoid") :: Humanoid
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local CharacterTorso = Character:WaitForChild("Torso") :: BasePart
local GameCamera = require(Modules:WaitForChild("gameCamera"))
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local GameCameraRemotes = Remotes:WaitForChild("GameCamera")
local CreateGameCamera = GameCameraRemotes:WaitForChild("CreateGameCamera")
local CreateVisualTool = GameCameraRemotes:WaitForChild("CreateVisualTool")
local RegisterJumpEvent = Remotes:WaitForChild("RegisterDoubleJumper")
local CreatedGameCam: GameCamera.GameCamera
local Items = ReplicatedStorage:WaitForChild("Items")

export type ButtonBinding = {
	name: string,
	remote: RemoteEvent,
}

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
local endedKeybinds:{} = {}
 
local function registerButtonBind(keybind: Enum.KeyCode, remote, name)
	local keybindExisting = keybinds[keybind]
	if keybindExisting then
		warn("OVERWRITING KEYBIND EXISTANCE")
	end
	keybinds[keybind] = { ["remote"] = remote, ["name"] = name }
end

local function registerInputEnded(keybind:Enum.KeyCode, remote, name)
	local keybindExisting = endedKeybinds[keybind]
	if endedKeybinds then
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


CreateGameCamera.OnClientEvent:Connect(onCreateGameCam)
CreateVisualTool.OnClientEvent:Connect(CreateVisualItem)
RegisterJumpEvent.OnClientEvent:Connect(RegisterDoubleJump)
UserInputService.InputBegan:Connect(processInput)
UserInputService.InputEnded:Connect(processInputEnded)
Remotes.RegisterButtonBinding.OnClientEvent:Connect(registerButtonBind)
Remotes.RegisterInputEnded.OnClientEvent:Connect(registerInputEnded)