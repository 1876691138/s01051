local player = game.Players.LocalPlayer

local mouse = player:GetMouse()

mouse.Button1Down:Connect(function()
	game.ReplicatedStorage.box:FireServer()
	game.ReplicatedStorage.Events.Client.Others.Click:FireServer()

end)
