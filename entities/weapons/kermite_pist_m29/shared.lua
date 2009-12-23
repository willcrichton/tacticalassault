-- Read the weapon_real_base if you really want to know what each action does

if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType 		= "pistol"
end

if (CLIENT) then
	SWEP.PrintName 		= "M29 Satan Deux"
	SWEP.ViewModelFOV		= 70
	SWEP.Slot 			= 1
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "f"

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

SWEP.Base 				= "kermite_base_pistol"

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 		= true
SWEP.Weight			= 5

SWEP.ViewModel				= "models/weapons/v_pist_swem29.mdl"
SWEP.WorldModel				= "models/weapons/w_pist_swem29.mdl"
SWEP.Category			= "Kermite's Pistols Weapons"
SWEP.Primary.Sound 		= Sound("weapons/m29/deagle-1.wav")
SWEP.Primary.Damage 		= 100
SWEP.Primary.Recoil 		= 19.75
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 		= 0.017
SWEP.Primary.ClipSize 		= 6
SWEP.Primary.Delay 		= 0.8
SWEP.Primary.DefaultClip 	= 12
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		= "357"

SWEP.data 				= {}
SWEP.mode 				= "semi"


SWEP.data.semi 			= {}

SWEP.data.auto 			= {}

SWEP.IronSightsPos = Vector (2.2604, -1.2921, 1.1346)
SWEP.IronSightsAng = Vector (0.3571, -0.1082, 0)



function SWEP:Reload()

	self.Weapon:DefaultReload(ACT_VM_RELOAD) 
	-- Animation when you're reloading

	if ( self.Weapon:Clip1() < self.Primary.ClipSize ) and self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
	-- When the current clip < full clip and the rest of your ammo > 0, then

		self.Owner:SetFOV( 0, 0.15 )
		-- Zoom = 0

		self:SetIronsights(false)
		-- Set the ironsight to false
self.Weapon:EmitSound("weapons/m29/reload.wav")
end
	
end


function SWEP:Deploy()

	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	
self.Weapon:EmitSound("weapons/m29/draw.wav")
	self.Reloadaftershoot = CurTime() + 1
	self.Weapon:SetNextPrimaryFire(CurTime() + 1)

	return true
end



