if (SERVER) then
	AddCSLuaFile("shared.lua")
	AddCSLuaFile("cl_init.lua")
	
	SWEP.Weight = 1
end

if (CLIENT) then

	SWEP.PrintName = "TECH CONSTRUCTOR"
	SWEP.Slot = 3
	SWEP.SlotPos = 2
	SWEP.DrawAmmo = false
	
	if (file.Exists("../materials/weapons/weapon_techie.vmt")) then
		SWEP.WepSelectIcon	= surface.GetTextureID("weapons/weapon_techie")
	end

end

 SWEP.Author = "Entoros"; 
 SWEP.Contact = ""; 
 SWEP.Purpose = "Create technology"; 
 SWEP.Instructions = "Primary: Popup menu + Make buildings\nSecondary: Remove buildings"
 SWEP.Base = "weapon_ta_base";
 
 SWEP.Spawnable = false
 SWEP.AdminSpawnable = true;
   
SWEP.ViewModel		= "models/weapons/v_toolgun.mdl"
SWEP.WorldModel		= "models/weapons/w_toolgun.mdl"

 SWEP.Primary.ClipSize = -1; 
 SWEP.Primary.DefaultClip = -1; 
 SWEP.Primary.Automatic = false; 
 SWEP.Primary.Ammo = "none";
 SWEP.Secondary.Ammo = "none";
 
 SWEP.RunAng = Angle(20,0,0)
 SWEP.RunPos = Vector(0,0,4)
 SWEP.types = {
	[1] = { 
		model = "models/props_lab/blastdoor001b.mdl",
		health = 250,
		buildtime = 5,
		height = 106.146,
		},
	[2] = {
		model = "models/props_lab/blastdoor001c.mdl",
		health = 500,
		buildtime = 10,
		height = 106.146,
		},
	[3]  = {
		model = "models/props_wasteland/cargo_container01b.mdl",
		health = 1000,
		buildtime = 15,
		height = 127.290,
		raiseup = 55,
		}
}

SWEP.build_sounds = {
	Sound("ta/build/build1.mp3"),
	Sound('ta/build/build2.wav'),
}
 
 function SWEP:Initialize()
	self.Yaw = 0
	self.GhostEntity = nil
end

function SWEP:Holster()

	if self.GhostEntity then
		self.GhostEntity:Remove()
		self.GhostEntity = nil
	end

	return true
end

function SWEP:PrimaryAttack()
	
	if !self:CanPrimaryAttack() || CLIENT then return end
	
	if self.GhostEntity then
	
		local barrier_count = self.Owner:GetNWInt("ta-barriercount")
		local tr = self.Owner:GetEyeTrace()
		local dist = tr.HitPos:Distance(self.Owner:GetPos())
	
		if barrier_count >= 4 then 
			
			self.Owner:ChatPrint("You already have four barriers!")
			
		elseif dist > 300 || tr.HitNonWorld || math.abs(tr.HitPos.z - self.Owner:GetPos().z) > 30 then
			
			self.Owner:ChatPrint("That is not a valid location.")
			
		else
			
			local barr = ents.Create("ent_barrier")
			barr:SetType(self.GhostEntity:GetNWInt("Type"),self.Owner,self.GhostEntity:GetNWInt("RaiseUp"))
			barr:SetPos(self.GhostEntity:GetPos())
			barr:SetAngles(self.GhostEntity:GetAngles())
		
			barr:Spawn()
			barr:Activate()
			barr:SetNWEntity("ta-owner",self.Owner)
			
			self.Owner:SetNWInt("ta-barriercount",barrier_count + 1)
			self.Owner:EmitSound(table.Random(self.build_sounds))
			
		end
		
		self.GhostEntity:Remove()
		self.GhostEntity = nil
		self.Yaw = 0
		
	else
		umsg.Start("Techie-ShowMenu",self.Owner) umsg.End()
	end
	
end
	
function SWEP:SecondaryAttack()

	if !self:CanPrimaryAttack() || CLIENT then return end
	
	local tr = self.Owner:GetEyeTrace()
	local ent = tr.Entity
	
	if ent:GetClass() == "ent_barrier" then
		self.Owner:SetNWInt("ta-barriercount",self.Owner:GetNWInt("ta-barriercount") - 1)
		ent:Remove()
	elseif ent == self.Owner:GetNWEntity("ta-turret") then
		ent:Remove()
		self.Owner:SetNWEntity("ta-turret",nil)
	end
	
end

function SWEP:Think()
	
	if CLIENT then return end
	
	self:UpdateGhost()
	
end

function SWEP:MakeGhost( n )
	self.GhostEntity = ents.Create( "prop_physics" )
	
	if (!self.GhostEntity:IsValid()) then
		self.GhostEntity = nil
		return
	end
	
	local info = self.types[n]
	
	self.GhostEntity:SetModel( info.model )
	self.GhostEntity:SetNWInt("RaiseUp",info.raiseup)
	self.GhostEntity:SetNWInt("Type",n)
	self.GhostEntity:SetPos( self.Owner:GetEyeTrace().HitPos + Vector(0,0,raiseup))
	self.GhostEntity:Spawn()
	
	self.GhostEntity:SetSolid( SOLID_VPHYSICS );
	self.GhostEntity:SetMoveType( MOVETYPE_NONE )
	self.GhostEntity:SetNotSolid( true );
	self.GhostEntity:SetRenderMode( RENDERMODE_TRANSALPHA )
	self.GhostEntity:SetColor( 255, 255, 255, 200 )
end

function SWEP:UpdateGhost()

	if (self.GhostEntity == nil) then return end
	if (!self.GhostEntity:IsValid()) then self.GhostEntity = nil return end

	local tr = self.Owner:GetEyeTrace()
	local dist =tr.HitPos:Distance(self.Owner:GetPos())
	local cent,min,max = self.GhostEntity:OBBCenter(),self.GhostEntity:OBBMins(),self.GhostEntity:OBBMaxs()
	
	if dist < 300 && !tr.HitNonWorld && math.abs(tr.HitPos.z - self.Owner:GetPos().z) < 30 then
		self.GhostEntity:SetColor( 50, 255, 50, 200 )
	else
		self.GhostEntity:SetColor( 255, 50, 50, 200 )
	end
	
	if self.Owner:KeyDown(IN_USE) then self.Yaw = self.Yaw + 1 end
	
	self.GhostEntity:SetAngles( Angle(0,self.Owner:GetForward():Angle().yaw + self.Yaw,0) )
	
	self.GhostEntity:SetPos( self.Owner:GetEyeTrace().HitPos + Vector(0,0,self.GhostEntity:GetNWInt("RaiseUp")) )
	
end