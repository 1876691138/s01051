local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local MaxJumps = 2
local JumpCooldown = 0.2

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid: Humanoid = Character:WaitForChild("Humanoid")

local NumberOfJumpsInARow = 0
local CanPlayerJump = false

Humanoid.StateChanged:Connect(function(oldState, newState)
	if Enum.HumanoidStateType.Landed == newState then
		NumberOfJumpsInARow = 0
		CanPlayerJump = false
	elseif Enum.HumanoidStateType.Freefall == newState then
		task.wait(JumpCooldown)
		CanPlayerJump = true
	elseif Enum.HumanoidStateType.Jumping == newState then
		if NumberOfJumpsInARow == 0 then
			Humanoid:LoadAnimation(script.Jump):Play()
		end
		NumberOfJumpsInARow += 1
		CanPlayerJump = false
		Workspace.Jump:Play()
	end
end)

UserInputService.JumpRequest:Connect(function()
	
	if CanPlayerJump and NumberOfJumpsInARow < MaxJumps then
		Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		Humanoid:LoadAnimation(script["Double Jump"]):Play()
	end
	
end)