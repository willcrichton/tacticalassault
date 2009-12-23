-- Read the weapon_real_base if you really want to know what each action does

if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType 		= "ar2"
end

if (CLIENT) then
	SWEP.PrintName 		= "M4-CMAG"
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

SWEP.ViewModel				= "models/weapons/v_mach_m4_c-mag.mdl"
SWEP.WorldModel				= "models/weapons/w_mach_m4_c-mag.mdl"
SWEP.Category			= "Kermite's Machineguns Weapons"
SWEP.Primary.Sound			= Sound("weapons/m4-cmag/m249-1.wav")
SWEP.Primary.Recoil 		= 1
SWEP.Primary.Damage 		= 30
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 		= 0.035
SWEP.Primary.ClipSize 		= 100
SWEP.Primary.Delay 		= 0.08
SWEP.Primary.DefaultClip 	= 200
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		= "smg1"

SWEP.Secondary.ClipSize 	= -1
SWEP.Secondary.DefaultClip 	= -1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

SWEP.IronSightsPos = Vector (-3.0674, -5.024, 0.6172)
SWEP.IronSightsAng = Vector (-0.0157, 0.1045, 0)


function SWEP:Reload()

	self.Weapon:DefaultReload(ACT_VM_RELOAD) 
	-- Animation when you're reloading

	if ( self.Weapon:Clip1() < self.Primary.ClipSize ) and self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
	-- When the current clip < full clip and the rest of your ammo > 0, then

		self.Owner:SetFOV( 0, 0.15 )
		-- Zoom = 0

		self:SetIronsights(false)
		-- Set the ironsight to false
self.Weapon:EmitSound("weapons/m4-cmag/rel2.wav")
end
	
end

