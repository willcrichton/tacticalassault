
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
GM.GameLength = 60
GM.PlayerCanNoClip = false

GM.NoPlayerDamage = false
GM.NoPlayerSelfDamage = false
GM.NoPlayerTeamDamage = true
GM.NoPlayerPlayerDamage = false
GM.NoNonPlayerPlayerDamage = false
GM.TakeFragOnSuicide = true
GM.AddFragsToTeamScore = true
GM.RealisticFallDamage = true
GM.MinimumDeathLength = 5

GM.RoundBased = true
GM.RoundLength = 3000
GM.RoundPreStartTime = 5
GM.RoundPostLength = 5
GM.RoundEndsWhenOneTeamAlive = false
GM.RoundLimit = 5

GM.SelectModel = false
GM.CanOnlySpectateOwnTeam = true

TEAM_RED = 1
TEAM_BLUE = 2

function GM:CreateTeams()
	
	team.SetUp( TEAM_RED, "Team Red", Color( 255, 80, 80 ), true )
	team.SetSpawnPoint( TEAM_RED, "info_player_terrorist", "info_player_rebel"  )
	team.SetClass( TEAM_RED , { "Runner", "Cavalry", "Assault", "Sniper", "Artillery", "Medic",} )
	
	team.SetUp( TEAM_BLUE, "Team Blue", Color( 80, 80, 255 ), true )
	team.SetSpawnPoint( TEAM_BLUE, "info_player_counterterrorist", "info_player_combine" )
	team.SetClass( TEAM_BLUE, { "Runner", "Cavalry", "Assault", "Sniper", "Artillery", "Medic"} )
	
	team.SetUp( TEAM_SPECTATOR, "Spectators", Color( 200, 200, 200 ), true )
	team.SetSpawnPoint( TEAM_SPECTATOR, { "info_player_start", "info_player_terrorist", "info_player_counterterrorist" } ) 

end
