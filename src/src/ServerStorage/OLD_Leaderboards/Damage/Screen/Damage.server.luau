--//Services
local Players						= game:GetService('Players')
local DataStoreService				= game:GetService('DataStoreService')

--//References
local TempPart						= script.Parent
local SurfaceGui					= TempPart.SurfaceGui
local MainFrame						= SurfaceGui.Frame
local Template						= script['Template']

--//Settings
local saveID						= "damage"
local CurrencyName					= "Damage"
local ListSize						= 100
local UpdateEvery					= 20
local MinimumRequirement			= 1

--//RuntimeValues
local RecentlySaved					= {}

local GlobalLeaderboardB			= DataStoreService:GetOrderedDataStore(saveID)

------------------------------------
if not game["Run Service"]:IsStudio() then
	GlobalLeaderboardB				= DataStoreService:GetOrderedDataStore(saveID)
end

------------------------------------
local _functions					= {}

_functions.returncurrency 			= function(v)
	local x							= 0
	for a, b in pairs(v:GetDescendants()) do
		if (b:IsA("IntValue") or b:IsA("NumberValue")) and (b.Name==CurrencyName) then
			x=b.Value
			break
		end
	end
	
	return x
end

_functions.removefromrecentlysaved	= function(PlayerName)
	for i, v in pairs(RecentlySaved) do 
		if v==PlayerName 			then
			table.remove(RecentlySaved,i)
			break
		end
	end
end

_functions.autoremoverecentsaved	= function(PlayerName)
	spawn(function()
		wait(15)
		
		for i, v in pairs(RecentlySaved) do 
			if v==PlayerName 		then
				table.remove(RecentlySaved,i)
				break
			end
		end
	end)
end

_functions.returnplayerlist			= function()
	local int 						= 0
	
	for i, v in pairs(Players:GetPlayers()) do 
		for _, j in pairs(v:GetDescendants()) do 
			if j.Name==CurrencyName and j:IsA("IntValue") then
				if j.Value>MinimumRequirement then
					int				+= 1
					break
				end

			end
		end
	end
	
	return int
end

_functions.clear					= function()
	for i, v in pairs(MainFrame:GetChildren()) do 
		if v:IsA('Frame') 			then
			v:Destroy()
		end
	end
end

_functions.abbreviate				= function(value,idp)
	if value < 1000 				then
		return math.floor(value + 0.5)
	else
		local abbreviations 		= {"", "K", "M", "B", "T"}
		local ex 					= math.floor(math.log(math.max(1, math.abs(value)),1000))
		
		local abbrevs 				= abbreviations [1 + ex] or ("e+"..ex)
		local normal 				= math.floor(value * ((10 ^ idp) / (1000 ^ ex))) / (10 ^ idp)
		
		return ("%."..idp.."f%s"):format(normal, abbrevs)
	end
end

------------------------------------
Players.PlayerRemoving:Connect(function(Player)
	local PName						= Player.Name
	
	if not table.find(RecentlySaved,Player.Name) then
		table.insert(RecentlySaved,Player.Name)

		local CurrentCurrencyAmount	=_functions.returncurrency(Player)
		local Success,Errormsg		= pcall(function()
			GlobalLeaderboardB:SetAsync(Player.UserId,CurrentCurrencyAmount)
		end)

		if not Success 				then warn(Errormsg) end
		_functions.removefromrecentlysaved(PName)
	end
end)

------------------------------------
while true do 
	_functions.clear()
	repeat wait() 					until _functions.returnplayerlist() > 0
	
	for i, Player in pairs(Players:GetPlayers()) do 
		local PName					= Player.Name
		
		if not table.find(RecentlySaved,Player.Name) then
			table.insert(RecentlySaved,Player.Name)
			
			local CurrentCurrencyAmount	=_functions.returncurrency(Player)
			
			local Success,Errormsg		= pcall(function()
				GlobalLeaderboardB:SetAsync(Player.UserId,CurrentCurrencyAmount)
			end)
			
			if not Success 			then warn(Errormsg) end
			_functions.autoremoverecentsaved(PName)
		end
	end
	
	local Pages 					= GlobalLeaderboardB:GetSortedAsync(false, ListSize)
	local TopList 					= Pages:GetCurrentPage()
	
	for Rank, SavedData in ipairs(TopList) do
		local UserId 				= SavedData.key
		local CAmount				= SavedData.value
		
		local passed				= CAmount >= MinimumRequirement
		print(passed)
		if not passed				then continue end
		
		local Template				= script['Template']:Clone()
		Template.Parent				= MainFrame
		Template.LayoutOrder		= Rank
		Template.Frame.Score.Text	= "".._functions.abbreviate(CAmount,1)
		
		local rankText				= Template.Frame.Rank
		
		local function SetRankText(n)
			local A					= {}
			
			A[1]					= function()
				rankText.Text		="🥇"
			end
			
			A[2]					=function()
				rankText.Text		="🥈"
			end
			
			A[3]					=function()
				rankText.Text		="🥉"
			end
			
			if n<=#A 				then
				A[n]()
			else 
				rankText.Text		="#"..n
			end
		end
		
		SetRankText(Rank)

		local User					= "Unknown"
		local Success,Errormsg		= pcall(function()
			User=Players:GetNameFromUserIdAsync(UserId)
		end)
		
		local usernameText			= Template.Frame.Username
		usernameText.Text			= User
		Template.Name				= User
	end
	
	task.wait(UpdateEvery)
end

------------------------------------