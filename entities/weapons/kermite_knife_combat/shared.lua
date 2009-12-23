
if ( CLIENT ) then
	SWEP.PrintName			= "Combat Knife"	
	SWEP.Author				= "Kermite"
	SWEP.DrawAmmo 			= false
	SWEP.DrawCrosshair 		= false
	SWEP.ViewModelFOV			= 70
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes		= false
	
	SWEP.Slot				= 1
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "j"
end

SWEP.Base 				= "kermite_base_knife"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.ViewModel 				= "models/weapons/v_knife_c.mdl"
SWEP.WorldModel 			= "models/weapons/w_knife_y.mdl" 

SWEP.Weight					= 5
SWEP.AutoSwitchTo				= false
SWEP.AutoSwitchFrom			= false

SWEP.Primary.ClipSize			= -1
SWEP.Primary.Damage			= 100
SWEP.Primary.DefaultClip		= 1
SWEP.Primary.Automatic			= true
SWEP.Primary.Ammo				= "xbowbolt"

SWEP.Secondary.ClipSize			= -1
SWEP.Secondary.DefaultClip		= -1
SWEP.Secondary.Damage			= 100
SWEP.Secondary.Automatic		= false
SWEP.Secondary.Ammo			= "none"

SWEP.MissSound 				= Sound("weapons/knife/knife_slash1.wav")
SWEP.WallSound 				= Sound("weapons/knife/knife_hitwall1.wav")
SWEP.DeploySound				= Sound("weapons/knife/knife_deploy1.wav")

SWEP.IronSightsPos = Vector (-5.8847, -5.7766, -10.8509)
SWEP.IronSightsAng = Vector (31.9535, -10.905, 0.8913)





/*---------------------------------------------------------
SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()

	if self.Owner:GetAmmoCount(self.Primary.Ammo) <= 1 then return end

	self.Weapon:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
	self.Weapon:SetNextPrimaryFire(CurTime() + 1)
	self.Weapon:SetNextSecondaryFire(CurTime() + 1)
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	self.Owner:RemoveAmmo(1,self.Primary.Ammo)

	if SERVER then
		local knife = ents.Create("ent_comb")
		knife:SetAngles(self.Owner:EyeAngles())

		if (self:GetIronsights() == false) then
			local v = self.Owner:GetShootPos()
				v = v + self.Owner:GetForward() * 5
				v = v + self.Owner:GetRight() * 9
				v = v + self.Owner:GetUp() * -5
			knife:SetPos( v )
		else
			knife:SetPos (self.Owner:EyePos() + (self.Owner:GetAimVector()))
		end

		knife:SetOwner(self.Owner)
		knife:SetPhysicsAttacker(self.Owner)
		knife:Spawn()
		knife:Activate()

		self.Owner:SetAnimation( PLAYER_ATTACK1 )

		local phys = knife:GetPhysicsObject()
		phys:SetVelocity(self.Owner:GetAimVector() * 3000)
		phys:AddAngleVelocity(Vector(0, 500, 0))
	end
end


