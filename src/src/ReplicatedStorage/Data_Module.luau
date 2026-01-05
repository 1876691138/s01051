local module = {}


module.Currencies = {
	
	Fruits = {
		Currency_Name = "Fruits";

		Currency_Image = "rbxassetid://129695395030040";
		
		Crate_Price = 1;

		Dev_Products = {
			[1] = 425456451,

			[2] = 456465123,
			
			[3] = 425456451,

			[4] = 456465123,
		}
	};

	Quirks = {
		Currency_Name = "Quirks";

		Currency_Image = "";
		
		Crate_Price = 1;

		Dev_Products = {
			[1] = 425456451,

			[3] = 456465123,

			[2] = 425456451,

			[4] = 456465123,
		}
	}
	
}

module.Items = {

	Fruits = {

		["Paw Paw"] = {Rarity = "Common",Chance = 60, Show_Chance = true,Image = "rbxassetid://111195538313683",Layout_Order = 1},

		["Rumble Rumble"] = {Rarity = "Uncommon",Chance = 30, Show_Chance = true,Image = "rbxassetid://130875557662206",Layout_Order = 2},

		["Flower Flower"] = {Rarity = "Rare",Chance = 7.9, Show_Chance = true,Image = "rbxassetid://134373203775937",Layout_Order = 3},

		["Tremor Tremor"] = {Rarity = "Legendary",Chance = 1, Show_Chance = true,Image = "rbxassetid://119104514992569",Layout_Order = 4},

		["Flame Flame"] = {Rarity = "Legendary",Chance = 1, Show_Chance = true,Image = "rbxassetid://96050913683375",Layout_Order = 5},

		["Soul Soul"] = {Rarity = "Mythic",Chance = 0.04, Show_Chance = true,Image = "rbxassetid://138015694242697",Layout_Order = 6},

		["Wind Wind"] = {Rarity = "Mythic",Chance = 0.04, Show_Chance = true,Image = "rbxassetid://135291007734510",Layout_Order = 7},

		["Tweet Tweet"] = {Rarity = "Godly",Chance = 0.0067, Show_Chance = false,Image = "rbxassetid://138015694242697",Layout_Order = 8},

		["Fish Fish"] = {Rarity = "Godly",Chance = 0.0067, Show_Chance = false,Image = "rbxassetid://138015694242697",Layout_Order = 9},

		["Time Time"] = {Rarity = "Godly",Chance = 0.0067, Show_Chance = false,Image = "rbxassetid://138015694242697",Layout_Order = 10},

	},

	Quirks = {
		
		["Paku Paku"] = {Rarity = "Common",Chance = 60, Show_Chance = true,Image = "rbxassetid://",Layout_Order = 1},

		["Doro Doro"] = {Rarity = "Uncommon",Chance = 30, Show_Chance = true,Image = "rbxassetid://",Layout_Order = 2},

		["Bana Bana"] = {Rarity = "Rare",Chance = 7.9, Show_Chance = true,Image = "rbxassetid://",Layout_Order = 3},

		["Rura Rura"] = {Rarity = "Legendary",Chance = 1, Show_Chance = true,Image = "rbxassetid://",Layout_Order = 4},

		["Fira Fira"] = {Rarity = "Legendary",Chance = 1, Show_Chance = true,Image = "rbxassetid://",Layout_Order = 5},

		["Neru Neru"] = {Rarity = "Mythic",Chance = 0.04, Show_Chance = true,Image = "rbxassetid://",Layout_Order = 6},

		["Kaze Kaze"] = {Rarity = "Mythic",Chance = 0.04, Show_Chance = true,Image = "rbxassetid://",Layout_Order = 7},

		["Ryu Ryu"] = {Rarity = "Godly",Chance = 0.0067, Show_Chance = false,Image = "rbxassetid://",Layout_Order = 8},

		["Moki Moki"] = {Rarity = "Godly",Chance = 0.0067, Show_Chance = false,Image = "rbxassetid://",Layout_Order = 9},

		["Tomi Tomi"] = {Rarity = "Godly",Chance = 0.0067, Show_Chance = false,Image = "rbxassetid://",Layout_Order = 10},

	}


}

module.Rarities = {

	["Common"] = Color3.fromRGB(170, 170, 170),
	["Uncommon"] = Color3.fromRGB(85, 170, 255),
	["Rare"] = Color3.fromRGB(85, 0, 127),
	["Legendary"] = Color3.fromRGB(255, 170, 0),
	["Mythic"] = Color3.fromRGB(255, 0, 0),
	["Godly"] = Color3.fromRGB(0, 0, 0),

}

function module.GetRandomItem(Crate_Name)
	
	local Skins = module.Items[Crate_Name]
	
	if not Skins then return end
	
	local totalWeight = 0

	for _, d in pairs(Skins) do
		totalWeight += d.Chance
	end

	local randomNumber = math.random() * totalWeight
	local cumulative = 0

	for skinName, d in pairs(Skins) do
		cumulative += d.Chance
		if randomNumber <= cumulative then
			return skinName, module.Items[skinName]
		end
	end
end

return module
