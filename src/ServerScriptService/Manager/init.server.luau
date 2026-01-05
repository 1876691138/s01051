--//Services
local replicatedStorage					= game:GetService("ReplicatedStorage")
local serverStorage						= game:GetService("ServerStorage")
local playersService					= game:GetService("Players")
local physicsService					= game:GetService("PhysicsService")
local runService						= game:GetService("RunService")

--//References
local scriptablesFolder					= game.Workspace["Scriptables"]
local spawnsFolder						= scriptablesFolder["Spawns"]
local Terrain 							= game.Workspace.Terrain

--//ModuleScripts
local childModules						= {}

-----------------------------
for i, child in pairs(script:GetChildren()) do
	if not child:IsA("ModuleScript") 	then return end
	childModules[child.Name]			= require(child)
end

-----------------------------
local function Passes(plr)
	local Passes						= Instance.new("Folder", plr)
	Passes.Name 						= "Passes"
	
	local Lucky							= Instance.new("BoolValue", Passes)
	Lucky.Name 							= "Lucky"
	
	local SuperLucky					= Instance.new("BoolValue", Passes)
	SuperLucky.Name 					= "SuperLucky"
	
	local UltraLucky					= Instance.new("BoolValue", Passes)
	UltraLucky.Name 					= "UltraLucky"
	
	local VIP							= Instance.new("BoolValue", Passes)
	VIP.Name 							= "VIP"
	
	local SuperVIP						= Instance.new("BoolValue", Passes)
	SuperVIP.Name 						= "SuperVIP"
	
	local AutoClicker					= Instance.new("BoolValue", Passes)
	AutoClicker.Name 					= "AutoClicker"
end	

-----------------------------
playersService.PlayerAdded:Connect(function(plr)
	Passes(plr)
	
	plr.CharacterAdded:Connect(function(char)
		childModules["Fighters"].ContainerSetup(char)
		
		task.delay(3, function()
			childModules["Upgrades"].UpdateGUI(plr, char)
		end)
		
		task.delay(1, function()
			local equipped				= plr:WaitForChild("Fighters"):WaitForChild("Equipped")
			for x, child in pairs(equipped:GetChildren()) do
				childModules["Fighters"].ToggleEquip(plr, true, child.ID.Value, child.RandomID.Value)
				task.wait(0.1)
			end
		end)
		
		for i, desc in pairs(char:GetDescendants()) do
			if desc:IsA("BasePart") or desc:IsA("UnionOperation") then
				desc.CollisionGroup		= "Plr"
			end
		end
	end)
	
	childModules["Saving"].LoadFighters(plr)
	childModules["Saving"].LoadLeaderstats(plr)
	childModules["Saving"].LoadOthers(plr)
	childModules["Saving"].LoadAchievements(plr)
	childModules["Saving"].LoadTeleports(plr)
	childModules["Saving"].LoadTokens(plr)
	
	childModules["MicroTransactions"].CheckAllPasses(plr)
	
	coroutine.wrap(function()
		while task.wait(1) 				do
			childModules["Achievements"].AddStat(plr, "Playtime", 1)
		end
	end)()
	
	childModules["Achievements"].UpdateBoosts(plr)
end)

playersService.PlayerRemoving:Connect(function(plr)
	childModules["Saving"].SaveFighters(plr)
	childModules["Saving"].SaveLeaderstats(plr)
	
	childModules["Saving"].SaveOthers(plr)
	childModules["Saving"].SaveAchievements(plr)
	childModules["Saving"].SaveTeleports(plr)
	childModules["Saving"].SaveTokens(plr)
end)

-----------------------------
physicsService:RegisterCollisionGroup("Plr")
physicsService:RegisterCollisionGroup("Fighter")
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
-- Tag players currently in water to avoid repeating triggers
local playersInWater = {}

runService.Heartbeat:Connect(function()
	for _, player in pairs(playersService:GetPlayers()) do
		local character = player.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")

		if root then
			local region = Region3.new(
				root.Position - Vector3.new(2, 2, 2),
				root.Position + Vector3.new(2, 2, 2)
			):ExpandToGrid(4)

			local materials = Terrain:ReadVoxels(region, 4)

			local isInWater = false
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

			if isInWater and not playersInWater[player] then
				playersInWater[player] = true
				print(player.Name .. " touched water!")
				player:LoadCharacter()

			elseif not isInWater and playersInWater[player] then
				-- Player exited water
				playersInWater[player] = nil
				print(player.Name .. " left the water.")
			end
		end
	end
end)
-----------------------------