local module 							= {}

----------------------------------------
--//Services
local marketplaceService				= game:GetService("MarketplaceService")
local replicatedStorage					= game:GetService("ReplicatedStorage")

--//References
local capsulesFolder					= game.Workspace.Scriptables.Capsules

--//Tables
module.List 							= 
	{
		[1] 							= 
		{
			DisplayName					= "1st Egg",
			Model 						= capsulesFolder["1"],
			Cost 						= 50,
			PityAmount					= 1000,
			
			Fighters 					= 
			{
				{Name = "Numi",     	Percentage = 40},			-- Common
				{Name = "Usep", 		Percentage = 25},			-- Common
				{Name = "Senjo", 		Percentage = 15},			-- Rare
				{Name = "Zero", 		Percentage = 5},			-- Epic
				{Name = "Lefty", 		Percentage = 4.5},			-- Legendary
				{Name = "Buggie", 		Percentage = 0.49},			-- Mythical
				{Name = "Snake", 		Percentage = 0.01},			-- Secret
			}
		},
		
		[2] 							= 
		{
			DisplayName					= "2nd Egg",
			Model 						= capsulesFolder["2"],
			Cost 						= 100,
			PityAmount					= 1000,
			
			Fighters 					= 
			{
				{Name = "Anne", 		Percentage = 30},			-- Common
				{Name = "Meliodos", 	Percentage = 30},			-- Common
				{Name = "Erin", 		Percentage = 20},			-- Rare
				{Name = "Armin", 		Percentage = 10},			-- Epic
				{Name = "Baam", 		Percentage = 8},			-- Legendary
				{Name = "Bakugo", 		Percentage = 1.9},			-- Mythical
				{Name = "Bone", 		Percentage = 0.1},			-- Secret
			}
		},

	}

----------------------------------------
-- Adjust each item's chance based on its rarity and the passes
local function applyLuckBoost(item, luckyMultiplier)
	-- Boost rare items more, but keep control
	local rarityWeight 					= (1 / item.Percentage) -- more rare → more weight
	local boost 						= (item.Percentage * luckyMultiplier * rarityWeight * 0.1) -- Tuned boost
	
	return item.Percentage + boost
end

function module.PickRandomItem(items, plr)
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

	for _, item in ipairs(items) 		do
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
