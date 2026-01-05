local module 							= {}

----------------------------------------
--//Services
local marketplaceService				= game:GetService("MarketplaceService")
local replicatedStorage					= game:GetService("ReplicatedStorage")
local playersService					= game:GetService("Players")
local tweenService						= game:GetService("TweenService") -- [新增]

--//LocalPlr
local plr 								= playersService.LocalPlayer
local plrOthers							= plr:WaitForChild("Others")
local plrBoosts							= plrOthers:WaitForChild("Boosts")

--//GUI
local thisGUI							= script.Parent.Parent.Parent
local multiFrame						= thisGUI:WaitForChild("Multiplier")

--//Functions
local getThisStatMultiFunc				= replicatedStorage["Functions"]["Client"]["GetThisStatMulti"]
local helpersModule						= require(replicatedStorage.ModuleScripts.APIs.Helpers)

--//Settings
local TWEEN_INFO						= TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local HIDDEN_POSITION					= UDim2.new(0, -200, 0.5, 0) -- [需调整] 隐藏到屏幕左侧外面 (假设原点在左边)
local VISIBLE_POSITION					= multiFrame.Position 		 -- 记录初始位置作为显示位置

--//State
local isVisible							= true
local isBusy							= false

-----------------------------
--// [新增] 脚本化创建 UI 按钮
local function CreateArrowButton()
	local btn = Instance.new("ImageButton")
	btn.Name = "ToggleArrow"
	btn.Size = UDim2.new(0, 30, 0, 50)
	-- 将按钮放在 Frame 的右侧边缘，这样 Frame 收进去时按钮还露在外面
	btn.Position = UDim2.new(1, 0, 0.5, -25) 
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.BorderSizePixel = 0
	btn.ZIndex = multiFrame.ZIndex
	-- 设置一个默认箭头图标 (Roblox 默认资源，你可以换成自己的)
	btn.Image = "rbxassetid://6031091004" -- 左箭头
	btn.Rotation = 0 -- 初始向左或向右，根据状态调整
	btn.Parent = multiFrame

	-- 圆角优化
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = btn

	return btn
end

local arrowBtn = CreateArrowButton()

-----------------------------
--// [新增] 滑动控制逻辑
local function ToggleMenu()
	if isBusy then return end
	isBusy = true

	local targetPos
	local targetRot

	if isVisible then
		-- 当前是显示的，准备隐藏
		targetPos = HIDDEN_POSITION
		targetRot = 180 -- 箭头翻转
		isVisible = false
	else
		-- 当前是隐藏的，准备显示
		targetPos = VISIBLE_POSITION
		targetRot = 0
		isVisible = true
	end

	-- 播放 UI 位移动画
	local tween = tweenService:Create(multiFrame, TWEEN_INFO, {Position = targetPos})
	local rotTween = tweenService:Create(arrowBtn, TWEEN_INFO, {Rotation = targetRot})

	tween:Play()
	rotTween:Play()

	tween.Completed:Wait()
	isBusy = false
end

arrowBtn.MouseButton1Click:Connect(ToggleMenu)

-----------------------------
function FormatToTwoDecimals(number)
	return string.format("%.2f", number)
end

-----------------------------
local function Update()
	for i, child in pairs(multiFrame:GetChildren()) do
		local isCorrect					= child:IsA("Frame")
		if not isCorrect				then continue end

		local newValue					= getThisStatMultiFunc:InvokeServer(child.Name)
		if not newValue					then continue end

		child["Amount"].Text			= "x"..helpersModule.AbbreviateNumber(newValue)
	end
end

-----------------------------
coroutine.wrap(function()
	while task.wait(5) 					do
		if isVisible then -- 只有显示的时候才更新数据，节省性能
			Update()
		end
	end
end)()

-----------------------------
task.spawn(function()
	Update()
end)

-----------------------------
return module