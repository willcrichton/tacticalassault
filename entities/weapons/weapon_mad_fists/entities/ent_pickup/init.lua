AddCSLuaFile( 'cl_init.lua' )
AddCSLuaFile( 'shared.lua' )
include('shared.lua')

function ENT:SpawnFunction( plr, tr )

	if not tr.Hit then return end
	
	local ent = ents.Create( self.Classname )
	ent:SetPos( tr.HitPos + tr.HitNormal * 10 )
	ent:Spawn()
	ent:Activate()	
	
	return ent
end


function ENT:Initialize()	
	
	self:SetType( 2 )
	self:SetSolid( SOLID_NONE )
	self:SetMoveType(MOVETYPE_NONE)
	self:Fire("setdamagefilter","0",0)

	local phys = self:GetPhysicsObject()  	
	if phys:IsValid() then  		
		phys:Wake()  	
	end
	
	self.AmmoTypes = {
		[1] = "AR2",
		[4] = "SMG1",
		[3] = "Pistol",
		[5] = "357",
		[7] = "Buckshot",
		[6] = "XBowBolt",
		[10] = "Grenade",
		[8] = "RPG_Round",
	}
	
	self.Recharging = false
	self.RechargeTime = 15
	self:SetTrigger(true)

end

function ENT:SetType( n )
	self.PickupType = n
	
	if n == 1 then
		self:SetModel("models/props_lab/jar01a.mdl")
		self:SetAngles( Angle( 30, 0, 0 ) )
		timer.Create(self.Entity:EntIndex().."angle",0.001,0,function()
			self.Entity:SetAngles( self.Entity:GetAngles() + Angle(0,2,0))
		end)
	elseif n == 2 then
		self:SetModel("models/props_c17/BriefCase001a.mdl")
		self:SetAngles( Angle( 0, 0, 0 ) )
		timer.Create(self.Entity:EntIndex().."angle",0.001,0,function()
			self.Entity:SetAngles( self.Entity:GetAngles() + Angle(0,2,0))
		end)
	end
end

/*function ENT:Think()
	if self.Recharging then return end

	local plys = ents.FindInSphere( self.Entity:GetPos(), self.Entity:BoundingRadius() * 2 )
	for _,v in ipairs(plys) do
		if v:IsPlayer() then
			if self.PickupType == 1 then
				local hp = v:Health()
				if hp < v:GetPlayerClass().MaxHealth then
					v:SetHealth(math.Clamp(hp + 30,0,v:GetPlayerClass().MaxHealth))
					v:EmitSound("items/smallmedkit1.wav")
					self.Entity:SetNoDraw(true)
					self.Recharging = true
					timer.Simple(self.RechargeTime,function()
						self.Entity:SetNoDraw(false)
						self.Recharging = false
					end)
				end
			elseif self.PickupType == 2 then
				local n = v:GetActiveWeapon():GetPrimaryAmmoType()
				if self.AmmoTypes[n] then v:GiveAmmo(45,self.AmmoTypes[n]) end
				self.Recharging = true
				self.Entity:SetNoDraw(true)
				timer.Simple(self.RechargeTime,function()
					self.Entity:SetNoDraw(false)
					self.Recharging = false
				end)
			end
			
		end
	end
end*/

function ENT:Touch( v )
	if self.Recharging then return end

	if v:IsPlayer() then
		if self.PickupType == 1 then
			local hp = v:Health()
			if hp < v:GetPlayerClass().MaxHealth then
				v:SetHealth(math.Clamp(hp + 30,0,v:GetPlayerClass().MaxHealth))
				v:EmitSound("items/smallmedkit1.wav")
				self.Entity:SetNoDraw(true)
				self.Recharging = true
				timer.Simple(self.RechargeTime,function()
					if !self.Entity then return end
					self.Entity:SetNoDraw(false)
					self.Recharging = false
				end)
			end
		elseif self.PickupType == 2 then
			local n = v:GetActiveWeapon():GetPrimaryAmmoType()
			if self.AmmoTypes[n] then v:GiveAmmo(45,self.AmmoTypes[n]) end
			self.Recharging = true
			self.Entity:SetNoDraw(true)
			timer.Simple(self.RechargeTime,function()
				if !self.Entity then return end
				self.Entity:SetNoDraw(false)
				self.Recharging = false
			end)
		end
	end
end

function ENT:OnRemove()
	timer.Destroy(self.Entity:EntIndex().."angle")
end