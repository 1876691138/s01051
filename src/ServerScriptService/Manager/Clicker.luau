local module 							= {}

-----------------------------
--//Services
local replicatedStorage 				= game:GetService("ReplicatedStorage")
local debris 							= game:GetService("Debris")

--//References
local assetsFolder						= replicatedStorage.Assets.Parts

--//ModuleScripts
local short 							= require(replicatedStorage.ModuleScripts.APIs.Short)
local boostsModule 						= require(script.Parent.Boosts)
local gamepassesModule					= require(script.Parent["MicroTransactions"]["GamePasses"])

--//Events
local clickEvent						= replicatedStorage["Events"]["Client"]["Others"]["Click"]

--//Settings
local AddEnergy 						= 1

-----------------------------
local function Energy(plr)
	local total							= boostsModule.Energy(plr)
	return total
end

local function CanAutoClick(plr)
	local target						= gamepassesModule.GetThisGamepass("AutoClicker")
	local ownsPass						= target and gamepassesModule.CheckGamePass(plr, target.Code) or false
	
	return ownsPass
end

-----------------------------
local function Click(plr, character)
	local total							= Energy(plr)

	local EnergyPart 					= assetsFolder.EnergyPart:Clone()
	EnergyPart.BillboardGui.TextLabel.Text = "+"..short.en(total)
	EnergyPart.Parent 					= character
	debris:AddItem(EnergyPart, 1)

	-- Random Place
	local RandomPlace 					= math.random(0, 15)
	local PartNumber 					= 0

	for _, Part in character:GetChildren() do
		if Part:IsA("MeshPart") 		then
			PartNumber 					+= 1

			if PartNumber == RandomPlace then
				EnergyPart.Position 	= Part.Position
			end
		end
	end

	plr.leaderstats.Energy.Value		+= total
end

-----------------------------
clickEvent.OnServerEvent:Connect(function(plr)
	local character 					= plr.Character
	if not character					then return end
	
	Click(plr, character)
end)

-----------------------------
return module
