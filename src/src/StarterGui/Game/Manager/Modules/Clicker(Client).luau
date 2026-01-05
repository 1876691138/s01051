local module 							= {}

----------------------------------------
--//Services
local UserInputService 					= game:GetService("UserInputService")
local marketplaceService				= game:GetService("MarketplaceService")
local replicatedStorage					= game:GetService("ReplicatedStorage")
local playersService					= game:GetService("Players")

--//LocalPlr
local plr 								= playersService.LocalPlayer
local character 						= plr.Character
local humanoid 							= character:WaitForChild("Humanoid")

local plrPasses							= plr:WaitForChild("Passes", 3)
local VIP								= plrPasses:WaitForChild("VIP", 3)
local SuperVIP							= plrPasses:WaitForChild("SuperVIP", 3)
local AutoClicker						= plrPasses:WaitForChild("AutoClicker", 3)

--//GUI
local thisGUI							= script.Parent.Parent.Parent
local mainFrame							= thisGUI.Clicker

--//Events
local clickEvent						= replicatedStorage["Events"]["Client"]["Others"]["Click"]

--//Funcs
local getThisPassFunc					= replicatedStorage["Functions"]["Client"]["GetThisPass"]

--//Settings
local autoClickerPass					= getThisPassFunc:InvokeServer("AutoClicker")
local walkSpeeds						= 
	{
		["Normal"]						= 16,
		["Sprint"]						= 28,
	}

local autoColors						= 
	{
		["InActive"]					= Color3.fromRGB(255, 255, 0),
		["Active"]						= Color3.fromRGB(255, 85, 0),
	}


--//Runtime
local isAutoClicking					= false
local sprinting 						= false

-----------------------------
local function GetMulti()
	local total							= 1

	if VIP.Value						then
		total							*= 1.5
	end

	if SuperVIP.Value					then
		--total							*= 1.5
	end

	return total
end


local function ToggleSprint()
	if not sprinting					then
		sprinting 						= true
		mainFrame["Sprint"].BackgroundColor3	= autoColors["Active"]
		
		humanoid.WalkSpeed 				= walkSpeeds["Sprint"] * GetMulti()

	elseif sprinting					then
		sprinting 						= false
		mainFrame["Sprint"].BackgroundColor3	= autoColors["InActive"]
		
		humanoid.WalkSpeed 				= walkSpeeds["Normal"] * GetMulti()
	end
end

-----------------------------------
local function CanAutoClick(plr)
	return AutoClicker.Value
end

-----------------------------------
mainFrame["Clicker"]["Click"].Activated:Connect(function()
	clickEvent:FireServer()
end)

mainFrame["Sprint"]["Sprint"].Activated:Connect(function()
	ToggleSprint()
end)

mainFrame["Auto"]["Auto"].Activated:Connect(function()
	if not CanAutoClick(plr)			then
		marketplaceService:PromptGamePassPurchase(plr, autoClickerPass.Code)
		return 
	end
	
	isAutoClicking						= not isAutoClicking
	if isAutoClicking					then
		mainFrame["Auto"].BackgroundColor3	= autoColors["Active"]
	else
		mainFrame["Auto"].BackgroundColor3	= autoColors["InActive"]
	end
end)

-----------------------------
UserInputService.InputBegan:Connect(function(Input, gameProcesed)
	if gameProcesed						then return end

	if Input.KeyCode == Enum.KeyCode.LeftControl then
		ToggleSprint()
	end
end)

-----------------------------------
humanoid.WalkSpeed 						= walkSpeeds["Normal"] * GetMulti()

-----------------------------------
local running 							= true

coroutine.wrap(function()
	while running and task.wait(0.65) 	do
		if not isAutoClicking 			then continue end
		if humanoid.Health <= 0 		then break end

		clickEvent:FireServer()
	end
end)()

script.Parent.AncestryChanged:Connect(function(_, parent)
	if not parent 						then
		running 						= false
	end
end)

-----------------------------------
return module
