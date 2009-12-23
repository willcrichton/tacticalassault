-- Read the weapon_real_base if you really want to know what each action does

if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType 		= "smg"
end

if (CLIENT) then
	SWEP.PrintName 		= "Mp-5k"
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

SWEP.Instructions 		= "Hold your use key and press secondary fire to change fire modes.  \n \nModel/Skin Authors: \n \n Model: Short_fuse \n Stock Model: Andrew \n Foregrip Model: Stoke \n Vertical Grip Model: Sas.Stu \n Barell Model: Firegold \n Bullet Model: Stoke \n Frame And Vertical Grip skin: Creeping_jesus \n Bullet/Scope/Stock And Foregrip Skin: Stoke \n Barell Skin: Thor \n Animations: Valve \n Sounds: Henrik A.K.A. Hk and Blueguile \n Model Hackage: candied_clown \n CS:S Compile: candied_clown"

SWEP.Base 				= "kermite_base_smg"
SWEP.Category			= "Kermite's Submachineguns Weapons"
SWEP.Spawnable 			= true
SWEP.AdminSpawnable 		= true
SWEP.Weight			= 5
SWEP.ViewModel				= "models/weapons/v_smg_mpk.mdl"
SWEP.WorldModel				= "models/weapons/w_smg_mpk.mdl"

SWEP.Primary.Sound 		= Sound("weapons/mp5k/mp5-1.wav")
SWEP.Primary.Damage 		= 15
SWEP.Primary.Recoil 		= 0.75
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 		= 0.025
SWEP.Primary.ClipSize 		= 30
SWEP.Primary.Delay 		= 0.035
SWEP.Primary.DefaultClip 	= 30
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		= "smg1"

SWEP.data 				= {}
SWEP.mode 				= "auto"


SWEP.data.semi 			= {}

SWEP.data.auto 			= {}


SWEP.IronSightsPos = Vector (2.9323, -4.5518, 0.8902)
SWEP.IronSightsAng = Vector (0, 0, 0)



function SWEP:Reload()

	if ( self.Reloadaftershoot > CurTime() ) then return end 
	-- If you're firering, you can't reload
if ( self.Weapon:Clip1() >= self.Primary.ClipSize ) then return end

	self.Weapon:DefaultReload(ACT_VM_RELOAD) 
self.Weapon:EmitSound("weapons/mp5k/magrel.wav")

	-- Animation when you're reloading

	if ( self.Weapon:Clip1() < self.Primary.ClipSize ) and self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
	-- When the current clip < full clip and the rest of your ammo > 0, then

		self.Owner:SetFOV( 0, 0.15 )
		-- Zoom = 0

		self:SetIronsights(false)
		-- Set the ironsight to false
	end
end

