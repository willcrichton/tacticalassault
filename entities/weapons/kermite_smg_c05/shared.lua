-- Read the weapon_real_base if you really want to know what each action does

if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType 		= "smg"
end

if (CLIENT) then
	SWEP.PrintName 		= "CF-05"
	SWEP.ViewModelFOV		= 70
	SWEP.Slot 			= 3
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "o"

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

SWEP.Instructions 		= "Hold your use key and press secondary fire to change fire modes.  \n \nModel/Skin Authors: \n \nModel: \nGun: Emperor, Lens: Twinke Masta \n Skin/UV: \n Gun: Emperor, Lens: Twinke Masta \n sound: VALVE \n Animations: VALVE(Edit by 3DStart) \n Compile: 3DStart"

SWEP.Base 				= "kermite_base_snip_smg"
SWEP.Category			= "Kermite's Submachineguns Weapons"
SWEP.Spawnable 			= true
SWEP.AdminSpawnable 		= true
SWEP.Weight			= 5

SWEP.ViewModel				= "models/weapons/v_smg_c05.mdl"
SWEP.WorldModel				= "models/weapons/w_smg_c05.mdl"

SWEP.Primary.Sound 		= Sound("weapons/cn79/79-1.wav")
SWEP.Primary.Damage 		= 15
SWEP.Primary.Recoil 		= 0.85
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 		= 0.035
SWEP.Primary.ClipSize 		= 53
SWEP.Primary.Delay 		= 0.05
SWEP.Primary.DefaultClip 	= 100
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		= "smg1"

SWEP.data 				= {}
SWEP.mode 				= "auto"


SWEP.data.semi 			= {}

SWEP.data.auto 			= {}

SWEP.IronSightsPos = Vector (1.2832, -18.0154, 1.21)
SWEP.IronSightsAng = Vector (-0.5592, 16.916, 0)

