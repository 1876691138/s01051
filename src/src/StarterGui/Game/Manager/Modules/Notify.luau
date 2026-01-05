local module 							= {}

----------------------------------------
--//Services
local marketplaceService				= game:GetService("MarketplaceService")
local replicatedStorage					= game:GetService("ReplicatedStorage")
local playersService					= game:GetService("Players")

--//LocalPlr
local plr 								= playersService.LocalPlayer

--//Events
local notifyEvent						= replicatedStorage.Events.Client.Others.Notify

--//GUI
local thisGUI							= script.Parent.Parent.Parent
local othersFolder						= thisGUI.Frames.Others
local mainFrame 						= othersFolder.Notify

--//ModuleScripts
local setupGUI							= require(thisGUI.SetupGUI)

--//Runtime
local isOpened							= false

-----------------------------
function module.Show(msg)
	if isOpened							then
		setupGUI.Close(mainFrame)
		
		task.wait(0.5)
	end
	
	spawn(function()
		isOpened						= true
		setupGUI.Open(mainFrame)
	end)
end

-----------------------------
notifyEvent.OnClientEvent:Connect(function(msg)
	module.Show(msg)
end)

-----------------------------
setupGUI.SetupAnim(mainFrame)

-----------------------------
return module
