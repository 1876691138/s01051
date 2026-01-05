--Basically checks if the toucher of the button is a player, then adds money to that player.

--Uberubert
--This script is free to use for anyone

local ting = 0 --debouncer

function onTouched(hit)

	if ting == 0 then --debounce check
	ting = 1 --activate debounce
	check = hit.Parent:FindFirstChild("Humanoid") --Find the human that touched the button

	if check ~= nil then --If a human is found, then

		local user = game.Players:GetPlayerFromCharacter(hit.Parent) --get player from touching human
		local stats = user:findFirstChild("leaderstats") --Find moneyholder

		if stats ~= nil then --If moneyholder exists then
			local Energy = stats:findFirstChild("Gems") --Get money
			Energy.Value  = Energy.Value +20000000 --increase amount of money by the number displayed here (500)
			wait(.5) --wait-time before button works again
		end

	end

	ting = 0 --remove debounce
	end

end

script.Parent.Touched:connect(onTouched)
