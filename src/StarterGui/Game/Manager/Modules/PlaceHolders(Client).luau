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

local frames							= thisGUI["Frames"]
local buttons_Left						= thisGUI["LeftSide"]["Buttons"]
local buttons_Right						= thisGUI["RightSide"]

--//ModuleScripts
local setupGUI							= require(thisGUI.SetupGUI)

----------------------------
local function SetupFrame(targetName)
	local mainFrame						= frames:FindFirstChild(targetName)
	if not mainFrame					then return end
	
	local buttons						= 
		{
			["Open"]					= buttons_Left:FindFirstChild(targetName) or buttons_Right:FindFirstChild(targetName),
			["Close"]					= mainFrame["Close"]
		}
	
	local isOpened						= buttons["Open"]["IsOpened"]
	
	local function ToggleOpen(newValue)
		isOpened.Value					= newValue
	end

	buttons["Open"].Activated:Connect(function()
		ToggleOpen(not isOpened.Value)
	end)

	buttons["Close"].Activated:Connect(function()
		ToggleOpen(false)
	end)
	
	for i, btn in pairs(buttons) 		do
		if btn.Name == "Open"			then continue end

		setupGUI.SetupBtnAnimations(btn, 1.05, 1.05)
	end

end

----------------------------
SetupFrame("Index")
SetupFrame("Settings")
SetupFrame("Inventory")
SetupFrame("Codes")
SetupFrame("UpdateLog")
SetupFrame("Verify")

----------------------------
return module
