wait()
local Humanoid = script.Parent.Humanoid
Humanoid.BreakJointsOnDeath = false
local DA = Instance.new("Animation")
DA.AnimationId = "rbxassetid://18337475623"
local DeathAnimation = Humanoid:LoadAnimation (DA)

Humanoid.HealthChanged:Connect(function(Health)
	if Health <= 0 then
		print("Died")
		script.Parent.HumanoidRootPart.Anchored = true
		DeathAnimation:Play()
	end
end)