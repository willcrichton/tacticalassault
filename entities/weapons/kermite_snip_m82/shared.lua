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
	SWEP.PrintName 		= "Barrett M-82"
	SWEP.ViewModelFOV		= 70
	SWEP.Slot 			= 3
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "w"

	killicon.AddFont("weapon_real_cs_m4a1", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ))
end

SWEP.Instructions 		= "Hold your use key and press secondary fire to change fire modes."

SWEP.Base 				= "kermite_base_snip_bart"

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 		= true
SWEP.Category			= "Kermite's Sniper Rifles Weapons"
SWEP.ViewModel				= "models/weapons/v_snip_m82.mdl"
SWEP.WorldModel				= "models/weapons/w_snip_m82.mdl"


SWEP.Primary.Sound			= Sound("weapons/m82/m82.wav")

SWEP.Primary.Damage 		= 69
SWEP.Primary.Recoil 		= 15
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 		= 0.0012
SWEP.Primary.ClipSize 		= 10
SWEP.Primary.Delay 		= 0.68
SWEP.Primary.DefaultClip 	= 30
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		= "smg1"

SWEP.IronSightZoom 			= 1.8
SWEP.ScopeZooms				= {6}



SWEP.IronSightsPos = Vector (0.9779, -29.4471, 0.0766)
SWEP.IronSightsAng = Vector (-0.8411, 9.9905, 0)




function SWEP:Reload()

	if ( self.Reloadaftershoot > CurTime() ) then return end 
	-- If you're firering, you can't reload
if ( self.Weapon:Clip1() >= self.Primary.ClipSize ) then return end

	self.Weapon:DefaultReload(ACT_VM_RELOAD) 
self.Weapon:EmitSound("weapons/m82/magrel2.wav")

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
