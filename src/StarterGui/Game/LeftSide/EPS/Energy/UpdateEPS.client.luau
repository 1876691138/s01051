--//Services
local replicatedStorage 		= game:GetService("ReplicatedStorage")
local players 					= game:GetService("Players")

--//LocalPlr
local player			 		= players.LocalPlayer
local leaderstats 				= player:WaitForChild("leaderstats")
local energyStat 				= leaderstats:WaitForChild("Energy")

--//ModuleScripts
local short 					= require(replicatedStorage.ModuleScripts.APIs.Short)

---------------------------------
script.Parent.Text 				= 0
wait(1)

while true do
	local oldEnergy 			= energyStat.Value
	wait(1)
	local newEnergy		 		= energyStat.Value
	script.Parent.Text 			= short.en(newEnergy - oldEnergy)
end

---------------------------------