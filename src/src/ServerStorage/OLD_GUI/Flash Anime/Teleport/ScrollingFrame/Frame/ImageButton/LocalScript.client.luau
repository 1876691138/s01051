wait(1)
player = game.Players.LocalPlayer
button = script.Parent

local debounce = false

function teleport()
	if not debounce then
		debounce = true
		local lowerTorso = player.Character.LowerTorso
		lowerTorso.CFrame = game.Workspace.PlaceArea1.CFrame
		
		wait(1)
		debounce = false
	end
end

button.MouseButton1Click:Connect(teleport)