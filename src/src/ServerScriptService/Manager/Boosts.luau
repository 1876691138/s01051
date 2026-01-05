local module 							= {}

-----------------------------
--//Services
local replicatedStorage					= game:GetService("ReplicatedStorage")
local playersService					= game:GetService("Players")

--//ModuleScripts
local upgradessModule 					= require(script.Parent["Upgrades"])
local tokensModule 						= require(script.Parent["Tokens"])
local fightersModule 					= require(script.Parent["Fighters"])
local gamepassesModule					= require(script.Parent["MicroTransactions"]["GamePasses"])

-- [修复] 正确引用 Fruits 模块 (指向 init 脚本，而不是文件夹)
local fruitsModule						= require(script.Parent.Fruits.init) 

--//Functions
local getThisStatMultiFunc				= replicatedStorage["Functions"]["Client"]["GetThisStatMulti"]

-----------------------------
-- 辅助函数
local function GetFruitMult(plr, stat)
	if not plr:FindFirstChild("Fruits") then return 1 end
	return fruitsModule.GetPlayerBoost(plr, stat)
end

function module.Damage(plr)
	local total							= 1
	local plrLevel						= plr["Others"]["UpgradeLevel"]
	local thisUpgrade					= upgradessModule.GetThisUpgrade(plrLevel.Value)

	total								*= 1 + plr["Others"]["Boosts"]["Damage"].Value
	total								*= thisUpgrade["Upgrades"]["Damage"]

	-- 果实加成
	total								*= GetFruitMult(plr, "Damage")

	local x2Gamepass					= gamepassesModule.GetThisGamepass("x2 Damage")
	local ownsX2						= x2Gamepass and gamepassesModule.CheckGamePass(plr, x2Gamepass.Code) or false
	if ownsX2							then
		total							*= 2
	end

	local tokensBoosts					= tokensModule.GetBoosts(plr)
	local thisTokenBoost				= tokensBoosts and tokensBoosts["Damage"]
	if thisTokenBoost					then
		total							*= (1 + thisTokenBoost)
	end

	return total
end

function module.Gems(plr)
	local total							= 1
	local plrLevel						= plr["Others"]["UpgradeLevel"]
	local thisUpgrade					= upgradessModule.GetThisUpgrade(plrLevel.Value)

	total 								*= ( 1 + plr["Others"]["Boosts"]["Gems"].Value)
	total								*= thisUpgrade["Upgrades"]["Gems"]

	-- 果实加成
	total								*= GetFruitMult(plr, "Gems")

	local x2Gamepass					= gamepassesModule.GetThisGamepass("x2 Gems")
	local ownsX2						= x2Gamepass and gamepassesModule.CheckGamePass(plr, x2Gamepass.Code) or false
	if ownsX2							then
		total							*= 2
	end

	local tokensBoosts					= tokensModule.GetBoosts(plr)
	local thisTokenBoost				= tokensBoosts and tokensBoosts["Gems"]
	if thisTokenBoost					then
		total							*= (1 + thisTokenBoost)
	end

	return total
end

function module.Energy(plr)
	local total							= 1
	local plrLevel						= plr["Others"]["UpgradeLevel"]
	local thisUpgrade					= upgradessModule.GetThisUpgrade(plrLevel.Value)

	local extraEnergy					= fightersModule.GetEnergy(plr)
	total								+= (1 + extraEnergy) 
	total								*= 1 + plr["Others"]["Boosts"]["Energy"].Value
	total								*= thisUpgrade["Upgrades"]["Energy"]

	-- 果实加成
	total								*= GetFruitMult(plr, "Energy")

	local x2Gamepass					= gamepassesModule.GetThisGamepass("x2 Energy")
	local ownsX2						= x2Gamepass and gamepassesModule.CheckGamePass(plr, x2Gamepass.Code) or false
	if ownsX2							then
		total							*= 2
	end

	local superVIP						= gamepassesModule.GetThisGamepass("SuperVIP")
	local ownsSuperVIP					= superVIP and gamepassesModule.CheckGamePass(plr, superVIP.Code) or false
	if ownsSuperVIP						then
		total							*= 2
	end

	local tokensBoosts					= tokensModule.GetBoosts(plr)
	local thisTokenBoost				= tokensBoosts and tokensBoosts["Energy"]
	if thisTokenBoost					then
		total							*= (1 + thisTokenBoost)
	end

	return total
end

function module.Luck(plr)
	local luckyMultiplier 				= 1

	if plr["Passes"]["Lucky"]      		then 
		luckyMultiplier 				+= 0.10
	end

	if plr["Passes"]["SuperLucky"] 		then 
		luckyMultiplier 				+= 0.25 
	end

	if plr["Passes"]["UltraLucky"] 		then 
		luckyMultiplier 				+= 0.50 
	end

	-- 果实加成 (Luck通常是加法)
	local fruitLuck = GetFruitMult(plr, "Luck")
	if fruitLuck > 1 then
		luckyMultiplier += fruitLuck 
	end

	return luckyMultiplier
end

-----------------------------
getThisStatMultiFunc.OnServerInvoke		= function(plr, statName)
	if statName == "Damage"			 	then
		return module.Damage(plr)
	elseif statName == "Gems"			then
		return module.Gems(plr)
	elseif statName == "Energy"			then
		return module.Energy(plr)
	elseif statName == "Luck"			then
		return module.Luck(plr)
	end
end

return module