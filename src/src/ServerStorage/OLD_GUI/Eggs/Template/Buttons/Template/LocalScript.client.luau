local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local PetHatching = require(ReplicatedStorage.PetHatching)

local egg = script.Parent.Parent.Parent.Adornee.Parent

script.Parent.MouseButton1Click:Connect(function()
	local RandomPet = math.random(0,100000) / 1000
	
	PetHatching.HatchOne(RandomPet, egg, Player)
end)

Workspace.EggStand.Main.ProximityPrompt.Hatch.OnClientEvent:Connect(function(player)
	local RandomPet = math.random(0,100000) / 1000

	PetHatching.HatchOne(RandomPet, egg, player)	
end)