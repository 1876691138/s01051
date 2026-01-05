local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Camera = Workspace.CurrentCamera

local module = {}

local Eggs = ReplicatedStorage.Eggs
local Pets = require(ReplicatedStorage.PetsModule)

local Pet
local PetClone

function module.HatchOne(RandomNumber, egg: Part, Player: Player)
	local PetsFolder = Player.PetsFolder
	local MaxPets = Player.MaxPets

	if #PetsFolder:GetChildren() < MaxPets.Value then
		Camera.CameraType = Enum.CameraType.Scriptable
		TweenService:Create(Camera, TweenInfo.new(0.5,Enum.EasingStyle.Sine,Enum.EasingDirection.Out, 0, false, 0), {CFrame = egg:FindFirstChild("Camera Part").CFrame}):Play()

		if egg.Name == "ShibuyaJitsu" then
			local EggClone = egg:Clone()
			EggClone.Anchored = true
			EggClone.CanCollide = false

			hatchOneConnection = RunService.RenderStepped:Connect(function()
				local CF = CFrame.new(0,0,-EggClone.Size.Z * 2) * CFrame.Angles(0,0,math.sin(time() * 18) / 2.3)
				EggClone.CFrame = Camera.CFrame * CF
			end)

			EggClone.Parent = Camera


			if RandomNumber >= 41.1 then
				for _, pet in Pets do
					if pet[1] == "Nobara" then
						Pet = pet
					end
				end

				task.wait(2)
				hatchOneConnection:Disconnect()
				EggClone:Destroy()

				PetClone = Eggs.ShibuyaJitsu.Nobara:Clone()
				PetClone.HumanoidRootPart.Anchored = true
				PetClone.Parent = Camera

				PetDisplay = RunService.RenderStepped:Connect(function()
					local CF = CFrame.new(0,0,-EggClone.Size.Z * 2) * CFrame.Angles(0,135,0)
					PetClone:SetPrimaryPartCFrame(Camera.CFrame * CF)
				end)
			elseif RandomNumber >= 16.1 and RandomNumber < 41.1 then
				for _, pet in Pets do
					if pet[1] == "Fushiguro" then
						Pet = pet
					end
				end

				task.wait(2)
				hatchOneConnection:Disconnect()
				EggClone:Destroy()

				PetClone = Eggs.ShibuyaJitsu.Fushiguro:Clone()
				PetClone.HumanoidRootPart.Anchored = true
				PetClone.Parent = Camera

				PetDisplay = RunService.RenderStepped:Connect(function()
					local CF = CFrame.new(0,0,-EggClone.Size.Z * 2) * CFrame.Angles(0,135,0)
					PetClone:SetPrimaryPartCFrame(Camera.CFrame * CF)
				end)
			elseif RandomNumber >= 1.1 and RandomNumber < 16.1 then
				for _, pet in Pets do
					if pet[1] == "Yuji" then
						Pet = pet
					end
				end

				task.wait(2)
				hatchOneConnection:Disconnect()
				EggClone:Destroy()

				PetClone = Eggs.ShibuyaJitsu.Yuji:Clone()
				PetClone.HumanoidRootPart.Anchored = true
				PetClone.Parent = Camera

				PetDisplay = RunService.RenderStepped:Connect(function()
					local CF = CFrame.new(0,0,-EggClone.Size.Z * 2) * CFrame.Angles(0,135,0)
					PetClone:SetPrimaryPartCFrame(Camera.CFrame * CF)
				end)
			elseif RandomNumber >= 0.011 and RandomNumber < 1.1 then
				for _, pet in Pets do
					if pet[1] == "Geto" then
						Pet = pet
					end
				end

				task.wait(2)
				hatchOneConnection:Disconnect()
				EggClone:Destroy()

				PetClone = Eggs.ShibuyaJitsu.Geto:Clone()
				PetClone.HumanoidRootPart.Anchored = true
				PetClone.Parent = Camera

				PetDisplay = RunService.RenderStepped:Connect(function()
					local CF = CFrame.new(0,0,-EggClone.Size.Z * 2) * CFrame.Angles(0,135,0)
					PetClone:SetPrimaryPartCFrame(Camera.CFrame * CF)
				end)
			elseif RandomNumber >= 0.01 and RandomNumber < 0.011 then
				for _, pet in Pets do
					if pet[1] == "Goje" then
						Pet = pet
					end
				end

				task.wait(2)
				hatchOneConnection:Disconnect()
				EggClone:Destroy()

				PetClone = Eggs.ShibuyaJitsu.Goje:Clone()
				PetClone.HumanoidRootPart.Anchored = true
				PetClone.Parent = Camera

				PetDisplay = RunService.RenderStepped:Connect(function()
					local CF = CFrame.new(0,0,-EggClone.Size.Z * 2) * CFrame.Angles(0,135,0)
					PetClone:SetPrimaryPartCFrame(Camera.CFrame * CF)
				end)
			elseif RandomNumber < 0.01 then
				for _, pet in Pets do
					if pet[1] == "Goje" then
						Pet = pet
					end
				end
			end

			for _, pet in Eggs.ShibuyaJitsu:GetChildren() do
				if pet.Name == Pet[1] then
					local Clone = pet:Clone()
					Clone.Parent = PetsFolder
				end
			end

			task.wait(2)
			hatchOneConnection:Disconnect()
			EggClone:Destroy()
			PetDisplay:Disconnect()
			PetClone:Destroy()
			Camera.CameraType = Enum.CameraType.Custom
		end
	end
end

return module