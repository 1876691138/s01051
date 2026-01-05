local module 							= {}

-----------------------------
--//Services
local replicatedStorage					= game:GetService("ReplicatedStorage")
local serverStorage						= game:GetService("ServerStorage")
local playersService					= game:GetService("Players")

--//ModuleScripts
local dataModule						= require(script.Data)

--//Functions
local getFunc 							= replicatedStorage.Functions.Client["GetTeleports"]
local purchaseTeleportFunc				= replicatedStorage.Functions.Client["PurchaseTeleport"]

--//Events
local teleportEvent						= replicatedStorage.Events["Client"]["Teleport"]["Teleport"]
local showPopupEvent					= replicatedStorage.Events["Client"]["Teleport"]["ShowPopup"]

-----------------------------
function module.GetList()
	return dataModule.List
end

getFunc.OnServerInvoke					= function(plr)
	return module.GetList()
end

purchaseTeleportFunc.OnServerInvoke		= function(plr, id)
	local entry							=  module.GetList()[id]
	if not entry 						then
		return "Can't find this entry"
	end
	
	local targetStats					= plr.leaderstats:WaitForChild(entry.Unlock.Currency)
	if not targetStats					then
		return "Can't find this target stat"
	end
	
	local hasEnough						= targetStats.Value >= entry.Unlock.Cost
	if not hasEnough					then
		return " You don't have enough currency to purchase this teleport entry"
	end
	
	targetStats.Value 					-= entry.Unlock.Cost
	module.Add(plr, id)
	
	return true
end

-----------------------------
function module.Add(plr, id)
	local plrTeleports					= plr:WaitForChild("Teleports", 5)
	if not plrTeleports					then return end
	
	local exist							= plrTeleports:FindFirstChild(id)
	if exist							then return end
	
	local clone							= Instance.new("StringValue")
	clone.Name							= id
	clone.Value							= id
	clone.Parent						= plrTeleports
end

function module.AddFree(plr)
	local allItems						= module.GetList()
	for i, entry in pairs(allItems)		do
		if entry.Unlock.Cost > 0		then continue end
		module.Add(plr, i)
	end
end

-----------------------------
local function Setup()
	local allItems						= module.GetList()
	for i, entry in pairs(allItems)		do
		if i == "0"						then continue end
		if not entry.Model				then continue end
		
		local portal					= entry.Model["Portal"]
		local teleporter				= entry.Model["Teleporter"]
		
		local promptPart				= portal:FindFirstChild("PromptPart")
		if not promptPart				then continue end
		
		local prompt					= promptPart["Attachment"]["Prompt"]
		if not prompt					then continue end

		prompt.ObjectText				= "Teleport to "..tostring(entry.DisplayName)
		
		prompt.Triggered:Connect(function(plr)
			print("Triggered")
			local plrTeleports			= plr:WaitForChild("Teleports")
			
			local exists				= plrTeleports:FindFirstChild(i)
			if not exists				then
				print("Can't Find it")
				showPopupEvent:FireClient(plr, i, entry)
				return
			end
			
			local char					= plr.Character or plr.CharacterAdded:Wait()
			if not char					then
				print("Can't Find character")
				return
			end
			
			local primPart				= teleporter["TpPos"]
			char:PivotTo(primPart.CFrame + Vector3.new(5, 1, 5))
		end)
	end
end

-----------------------------
teleportEvent.OnServerEvent:Connect(function(plr, id)
	local owned							= plr["Teleports"]:FindFirstChild(id)
	if not owned						then return end
	
	local char							= plr.Character or plr.CharacterAdded:Wait()
	if not char							then return end
	
	local entry							= dataModule.List[id]
	if not entry						then return end
	local teleporter					= entry.Model["Teleporter"]
	
	local primPart						= teleporter["TpPos"]
	char:PivotTo(primPart.CFrame + Vector3.new(5, 1, 5))
end)

-----------------------------
Setup()

-----------------------------
return module
