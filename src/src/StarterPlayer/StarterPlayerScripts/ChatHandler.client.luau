--//Services
local replicatedStorage		 			= game:GetService("ReplicatedStorage")
local Players 							= game:GetService("Players")
local TextChatService 					= game:GetService("TextChatService")

--//LocalPlr
local plr								= Players.LocalPlayer

local plrPasses							= plr:WaitForChild("Passes", 3)
local VIP								= plrPasses:WaitForChild("VIP", 3)
local SuperVIP							= plrPasses:WaitForChild("SuperVIP", 3)

--//References
local TextChannels 						= TextChatService:WaitForChild("TextChannels")

--//Settings
local colors							= 
	{
		["VIP"]							= 
		{
			["Title"]					= Color3.new(1, 1, 0),
			["PlrName"]					= Color3.new(0.666667, 1, 1),
		},
		
		["SuperVIP"]					= 
		{
			["Title"]					= Color3.new(1, 0, 0),
			["PlrName"]					= Color3.new(0.333333, 0.666667, 1),
		},
	}

local titles							= 
	{
		["VIP"]							= "VIP",
		["SuperVIP"]					= "SuperVIP",
	}

------------------------------------
function format_color(color)
	return string.format("%s,%s,%s", math.round(color.R *255),math.round(color.G*255),math.round(color.B*255))
end

function ShowMessageWithColor(Message, Color)
	Color								= Color or Color3.new(1, 1, 1)
	TextChannels.RBXSystem:DisplaySystemMessage(("<b><font color='rgb(%s)'>%s</font></b>"):format(format_color(Color), Message))
end

------------------------------------
TextChatService.OnIncomingMessage 		= function(message: TextChatMessage)
	if not message.TextSource 			then return end
	
	local otherPlr 						= Players:GetPlayerByUserId(message.TextSource.UserId)
	local properties 					= Instance.new("TextChatMessageProperties")
	local prefText 						= ""
	local plrName						= message.PrefixText
	
	local VIP							= otherPlr["Passes"]["VIP"]
	local SuperVIP						= otherPlr["Passes"]["SuperVIP"]
	
	local activeColor					= nil
	local activeTitle					= nil
	
	if VIP.Value or SuperVIP.Value 		then
		if VIP.Value					then
			activeColor					= colors["VIP"]
			activeTitle					= titles["VIP"]
		end
		
		if SuperVIP.Value				then
			activeColor					= colors["SuperVIP"]
			activeTitle					= titles["SuperVIP"]
		end
		
		
		prefText 						..= ("<font color='rgb(%s)'>["..tostring(activeTitle).."]</font> "):format(format_color(activeColor["Title"]))
		plrName 						= ("<font color='rgb(%s)'>%s</font>"):format(format_color(activeColor["PlrName"]), message.PrefixText)
	end

	properties.PrefixText 			= prefText..plrName
	return properties
end

------------------------------------