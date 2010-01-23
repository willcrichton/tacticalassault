AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')


ENT.ExplosionDel = CurTime() + 1
ENT.ExplodeOnce = 0
ENT.EntAngs = NULL
ENT.lifeTime = CurTime() + 20;

function ENT:SpawnFunction( ply, tr ) 
 	ent:Spawn()
 	ent:Activate() 
 	ent.Owner = ply
	ent:GetPhysicsObject():SetMass(1)
	return ent 
	
end

function ENT:Initialize()


	self.Entity:SetModel("models/military2/bomb/bomb_cbu.mdl")
	self.Entity:SetOwner(self.Owner)
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)

	self.Entity:SetSolid(SOLID_VPHYSICS)	
    local phys = self.Entity:GetPhysicsObject()
	if(phys:IsValid()) then phys:Wake() end

	 	self.EntAngs = self.Entity:GetAngles()	
	
	util.SpriteTrail(self.Entity, 0, Color(200,200,200,255), false, 4, 0, 3, 1/(15+1)*0.5, "trails/smoke.vmt")

	self.lifeTime = CurTime() + 20;
end

-------------------------------------------PHYS COLLIDE
function ENT:PhysicsCollide( data, phys ) 
	ent = data.HitEntity
	
	if self.ExplosionDel < CurTime() then
		self.Entity:SetCollisionGroup( 3 )
	end
	
	if self.ExplodeOnce == 0 then
		self.ExplodeOnce = 1
		local expl = ents.Create("env_explosion")
		expl:SetKeyValue("spawnflags",128)
		expl:SetPos(self.Entity:GetPos())
		expl:Spawn()
		expl:Fire("explode","",0)
		
		local FireExp = ents.Create("env_physexplosion")
		FireExp:SetPos(self.Entity:GetPos())
		FireExp:SetParent(self.Entity)
		FireExp:SetKeyValue("magnitude", 500)
		FireExp:SetKeyValue("radius", 600)
		FireExp:SetKeyValue("spawnflags", "1")
		FireExp:Spawn()
		FireExp:Fire("Explode", "", 0)
		FireExp:Fire("kill", "", 5)
		util.BlastDamage( self.Entity, self.Entity, self.Entity:GetPos(), 400, 100)
		
		local effectdata = EffectData()
		effectdata:SetOrigin( self.Entity:GetPos() )
		effectdata:SetStart( Vector(0,0,90) )
		util.Effect( "jetbomb_explosion", effectdata )		
		
		util.ScreenShake( self.Entity:GetPos(), 15, 15, 0.5, 2000 )
		
		self.Entity:Remove()
	end
end
-------------------------------------------PHYSICS =D
function ENT:PhysicsUpdate( physics )

	local entphys = self.Entity:GetPhysicsObject()

	phys = self.Entity:GetPhysicsObject()
	local veloc = phys:GetVelocity()

	local AimVec = self.Entity:GetVelocity():Normalize():Angle( )					
	
	self.EntAngs.p = math.ApproachAngle( self.EntAngs.p, AimVec.p, 0.5 )
	self.EntAngs.r = math.ApproachAngle( self.EntAngs.r, AimVec.r, 0.5 )
	self.EntAngs.y = math.ApproachAngle( self.EntAngs.y, AimVec.y, 0.5 )
	self.Entity:SetAngles( self.EntAngs )									

	phys:SetVelocity(veloc)		
			
end
-------------------------------------------DAMAGE
function ENT:OnTakeDamage(dmg)

	if self.ExplosionDel < CurTime() && not(dmg:IsExplosionDamage()) then
		self.Entity:SetCollisionGroup( 3 )
	end

	if self.ExplosionDel < CurTime() and self.ExplodeOnce == 0 && not(dmg:IsExplosionDamage()) then
		self.ExplodeOnce = 1
		local expl = ents.Create("env_explosion")
		expl:SetKeyValue("spawnflags",128)
		expl:SetPos(self.Entity:GetPos())
		expl:Spawn()
		expl:Fire("explode","",0)
		
		local FireExp = ents.Create("env_physexplosion")
		FireExp:SetPos(self.Entity:GetPos())
		FireExp:SetParent(self.Entity)
		FireExp:SetKeyValue("magnitude", 500)
		FireExp:SetKeyValue("radius", 500)
		FireExp:SetKeyValue("spawnflags", "1")
		FireExp:Spawn()
		FireExp:Fire("Explode", "", 0)
		FireExp:Fire("kill", "", 5)
		util.BlastDamage( self.Entity, self.Entity, self.Entity:GetPos(), 400, 100)

		local effectdata = EffectData()
		effectdata:SetOrigin( self.Entity:GetPos() )
		effectdata:SetStart( Vector(0,0,90) )
		util.Effect( "jetbomb_explosion", effectdata )			

		util.ScreenShake( self.Entity:GetPos(), 15, 15, 0.5, 2000 )		
	
		local nor = self.Entity:GetVelocity():Normalize()
		
		self.Entity:Remove()
	end
end

-------------------------------------------THINK
function ENT:Think()
	local entphys = self.Entity:GetPhysicsObject()

		entphys:Wake()

	if self.ExplosionDel < CurTime() then
	self.Entity:SetCollisionGroup( 3 )
	end
		
		
	if self.lifeTime < CurTime() then
		self.Entity:Remove()
	end
		
end
