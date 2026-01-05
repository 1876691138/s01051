local module 							= {}
-----------------------------------
--//Services
local replicatedStorage					= game:GetService("ReplicatedStorage")
local serverStorage						= game:GetService("ServerStorage")

-----------------------------------
module.List 							= 
	{
		----------------
		-- FIGHTERS INVENTORY
		
		["Small Storage"]				= 
		{
			Name 						= "+50 Fighter Slots",
			Code 						= 1031687750,
			Reward						= function(plr)
				task.spawn(function()
					local maxInv		= plr:WaitForChild("Fighters"):WaitForChild("MaxInventory")
					maxInv.Value  		+= 50
				end)
			end,
		},
		
		["Big Storage"]					= 
		{
			Name 						= "+100 Fighter Slots",
			Code 						= 1327643743,
			Reward						= function(plr)
				task.spawn(function()
					local maxInv		= plr:WaitForChild("Fighters"):WaitForChild("MaxInventory")
					maxInv.Value  		+= 100
				end)
			end,
		},

		["+2 Equips"]					= 
		{
			Name 						= "+2 Equips",
			Code 						= 1032094429,
			Reward						= function(plr)
				task.spawn(function()
					plr:WaitForChild("Fighters"):WaitForChild("MaxEquip").Value  		+= 2
				end)
			end,
		},
		
		----------------
		-- HATCHING
		
		["Auto Open"]					= 
		{
			Name 						= "Auto Open",
			Code 						= 1032046415,
			Reward						= function(plr)
			end,
		},

		["More Eggs"]					= 
		{
			Name 						= "+2 Opens",
			Code 						= 1031506146,
			Reward						= function(plr)
			end,
		},
		
		["Fast Open"]					= 
		{
			Name 						= "Fast Open",
			Code 						= 1326220194,
			Reward						= function(plr)
			end,
		},
		
		----------------
		-- X2 BOOSTS
		
		["x2 Gems"]						= 
		{
			Name 						= "x2 Gems",
			Code 						= 1322079152,
			Reward						= function(plr)
			end,
		},

		["x2 Energy"]					= 
		{
			Name 						= "x2 Energy",
			Code 						= 1326232325,
			Reward						= function(plr)
			end,
		},

		["x2 Damage"]					= 
		{
			Name 						= "x2 Damage",
			Code 						= 1325408574,
			Reward						= function(plr)
			end,
		},

		----------------
		["Teleport GUI"]				= 
		{
			Name 						= "Teleport",
			Code 						= 904849351,
			Reward						= function(plr)
			end,
		},

		["AutoClicker"]					= 
		{
			Name 						= "AutoClicker",
			Code 						= 902323795,
			Reward						= function(plr)
				local target			= plr:WaitForChild("Passes"):WaitForChild("AutoClicker")
				target.Value  			= true
			end,
		},
		
		["Magnet"]						= 
		{
			Name 						= "Magnet",
			Code 						= 904772555,
			Reward						= function(plr)
			end,
		},
		
		----------------
		-- LUCKY PASSES
		
		["Lucky"]						= 
		{
			Name 						= "Lucky",
			Code 						= 1327385842,
			Reward						= function(plr)
				local target			= plr:WaitForChild("Passes"):WaitForChild("Lucky")
				target.Value  			= true
			end,
		},
		
		["SuperLucky"]					= 
		{
			Name 						= "Super Lucky",
			Code 						= 1326200285,
			Reward						= function(plr)
				local target			= plr:WaitForChild("Passes"):WaitForChild("SuperLucky")
				target.Value  			= true
			end,
		},
		
		["UltraLucky"]					= 
		{
			Name 						= "Ultra Lucky!",
			Code 						= 1326056320,
			Reward						= function(plr)
				local target			= plr:WaitForChild("Passes"):WaitForChild("UltraLucky")
				target.Value  			= true
			end,
		},
		
		----------------
		["VIP"]							= 
		{
			Name 						= "VIP",
			Code 						= 885072361,
			Reward						= function(plr)
				-- (gain boosts such as exclusive title on screen and in chat, exclusive token and walk speed increase).
				
				local target			= plr:WaitForChild("Passes"):WaitForChild("VIP")
				target.Value  			= true
				
				module.AddToken(plr, "Kurama")
			end,
		},
		
		["SuperVIP"]					= 
		{
			Name 						= "Flash VIP",
			Code 						= 1321669180,
			Reward						= function(plr)
				-- (gain boosts such as exclusive title on screen and in chat, exclusive token and x2 energy boost).

				local target			= plr:WaitForChild("Passes"):WaitForChild("SuperVIP")
				target.Value  			= true
				
				
				module.AddToken(plr, "Kurama")
			end,
		},

		----------------
	}

-----------------------------------
function module.AddToken(plr, id)
	local plrTokens						= plr:WaitForChild("Tokens", 5)
	if not plrTokens					then return end

	local exist							= plrTokens:FindFirstChild(id)
	if exist							then return end

	local clone							= Instance.new("StringValue", plrTokens)
	clone.Name							= id
	clone.Value							= id
end

-----------------------------------
return module
