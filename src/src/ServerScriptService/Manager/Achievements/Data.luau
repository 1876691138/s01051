local module 						= {}
-----------------------------------
--//Services
local replicatedStorage				= game:GetService("ReplicatedStorage")
local serverStorage					= game:GetService("ServerStorage")

-----------------------------------
-- Types Are:
-- "Enemies"
-- "Eggs"
-- "Playtime"

module.List 						= 
	{
		["Kill I"] 					=	
		{
			DisplayName 			= "Kill I",
			Image 					= "rbxassetid://128592214047807",
			Tier					= 1,
			
			Type 					= "Enemies",
			Target					= 100,
			Desc 					= "Kill 100 Enemies to get the permanenet boost reward!",
			LayoutOrder				= 1,
	
			Reward 					= 
			{
				Boosts 				= 
				{
					["Energy"]		= 0,
					["Damage"]		= 0,
					["Gems"]		= 0.1,
				},
				
				Fighter				= nil,
			},
		},
		
		["Kill II"] 				=	
		{
			DisplayName 			= "Kill II",
			Image 					= "rbxassetid://98561069380748",
			Tier					= 2,

			Type 					= "Enemies",
			Target					= 1000,
			Desc 					= "Kill 1K Enemies to get the permanenet boost reward!",
			LayoutOrder				= 2,

			Reward 					= 
			{
				Boosts 				= 
				{
					["Energy"]		= 0,
					["Damage"]		= 0,
					["Gems"]		= 0.25,
				},

				Fighter				= nil,
			},
		},
		
		["Kill III"] 				=	
		{
			DisplayName 			= "Kill III",
			Image 					= "rbxassetid://74540654639612",
			Tier					= 3,

			Type 					= "Enemies",
			Target					= 10000,
			Desc 					= "Kill 10K Enemies to get the permanenet boost reward!",
			LayoutOrder				= 3,

			Reward 					= 
			{
				Boosts 				= 
				{
					["Energy"]		= 0,
					["Damage"]		= 0,
					["Gems"]		= 0.5,
				},

				Fighter				= nil,
			},
		},
		
		["Kill IV"] 				=	
		{
			DisplayName 			= "Kill IV",
			Image 					= "rbxassetid://88614917770751",
			Tier					= 4,

			Type 					= "Enemies",
			Target					= 100000,
			Desc 					= "Kill 100K Enemies to get the permanenet boost reward!",
			LayoutOrder				= 4,

			Reward 					= 
			{
				Boosts 				= 
				{
					["Energy"]		= 0,
					["Damage"]		= 0,
					["Gems"]		= 1,
				},

				Fighter				= nil,
			},
		},
		
		["Kill V"] 					=	
		{
			DisplayName 			= "Kill V",
			Image 					= "rbxassetid://98039445071298",
			Tier					= 5,

			Type 					= "Enemies",
			Target					= 1000000,
			Desc 					= "Kill 1M Enemies to get the permanenet boost reward!",
			LayoutOrder				= 5,

			Reward 					= 
			{
				Boosts 				= 
				{
					["Energy"]		= 0,
					["Damage"]		= 0,
					["Gems"]		= 1.5,
				},

				Fighter				= nil,
			},
		},
		
		
		["Star I"] 					=	
		{
			DisplayName 			= "Star I",	
			Image 					= "rbxassetid://72577452727723",
			Tier					= 1,

			Type 					= "Eggs",
			Target					= 100,
			Desc 					= "Hatch 100 Eggs to get the permanenet boost reward!",
			LayoutOrder				= 6,

			Reward 					= 
			{
				Boosts 				= 
				{
					["Energy"]		= 0.1,
					["Damage"]		= 0,
					["Gems"]		= 0,
				},
				
				Fighter				= nil,
			},
		},
		
		["Star II"] 				=	
		{
			DisplayName 			= "Star II",
			Image 					= "rbxassetid://86047322300376",
			Tier					= 2,

			Type 					= "Eggs",
			Target					= 1000,
			Desc 					= "Hatch 1K Eggs to get the permanenet boost reward!",
			LayoutOrder				= 7,

			Reward 					= 
			{
				Boosts 				= 
				{
					["Energy"]		= 0.25,
					["Damage"]		= 0,
					["Gems"]		= 0,
				},

				Fighter				= nil,
			},
		},
		
		["Star III"] 				=	
		{
			DisplayName 			= "Star III",
			Image 					= "rbxassetid://75622817840064",
			Tier					= 3,

			Type 					= "Eggs",
			Target					= 10000,
			Desc 					= "Hatch 10K Eggs to get the permanenet boost reward!",
			LayoutOrder				= 8,

			Reward 					= 
			{
				Boosts 				= 
				{
					["Energy"]		= 0.5,
					["Damage"]		= 0,
					["Gems"]		= 0,
				},

				Fighter				= nil,
			},
		},
		
		["Star IV"] 				=	
		{
			DisplayName 			= "Star IV",
			Image 					= "rbxassetid://123205228137433",
			Tier					= 4,

			Type 					= "Eggs",
			Target					= 100000,
			Desc 					= "Hatch 100K Eggs to get the permanenet boost reward!",
			LayoutOrder				= 9,

			Reward 					= 
			{
				Boosts 				= 
				{
					["Energy"]		= 1,
					["Damage"]		= 0,
					["Gems"]		= 0,
				},

				Fighter				= nil,
			},
		},
		
		["Star V"] 				=	
		{
			DisplayName 			= "Star V",
			Image 					= "rbxassetid://137177048760213",
			Tier					= 5,

			Type 					= "Eggs",
			Target					= 1000000,
			Desc 					= "Hatch 1M Eggs to get the permanenet boost reward!",
			LayoutOrder				= 10,

			Reward 					= 
			{
				Boosts 				= 
				{
					["Energy"]		= 1.5,
					["Damage"]		= 0,
					["Gems"]		= 0,
				},

				Fighter				= nil,
			},
		},
		
		["Timer I"] 				=	
		{
			DisplayName 			= "Timer I",
			Image 					= "rbxassetid://93588614147255",
			Tier					= 1,

			Type 					= "Playtime",
			Target					= 1800,
			Desc 					= "Play for 30 Minutes to get the permanenet boost reward!",
			LayoutOrder				= 11,

			Reward 					= 
			{
				Boosts 				= 
				{
					["Energy"]		= 0,
					["Damage"]		= 0.1,
					["Gems"]		= 0,
				},
				
				Fighter				= nil,
			},
		},
		
		["Timer II"] 				=	
		{
			DisplayName 			= "Timer II",
			Image 					= "rbxassetid://104425876104748",
			Tier					= 2,

			Type 					= "Playtime",
			Target					= 3600,
			Desc 					= "Play for 1 Hour to get the permanenet boost reward!",
			LayoutOrder				= 12,

			Reward 					= 
			{
				Boosts 				= 
				{
					["Energy"]		= 0,
					["Damage"]		= 0.25,
					["Gems"]		= 0,
				},

				Fighter				= nil,
			},
		},
		
		["Timer III"] 				=	
		{
			DisplayName 			= "Timer III",
			Image 					= "rbxassetid://132820943891051",
			Tier					= 3,

			Type 					= "Playtime",
			Target					= 18000,
			Desc 					= "Play for 5 Hours to get the permanenet boost reward!",
			LayoutOrder				= 13,

			Reward 					= 
			{
				Boosts 				= 
				{
					["Energy"]		= 0,
					["Damage"]		= 0.5,
					["Gems"]		= 0,
				},

				Fighter				= nil,
			},
		},
		
		["Timer IV"] 				=	
		{
			DisplayName 			= "Timer IV",
			Image 					= "rbxassetid://118963770488747",
			Tier					= 4,

			Type 					= "Playtime",
			Target					= 36000,
			Desc 					= "Play for 10 Hours to get the permanenet boost reward!",
			LayoutOrder				= 14,

			Reward 					= 
			{
				Boosts 				= 
				{
					["Energy"]		= 0,
					["Damage"]		= 1,
					["Gems"]		= 0,
				},

				Fighter				= nil,
			},
		},
		
		["Timer V"] 				=	
		{
			DisplayName 			= "Timer V",
			Image 					= "rbxassetid://104165140392007",
			Tier					= 5,
			
			Type 					= "Playtime",
			Target					= 86400,
			Desc 					= "Play for 1 Day to get the permanenet boost reward!",
			LayoutOrder				= 15,

			Reward 					= 
			{
				Boosts 				= 
				{
					["Energy"]		= 0,
					["Damage"]		= 1.5,
					["Gems"]		= 0,
				},

				Fighter				= nil,
			},
		},
	}

-----------------------------------
return module
