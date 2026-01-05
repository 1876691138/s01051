local module 							= {}

----------------------------------------
--//Services
local marketplaceService				= game:GetService("MarketplaceService")
local replicatedStorage					= game:GetService("ReplicatedStorage")
local playersService					= game:GetService("Players")

--//LocalPlr
local plr 								= playersService.LocalPlayer
local plrOthers							= plr:WaitForChild("Others")
local otherStats						= plrOthers:WaitForChild("Stats")

--//GUI
local thisGUI							= script.Parent.Parent.Parent
local mainFrame							= thisGUI.Frames.Achievements
local statsFrame						= mainFrame.Stats
local container							= mainFrame.Container

local buttons							= 
	{
		["Open"]						= thisGUI["RightSide"]["Achievements"],
		["Close"]						= mainFrame["Close"],
	}

--//Functions
local getAchievementsFunc 				= replicatedStorage.Functions.Client.GetAchievements
local allData							= getAchievementsFunc:InvokeServer()

--//ModuleScripts
local setupGUI							= require(thisGUI.SetupGUI)
local helpersModule						= require(replicatedStorage.ModuleScripts.APIs.Helpers)

--//References
local assetsFolder						= thisGUI.Manager.Assets
local achievementsAssets				= assetsFolder.Achievements

--//RuntimeValues
local isOpened							= buttons["Open"]["IsOpened"]
local activeID							= nil
local activeType						= nil

-----------------------------
local function DestroyAll()
	for i, child in pairs(container:GetChildren()) do
		if not child:IsA(achievementsAssets.Sample.ClassName) 	then continue end
		child:Destroy()
	end
end

local function ClearStats()
	activeID							= nil
	activeType							= nil

	statsFrame.Desc.Text				= ""
	statsFrame.Progress.Text			= ""
	
	statsFrame.Title.Text				= ""
	statsFrame.Energy.Text				= ""
	statsFrame.Damage.Text				= ""
	statsFrame.Gems.Text				= ""
end

-----------------------------
local function ToggleOpen(newValue)
	isOpened.Value						= newValue
	
	if isOpened.Value 					then
		ClearStats()
	end
end

buttons["Open"].Activated:Connect(function()
	ToggleOpen(not isOpened.Value)
end)

buttons["Close"].Activated:Connect(function()
	ToggleOpen(false)
end)

-----------------------------
local function GetFinal(entry, newValue)
	local finalValue					= helpersModule.AbbreviateNumber(newValue).."/"..helpersModule.AbbreviateNumber(entry.Target)

	if entry.Type == "Playtime" 		then
		finalValue						= helpersModule.ConvertToHMS(newValue).."/"..helpersModule.ConvertToHMS(entry.Target)
	end
	
	if newValue > entry.Target 			then
		finalValue						= "Unlocked!"
	end
	
	return finalValue
end

local function Update()
	for i, entry in pairs(allData) 			do
		local targetStat					= otherStats:FindFirstChild(entry.Type)
		if not targetStat					then continue end

		local clone 						= achievementsAssets["Sample"]:Clone()
		clone["Icon"].Image					= entry.Image
		clone["Title"].Text					= entry.DisplayName
		clone.Boost.Text					= "+ x"..tostring(entry.Reward.Boosts["Energy"])
		
		clone.LayoutOrder					= entry.LayoutOrder
		clone.Parent						= container
		clone.Checked.Visible				= (targetStat.Value >= entry.Target)

		local thisGradient 					= achievementsAssets["GradientTiers"]:FindFirstChild(tostring(entry.Tier))
		if thisGradient						 then
			local gradientClone_1 			= thisGradient:Clone()
			gradientClone_1.Parent 			= clone["Stroke"]

			local gradientClone_2 			= thisGradient:Clone()
			gradientClone_2.Parent 			= clone	
		end

		

		targetStat.Changed:Connect(function(newValue)
			clone.Checked.Visible			= (newValue >= entry.Target)

			if activeType ~= targetStat.Name then return end
			statsFrame.Progress.Text		= GetFinal(entry, newValue)
		end)

		clone.Activated:Connect(function()
			activeID						= i
			activeType						= entry.Type

			statsFrame.Title.Text			= entry.DisplayName

			statsFrame.Energy.Text			= "+ x"..tostring(entry.Reward.Boosts["Energy"]).." Energy"
			statsFrame.Damage.Text			= "+ x"..tostring(entry.Reward.Boosts["Damage"]).." Damage"
			statsFrame.Gems.Text			= "+ x"..tostring(entry.Reward.Boosts["Gems"]).." Gems"

			statsFrame.Progress.Text		= ""
			statsFrame.Desc.Text			= entry.Desc

			statsFrame.Progress.Text		= GetFinal(entry, targetStat.Value)
		end)
	end

end

-----------------------------
for i, btn in pairs(buttons) 			do
	if btn.Name == "Open"				then continue end

	setupGUI.SetupBtnAnimations(btn, 1.05, 1.05)
end

Update()

-----------------------------
return module
