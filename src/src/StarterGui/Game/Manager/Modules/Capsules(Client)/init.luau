local module 							= {}

----------------------------
-- Services
local replicatedStorage 				= game:GetService("ReplicatedStorage")
local plrs 								= game:GetService("Players")
local MarketplaceService 				= game:GetService("MarketplaceService")
local debris							= game:GetService("Debris")

--//LocalPlr
local plr 								= plrs.LocalPlayer

--//Functions
local getFightersFunc 					= replicatedStorage.Functions.Client.GetFighters
local getRarityFunc 					= replicatedStorage.Functions.Client.GetRarity
local getCapsulesFunc 					= replicatedStorage.Functions.Client.GetCapsules
local purchaseCapsuleFunc				= replicatedStorage.Functions.Client.PurchaseCapsule
local getPassesFunc						= replicatedStorage.Functions.Client.GetPasses

--//Events
local openRobuxEggEvent					= replicatedStorage["Events"]["Client"]["Fighters"]["OpenRobuxEgg"]

--//ServerData
local allPasses							= getPassesFunc:InvokeServer()
local allFighters						= getFightersFunc:InvokeServer()
local allRarity							= getRarityFunc:InvokeServer()
local allCapsules						= getCapsulesFunc:InvokeServer()

local passes							= 
	{
		["Auto"]						= allPasses["Auto Open"],
		["Mutli"]						= allPasses["More Eggs"],
		["Fast"]						= allPasses["Fast Open"],
	}

--//GUI
local thisGUI							= script.Parent.Parent.Parent
local mainFrame							= thisGUI.Frames.Hatching
local stopBtn							= mainFrame.StopBtn

--//References
local assetsFolder						= thisGUI.Manager.Assets
local capsulesAssets					= assetsFolder.Capsules
local fighterAssets						= assetsFolder.Fighters

--//ModuleScripts
local setupGUI							= require(thisGUI.SetupGUI)
local rotatorModule						= require(script.Rotator)

-- IDs
local imageStringLink 					= "rbxassetid://"

--//Runtime Values
local activeEgg							= nil
local inProcess							= false
local isAuto							= false

-------------------------------------
local function CheckGamePass(plr, id)
	local hasPass 						= false
	-- Check if the player already owns the game pass
	local success, message 				= pcall(function()
		hasPass 						= MarketplaceService:UserOwnsGamePassAsync(plr.UserId, id)
	end)

	if not success 						then return false end
	if hasPass 							then return true end
	
	return false
end

-------------------------------------
local function SetupHeadViewframe(guiObject, itemData)
	local object 						= itemData.Model
	if not object 						then return end

	local cloneFighter 					= object:Clone()
	cloneFighter.Parent 				= guiObject.Viewport

	local cam 							= Instance.new("Camera") 
	cam.Parent 							= guiObject.Viewport
	cam.CFrame 							= CFrame.new(object.Head.Position + (object.PrimaryPart.CFrame.lookVector * 3), object.Head.Position)
	guiObject.Viewport.CurrentCamera 	= cam

	local rotateScript 					= script.RotateScript:Clone()
	rotateScript.Parent 				= cloneFighter
	rotateScript.Enabled 				= true
end

local function SetupRewardViewframe(guiObject, itemData)
	local object 						= itemData.Model
	if not object 						then return end

	local cloneFighter 					= object:Clone()
	cloneFighter.Parent 				= guiObject.Viewport

	local cam 							= Instance.new("Camera") 
	cam.Parent 							= guiObject.Viewport
	cam.CFrame 							= CFrame.new(object.PrimaryPart.Position + (object.PrimaryPart.CFrame.lookVector * 7), object.PrimaryPart.Position)
	guiObject.Viewport.CurrentCamera 	= cam

	local rotateScript 					= script.RotateScript2:Clone()
	rotateScript.Parent 				= cloneFighter
	rotateScript.Enabled 				= true
end

-------------------------------------
local function Warning()
	local exists						= mainFrame:FindFirstChild("Warning")
	if exists 							then return end

	local clone 						= capsulesAssets.Warning:Clone()
	clone.Parent 						= mainFrame

	debris:AddItem(clone, 1)
end

------------------------------------
local function OpenScene(clone, itemData)
	
end

local function Hatch(action, capsuleID)
	if inProcess						then return end
	inProcess							= true
	
	local canPurchase					= purchaseCapsuleFunc:InvokeServer(action, capsuleID)
	if not canPurchase					then
		inProcess						= false
		
		thisGUI.LeftSide.Visible		= true
		thisGUI.RightSide.Visible		= true
		thisGUI.Clicker.Visible			= true
		
		return
	end
	
	activeEgg							= allCapsules[capsuleID]
	
	--print(canPurchase)
	for i, entry in pairs(canPurchase.Rewards) do
		local clone 					= capsulesAssets.Egg:Clone()
		clone.Visible 					= true
		clone.Parent 					= mainFrame.Eggs
	end
	
	thisGUI.LeftSide.Visible			= false
	thisGUI.RightSide.Visible			= false
	thisGUI.Clicker.Visible				= false
	
	mainFrame.Eggs.Visible				= true
	stopBtn.Visible						= isAuto
	
	local canFast						= CheckGamePass(plr, passes["Fast"].Code)
	
	for i, child in pairs(mainFrame.Eggs:GetChildren()) do
		if not child:IsA(capsulesAssets.Egg.ClassName) then continue end
		
		task.spawn(function()
			rotatorModule.RotateThis(child, canFast)
		end)
	end
	
	local rotDuration					= rotatorModule.Duration
	local timeAfterRewards				= 3
	
	if canFast							then
		rotDuration						/= 2
		timeAfterRewards				/= 2
	end
	
	task.wait(rotDuration)
	
	for i, entry in pairs(canPurchase.Rewards) do
		local itemData 					= allFighters[entry.Name]
		if not itemData					then continue end

		local rarityData 				= allRarity[itemData.Rarity]
		if not rarityData				then continue end

		local clone 					= capsulesAssets.Reward:Clone()
		SetupRewardViewframe(clone, itemData)

		clone.Sunburst.ImageColor3		= rarityData.StrokeColor
		clone.Rarity.Text				= itemData.Rarity
		clone.Visible 					= true
		clone.Parent 					= mainFrame.Eggs
	end
	
	task.wait(timeAfterRewards)
	
	for i, child in pairs(mainFrame.Eggs:GetChildren()) do
		if not child:IsA(capsulesAssets.Reward.ClassName) then continue end
		child:Destroy()
	end
	
	mainFrame.Eggs.Visible				= false
	inProcess							= false
	activeEgg							= nil
	
	if isAuto							then
		local canMulti					= CheckGamePass(plr, passes["Auto"].Code)
		if canMulti						then
			Hatch("Multi", capsuleID)
		else
			Hatch("One", capsuleID)
		end
		
		
	else
		thisGUI.LeftSide.Visible		= true
		thisGUI.RightSide.Visible		= true
		thisGUI.Clicker.Visible			= true

	end
end

------------------------------------
openRobuxEggEvent.OnClientEvent:Connect(function(rewardData, eggData)
	activeEgg							= eggData
	
	for i, entry in pairs(rewardData.Rewards) do
		local clone 					= capsulesAssets.Egg:Clone()
		clone.Visible 					= true
		clone.Parent 					= mainFrame.Eggs
	end

	thisGUI.LeftSide.Visible			= false
	thisGUI.RightSide.Visible			= false
	thisGUI.Clicker.Visible				= false

	mainFrame.Eggs.Visible				= true
	stopBtn.Visible						= isAuto

	local canFast						= CheckGamePass(plr, passes["Fast"].Code)

	for i, child in pairs(mainFrame.Eggs:GetChildren()) do
		if not child:IsA(capsulesAssets.Egg.ClassName) then continue end

		task.spawn(function()
			rotatorModule.RotateThis(child, canFast)
		end)
	end

	local rotDuration					= rotatorModule.Duration
	local timeAfterRewards				= 3

	if canFast							then
		rotDuration						/= 2
		timeAfterRewards				/= 2
	end

	task.wait(rotDuration)

	for i, entry in pairs(rewardData.Rewards) do
		local itemData 					= allFighters[entry.Name]
		if not itemData					then continue end

		local rarityData 				= allRarity[itemData.Rarity]
		if not rarityData				then continue end

		local clone 					= capsulesAssets.Reward:Clone()
		SetupRewardViewframe(clone, itemData)

		clone.Sunburst.ImageColor3		= rarityData.StrokeColor
		clone.Rarity.Text				= itemData.Rarity
		clone.Visible 					= true
		clone.Parent 					= mainFrame.Eggs
	end

	task.wait(timeAfterRewards)

	for i, child in pairs(mainFrame.Eggs:GetChildren()) do
		if not child:IsA(capsulesAssets.Reward.ClassName) then continue end
		child:Destroy()
	end

	mainFrame.Eggs.Visible				= false
	inProcess							= false
	activeEgg							= nil

	thisGUI.LeftSide.Visible			= true
	thisGUI.RightSide.Visible			= true
	thisGUI.Clicker.Visible				= true
end)

------------------------------------
local function CloneFighter(entry, container)
	local id							= entry.Name

	local itemData 						= allFighters[id]
	if not itemData						then return end

	local rarityData 					= allRarity[itemData.Rarity]
	if not rarityData					then return end
	
	if itemData.Rarity == "Secret"		then return end

	local clone 						= capsulesAssets.Sample:Clone()
	SetupHeadViewframe(clone, itemData)


	clone.UIStroke.Color				= rarityData.StrokeColor
	clone.RarityText.Text				= itemData.Rarity
	clone.PercentageText.Text			= tostring(entry.Percentage).."%"

	clone.Visible 						= true
	clone.Name 							= id
	clone.Parent 						= container
end

local function PityPercentage(pityText, barFrame, newValue, capsule)
	pityText.Text 						= "Mythical Pity ["..tostring(newValue).."/"..tostring(capsule.PityAmount).."]"
	
	local percentage 					= UDim2.new(math.floor(newValue) / capsule.PityAmount, 0, 1, 0)
	barFrame.Size 						= percentage
end

function module.SetupCapsules()
	for i, capsule in pairs(allCapsules) do
		local clone						= capsulesAssets.Billboard:Clone()

		clone.Name 						= capsule.DisplayName
		clone.Adornee 					= capsule.Model.Base
		clone.Parent					= thisGUI.Boards
		clone.Enabled					= true
		
		local pityText					= clone.Pity.Rarity
		local barFrame					= clone.Pity.Bar
		
		pityText.Text 					= "Mythical Pity [".."0".."/"..tostring(capsule.PityAmount).."]"
		
		local pityTarget				= plr.Fighters.Pity:FindFirstChild(i) or plr.Fighters.Pity:FindFirstChild(tostring(i))
		if pityTarget					then
			PityPercentage(pityText, barFrame, pityTarget.Value, capsule)
			
			pityTarget.Changed:Connect(function(newValue)
				PityPercentage(pityText, barFrame, newValue, capsule)
			end)
		end

		for _, entry in pairs(capsule.Fighters) do
			CloneFighter(entry, clone.Fighters.Container)
		end

		for i, btn in pairs(clone.Buttons:GetChildren()) do
			if not btn:IsA("TextButton")	then continue end
			setupGUI.SetupBtnAnimations(btn, 1.1, 1.1)
		end

		clone.Buttons.Open.Activated:Connect(function()
			isAuto						= false
			Hatch("One", i)
		end)

		clone.Buttons.Multi.Activated:Connect(function()
			local canMulti				= CheckGamePass(plr, passes["Mutli"].Code)
			if not canMulti				then
				MarketplaceService:PromptGamePassPurchase(plr, passes["Mutli"].Code)
				return
			end
			
			isAuto						= false
			Hatch("Multi", i)
		end)

		clone.Buttons.Auto.Activated:Connect(function()
			local canAuto				= CheckGamePass(plr, passes["Auto"].Code)

			if not canAuto				then
				MarketplaceService:PromptGamePassPurchase(plr, passes["Auto"].Code)
				return
			end
			
			isAuto						= true
			local canMulti				= CheckGamePass(plr, passes["Auto"].Code)
			if canMulti					then
				Hatch("Multi", i)
			else
				Hatch("One", i)
			end
		end)
	end
end

------------------------------------
setupGUI.SetupBtnAnimations(stopBtn, 1.1, 1.1)

stopBtn.Activated:Connect(function()
	isAuto								= false
	stopBtn.Visible						= false
end)

------------------------------------
coroutine.wrap(function()
	while task.wait(1)					 do
		if not activeEgg 				then continue end
		if not  activeEgg.Model			then continue end
		
		local character 				= plr.Character or plr.CharacterAdded:Wait() -- Get the character
		local humanoidRootPart 			= character:WaitForChild("HumanoidRootPart")
		local distance 					= (humanoidRootPart.Position - activeEgg.Model.Base.Position).Magnitude

		-- If the distance is greater than 50
		if distance > 50 				then
			isAuto						= false
			stopBtn.Visible				= false
		end
	end
end)()

------------------------------------
return module
