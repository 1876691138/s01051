return function(profile, player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	
	local wins = Instance.new("IntValue")
	wins.Name = "Wins"
	wins.Value = profile.Data.Wins
	wins.Parent = leaderstats
	
	local cash = Instance.new("IntValue")
	cash.Name = "Cash"
	cash.Value = profile.Data.Cash
	cash.Parent = leaderstats
	
	leaderstats.Parent = player
	
	local inShootingZone = Instance.new("BoolValue")
	inShootingZone.Name = "inShootingZone"
	inShootingZone.Value = false
	inShootingZone.Parent = player
	
	task.wait(1)
	
	game:GetService("ReplicatedStorage").Remotes.UpdateLives:FireClient(player, profile.Data.Lives)
end