local module 							= {}
----------------------------------------
--//Services
local replicatedStorage					= game:GetService("ReplicatedStorage")
local marketplaceService 				= game:GetService("MarketplaceService")
local playersService					= game:GetService("Players")

--//LocalPlr
local plr								= playersService.LocalPlayer

--//ModuleScripts
local audioModule						= require(replicatedStorage.ModuleScripts.APIs.Audio)
local draggableModule					= require(replicatedStorage.ModuleScripts.APIs.DraggableObject)
local animationsModule					= require(replicatedStorage.ModuleScripts.APIs.Animations)

--//MainGUI
local thisGUI							= script.Parent

----------------------------------------
function module.SetupDrag(mainFrame)
	local FrameDrag 					= draggableModule.new(mainFrame)
	FrameDrag:Enable()
end

----------------------------------------
function module.SetupAnim(mainFrame)
	animationsModule.SetupFrame(mainFrame)
end

function module.Open(mainFrame)
	animationsModule.Open(mainFrame)
end

function module.Close(mainFrame)
	animationsModule.Close(mainFrame)
end

function module.CloseAndDestroy(mainFrame)
	animationsModule.CloseAndDestroy(mainFrame)
end

function module.CloseAndDestroyAfterTime(mainFrame, duration)
	animationsModule.CloseAndDestroyAfterTime(mainFrame, duration)
end

function module.SetupBtnAnimations(btn, x, y)
	animationsModule.SetupBtnAnimations(btn, x, y)
end

----------------------------------------
function module.SetupBtnAudio(child, isHoverOnly)
	child.MouseEnter:Connect(function()
		--audioModule.PlaySFX("Button", "Hover")
	end)
	
	if isHoverOnly						then return end
	child.Activated:Connect(function()
		audioModule.PlaySFX("Button", "Click")
	end)
end

----------------------------------------
return module
