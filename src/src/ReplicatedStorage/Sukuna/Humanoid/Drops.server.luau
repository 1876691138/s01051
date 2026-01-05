local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DropModule = require(ReplicatedStorage.DropsModule)
local DropsFolder = ReplicatedStorage.DropsFolder
local GemDrop = DropsFolder.GemDrop

local OriginCframe = script.Parent.Parent.HumanoidRootPart.CFrame

script.Parent.Died:Connect(function()
	DropModule.DropCurrency(OriginCframe,GemDrop)
end)