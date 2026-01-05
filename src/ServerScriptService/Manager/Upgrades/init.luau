local module 							= {}

-----------------------------
--//Services
local replicatedStorage 				= game:GetService("ReplicatedStorage")
local debris 							= game:GetService("Debris")

--//ModuleScripts
local dataModule 						= require(script.Data)

--//Functions
local getUpgradesFunc 					= replicatedStorage.Functions.Client["GetUpgrades"]
local purchaseUpgradeFunc 				= replicatedStorage.Functions.Client["PurchaseUpgrade"]

-----------------------------
function module.GetThisUpgrade(id)
	return dataModule.List[id]
end

getUpgradesFunc.OnServerInvoke			= function(plr, id)
	return module.GetThisUpgrade(id)
end

-----------------------------
function module.UpdateGUI(plr, char)
	if not char							then return end
	local head							= char["Head"]
	
	local plrLevel						= plr:WaitForChild("Others"):WaitForChild("UpgradeLevel")
	local target						= dataModule.List[plrLevel.Value]
	
	local exist							= head:FindFirstChild("HeadGUI")
	if exist							then
		exist.Upgrade.Text				= target.DisplayName
		return
	end
	
	local clone							= script["HeadGUI"]:Clone()
	clone.Upgrade.Text					= target.DisplayName
	clone.Parent						= head
end

-----------------------------
purchaseUpgradeFunc.OnServerInvoke		= function(plr)
	local plrLevel						= plr["Others"]["UpgradeLevel"]

	local nextLevel						= plrLevel.Value + 1
	local target						= dataModule.List[nextLevel]
	if not target						then
		return	"No new level available!"
	end
	
	local plrLeaderstats				= plr:WaitForChild("leaderstats")
	local plrEnergy						= plrLeaderstats["Energy"]
	local plrGems						= plrLeaderstats["Gems"]
	
	local enoughCost					= (plrEnergy.Value >= target.Cost)
	if not enoughCost					then
		return "Not enough energy to upgrade to next level!"
	end
	
	plrEnergy.Value						= 0
	plrGems.Value						= 0
	plrLevel.Value 						+= 1
	
	module.UpdateGUI(plr, plr.Character)
	
	return true
end

-----------------------------
return module