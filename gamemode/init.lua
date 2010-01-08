AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_ambience.lua" )
AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "cl_vgui.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "util.lua" )

include( "player.lua" )
include( "shared.lua" )
include( "data.lua")
include( "util.lua")
include( "sv_general.lua" )
include( "sv_techie.lua" )

ta.AddFilesRecursive("sound/ta","")
ta.AddFilesRecursive("materials/ta","")
resource.AddFile("models/weapons/w_binoculars.mdl")
resource.AddFile("models/weapons/v_binoculars.mdl")
resource.AddFile("resource/fonts/Army.ttf")

SetGlobalString("ta_ambience","battle")
SetGlobalString("ta_mode","capture") -- other options: bomb

// Load a player's points
function GM:PlayerDisconnected(pl)
	if CurTime() - pl:GetNWInt("StartTime") > 300 then DB.AddPlay(pl) end
	DB.Save()
end

// GIve people play points and talk about maps
hook.Add("EndOfGame","AddPlays",function() 
	for _,v in ipairs(player.GetAll()) do 
		DB.AddPlay(v) 
	end 
	DB.Save() 
	
end)

// Set start time for later reference by disconnect and play points
function GM:PlayerAuthed(pl)
	pl:SetNWInt("StartTime",CurTime())
end

hook.Add("PlayerDeath","SavePoints",function(vic,inf,killer)
	
	// Add the points
	if !killer:IsPlayer() then return end

	local pts = (DB.GetPoints(vic) + vic:Frags())/1000
	
	if pts >= 1 then killer:AddFrags(math.floor(pts)) end
	
	DB.SetPoints(killer,killer:Frags())
	
	// Calculate killstreaks
	vic:SetNWInt("Killstreak",0)
	local kills = killer:GetNWInt("Killstreak") + 1
	killer:SetNWInt("Killstreak",kills)
	umsg.Start("ta-killstreak")
		umsg.Entity(killer)
		umsg.Short(kills)
	umsg.End()
end)

// Create Squads func
GM.Squads = {red = {}, blu = {}}
GM.Red, GM.Blu = {Spawns = {}}, {Spawns = {}}
GM.SquadMax = 3
function CreateSquads(sqd,tm)
	local availplys = team.GetPlayers(tm)
	
	local top_points = {-1,nil,nil}
	for k,v in ipairs(availplys) do
		if DB.GetPoints(v) * 0.6 + DB.GetPlays(v) * 0.4 > top_points[1] then 
			top_points[1] = DB.GetPoints(v)
			top_points[2] = k
			top_points[3] = v
		end
	end
	ta.Message("You've been selected to become General!",false,{top_points[3]})
	top_points[3]:SetNWBool("General",true)

	for i = 1, math.max(math.ceil(team.NumPlayers(tm)/3),1) do
		local tbl = {}
		for n = 1, math.min(table.Count(availplys),3) do
			local num = math.random(1,table.Count(availplys))
			table.insert(tbl,availplys[num])
			table.remove(availplys,num)
		end
		local pts = {-1,nil}
		/*for _,v in pairs(tbl) do 
			if DB.GetPoints(v) + DB.GetPlays(v) * 5 > pts[1] then 
				pts[1] = DB.GetPoints(v)
				pts[2] = v
			end
		end
		for _,v in pairs(tbl) do 
			if v == pts[2] then 
				v:SetLeader()  
				tbl.leader = v
			else 
				v:RemoveLeader() 
			end 
		end*/
		local ldr = tbl[1]
		for _,v in ipairs(tbl) do ldr = ta.ComparePoints(v,ldr) end
		tbl.leader = ldr
		tbl.name = "Squad "..i
		table.insert(sqd,tbl)
		
		for c,v in pairs(tbl) do	
			if c != "name" and c != "leader" then 
				v:SetSquad(tbl)
				umsg.Start("sendSquad",v)
					umsg.Entity(tbl.leader)
					umsg.Short(GAMEMODE.SquadMax)
					for k,q in pairs(tbl) do if k !="name" and k != "leader" and q != tbl.leader then
						umsg.Entity(q)
					end end
				umsg.End()
			end
		end
		
	end
	
end

function GM:OnRoundStart( n )

	ta.SpawnEntities()
	if not GAMEMODE.Squads.red[1] or not GAMEMODE.Squads.blu[1] then
		CreateSquads(GAMEMODE.Squads.red,1)
		CreateSquads(GAMEMODE.Squads.blu,2)
	end
	GAMEMODE.Red.Spawns = {}
	GAMEMODE.Blu.Spawns = {}
	//for _,v in ipairs(player.GetAll()) do v:ConCommand("ta_printsquads") end
	for _,v in ipairs(player.GetAll()) do v:ChatPrint("The round has begun! Get going!") v:UnLock() v:Freeze(false) end
	for _,v in ipairs(ents.FindByClass("obj_*")) do v:SetNWBool("ObjectiveComplete",false) end
	
	umsg.Start("stopRoundSound") umsg.End()
end

function GM:OnRoundEnd( n )
	local winner = GetGlobalInt("RoundResult")
	local rp1,rp2 = RecipientFilter(),RecipientFilter()
	for _,v in ipairs(player.GetAll()) do if v:Team() == 1 then rp1:AddPlayer(v) elseif v:Team() == 2 then rp2:AddPlayer(v) end end
	umsg.Start("endRoundSound",rp1)
		if winner == 1 then umsg.Bool(true) else umsg.Bool(false) end
	umsg.End()
	umsg.Start("endRoundSound",rp2)
		if winner == 2 then umsg.Bool(true) else umsg.Bool(false) end
	umsg.End()
end

function GM:CanStartRound( n )
	return ta.Players() >= 6
end

/* HOW IT WORKS:
	< 16 players = 3 person squads
	16 - 29 players = 4 person squads
	30 - 47 = 5 player squads
	> 48 = 6 player squad
*/ 

function CheckSquads( pl )

	if ta.Players() == 16 and GAMEMODE.SquadMax != 4 then 
		GAMEMODE.SquadMax = 4
		ta.Message("Squads are now 4 people.",true)
	elseif ta.Players() == 30 and GAMEMODE.SquadMax != 5 then 
		GAMEMODE.SquadMax = 5
		ta.Message("Squads are now 5 people!",true)
	elseif ta.Players()  >= 48 and GAMEMODE.SquadMax != 6 then 
		GAMEMODE.SquadMax = 6
		ta.Message("Squads are now 6 people!",true)
	elseif ta.Players() < 16 and GAMEMODE.SquadMax != 3 then
		GAMEMODE.SquadMax = 3 
		ta.Message("Squads are now 3 people!",true)
	end

	/*print("Attempting to place ".. pl:Name() .. " in a squad...")
	print("	"..tostring(pl:GetSquad()))
	print("	"..tostring(GAMEMODE:InRound()))
	print("	"..pl:Team())*/
	
	
	// Put them in a squad if not already done
	if not pl:GetSquad() and GAMEMODE:InRound() and pl:Team() != 0 and pl:Team() != 1001 then
		local in_squad = false
		local sqd = {}
		if pl:Team() == 1 then
			for _,v in pairs(GAMEMODE.Squads.red) do
				if not v[GAMEMODE.SquadMax] then 
					table.insert(v,pl)
					in_squad = true
					// DETERMINE IF HE'S A BETTER LEADER
						local ldr = pl
						for _,ply in ipairs(v) do
							ldr = ta.ComparePoints(ldr,ply)
						end
						v.leader = pl
					sqd = v
					break
				end
			end
			if not in_squad then
				sqd = {name = "Squad " ..table.Count(GAMEMODE.Squads.blu), pl, leader = pl}
				table.insert(GAMEMODE.Squads.red, sqd)
			end
		elseif pl:Team() == 2 then
			for _,v in pairs(GAMEMODE.Squads.blu) do
				if not v[GAMEMODE.SquadMax] then 
					table.insert(v,pl)
					in_squad = true
					// DETERMINE IF HE'S A BETTER LEADER
						local ldr = pl
						for _,ply in ipairs(v) do
							ldr = ta.ComparePoints(ldr,ply)
						end
						v.leader = ldr
					sqd = v
					break
				end
			end
			if not in_squad then
				sqd = {name = "Squad " ..table.Count(GAMEMODE.Squads.blu), pl, leader = pl}
				table.insert(GAMEMODE.Squads.blu, sqd)
			end
		end
		pl:SetSquad(sqd)
			
		for c,v in pairs(sqd) do	
			if c != "name" and c != "leader" then 
				v:SetSquad(sqd)
				umsg.Start("sendSquad",v)
					umsg.Entity(sqd.leader)
					umsg.Short(GAMEMODE.SquadMax)
					for k,q in pairs(sqd) do if k !="name" and k != "leader" and q != sqd.leader then
						umsg.Entity(q)
					end end
				umsg.End()
			end
		end
	end
	
	
	
end
hook.Add("PlayerSpawn","CheckSquads",CheckSquads)

function CaptureRound(ent,t,cappers)
	ta.Message(team.GetName(t).." has captured a control point!")
	local objs = ents.FindByClass("obj_capture")
		
	if t == 1 then
		local spawns = {}
		for i = 1,3 do
			local newspawn = ents.Create("info_player_terrorist")
			newspawn:SetPos(ent:GetPos() + Vector(i * 5 - 5, i * 5 - 5,10))
			newspawn:Spawn()
			newspawn:Activate()
			table.insert(spawns,newspawn)
		end
		table.insert(GAMEMODE.Red.Spawns,spawns)
	else
		local spawns = {}
		for i = 1,3 do
			local newspawn = ents.Create("info_player_counterterrorist")
			newspawn:SetPos(ent:GetPos() + Vector(i * 5 - 5, i * 5 - 5,10))
			newspawn:Spawn()
			newspawn:Activate()
			table.insert(spawns,newspawn)
		end
		table.insert(GAMEMODE.Blu.Spawns,spawns)
	end
	
	if GetGlobalString("ta_mode") == "capture" then
	
		local capped = 0
		for _,v in ipairs(objs) do
			if v:GetNWInt("HasCapped") == 1 then capped = capped + 1
			elseif v:GetNWInt("HasCapped") == 2 then capped = capped - 1
			end
		end
		
		local pts_added = {}
		for _,v in ipairs(cappers) do
			if !table.HasValue(pts_added,v) then 
				v:AddFrags(10)
				table.insert(pts_added,v)
			end
		end
		
		if capped == #objs then GAMEMODE:RoundEndWithResult(1,"Team Red wins!")
			GAMEMODE.Red.Spawns = {}
			GAMEMODE.Blu.Spawns = {}
		elseif capped == #objs * -1 then GAMEMODE:RoundEndWithResult(2,"Team Blue wins!")
			GAMEMODE.Red.Spawns = {}
			GAMEMODE.Blu.Spawns = {}
		end
		
		for _,v in ipairs(objs) do v:SetNWBool("ObjectiveComplete",true) end
		
	end
	DB.Save()
end
hook.Add("ta_capwon","CaptureRound",CaptureRound)

function BombRound(t,detonated,boomer)
	if detonated then
		ta.Message(team.GetName(t).." detonated the bomb!")
	else
		ta.Message(team.GetName(t).." has defused the bomb!")
	end
	
	boomer:AddFrags(15)
	GAMEMODE.Red.Spawns = {}
	GAMEMODE.Blu.Spawns = {}
	GAMEMODE:RoundEndWithResult(t,"Winner!")
	DB.Save()
end
hook.Add("ta_bombwon","BombRound",BombRound)


/*function GM:PlayerJoinClass(pl,class)
	if class == "Runner" then
		pl:SetNWBool("Runner",true)
	else
		pl:SetNWBool("Runner",false)
	end
end*/

function SendObjectives(pl,cmd,args)
	if pl:GetSquad().leader != pl then return end
	local rp = RecipientFilter()
	for _,v in ipairs(pl:GetSquad()) do rp:AddPlayer(v) end
	umsg.Start("ta_objective",rp)
		umsg.String("Assault "..args[1].." Objective "..math.floor(args[2]))
	umsg.End()
end
concommand.Add("ta_target",SendObjectives)

concommand.Add("ta_aurora",function(pl)
	if pl:GetNWInt("Killstreak") >= 25 and !pl:GetNWBool("HasCannon") then
		pl:SetNWBool("HasCannon",true)
		pl:Give("weapon_auroracannon")
	end
end)

concommand.Add("ta_printsquads",function()
	for _,p in ipairs(player.GetAll()) do
		p:ChatPrint("And the teams are...")
		for k,sqd in pairs(GAMEMODE.Squads) do
			p:ChatPrint("----------Team "..k.."----------")
			for a,b in pairs(sqd) do
				p:ChatPrint("----Squad "..a.."----")
				for c,d in pairs(b) do
					if c != "name" then
					p:ChatPrint("Player "..c..": "..d:Name())
					end
				end
			end
		end
	end
end)

concommand.Add("ta_save",function(pl)
	if !pl:IsAdmin() then return end
	for _,v in ipairs(player.GetAll()) do
		if not string.find(string.lower(v:Name()),"bot") then
			DB.Save()
		end
	end
end)

concommand.Add("ta_points",function(pl)
	pl:ChatPrint(DB.GetPoints(pl))
end)

concommand.Add("ta_bots",function(pl)
	if !pl:IsAdmin() then return end
	for i=1,11 do pl:ConCommand("bot") end
end)

concommand.Add("ta_send",function(pl)
	local tbl = pl:GetSquad()
	umsg.Start("sendSquad",pl)
		umsg.Entity(tbl.leader)
		umsg.Short(GAMEMODE.SquadMax)
		for k,q in pairs(tbl) do if k !="name" and k != "leader" and q != tbl.leader then
			umsg.Entity(q)
		end end
	umsg.End()
end)

concommand.Add("ta_ambience",function(pl,cmd,args)
	if !pl:IsAdmin() then return end
	SetGlobalString("ta_ambience",args[1])
end)