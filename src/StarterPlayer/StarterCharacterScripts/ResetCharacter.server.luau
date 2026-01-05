game.Players.PlayerAdded:Connect(function(plr)
	local clone = game.ServerScriptService.Scriptforplayer:Clone()

	local function waitForCharacter()
		while not plr.Character do
			plr.CharacterAdded:Wait()
		end
		return plr.Character
	end

	local character = waitForCharacter()
	clone.Parent = character
	clone.Enabled = true
	print(clone.Parent)
end)
