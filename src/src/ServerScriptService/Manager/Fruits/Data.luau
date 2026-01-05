local module = {}

module.List = {
	-- 格式: [名字] = { 稀有度, 加成类型, 倍率 }
	["Common Fruit"] 		= { Rarity = "Common", 		Stat = "Gems", 		Multi = 1.2 },
	["Rare Fruit"] 			= { Rarity = "Rare", 		Stat = "Damage", 	Multi = 1.2 },
	["Epic Fruit"] 			= { Rarity = "Epic", 		Stat = "Energy", 	Multi = 1.2 },

	["Legendary 1"] 		= { Rarity = "Legendary", 	Stat = "Gems", 		Multi = 1.5 },
	["Legendary 2"] 		= { Rarity = "Legendary", 	Stat = "Damage", 	Multi = 1.5 },

	["Mythical 1"] 			= { Rarity = "Mythical", 	Stat = "Energy", 	Multi = 1.5 },
	["Mythical 2"] 			= { Rarity = "Mythical", 	Stat = "Gems", 		Multi = 2.0 },

	["Secret 1"] 			= { Rarity = "Secret", 		Stat = "Damage", 	Multi = 2.0 },
	["Secret 2"] 			= { Rarity = "Secret", 		Stat = "Energy", 	Multi = 2.0 },
	["Secret 3"] 			= { Rarity = "Secret", 		Stat = "Luck", 		Multi = 2.0 }, -- Luck +2
}

return module