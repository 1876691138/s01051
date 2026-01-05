local module 						= {}

-----------------------------
--//Services
local replicatedStorage 			= game:GetService("ReplicatedStorage")
local serverStorage 				= game:GetService("ServerStorage")
local MarketplaceService 			= game:GetService("MarketplaceService")
local DataStoreService 				= game:GetService("DataStoreService")
local Players 						= game:GetService("Players")

--//ModuleScripts
local gamePassesModule 				= require(script["GamePasses"])
local devproductsModule 			= require(script["DevProducts"])

-----------------------------
function module.CheckAllPasses(plr)
	gamePassesModule.CheckAllPasses(plr)
end

-----------------------------
return module
