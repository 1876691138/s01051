local Mouse = game.Players.LocalPlayer:GetMouse()
local CircleClick = require(game.ReplicatedStorage:WaitForChild("CircleClick")) 

script.Parent.MouseButton1Down:connect(function()
	CircleClick(script.Parent, Mouse.X, Mouse.Y) 
end)


