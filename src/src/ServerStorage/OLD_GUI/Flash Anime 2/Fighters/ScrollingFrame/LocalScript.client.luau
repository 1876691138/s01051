game:GetService("RunService").Render:Connect(function()
	script.Parent.CanvasSize = UDim(0,0,0,script.Parent.ScrollingFrame.AbsoluteContentSize)
end)