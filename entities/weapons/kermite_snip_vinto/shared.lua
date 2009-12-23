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
	SWEP.PrintName 		= "VSS Vintorez"
	SWEP.ViewModelFOV		= 70
	SWEP.Slot 			= 3
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "w"

	killicon.AddFont("weapon_real_cs_m4a1", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ))
end

SWEP.Instructions 		= "Hold your use key and press secondary fire to change fire modes."

SWEP.Base 				= "kermite_base_snip"
SWEP.Category			= "Kermite's Sniper Rifles Weapons"
SWEP.Spawnable 			= true
SWEP.AdminSpawnable 		= true

SWEP.ViewModel				= "models/weapons/v_snip_vinto.mdl"
SWEP.WorldModel				= "models/weapons/w_snip_vinto.mdl"


SWEP.Primary.Sound			= Sound("weapons/vintor/g3sg1-1.wav")

SWEP.Primary.Damage 		= 20
SWEP.Primary.Recoil 		= 1.5
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 		= 0.0012
SWEP.Primary.ClipSize 		= 20		
SWEP.Primary.Delay 		= 0.18
SWEP.Primary.DefaultClip 	= 60
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		= "smg1"

SWEP.IronSightZoom 			= 1.8
SWEP.ScopeZooms				= {2}






SWEP.IronSightsPos = Vector (0.2301, 0, -5.0961)
SWEP.IronSightsAng = Vector (-9.4599, 0.3032, 0)








SWEP.data 				= {}
SWEP.mode 				= "semi"

SWEP.data.semi 			= {}

SWEP.data.auto 			= {}
