local CharacterClass = {}
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local GameCameraRemotes = Remotes:WaitForChild("GameCamera")
local CreateGameCamera = GameCameraRemotes:WaitForChild("CreateGameCamera")::RemoteEvent
local Modules = ReplicatedStorage:WaitForChild("Modules")
local GameCamera = require(Modules:WaitForChild("gameCamera"))
local ServerStorage = game:GetService("ServerStorage")
local ClassConfiguration = require(ServerStorage:WaitForChild("ClassConfiguration"))
local ClassModels = ReplicatedStorage:WaitForChild("ClassModels")
local CharacterClassBehavioral = ServerStorage:WaitForChild("CharacterClassBehavioral")
CharacterClass.__index = CharacterClass

export type CharacterClass = {
    Class:string,
    Camera:GameCamera.GameCamera,
    Character:Model,
    Player:Player,
    ClassConfiguration:{},
}

function CharacterClass.create(Class, Player)
    local self:CharacterClass = setmetatable({}::any, CharacterClass)
    local ClassFolder = ClassModels:WaitForChild(Class)
    local ChildrenFolder = ClassFolder:GetChildren()
    local RandomIndex = math.random(1, #ChildrenFolder)
    local RandomModel:Model = ChildrenFolder[RandomIndex]:Clone()
    RandomModel.Parent = Workspace
    Player.Character = RandomModel
    local newRootAttachment = Instance.new("Attachment")
    newRootAttachment.Position = Vector3.zero
    newRootAttachment.Name = "RootAttachment"
    newRootAttachment.Parent = RandomModel.PrimaryPart
    self.Class = Class
    self.Camera = CreateGameCamera:FireClient(Player, 0.13, 0.13)
    self.Player = Player
    self.ClassConfiguration = ClassConfiguration.get(Class)
    self.Character = Player.Character::Model
    local Humanoid = self.Character:WaitForChild("Humanoid")
    local ClassConfig = self.ClassConfiguration
    local BehavioralScriptName = ClassConfig["BehavioralScript"]
    local HumanoidProperties = ClassConfig["HumanoidProperties"]
    for property, value in pairs(HumanoidProperties) do
        Humanoid[property] = value
    end
    local BehavioralFunction = require(CharacterClassBehavioral:WaitForChild(BehavioralScriptName))
    BehavioralFunction(self)
    Remotes.EnableCharacterClient:FireClient(Player, Class)
    return CharacterClass
end



return CharacterClass