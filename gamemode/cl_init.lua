include( 'shared.lua' )
include( 'cl_ambience.lua' )
include( 'cl_hud.lua' )
include( 'cl_vgui.lua' )
include( 'util.lua' )

surface.CreateFont( "HalfLife2", SScale( 20 ), 0, true, true, "HudNumber20" )
surface.CreateFont( "Army", 25, 400, true, false, "ObjectiveFontPrimary" )
surface.CreateFont( "Army", 18, 400, true, false, "ObjectiveFontSecondary" )
surface.CreateFont( "Army",  40, 400, true, false, "AmmoFontPrimary" )

language.Add("sent_sakarishelicopter","Helicopter")

function GM:PositionScoreboard( ScoreBoard )

	ScoreBoard:SetSize( 700, ScrH() - 100 )
	ScoreBoard:SetPos( (ScrW() - ScoreBoard:GetWide()) / 2, 50 )

end

function GM:UpdateHUD_Alive()
end

/*function OptionsMenu()
	local frame = vgui.Create("DFrame")
	frame:SetSize(150,300)
	frame:Center()
	frame:MakePopup()
	frame:SetTitle("")
	frame.Paint = function()
		draw.RoundedBox(4,0,0,frame:GetWide(),frame:GetTall(),Color(0,0,0,200))
		draw.DrawText("Options Menu","ScoreboardText",frame:GetWide()/2,2,color_white,1)
	end
end
concommand.Add("ta_options",OptionsMenu)

function GeneralMenu()
	if not LocalPlayer():GetNWBool("General") then return end
	local frame = vgui.Create("DFrame")
	frame:SetSize(100,300)
	frame:Center()
	frame:MakePopup()
	frame:SetTitle("")
	frame.Paint = function()
		draw.RoundedBox(4,0,0,frame:GetWide(),frame:GetTall(),Color(0,0,0,200))
		draw.DrawText("General's Menu","ScoreboardText",frame:GetWide()/2,2,color_white,1)
	end
end
concommand.Add("ta_general",GeneralMenu)*/

// Death view
local bright,cont,col = 0,1,1
hook.Add("RenderScreenspaceEffects","TestDeath",function()
	if !LocalPlayer():Alive() then
		
		bright = math.Approach(bright, -0.11,0.005)
		cont = math.Approach(cont,0.56,0.005)
		col = math.Approach(col,0,0.005)
	
		local ScrColTab = {}
		ScrColTab[ "$pp_colour_addr" ] 		= 0
		ScrColTab[ "$pp_colour_addg" ] 		= 0
		ScrColTab[ "$pp_colour_addb" ] 		= 0
		ScrColTab[ "$pp_colour_brightness" ]= bright
		ScrColTab[ "$pp_colour_contrast" ] 	= cont
		ScrColTab[ "$pp_colour_colour" ] 	= col
		ScrColTab[ "$pp_colour_mulr" ] 		= 0
		ScrColTab[ "$pp_colour_mulg" ] 		= 0
		ScrColTab[ "$pp_colour_mulb" ] 		= 0
		DrawColorModify(ScrColTab)
		
		ta.StopLowHealth()
		
	elseif LocalPlayer():Health() < 20 then
	
		DrawMotionBlur( 0.25, 0.7, 0)
		
	else 
		bright,cont,col = 0,1,1	
		ta.StopLowHealth()
	end
		
end)

// Recieve killstreak info
usermessage.Hook("ta-killstreak",function(um) 
	local killer,kills = um:ReadEntity(),um:ReadShort()
	timer.Simple(0.05,function() ta.AddKillStreak(killer,kills) end) 
end)

// Stop death sounds
usermessage.Hook("ta-death",function(u) 
	local b = u:ReadBool()
	if b then ta.StopLowHealth() else ta.LowHealth() end
end)
