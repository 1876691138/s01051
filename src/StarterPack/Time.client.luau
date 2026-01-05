wait(1)

local event = game.ReplicatedStorage.TimePlayed

while true do
	wait(60)
	event:FireServer()
end