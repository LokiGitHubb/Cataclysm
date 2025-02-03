--!strict
local AnimationManager = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Animations = ReplicatedStorage:WaitForChild("Animations")
local ViewmodelAnimations = Animations:WaitForChild("ViewmodelAnimations")
local GlobalAnimations = Animations:WaitForChild("GlobalAnimations")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local ViewmodelRemotes = Remotes:WaitForChild("GameCamera")
local PlayAnimation = ViewmodelRemotes:WaitForChild("playAnimation")
local StopAnimation = ViewmodelRemotes:WaitForChild("stopAnimation")

local Players = game:GetService("Players")

local LoadedAnims = {}

export type LoadedAnimation = {
    Track:AnimationTrack,
    Info:{},
    OriginalAnimationName:string
}

AnimationManager.init = function()
    for _, player in pairs(Players:GetPlayers()) do
        LoadedAnims[player.Name] = {}
    end
end


AnimationManager.LoadAnimation = function(Reference:string, AnimationName:string, Player:Player)
    local TracksPlayingList = LoadedAnims[Player.Name]
    if not TracksPlayingList then
        LoadedAnims[Player.Name] = {}
        TracksPlayingList = LoadedAnims[Player.Name]
    end
    local ExistingTrack = TracksPlayingList[Reference]::LoadedAnimation
    local Character = Player.Character::Model
    local Humanoid = Character:WaitForChild("Humanoid")::Humanoid
    local Animator = Humanoid:WaitForChild("Animator")::Animator
    local Animation = GlobalAnimations:FindFirstChild(AnimationName)
    if Animation then
        if ExistingTrack then
            return "ALREADY LOADED"
        else
            local NewInfo = {}
            if ViewmodelAnimations:FindFirstChild(Animation.Name) then
                NewInfo["ViewmodelEnabled"] = true
            end
            NewInfo["OriginalAnimationName"] = AnimationName
            local newTrack = Animator:LoadAnimation(Animation)
            TracksPlayingList[Reference] = {
                ["Track"] = newTrack;
                ["Info"] = NewInfo;
                
            }
            return "LOADED"
        end
    else
        return "ANIMATION DOES NOT EXIST"
    end
end

AnimationManager.PlayAnimation = function(Reference:string, Player:Player) : any
    local TracksPlayingList:{} = LoadedAnims[Player.Name]
    if not TracksPlayingList then
        LoadedAnims[Player.Name] = {}
        TracksPlayingList = LoadedAnims[Player.Name]
    end
    local ExistingTrack:LoadedAnimation = TracksPlayingList[Reference]::LoadedAnimation
    if ExistingTrack then
        ExistingTrack["Track"]:Play()
        local Info = ExistingTrack["Info"]
        local ViewmodelEnabled = Info["ViewmodelEnabled"]
        local OriginalAnimation = Info["OriginalAnimationName"]
        if ViewmodelEnabled then
            PlayAnimation:FireClient(Player, OriginalAnimation)
        end
    else
        return "NOT LOADED PLEASE LOAD ANIMATION"
    end
    return "SUCCESS"
end

AnimationManager.PauseAnimation = function(Reference:string, Player:Player)
    local TracksPlayingList:{} = LoadedAnims[Player.Name]
    if not TracksPlayingList then
        LoadedAnims[Player.Name] = {}
        TracksPlayingList = LoadedAnims[Player.Name]
    end
    local ExistingTrack:LoadedAnimation = TracksPlayingList[Reference]::LoadedAnimation
    if ExistingTrack then
        ExistingTrack["Track"]:AdjustSpeed(0)
        local Info = ExistingTrack["Info"]
        local ViewmodelEnabled = Info["ViewmodelEnabled"]
        local OriginalAnimation = Info["OriginalAnimationName"]
        if ViewmodelEnabled then
            StopAnimation:FireClient(Player, OriginalAnimation)
        end
    else
        return "NOT LOADED PLEASE LOAD ANIMATION"
    end
    return "SUCCESS"
end

AnimationManager.StopAnimation = function(Reference:string, Player:Player) : any
    local TracksPlayingList:{} = LoadedAnims[Player.Name]
    if not TracksPlayingList then
        LoadedAnims[Player.Name] = {}
        TracksPlayingList = LoadedAnims[Player.Name]
    end
    local ExistingTrack:LoadedAnimation = TracksPlayingList[Reference]::LoadedAnimation
    if ExistingTrack then
        print(ExistingTrack)
        ExistingTrack["Track"]:Stop()
        local Info = ExistingTrack["Info"]
        local ViewmodelEnabled = Info["ViewmodelEnabled"]
        local OriginalAnimation = Info["OriginalAnimationName"]
        if ViewmodelEnabled then
            StopAnimation:FireClient(Player, OriginalAnimation)
        end
    else
        return "NOT LOADED PLEASE LOAD ANIMATION"
    end
    return "SUCCESS"
end

return AnimationManager