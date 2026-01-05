--//Services
local MarketplaceService 				= game:GetService("MarketplaceService")
local replicatedStorage					= game:GetService("ReplicatedStorage")
local tweenService						= game:GetService("TweenService")
local userInputService					= game:GetService("UserInputService")
local players							= game:GetService("Players")

--//References
local moduleScripts						= script.Modules

--//LocalPlr
local plr								= players.LocalPlayer
local leaderstats						= plr:WaitForChild("leaderstats")
local energyValue						= leaderstats:WaitForChild("Energy")
local gemsValue							= leaderstats:WaitForChild("Gems")

--//GUI
local thisGUI							= script.Parent
local frames							= thisGUI["Frames"]
local buttons_Left						= thisGUI["LeftSide"]["Buttons"]
local buttons_Right						= thisGUI["RightSide"]

local statsFrame						= thisGUI.LeftSide.Stats

--//ModuleScripts
--local introModule						= require(moduleScripts.Intro)
local childModules						= {}
local shortModule 						= require(replicatedStorage.ModuleScripts.APIs.Short)
local setupModule						= require(thisGUI.SetupGUI)

---------------------------------
local function CloseAll(targetBtn)
	for i, btn in pairs(buttons_Left:GetChildren()) do
		if targetBtn and btn == targetBtn	then continue end

		local IsOpened					= btn:FindFirstChild("IsOpened")
		if not IsOpened					then continue end

		IsOpened.Value					= false
	end
	
	for i, btn in pairs(buttons_Right:GetChildren()) do
		if targetBtn and btn == targetBtn	then continue end

		local IsOpened					= btn:FindFirstChild("IsOpened")
		if not IsOpened					then continue end

		IsOpened.Value					= false
	end
end

local function SetupBtns(buttonsParent)
	for i, btn in pairs(buttonsParent:GetChildren()) do
		local isCorrect						= btn:IsA("TextButton") or btn:IsA("ImageButton")
		if not isCorrect					then continue end

		setupModule.SetupBtnAudio(btn, false)
		setupModule.SetupBtnAnimations(btn, 1.15, 1.15)

		local targetFrame					= frames:FindFirstChild(btn.Name)	
		if not targetFrame					then continue end

		local IsOpened						= Instance.new("BoolValue", btn)
		IsOpened.Name 						= "IsOpened"

		IsOpened.Changed:Connect(function(newValue)
			if newValue						then
				CloseAll(btn)

				setupModule.Open(targetFrame)
			else
				setupModule.Close(targetFrame)
			end
		end)

		setupModule.SetupAnim(targetFrame)
	end
end

---------------------------------
SetupBtns(buttons_Left)
SetupBtns(buttons_Right)

---------------------------------
for _, child in pairs(moduleScripts:GetChildren()) do
	if not child:IsA("ModuleScript")	then continue end
	if child.Name == "Intro"			then continue end

	childModules[child.Name]			= require(child)
end

---------------------------------
local function GetNumber(number)
	local abbreviations 				= 
		{
			K 							= 4,
			M 							= 7,
			B 							= 10,
			Qa 							= 13,
		}


	local wantedText 					= tostring(math.floor(number))
	local choosenIndex

	for i, digits in pairs(abbreviations) 	do
		if #wantedText >= digits and #wantedText < (digits + 3) then
			choosenIndex 				= i
			break
		end
	end

	if choosenIndex 					then
		local digits 					= abbreviations[choosenIndex]
		local abbreviated 				= number / 10^(digits - 1)
		local formatted 				= math.floor(abbreviated) == abbreviated and tostring(abbreviated) or string.format("%.1f", abbreviated)
		return formatted .. choosenIndex
	else
		return wantedText
	end
end

---------------------------------
local function SetupStats()
	statsFrame.Energy.TextLabel.Text	= GetNumber(energyValue.Value)

	energyValue.Changed:Connect(function(newValue)
		statsFrame.Energy.TextLabel.Text	= GetNumber(energyValue.Value)
	end)
	
	--------
	statsFrame.Gems.TextLabel.Text		= GetNumber(gemsValue.Value)

	gemsValue.Changed:Connect(function(newValue)
		statsFrame.Gems.TextLabel.Text	= GetNumber(gemsValue.Value)
	end)
end

---------------------------------
SetupStats()
childModules["Capsules(Client)"].SetupCapsules()

---------------------------------
