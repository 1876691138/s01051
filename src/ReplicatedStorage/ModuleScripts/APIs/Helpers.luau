local module 					= {}

----------------------------------------
--//Services
local textService 				= game:GetService("TextService")
local playersService			= game:GetService("Players")

--//Tables
local badWords 					= 
	{
		"shit", "fuck", "fck", "fckk", "fuuck", "bitch", "ass", "pussy", "fag", "faggot", "whore", "slut", 
		"heaux", "shyt", "shytt", "btch","bich", "bish", "shxt", "bxcht", "whores", "sluts", "asshole", 
		"assholes", "dick", "penis", "bastard", "cunt", "cock", "motherfucker", "bitches", "twat", "prick", 
		"wanker", "douche", "douchebag", "arse", "arsehole","bollocks", "bugger", "crap", "damn", "hell", 
		"nigger", "nigga", "spic", "chink", "gook", "kike", "wetback","dyke", "coon", "jizz", "cum", "hoe", 
		"jerkoff", "jackass", "piss", "pissed", "scumbag", "shithead", "turd", "boob", "tit", "tits", "knob", 
		"knobhead", "tosser", "bollocks", "pussy", "twat", "bint", "clunge", "hoe", "cocksucker", "niga", "nigg"
	}

local replacementChar 			= "*"

----------------------------------------
function Format(Int)
	return string.format("%02i", Int)
end

function module.ConvertToHM(Seconds)
	local Minutes 				= (Seconds - Seconds %60) /60
	Seconds 					= Seconds - Minutes *60
	
	local Hours 				= (Minutes - Minutes %60) /60
	Minutes 					= Minutes - Hours *60
	return Format(Hours)..":"..Format(Minutes)
end

function  module.ConvertToMS(seconds)
	local minutes 				= math.floor(seconds / 60)
	local remainingSeconds 		= seconds % 60
	return string.format("%d Minutes, %d Seconds", minutes, remainingSeconds)
end

function module.ConvertToHMS(Seconds)
	local Minutes 				= math.floor(Seconds / 60)
	Seconds 					= Seconds % 60

	local Hours 				= math.floor(Minutes / 60)
	Minutes 					= Minutes % 60

	return Format(Hours) .. ":" .. Format(Minutes) .. ":" .. Format(Seconds)
end

----------------------------------------
function module.ConvertToDHM(seconds)
	local minutes 				= math.floor(seconds / 60)
	local hours 				= math.floor(minutes / 60)
	local days 					= math.floor(hours / 24)

	minutes 					= minutes % 60
	hours 						= hours % 24

	return days .. " days, " .. hours .. " hours, " .. minutes .. " mins"
end

----------------------------------------
function module.FilterString(plr, inputString)
	local filteredString 		= inputString

	for _, word in ipairs(badWords) do
		local pattern 			= word
		filteredString 			= filteredString:gsub(pattern, string.rep(replacementChar, #word))
	end

	return filteredString
end


----------------------------------------
function module.GetUserId(name)
	local id 					= nil

	local success, data 		= pcall(function()
		return playersService:GetUserIdFromNameAsync(name)
	end)

	if success then
		id 						= data
	end

	return id
end

function module.IsTextBoxEmptyOrSpaces(text)
	local trimmedText 			= text:match("^%s*(.-)%s*$")
	return trimmedText == ""
end

----------------------------------------
function module.SetupSearchBar(searchBar, itemsFrame, itemType)
	searchBar:GetPropertyChangedSignal("Text"):Connect(function()
		
		local function match_strings(string1, string2)
			local matches 				= 0
			for i = 1, #string1, 1 do
				if string.sub(string1, i, i) == string.sub(string2, i, i) then
					matches 			+= 1
				end
			end
			return matches == #string1
		end


		local function SortBySearch()
			for i, item in ipairs(itemsFrame:GetChildren()) do
				if item:IsA(itemType) 	then -- don't take into account hidden things
					if searchBar.Text == "" then
						item.Visible 	= true
						continue
					end

					local search_text 	= string.lower(searchBar.Text)
					local item_name 	= string.lower(item.Name)

					item.Visible 		= match_strings(search_text, item_name)

				end


			end
		end

		SortBySearch()
	end)

end

----------------------------------------
function module.FindPlrFromPartialName(plr, targetName)
	for i, otherPlr in pairs(playersService:GetPlayers()) do
		if string.lower(otherPlr.Name):sub(1, #targetName) == string.lower(targetName) then
			return otherPlr
		end
	end
	
	if string.lower(targetName) == "me" then
		return plr
	end
end

----------------------------------------
function module.AbbreviateNumber(value)
	local abbreviations = {
		{threshold = 1e12, suffix = "T"},
		{threshold = 1e9, suffix = "B"},
		{threshold = 1e6, suffix = "M"},
		{threshold = 1e3, suffix = "K"},
	}

	for _, abbrev in ipairs(abbreviations) do
		if value >= abbrev.threshold then
			local short = value / abbrev.threshold
			if short % 1 == 0 then
				return string.format("%d%s", short, abbrev.suffix)
			else
				return string.format("%.1f%s", short, abbrev.suffix)
			end
		end
	end

	return tostring(value)
end

----------------------------------------
return module
