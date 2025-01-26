--!strict
local ItemClass = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local AnimationManager = require(Modules:WaitForChild("AnimationManager"))
local ServerStorage = game:GetService("ServerStorage")
local BehavioralScripts = ServerStorage:WaitForChild("ItemBehavioral")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local ViewmodelEvents = Remotes:WaitForChild("GameCamera")
local CreateVisualTool = ViewmodelEvents:WaitForChild("CreateVisualTool")
local HookItemEvent = Remotes:WaitForChild("HookItemEvent")
local Items = ReplicatedStorage:WaitForChild("Items")

ItemClass.__index = ItemClass

export type ItemBehavioral = {
	equip: (player: Player, item: Item) -> nil,
	unequip: (player: Player, item: Item) -> nil,
	use: (player: Player, item: Item) -> nil,
	init: (player: Player, item: Item) -> nil,
	config: {},
}

export type Item = {
	Status: string,
	Player: Player,
	BehavioralScript: ItemBehavioral,
	ActivationConnection: RBXScriptConnection,
	equip: (self: Item) -> nil,
	unequip: (self: Item) -> nil,
	ItemName: string,
	keyCode: Enum.KeyCode,
}

function ItemClass.create(itemName, player: Player, KeyCode: Enum.KeyCode)
	local self: Item = setmetatable({} :: any, ItemClass)
	self.ItemName = itemName
	self.Player = player
	local ItemBehavioral = require(BehavioralScripts:WaitForChild(itemName)) :: ItemBehavioral
	local Config = ItemBehavioral["config"]
	local AnimationName = Config["AnimationName"]
	self.BehavioralScript = ItemBehavioral
	AnimationManager.LoadAnimation(player.Name .. "ItemAnimation" .. itemName, AnimationName, player)
	AnimationManager.PlayAnimation(player.Name .. "ItemAnimation" .. itemName, player)
	return self
end

function ItemClass.equip(self: Item)
	local player = self.Player
	local Character = player.Character :: Model
	local CharacterTorso = Character:WaitForChild("Torso") :: BasePart
	local itemName = self.ItemName
	local ScriptBehavioral = self.BehavioralScript
	local Config = ScriptBehavioral["config"]
	local AnimationName = Config["AnimationName"]
	AnimationManager.LoadAnimation(player.Name .. "ItemAnimation" .. itemName, AnimationName, player)
	AnimationManager.PlayAnimation(player.Name .. "ItemAnimation" .. itemName, player)
	HookItemEvent:FireClient(player)
	local GlobalTool = Items:FindFirstChild(itemName) :: Model
	if GlobalTool then
		GlobalTool = GlobalTool:Clone()
	end
	local NewGlobalToolGrip = Instance.new("Motor6D")
	NewGlobalToolGrip.Name = "GlobalToolGrip"
	NewGlobalToolGrip.Part0 = CharacterTorso
	NewGlobalToolGrip.Part1 = GlobalTool.PrimaryPart
	NewGlobalToolGrip.Parent = CharacterTorso
	GlobalTool.Parent = CharacterTorso
	task.wait(0.5)
	CreateVisualTool:FireClient(player, self.ItemName)
end

return ItemClass
