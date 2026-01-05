local model = script.Parent

local rotationAngle = 0.25 -- Adjust the rotation angle as desired (in degrees)
local maxRotation = 10 -- Maximum rotation angle
local minRotation = 0 -- Minimum rotation angle

local rotationDirection = 1 -- 1 for clockwise, -1 for counter-clockwise
local currentRotation = 0

while true do
	currentRotation = currentRotation + rotationAngle * rotationDirection
	if currentRotation >= maxRotation or currentRotation <= minRotation then
		rotationDirection = -rotationDirection
	end

	local rotation = CFrame.Angles(-math.rad(rotationAngle) * rotationDirection,0,0)
	local modelCFrame = model:GetPivot()
	model:PivotTo(modelCFrame * rotation)

	wait()
end