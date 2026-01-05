local ReplicatedStorage = game:GetService("ReplicatedStorage")

wait(1)

while true do
	local player = game.Players.LocalPlayer
	local leaderstats = player.leaderstats
	local short = require(ReplicatedStorage.Short)
	local oldEnergy = leaderstats.Energy.Value
	wait(1)
	local newEnergy = leaderstats.Energy.Value
	script.Parent.Text = short.en(newEnergy - oldEnergy)
end