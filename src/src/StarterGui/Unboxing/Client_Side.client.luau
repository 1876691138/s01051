local RS = game:GetService("ReplicatedStorage")
local TS = game:GetService("TweenService")

local E = RS:WaitForChild("Events")
local DB = require(RS:WaitForChild("Data_Module"))

local Template = script:WaitForChild("Template")
local UI = script.Parent:WaitForChild("Unboxing_Main")

local function launch(case, picked, dataInfo, auto)
	UI.UIScale.Scale = 1

	local t1, t2 = 5, 10
	local s1, s2 = 25, 50

	local slots = math.random(s1, s2)
	local duration = math.random(t1, t2)

	local winIndex = math.random(20, slots - 5)
	local winRef

	local holder = UI.Holder.Item
	holder.Size = UDim2.new(0, slots * holder.AbsoluteSize.Y, 1, 0)
	holder.Position = UDim2.new(0, 0, 0, 0)
	holder:ClearAllChildren()

	local list = {}
	local caseInfo = DB.Items[case]

	for n in pairs(caseInfo) do
		list[#list + 1] = n
	end

	for i = 1, slots do
		local slot = Template:Clone()
		local chosen

		if i == winIndex then
			chosen = picked
			winRef = slot
		else
			chosen = list[math.random(1, #list)]
		end

		local data = caseInfo[chosen]
		slot.Content.TextLabel.Text = chosen
		slot.Content.TextLabel.TextColor3 = DB.Rarities[data.Rarity]
		slot.Content.Image = data.Image

		local w = holder.AbsoluteSize.X / slots
		slot.Size = UDim2.new(0, w, 1, 0)
		slot.Position = UDim2.new(0, w * (i - 1), 0, 0)
		slot.Parent = holder
	end

	local wobble = math.random(-winRef.AbsoluteSize.X/2, winRef.AbsoluteSize.X/2)
	local dist = (winRef.AbsolutePosition.X + winRef.AbsoluteSize.X/2) - UI.Center.AbsolutePosition.X

	holder:TweenPosition(
		UDim2.new(0, -dist + wobble, 0, 0),
		"InOut",
		"Quint",
		duration
	)

	local beep = script.Parent:WaitForChild("Tick")
	local group = holder:GetChildren()
	local mid = UI.Center.AbsolutePosition.X
	local flagged = {}
	for _, g in ipairs(group) do
		flagged[g] = false
	end

	local spinning = true

	task.spawn(function()
		while spinning do
			for _, g in ipairs(group) do
				if not flagged[g] then
					if g.AbsolutePosition.X <= mid then
						flagged[g] = true
						beep:Play()
					end
				end
			end
			task.wait(0.01)
		end
	end)

	task.wait(duration)
	spinning = false

	UI.UIScale.Scale = 0
	script.Parent:WaitForChild("Unboxed"):Play()

	if not auto then
		task.wait(1)
		E.Client.Others.SpinCooldown:FireServer()
	end
end

E.Client.Others.Unbox.Event:Connect(function(a, b, c, d)
	launch(a, b, c, d)
end)
