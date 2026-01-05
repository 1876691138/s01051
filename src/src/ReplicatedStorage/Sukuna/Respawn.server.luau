local dummy = script.Parent
local dummyclone = dummy:Clone()
local dummyhumanoid = dummy.Humanoid

dummyclone.Parent = game.ReplicatedStorage

local respawntime = 3

local function died()
	wait(respawntime)
	dummyclone.Parent = script.Parent.Parent
	dummy:Destroy()
end

dummyhumanoid.Died:Connect(died)