local module 							= {}

----------------------------------------
--//Services
local marketplaceService				= game:GetService("MarketplaceService")
local replicatedStorage					= game:GetService("ReplicatedStorage")

--//Tables
module.ActiveEgg 						= 
	{
		DisplayName						= "1st Update Egg",

		Fighters 						= 
		{
			[1]							=
			{
				-- Rare
				Name 					= "Zero", 			
				Icon 					= "rbxassetid://3583316602", 
				Percentage 				= 40,
			},
			
			[2]							=
			{
				-- Epic
				Name 					= "Lefty", 			
				Icon 					= "rbxassetid://12702090050", 
				Percentage 				= 35,
			},	
			
			[3]							=
			{
				-- Legendary
				Name 					= "Buggie", 			
				Icon 					= "rbxassetid://87606029372902", 
				Percentage 				= 20,
			},	
			
			[4]							=
			{
				-- Mythical
				Name 					= "Snake", 			
				Icon 					= "rbxassetid://116448307659899", 
				Percentage 				= 5,
			},	
		},
		
		Prices 							= 
		{
			{Code = 3336776386, Amount = 1},
			{Code = 3336776668, Amount = 3},
			{Code = 3336776890, Amount = 5},
		}
	}

----------------------------------------
-- Adjust each item's chance based on its rarity and the passes
local function applyLuckBoost(item, luckyMultiplier)
	-- Boost rare items more, but keep control
	local rarityWeight 					= (1 / item.Percentage) -- more rare → more weight
	local boost 						= (item.Percentage * luckyMultiplier * rarityWeight * 0.1) -- Tuned boost
	
	return item.Percentage + boost
end

function module.PickRandomItem(plr)
	-- Calculate total luck multiplier
	local luckyMultiplier 				= 0
	if plr["Passes"]["Lucky"]      		then 
		luckyMultiplier 				+= 0.10
	end
	
	if plr["Passes"]["SuperLucky"] 		then 
		luckyMultiplier 				+= 0.25 
	end
	
	if plr["Passes"]["UltraLucky"] 		then 
		luckyMultiplier 				+= 0.50 
	end

	local adjustedItems 				= {}
	local sum 							= 0

	for _, item in ipairs(module.ActiveEgg.Fighters) 		do
		-- Apply a milder rarity-based luck boost
		local adjusted 					= applyLuckBoost(item, luckyMultiplier)
		sum 							+= adjusted
		table.insert(adjustedItems, {
			Name 						= item.Name,
			AdjustedPercentage 			= adjusted,
			Original 					= item
		})
	end

	local pick 							= math.random() * sum
	local total 						= 0

	for _, item in ipairs(adjustedItems) do
		total 							+= item.AdjustedPercentage
		
		local isCorrect					= pick <= total 
		if not isCorrect 				then continue end
		
		return item.Original
	end
end

-----------------------------------
return module
