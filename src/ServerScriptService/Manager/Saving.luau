local module 							= {}

------------------------------------
--//Services
local replicatedStorage 				= game:GetService("ReplicatedStorage")
local dataStoreService 					= game:GetService("DataStoreService")

--//DataStores
local fightersStored 					= dataStoreService:GetDataStore("Fighters")
local statsStored 						= dataStoreService:GetDataStore("Stats")
local achievementsStored 				= dataStoreService:GetDataStore("Achievements")
local othersStored 						= dataStoreService:GetDataStore("Others")
local teleportsStored 					= dataStoreService:GetDataStore("Teleports")
local tokensStored 						= dataStoreService:GetDataStore("Tokens")

--//Keys
local fightersKey 						= "1.0000001"
local statsKey 							= "1.0000001"
local achievementsKey 					= "1.0000001"
local othersKey 						= "1.0000001"
local teleportsKey 						= "1.0000001"
local tokensKey 						= "1.0000001"

--//ModuleScripts
local fightersModule					= require(script.Parent["Fighters"])
local achievementsModule				= require(script.Parent["Achievements"])
local teleportsModule					= require(script.Parent["Teleports"])
local tokensModule						= require(script.Parent["Tokens"])

------------------------------------
function module.SaveLeaderstats(plr)
	local userID 					= plr.UserId
	local saveID 					= userID..statsKey
	local data 						= 
		{
			Energy 					= plr.leaderstats.Energy.Value,
			Gems					= plr.leaderstats.Gems.Value,
		}

	statsStored:SetAsync(saveID, data)
end

function module.LoadLeaderstats(plr)
	local leaderstats 				= Instance.new("Folder", plr)
	leaderstats.Name				= "leaderstats"

	local Energy 					= Instance.new("IntValue",leaderstats)
	Energy.Name 					= "Energy"

	local Gems 						= Instance.new("IntValue",leaderstats)
	Gems.Name 						= "Gems"
	Gems.Value						= 9999
	
	local Damage 					= Instance.new("IntValue", plr)
	Damage.Name 					= "Damage"
	Damage.Value 					= 10

	
	local userID 					= plr.UserId
	local saveID 					= userID..statsKey
	local valueRetrieved 			= {}

	local success, errormessage 	= pcall(function()
		valueRetrieved 				= statsStored:GetAsync(saveID)
	end)
	
	if not success 					then return end
	if not valueRetrieved  			then return end
	
	Energy.Value 					= valueRetrieved.Energy
	Gems.Value 						= valueRetrieved.Gems
end

------------------------------------
function module.SaveOthers(plr)
	local userID 					= plr.UserId
	local saveID 					= userID..othersKey
	local data 						= 
		{
			Stats 					= 
			{
				Eggs				= plr.Others.Stats.Eggs.Value,
				Enemies				= plr.Others.Stats.Enemies.Value,
				Playtime			= plr.Others.Stats.Playtime.Value,
			},
			
			UpgradeLevel			= plr.Others.UpgradeLevel.Value
		}

	othersStored:SetAsync(saveID, data)
end

function module.LoadOthers(plr)
	local Others 					= Instance.new("Folder", plr)
	Others.Name						= "Others"
	
	-----------------------------
	local Boosts 					= Instance.new("Folder", Others)
	Boosts.Name						= "Boosts"
	
	local Energy 					= Instance.new("NumberValue", Boosts)
	Energy.Name						= "Energy"
	
	local Damage 					= Instance.new("NumberValue", Boosts)
	Damage.Name						= "Damage"
	
	local Gems 						= Instance.new("NumberValue", Boosts)
	Gems.Name						= "Gems"
	
	-----------------------------
	local Stats 					= Instance.new("Folder", Others)
	Stats.Name						= "Stats"
	
	local Eggs 						= Instance.new("IntValue",Stats)
	Eggs.Name 						= "Eggs"

	local Enemies 					= Instance.new("IntValue",Stats)
	Enemies.Name 					= "Enemies"
	
	local Playtime 					= Instance.new("IntValue",Stats)
	Playtime.Name 					= "Playtime"
	
	-----------------------------
	local UpgradeLevel 				= Instance.new("IntValue", Others)
	UpgradeLevel.Name				= "UpgradeLevel"
	
	-----------------------------
	local userID 					= plr.UserId
	local saveID 					= userID..othersKey
	local valueRetrieved 			= {}

	local success, errormessage 	= pcall(function()
		valueRetrieved 				= othersStored:GetAsync(saveID)
	end)

	if not success 					then return end
	if not valueRetrieved  			then return end

	Eggs.Value 						= valueRetrieved.Stats.Eggs
	Enemies.Value 					= valueRetrieved.Stats.Enemies
	Playtime.Value 					= valueRetrieved.Stats.Playtime
	
	if valueRetrieved.UpgradeLevel	then
		UpgradeLevel.Value			= valueRetrieved.UpgradeLevel
	end
end

------------------------------------
function module.SaveFighters(plr)
	local userID 					= plr.UserId
	local saveID 					= userID..fightersKey
	local data 						= 
		{
			Inventory 				= {},
			Equipped				= {},
			Pity 					= {},
		}
	
	for i, child in pairs(plr.Fighters.Pity:GetChildren()) do
		local template				= 
			{
				Name 				= child.Name,
				Value				= child.Value,
			}

		table.insert(data.Pity, template)
	end
	
	for i, child in pairs(plr.Fighters.Inventory:GetChildren()) do
		local template				= 
			{
				ID 					= child.ID.Value,
				RandomID			= child.RandomID.Value,
			}
		
		table.insert(data.Inventory, template)
	end
	
	for i, child in pairs(plr.Fighters.Equipped:GetChildren()) do
		local template				= 
			{
				ID 					= child.ID.Value,
				RandomID			= child.RandomID.Value,
			}

		table.insert(data.Equipped, template)
	end

	fightersStored:SetAsync(saveID, data)
end

function module.LoadFighters(plr)
	local Fighters 					= Instance.new("Folder", plr)
	Fighters.Name					= "Fighters"

	local Inventory 				= Instance.new("Folder", Fighters)
	Inventory.Name					= "Inventory"
	
	local Equipped 					= Instance.new("Folder", Fighters)
	Equipped.Name					= "Equipped"
	
	local Pity 						= Instance.new("Folder", Fighters)
	Pity.Name						= "Pity"
	
	for i, capsule in pairs(fightersModule.GetCapsules()) do
		local newItem 				= Instance.new("IntValue", Pity)
		newItem.Name				= i
		newItem						= 0
	end
	
	local MaxEquip 					= Instance.new("IntValue", Fighters)
	MaxEquip.Name					= "MaxEquip"
	MaxEquip.Value					= 4
	
	local MaxInventory 				= Instance.new("IntValue", Fighters)
	MaxInventory.Name				= "MaxInventory"
	MaxInventory.Value				= 50
	
	local userID 					= plr.UserId
	local saveID 					= userID..fightersKey
	local valueRetrieved 			= {}

	local success, errormessage 	= pcall(function()
		valueRetrieved 				= fightersStored:GetAsync(saveID)
	end)

	if not success 					then return end
	if not valueRetrieved  			then return end

	for i, entry in pairs(valueRetrieved.Inventory) do
		local canAdd				= #Inventory:GetChildren() < MaxInventory.Value
		if not canAdd				then continue end
		
		fightersModule.AddNew(plr, entry.ID, Inventory, entry.RandomID)
	end

	for i, entry in pairs(valueRetrieved.Equipped) do
		fightersModule.AddNew(plr, entry.ID, Equipped, entry.RandomID)
	end
	
	if valueRetrieved.Pity			then
		--print(valueRetrieved.Pity)
		for i, entry in pairs(valueRetrieved.Pity) do
			local target			= Pity:FindFirstChild(entry.Name) or Pity:FindFirstChild(tostring(entry.Name))
			if not target			then continue end

			target.Value			= entry.Value
		end
	end
	
end

------------------------------------
function module.SaveAchievements(plr)
	local userID 					= plr.UserId
	local saveID 					= userID..achievementsKey
	local data 						= {}

	for i, child in pairs(plr.Achievements:GetChildren()) do
		data[child.Name]			= child.Value
	end

	achievementsStored:SetAsync(saveID, data)
end

function module.LoadAchievements(plr)
	local Achievements 				= Instance.new("Folder", plr)
	Achievements.Name				= "Achievements"

	for i, entry in pairs(achievementsModule.GetList()) do
		local newItem 				= Instance.new("BoolValue", Achievements)
		newItem.Name				= i
	end

	local userID 					= plr.UserId
	local saveID 					= userID..achievementsKey
	local valueRetrieved 			= {}

	local success, errormessage 	= pcall(function()
		valueRetrieved 				= achievementsStored:GetAsync(saveID)
	end)

	if not success 					then return end
	if not valueRetrieved  			then return end
	
	for i, child in pairs(Achievements:GetChildren()) do
		local exist 				= valueRetrieved[child.Name]
		if not exist				then continue end
		
		child.Value					= exist
	end
	
	achievementsModule.UpdateBoosts(plr)

end

------------------------------------
function module.SaveTeleports(plr)
	local userID 					= plr.UserId
	local saveID 					= userID..teleportsKey
	local data 						= {}

	for i, child in pairs(plr.Teleports:GetChildren()) do
		local template				= 
			{
				Name 				= child.Name,
				Value				= child.Value,
			}

		table.insert(data, template)
	end

	teleportsStored:SetAsync(saveID, data)
end

function module.LoadTeleports(plr)
	local Teleports 				= Instance.new("Folder", plr)
	Teleports.Name					= "Teleports"
	
	teleportsModule.AddFree(plr)

	local userID 					= plr.UserId
	local saveID 					= userID..teleportsKey
	local valueRetrieved 			= {}

	local success, errormessage 	= pcall(function()
		valueRetrieved 				= teleportsStored:GetAsync(saveID)
	end)

	if not success 					then return end
	if not valueRetrieved  			then return end

	for i, entry in pairs(valueRetrieved) do
		teleportsModule.Add(plr, entry.Value)
	end
end

------------------------------------
function module.SaveTokens(plr)
	local userID 					= plr.UserId
	local saveID 					= userID..tokensKey
	local data 						= {}

	for i, child in pairs(plr.Tokens:GetChildren()) do
		local template				= 
			{
				Name 				= child.Name,
				Value				= child.Value,
			}

		table.insert(data, template)
	end

	tokensStored:SetAsync(saveID, data)
end

function module.LoadTokens(plr)
	local Tokens 					= Instance.new("Folder", plr)
	Tokens.Name						= "Tokens"

	local userID 					= plr.UserId
	local saveID 					= userID..tokensKey
	local valueRetrieved 			= {}

	local success, errormessage 	= pcall(function()
		valueRetrieved 				= tokensStored:GetAsync(saveID)
	end)

	if not success 					then return end
	if not valueRetrieved  			then return end

	for i, entry in pairs(valueRetrieved) do
		tokensModule.Add(plr, entry.Value)
	end
end

------------------------------------
return module