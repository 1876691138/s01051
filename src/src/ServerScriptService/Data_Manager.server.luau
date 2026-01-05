local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService") -- [新增] 获取服务

local Module = require(ReplicatedStorage:WaitForChild("Data_Module")) 

------------------------------------------------------------------
-- [新增] 安全加载果实系统
-- 这样写可以防止因为路径错误导致整个 Data_Manager 崩溃
local fruitsModule = nil
local success, result = pcall(function()
	-- 注意：这里路径指向 Manager -> Fruits 文件夹 -> init 脚本
	return require(ServerScriptService.Manager.Fruits.init)
end)

if success then
	fruitsModule = result
	print("✅ 果实系统 (Fruits System) 加载成功！")
else
	warn("⚠️ 果实系统加载失败，请检查路径！错误信息: " .. tostring(result))
end
------------------------------------------------------------------

local DataStore = DataStoreService:GetDataStore("Main_Data..3")


local function SavePlayer(player)
	local folder = player:FindFirstChild("Player_Data")
	if not folder then return end

	local saveTable = {

		["Inventory"] = {

		},

		["Current"] = {

		}

	}

	for currencyKey, data in pairs(Module.Currencies) do
		local currencyName = data.Currency_Name
		local valueObj = folder:FindFirstChild(currencyName)

		if valueObj then
			saveTable[currencyName] = valueObj.Value
		end
	end

	for _,f in pairs(folder.Inventory:GetChildren()) do

		saveTable.Inventory[f.Name] = {}

		for _,v in pairs(f:GetChildren()) do
			saveTable.Inventory[f.Name][v.Name] = v.Value
		end

	end

	for _,v in pairs(folder.Current:GetChildren()) do

		saveTable.Current[v.Name] = v.Value

	end

	local success, err = pcall(function()
		DataStore:SetAsync(player.UserId, saveTable)
	end)

	if not success then
		warn("Failed saving currencies for " .. player.Name .. ": " .. err)
	end
end


local function PlayerAdded(player)
	local folder = Instance.new("Folder")
	folder.Name = "Player_Data"
	folder.Parent = player

	-------------------------------------------------------
	-- [新增] 初始化玩家的果实数据
	if fruitsModule then
		task.spawn(function()
			fruitsModule.SetupPlayer(player)
		end)
	end
	-------------------------------------------------------

	local Inventory = Instance.new("Folder")
	Inventory.Name = "Inventory"
	Inventory.Parent = folder

	local Current = Instance.new("Folder")
	Current.Name = "Current"
	Current.Parent = folder



	local data

	local success, err = pcall(function()
		data = DataStore:GetAsync(player.UserId)
	end)

	if not success or (success and not data) then
		data = {}
	end


	for currencyKey, currencyData in pairs(Module.Currencies) do
		local currencyName = currencyData.Currency_Name

		local value = Instance.new("IntValue")
		value.Name = currencyName
		value.Value = data[currencyName] or 0
		value.Parent = folder

		local value = Instance.new("StringValue")
		value.Name = currencyName
		value.Parent = Current

		local folder = Instance.new("Folder")
		folder.Name = currencyName
		folder.Parent = Inventory
	end
	-- warn(data) -- 调试用，觉得吵可以注释掉
	if data then

		if data.Inventory then

			for n1,f in pairs(data.Inventory) do

				for n2,v in pairs(f) do
					local value = Instance.new("IntValue")
					value.Name = n2
					value.Value = v
					value.Parent = Inventory[n1]
				end
			end

		end

		if data.Current then

			for n1,v in pairs(data.Current) do
				Current[n1].Value = v
			end

		end
	end

end

Players.PlayerAdded:Connect(PlayerAdded)
Players.PlayerRemoving:Connect(SavePlayer)


game:BindToClose(function()
	for _, player in ipairs(Players:GetPlayers()) do
		SavePlayer(player)
	end
end)

local Spinners = {}

ReplicatedStorage.Events.Client.Others.SpinCooldown.OnServerEvent:Connect(function(Player)
	Spinners[Player] = nil

	Player:SetAttribute("Spin_Cooldown",nil)
end)

ReplicatedStorage.Events.Client.Others.Purchase.OnServerInvoke = function(Player,Section)

	if Spinners[Player] then return end

	if not Section then return end

	local MyCurrency = Player["Player_Data"]:FindFirstChild(Section)

	if not MyCurrency then return end

	local Inventory = Player["Player_Data"].Inventory

	local ItemData = Module.Items[Section]

	if not ItemData then return end

	local Price = Module.Currencies[Section]["Crate_Price"]

	if Price > MyCurrency.Value then return false,nil,nil,"No_Money" end

	Spinners[Player] = true

	Player:SetAttribute("Spin_Cooldown",true)

	MyCurrency.Value -= Price

	local SkinName,SkinData = Module.GetRandomItem(Section)

	task.delay(3,function()

		local Parent = Inventory[Section]

		warn(SkinName)

		local IntValue = Parent:FindFirstChild(SkinName)

		if IntValue then
			IntValue.Value += 1
		else
			IntValue = Instance.new("IntValue")
			IntValue.Value = 1
			IntValue.Name = SkinName
			IntValue.Parent = Parent
		end

	end)

	return true,SkinName,SkinData

end

ReplicatedStorage.Functions.Client.EquipVault.OnServerInvoke = function(Player,Section,Name)

	if not Section or not Name then return end

	local Inventory = Player["Player_Data"]:WaitForChild("Inventory"):FindFirstChild(Section)

	if not Inventory then return end

	local ItemData = Module.Items[Section]

	if not ItemData then return end

	local Target = Inventory:FindFirstChild(Name)

	if not Target then return end 

	Player["Player_Data"]["Current"][Section].Value = Name

	return true

end