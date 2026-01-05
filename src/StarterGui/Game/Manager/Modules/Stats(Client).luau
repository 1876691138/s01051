local module 							= {}

----------------------------------------
--//Services
local marketplaceService				= game:GetService("MarketplaceService")
local replicatedStorage					= game:GetService("ReplicatedStorage")
local playersService					= game:GetService("Players")

--//LocalPlr
local plr 								= playersService.LocalPlayer

--//GUI
local thisGUI							= script.Parent.Parent.Parent
local mainFrame							= thisGUI.Frames.Stats
local container							= mainFrame.Container

local buttons							= 
	{
		["Open"]						= thisGUI["LeftSide"]["Buttons"]["Stats"],
		["Close"]						= mainFrame["Close"],
	}

--//Functions
local getStatsFunc 						= replicatedStorage.Functions.Client.GetStats
local allData							= getStatsFunc:InvokeServer()

--//Events
local updateStatsEvent					= replicatedStorage.Events.Client.Others.UpdateStats

--//ModuleScripts
local setupGUI							= require(thisGUI.SetupGUI)
local helpersModule						= require(replicatedStorage.ModuleScripts.APIs.Helpers)

--//References
local assetsFolder						= thisGUI.Manager.Assets
local statsAssets						= assetsFolder.Stats

--//RuntimeValues
local isOpened							= buttons["Open"]["IsOpened"]

-----------------------------
local function ToggleOpen(newValue)
	isOpened.Value						= newValue

	if isOpened 						then
		updateStatsEvent:FireServer()
	end
end

buttons["Open"].Activated:Connect(function()
	ToggleOpen(not isOpened.Value)
end)

buttons["Close"].Activated:Connect(function()
	ToggleOpen(false)
end)

-----------------------------
function FormatTime(seconds)
	local hours 						= math.floor(seconds / 3600)
	local minutes 						= math.floor((seconds % 3600) / 60)
	local secs 							= seconds % 60
	return string.format("%02d:%02d:%02d", hours, minutes, secs)
end

local function OtherStat(entry)
	local targetStat					= plr.Others.Stats:FindFirstChild(entry.Type)
	if not targetStat					then return end
	
	local clone 						= statsAssets.Sample:Clone()
	clone.Title.Text					= entry.DisplayName

	targetStat.Changed:Connect(function(newValue)
		if entry.Type == "Playtime" 	then
			clone.Amount.Text			= FormatTime(targetStat.Value)
		else
			clone.Amount.Text			= targetStat.Value
		end
	end)
	
	if entry.Type == "Playtime" 		then
		clone.Amount.Text				= FormatTime(targetStat.Value)
	else
		clone.Amount.Text				= targetStat.Value
	end
	
	clone.Parent						= container
end

local function BoostStat(entry)
	local targetStat					= plr.Others:FindFirstChild("Boosts"):FindFirstChild(entry.SubType)
	if not targetStat					then return end

	local clone 						= statsAssets.Sample:Clone()
	clone.Title.Text					= entry.DisplayName

	targetStat.Changed:Connect(function(newValue)
		clone.Amount.Text				= "+ "..tostring(targetStat.Value).." x"
	end)
	
	clone.Amount.Text					= "+ "..tostring(targetStat.Value).." x"
	clone.Parent						= container
end

-----------------------------
for i, entry in pairs(allData) 			do
	if entry.Type == "Boosts"			then
		BoostStat(entry)
	else
		OtherStat(entry)
	end
end

for i, btn in pairs(buttons) 			do
	if btn.Name == "Open"				then continue end

	setupGUI.SetupBtnAnimations(btn, 1.05, 1.05)
end

-----------------------------
return module
