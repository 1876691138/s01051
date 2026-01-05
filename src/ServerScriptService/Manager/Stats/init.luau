local module 							= {}

-----------------------------
--//Services
local replicatedStorage 				= game:GetService("ReplicatedStorage")
local debris 							= game:GetService("Debris")

--//ModuleScripts
local dataModule 						= require(script.Data)

--//Functions
local getStatsFunc 						= replicatedStorage.Functions.Client.GetStats

-----------------------------
getStatsFunc.OnServerInvoke				= function(plr)
	return dataModule.List
end

-----------------------------
function module.GetList()
	return dataModule.List
end

-----------------------------
return module
