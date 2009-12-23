local TIME_AIRSTRIKE = 180
local TIME_AMMODROP = 300

timer.Simple(20,function() physenv.SetPerformanceSettings({MaxVelocity = 50000 }) end)

function Airstrike(pl)
	
	if !pl:GetNWBool("General") then return end
	if pl:Team() == 1 then 
		local a = GAMEMODE.Red.LastAirstrike
		if a and CurTime() - a < TIME_AIRSTRIKE then pl:ChatPrint("You must wait ".. math.ceil(TIME_AIRSTRIKE - (CurTime() - a)) .. " more seconds before using an airstrike.") return end
	else 
		local a = GAMEMODE.Blu.LastAirstrike
		if a and CurTime() - a < TIME_AIRSTRIKE then pl:ChatPrint("You must wait ".. math.ceil(TIME_AIRSTRIKE - (CurTime() - a)) .. " more seconds before using an airstrike.") return end
	end
	
	local orig = {tr = pl:GetEyeTrace()}
	
	local flyby_sounds = {
		Sound("ta/flyby1.mp3"),
		Sound("ta/flyby2.mp3"),
	}
	
	if orig.tr.HitPos:Distance(pl:GetPos()) > 8000 then pl:ChatPrint("You must be at least 8000 units from the target to use an airstrike.") return end
	if orig.tr.HitPos:Distance(pl:GetPos()) < 2000 then pl:ChatPrint("You're too close to call in an airstrike! You must be at least 2000 units away.") return end
	
	local ent = ents.Create("prop_physics")
	ent:SetModel("models/XQM/jetbody3_s2.mdl")
	
	local tr = util.TraceLine(util.GetPlayerTrace( pl , -1 * pl:GetForward()))
	local pos = pl:GetPos() - pl:GetForward() * 1000 + Vector(800,0,700)
	
	//if not util.IsInWorld(pos) or not util.PointContents(pos) == CONTENTS_EMPTY then ent:SetPos(tr.HitPos + Vector(0,0,500))
	//else ent:SetPos(pos) end
	ent:SetPos(tr.HitPos + Vector(0,0,1500))

	ent:Spawn()
	ent:Activate()
	
	local vel_mul = 10000
	local phys = ent:GetPhysicsObject()
	phys:EnableGravity(false) 
	phys:EnableCollisions(false)
	
	//if not util.IsInWorld(pos) or not util.PointContents(pos) == CONTENTS_EMPTY  then
		phys:SetVelocity( (pl:GetForward()) * vel_mul )
		ent:SetAngles( pl:GetForward():Angle() + Angle(0,90,0) )
		
		timer.Simple(1,function()
			phys:SetVelocity( (orig.tr.HitPos - pl:GetPos()):Normalize() * vel_mul )
		end)
	/* else
		phys:SetVelocity( (pl:GetForward() + Vector(-0.2,5,0)) * vel_mul )
		ent:SetAngles( pl:GetForward():Angle() + Angle(0,100,0) )
		pl:ChatPrint("Spawn point was not in the world.")
	end */
	
	ent:EmitSound(table.Random(flyby_sounds))
	
	orig.pos =  ent:GetPos()
	orig.time = CurTime()
	orig.index = ent:EntIndex()
	
	hook.Add("Think","LaunchBombs"..ent:EntIndex(),function()
	
		if orig.launched then return end
		if !ent:IsValid() then 
			pl:ChatPrint("Airstrike malfunction!") 
			hook.Remove("Think","LaunchBombs"..orig.index) return 
		end
		if math.abs(orig.tr.HitPos.x - ent:GetPos().x) > 300 or math.abs(orig.tr.HitPos.y - ent:GetPos().y) > 300 then return end
	
		local td = {start = ent:GetPos(),endpos = ent:GetPos() - Vector(0,0,1000000),filter = ent}
		local tdr = util.TraceLine(td)
		orig.to_hit = tdr.HitPos
	
		if !ent:IsValid() then pl:ChatPrint("The airstrike malfunctioned!") return end
		for i =1, 3 do
			local bomb = ents.Create("prop_physics")
			bomb:SetPos(ent:GetPos() - Vector(20 - i * 20,0,100))
			bomb:SetModel("models/Combine_Helicopter/helicopter_bomb01.mdl")
			
			bomb:Spawn()
			bomb:Activate()
			
			local b_phys = bomb:GetPhysicsObject()
			b_phys:SetVelocity(ent:GetUp() * -10 + pl:GetForward() * 100)
			
			hook.Add("Think",bomb:EntIndex().."BlowUp",function()
				if orig.to_hit.z >= bomb:GetPos().z - 50 or CurTime() - orig.time > 15 then
					local effectdata = EffectData()
					effectdata:SetOrigin( bomb:GetPos() )
					effectdata:SetNormal( bomb:GetPos():GetNormalized() )
					effectdata:SetEntity( bomb )
					util.Effect( "super_explosion", effectdata )
					
					local explosion = ents.Create( "env_explosion" )
					explosion:SetPos(bomb:GetPos())
					explosion:SetKeyValue( "iMagnitude" , "500" )
					explosion:SetPhysicsAttacker(pl)
					explosion:SetOwner(pl)
					explosion:Spawn()
					explosion:Fire("explode","",0)
					explosion:Fire("kill","",0 )
					bomb:Remove()
					hook.Remove("Think",bomb:EntIndex().."BlowUp")
				end
			end)
		end
		hook.Remove("Think","LaunchBombs"..ent:EntIndex())
		orig.launched = true
	end)
	
	undo.Create("Airstrike")
		undo.AddEntity(ent)
		undo.SetPlayer(pl)
		undo.SetCustomUndoText("Airstrike")
	undo.Finish()
	
	hook.Add("Think","RemoveObject"..ent:EntIndex(),function()
		if !ent or !ent:IsValid() then return end
		local tracedata = {}
		tracedata.start = ent:GetPos()
		tracedata.endpos = ent:GetPos() + ent:GetRight() * 10000000
		tracedata.filter = ent
		trace = util.TraceLine(tracedata)
		if (!trace.HitNonWorld and trace.HitPos:Distance(ent:GetPos()) < 5 and CurTime() - orig.time > orig.tr.HitPos:Distance(pl:GetPos()) / 2500 + 1) or CurTime() - orig.time > 10 then
			ent:Remove()
			hook.Remove( "Think", "RemoveObject"..ent:EntIndex() )
		end
	end)
	
	if pl:Team() == 1 then GAMEMODE.Red.LastAirstrike = CurTime()
	else GAMEMODE.Blu.LastAirstrike = CurTime() end

end
concommand.Add("ta_airstrike",Airstrike)

function AmmoDrop(pl)

	if !pl:GetNWBool("General") then return end
	if pl:Team() == 1 then 
		local a = GAMEMODE.Red.LastAmmo
		if a and CurTime() - a < TIME_AMMODROP then pl:ChatPrint("You must wait ".. math.ceil(TIME_AMMODROP - (CurTime() - a)) .. " more seconds before using an airstrike.") return end
	else 
		local a = GAMEMODE.Blu.LastAmmo
		if a and CurTime() - a < TIME_AMMODROP then pl:ChatPrint("You must wait ".. math.ceil(TIME_AMMODROP - (CurTime() - a)) .. " more seconds before using an airstrike.") return end
	end

	local up = util.TraceLine({start = pl:GetPos(),endpos = pl:GetPos() + Vector(0,0,1000000000),filter=pl})
	if up.HitPos:Distance(pl:GetPos()) < 1000 then pl:ChatPrint("You must be in an open area!") return end
	
	local crate = ents.Create("ent_ammopack")
	crate:SetPos(up.HitPos - Vector(0,0,1000))
	crate:Spawn()
	crate:Activate()
	crate:SetNativeTeam(pl:Team())
	
	if pl:Team() == 1 then GAMEMODE.Red.LastAmmo = CurTime()
	else GAMEMODE.Blu.LastAmmo = CurTime() end
	
end
concommand.Add("ta_ammodrop",AmmoDrop)

function MakeObjective(pl)
	local obj = ents.Create("obj_capture")
	obj:SetPos(pl:GetEyeTrace().HitPos)
	obj:Spawn()
	obj:Activate()
end
concommand.Add("ta_cap",MakeObjective)

function MakeBomb(pl)
	local obj = ents.Create("obj_explode")
	obj:SetPos(pl:GetEyeTrace().HitPos)
	obj:Spawn()
	obj:Activate()
end
concommand.Add("ta_bomb",MakeBomb)