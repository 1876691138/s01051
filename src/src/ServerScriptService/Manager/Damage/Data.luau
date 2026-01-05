local module 						= {}
-----------------------------------
--//Services
local replicatedStorage				= game:GetService("ReplicatedStorage")
local serverStorage					= game:GetService("ServerStorage")

--//References
local assetsFolder					= replicatedStorage["Assets"]
local tokensFolder					= assetsFolder["Tokens"]

-----------------------------------
module.Secret 						= 
	{
		["Shank"] 					=	
		{
			DisplayName 			= "Shanks",
			Token 					= 
			{
				Name 				= "Luffy",
				Percentage 			= 10,
			}
		},
	}

-----------------------------------
return module
