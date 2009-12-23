-- Read the weapon_real_base if you really want to know what each action does

if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType 		= "smg"
end

if (CLIENT) then
	SWEP.PrintName 		= "AR-57"
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

SWEP.Instructions 		= "Hold your use key and press secondary fire to change fire modes.  \n \nModel/Skin Authors: \n \n Model: Twinke Masta (reciever), General Tso (vert grip), Soul Slayer (silencer), SureShot (rest of it) \n Textures: Vile, SilentAssassin12(vert grip and silencer) \n Sounds: Valve, Vunsunta \n Animations and Compile: SilentAssassin12"

SWEP.Base 				= "kermite_base_burst_spec"
SWEP.Category			= "Kermite's Submachineguns Weapons"
SWEP.Spawnable 			= true
SWEP.AdminSpawnable 		= true
SWEP.Weight			= 5

SWEP.ViewModel				= "models/weapons/v_smg_ar5.mdl"
SWEP.WorldModel				= "models/weapons/w_smg_p99.mdl"

SWEP.Primary.Sound 		= Sound("weapons/ar57/p90-1.wav")
SWEP.Primary.Damage 		= 20
SWEP.Primary.Recoil 		= 0.75
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 		= 0.025
SWEP.Primary.ClipSize 		= 30
SWEP.Primary.Delay 		= 0.05
SWEP.Primary.DefaultClip 	= 30
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		= "smg1"

SWEP.data 				= {}
SWEP.mode 				= "auto"


SWEP.data.semi 			= {}

SWEP.data.auto 			= {}


SWEP.IronSightsPos = Vector (4.2114, -3.3574, 1.7486)
SWEP.IronSightsAng = Vector (0.6836, -0.1299, 0)
