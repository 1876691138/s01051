local module 						= {}

-----------------------------
--//Services
local replicatedStorage 				= game:GetService("ReplicatedStorage")
local serverStorage 					= game:GetService("ServerStorage")
local MarketplaceService 				= game:GetService("MarketplaceService")
local DataStoreService 					= game:GetService("DataStoreService")
local Players 							= game:GetService("Players")

--//Functions
local getPassesFunc						= replicatedStorage.Functions.Client.GetPasses
local getThisPassFunc					= replicatedStorage.Functions.Client.GetThisPass

--//ModuleScripts
local dataModule						= require(script["Data"])
local passes							= dataModule.List

-----------------------------
function module.GetPasses()
	return passes
end

function module.GetThisGamepass(id)
	return passes[id]
end


-----------------------------
getPassesFunc.OnServerInvoke			= function(plr)
	return module.GetPasses()
end

getThisPassFunc.OnServerInvoke			= function(plr, id)
	return module.GetThisGamepass(id)
end

-----------------------------
MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(plr, passID, wasPurchased)
	if not wasPurchased					then return end
	if not plr 							then return end

	for i, entry in pairs(passes) 		do
		if passID ~= entry.Code			then continue end
		
		entry.Reward(plr)
		return true
	end
end)

-----------------------------
function module.CheckGamePass(plr, gamepassID)
	local hasPass 						= false

	local success, message 				= pcall(function()
		hasPass 						= MarketplaceService:UserOwnsGamePassAsync(plr.UserId, gamepassID)
	end)

	if not success 						then return false end
	if hasPass 							then return true end
	
	return false
end

function module.CheckAllPasses(plr)
	for i, entry in pairs(passes) 		do
		local isOwned 					= module.CheckGamePass(plr, entry.Code)
		if not isOwned 					then continue end
		
		entry.Reward(plr)
	end
end

-----------------------------
return module
