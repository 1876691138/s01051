local module 						= {}
-----------------------------------
--//Services
local replicatedStorage				= game:GetService("ReplicatedStorage")
local serverStorage					= game:GetService("ServerStorage")

--//References
local scriptablesFolder				= game.Workspace["Scriptables"]
local teleportsFolder				= scriptablesFolder["Teleports"]

-----------------------------------
module.List 						= 
	{
		["0"] 						=	
		{
			DisplayName 			= "Spawn Point",	
			Model 					= teleportsFolder["0"],	
			LayoutOrder				= 0,

			Unlock					= 
			{
				Currency 			= "Gems",
				Cost 				= 0,
			}
		},
		
		["1"] 						=	
		{
			DisplayName 			= "One Island",	
			Model 					= teleportsFolder["1"],	
			LayoutOrder				= 1,

			Unlock					= 
			{
				Currency 			= "Gems",
				Cost 				= 0,
			}
		},
		
		["2"] 						=	
		{
			DisplayName 			= "Solo Tower",	
			Model 					= teleportsFolder["2"],	
			LayoutOrder				= 2,

			Unlock					= 
			{
				Currency 			= "Gems",
				Cost 				= 10000,
			}
		},
		
		["3"] 						=	
		{
			DisplayName 			= "Floating Brittania",	
			Model 					= teleportsFolder["3"],	
			LayoutOrder				= 3,

			Unlock					= 
			{
				Currency 			= "Gems",
				Cost 				= 9999999999,
			}
		},
		
		["4"] 						=	
		{
			DisplayName 			= "Shibuya Jitsu",	
			Model 					= teleportsFolder["4"],	
			LayoutOrder				= 4,

			Unlock					= 
			{
				Currency 			= "Gems",
				Cost 				= 9999999999,
			}
		},
		
		["5"] 						=	
		{
			DisplayName 			= "Peaking Academy",	
			Model 					= teleportsFolder["5"],	
			LayoutOrder				= 5,

			Unlock					= 
			{
				Currency 			= "Gems",
				Cost 				= 9999999999,
			}
		},
	}

-----------------------------------
return module
