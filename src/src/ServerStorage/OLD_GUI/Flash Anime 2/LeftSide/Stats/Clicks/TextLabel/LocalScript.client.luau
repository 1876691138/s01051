wait(1)



while true do
	local player = game.Players.LocalPlayer
	local leaderstats = player.leaderstats
	local short = require(game.ReplicatedStorage.Short)
	script.Parent.Text = short.en(leaderstats.Energy.Value)
	wait(0.2)
end