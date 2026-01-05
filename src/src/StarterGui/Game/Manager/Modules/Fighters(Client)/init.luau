local module 							= {}

----------------------------
--//Services
local replicatedStorage 				= game:GetService("ReplicatedStorage")
local plrsService 						= game:GetService("Players")

--//LocalPlr
local plr 								= plrsService.LocalPlayer
local fightersFolder					= plr:WaitForChild("Fighters")
local equippedFolder					= fightersFolder:WaitForChild("Equipped")
local maxEquipped						= fightersFolder:WaitForChild("MaxEquip")

local invFolder							= fightersFolder:WaitForChild("Inventory")
local maxInventory						= fightersFolder:WaitForChild("MaxInventory")

--//Events
local invActionEvent					= replicatedStorage.Events.Client.Fighters.InventoryAction

--//Functions
local getFightersFunc 					= replicatedStorage.Functions.Client.GetFighters
local getRarityFunc 					= replicatedStorage.Functions.Client.GetRarity

--//ServerData
local allFighters						= getFightersFunc:InvokeServer()
local allRarity							= getRarityFunc:InvokeServer()

--//GUI
local thisGUI							= script.Parent.Parent.Parent
local mainFrame 						= thisGUI.Frames.Fighters
local container							= mainFrame.Container
local equippedText						= mainFrame.EquippedText
local inventoryText						= mainFrame.InventoryText

local buttons							= 
	{
		["Open"]						= thisGUI.LeftSide.Buttons.Fighters,
		["Close"]						= mainFrame.Close,
		["Delete"]						= mainFrame.Delete,
		["EquipBest"]					= mainFrame.EquipBest,
		["UnequipAll"]					= mainFrame.UnequipAll,
	}

--//References
local assetsFolder						= thisGUI.Manager.Assets
local fighterAssets						= assetsFolder.Fighters

--//ModuleScripts
local setupGUI							= require(thisGUI.SetupGUI)
local helpersModule						= require(replicatedStorage.ModuleScripts.APIs.Helpers)

--//RuntimeValues
local isDeleting						= false
local deleteTable						= {}

local isOpened							= buttons["Open"]["IsOpened"]
local activeData						= 
	{
		Clone 							= nil,
		ID 								= nil,
		RandomID						= nil,
	}

----------------------------
local function SetupStats()
	equippedText.Text					= "Equipped: "..tostring(#equippedFolder:GetChildren()).."/"..tostring(maxEquipped.Value)

	equippedFolder.ChildAdded:Connect(function()
		equippedText.Text				= "Equipped: "..tostring(#equippedFolder:GetChildren()).."/"..tostring(maxEquipped.Value)
	end)

	equippedFolder.ChildRemoved:Connect(function()
		equippedText.Text				= "Equipped: "..tostring(#equippedFolder:GetChildren()).."/"..tostring(maxEquipped.Value)
	end)

	maxEquipped.Changed:Connect(function()
		equippedText.Text				= "Equipped: "..tostring(#equippedFolder:GetChildren()).."/"..tostring(maxEquipped.Value)
	end)

	----------------------------
	inventoryText.Text					= "Inventory: "..tostring(#invFolder:GetChildren()).."/"..tostring(maxInventory.Value)

	invFolder.ChildAdded:Connect(function()
		inventoryText.Text				= "Inventory: "..tostring(#invFolder:GetChildren()).."/"..tostring(maxInventory.Value)
	end)

	invFolder.ChildRemoved:Connect(function()
		inventoryText.Text				= "Inventory: "..tostring(#invFolder:GetChildren()).."/"..tostring(maxInventory.Value)
	end)

	maxInventory.Changed:Connect(function()
		inventoryText.Text				= "Inventory: "..tostring(#invFolder:GetChildren()).."/"..tostring(maxInventory.Value)
	end)
end

----------------------------
local function DestroyAll()
	for i, child in pairs(container:GetChildren()) do
		if not child:IsA(fighterAssets.Sample.ClassName) 	then continue end
		child:Destroy()
	end
end

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

----------------------------
local function DisplayItems()
	for i, entry in pairs(plr.Fighters.Inventory:GetChildren()) do
		local id						= entry.ID.Value
		local randomID					= entry.RandomID.Value
		
		local itemData 					= allFighters[entry.ID.Value]
		if not itemData					then continue end
		
		local rarityData 				= allRarity[itemData.Rarity]
		if not rarityData				then continue end

		local clone 					= fighterAssets.Sample:Clone()
		SetupHeadViewframe(clone, itemData)
		
		local configs					= clone.Config
		configs.ID.Value 				= id
		configs.RandomID.Value 			= randomID
		configs.isEquipped.Value 		= false
		
		for _, child in pairs(plr.Fighters.Equipped:GetChildren()) do
			if (child.ID.Value == id) and (child.RandomID.Value == randomID) then
				configs.isEquipped.Value = true
				break
			end
		end
		
		clone.EquippedMark.Visible		= configs.isEquipped.Value
		clone.Title.Text 				= itemData.DisplayName
		clone.UIGradient.Color 			= rarityData.Color
		clone.UIStroke.Color			= rarityData.StrokeColor
		
		clone.EnergyText.Text			= itemData.Stats.Energy
		
		clone.LayoutOrder				= - itemData.Stats.Energy
		clone.Visible 					= true
		clone.Name 						= id
		clone.Parent 					= container

		clone.Activated:Connect(function() 
			activeData					= 
				{
					Clone 				= clone,
					ID 					= id,
					RandomID			= randomID,
				}
			
			if isDeleting				then
				clone.Wrong_Frame.Visible	= not clone.Wrong_Frame.Visible
				return
			end
			
			invActionEvent:FireServer("ToggleEquip", activeData)
		end)
	end	
end

----------------------------
local function UpdateInv()
	DestroyAll()

	if isOpened.Value					then
		equippedText.Text				= "Equipped: "..tostring(#equippedFolder:GetChildren()).."/"..tostring(maxEquipped.Value)
		inventoryText.Text				= "Inventory: "..tostring(#invFolder:GetChildren()).."/"..tostring(maxInventory.Value)
		
		DisplayItems()
	end
end

invActionEvent.OnClientEvent:Connect(function(action)
	UpdateInv()
end)

----------------------------
local function ToggleOpen(newValue)
	isOpened.Value						= newValue
	
	if isOpened.Value 					then
		isDeleting						= false
		deleteTable						= {}
	end

	UpdateInv()
end

buttons["Open"].Activated:Connect(function()
	ToggleOpen(not isOpened.Value)
end)

buttons["Close"].Activated:Connect(function()
	ToggleOpen(false)
end)

buttons["Delete"].Activated:Connect(function()
	isDeleting							= not isDeleting
	
	if not isDeleting					then
		for i, item in pairs(container:GetChildren()) do
			if not item:IsA(fighterAssets.Sample.ClassName) then continue end
			if not item.Wrong_Frame.Visible 				then continue end
			
			local template				= 
				{
					ID 					= item.Config.ID.Value,
					RandomID			= item.Config.RandomID.Value,
				}
			
			table.insert(deleteTable, template)
			item:Destroy()
		end
		
		invActionEvent:FireServer("Delete", deleteTable)
		deleteTable						= {}
	end
	
end)

buttons["EquipBest"].Activated:Connect(function()
	invActionEvent:FireServer("EquipBest")
end)

buttons["UnequipAll"].Activated:Connect(function()
	invActionEvent:FireServer("UnequipAll")
end)

----------------------------
SetupStats()

helpersModule.SetupSearchBar(mainFrame.SearchBox, container, fighterAssets.Sample.ClassName)

for i, btn in pairs(buttons) 			do
	if btn.Name == "Open"				then continue end
	
	setupGUI.SetupBtnAnimations(btn, 1.05, 1.05)
end

----------------------------
return module
