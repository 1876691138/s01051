for _, ImageButton in script.Parent:GetDescendants() do
	if ImageButton:IsA("ImageButton") and ImageButton.Name == "Close" then
		ImageButton.MouseButton1Click:Connect(function()
			ImageButton.Parent.Visible = false
		end)
	end
end