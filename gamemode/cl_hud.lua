include("util.lua")
include("shared.lua")

local squad = {}
local obj1,obj2 = "", ""
usermessage.Hook("sendSquad",function(u)
	local ldr = u:ReadEntity()
	squad = {leader = ldr,ldr}
	for i=1,u:ReadShort() - 1 do
		table.insert(squad,u:ReadEntity())
	end
end)
usermessage.Hook("ta_objective",function(u)
	obj2 = obj1
	obj1 = u:ReadString()
end)


local options = {squadArrows = true, squadHealth = true}
local last_use = SysTime()

function DrawProgressBar(x,y,w,h,diag,facing_up,col)
	if col then surface.SetDrawColor(col) end
	/* if w - diag < 0 then 
		LocalPlayer():ChatPrint( w - diag)
		if facing_up then
			surface.DrawPoly{
				{x =x,y = y + h};
				{x = x +  (diag - w) / diag, y = y+ h};
				{x = x + (diag - w) / diag , y = y};
			}
		else
			surface.DrawPoly{
			}
		end
	else */
		if facing_up then	
			
			surface.DrawPoly{
				{ x = x, y = y + h};
				{ x = x  + w, y = y + h};
				{ x = x + w - diag, y = y;};
				{ x = x + diag,y = y};
			}
		else
			surface.DrawPoly{
				{ x = x, y = y};
				{ x = x + diag, y = y + h};
				{ x = x + w - diag, y = y + h;};
				{ x = x + w,y = y};
			}
		end
	//end
end

local round_duration = 0
local round_timer = 0
local mul = 30
local sel_timer = 0
local key_wait = CurTime()
local objectives = {}

local obj_tex = {
["explode"] = "gui/silkicons/bomb",
["capture"] = "ta/cap-icon",
}

local start,finish = 0,0

hook.Add("HUDPaint","TA-DrawHudMain",function()
		
	if !LocalPlayer():Alive() then return end
	
	local k_pos = 0
	
	surface.SetTexture(surface.GetTextureID("VGUI/gradient-r"))
	surface.SetDrawColor(0,0,0,200)
	surface.DrawTexturedRectRotated(ScrW()-150,ScrH()-275,200,150,180)
	
	for k,v in pairs(squad) do if k != "name" && k != "leader" && v != LocalPlayer() && v:IsPlayer() && ValidEntity(v) then
	
		// Above their head info
		local pos = (v:GetPos() + Vector(0,0,80 - LocalPlayer():GetPos():Distance(v:GetPos()) / 100)):ToScreen()
		if v:Alive() and options.squadArrows then 
			draw.DrawText(v:Name(),"ScoreboardText",pos.x ,pos.y - 25,color_white,1) 
			
			draw.RoundedBox(0,pos.x - 15,pos.y - 8,30,6,color_black)
			draw.RoundedBox(0,pos.x - 14,pos.y - 7,28 * (v:Health() / v:GetPlayerClass().MaxHealth),4,Color(0,255,0))
			
			local quad = {}
			quad.texture 	= surface.GetTextureID( "ta/player-arrow" )
			quad.color		= team.GetColor(LocalPlayer():Team())
		 
			quad.x = pos.x - 12.5
			quad.y = pos.y 
			quad.w = 25
			quad.h = 12.5
			draw.TexturedQuad( quad )
			
		
		end
		
		/* 
		if options.squadHealth then
			local x = k_pos * 100
			draw.RoundedBox(8,260 + x,ScrH() - 97,90,73,Color(0,0,0,76))
			draw.DrawText(string.upper(v:Name()),"HudSelectionText",270 + x,ScrH() - 97 + 50,Color(255,220,0,200),0)
			draw.DrawText(v:Health(),"HudNumber20",260 + x + 45,ScrH() - 97 + 10,Color(255,220,0,200),1)
		end */
		
		
		k_pos = k_pos + 1
		
	end end
	
	// Squad box
	draw.DrawText("Squad Members","ObjectiveFontPrimary",ScrW() - 150,ScrH() - 380,color_white,1)
	for k,v in ipairs(squad) do if v:IsValid() then

		local prefix = ""
		if v == squad.leader then prefix = "(L)" end
	
		draw.DrawText(v:Name() .. " " .. prefix,"MenuLarge",ScrW()-240,ScrH()-340 + (k - 1) * 20,color_white,0)
		
	end end
	
	
	
	// Objectives
	if obj1 != "" and ValidEntity(objectives[1]) and (not objectives[1]:GetNWBool("ObjectiveComplete") || objectives[1]:GetNWInt("HasCapped") != LocalPlayer():Team()) then draw.DrawText(obj1,"ObjectiveFontPrimary",30,20,color_white,0) 
	elseif ValidEntity(objectives[2]) and (not objectives[2]:GetNWBool("ObjectiveComplete") || objectives[2]:GetNWInt("HasCapped") != LocalPlayer():Team()) then
		objectives[1] = objectives[2]
		objectives[2] = nil
		obj1 = obj2
		obj2 = ""
	end
	if obj2 != "" and ValidEntity(objectives[2]) and not objectives[2]:GetNWBool("ObjectiveComplete") then draw.DrawText(obj2,"ObjectiveFontSecondary",30,45,color_white,0) end
	
	// Ammo
	/*if !LocalPlayer():GetActiveWeapon():IsValid() or !LocalPlayer():Health() then return end
	local clip = LocalPlayer():GetActiveWeapon():Clip1()
	if clip > -1 then
		draw.DrawText(clip,"AmmoFontPrimary",ScrW() - 120,ScrH() - 80,color_white,0)
		for i =1,clip do
			draw.TexturedQuad({texture="color/white",color=color_white,x=ScrW()-130 - i * 3,y=ScrH() - 60,w=1.4,h=8})
		end
	end
	
	local clip2 = LocalPlayer():GetActiveWeapon():Clip2()
	if clip2 > -1 then
		draw.DrawText(clip2,"ObjectiveFontPrimary",ScrW()-117,ScrH()-50,color_white,0)
		for i =1,clip2 do
			draw.TexturedQuad({texture="color/white",color=color_white,x=ScrW()-130 - i * 3,y=ScrH() - 40,w=1.4,h=8})
		end
	end
	
	// Health
	draw.TexturedQuad({texture=surface.GetTextureID("ta/hp"),color=color_white,x=50,y=ScrH()-73,w=25,h=25})
	draw.DrawText(LocalPlayer():Health(),"AmmoFontPrimary",85,ScrH()-80,color_white,0)*/

	// Objective points
	surface.SetTexture( "color/white" )
	if GetGlobalString("ta_mode") == "capture" then
		local objs = ents.FindByClass("obj_capture")
		for k,v in ipairs(objs) do
			/* local xpos = ScrW()/2 + (k - #objs/1.8) * 200 - 200
			draw.DrawText("Objective "..k,"ScoreboardText", xpos,ScrH() - 80,color_white,1)
			draw.RoundedBox(0,xpos - 75,ScrH() - 60,150,20,color_black)
			
			local prog = v:GetNWInt("ta_progress")
			if prog > 0 then draw.RoundedBox(0,xpos - 73,ScrH() - 58,146 * (prog / 100),16,Color(255,0,0))
			else draw.RoundedBox(0,xpos - 73,ScrH() - 58,146 * (prog * -1 / 100),16,Color(0,0,255)) end
			
			local plys = v:GetNWInt("ta_players")
			if plys > 0 then draw.DrawText(plys.."x","ScoreboardText",xpos,ScrH() - 58,color_white,1) end */
			
			local xpos = ScrW()/2 + (k - #objs/1.8) * 200 - 125
			draw.DrawText("Objective "..k,"ScoreboardText", xpos,ScrH() - 80,color_white,1)
			local prog = v:GetNWInt("ta_progress")
			if k%2 == 0 then 
				ta.DrawTrapezoid(xpos - 75,ScrH()-60,150,20,20,false,color_black)
				if prog > 0 then ta.DrawTrapezoid(xpos - 69,ScrH() - 58,138 * (prog / 100),16,16,false,Color(255,0,0))
				else ta.DrawTrapezoid(xpos - 69,ScrH() - 58,138 * (prog / -100),16,16,false,Color(0,0,255)) end
			else 
				ta.DrawTrapezoid(xpos - 75,ScrH()-60,150,20,20,true,color_black)
				if prog > 0 then ta.DrawTrapezoid(xpos - 69,ScrH() - 58,138 * (prog / 100),16,16,true,Color(255,0,0)) 
				else ta.DrawTrapezoid(xpos - 69,ScrH() - 58,138 * (prog / -100),16,16,true,Color(0,0,255)) end
			end
			
			local plys,text = v:GetNWInt("ta_players"), ""
			if plys == -1 then text = "Blocked!" elseif plys > 0 then text = plys.."x" else text = "" end
			draw.DrawText(text,"ScoreboardText",xpos,ScrH() - 57,color_white,1)
			
		end
	elseif GetGlobalString("ta_mode") == "bomb" then
		local bomb = ents.FindByClass("ent_bomb")[1]
		if bomb then
			local w,h,diag = 200,40,50
			local x,y = ScrW()/2 - w / 2,15 + h
			surface.SetTexture("color/white")
			surface.SetDrawColor( 200, 200, 200, 150 )
			ta.DrawTrapezoid(x,y,w,h,diag,true)
			draw.DrawText("bomb","ObjectiveFontSecondary",ScrW()/2 - 24,31 + h,color_black,1)
			draw.DrawText(bomb:GetNWInt("bomb_timer"),"AmmoFontPrimary",ScrW()/2 + 20,17 + h,color_black,1)
		end
	end
	
	// Timer
	/*local w,h,diag = 200,40,50
	local x,y = ScrW()/2 - w / 2,5
	
	if finish - start != round_duration || GetGlobalInt("RoundStartTime") != start then
		round_duration = finish - start
		round_timer = CurTime()
	end
	
	surface.SetDrawColor( 200, 200, 200, 150 )
	ta.DrawTrapezoid(x,y,w,h,diag,false)
	if round_timer > 0 and round_timer + round_duration - CurTime() > 0 then draw.DrawText(ta.SecToMin(round_timer + round_duration - CurTime()),"AmmoFontPrimary",ScrW()/2,5,color_black,1)
	else draw.DrawText("00:00","AmmoFontPrimary",ScrW()/2,5,color_black,1) end
	
	start,finish = GetGlobalInt("RoundStartTime"), GetGlobalInt("RoundEndTime")*/
	
	/* // Team name
	x = x - w + 30
	ta.DrawTrapezoid(x,y,w,h,diag,true)
	draw.DrawText(team.GetName(LocalPlayer():Team()),"ObjectiveFontPrimary",ScrW()/2  - w + 30,13,team.GetColor(LocalPlayer():Team()),1)
	
	// Game mode
	x = x + 2 * w - 60
	ta.DrawTrapezoid(x,y,w,h,diag,true)
	draw.DrawText(ta.Capitalize(GetGlobalString("ta_mode")),"ObjectiveFontPrimary",ScrW()/2 + w - 30,13,color_black,1) */
	
	// Draw chevron over primary target
	if objectives[1] and ValidEntity(objectives[1]) then
		local pos = objectives[1]:GetPos():ToScreen()
		ta.DrawChevron(pos.x,pos.y - 30,55,30,15,false,Color(0,120,255,200))
	end
	
	// Target selection
	if not squad || squad.leader != LocalPlayer() then return end
	local selected = 0
	for k,v in ipairs(ents.FindByClass("obj_*")) do
		local pos = v:GetPos():ToScreen()
		local str = string.Explode("_",v:GetClass())[2]
		if pos.visible then
			local vec = LocalPlayer():GetEyeTrace().HitPos:ToScreen()
			local x,y = vec.x,vec.y
			if x > pos.x - mul/2 and x < pos.x + mul/2 and y > pos.y - mul/2 and y < pos.y + mul/2 then
				mul = math.Clamp(mul + 1.3,30,50)
				selected = k
				if input.IsKeyDown(KEY_T) and CurTime() - key_wait > .2 then
					key_wait = CurTime()
					if objectives[1] then objectives[2] = objectives[1] end
					objectives[1] = v
					RunConsoleCommand("ta_target",str,k)
				end
				if table.HasValue(objectives,v) then ta.RoundedBoxOutlined(4,pos.x - mul/2,pos.y - mul/2,mul,mul,Color(0,0,0,0),Color(255,0,0))
				else ta.RoundedBoxOutlined(4,pos.x - mul/2,pos.y - mul/2,mul,mul,Color(0,0,0,0),color_white) end
			else
				if table.HasValue(objectives,v) then ta.RoundedBoxOutlined(4,pos.x - 15,pos.y - 15,30,30,Color(0,0,0,0),Color(255,0,0))
				else ta.RoundedBoxOutlined(4,pos.x - 15,pos.y - 15,30,30,Color(0,0,0,0),color_white) end
			end
			draw.TexturedQuad({texture=surface.GetTextureID(obj_tex[str]),color=color_white,x=pos.x-10,y=pos.y-10,w=20,h=20})
		end
	end
	if selected == 0 then mul = 30 end
	
end)

hook.Add("HUDPaint","TA-DrawHudSecondary",function()
	
	local x,y,w,h,diag = ScrW() - 290,ScrH() - 48,170,35,20

	surface.SetDrawColor( 100, 100, 100, 120 )
	ta.DrawParallel(x,y,w,h,diag)
	
	// Ammo
	if LocalPlayer():Alive() and LocalPlayer():GetActiveWeapon():IsValid() then
	
		
		
		// HEALTH
		surface.SetDrawColor(0,0,0,255)
		x = x + diag + 14
		y = y - h + 18
		w = 130
		h = 10
		diag = 5
		ta.DrawParallel(x,y,w,h,diag)
		
		surface.SetDrawColor(255,0,0,255)
		x = x + 3
		y = y - 2
		w = w * LocalPlayer():Health() / LocalPlayer():GetPlayerClass().MaxHealth - 4
		h = 6
		diag = 3
		ta.DrawParallel(x,y,w,h,diag)
	
		local wep = LocalPlayer():GetActiveWeapon()
		local clip = wep:Clip1()
		
		x = ScrW() - 125
		y = ScrH() - 53.5
		w = 0.75
		h = 8
		diag = 3
		
		surface.SetDrawColor(255,255,255,255)
		if wep.Primary and wep.Primary.ClipSize > 60 then
			local mul = math.floor( wep.Primary.ClipSize / 60) + 1.2
			for i = 1, clip/mul do
				x = x -  3
				ta.DrawParallel(x,y,w,h,diag)
			end
			
		else
			for i = 1, clip do
				x = x - 3
				ta.DrawParallel(x,y,w,h,diag)	
			end
		end
	end
	
	// Timer
	
	x = ScrW() - 218
	y = ScrH() - 87
	w = 120
	h = 20
	diag = 10
	
	surface.SetDrawColor( 100, 100, 100, 120 )
	ta.DrawParallel(x,y,w,h,diag)
	
	local time = ""
	if finish - start != round_duration || GetGlobalInt("RoundStartTime") != start then
		round_duration = finish - start
		round_timer = CurTime()
	end
	if round_timer > 0 and round_timer + round_duration - CurTime() > 0 then time = ta.SecToMin(round_timer + round_duration - CurTime())
	else time = "00:00" end
	
	draw.DrawText(time.." Left","ScoreboardText",x + w/2,y - 18,color_white,1)
	start,finish = GetGlobalInt("RoundStartTime"), GetGlobalInt("RoundEndTime")
	
	// Game type
	
	//local x,y,w,h,diag = ScrW() - 290,ScrH() - 48,170,35,20
	x = ScrW() - 303
	y = ScrH() - 24
	w = 120
	h = 20
	diag = 11
	
	ta.DrawParallel(x,y,w,h,diag)
	draw.DrawText(ta.Capitalize(GetGlobalString("ta_mode")),"ScoreboardText",x + w / 2,y - 19,color_white,1) 
	
	// ICONS (they break the drawpoly?)
	
	if !LocalPlayer():Alive() then return end
	
	x = ScrW() - 260
	y = ScrH() - 55
	
	draw.TexturedQuad({
		texture=surface.GetTextureID("ta/hp"),
		color=color_white,
		x=x - 12,
		y = y - 27,
		w=15,
		h=15,
	})
	
		
	draw.TexturedQuad({
		texture=surface.GetTextureID("ta/ammo"),
		color=color_white,
		x=x - 16,
		y = y - 10,
		w=10,
		h=15,
	})

end)

hook.Add("HUDShouldDraw","RemoveAmmo",function(name)
	if name == "CHudAmmo" or name == "CHudSecondaryAmmo" or name == "CHudHealth" then return false end
end)

