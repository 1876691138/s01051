local module 							= {}

----------------------------
--//Services
local marketplaceService 				= game:GetService("MarketplaceService")
local replicatedStorage 				= game:GetService("ReplicatedStorage")
local plrsService 						= game:GetService("Players")

--//LocalPlr
local plr 								= plrsService.LocalPlayer
local plrTeleportsFolder				= plr:WaitForChild("Teleports", 10)

--//GUI
local thisGUI							= script.Parent.Parent.Parent

local popupFrame						= thisGUI.Frames["Others"]["BuyTeleport"]
local mainFrame_1 						= thisGUI.Frames["Teleport"]
local mainFrame_2 						= thisGUI.Frames["Teleport2"]

local buttons							= 
	{
		["Open"]						= thisGUI["LeftSide"]["Buttons"]["Teleport"],
		["Close"]						= mainFrame_1["Close"],
		
		["ClosePopup"]					= popupFrame["Close"],
		["PurchaseBtn"]					= popupFrame["PurchaseBtn"],
	}

--//ModuleScripts
local setupGUI							= require(thisGUI.SetupGUI)
local subModules						= 
	{
		["GUI"]							= require(script["GUI"]),
		["Trigger"]						= require(script["Trigger"]),
		["Popup"]						= require(script["Popup"]),
	}

--//RuntimeValues

----------------------------
return module
