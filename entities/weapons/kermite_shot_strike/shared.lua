-- Read the weapon_real_base if you really want to know what each action does

if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType 		= "smg"
end

if (CLIENT) then
	SWEP.PrintName 		= "Striker 12"
	SWEP.ViewModelFOV		= 70
	SWEP.Slot 			= 3
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "o"

	killicon.AddFont("weapon_real_cs_sg550", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ))
end

/*---------------------------------------------------------
Muzzle Effect + Shell Effect
---------------------------------------------------------*/
SWEP.MuzzleEffect			= "rg_muzzle_grenade" -- This is an extra muzzleflash effect
-- Available muzzle effects: rg_muzzle_grenade, rg_muzzle_highcal, rg_muzzle_hmg, rg_muzzle_pistol, rg_muzzle_rifle, rg_muzzle_silenced, none

SWEP.ShellEffect			= "rg_shelleject_shotgun" -- This is a shell ejection effect
-- Available shell eject effects: rg_shelleject, rg_shelleject_rifle, rg_shelleject_shotgun, none

SWEP.MuzzleAttachment		= "1" -- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment	= "2" -- Should be "2" for CSS models or "1" for hl2 models
/*-------------------------------------------------------*/

SWEP.Instructions 		= "Hold your use key and press secondary fire to change fire modes."

SWEP.Base 				= "kermite_base_shotgun_auto"
SWEP.Spawnable 			= true
SWEP.AdminSpawnable 		= true

SWEP.ViewModel 			= "models/weapons/v_shot_strike.mdl"
SWEP.WorldModel 			= "models/weapons/w_shot_strike.mdl"


SWEP.Primary.Sound 		= Sound("weapons/stiker/m3-2.wav")
SWEP.Primary.Recoil 		= 8
SWEP.Primary.Damage 		= 7.5
SWEP.Primary.NumShots 		= 15
SWEP.Primary.Cone 		= 0.045
SWEP.Primary.ClipSize 		= 12
SWEP.Primary.Delay 		= 0.25
SWEP.Primary.DefaultClip 	= 12
SWEP.Primary.Automatic 		= false
SWEP.Primary.Ammo 		= "buckshot"

SWEP.Secondary.ClipSize 	= -1
SWEP.Secondary.DefaultClip 	= -1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"


SWEP.IronSightsPos = Vector (3.8952, 0, 3.1029)
SWEP.IronSightsAng = Vector (-1.3984, 3.4063, 0)


SWEP.data 				= {}
SWEP.mode 				= "burst"
SWEP.data.newclip 		= false

SWEP.data.burst 			= {}
SWEP.data.burst.Delay 		= .3
SWEP.data.burst.Cone 		= 0.045
SWEP.data.burst.NumShots 	= 12
SWEP.data.burst.Damage 		= 7.5

SWEP.data.semi 			= {}
SWEP.data.semi.Delay 		= .3
SWEP.data.semi.Cone 		= 0.015
SWEP.data.semi.NumShots 	= 1
SWEP.data.semi.Damage 		= 77


