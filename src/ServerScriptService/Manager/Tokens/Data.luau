local module 						= {}
-----------------------------------
--//Services
local replicatedStorage				= game:GetService("ReplicatedStorage")
local serverStorage					= game:GetService("ServerStorage")

--//References
local assetsFolder					= replicatedStorage["Assets"]
local tokenFolder					= assetsFolder["Tokens"]

-----------------------------------
module.List 						= 
	{
		["Baam"] 					=	
		{
			DisplayName 			= "Baam Token",
			Icon 					= "rbxassetid://130416747139754",
			Model 					= tokenFolder["Baam"],
			
			Desc 					= "Obtained: Defeated Baam Villain",
			Boosts 					= 
			{
				["Energy"]			= 0,
				["Damage"]			= 0.3,
				["Gems"]			= 0,
			},
		},
		
		["Deku"] 					=	
		{
			DisplayName 			= "Deku Token",
			Icon 					= "rbxassetid://103599757045471",
			Model 					= tokenFolder["Deku"],

			Desc 					= "Obtained: Defeated Shigaraki",
			Boosts 					= 
			{
				["Energy"]			= 0,
				["Damage"]			= 0,
				["Gems"]			= 0.2,
			},
		},
		
		["Goje"] 					=	
		{
			DisplayName 			= "Goje Token",
			Icon 					= "rbxassetid://122583070660121",
			Model 					= tokenFolder["Goje"],

			Desc 					= "Obtained: Defeated Kenjaku",
			Boosts 					= 
			{
				["Energy"]			= 0,
				["Damage"]			= 0.2,
				["Gems"]			= 0,
			},
		},
		
		["Kurama"] 					=	
		{
			DisplayName 			= "Kurama Token",
			Icon 					= "rbxassetid://78555330256767",
			Model 					= tokenFolder["Kurama"],

			Desc 					= "Obtained: Defeated Nine Tale Naruto",
			Boosts 					= 
			{
				["Energy"]			= 0.2,
				["Damage"]			= 0,
				["Gems"]			= 0,
			},
		},
		
		["Luffy"] 					=	
		{
			DisplayName 			= "Luffy Token",
			Icon 					= "rbxassetid://88846526820707",
			Model 					= tokenFolder["Luffy"],

			Desc 					= "Obtained: Defeated Shanks",
			Boosts 					= 
			{
				["Energy"]			= 0,
				["Damage"]			= 0,
				["Gems"]			= 0.3,
			},
		},
		
		["Sung"] 					=	
		{
			DisplayName 			= "Sung Token",
			Icon 					= "rbxassetid://117396084618518",
			Model 					= tokenFolder["Sung"],

			Desc 					= "Obtained: Defeated Sung Villain",
			Boosts 					= 
			{
				["Energy"]			= 0,
				["Damage"]			= 0.4,
				["Gems"]			= 0,
			},
		},
		
		["Zeldris"] 				=	
		{
			DisplayName 			= "Zeldris Token",
			Icon 					= "rbxassetid://133784664402115",
			Model 					= tokenFolder["Zeldris"],

			Desc 					= "Obtained: Defeated Meliodes",
			Boosts 					= 
			{
				["Energy"]			= 0,
				["Damage"]			= 0,
				["Gems"]			= 0.4,
			},
		},
	}

-----------------------------------
return module
