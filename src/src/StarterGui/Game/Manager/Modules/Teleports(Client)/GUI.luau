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

local mainFrame 						= thisGUI.Frames["Teleport"]
local container							= mainFrame["Container"]

local buttons							= 
	{
		["Open"]						= thisGUI["LeftSide"]["Buttons"]["Teleport"],
		["Close"]						= mainFrame["Close"],
		
		["ClosePopup"]					= popupFrame["Close"],
		["PurchaseBtn"]					= popupFrame["PurchaseBtn"],
	}

--//References
local assetsFolder						= thisGUI.Manager.Assets["Teleports"]
local billboardsFolder					= thisGUI["Teleports"]

--//ModuleScripts
local setupGUI							= require(thisGUI.SetupGUI)
local short 							= require(replicatedStorage.ModuleScripts.APIs.Short)

local popupModule						= require(script.Parent["Popup"])

--//Runtime
local tpPass							= getThisPassFunc:InvokeServer("Teleport GUI")
local isOpened							= buttons["Open"]["IsOpened"]

----------------------------
local function CheckGamePass(plr)
	local hasPass 						= false
	local success, message 				= pcall(function()
		hasPass 						= marketplaceService:UserOwnsGamePassAsync(plr.UserId, tpPass.Code)
	end)

	if not success 						then return false end
	if hasPass 							then return true end

	return false
end

----------------------------
function module.ToggleOpen(newValue)
	isOpened.Value						= newValue

	if isOpened.Value	 				then
		module.Update()
	end
end

buttons["Open"].Activated:Connect(function()
	local canOpen						= CheckGamePass(plr)
	if not canOpen						then
		marketplaceService:PromptGamePassPurchase(plr, tpPass.Code)
		return
	end

	module.ToggleOpen(not isOpened.Value)
end)

buttons["Close"].Activated:Connect(function()
	module.ToggleOpen(false)
end)

----------------------------
local function GetNumber(number)
	local abbreviations 				= 
		{
			K 							= 4,
			M 							= 7,
			B 							= 10,
			Qa 							= 13,
		}


	local wantedText 					= tostring(math.floor(number))
	local choosenIndex

	for i, digits in pairs(abbreviations) 	do
		if #wantedText >= digits and #wantedText < (digits + 3) then
			choosenIndex 				= i
			break
		end
	end

	if choosenIndex 					then
		local digits 					= abbreviations[choosenIndex]
		local abbreviated 				= number / 10^(digits - 1)
		local formatted 				= math.floor(abbreviated) == abbreviated and tostring(abbreviated) or string.format("%.1f", abbreviated)
		return formatted .. choosenIndex
	else
		return wantedText
	end
end

plrTeleportsFolder.ChildAdded:Connect(function(child)
	local oldBoard						= billboardsFolder:FindFirstChild(child.Name)
	if not oldBoard						then return end
	oldBoard:Destroy()
	
	local entry							= allTeleports[child.Name]
	if not entry						then return end
	
	local portal						= entry.Model["Portal"]
	local promptPart					= portal:FindFirstChild("PromptPart")
	if not promptPart					then return end
	
	promptPart["Attachment"]["Prompt"].Enabled = true
end)

local function SetupBillboards()
	for i, entry in pairs(allTeleports)	 do
		if entry.Unlock.Cost <= 0		then continue end
		
		local owned						= plrTeleportsFolder:FindFirstChild(i) or plrTeleportsFolder:FindFirstChild(tostring(i))
		if owned						then continue end
		
		local portal					= entry.Model["Portal"]
		local promptPart				= portal:FindFirstChild("PromptPart")
		if not promptPart				then continue end
		
		promptPart["Attachment"]["Prompt"].Enabled = false
		
		local clone						= assetsFolder["GUI"]:Clone()
		clone["BuyBtn"]["Title"].Text	= entry.DisplayName
		clone["BuyBtn"]["Cost"].Text	= GetNumber(entry.Unlock.Cost)
		
		clone["BuyBtn"].Activated:Connect(function()
			ShowPopup(i, entry)
		end)
		
		clone.Adornee					= promptPart
		clone.Parent					= billboardsFolder
		clone.Name						= i
		clone.Enabled					= true
	end
end

----------------------------
local function UpdateChild(clone, i, entry)
	local portal						= entry.Model:FindFirstChild("Portal")
	local base							= portal and portal["Base"]
	
	local owned							= plrTeleportsFolder:FindFirstChild(i) or plrTeleportsFolder:FindFirstChild(tostring(i))
	if not owned						then
		owned							= false
		if base							then
			base.Color					= Color3.fromRGB(17, 17, 17)
		end
		
	else
		owned							= true
		if base							then
			base.Color					= Color3.fromRGB(0, 255, 255)
		end

	end

	clone["PurchaseBtn"].Visible		= not owned
	clone["NotOwned"].Visible			= not owned
	clone["TeleportBtn"].Visible		= owned
end

function module.Update()
	for i, clone in pairs(container:GetChildren()) do
		local isCorrect					= clone:IsA(assetsFolder["Sample"].ClassName)
		if not isCorrect				then continue end
		
		local id						= clone["Configs"]["ID"].Value
		local entry						= allTeleports[id]
		
		UpdateChild(clone, id, entry)
	end
end

local function Setup()
	for i, entry in pairs(allTeleports)	do
		local clone						= assetsFolder["Sample"]:Clone()
		clone["Title"].Text				= entry.DisplayName
		clone["ID"]["Title"].Text		= entry.LayoutOrder
		
		clone["PurchaseBtn"].Title.Text	= short.en(entry.Unlock.Cost)..tostring(entry.Unlock.Currency)

		UpdateChild(clone, i, entry)

		clone["Configs"]["ID"].Value	= i
		
		clone["TeleportBtn"].Activated:Connect(function()
			teleportEvent:FireServer(i)
		end)
		
		clone["PurchaseBtn"].Activated:Connect(function()
			ShowPopup(i, entry)
		end)
		
		clone.LayoutOrder				= entry.LayoutOrder
		clone.Parent					= container
	end
end

----------------------------
function ShowPopup(i, entry)
	popupFrame.Message.Text				= "Are you sure you want to buy "..tostring(entry.DisplayName).." teleport?"
	popupFrame["PurchaseBtn"].Title.Text	= short.en(entry.Unlock.Cost)..tostring(entry.Unlock.Currency)

	popupModule.activeData				= 
		{
			Entry 						= entry,
			ID 							= i,
		}
	
	feedbackText.Visible				= false
	buttons["PurchaseBtn"].Visible		= true
	setupGUI.Open(popupFrame)
end

showPopupEvent.OnClientEvent:Connect(function(i, entry)
	ShowPopup(i, entry)
end)

----------------------------
task.spawn(function()	
	for i, btn in pairs(buttons) 		do
		if btn.Name == "Open"			then continue end

		setupGUI.SetupBtnAnimations(btn, 1.05, 1.05)
	end
	
	Setup()
	SetupBillboards()
end)

----------------------------
return module
