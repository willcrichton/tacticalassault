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
	SWEP.PrintName 		= "HK G36 Sniper"
	SWEP.ViewModelFOV		= 70
	SWEP.Slot 			= 3
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "w"

	killicon.AddFont("weapon_real_cs_m4a1", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ))
end

SWEP.Instructions 		= "Hold your use key and press secondary fire to change fire modes."

SWEP.Base 				= "kermite_base_snip_mildot"
SWEP.Category			= "Kermite's Sniper Rifles Weapons"
SWEP.Spawnable 			= true
SWEP.AdminSpawnable 		= true

SWEP.ViewModel				= "models/weapons/v_snip_hks18.mdl"
SWEP.WorldModel				= "models/weapons/w_snip_hks18.mdl"


SWEP.Primary.Sound			= Sound("weapons/hks/18.wav")

SWEP.Primary.Damage 		= 50
SWEP.Primary.Recoil 		= 5.5
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 		= 0.0052
SWEP.Primary.ClipSize 		= 10
SWEP.Primary.Delay 		= 0.48
SWEP.Primary.DefaultClip 	= 30
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		= "smg1"

SWEP.IronSightZoom 			= 1.8
SWEP.ScopeZooms				= {3}





SWEP.IronSightsPos = Vector (3.4979, -18.8359, 0.919)
SWEP.IronSightsAng = Vector (0.337, -0.6378, 24.933)








SWEP.data 				= {}
SWEP.mode 				= "semi"

SWEP.data.semi 			= {}

SWEP.data.auto 			= {}
