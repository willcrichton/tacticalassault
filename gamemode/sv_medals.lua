MEDALS = {}
MEDALS.List  = {}

function MEDALS:Register(name,tex,winner,winval)
	if self.List[name] then return end
	self.List[name] = {tex=tex,winner=winner or nil,winval=winval or nil,people={}}
end

function MEDALS:GetWinner(name) return self.List[name].winner,self.List[name].winval end

function MEDALS:Check()
	for _,v in pairs(self.List) do
		local winner,max = nil,0
		for _,p in pairs(v.people) do
			if p[2] > max then
				winner = p[1]
				max = p[2]
			end
		end
		v.winner = winner
		v.winval = max
	end
end

function MEDALS:UpdatePlayer(name,pl,val,inc)
	local medal = self.List[name]
	if not medal then return end
	local num = 0
	if inc then num = medal.people[pl:SteamID()] + val
	else num = val end
	medal.people[pl:SteamID()] = {pl,num}
end

function MEDALS:GetAll() return self.List end


MEDALS:Register("Most Kills","")
MEDALS:Register("Most Deaths","")
hook.Add("PlayerDeath","MedalCheck-Kills",function(vic,inflict,killer)
	MEDALS:UpdatePlayer("Most Kills",killer,1,true)
	MEDALS:UpdatePlayer("Most Deaths",vic,1,true)
end)
