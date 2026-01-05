--!strict
-- ZoneManager.client.lua (fast open version)
-- Opens target panel immediately on zone enter; closes previous panel in parallel.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Market = game:GetService("MarketplaceService")

local LocalPlayer = Players.LocalPlayer
local PLayer_Data = LocalPlayer:WaitForChild("Player_Data")
local screenGui = script:FindFirstAncestorWhichIsA("ScreenGui") or script.Parent
local Frames    = screenGui:WaitForChild("Frames")
local SetupGUI  = require(screenGui:WaitForChild("SetupGUI"))
local Data_Module = require(ReplicatedStorage:WaitForChild("Data_Module"))
local ZoneModule= require(ReplicatedStorage.ModuleScripts.APIs.Zone)

local Spinner = screenGui:WaitForChild("Frames"):WaitForChild("Spinner")
local BuyMore = Spinner:WaitForChild("BuyMore")

for _,v in pairs(BuyMore:GetChildren()) do
	if v:IsA("TextButton") then
		v.MouseButton1Click:Connect(function()
			
			if not v:GetAttribute("ID") then return end
			
			Market:PromptProductPurchase(LocalPlayer,v:GetAttribute("ID"))
		end)
	end
end

local StopAutoButton = script.Parent:WaitForChild("Stop_Auto_Spin")

local Connections = {}

local Index_Template = script:WaitForChild("Index_Template")
-- If you want animating the inner container instead, flip this to return frame.Index when present.
local function animNode(frame: Instance): GuiObject
	-- animate the root to guarantee .Visible flips instantly
	return frame :: GuiObject
end

local Warning_Text = script.Parent:WaitForChild("WarningText")
local Failed_Sound = script.Parent:WaitForChild("Purchase Failed")

local function SpinnerManager(Gui,Section_Name)
	
	local Currencies = Data_Module.Currencies[Section_Name]
	
	if not Currencies then return end
	
	local Items = Data_Module.Items[Section_Name]
	
	local BuyMore = Gui:WaitForChild("BuyMore")
	local Currency = Gui:WaitForChild("Currency")
	local Current = Gui:WaitForChild("Current")
	local Index = Gui:WaitForChild("Index"):WaitForChild("ScrollingFrame")
	local Price = Gui:WaitForChild("Price")
	local Menu = Gui:WaitForChild("MenuName") 
	local RollButton = Gui:WaitForChild("RollButton")
	local AutoButton = Gui:WaitForChild("AutoButton")
	
	
	for _,v in pairs(Index:GetChildren()) do
		if v:IsA("TextButton") then
			v:Destroy()
		end
	end
	
	for _,v in pairs(BuyMore:GetChildren()) do
		if v:IsA("TextButton") then
			v.ImageLabel.Image = Currencies["Currency_Image"]
			v:SetAttribute("ID",Currencies["Dev_Products"][tonumber(v.Name)])
		end
	end
	
	Currency.ImageLabel.Image = Currencies["Currency_Image"]
	
	Menu.Title.Text = Section_Name
	Price.Amount.Text = "Price :"..Currencies.Crate_Price
	
	local Int:IntValue = PLayer_Data:WaitForChild(Section_Name)
	
	local IntConnection,PurchaseConnection,RerollConnection,StopConnection
	
	local BreakAuto = false
	
	local StringValue = PLayer_Data:WaitForChild("Current"):WaitForChild(Section_Name)
	
	local ItemData = Data_Module.Items[Section_Name][StringValue.Value]

	Current.Race.Name_Holder.Text = ItemData and StringValue.Value or "None"

	Current.Image_Holder.ImageLabel.Image = ItemData and ItemData.Image or ""

	Current.Race.Name_Holder.TextColor3 = ItemData and Data_Module.Rarities[ItemData.Rarity] or Color3.fromRGB(255, 255, 255)
	
	IntConnection = Int:GetPropertyChangedSignal("Value"):Connect(function()
		Currency.Amount.Text = Int.Value
	end)
	
	PurchaseConnection = RollButton.MouseButton1Click:Connect(function()
		
		if LocalPlayer:GetAttribute("Spin_Cooldown") then return end
		
		if PLayer_Data:WaitForChild(Section_Name).Value < Data_Module.Currencies[Section_Name]["Crate_Price"] then
			if Warning_Text.Text == "Insufficient Amount" then
				return
			end

			Warning_Text.Text = "Insufficient Amount"
			Failed_Sound:Play()
			task.wait(3)
			Warning_Text.Text = ""
			return
		end
		
		local returned,skin,data = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Client"):WaitForChild("Others"):WaitForChild("Purchase"):InvokeServer(Section_Name)
		
		if returned then
			ReplicatedStorage:WaitForChild("Events"):WaitForChild("Client"):WaitForChild("Others"):WaitForChild("Unbox"):Fire(Section_Name,skin,data)
		end
	end)
	
	RerollConnection = AutoButton.MouseButton1Click:Connect(function()
		
		if LocalPlayer:GetAttribute("Spin_Cooldown") then return end
		
		if PLayer_Data:WaitForChild(Section_Name).Value < Data_Module.Currencies[Section_Name]["Crate_Price"] then
			if Warning_Text.Text == "Insufficient Amount" then
				return
			end
			
			Warning_Text.Text = "Insufficient Amount"
			Failed_Sound:Play()
			task.wait(3)
			Warning_Text.Text = ""
			return
		end
		
		StopAutoButton.Visible = true
		
		StopConnection = StopAutoButton.MouseButton1Click:Connect(function()
			BreakAuto = true
			
			StopAutoButton.Visible = false
		end)
		
		table.insert(Connections,StopConnection)
		
		repeat
			
		local returned,skin,data,no_cash = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Client"):WaitForChild("Others"):WaitForChild("Purchase"):InvokeServer(Section_Name)

		if returned then
			ReplicatedStorage:WaitForChild("Events"):WaitForChild("Client"):WaitForChild("Others"):WaitForChild("Unbox"):Fire(Section_Name,skin,data)
		end
		
		task.wait(1)
		
		until BreakAuto or no_cash
		
	end)
	
	table.insert(Connections,IntConnection)

	table.insert(Connections,PurchaseConnection)
	
	table.insert(Connections,RerollConnection)

	
	Currency.Amount.Text = Int.Value
	
	for N,D in pairs(Items) do
		local Template = Index_Template:Clone()
		Template.Name = N
		Template.LayoutOrder = D.Layout_Order
		Template.Item.Text = N
		Template.Item.TextColor3 = Data_Module.Rarities[D.Rarity]
		Template.Chance.Text = D.Show_Chance and D.Chance.."%" or "???"
		Template.Parent = Index
	end
	
	
	
	
end

local setupCache: {[GuiObject]: boolean} = {}
local function ensureSetup(frame: GuiObject)
	local node = animNode(frame)
	if setupCache[node] then return end
	SetupGUI.SetupAnim(node)
	setupCache[node] = true
end

local currentFrame: GuiObject? = nil
local currentZonePart: BasePart? = nil

local function openImmediate(frameName: string,Zone : string)
	local frame = Frames:FindFirstChild(frameName)
	if not (frame and frame:IsA("GuiObject")) then
		warn("[ZoneManager] Missing frame:", frameName)
		return
	end
	if currentFrame == frame then
		return -- already open
	end

	-- Prep new frame quickly
	ensureSetup(frame)
	local node = animNode(frame)

	-- OPEN FIRST (no waits)
	-- make it feel instant even if your Open tween does setup internally
	
	task.spawn(function()
		
		
		
		SetupGUI.Open(node) -- run the tween without blocking this thread
		
		if frameName == "Spinner" then
			SpinnerManager(node,Zone)
		end
		
		node.Visible = true
	end)

	-- CLOSE previous (if any) in parallel
	if currentFrame and currentFrame ~= frame then
		local prev = animNode(currentFrame)
		task.spawn(function()
			
			for _,v in pairs(Connections) do
				v:Disconnect()
			end
			
			Connections = {}
			
			SetupGUI.Close(prev)
		end)
	end

	currentFrame = frame
end

local function closeIfCurrent(frameName: string)
	local frame = Frames:FindFirstChild(frameName)
	if not (frame and frame:IsA("GuiObject")) then return end
	if currentFrame ~= frame then return end

	ensureSetup(frame)
	local node = animNode(frame)
	task.spawn(function()
		SetupGUI.Close(node)
	end)
	currentFrame = nil
end

-- Hook zones under Workspace.Scriptables.MapZones
local MapZones = workspace:WaitForChild("Scriptables"):WaitForChild("MapZones")
local function bindZone(part)
	local zone = ZoneModule.new(part)
	zone:bindToGroup("EnterOnlyOneZoneAtATime")

	zone.localPlayerEntered:Connect(function()
		currentZonePart = part
		local target = part:GetAttribute("TargetFrame") or part.Name
		openImmediate(target,part.Parent.Name)
	end)

	zone.localPlayerExited:Connect(function()
		if currentZonePart ~= part then
			return -- exited a zone that's not the active one; ignore
		end
		local target = part:GetAttribute("TargetFrame") or part.Name
		for _,v in pairs(Frames:GetChildren()) do
			closeIfCurrent(v.Name)
		end
		currentZonePart = nil
		game.Workspace.Scriptables.MapZones.LeftZone:Fire()
	end)
end

for _, child in ipairs(MapZones:GetChildren()) do
	if child:IsA("BasePart") or child:IsA("Model") then
		
		if child:IsA("Model") then
			child = child.PrimaryPart
		end
		
		bindZone(child)
	end
end
MapZones.ChildAdded:Connect(function(child)
	if child:IsA("BasePart") or child:IsA("Model") then
		
		if child:IsA("Model") then
			child = child.PrimaryPart
		end
		
		bindZone(child)
	end
end)
