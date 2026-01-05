local module 							= {}

-----------------------------
--//Services
local replicatedStorage 				= game:GetService("ReplicatedStorage")
local debris 							= game:GetService("Debris")

--//ModuleScripts
local dataModule 						= require(script.Data)

--//Functions
local getAchievementsFunc 				= replicatedStorage.Functions.Client.GetAchievements

--//Events
local updateStatsEvent					= replicatedStorage.Events.Client.Others.UpdateStats

-----------------------------
getAchievementsFunc.OnServerInvoke		= function(plr)
	return dataModule.List
end

-----------------------------
function module.UpdateBoosts(plr)
	local plrBoosts						= plr.Others.Boosts
	plrBoosts["Energy"].Value			= 0
	plrBoosts["Damage"].Value			= 0
	plrBoosts["Gems"].Value				= 0
	
	for i, child in pairs(plr.Achievements:GetChildren()) do
		local itemData					= dataModule.List[child.Name]
		if not itemData					then continue end
		
		if not child.Value				then continue end
		
		local boosts					= itemData.Reward.Boosts
		plrBoosts["Energy"].Value		+= tonumber(boosts["Energy"])
		plrBoosts["Damage"].Value		+= tonumber(boosts["Damage"])
		plrBoosts["Gems"].Value			+= tonumber(boosts["Gems"])
	end	
end

updateStatsEvent.OnServerEvent:Connect(function(plr)
	module.UpdateBoosts(plr)
end)

-----------------------------
function module.AddStat(plr, wantedType, addedValue)
	local targetStat					= plr.Others.Stats:FindFirstChild(wantedType)
	if not targetStat					then return end
	
	targetStat.Value					+= addedValue
	
	for i, child in pairs(plr.Achievements:GetChildren()) do
		local itemData					= dataModule.List[child.Name]
		if not itemData					then continue end

		if itemData.Type ~= wantedType 	then continue end
		
		child.Value						= (targetStat.Value >= itemData.Target)
	end	
	
	--module.UpdateBoosts(plr)
end

function module.GetList()
	return dataModule.List
end

-----------------------------
return module
