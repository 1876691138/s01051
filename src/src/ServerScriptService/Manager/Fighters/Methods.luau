local module 							= {}

----------------------------------------
--//Services
local marketplaceService				= game:GetService("MarketplaceService")
local replicatedStorage					= game:GetService("ReplicatedStorage")
local runService						= game:GetService("RunService")

--//ModuleScripts
local dataModule						= require(script.Parent.Data)

--//References
local petsFolder						= game.Workspace["Scriptables"]["Pets"]

--//Settings
local walkAnimId 						= "http://www.roblox.com/asset/?id=180426354"
local idleAnimId 						= "http://www.roblox.com/asset/?id=180435571"

----------------------------------------
local function DestroyThisPet(plr, petRandomID)
	local char 							= plr.Character or plr.CharacterAdded:Wait()
	
	local plrPetsFolder					= petsFolder:FindFirstChild(plr.Name)
	if not plrPetsFolder				then
		plrPetsFolder					= Instance.new("Folder", petsFolder)
		plrPetsFolder.Name 				= plr.Name
	end
	
	local thisEquippedPet 				= plrPetsFolder:FindFirstChild(petRandomID)
	
	for i, child in pairs(char.Container:GetChildren()) do
		if child.Name ~= "mainContainer" and child.targetPet.Value == thisEquippedPet then 
			child.targetPet.Value		= nil
		end
	end

	if thisEquippedPet 					then
		thisEquippedPet:Destroy()
	end
end

local function LessThanID(a, b) 
	return a.ID.Value < b.ID.Value 
end

----------------------------------------
local function CreateAndLoadAnimation(animator, animId)
	local anim 							= Instance.new("Animation")
	anim.AnimationId 					= animId
	return animator:LoadAnimation(anim)
end

local function PlayAnimation(anim)
	if anim and not anim.IsPlaying then
		anim:Play()
	end
end

local function StopAnimation(anim)
	if anim and anim.IsPlaying then
		anim:Stop()
	end
end

local function SetupAnimations(clone)
	local humanoid 						= clone:FindFirstChildOfClass("Humanoid")
	if not humanoid 					then
		humanoid 						= Instance.new("Humanoid", clone)
	end

	local animator 						= humanoid:FindFirstChildOfClass("Animator")
	if not animator 					then
		animator 						= Instance.new("Animator", humanoid)
	end

	-- Load animations
	local walkAnim 						= CreateAndLoadAnimation(animator, walkAnimId)
	local idleAnim 						= CreateAndLoadAnimation(animator, idleAnimId)

	return walkAnim, idleAnim
end

-----------------------------------
function module.ToggleEquip(plr, shouldEquip, id, petRandomID)
	DestroyThisPet(plr, petRandomID)
	if not shouldEquip 					then return end
	
	local char 							= plr.Character or plr.CharacterAdded:Wait()
	
	local fighterData 					= dataModule.List[id]
	if not fighterData 					then return end
	
	local plrPetsFolder					= petsFolder:FindFirstChild(plr.Name)
	if not plrPetsFolder				then
		plrPetsFolder					= Instance.new("Folder", petsFolder)
		plrPetsFolder.Name 				= plr.Name
	end
	
	---------------
	local model 						= fighterData.Model
	if not model 						then return end

	local clone 						= model:Clone()
	
	for i, desc in pairs(clone:GetDescendants()) do
		if desc:IsA("BasePart") or desc:IsA("UnionOperation") then
			desc.CanCollide				= false
			desc.Anchored				= false
			desc.CollisionGroup			= "Fighter"
		end
	end
		
	local myTag 						= Instance.new("StringValue", clone.Humanoid)
	myTag.Name 							= plr.Name
	
	--local animScript 					= script.Parent.Others.Animate:Clone()
	--animScript.Parent 				= clone 
	--animScript.Enabled	 			= true

	---------------
	local posIndex 						= ""
	local containerTable 				= {}

	for i, child in pairs(char.Container:GetChildren()) do
		if child.Name ~= "mainContainer" then 
			table.insert(containerTable, child) 
		end
	end

	table.sort(containerTable, LessThanID)

	for i, child in pairs(containerTable) do
		if child.Name ~= "mainContainer" and child.targetPet.Value == nil then
			posIndex 					= child.Name
			break
		end
	end

	---------------
	local _goalPos 						= char.Container:FindFirstChild(posIndex)
	_goalPos.targetPet.Value 			= clone

	clone:SetPrimaryPartCFrame(_goalPos.CFrame)
	clone.Name 							= petRandomID
	clone.Parent 						= plrPetsFolder
	
	---------------
	local bodyPos 						= Instance.new("BodyPosition", clone.PrimaryPart)
	bodyPos.MaxForce 					= Vector3.new(math.huge, math.huge, math.huge)

	local bodyGyro 						= Instance.new("BodyGyro", clone.PrimaryPart)
	bodyGyro.MaxTorque 					= Vector3.new(math.huge, math.huge, math.huge)

	---------------
	local PetID 						= Instance.new("StringValue", clone)
	PetID.Name 							= "PetID"
	PetID.Value 						= id

	local selectedObject 				= Instance.new("ObjectValue", clone)
	selectedObject.Name 				= "SelectedObject"

	local isFollowingCoins 				= Instance.new("BoolValue", clone)
	isFollowingCoins.Name 				= "IsFollowingCoins"

	local isStanding 					= Instance.new("BoolValue", clone)
	isStanding.Name 					= "IsStanding"

	local ConnectedPart 				= Instance.new("ObjectValue", clone)
	ConnectedPart.Name 					= "ConnectedPart"

	---------------
	local wantedHeight 					= 1
	local wantedZDistance 				= 4
	local multiplier 					= 1

	local walkAnim, idleAnim 			= SetupAnimations(clone)
	local idleThreshold 				= 0.2 -- Time before switching to idle
	local movementThreshold 			= 0.1 -- Minimum distance to detect as movement
	local idleTimer 					= 0 -- Tracks time since last movement
	
	local function FollowPlayerActions()
		if isStanding.Value 			then
			StopAnimation(walkAnim)
			PlayAnimation(idleAnim)
			return
		end

		---------------
		if isFollowingCoins.Value 		then
			local wantedPos 			= ConnectedPart.Value
			bodyPos.Position 			= wantedPos.CFrame.Position
			bodyGyro.CFrame 			= wantedPos.CFrame
			isStanding.Value 			= true
			
			StopAnimation(walkAnim)
			PlayAnimation(idleAnim)
			
			return
		end

		---------------
		local prevPos 					= bodyPos.Position
		bodyPos.Position 				= _goalPos.CFrame.Position
		bodyGyro.CFrame 				= _goalPos.CFrame

		-- Check movement
		local movementDelta 			= (bodyPos.Position - prevPos).Magnitude
		if movementDelta > movementThreshold then
			-- Reset idle timer since the character is moving
			idleTimer 					= 0
			PlayAnimation(walkAnim)
			StopAnimation(idleAnim)
		else
			-- Increment idle timer
			idleTimer 					+= runService.Heartbeat:Wait()

			-- Switch to idle if enough time has passed
			if idleTimer >= idleThreshold then
				StopAnimation(walkAnim)
				PlayAnimation(idleAnim)
			end
		end
	end

	runService.Heartbeat:Connect(FollowPlayerActions)
end

-----------------------------------
return module
