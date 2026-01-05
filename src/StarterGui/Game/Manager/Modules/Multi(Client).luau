local module 							= {}

----------------------------------------
--//Services
local marketplaceService				= game:GetService("MarketplaceService")
local replicatedStorage					= game:GetService("ReplicatedStorage")
local playersService					= game:GetService("Players")

--//LocalPlr
local plr 								= playersService.LocalPlayer
local plrOthers							= plr:WaitForChild("Others")
local plrBoosts							= plrOthers:WaitForChild("Boosts")

local plrEnergy							= plrBoosts:WaitForChild("Energy")
local plrDamage							= plrBoosts:WaitForChild("Damage")
local plrGems							= plrBoosts:WaitForChild("Gems")

--//GUI
local thisGUI							= script.Parent.Parent.Parent
local multiFrame						= thisGUI["Multiplier"]

--//Functions
local getThisStatMultiFunc				= replicatedStorage["Functions"]["Client"]["GetThisStatMulti"]

--//ModuleScripts
local setupGUI							= require(thisGUI.SetupGUI)
local helpersModule						= require(replicatedStorage.ModuleScripts.APIs.Helpers)

--//References
local assetsFolder						= thisGUI.Manager.Assets
local statsAssets						= assetsFolder.Stats

--//RuntimeValues
local isOpened							= false

-----------------------------
function FormatToTwoDecimals(number)
	return string.format("%.2f", number)
end

-----------------------------
local function Update()
	for i, child in pairs(multiFrame:GetChildren()) do
		local isCorrect					= child:IsA("Frame")
		if not isCorrect				then continue end

		local newValue					= getThisStatMultiFunc:InvokeServer(child.Name)
		if not newValue					then continue end

		child["Amount"].Text			= "x"..helpersModule.AbbreviateNumber(newValue)
	end
end

-----------------------------
coroutine.wrap(function()
	while task.wait(5) 					do
		Update()
	end
end)()

-----------------------------
task.spawn(function()
	Update()
end)

-----------------------------
return module
