local module 								= {}

-----------------------------
--//Services
local replicatedStorage 					= game:GetService("ReplicatedStorage")
local debrisService 						= game:GetService("Debris")
local players								= game:GetService("Players")
local debris								= game:GetService("Debris")

--//References
local assetsFolder							= replicatedStorage["Assets"]
local gemDrop 								= assetsFolder.GemDrop
local gemPart 								= assetsFolder["Parts"]["GemPart"]

local scriptablesFolder						= game.Workspace["Scriptables"]
local npcsFolder							= scriptablesFolder["NPCs"]
local dropFolder 							= scriptablesFolder["Drops"]

local npcSources							= npcsFolder:Clone()
npcSources.Parent							= assetsFolder

--//ModuleScripts
local short 								= require(replicatedStorage["ModuleScripts"]["APIs"]["Short"])
local boostsModule 							= require(script.Parent["Boosts"])
local tokensModule 							= require(script.Parent["Tokens"])
local achievementsModule 					= require(script.Parent["Achievements"])
local dataModule							= require(script["Data"])

local gamepassesModule						= require(script.Parent["MicroTransactions"]["GamePasses"])

--//Events
local boxEvent								= replicatedStorage.box

--//Settings
local baseValue								= 5
local respawntime 							= 20

local deathAnimation 						= Instance.new("Animation")
deathAnimation.AnimationId 					= "rbxassetid://18337475623"

local hitAnimation 							= Instance.new("Animation")
hitAnimation.AnimationId 					= "rbxassetid://18337475623"

--//Runtime
local debounce 								= false

-----------------------------
local function GetNumber(number)
	local abbreviations 					= 
		{
			K 								= 4,
			M 								= 7,
			B 								= 10,
			Qa 								= 13,
		}

	
	local wantedText 						= tostring(math.floor(number))
	local choosenIndex

	for i, digits in pairs(abbreviations) 	do
		if #wantedText >= digits and #wantedText < (digits + 3) then
			choosenIndex 					= i
			break
		end
	end

	if choosenIndex 						then
		local digits 						= abbreviations[choosenIndex]
		local abbreviated 					= number / 10^(digits - 1)
		local formatted 					= math.floor(abbreviated) == abbreviated and tostring(abbreviated) or string.format("%.1f", abbreviated)
		return formatted .. choosenIndex
	else
		return wantedText
	end
end

-----------------------------
local function Damage(plr)
	local total								= plr.leaderstats.Energy.Value
	total									*= boostsModule.Damage(plr)
	
	return total
end

local function Gems(plr)
	local total								= (baseValue)
	total									*= boostsModule.Gems(plr)

	return total
end

local function CanMagnet(plrName)
	local plr								= players:FindFirstChild(plrName)
	
	local target							= gamepassesModule.GetThisGamepass("Magnet")
	local ownsPass							= plr and target and gamepassesModule.CheckGamePass(plr, target.Code) or false

	return ownsPass
end

-----------------------------
local function Collect(clone, plr, char)
	if not plr or not char					then return end

	local GemPart 							= gemPart:Clone()
	GemPart.BillboardGui.TextLabel.Text 	= "+"..short.en(baseValue)
	GemPart.Parent 							= char
	debris:AddItem(GemPart, 1)

	-- Random Place
	local RandomPlace 						= math.random(0,15)

	local PartNumber 						= 0
	for _, Part in char:GetChildren() 		do
		local isMeshPart					= Part:IsA("MeshPart")
		if not isMeshPart					then continue end

		PartNumber 							+= 1
		if PartNumber == RandomPlace 		then
			GemPart.Position 				= Part.Position
		end
	end

	plr.leaderstats.Gems.Value 				+= Gems(plr)

	clone:Destroy()
end

function DropGems(plrName, orgCFrame, object)
	local amount 							= math.random(3, 7)

	for i = 0, amount 						do
		local clone 						= object:Clone()
		clone.Name 							= "Drop "..i
		clone.CFrame 						= orgCFrame
		clone.Parent 						= dropFolder

		local randomX 						= {math.random(-10, -5), math.random(5, 10)}
		local randomZ 						= {math.random(-10, -5), math.random(5, 10)}

		local velocity 						= Vector3.new(randomX[math.random(1,2)], math.random(30,100), randomZ[math.random(1,2)])
		clone.AssemblyLinearVelocity 		= velocity
		
		if plrName and CanMagnet(plrName)	then
			local plr 						= players:FindFirstChild(plrName)
			Collect(clone, plr, plr.Character)
		end
		
		clone.Touched:Connect(function(hit)
			local char						= hit.Parent
			if not char						then return end

			local plr 						= players:GetPlayerFromCharacter(char)
			if not plr 						then return  end
			
			Collect(clone, plr, char)
		end)
	end
end

-----------------------------
function DropToken(plrName, orgCFrame, orgName)
	if not plrName or plrName == ""			then return end
	
	local target							= dataModule.Secret[orgName]
	if not target							then return end
	
	local plr								= players:FindFirstChild(plrName)
	if not plr								then return end
	
	local tokenData							= tokensModule.GetList()[target.Token.Name]
	if not tokenData						then return end
	
	local random							= math.random(1, 100)
	if random < target.Token.Percentage		then return end
	
	local exist								= plr["Tokens"]:FindFirstChild(target.Token.Name)
	if exist								then return end
	
	print("Drop Token")
	local clone								= tokenData.Model:Clone()
	clone.CFrame							= orgCFrame + Vector3.new(2, 0, 5)

	clone.Touched:Connect(function(hit)
		local char							= hit.Parent
		if not char 						then return end
		
		local otherPlr						= players:GetPlayerFromCharacter(char)
		if not otherPlr						then return end
		if otherPlr ~= plr 					then return end
		
		tokensModule.Add(plr, target.Token.Name)
		clone:Destroy()
	end)
	
	clone.Parent							= dropFolder
end

-----------------------------
local function SetupNPC(npc, parentName)
	local humanoid							= npc:FindFirstChild("Humanoid")
	if not humanoid							then return end

	local hrp								= npc:FindFirstChild("HumanoidRootPart")
	if not hrp								then return end
	
	local alive 							= true
	local orgCFrame							= npc.PrimaryPart.CFrame
	local orgName 							= npc.Name
	
	local billboardGUI						= npc:FindFirstChild("BillboardGui")
	
	if parentName == "R6"					then
		local animateScript					= script["Others"].Animate:Clone()
		animateScript.Parent				= npc
		animateScript.Enabled				= true	
	end
	
	local LastHit							= Instance.new("StringValue", humanoid)
	LastHit.Name 							= "LastHit"
	
	humanoid.BreakJointsOnDeath 			= false
	
	local loadedAnim_Death 					= humanoid:LoadAnimation(deathAnimation)
	
	local loadedAnim_Hit 					= humanoid:LoadAnimation(hitAnimation)
	local hitAnimObject						= Instance.new("ObjectValue", humanoid)
	hitAnimObject.Name 						= "HitAnimObject"
	hitAnimObject.Value						= loadedAnim_Hit

	humanoid.HealthChanged:Connect(function(Health)
		if Health >= 0 						then return end

		hrp.Anchored 						= true
		loadedAnim_Death:Play()
		loadedAnim_Death.Stopped:Connect(function()
			print("Animation finished!")
			alive							= false
			npc:Destroy()
		end)
		
		--[[
		task.delay(1, function()
			alive							= false
			npc:Destroy()
		end)
		]]
		
		DropGems(LastHit.Value, 	hrp.CFrame, gemDrop)
		DropToken(LastHit.Value, 	orgCFrame, 	orgName)

		task.delay(respawntime, function()
			local dummyclone 				= npcSources[parentName]:FindFirstChild(orgName):Clone()
			dummyclone:SetPrimaryPartCFrame(orgCFrame)
			npc:Destroy()
			
			dummyclone.Parent 				= npcsFolder
			SetupNPC(dummyclone, parentName)

		end)
	end)
	
	if not billboardGUI						then return end
	coroutine.wrap(function()
		while task.wait(0.1) 				do
			if not npc						then break end
			if not alive					then break end
			
			local gui						= billboardGUI:FindFirstChild("GUI")
			if not gui						then break end
			
			local healthBar					= gui["HealthGUI"].Healthbar
			local healthNum					= gui["HealthGUI"].HealthNum
			healthNum.Text 					= GetNumber(math.floor(humanoid.Health)) .. " / " ..GetNumber(math.floor(humanoid.MaxHealth))

			if humanoid.Health > 5000 		then
				healthBar.BackgroundColor3 	= Color3.new(0, 255, 0)

			elseif humanoid.Health <= 5000 	and humanoid.Health > 1000 then
				healthBar.BackgroundColor3 	= Color3.new(1, 0.647059, 0)

			elseif humanoid.Health <= 1000 	then
				healthBar.BackgroundColor3 	= Color3.new(255, 0, 0)

			end

			local pie 						= (humanoid.Health / humanoid.MaxHealth)
			healthBar.Size 					= UDim2.new(pie, 0, 1, 0)
		end
	end)()
end

-----------------------------
-- SETUP

for i, npc in pairs(npcsFolder["R6"]:GetChildren()) do
	local humanoid							= npc:FindFirstChild("Humanoid")
	if not humanoid							then continue end

	local hrp								= npc:FindFirstChild("HumanoidRootPart")
	if not hrp								then continue end
	
	SetupNPC(npc, "R6")
end

for i, npc in pairs(npcsFolder["R15"]:GetChildren()) do
	local humanoid							= npc:FindFirstChild("Humanoid")
	if not humanoid							then continue end

	local hrp								= npc:FindFirstChild("HumanoidRootPart")
	if not hrp								then continue end

	SetupNPC(npc, "R15")
end

-----------------------------
boxEvent.OnServerEvent:Connect(function(plr)
	if debounce								then return end
	
	local dmg								= Damage(plr)

	debounce 								=  true
	local humanoid 							= plr.Character.Humanoid
	local animtrack 						= humanoid:LoadAnimation(script["Others"].Animation)
	animtrack:Play()

	local hitbox 							= Instance.new("Part",game.Workspace)
	hitbox.Anchored 						= true
	hitbox.CanCollide 						= false
	hitbox.Transparency 					= 1
	hitbox.Size 							= Vector3.new(4, 6.4, 5.7)
	hitbox.CFrame 							= plr.Character.HumanoidRootPart.CFrame
	debrisService:AddItem(hitbox,.5)

	local hits 								= {}
	hitbox.Touched:Connect(function(hit)
		local char							= hit.Parent
		if not char							then return end

		local humanoid						= char:FindFirstChild("Humanoid")

		local isCorrect						= humanoid and char.Name ~= plr.Name
		if not isCorrect					then return end

		local isPet							= char.Humanoid:FindFirstChild(plr.Name)
		if isPet							then return end

		if hits[char.Name] 					then return end
		hits[char.Name] 					=  true
		
		plr.Damage.Value 					+= dmg
		local DamagePart 					= replicatedStorage.Parts.DamagePart:Clone()
		DamagePart.Parent 					= char

		local textLabel						= DamagePart.BillboardGui.TextLabel

		if dmg >= char.Humanoid.Health 		then
			textLabel.Text 					= "-"..short.en(char.Humanoid.Health)
		else
			textLabel.Text 					= "-"..short.en(dmg)
		end

		-- Random Place
		local RandomPlace 					= math.random(0,7)
		local PartNumber 					= 0

		for _, Part in char:GetChildren() 	do
			if not Part:IsA("Part") 		then continue end

			PartNumber 						+= 1
			if PartNumber == RandomPlace 	then
				DamagePart.Position 		= Part.Position
			end
		end

		local sound 						= script["Others"]["Punch"]:Clone()
		sound.Parent 						= humanoid
		sound:Play()

		debrisService:AddItem(sound,2)
		debrisService:AddItem(DamagePart,2)

		humanoid:TakeDamage(dmg)
		
		if humanoid.Health <= 0				then
			print("Added Stat")
			achievementsModule.AddStat(plr, "Enemies", 1)
		end
		
		local hitAnim						= humanoid:FindFirstChild("HitAnimObject")
		if hitAnim and hitAnim.Value		then
			hitAnim.Value:Play()
		end
		
		local LastHit						= humanoid:FindFirstChild("LastHit")
		if LastHit							then
			LastHit.Value 					= plr.Name
		end

		wait(1.5)
		hits[char.Name] 					= false
	end)

	wait(0.5)
	debounce  								= false
end)

-----------------------------
return module
