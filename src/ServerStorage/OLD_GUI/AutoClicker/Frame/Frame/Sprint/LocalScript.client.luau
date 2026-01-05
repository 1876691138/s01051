local player = game.Players.LocalPlayer
local character = player.Character
local humanoid: Humanoid = character:WaitForChild("Humanoid")

local Sprinting = false

script.Parent.MouseButton1Click:Connect(function()
	if Sprinting == false then
		Sprinting = true
		humanoid.WalkSpeed = 28
	elseif Sprinting == true then
		Sprinting = false
		humanoid.WalkSpeed = 16
	end
end)