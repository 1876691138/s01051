local module 								= {}

-----------------------------
--//Services
local replicatedStorage 					= game:GetService("ReplicatedStorage")
local debrisService 						= game:GetService("Debris")
local players								= game:GetService("Players")
local debris								= game:GetService("Debris")

--//Modules
local dataModule							= require(script["Data"])
local achievementsModule					= require(script.Parent["Achievements"])
local fightersModule						= require(script.Parent["Fighters"])

--//Events
local openRobuxEggEvent						= replicatedStorage["Events"]["Client"]["Fighters"]["OpenRobuxEgg"]

--//Functions
local getActiveFunc							= replicatedStorage["Functions"]["Client"]["GetActiveRobuxCapsule"]

--//Settings
local fightersList							= dataModule.ActiveEgg.Fighters

-----------------------------
function module.ActiveEgg()
	return dataModule.ActiveEgg
end

getActiveFunc.OnServerInvoke				= function(plr)
	return module.ActiveEgg()
end

-----------------------------
local function Pick1(plr)
	local plrFighters						= plr["Fighters"]
	local plrInv							= plrFighters["Inventory"]
	local maxInv							= plrFighters["MaxInventory"]
	
	local randomID							= dataModule.PickRandomItem(plr)

	local canAdd							= #plrInv:GetChildren() < maxInv.Value
	if canAdd								then
		fightersModule.AddNew(plr, randomID.Name, plrInv)	
	end

	return randomID
end

-----------------------------
function module.Open(plr, amount)
	local data								= 
		{
			Count 							= amount,
			Rewards							= {},
		}
	
	for i = 1, data.Count 					do
		local randomID						= Pick1(plr)
		table.insert(data.Rewards, randomID)
	end

	achievementsModule.AddStat(plr, "Eggs", data.Count)
	openRobuxEggEvent:FireClient(plr, data, dataModule.ActiveEgg)
end

-----------------------------
return module
