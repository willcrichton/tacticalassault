
GM.Name 	= "Tactical Assault"
GM.Author 	= "Entoros"
GM.Email 	= ""
GM.Website 	= "http://www.facepunch.com"

DeriveGamemode( "fretta" )
IncludePlayerClasses()	

GM.Help		= "Work with your squad to\nwin points and kill enemies!\nCreated by Entoros and Spencer Henslol (please give us money)"
GM.TeamBased = true
GM.AllowAutoTeam = true
GM.AllowSpectating = true
GM.SelectClass = true
GM.SecondsBetweenTeamSwitches = 10
GM.GameLength = 30
GM.PlayerCanNoClip = false

GM.NoPlayerDamage = false
GM.NoPlayerSelfDamage = false
GM.NoPlayerTeamDamage = true
GM.NoPlayerPlayerDamage = false
GM.NoNonPlayerPlayerDamage = false
GM.TakeFragOnSuicide = true
GM.AddFragsToTeamScore = true
GM.RealisticFallDamage = true
GM.FallSpeedDecrease = 3
GM.MinimumDeathLength = 5

GM.RoundBased = true
GM.RoundLength = 600
GM.RoundPreStartTime = 3
GM.RoundPostLength = 11
GM.RoundEndsWhenOneTeamAlive = false
GM.RoundLimit = 3

GM.SelectModel = false
GM.CanOnlySpectateOwnTeam = true

TEAM_RED = 1
TEAM_BLUE = 2

function GM:CreateTeams()
	
	team.SetUp( TEAM_RED, "Team Red", Color( 255, 40, 40 ), true )
	team.SetSpawnPoint( TEAM_RED, "info_player_terrorist", "info_player_rebel"  )
	team.SetClass( TEAM_RED , { "Runner",  "Assault", "Sniper", "Artillery", "Medic","Techie"} )
	
	team.SetUp( TEAM_BLUE, "Team Blue", Color( 50, 50, 255 ), true )
	team.SetSpawnPoint( TEAM_BLUE, "info_player_counterterrorist", "info_player_combine" )
	team.SetClass( TEAM_BLUE, { "Runner", "Assault", "Sniper", "Artillery", "Medic", "Techie"} )
	
	team.SetUp( TEAM_SPECTATOR, "Spectators", Color( 200, 200, 200 ), true )
	team.SetSpawnPoint( TEAM_SPECTATOR, { "info_player_start", "info_player_terrorist", "info_player_counterterrorist" } ) 

end

// Stole this code from GMDM...
local LastStrafeRoll = 0
local WalkTimer = 0
local VelSmooth = 0
function GM:CalcView( ply, origin, angle, fov )
 
	if !ply:Alive() then
		local rag = ply:GetRagdollEntity()
		if !rag then return end
		local att = rag:GetAttachment( rag:LookupAttachment("eyes") )
		if att then
			att.Pos = att.Pos + att.Ang:Forward() * 1
			
			origin = att.Pos
			angle = att.Ang
		end
		fov = 55
	else
		VelSmooth = math.Clamp( VelSmooth * 0.9 + ply:GetVelocity():Length() * 0.08, 0, 700 )
		if ply:GetPlayerClassName() == "Runner" then VelSmooth = VelSmooth / 1.2 end
		WalkTimer = WalkTimer + VelSmooth * FrameTime() * 0.05

		if ply:IsOnGround() then	
			angle.roll = angle.roll + math.sin( WalkTimer ) * VelSmooth * 0.001
			angle.pitch = angle.pitch + math.cos( WalkTimer * 0.5 ) * VelSmooth * 0.003
			angle.yaw = angle.yaw + math.cos( WalkTimer ) * VelSmooth * 0.003
		end
	end
 
	return self.BaseClass:CalcView(ply,origin,angle,fov)
 
end

hook.Add("OnPlayerHitGround","SlowEmDown",function( pl )
	local class,div = pl:GetPlayerClass(), math.Clamp((pl:GetVelocity():Length() - 630) / 70,1,10)
	local run,walk = class.RunSpeed,class.WalkSpeed
	pl:SetRunSpeed(run / div)
	pl:SetWalkSpeed(walk / div)
	local inc = 0
	timer.Create(pl:SteamID().."speed",0.2,10,function()
		inc = inc + 0.1
		pl:SetRunSpeed(run / div + run * inc * (1 - 1 / div) )
		pl:SetWalkSpeed(walk / div + walk * inc * (1 - 1 / div) )
	end)
end)

