local module 							= {}

----------------------------
--//Services
local replicatedStorage 				= game:GetService("ReplicatedStorage")
local plrsService 						= game:GetService("Players")
local runService						= game:GetService("RunService")

--//LocalPlr
local plr 								= plrsService.LocalPlayer
local plrOthers							= plr:WaitForChild("Others")
local plrUpgradeLevel					= plrOthers:WaitForChild("UpgradeLevel")

--//GUI
local thisGUI							= script.Parent.Parent.Parent
local mainFrame 						= thisGUI.Frames.PowerUp

local currentFrame						= mainFrame["Current"]
local nextFrame							= mainFrame["Next"]

local buttons							= 
	{
		["Upgrade"]						= mainFrame["Upgrade"],
	}

--//Functions
local getUpgradesFunc					= replicatedStorage.Functions.Client["GetUpgrades"]
local purchaseUpgradeFunc 				= replicatedStorage.Functions.Client["PurchaseUpgrade"]

--//ModuleScripts
local setupGUI							= require(thisGUI.SetupGUI)
local helpersModule						= require(replicatedStorage.ModuleScripts.APIs.Helpers)
local shortModule 						= require(replicatedStorage.ModuleScripts.APIs.Short)

--//RuntimeValues
local isOpened							= false

--//Ray
local params							= OverlapParams.new()
params.FilterType						= Enum.RaycastFilterType.Whitelist

----------------------------
local function Update()
	local current						= getUpgradesFunc:InvokeServer(plrUpgradeLevel.Value)
	if current							then
		currentFrame["Icon"].Image		= current.Icon
		
		currentFrame["Stats"]["Gems"].Value.Text 	= tostring(current.Upgrades.Gems).."x"
		currentFrame["Stats"]["Energy"].Value.Text 	= tostring(current.Upgrades.Energy).."x"
		currentFrame["Stats"]["Damage"].Value.Text 	= tostring(current.Upgrades.Damage).."x"
	end
	
	
	local next							= getUpgradesFunc:InvokeServer(plrUpgradeLevel.Value +1)
	if next								then
		nextFrame["Icon"].Image			= next.Icon
		
		nextFrame["Stats"]["Gems"].Value.Text 		= tostring(next.Upgrades.Gems).."x"
		nextFrame["Stats"]["Energy"].Value.Text 	= tostring(next.Upgrades.Energy).."x"
		nextFrame["Stats"]["Damage"].Value.Text 	= tostring(next.Upgrades.Damage).."x"
		
		mainFrame["NextTitle"].Text		= next.DisplayName
		mainFrame["Cost"].Text			= shortModule.en(next.Cost)
	end
end

buttons["Upgrade"].Activated:Connect(function()
	local result						= purchaseUpgradeFunc:InvokeServer()
	print(result)
	
	if result == true					then
		mainFrame.Result.Text			= "Upgraded Successfully!"
		Update()
	else
		mainFrame.Result.Text			= result
	end
	
	task.delay(2, function()
		mainFrame.Result.Text			= ""
	end)
end)

----------------------------
local function ToggleOpen(newValue)
	if isOpened == newValue				then return end
	
	isOpened							= newValue

	if isOpened 						then
		setupGUI.Open(mainFrame)
		task.spawn(function()
			Update()
		end)
	else
		setupGUI.Close(mainFrame)
	end
end

----------------------------
local triggerPart						= script.PowerupPart:Clone()
triggerPart.Parent						= game.Workspace.Scriptables

runService.RenderStepped:Connect(function()
	local char 							= plr.Character or plr.CharacterAdded:Wait()
	if not char 						then return end

	params.FilterDescendantsInstances 	= {char.PrimaryPart}

	local inRange 						= false
	local overlap 						= workspace:GetPartsInPart(triggerPart, params)
	if #overlap > 0 					then
		inRange 						= true
	end

	if not inRange						then
		ToggleOpen(false)
	else
		ToggleOpen(true)
	end
end)

----------------------------
setupGUI.SetupAnim(mainFrame)

for i, btn in pairs(buttons) do
	setupGUI.SetupBtnAnimations(btn, 1.05, 1.05)
end

----------------------------
return module
