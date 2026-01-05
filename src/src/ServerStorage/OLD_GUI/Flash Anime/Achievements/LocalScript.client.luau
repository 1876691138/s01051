local TouchPart = game.Workspace:WaitForChild("TouchPart") -- Change Part to whatever your part is called which a player will need to touch
local gui = script.Parent
TouchPart.Touched:Connect(function(hit)
	if hit.Parent:FindFirstChild("Humanoid") and hit.Parent == game.Players.LocalPlayer.Character then
		gui.Visible = true
		print("Gui opened")
	end
end)