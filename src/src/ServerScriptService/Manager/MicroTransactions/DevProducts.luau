local module 							= {}

------------------------------------
--// Services
local marketplaceService 				= game:GetService("MarketplaceService")
local players 							= game:GetService("Players")
local replicatedStorage 				= game:GetService("ReplicatedStorage")
local dataStoreService					= game:GetService("DataStoreService")

--//Purchase
local purchaseHistoryStore 				= dataStoreService:GetDataStore("PurchaseHistory")
local productFunctions 					= {}

--// Modules
local otherModules						= 
	{
		["RobuxCapsules"]				= require(script.Parent.Parent["RobuxCapsules"]),
		["Data_Module"]                 = require(replicatedStorage.Data_Module)
	}

--//Settings
local activeRobuxEgg					= otherModules["RobuxCapsules"].ActiveEgg()

------------------------------
--//Products

local function ProcessReceipt(receiptInfo)
	local playerProductKey 				= receiptInfo.PlayerId .. "_" .. receiptInfo.PurchaseId
	local purchased 					= false

	local success, errorMessage 		= pcall(function()
		purchased 						= purchaseHistoryStore:GetAsync(playerProductKey)
	end)

	if success and purchased 			then
		return Enum.ProductPurchaseDecision.PurchaseGranted

	elseif not success 					then
		local plr 						= players:GetPlayerByUserId(receiptInfo.PlayerId)
		error("Data store error:" .. errorMessage)

	end

	local plr 							= players:GetPlayerByUserId(receiptInfo.PlayerId)
	if not plr 							then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	local handler 						= productFunctions[receiptInfo.ProductId]
	local success, result 				= pcall(handler, receiptInfo, plr)

	if not success or not result then
		warn("Error occurred while processing a product purchase")
		--print("\nProductId:", receiptInfo.ProductId)
		--print("\nPlayer:", plr)
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	local success, errorMessage 		= pcall(function()
		purchaseHistoryStore:SetAsync(playerProductKey, true)
	end)

	if not success then
		error("Cannot save purchase data: " .. errorMessage)
	end

	return Enum.ProductPurchaseDecision.PurchaseGranted
end

task.spawn(function()
	for i, entry in pairs(activeRobuxEgg.Prices) 	do
		productFunctions[entry.Code]	= function(receipt, plr)
			if not plr 					then return end

			task.spawn(function()
				otherModules["RobuxCapsules"].Open(plr, entry.Amount)
			end)
			
			return true
		end
	end
	
	for i, entry in pairs(otherModules.Data_Module.Currencies) 	do
		
		for number,product in pairs(entry["Dev_Products"]) do
			
		productFunctions[product]	= function(receipt, plr)
			if not plr 					then return end

			task.spawn(function()
				local Player_Data = plr["Player_Data"]
				local Currency = Player_Data:FindFirstChild(entry["Currency_Name"])
					
				if not Currency then return end
					
				local Amount = number == 1 and 50 or number == 2 and 200 or number == 3 and 500 or 1000
				
				Currency.Value += Amount
			end)

			return true
		end
		
		end
		
	end
		
	task.wait(1)
	marketplaceService.ProcessReceipt 	= ProcessReceipt
end)

-----------------------------
return module
