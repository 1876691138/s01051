local UserInputService = game:GetService("UserInputService");
local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");

local Character = script.Parent
local Player = game:GetService("Players").LocalPlayer
local HRP = Character:WaitForChild("HumanoidRootPart")

local PlayerGui = Player:WaitForChild("PlayerGui")
local SavedUI = PlayerGui:WaitForChild("Saved")

local Device = nil;
local LastPurchase = nil;
local InsertedModels = {}

local function PromptEgg(EggModel)
	if (EggModel == nil) then
		return;
	end;
	script.Click:Play()
	if LastPurchase and not SavedUI:WaitForChild("Purchase").Visible then
		print("prompted egg, type: "..EggModel.Name)
		SavedUI:WaitForChild("Purchase").Desc.Text = "Would you like to buy a "..EggModel.Name.." Egg for "..tostring(ReplicatedStorage.Eggs[EggModel.Name].Price.Value).." Gold ?"
		SavedUI:WaitForChild("Purchase").Visible = true;
		SavedUI.Purchase.Prompt.Value = EggModel.Name
		SavedUI.Purchase.Type.Value = "Egg";
	end;
	EggModel = nil;
end

if UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
	Device = "PC"
elseif UserInputService.TouchEnabled then
	Device = "Mobile"
else
	Device = "Console"
end

print(Device)

for _, egg in pairs(workspace:WaitForChild("Eggs"):GetChildren()) do
	for _, label in pairs(egg:WaitForChild("Billboards").Purchase.Frame:GetChildren()) do
		if label:IsA("TextLabel") or label:IsA("ImageButton") then
			label.Visible = false;
		end
	end
	local PromptFrame = egg:WaitForChild("Billboards").Purchase.Frame
	local BeginZoom = TweenService:Create(PromptFrame, TweenInfo.new(0.05), {Size = UDim2.fromScale(PromptFrame.Size.X.Scale*0.8,PromptFrame.Size.Y.Scale*0.8)})
	local EndZoom = TweenService:Create(PromptFrame, TweenInfo.new(0.2), {Size = UDim2.fromScale(PromptFrame.Size.X.Scale,PromptFrame.Size.Y.Scale)})
	PromptFrame[Device].Visible = true;
	if Device == "Mobile" then
		PromptFrame[Device].MouseButton1Click:Connect(function()
			task.spawn(function()
				BeginZoom:Play()
				task.wait(0.05)
				EndZoom:Play()
			end)
			PromptEgg(LastPurchase)
		end)
	else
		UserInputService.InputBegan:Connect(function(input, typing)
			if not typing then
				if input.KeyCode == Enum.KeyCode.E or input.KeyCode == Enum.KeyCode.ButtonX then
					task.spawn(function()
						BeginZoom:Play()
						task.wait(0.05)
						EndZoom:Play()
					end)
					PromptEgg(LastPurchase)
				end
			end
		end)
	end
end

while task.wait() do
	local NearEggs = {}
	for _, egg in pairs(workspace:WaitForChild("Eggs"):GetChildren()) do
		local EggPos = egg:IsA("Model") and egg:GetPivot().Position or egg.Egg.Position
		local StartPos = HRP.Position
		local Distance = (StartPos-EggPos).Magnitude
		local Billboards = egg.Billboards
		if Distance <= 20 then
			table.insert(NearEggs, egg)
			if not table.find(InsertedModels, egg) then
				table.insert(InsertedModels, egg)
				TweenService:Create(Billboards.Pets, TweenInfo.new(0.25), {Size = UDim2.fromScale(4,4)}):Play()
			end
		else
			if table.find(InsertedModels, egg) then
				table.remove(InsertedModels, table.find(InsertedModels, egg))
				TweenService:Create(Billboards.Pets, TweenInfo.new(0.25), {Size = UDim2.fromScale(0,0)}):Play()
			end
		end
	end
	if #NearEggs > 0 then
		local NearestDistance = nil;
		for i, egg in ipairs(NearEggs) do
			local EggPos = egg:IsA("Model") and egg:GetPivot().Position or egg.Egg.Position
			local StartPos = HRP.Position
			local Distance = (StartPos-EggPos).Magnitude
			if NearestDistance == nil then
				NearestDistance = egg
			else
				local EggPos2 = NearestDistance.Egg:IsA("Model") and NearestDistance.Egg:GetPivot().Position or NearestDistance.Egg.Position
				local StartPos2 = HRP.Position
				local Distance2 = (StartPos2-EggPos2).Magnitude
				if Distance2 >= Distance then
					NearestDistance = egg
				end
			end
		end
		if NearestDistance ~= LastPurchase then
			if LastPurchase ~= nil then
				local Billboards = LastPurchase.Billboards
				TweenService:Create(Billboards.Purchase, TweenInfo.new(0.25), {Size = UDim2.fromScale(0,0)}):Play()
			end
			TweenService:Create(NearestDistance.Billboards.Purchase, TweenInfo.new(0.25), {Size = UDim2.fromScale(3,3)}):Play()
			LastPurchase = NearestDistance
		end
	else
		if LastPurchase ~= nil then
			local Billboards = LastPurchase.Billboards
			TweenService:Create(Billboards.Purchase, TweenInfo.new(0.25), {Size = UDim2.fromScale(0,0)}):Play()
			LastPurchase = nil;
		end
	end
end