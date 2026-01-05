local module 							= {}

----------------------------
--//Services
local replicatedStorage 				= game:GetService("ReplicatedStorage")
local plrsService 						= game:GetService("Players")
local runService						= game:GetService("RunService")

--//LocalPlr
local plr 								= plrsService.LocalPlayer
local plrTokens							= plr:WaitForChild("Tokens")

--//GUI
local thisGUI							= script.Parent.Parent.Parent
local mainFrame 						= thisGUI.Frames["Tokens"]

local statsFrame						= mainFrame["Stats"]
local container							= mainFrame["Container"]
local texts								= 
	{
		["Title"]						= mainFrame["Title"],
		["Obtained"]					= mainFrame["Obtained"],
		["Locked"]						= mainFrame["Locked"],
	}

local buttons							= 
	{
		["Open"]						= thisGUI["LeftSide"]["Buttons"]["Tokens"],
		["Close"]						= mainFrame["Close"]
	}

--//References
local assetsFolder						= thisGUI.Manager.Assets["Tokens"]

--//Functions
local getFunc							= replicatedStorage.Functions.Client["GetTokens"]
local allTokens							= getFunc:InvokeServer()

--//ModuleScripts
local setupGUI							= require(thisGUI.SetupGUI)
local shortModule 						= require(replicatedStorage.ModuleScripts.APIs.Short)

--//RuntimeValues
local isOpened							= buttons["Open"]["IsOpened"]

----------------------------
function UpdateStats(entry, i)
	local owned							= plrTokens:FindFirstChild(i)
	if not owned						then
		owned							= false
	else
		owned							= true
	end
	
	mainFrame["Icon"].Image				= entry.Icon

	statsFrame["Gems"].Value.Text 		= "Gems: +"..tostring(entry.Boosts.Gems).."x"
	statsFrame["Gems"].Visible			= (entry.Boosts.Gems > 0)
	
	statsFrame["Energy"].Value.Text 	= "Energy: +"..tostring(entry.Boosts.Energy).."x"
	statsFrame["Energy"].Visible		= (entry.Boosts.Energy > 0)
	
	statsFrame["Damage"].Value.Text 	= "Damage: +"..tostring(entry.Boosts.Damage).."x"
	statsFrame["Damage"].Visible		= (entry.Boosts.Damage > 0)
	
	texts["Title"].Text					= entry.DisplayName
	texts["Obtained"].Text				= entry.Desc
	
	texts["Locked"].Visible				= not owned
	texts["Obtained"].Visible			= owned
end

local function Setup()
	for i, entry in pairs(allTokens)	do
		local clone						= assetsFolder["Sample"]:Clone()
		clone["Title"].Text				= entry.DisplayName
		clone.Image						= entry.Icon
		clone["ID"].Value				= i
		
		local owned						= plrTokens:FindFirstChild(i)
		if not owned					then
			owned						= false
		else
			owned						= true
		end
		
		clone["NotOwned"].Visible		= not owned
		

		clone.Activated:Connect(function()
			UpdateStats(entry, i)
		end)

		clone.Parent					= container
	end
end

----------------------------
local function Update()
	for i, child in pairs(container:GetChildren())	do
		if not child:IsA(assetsFolder["Sample"].ClassName) then continue end
		
		local id						= child["ID"].Value

		local owned						= plrTokens:FindFirstChild(id)
		if not owned					then
			owned						= false
		else
			owned						= true
		end

		child["NotOwned"].Visible		= not owned
	end
end

local function Reset()
	mainFrame["Icon"].Image				= ""

	statsFrame["Gems"].Value.Text 		= ""
	statsFrame["Energy"].Value.Text 	= ""
	statsFrame["Damage"].Value.Text 	= ""

	texts["Title"].Text					= ""
	
	texts["Locked"].Visible				= false
	texts["Obtained"].Visible			= false
	
	statsFrame["Gems"].Visible			= false
	statsFrame["Energy"].Visible		= false
	statsFrame["Damage"].Visible		= false
end

----------------------------
local function ToggleOpen(newValue)
	if isOpened.Value == newValue		then return end
	isOpened.Value						= newValue

	Update()
	Reset()
end

buttons["Open"].Activated:Connect(function()
	ToggleOpen(not isOpened.Value)
end)

buttons["Close"].Activated:Connect(function()
	ToggleOpen(false)
end)

----------------------------
for i, btn in pairs(buttons) 		do
	if btn.Name == "Open"			then continue end
	
	setupGUI.SetupBtnAnimations(btn, 1.05, 1.05)
end

----------------------------
Reset()
Setup()

----------------------------
return module
