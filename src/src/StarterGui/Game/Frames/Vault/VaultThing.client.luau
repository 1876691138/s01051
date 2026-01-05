--!strict
-- Frames/Vault/VaultThing.client.lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Player_Data = LocalPlayer:WaitForChild("Player_Data")
local screenGui = script:FindFirstAncestorWhichIsA("ScreenGui") or script.Parent
local Frames    = screenGui:WaitForChild("Frames")
local Vault     = script.Parent :: GuiObject
local SetupGUI  = require(screenGui:WaitForChild("SetupGUI"))

local LEFT = screenGui:FindFirstChild("LeftSide") and screenGui.LeftSide:FindFirstChild("Buttons")
local RIGHT = screenGui:FindFirstChild("RightSide") and screenGui.RightSide

local Index          = Vault:WaitForChild("Index")
local ScrollingFrame = Index:WaitForChild("ScrollingFrame")

-- Config
local OPEN_VAULT_ON_CLOSE = true
local Data_Module = require(ReplicatedStorage:WaitForChild("Data_Module"))

-- Cache so SetupAnim runs once per panel root
local setupCache: {[GuiObject]: boolean} = {}
local closeBindCache: {[GuiObject]: boolean} = {}

local Connections = {}


local function UpdateVaultCurrent()
	for _,v:StringValue in pairs(Player_Data:WaitForChild("Current"):GetChildren()) do
		local Target = ScrollingFrame:FindFirstChild(v.Name)
		
		if not Target then continue end
		
		Target.Current.Text = v.Value ~= "" and v.Value or "None"
	end
end

for _,v:StringValue in pairs(Player_Data:WaitForChild("Current"):GetChildren()) do
	v:GetPropertyChangedSignal("Value"):Connect(function()
		UpdateVaultCurrent()
	end)
end

UpdateVaultCurrent()

local function ensureSetup(panel: GuiObject)
	if not setupCache[panel] then
		SetupGUI.SetupAnim(panel)
		setupCache[panel] = true
	end
end

local function flipAllButtonsOff()
	if LEFT then
		for _, b in ipairs(LEFT:GetChildren()) do
			local v = b:FindFirstChild("IsOpened")
			if v and v:IsA("BoolValue") then v.Value = false end
		end
	end
	if RIGHT then
		for _, b in ipairs(RIGHT:GetChildren()) do
			local v = b:FindFirstChild("IsOpened")
			if v and v:IsA("BoolValue") then v.Value = false end
		end
	end
end
local ZoneModule= require(game.ReplicatedStorage.ModuleScripts.APIs.Zone)
local MapZones = workspace:WaitForChild("Scriptables"):WaitForChild("MapZones")

-- Bind all descendant "Close" buttons of a target panel (only once per panel)
local function bindCloseButtonsFor(panel: GuiObject)
	if closeBindCache[panel] then return end
	closeBindCache[panel] = true

	local function hook(inst: Instance)
		if (inst:IsA("TextButton") or inst:IsA("ImageButton")) and inst.Name == "Close" then
			inst.Activated:Connect(function()
				ensureSetup(panel)
				
				SetupGUI.Close(panel)
				if OPEN_VAULT_ON_CLOSE then
					ensureSetup(Vault)
					SetupGUI.Open(Vault)
				end
			end)
		end
	end

	for _, d in ipairs(panel:GetDescendants()) do
		hook(d)
	end
	panel.DescendantAdded:Connect(hook)
end

local Storage = Frames:WaitForChild("Storage")

local debounce = false

local Index_Template = script:WaitForChild("Template")

local function InventoryManager(Section_Name)

	local Currencies = Data_Module.Currencies[Section_Name]

	if not Currencies then return end

	local Items = Data_Module.Items[Section_Name]

	local Index = Storage:WaitForChild("Storage")
	local ItemImage = Storage:WaitForChild("Secret"):WaitForChild("Item")
	local Description = Storage:WaitForChild("Description")
	
	local EquipConnection,SelectConnection

	for _,v in pairs(Index:GetChildren()) do
		if v:IsA("Frame") then
			v:Destroy()
		end
	end
	
	local StringValue = Player_Data:WaitForChild("Current"):WaitForChild(Section_Name)
	
	EquipConnection = StringValue:GetPropertyChangedSignal("Value"):Connect(function()
		
		local ItemData = Data_Module.Items[Section_Name][StringValue.Value]
		
		Description.Name_Holder.Text = ItemData and StringValue.Value or "None"
		
		ItemImage.Image = ItemData and ItemData.Image or ""
		
		ItemImage.Parent.None.Visible = not ItemData
		
		ItemImage.Parent.UIStroke.Color = ItemData and Data_Module.Rarities[ItemData.Rarity] or Color3.fromRGB(0, 0, 0)
	end)
	
	SelectConnection = Storage:WaitForChild("Select").MouseButton1Click:Connect(function()
		for _,v in pairs(Connections) do
			v:Disconnect()
		end

		Connections = {}

		SetupGUI.Close(Storage)	
	end)
	
	table.insert(Connections,SelectConnection)
	
	local ItemData = Data_Module.Items[Section_Name][StringValue.Value]

	Description.Name_Holder.Text = ItemData and StringValue.Value or "None"

	ItemImage.Image = ItemData and ItemData.Image or ""

	ItemImage.Parent.None.Visible = not ItemData
	
	ItemImage.Parent.UIStroke.Color = ItemData and Data_Module.Rarities[ItemData.Rarity] or Color3.fromRGB(0, 0, 0)
	
	table.insert(Connections,EquipConnection)

	for N,D in pairs(Items) do
		local Template = Index_Template:Clone()
		Template.Name = N
		Template.LayoutOrder = D.Layout_Order
		Template.Lock.Visible = not Player_Data:WaitForChild("Inventory"):WaitForChild(Section_Name):FindFirstChild(N)
		Template.UIStroke.Color = Data_Module.Rarities[D.Rarity]
		Template.Item.Image = D.Image
		
		Template:WaitForChild("Button").MouseButton1Click:Connect(function()
			local returned = ReplicatedStorage:WaitForChild("Functions"):WaitForChild("Client"):WaitForChild("EquipVault"):InvokeServer(Section_Name,N)
		end)
		
		Template.Parent = Index
	end




end

local function openPanelFromTile(section)
	if debounce then return end
	debounce = true
	
	SetupGUI.Close(Vault)
	
	local target = Storage
	if not (target and target:IsA("GuiObject")) then
		warn("[VaultThing] No panel named", section, "under Frames")
		debounce = false
		return
	end

	ensureSetup(Vault)
	ensureSetup(target)

	flipAllButtonsOff()

	-- Wire its Close buttons exactly once
	bindCloseButtonsFor(target)
	
	game.Workspace.Scriptables.MapZones.LeftZone.Event:Connect(function()
		
		for _,v in pairs(Connections) do
			v:Disconnect()
		end

		Connections = {}
		
		SetupGUI.Close(target)	
	end)
	
	InventoryManager(section)
	
	SetupGUI.Open(target)

	task.delay(0.12, function() debounce = false end)
end

local function bindTile(child: Instance)
	if not child:IsA("Frame") then return end
	local button = child:FindFirstChildWhichIsA("ImageButton")
	if not button then return end
	button.Activated:Connect(function()
		openPanelFromTile(child.Name)
	end)
end

for _, child in ipairs(ScrollingFrame:GetChildren()) do
	bindTile(child)
end
ScrollingFrame.ChildAdded:Connect(bindTile)

