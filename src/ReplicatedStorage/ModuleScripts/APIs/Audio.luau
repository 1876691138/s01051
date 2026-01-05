local module 					= {}

----------------------------------------
--//Services
local debrisService				= game:GetService("Debris")
local soundService				= game:GetService("SoundService")
local playersService			= game:GetService("Players")

--//LocalPlr
local plr						= playersService.LocalPlayer

--//Tables
local Music 					= 
	{
		["Menu"] 				= "rbxassetid://5510367180",
		["Chirping"] 			= "rbxassetid://6208085004"
	}

local SoundEffects 				= 
	{
		["Button"] 				= 
		{
			["Hover"] 			= "rbxassetid://4601634822",
			["Click"] 			= "rbxassetid://4601635211"
		},

		["Notification"] 		= 
		{
			["Create"]			= "rbxassetid://6083413636"
		},

		["Announcement"] 		= 
		{
			["Create"] 			= "rbxassetid://4835664238"
		},
	}

----------------------------------------
function module.PlaySFX(id, subID)
	if not id					then return end
	local target				= SoundEffects[id]
	if not target				then return end
	
	local newTarget				= target
	
	if subID then
		newTarget				= target[subID]
	end
	
	if not newTarget			then return end
	
	local newAudio				= Instance.new("Sound")
	newAudio.SoundId			= newTarget
	newAudio.Parent				= soundService.SFXs
	newAudio:Play()

	debrisService:AddItem(newAudio, newAudio.TimeLength + 1)
end

----------------------------------------
return module
