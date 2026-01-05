local module 							= {}

----------------------------------------
--//Services
local marketplaceService				= game:GetService("MarketplaceService")
local replicatedStorage					= game:GetService("ReplicatedStorage")
local playersService					= game:GetService("Players")
local tweenService						= game:GetService("TweenService")
local soundService						= game:GetService("SoundService")

--//Tweens
local transitionSway 					= TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0)

--//References
local currentCamera 					= game.Workspace.CurrentCamera
local audios 							= soundService.Audios

--//LocalPlr
local plr 								= playersService.LocalPlayer
local char 								= plr.Character or plr.CharacterAdded:Wait()
local humanoid 							= char:WaitForChild("Humanoid")
local hrp 								= char:WaitForChild("HumanoidRootPart")

--//GUI
local thisGUI							= script.Parent.Parent.Parent

-----------------------------
function module.PlayThisAudio(itemName)
	local targetAudio					= audios:FindFirstChild(itemName)
	if not targetAudio					then return end
	
	targetAudio:Play()
end

-----------------------------
return module
