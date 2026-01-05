local module 						= {}
-----------------------------------
--//Services
local replicatedStorage				= game:GetService("ReplicatedStorage")
local serverStorage					= game:GetService("ServerStorage")

--//References
local fightersFolder				= replicatedStorage.Assets.Fighters

-----------------------------------
module.List 						= 
	{

		------------------
		--// Egg 1 Fighters
		
		["Numi"] 				=	
		{
			DisplayName 			= "Numi",	
			Model 					= fightersFolder["1"]:WaitForChild("Numi"),	
			Rarity 					= "Common",
			
			Stats 					= 
			{
				Energy 				= 2.5,
			},
		},
		
		["Usep"] 				=	
		{
			DisplayName 			= "Usep",	
			Model 					= fightersFolder["1"]:WaitForChild("Usep"),	
			Rarity 					= "Common",

			Stats 					= 
			{
				Energy 				= 2.5,
			},
		},
		
		["Senjo"] 					=	
		{
			DisplayName 			= "Senjo",	
			Model 					= fightersFolder["1"]:WaitForChild("Senjo"),	
			Rarity 					= "Rare", 

			Stats 					= 
			{
				Energy 				= 4,
			},
		},
		
		["Zero"] 					=	
		{
			DisplayName 			= "Zero",	
			Model 					= fightersFolder["1"]:WaitForChild("Zero"),	
			Rarity 					= "Epic", 

			Stats 					= 
			{
				Energy 				= 6,
			},
		},
		
		["Lefty"] 					=	
		{
			DisplayName 			= "Lefty",	
			Model 					= fightersFolder["1"]:WaitForChild("Lefty"),	
			Rarity 					= "Legendary", 

			Stats 					= 
			{
				Energy 				= 8,
			},
		},
		
		["Buggie"] 					=	
		{
			DisplayName 			= "Buggie",	
			Model 					= fightersFolder["1"]:WaitForChild("Buggie"),	
			Rarity 					= "Mythical", 

			Stats 					= 
			{
				Energy 				= 10,
			},
		},
		
		["Snake"] 					=	
		{
			DisplayName 			= "Snake",	
			Model 					= fightersFolder["1"]:WaitForChild("Snake"),	
			Rarity 					= "Secret", 

			Stats 					= 
			{
				Energy 				= 15,
			},
		},
		
		------------------
		--// Egg 2 Fighters

		["Anne"] 				=	
		{
			DisplayName 			= "Anne",	
			Model 					= fightersFolder["2"]:WaitForChild("Anne"),	
			Rarity 					= "Common",

			Stats 					= 
			{
				Energy 				= 10,
			},
		},
		
		["Meliodos"] 				=	
		{
			DisplayName 			= "Meliodos",	
			Model 					= fightersFolder["2"]:WaitForChild("Meliodos"),	
			Rarity 					= "Common",

			Stats 					= 
			{
				Energy 				= 15,
			},
		},

		["Erin"] 					=	
		{
			DisplayName 			= "Erin",	
			Model 					= fightersFolder["2"]:WaitForChild("Erin"),	
			Rarity 					= "Rare", 

			Stats 					= 
			{
				Energy 				= 20,
			},
		},

		["Armin"] 					=	
		{
			DisplayName 			= "Armin",	
			Model 					= fightersFolder["2"]:WaitForChild("Armin"),	
			Rarity 					= "Epic", 

			Stats 					= 
			{
				Energy 				= 30,
			},
		},

		["Baam"] 					=	
		{
			DisplayName 			= "Baam",	
			Model 					= fightersFolder["2"]:WaitForChild("Baam"),	
			Rarity 					= "Legendary", 

			Stats 					= 
			{
				Energy 				= 40,
			},
		},

		["Bakugo"] 					=	
		{
			DisplayName 			= "Bakugo",	
			Model 					= fightersFolder["2"]:WaitForChild("Bakugo"),	
			Rarity 					= "Mythical", 

			Stats 					= 
			{
				Energy 				= 50,
			},
		},

		["Bone"] 					=	
		{
			DisplayName 			= "Bone",	
			Model 					= fightersFolder["2"]:WaitForChild("Bone"),	
			Rarity 					= "Secret", 

			Stats 					= 
			{
				Energy 				= 60,
			},
		},

		------------------
	}

-----------------------------------
return module
