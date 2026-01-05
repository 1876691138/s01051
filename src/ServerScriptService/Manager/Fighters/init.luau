local module 							= {}

-----------------------------
--//Services
local replicatedStorage					= game:GetService("ReplicatedStorage")
local serverStorage						= game:GetService("ServerStorage")
local playersService					= game:GetService("Players")

--//ModuleScripts
local rarityModule						= require(script.Rarity)
local dataModule						= require(script.Data)
local capsulesData						= require(script.Capsules)
local methodsData						= require(script.Methods)

local achievementsModule				= require(script.Parent.Achievements)

--//Events
local invActionEvent					= replicatedStorage.Events.Client.Fighters.InventoryAction

--//Functions
local getFightersFunc 					= replicatedStorage.Functions.Client.GetFighters
local getRarityFunc 					= replicatedStorage.Functions.Client.GetRarity
local getCapsulesFunc 					= replicatedStorage.Functions.Client.GetCapsules
local purchaseCapsuleFunc				= replicatedStorage.Functions.Client.PurchaseCapsule

--//Values
local maxEggs 							= 3

-----------------------------
getRarityFunc.OnServerInvoke			= function(plr)
	return rarityModule.List
end

getFightersFunc.OnServerInvoke			= function(plr)
	return dataModule.List
end

getCapsulesFunc.OnServerInvoke			= function(plr)
	return capsulesData.List
end

-----------------------------
--//Capsules
local function GetMythical(items)
	for i, entry in pairs(items) 		do
		local itemData					= dataModule.List[entry.Name]
		if not itemData					then continue end
		
		if itemData.Rarity == "Mythical" then return entry end
	end
end

local function CheckPity(plr, capsuleID, data, targetCapsule)
	local pityTarget				= plr.Fighters.Pity:FindFirstChild(capsuleID) or plr.Fighters.Pity:FindFirstChild(tostring(capsuleID))
	if pityTarget					then
		pityTarget.Value			+= data.Count

		if pityTarget.Value >= targetCapsule.PityAmount then
			pityTarget.Value		= 0
			return true
		end
	end
	
	return false
end

local function ResetPity(plr, capsuleID, data)
	local hasMythical				= false
	
	for i, entry in pairs(data.Rewards) do
		local itemData				= dataModule.List[entry.Name]
		if not itemData				then continue end
		
		if itemData.Rarity == "Mythical" or itemData.Rarity == "Secret" then
			hasMythical				= true
		end
	end
	
	if not hasMythical				then return end
	
	local pityTarget				= plr.Fighters.Pity:FindFirstChild(capsuleID) or plr.Fighters.Pity:FindFirstChild(tostring(capsuleID))
	if not pityTarget				then return end
	
	pityTarget.Value				= 0
end

local function GetAffordableCapsules(gemsStats, eggCost)
	local affordableEggs 				= math.floor(gemsStats.Value / eggCost)
	return math.min(gemsStats.Value, maxEggs)
end

purchaseCapsuleFunc.OnServerInvoke		= function(plr, action, capsuleID)
	local targetCapsule					= capsulesData.List[capsuleID]
	if not targetCapsule				then return end
	
	local gemsStats						= plr.leaderstats:WaitForChild("Gems")
	if not gemsStats					then return end
	
	if action == "One"					then
		local targetCost				= (targetCapsule.Cost * 1)
		
		if gemsStats.Value < targetCost	then return end
		gemsStats.Value 				-= targetCost
		
		local data						= 
			{
				Count 					= 1,
				Rewards					= {},
			}
		
		local isPity					= CheckPity(plr, capsuleID, data, targetCapsule)

		if isPity						then
			local mythicalID			= GetMythical(targetCapsule.Fighters)
			table.insert(data.Rewards, mythicalID)
			module.AddNew(plr, mythicalID.Name, plr.Fighters.Inventory)
			
		else
			local randomID				= capsulesData.PickRandomItem(targetCapsule.Fighters, plr)
			table.insert(data.Rewards, randomID)
			module.AddNew(plr, randomID.Name, plr.Fighters.Inventory)
		end
		
		ResetPity(plr, capsuleID, data)
		
		achievementsModule.AddStat(plr, "Eggs", data.Count)
		return data
		
	elseif action == "Multi"			then
		local totalCapsules				= GetAffordableCapsules(gemsStats, targetCapsule.Cost)
		local targetCost				= (targetCapsule.Cost * totalCapsules)
		
		if gemsStats.Value < targetCost	then return end
		gemsStats.Value 				-= targetCost
		
		local data						= 
			{
				Count 					= totalCapsules,
				Rewards					= {},
			}
		
		local isPity					= CheckPity(plr, capsuleID, data, targetCapsule)
		
		for i = 1, totalCapsules 		do
			if i == 1 and isPity		then
				local mythicalID		= GetMythical(targetCapsule.Fighters)
				table.insert(data.Rewards, mythicalID)
				module.AddNew(plr, mythicalID.Name, plr.Fighters.Inventory)
			else

				local randomID			= capsulesData.PickRandomItem(targetCapsule.Fighters, plr)
				table.insert(data.Rewards, randomID)
				
				local canAdd			= #plr.Fighters.Inventory:GetChildren() < plr.Fighters.MaxInventory.Value
				if not canAdd			then continue end
				module.AddNew(plr, randomID.Name, plr.Fighters.Inventory)	
			end
			
		end
		
		ResetPity(plr, capsuleID, data)
		achievementsModule.AddStat(plr, "Eggs", data.Count)
		return data
	end
end

function module.GetCapsules()
	return capsulesData.List
end

-----------------------------
--//Add To Inventory or to Equip folder

function module.AddNew(plr, id, targetParent, oldRandomID)
	local clone							= Instance.new("Folder", targetParent)
	clone.Name							= id
	
	local ID							= Instance.new("StringValue", clone)
	ID.Name								= "ID"
	ID.Value							= id
	
	local RandomID						= Instance.new("StringValue", clone)
	RandomID.Name						= "RandomID"
	
	if oldRandomID						then
		RandomID.Value					= oldRandomID
	else
		RandomID.Value					= tostring(math.random(100000, 9999999))..tostring(id)
	end
end

-----------------------------
--//Get Energy Boost

function module.GetEnergy(plr)
	local totalEnergy					= 0
	
	for i, child in pairs(plr.Fighters.Equipped:GetChildren()) do
		local itemData					= dataModule.List[child.ID.Value]
		if not itemData					then continue end
		
		totalEnergy						+= itemData.Stats.Energy
	end
	
	return totalEnergy
end

-----------------------------
--// Equip/UnEquip

local function ToggleEquip(plr, data)
	local parentFolder					= plr.Fighters.Equipped
	local shouldEquip					= true
	local targetChild					= nil

	for _, child in pairs(parentFolder:GetChildren()) do
		if (child.ID.Value == data.ID) and (child.RandomID.Value == data.RandomID) then
			shouldEquip					= false
			targetChild					= child
			break
		end
	end

	if shouldEquip						then
		if #parentFolder:GetChildren() >= plr.Fighters.MaxEquip.Value then return end
		module.AddNew(plr, data.ID, parentFolder, data.RandomID)
		methodsData.ToggleEquip(plr, true, data.ID, data.RandomID)
		
	else
		if not targetChild				then return end
		methodsData.ToggleEquip(plr, false, targetChild.ID.Value, targetChild.RandomID.Value)
		targetChild:Destroy()
		
	end
end

function module.ToggleEquip(plr, shouldEquip, id, petRandomID)
	methodsData.ToggleEquip(plr, shouldEquip, id, petRandomID)
end

-----------------------------
--// UnEquip ALL

local function UnEquipAll(plr)
	for i, child in pairs(plr.Fighters.Equipped:GetChildren()) do
		methodsData.ToggleEquip(plr, false, child.ID.Value, child.RandomID.Value)
	end
	
	plr.Fighters.Equipped:ClearAllChildren()
end

-----------------------------
--// Equip Best

local function GetTopItems(list, count)
	local items 						= {}

	for i, child in pairs(list) 		do
		local thisData					= dataModule.List[child.ID.Value]
		
		local template					= 
			{
				ID 						= child.ID.Value, 
				RandomID 				= child.RandomID.Value, 
				Data 					= thisData, 
				Rarity 					= rarityModule.List[thisData.Rarity],
				Energy					= thisData.Stats.Energy,
			}
		
		table.insert(items, template)
	end

	table.sort(items, function(a, b)
		return a.Energy > b.Energy
	end)

	local result 						= {}
	for i = 1, math.min(count, #items) 	do
		table.insert(result, items[i])
	end

	return result
end

local function EquipBest(plr)
	UnEquipAll(plr)
	
	local topItems 						= GetTopItems(plr.Fighters.Inventory:GetChildren(), plr.Fighters.MaxEquip.Value)
	for _, item in ipairs(topItems) 	do
		ToggleEquip(plr, item)
	end

end

-----------------------------
--// Setup

function module.ContainerSetup(char)
	local container 					= script.Others.Container:Clone()
	container:SetPrimaryPartCFrame(char:GetPrimaryPartCFrame())

	for i, child in pairs(container:GetChildren()) do
		if child:IsA("BasePart") 		then
			child.Transparency 			= 1 
		end
	end

	container.PrimaryPart.cweld.Part1 	= char.PrimaryPart
	container.Parent 					= char
end

-----------------------------
invActionEvent.OnServerEvent:Connect(function(plr, action, data)
	if action == "ToggleEquip"			then
		ToggleEquip(plr, data)
		
	elseif action == "Delete"			then
		if not data 					then return end
		for _, entry in pairs(data) 	do
			for i, child in pairs(plr.Fighters.Inventory:GetChildren()) do
				if child.ID.Value == entry.ID and child.RandomID.Value == entry.RandomID then
					methodsData.ToggleEquip(plr, false, child.ID.Value, child.RandomID.Value)
					child:Destroy()
				end
			end
		end
		
	elseif action == "UnequipAll"		then
		UnEquipAll(plr)
		
	elseif action == "EquipBest"		then
		EquipBest(plr)
		
	end
	
	invActionEvent:FireClient(plr, "Update")
end)

-----------------------------
return module
