--//Services
local replicatedStorage					= game:GetService("ReplicatedStorage")
local serverStorage						= game:GetService("ServerStorage")
local playersService					= game:GetService("Players")
local physicsService					= game:GetService("PhysicsService")
local runService						= game:GetService("RunService")

--//References
local scriptablesFolder					= game.Workspace:FindFirstChild("Scriptables") or Instance.new("Folder", game.Workspace) -- 防报错
local spawnsFolder						= scriptablesFolder:FindFirstChild("Spawns") or Instance.new("Folder", scriptablesFolder)
local Terrain 							= game.Workspace.Terrain

--//ModuleScripts
local childModules						= {}

-----------------------------
-- [修复 1] 加载模块逻辑
for i, child in pairs(script:GetChildren()) do
	-- 如果是文件夹（比如 Fruits），就跳过它，而不是停止整个脚本 (return -> continue)
	if not child:IsA("ModuleScript") then continue end

	-- 使用 pcall 防止某个模块报错导致所有模块都挂掉
	local success, result = pcall(function()
		return require(child)
	end)

	if success then
		childModules[child.Name] = result
	else
		warn("⚠️ 模块加载失败: " .. child.Name .. " | 原因: " .. tostring(result))
	end
end

-----------------------------
local function Passes(plr)
	local Passes						= Instance.new("Folder", plr)
	Passes.Name 						= "Passes"

	local list = {"Lucky", "SuperLucky", "UltraLucky", "VIP", "SuperVIP", "AutoClicker"}
	for _, name in pairs(list) do
		local val = Instance.new("BoolValue", Passes)
		val.Name = name
	end
end	

-----------------------------
playersService.PlayerAdded:Connect(function(plr)
	Passes(plr)

	plr.CharacterAdded:Connect(function(char)
		if childModules["Fighters"] then
			childModules["Fighters"].ContainerSetup(char)
		end

		task.delay(3, function()
			if childModules["Upgrades"] then
				childModules["Upgrades"].UpdateGUI(plr, char)
			end
		end)

		task.delay(1, function()
			-- 增加安全检查
			local fighters = plr:FindFirstChild("Fighters")
			local equipped = fighters and fighters:FindFirstChild("Equipped")

			if equipped and childModules["Fighters"] then
				for x, child in pairs(equipped:GetChildren()) do
					childModules["Fighters"].ToggleEquip(plr, true, child.ID.Value, child.RandomID.Value)
					task.wait(0.1)
				end
			end
		end)

		for i, desc in pairs(char:GetDescendants()) do
			if desc:IsA("BasePart") or desc:IsA("UnionOperation") then
				desc.CollisionGroup		= "Plr"
			end
		end
	end)

	-- 安全调用各模块
	if childModules["Saving"] then
		childModules["Saving"].LoadFighters(plr)
		childModules["Saving"].LoadLeaderstats(plr)
		childModules["Saving"].LoadOthers(plr)
		childModules["Saving"].LoadAchievements(plr)
		childModules["Saving"].LoadTeleports(plr)
		childModules["Saving"].LoadTokens(plr)
	end

	if childModules["MicroTransactions"] then
		childModules["MicroTransactions"].CheckAllPasses(plr)
	end

	coroutine.wrap(function()
		while task.wait(1) do
			if childModules["Achievements"] then
				childModules["Achievements"].AddStat(plr, "Playtime", 1)
			end
		end
	end)()

	if childModules["Achievements"] then
		childModules["Achievements"].UpdateBoosts(plr)
	end
end)

playersService.PlayerRemoving:Connect(function(plr)
	if childModules["Saving"] then
		childModules["Saving"].SaveFighters(plr)
		childModules["Saving"].SaveLeaderstats(plr)
		childModules["Saving"].SaveOthers(plr)
		childModules["Saving"].SaveAchievements(plr)
		childModules["Saving"].SaveTeleports(plr)
		childModules["Saving"].SaveTokens(plr)
	end
end)

-----------------------------
-- [修复] 只有当 Group 不存在时才注册，防止报错
local function safeRegisterGroup(name)
	local success, _ = pcall(function()
		physicsService:RegisterCollisionGroup(name)
	end)
end

safeRegisterGroup("Plr")
safeRegisterGroup("Fighter")
physicsService:CollisionGroupSetCollidable("Plr", "Fighter", false)

-----------------------------
for i, child in pairs(spawnsFolder:GetChildren()) do
	child.Touched:Connect(function(hit)
		local char						= hit.Parent
		if not char						then return end

		local plr						= playersService:GetPlayerFromCharacter(char)
		if not plr 						then return end

		plr.RespawnLocation				= child
	end)
end


-----------------------------
-- [修复 2] 优化水体检测 (解决卡顿)
local playersInWater = {}

-- 以前是 Heartbeat (60次/秒)，现在改成 Loop (每 0.3 秒检测一次)
task.spawn(function()
	while task.wait(0.3) do 
		for _, player in pairs(playersService:GetPlayers()) do
			local character = player.Character
			local root = character and character:FindFirstChild("HumanoidRootPart")

			if root then
				-- 缩小检测范围，提升性能
				local region = Region3.new(
					root.Position - Vector3.new(1, 1, 1),
					root.Position + Vector3.new(1, 1, 1)
				):ExpandToGrid(4)

				local materials = Terrain:ReadVoxels(region, 4)

				local isInWater = false
				-- 简化循环
				if materials[1] and materials[1][1] and materials[1][1][1] == Enum.Material.Water then
					isInWater = true
				else
					-- 如果中心点没检测到，再遍历周围 (可选，通常中心点就够了)
					for x = 1, materials.Size.X do
						for y = 1, materials.Size.Y do
							for z = 1, materials.Size.Z do
								if materials[x][y][z] == Enum.Material.Water then
									isInWater = true
									break
								end
							end
							if isInWater then break end
						end
						if isInWater then break end
					end
				end

				if isInWater and not playersInWater[player] then
					playersInWater[player] = true
					-- print(player.Name .. " touched water!") -- 调试信息，觉得吵可以注释掉
					player:LoadCharacter()

				elseif not isInWater and playersInWater[player] then
					playersInWater[player] = nil
					-- print(player.Name .. " left the water.")
				end
			end
		end
	end
end)