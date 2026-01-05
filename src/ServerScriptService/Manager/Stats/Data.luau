local module 						= {}
-----------------------------------
--//Services
local replicatedStorage				= game:GetService("ReplicatedStorage")
local serverStorage					= game:GetService("ServerStorage")

-----------------------------------
module.List 						= 
	{
		[1] 						=	
		{
			DisplayName 			= "Enemies Defeated",	
			Type 					= "Enemies",

		},
		
		[2] 						=	
		{
			DisplayName 			= "Eggs Hatched",	
			Type 					= "Eggs",
		},
		
		[3] 						=	
		{
			DisplayName 			= "Time Played",	
			Type 					= "Playtime",
		},
		
		[4] 						=	
		{
			DisplayName 			= "Energy Boosts",	
			Type 					= "Boosts",
			SubType 				= "Energy",
		},
		
		[5] 						=	
		{
			DisplayName 			= "Damage Boosts",	
			Type 					= "Boosts",
			SubType 				= "Damage",
		},
		
		[6] 						=	
		{
			DisplayName 			= "Gems Boosts",	
			Type 					= "Boosts",
			SubType 				= "Gems",
		},
	}

-----------------------------------
return module
