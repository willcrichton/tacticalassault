-- Read the weapon_real_base if you really want to know what each action does

/*---------------------------------------------------------*/
local HitImpact = function(attacker, tr, dmginfo)

	local hit = EffectData()
	hit:SetOrigin(tr.HitPos)
	hit:SetNormal(tr.HitNormal)
	hit:SetScale(20)
	util.Effect("effect_hit", hit)

	return true
end
/*---------------------------------------------------------*/

if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType = "ar2"
end

if (CLIENT) then
	SWEP.PrintName 		= "Artic Warfare Magnum"
	SWEP.ViewModelFOV		= 70
	SWEP.Slot 			= 3
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "w"

	killicon.AddFont("weapon_real_cs_m4a1", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ))
end

SWEP.Instructions 		= "Hold your use key and press secondary fire to change fire modes."

SWEP.Base 				= "kermite_base_snip_3030"

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 		= true
SWEP.Category			= "Kermite's Sniper Rifles Weapons"
SWEP.ViewModel				= "models/weapons/v_snip_awm.mdl"
SWEP.WorldModel				= "models/weapons/w_snip_awm.mdl"


SWEP.Primary.Sound			= Sound("weapons/awm/awmfire3.wav")

SWEP.Primary.Damage 		= 100
SWEP.Primary.Recoil 		= 7.5
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 		= 0.0012
SWEP.Primary.ClipSize 		= 5
SWEP.Primary.Delay 		= 2.0
SWEP.Primary.DefaultClip 	= 30
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		= "smg1"

SWEP.IronSightZoom 			= 1.8
SWEP.ScopeZooms				= {5,8}



SWEP.IronSightsPos = Vector (-3.1081, -19.6773, -1.0485)
SWEP.IronSightsAng = Vector (0, 0, 0)



function SWEP:SecondaryAttack()
if !self.Owner:KeyDown(IN_USE) then
	
	
	bIronsights = !self.Weapon:GetNetworkedBool( "Ironsights", false )
	
	self:SetIronsights( bIronsights )
	
	self.NextSecondaryAttack = CurTime() + 0.3

end
	if self.Owner:KeyDown(IN_USE) then
	-- When you're pressing E + Right click, then

		if self.mode == "semi" then
			self.mode = "semi"
			self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)
		else
			self.mode = "semi"
			self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)
		end
		self.data[self.mode].Init(self)
	end
end


function SWEP:Reload()

	if ( self.Reloadaftershoot > CurTime() ) then return end 
	-- If you're firering, you can't reload
if ( self.Weapon:Clip1() >= self.Primary.ClipSize ) then return end

	self.Weapon:DefaultReload(ACT_VM_RELOAD) 
self.Weapon:EmitSound("weapons/awm/magrel2.wav")

	-- Animation when you're reloading

	if ( self.Weapon:Clip1() < self.Primary.ClipSize ) and self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
	-- When the current clip < full clip and the rest of your ammo > 0, then

		self.Owner:SetFOV( 0, 0.15 )
		-- Zoom = 0

		self:SetIronsights(false)
		-- Set the ironsight to false
	end
end






SWEP.data 				= {}
SWEP.mode 				= "semi"

SWEP.data.semi 			= {}

SWEP.data.auto 			= {}
