local module 						= {}
-----------------------------------
--//Services
local replicatedStorage				= game:GetService("ReplicatedStorage")
local serverStorage					= game:GetService("ServerStorage")

-----------------------------------
module.List 						= 
	{
		[0] 						=	
		{
			DisplayName 			= "Newbie",
			Icon 					= "rbxassetid://87502214343984",
			Cost 					= 0,

			Upgrades 				= 
			{
				Energy 				= 1,
				Gems 				= 1,
				Damage 				= 1,
			},
		},
		
		[1] 						=	
		{
			DisplayName 			= "BUCCANEER I",
			Icon 					= "rbxassetid://106666029876986",
			Cost 					= 10000,
			
			Upgrades 				= 
			{
				Energy 				= 1.5,
				Gems 				= 1,
				Damage 				= 1.5,
			},
		},
		
		[2] 						=	
		{
			DisplayName 			= "BUCCANEER II",
			Icon 					= "rbxassetid://134986081093502",
			Cost 					= 25000,

			Upgrades 				= 
			{
				Energy 				= 2,
				Gems 				= 1,
				Damage 				= 2,
			},
		},
		
		[3] 						=	
		{
			DisplayName 			= "BUCCANEER III",
			Icon 					= "rbxassetid://139973051672853",
			Cost 					= 250000,

			Upgrades 				= 
			{
				Energy 				= 3,
				Gems 				= 1,
				Damage 				= 3,
			},
		},
		
		[4] 						=	
		{
			DisplayName 			= "BUCCANEER IV",
			Icon 					= "rbxassetid://135953745784082",
			Cost 					= 2500000,

			Upgrades 				= 
			{
				Energy 				= 4,
				Gems 				= 1,
				Damage 				= 4,
			},
		},
		
		[5] 						=	
		{
			DisplayName 			= "BUCCANEER V",
			Icon 					= "rbxassetid://138413702936274",
			Cost 					= 25000000,

			Upgrades 				= 
			{
				Energy 				= 5.5,
				Gems 				= 1,
				Damage 				= 5.5,
			},
		},
		
		[6] 						=	
		{
			DisplayName 			= "RAIDER I",
			Icon 					= "rbxassetid://137320258599928",
			Cost 					= 75000000,

			Upgrades 				= 
			{
				Energy 				= 8,
				Gems 				= 1,
				Damage 				= 8,
			},
		},
		
		[7] 						=	
		{
			DisplayName 			= "RAIDER II",
			Icon 					= "rbxassetid://134335735960445",
			Cost 					= 200000000,

			Upgrades 				= 
			{
				Energy 				= 10.5,
				Gems 				= 1,
				Damage 				= 10.5,
			},
		},
	}

-----------------------------------
return module
