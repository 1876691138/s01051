local Players=game:GetService('Players')
local TempPart=script.Parent
--[[]]--
local SurfaceGui=TempPart.SurfaceGui
local MainFrame=SurfaceGui.Frame
--[[]]--
local Template=script['Template']
--[[]]--
local RecentlySaved={}
local DataStoreService=game:GetService('DataStoreService')
local GlobalLeaderboardB=DataStoreService:GetOrderedDataStore("energy")
if not game["Run Service"]:IsStudio() then
	GlobalLeaderboardB=DataStoreService:GetOrderedDataStore("energy")
end
--[[ SETTINGS ]]--
local CurrencyName="Energy"
local ListSize=100
local UpdateEvery=20
local MinimumRequirement=1
--[[]]--
local _functions={}
_functions.returncurrency = function(v)
	local x=0
	for a, b in pairs(v:GetDescendants()) do
		if (b:IsA("IntValue") or b:IsA("NumberValue")) and (b.Name==CurrencyName) then
			x=b.Value
			break
		end
	end
	return x
end
_functions.removefromrecentlysaved=function(PlayerName)
	for i, v in pairs(RecentlySaved) do 
		if v==PlayerName then
			table.remove(RecentlySaved,i)
			break
		end
	end
end
_functions.autoremoverecentsaved=function(PlayerName)
	spawn(function()
		wait(15)
		for i, v in pairs(RecentlySaved) do 
			if v==PlayerName then
				table.remove(RecentlySaved,i)
				break
			end
		end
	end)
end
_functions.returnplayerlist=function()
	local int = 0
	for i, v in pairs(Players:GetPlayers()) do 
		for _, j in pairs(v:GetDescendants()) do 
			if j.Name==CurrencyName and j:IsA("IntValue") then
				if j.Value>MinimumRequirement then
					int+=1
					break
				end

			end
		end
	end
	return int
end
_functions.clear=function()
	for i, v in pairs(MainFrame:GetChildren()) do 
		if v:IsA('Frame') then
			v:Destroy()
		end
	end
end
_functions.abbreviate=function(value,idp)
	if value < 1000 then
		return math.floor(value + 0.5)
	else
		local abbreviations = {"", "K", "M", "B", "T"}
		local ex = math.floor(math.log(math.max(1, math.abs(value)),1000))
		--[[]]--
		local abbrevs = abbreviations [1 + ex] or ("e+"..ex)
		local normal = math.floor(value * ((10 ^ idp) / (1000 ^ ex))) / (10 ^ idp)
		--[[]]--
		return ("%."..idp.."f%s"):format(normal, abbrevs)
	end
end
--[[]]--
Players.PlayerRemoving:Connect(function(Player)
	local PName=Player.Name
	if not table.find(RecentlySaved,Player.Name) then
		table.insert(RecentlySaved,Player.Name)
		local CurrentCurrencyAmount=_functions.returncurrency(Player)
		local Success,Errormsg=pcall(function()
			GlobalLeaderboardB:SetAsync(Player.UserId,CurrentCurrencyAmount)
		end)
		if not Success then warn(Errormsg) end
		_functions.removefromrecentlysaved(PName)
	else 
	end
end)
--[[]]--
while true do 
	_functions.clear()
	repeat wait() until _functions.returnplayerlist()>0
	for i, Player in pairs(Players:GetPlayers()) do 
		local PName=Player.Name
		if not table.find(RecentlySaved,Player.Name) then
			table.insert(RecentlySaved,Player.Name)
			local CurrentCurrencyAmount=_functions.returncurrency(Player)
			local Success,Errormsg=pcall(function()
				GlobalLeaderboardB:SetAsync(Player.UserId,CurrentCurrencyAmount)
			end)
			if not Success then warn(Errormsg) end
			_functions.autoremoverecentsaved(PName)
		end
	end
	local Pages = GlobalLeaderboardB:GetSortedAsync(false, ListSize)
	local TopList = Pages:GetCurrentPage()
	for Rank, SavedData in ipairs(TopList) do
		local UserId = SavedData.key
		local CAmount=SavedData.value
		--[[]]--
		if CAmount>=MinimumRequirement then
			local Template=script['Template']:Clone()
			Template.Parent=MainFrame
			Template.LayoutOrder=Rank
			Template.Frame.Score.Text="".._functions.abbreviate(CAmount,1)
			local function SetRankText(n)
				local A={}
				A[1]=function()
					Template.Frame.Rank.Text="🥇"
				end
				A[2]=function()
					Template.Frame.Rank.Text="🥈"
				end
				A[3]=function()
					Template.Frame.Rank.Text="🥉"
				end
				if n<=#A then
					A[n]()
				else Template.Frame.Rank.Text="#"..n
				end
			end
			SetRankText(Rank)
			--[[]]--
			local User="Unknown"
			local Success,Errormsg=pcall(function()
				User=Players:GetNameFromUserIdAsync(UserId)
			end)
			Template.Frame.Username.Text=User
			Template.Name=User
		end
	end
	task.wait(UpdateEvery)
end