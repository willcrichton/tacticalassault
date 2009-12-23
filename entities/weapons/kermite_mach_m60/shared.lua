-- Read the weapon_real_base if you really want to know what each action does

if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType 		= "ar2"
end

if (CLIENT) then
	SWEP.PrintName 		= "M-60"
	SWEP.Slot 			= 3
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "z"
	SWEP.ViewModelFlip	= false

	killicon.AddFont("weapon_real_cs_m249", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ))
end

/*---------------------------------------------------------
Muzzle Effect
---------------------------------------------------------*/
SWEP.MuzzleEffect			= "rg_muzzle_highcal" -- This is an extra muzzleflash effect
-- Available muzzle effects: rg_muzzle_grenade, rg_muzzle_highcal, rg_muzzle_hmg, rg_muzzle_pistol, rg_muzzle_rifle, rg_muzzle_silenced, none
/*-------------------------------------------------------*/

SWEP.Instructions 		= "Damage: 30% \nRecoil: 10% \nPrecision: 85% \nType: Automatic \nRate of Fire: 800 rounds per minute"

SWEP.Base 				= "kermite_base_rifle"

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 		= true

SWEP.ViewModel				= "models/weapons/v_mach_m60anim1.mdl"
SWEP.WorldModel				= "models/weapons/w_mach_m60anim1.mdl"
SWEP.Category			= "Kermite's Machineguns Weapons"
SWEP.Primary.Sound			= Sound("weapons/m60/m60.wav")
SWEP.Primary.Recoil 		= 1
SWEP.Primary.Damage 		= 30
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 		= 0.035
SWEP.Primary.ClipSize 		= 200
SWEP.Primary.Delay 		= 0.095
SWEP.Primary.DefaultClip 	= 200
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		= "smg1"

SWEP.Secondary.ClipSize 	= -1
SWEP.Secondary.DefaultClip 	= -1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"


SWEP.IronSightsPos = Vector (-4.7695, -5.1505, 0.1146)
SWEP.IronSightsAng = Vector (0.938, 0.7515, 0)


