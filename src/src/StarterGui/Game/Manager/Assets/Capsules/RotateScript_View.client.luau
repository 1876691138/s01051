
local model = script.Parent

local rotationAngle = 5 -- Adjust the rotation angle as desired (in degrees)

while true do
	local rotation = CFrame.Angles(0, math.rad(rotationAngle), 0)
	local modelCFrame = model:GetPivot()
	model:PivotTo(modelCFrame * rotation)

	wait()
end