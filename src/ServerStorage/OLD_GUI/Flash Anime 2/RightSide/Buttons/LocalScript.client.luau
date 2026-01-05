local OpenPos = UDim2.new(0.5,0,0.5,0)
local ClosedPos = UDim2.new(0.5,0,1.5,0)
local ogSize = game.StarterGui["Flash Anime"].Shop.Size
local newSize = UDim2.fromScale(ogSize.X.Scale/10, ogSize.Y.Scale/10)

local TS = game:GetService("TweenService")
local TI = TweenInfo.new(1, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut)

for _, ImageButton: ImageButton in script.Parent:GetChildren() do
	if ImageButton:IsA("ImageButton") then
		ImageButton.MouseButton1Click:Connect(function()
		
			local Menu:ImageLabel = script.Parent.Parent.Parent:FindFirstChild(ImageButton.Name)
			for i, v in Menu.Parent:GetChildren() do
				if v ~= Menu and v:IsA("ImageLabel") then
					TS:Create(v, TI, {Position = ClosedPos}):Play()
					TS:Create(v, TI, {Size = newSize}):Play()
				end
			end
			if Menu.Position == ClosedPos then
				Menu.Size = newSize
			end
			TS:Create(Menu, TI, {Position = OpenPos}):Play()
			TS:Create(Menu, TI, {Size = ogSize}):Play()
			local closeButton:ImageButton = Menu:FindFirstChild("Close")
			closeButton.MouseButton1Click:Connect(function()
				TS:Create(Menu, TI, {Position = ClosedPos}):Play()
				TS:Create(Menu, TI, {Size = newSize}):Play()
			end)
		end)
	end
end