local module 							= {}

----------------------------------------
--//Services
local marketplaceService				= game:GetService("MarketplaceService")
local replicatedStorage					= game:GetService("ReplicatedStorage")
local userInputService					= game:GetService("UserInputService")
local playersService					= game:GetService("Players")
local tweenService						= game:GetService("TweenService")

--//References
local modelsFolder						= replicatedStorage.Assets.Objects.Eggs

--//Tables
module.Eggs 							= 
	{
		[1] 							= 
		{
			DisplayName					= "Normal Egg",
			Image						= "12210948506",
			
			EggModel					= modelsFolder["01"],
			
			Cost 						= 250,
			CurrencyType 				= "Fork",
			
			Pets 						= 
			{
				{Name = "Fushiguro", 	Percentage = 40},
				{Name = "Geto", 		Percentage = 30},
				{Name = "Goje", 		Percentage = 25},
				{Name = "Nobara", 		Percentage = 4.4},
				{Name = "Sukuna", 		Percentage = 0.6},
			}
		},

	}

----------------------------------------
return module
