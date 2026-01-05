local module 							= {}

----------------------------
--//Services
local replicatedStorage 				= game:GetService("ReplicatedStorage")
local tweenService 						= game:GetService("TweenService")
local marketplaceService 				= game:GetService("MarketplaceService")
local plrsService 						= game:GetService("Players")

--//LocalPlr
local plr 								= plrsService.LocalPlayer

--//GUI
local thisGUI							= script.Parent.Parent.Parent
local mainFrame 						= thisGUI["Frames"]["Shop"]
local container							= mainFrame["Container"]

local buttons							= 
	{
		["Open"]						= thisGUI["LeftSide"]["Buttons"]["Shop"],
		["Close"]						= mainFrame["Close"],
	}

--//References
local thisAssets						= thisGUI["Manager"]["Assets"]["RobuxShop"]

--//Events
local openRobuxEggEvent					= replicatedStorage["Events"]["Client"]["Fighters"]["OpenRobuxEgg"]

--//ModuleScripts
local setupModule						= require(thisGUI["SetupGUI"])

--//Settings
local colors							= 
	{
		["Active"]						= Color3.fromRGB(91, 9, 6),
		["InActive"]					= Color3.fromRGB(25, 25, 25),
		
		["Selected"]					= Color3.fromRGB(229, 153, 0),
		["Other"]						= Color3.fromRGB(62, 62, 62),
	}

local categories						= 
	{
		["Passes"]						= 
		{
			Data 						= replicatedStorage["Functions"]["Client"]["GetPasses"]:InvokeServer(),
			Frame 						= container["Passes"],
		},
	}

--//RuntimeValues
local activeRobuxEgg					= replicatedStorage["Functions"]["Client"]["GetActiveRobuxCapsule"]:InvokeServer()
local IsOpened							= buttons["Open"]["IsOpened"]

----------------------------
function CheckGamePass(gamepassID)
	local hasPass 						= false
	local success, message 				= pcall(function()
		hasPass 						= marketplaceService:UserOwnsGamePassAsync(plr.UserId, gamepassID)
	end)

	if not success 						then return false end
	if hasPass 							then return true end
	return false
end

----------------------------
local function Passes(targetCategory)
	for i, entry in pairs(targetCategory.Data) 	do
		local clone						= thisAssets["Pass_Small"]:Clone()
		clone["Title"].Text				= entry.Name
		clone["OWNED"].Visible			= CheckGamePass(entry.Code)
		--clone.Icon.Image				= entry.Icon
		clone.Parent					= targetCategory.Frame
		
		clone.Activated:Connect(function()
			--local isOwned				= CheckGamePass(entry.Code)
			--if isOwned					then return end
			
			marketplaceService:PromptGamePassPurchase(plr, entry.Code)

		end)

		setupModule.SetupBtnAudio(clone, false)
	end
end

local function FeaturedCapsule()
	local clone							= thisAssets["FeaturedSample"]:Clone()
	clone["EggName"].Text				= activeRobuxEgg.DisplayName
	
	for i, entry in pairs(activeRobuxEgg.Prices) do
		local target					= clone["BuyBtns"]:FindFirstChild(tostring(entry.Amount))
		if not target					then continue end
		
		local productInfo				= marketplaceService:GetProductInfo(entry.Code, Enum.InfoType.Product)
		if not productInfo				then continue end
		
		target["Price"]["Robux"].Text	= productInfo.PriceInRobux
		
		target.Activated:Connect(function()
			marketplaceService:PromptProductPurchase(plr, entry.Code)
		end)
	end
	
	for i, entry in pairs(activeRobuxEgg.Fighters) do
		local target					= clone["IconsList"]:FindFirstChild(tostring(i))
		if not target					then continue end
		
		target["Icon"].Image			= entry.Icon
		target["Percentage"].Text		= tostring(entry.Percentage).."%"
	end
	
	clone.Parent 						= container["Featured"]["Container"]
end

----------------------------
local function ToggleOpen(newValue)
	IsOpened.Value						= newValue
end

local function Setup()
	buttons["Open"].Activated:Connect(function()
		ToggleOpen(not IsOpened.Value)
	end)

	buttons["Close"].Activated:Connect(function()
		ToggleOpen(false)
	end)

	for i, btn in pairs(buttons) 		do
		if btn.Name == "Open"			then continue end

		setupModule.SetupBtnAnimations(btn, 1.05, 1.05)
	end

	task.spawn(function()
		for i, entry in pairs(categories) 		do
			Passes(entry)
		end
	end)
	
	task.spawn(function()
		FeaturedCapsule()
	end)
end

----------------------------
openRobuxEggEvent.OnClientEvent:Connect(function(rewardData, eggData)
	ToggleOpen(false)
end)

----------------------------
Setup()

----------------------------
return module
