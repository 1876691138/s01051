local module 							= {}

-----------------------------
--//Services
local replicatedStorage					= game:GetService("ReplicatedStorage")
local players							= game:GetService("Players")
local dataStoreService 					= game:GetService("DataStoreService")

--//References
local scriptables						= game.Workspace["Scriptables"]
local area0								= scriptables["Area0"]
local boardsFolder						= area0["Leaderboards"]

--//Modules
local helperModule						= require(replicatedStorage["ModuleScripts"]["APIs"]["Helpers"])

--//Settings
local maxItems	 						= 100
local minValueDisplay 					= 1
local maxValueDisplay 					= 10e15
local abbreviateValue 					= true
local updateEvery 						= 60 

local ABBREVIATIONS 					= { "K", "M", "B", "T" }
local COLORS 							= 
	{
		Default 						= Color3.fromRGB(58, 42, 229),
		Gold 							= Color3.fromRGB(255, 215, 0),
		Silver 							= Color3.fromRGB(249, 242, 36),
		Bronze 							= Color3.fromRGB(255, 255, 57)
	}
-----------------------------
local function toHumanReadableNumber(num)
	if num < 1000 						then
		return tostring(num)
	end

	local digits 						= math.floor(math.log10(num)) + 1
	local index 						= math.min(#ABBREVIATIONS, math.floor((digits - 1) / 3))
	local front 						= num / math.pow(10, index * 3)

	return string.format("%i%s+", front, ABBREVIATIONS[index])
end

local function GetItems(thisDataStore, board, statsName)
	local data 							= thisDataStore:GetSortedAsync(false, maxItems, minValueDisplay, maxValueDisplay)
	local topPage 						= data:GetCurrentPage()

	local Contents 						= board["Screen"]["SurfaceGui"]["Frame"]
	local Template 						= script["Template"]

	for position, v in ipairs(topPage) do
		local userId 					= v.key
		local value 					= v.value
		local username 					= "Unknown"
		local ICON
		local color 					= COLORS.Default

		local success, err 				= pcall(function()
			username 					= players:GetNameFromUserIdAsync(userId)

		end)

		if position == 1 				then
			color 						= COLORS.Gold

		elseif position == 2 			then
			color 						= COLORS.Silver

		elseif position == 3 			then
			color 						= COLORS.Bronze
		end

		local item 						= Template:Clone()
		--item["Icon"].Image				= "https://www.roblox.com/bust-thumbnail/image?userId=".. userId .."&width=420&height=420&format=png"
		item["Rank"].Text				= position
		item["Title"].Text				= username
		
		local score						= nil

		if statsName == "Playtime" 		then
			score						= helperModule.ConvertToDHM(value)
		else
			score						= abbreviateValue and toHumanReadableNumber(value) or value	
		end
		
		item["Score"].Text				= score

		item.Name 						= username
		item.LayoutOrder 				= position
		item.Parent 					= Contents
	end
end

-----------------------------
local function SetupBoard(statsName, board)
	local thisDataStore 				= dataStoreService:GetOrderedDataStore("GlobalLeaderboard_" .. statsName)
	local Contents 						= board["Screen"]["SurfaceGui"]["Frame"]

	coroutine.wrap(function()
		while wait() 					do
			for _, plr in pairs(players:GetPlayers()) do
				local leaderstats 		= plr:FindFirstChild("leaderstats")
				local otherStats		= plr:WaitForChild("Others"):WaitForChild("Stats")
				
				local statsValue 		= leaderstats and leaderstats:FindFirstChild(statsName) or plr:FindFirstChild(statsName) or otherStats:FindFirstChild(statsName)

				if not statsValue 		then
					warn("Couldn't find " .. statsName .. " stat in plr!")
					break
				end

				pcall(function()
					thisDataStore:UpdateAsync(plr.UserId, function()
						return tonumber(statsValue.Value)
					end)
				end)
			end

			for _, item in pairs(Contents:GetChildren()) do
				local isCorrect			= item:IsA("Frame")
				if not isCorrect		then continue end
				
				item:Destroy()
			end

			GetItems(thisDataStore, board, statsName)

			wait(updateEvery)
		end
	end)()
end

-----------------------------
task.delay(3, function()
	for i, child in pairs(boardsFolder:GetChildren()) do
		local statName					= child:FindFirstChild("StatName")
		if not statName					then continue end

		SetupBoard(statName.Value, child)
	end
end)

-----------------------------
return module
