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
    local RandomModel = ChildrenFolder[RandomIndex]:Clone()
    RandomModel.Parent = Workspace
    Player.Character = RandomModel
    self.Class = Class
    self.Camera = CreateGameCamera:FireClient(Player, 0.13, 0.13)
    self.Player = Player
    self.ClassConfiguration = ClassConfiguration.get(Class)
    self.Character = Player.Character::Model
    return CharacterClass
end



return CharacterClass