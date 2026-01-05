local module 							= {}

-----------------------------
--//Services
local replicatedStorage					= game:GetService("ReplicatedStorage")
local serverStorage						= game:GetService("ServerStorage")
local playersService					= game:GetService("Players")

--//ModuleScripts
local dataModule						= require(script.Data)

--//Functions
local getFunc 							= replicatedStorage.Functions.Client["GetTokens"]

-----------------------------
function module.GetList()
	return dataModule.List
end

-----------------------------
getFunc.OnServerInvoke					= function(plr)
	return module.GetList()
end

-----------------------------
function module.Add(plr, id)
	local plrTokens						= plr:WaitForChild("Tokens", 5)
	if not plrTokens					then return end

	local exist							= plrTokens:FindFirstChild(id)
	if exist							then return end

	local clone							= Instance.new("StringValue", plrTokens)
	clone.Name							= id
	clone.Value							= id
end

-----------------------------
function module.GetBoosts(plr)
	local total							= 
		{
			["Energy"]					= 0,
			["Damage"]					= 0,
			["Gems"]					= 0,
		}
		
	
	local plrTokens						= plr:WaitForChild("Tokens", 5)
	if not plrTokens					then return total end

	for _, child in pairs(plrTokens:GetChildren()) do
		local itemData					= dataModule.List[child.Value]
		if not itemData					then continue end
		
		for i, value in pairs(itemData.Boosts) do
			total[i]					+= value
		end
	end
	
	return total
end

-----------------------------
return module
