local DataManager = {Profiles = {}};

function DataManager.GetProfileAsync(player: Player)
	if (DataManager.Profiles[player] ~= nil) then
		--print("Found profile: ", DataManager.Profiles[player]);
		return DataManager.Profiles[player];
	else
		local profile = DataManager.Profiles[player]
		local retries = 0
		
		while not profile and retries <= 25 do
			profile = DataManager.Profiles[player]
			retries = retries + 1
			
			task.wait()
		end
		
		return profile
	end;
end;

function DataManager.SetData(player: Player, key: string, value: any)
	local profile = DataManager.GetProfileAsync(player);
	
	if (profile ~= nil) then
		profile.Data[key] = value;
		if (player.leaderstats:FindFirstChild(key) ~= nil) then
			player.leaderstats[key].Value = value;
		end;
	else
		warn("Could not find profile.");
	end;
end;

function DataManager.Increment(player: Player, key: string, increment: number)
	local profile = DataManager.GetProfileAsync(player);

	if (profile ~= nil and type(tonumber(profile.Data[key])) == "number") then
		DataManager.SetData(player, key, profile.Data[key] + increment);
		return profile.Data[key];
	else
		warn("Could not find profile.");
	end;
end;

return (DataManager);