local module 							= {}

----------------------------
--//Services
local marketplaceService 				= game:GetService("MarketplaceService")
local replicatedStorage 				= game:GetService("ReplicatedStorage")
local plrsService 						= game:GetService("Players")

--//LocalPlr
local plr 								= plrsService.LocalPlayer
local plrTeleportsFolder				= plr:WaitForChild("Teleports", 10)

--//Events
local teleportEvent						= replicatedStorage.Events["Client"]["Teleport"]["Teleport"]
local showPopupEvent					= replicatedStorage.Events["Client"]["Teleport"]["ShowPopup"]

--//Functions
local purchaseTeleportFunc				= replicatedStorage.Functions.Client["PurchaseTeleport"]
local getThisPassFunc					= replicatedStorage.Functions.Client["GetThisPass"]

local getTeleportsFunc 					= replicatedStorage.Functions.Client["GetTeleports"]
local allTeleports						= getTeleportsFunc:InvokeServer()

--//GUI
local thisGUI							= script.Parent.Parent.Parent.Parent

local popupFrame						= thisGUI.Frames["Others"]["BuyTeleport"]
local feedbackText						= popupFrame["Feedback"]

local buttons							= 
	{
		["ClosePopup"]					= popupFrame["Close"],
		["PurchaseBtn"]					= popupFrame["PurchaseBtn"],
	}

--//References
local assetsFolder						= thisGUI.Manager.Assets["Teleports"]
local billboardsFolder					= thisGUI["Teleports"]

--//ModuleScripts
local setupGUI							= require(thisGUI.SetupGUI)
local short 							= require(replicatedStorage.ModuleScripts.APIs.Short)

--//RuntimeValues
module.activeData						= 
	{
		Entry 							= nil,
		ID 								= nil,
	}

----------------------------
buttons["ClosePopup"].Activated:Connect(function()
	setupGUI.Close(popupFrame)
end)

buttons["PurchaseBtn"].Activated:Connect(function()
	if not module.activeData.Entry 		then return end
	if not module.activeData.ID 		then return end
	
	local feedback						= purchaseTeleportFunc:InvokeServer(module.activeData.ID)
	if feedback == true 				then
		feedbackText.Text				= "Purchased Successfully!"
	else
		feedbackText.Text				= feedback
	end
	
	feedbackText.Visible				= true
	task.delay(2, function()
		feedbackText.Visible			= false
	end)
	
	if feedback == true 				then
		buttons["PurchaseBtn"].Visible	= false
		
		task.delay(2, function()
			popupFrame.Visible			= false
		end)
	end
	
	module.Update()
end)

----------------------------
setupGUI.SetupAnim(popupFrame)

----------------------------
return module
