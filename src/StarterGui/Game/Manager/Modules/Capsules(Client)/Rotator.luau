local module 							= {}

----------------------------
--//Services
local tweenService 						= game:GetService("TweenService")
local debrisService 					= game:GetService("Debris")
local plrs 								= game:GetService("Players")

--//LocalPlr
local plr 								= plrs.LocalPlayer

--//Values
module.Duration							= 5

--//Infos


-------------------------------------------
function module.RotateThis(sample, isFast)
	local rot_Dur						= 0.5
	local size_Dur						= 1.5
	
	if isFast							then
		rot_Dur							= 0.25
		size_Dur						= 0.75
	end
	
	local tweenInfo_Rot 				= TweenInfo.new(rot_Dur, Enum.EasingStyle.Linear)
	local tweenInfo_Size 				= TweenInfo.new(size_Dur, Enum.EasingStyle.Linear)
	
	local originalRotation 				= sample.Icon.Rotation
	local rotationGoal_1 				= originalRotation - 30
	local rotationGoal_2 				= originalRotation + 30

	local originalSize 					= sample.Icon.Size
	local sizeGoal 						= UDim2.new(originalSize.X.Scale * 0.3, originalSize.X.Offset, originalSize.Y.Scale * 0.3, originalSize.Y.Offset)
	
	local tween1 						= tweenService:Create(sample.Icon, tweenInfo_Rot, {Rotation = rotationGoal_1})
	local tween2 						= tweenService:Create(sample.Icon, tweenInfo_Rot, {Rotation = rotationGoal_2})
	local tween3 						= tweenService:Create(sample.Icon, tweenInfo_Rot, {Rotation = originalRotation})

	local tween_Size 					= tweenService:Create(sample.Icon, tweenInfo_Size, {Size  = sizeGoal})
	
	for i = 1, 0, -1 					do
		tween1:Play()
		tween1.Completed:Wait()
		
		tween2:Play()
		tween2.Completed:Wait()
	end

	tween3:Play()
	tween3.Completed:Wait()

	tween_Size:Play()
	tween_Size.Completed:Wait()
	
	sample:Destroy()
end

----------------------------
return module
