local module 							= {}

-----------------------------
--//Services
local replicatedStorage					= game:GetService("ReplicatedStorage")
local playersService					= game:GetService("Players")
local debrisService						= game:GetService("Debris")
local tweenService						= game:GetService("TweenService")

--//Local
local localPlayer						= playersService.LocalPlayer

-----------------------------
function module.SetupBtnAnimations(btn, xValue, yValue)
	local orgSize						= btn.Size
	local HoverSize 					= UDim2.new(orgSize.X.Scale * xValue, 0, orgSize.Y.Scale * yValue, 0)
	
	btn.MouseEnter:Connect(function()
		btn:TweenSize(HoverSize, "Out", "Sine", 0.2, true)
	end)
	
	btn.MouseLeave:Connect(function()
		btn:TweenSize(orgSize, "Out", "Sine", 0.2, true)
	end)
end

-----------------------------
function module.SetupFrame(frame)
	if not frame 						then return end

	local org_X							= Instance.new("NumberValue", frame)
	org_X.Name							= "XOrg"
	org_X.Value							= frame.Size.X.Scale

	local org_Y							= Instance.new("NumberValue", frame)
	org_Y.Name							= "YOrg"
	org_Y.Value							= frame.Size.Y.Scale

	frame.Size							= UDim2.new(0, 0, 0, 0)
end

function module.Open(frame)
	if not frame 						then return end
	
	local org_X							= frame:FindFirstChild("XOrg")
	if not org_X						then return end

	local org_Y							= frame:FindFirstChild("YOrg")
	if not org_Y						then return end

	frame.Visible						= true
	frame:TweenSize(UDim2.new(org_X.Value, 0, org_Y.Value, 0), "Out", "Sine", 0.15, true)
end

function module.Close(frame)
	if not frame 						then return end
	frame:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Sine", 0.15, true)

	wait(0.15)
	frame.Visible						= false
end

function module.CloseAndDestroy(frame)
	if not frame 						then return end
	frame:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Sine", 0.15, true)
	debrisService:AddItem(frame, 0.15)
end

function module.CloseAndDestroyAfterTime(frame, duration)
	if not frame 						then return end
	
	task.spawn(function()
		wait(duration)
		
		if not frame.Parent				then return end
		frame:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Sine", 0.15, true)
		debrisService:AddItem(frame, 0.25)
	end)
end

-----------------------------
return module


