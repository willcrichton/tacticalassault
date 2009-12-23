-- Read the weapon_real_base if you really want to know what each action does

if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType 		= "pistol"
end

if (CLIENT) then
	SWEP.PrintName 		= "Stalker PB"
	SWEP.ViewModelFOV		= 70
	SWEP.Slot 			= 1
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "a"

	killicon.AddFont("weapon_real_cs_sg550", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ))
end

/*---------------------------------------------------------
Muzzle Effect + Shell Effect
---------------------------------------------------------*/
SWEP.MuzzleEffect			= "rg_muzzle_pistol" -- This is an extra muzzleflash effect
-- Available muzzle effects: rg_muzzle_grenade, rg_muzzle_highcal, rg_muzzle_hmg, rg_muzzle_pistol, rg_muzzle_rifle, rg_muzzle_silenced, none

SWEP.ShellEffect			= "rg_shelleject" -- This is a shell ejection effect
-- Available shell eject effects: rg_shelleject, rg_shelleject_rifle, rg_shelleject_shotgun, none

SWEP.MuzzleAttachment		= "1" -- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment	= "2" -- Should be "2" for CSS models or "1" for hl2 models
/*-------------------------------------------------------*/

SWEP.Instructions 		= "Hold your use key and press secondary fire to change fire modes."

SWEP.Base 				= "kermite_base_sil_pist"

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 		= true
SWEP.Weight			= 5

SWEP.ViewModel				= "models/weapons/v_pist_spb.mdl"
SWEP.WorldModel				= "models/weapons/w_pist_spb.mdl"
SWEP.Category			= "Kermite's Pistols Weapons"
SWEP.Primary.Sound 		= Sound("weapons/pb/usp_unsil-1.wav")
SWEP.Secondary.Sound 		= Sound("weapons/pb/usp1.wav")
SWEP.Primary.Damage 		= 20
SWEP.Primary.Recoil 		= 0.75
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 		= 0.015
SWEP.Primary.ClipSize 		= 8
SWEP.Primary.Delay 		= 0.05
SWEP.Primary.DefaultClip 	= 30
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		= "pistol"

SWEP.data 				= {}
SWEP.mode 				= "semi"


SWEP.data.semi 			= {}

SWEP.data.auto 			= {}



SWEP.IronSightsPos = Vector (3.7966, 0, 1.7345)
SWEP.IronSightsAng = Vector (0.8266, -0.1405, 0)




