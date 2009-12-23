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
	SWEP.PrintName 		= "M-24"
	SWEP.ViewModelFOV		= 70
	SWEP.Slot 			= 3
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "w"

	killicon.AddFont("weapon_real_cs_m4a1", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ))
end

SWEP.Instructions 		= "Hold your use key and press secondary fire to change fire modes."

SWEP.Base 				= "kermite_base_snip_mildot2"
SWEP.Category			= "Kermite's Sniper Rifles Weapons"
SWEP.Spawnable 			= true
SWEP.AdminSpawnable 		= true

SWEP.ViewModel				= "models/weapons/v_snip_m24_6.mdl"
SWEP.WorldModel				= "models/weapons/w_snip_m24_6.mdl"


SWEP.Primary.Sound			= Sound("weapons/m24/m25.wav")

SWEP.Primary.Damage 		= 50
SWEP.Primary.Recoil 		= 1.0
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 		= 0.0010
SWEP.Primary.ClipSize 		= 10
SWEP.Primary.Delay 		= 1.518
SWEP.Primary.DefaultClip 	= 30
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		= "smg1"

SWEP.IronSightZoom 			= 1.8
SWEP.ScopeZooms				= {5}





SWEP.IronSightsPos = Vector (-2.8576, 0, -6.1133)
SWEP.IronSightsAng = Vector (-1.3309, 22.259, -0.0064)






function SWEP:Reload()

	if ( self.Reloadaftershoot > CurTime() ) then return end 
	-- If you're firering, you can't reload
if ( self.Weapon:Clip1() >= self.Primary.ClipSize ) then return end

	self.Weapon:DefaultReload(ACT_VM_RELOAD) 
self.Weapon:EmitSound("weapons/m24/magrel.wav")

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
