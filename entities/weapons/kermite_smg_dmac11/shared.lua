-- Read the weapon_real_base if you really want to know what each action does

if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType 		= "pistol"
end

if (CLIENT) then
	SWEP.PrintName 		= "Dual Mac-11's"
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

SWEP.Instructions 		= "Hold your use key and press secondary fire to change fire modes.  \n \nModel/Skin Authors: \n \n Model- Kimono \n Skin- Enron \n Normals/Phong: Grimm AKA T3hReap3r \n Animations- Powerskull \n Compile- Powerskull \n Sounds- Valve/Vunsunta?/Anti-Paladin?/iFlip?"

SWEP.Base 				= "kermite_base_smg_dual"
SWEP.Category			= "Kermite's Submachineguns Weapons"
SWEP.Spawnable 			= true
SWEP.AdminSpawnable 		= true
SWEP.Weight			= 5
SWEP.ViewModel				= "models/weapons/v_smg_dmac11.mdl"
SWEP.WorldModel				= "models/weapons/w_smg_dmac11.mdl"

local clip1, clip2
clip1 				= 16
clip2 				= 16

SWEP.Primary.Sound 		= Sound("weapons/mac11/elite-1.wav")
SWEP.Primary.Damage 		= 15
SWEP.Primary.Recoil 		= 0.35
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 		= 0.025
SWEP.Primary.ClipSize 		= 32
SWEP.Primary.Delay 		= 0.02
SWEP.Primary.DefaultClip 	= 70
SWEP.Primary.Automatic 		= true
SWEP.Secondary.Automatic 		= true
SWEP.Primary.Ammo 		= "smg1"

SWEP.data 				= {}
SWEP.mode 				= "auto"


SWEP.data.semi 			= {}

SWEP.data.auto 			= {}

SWEP.IronSightsPos = Vector (3.8636, -4.4101, 1.3444)
SWEP.IronSightsAng = Vector (0, 0, 0)


/*---------------------------------------------------------
Think
---------------------------------------------------------*/
function SWEP:Think()

	if self.Owner:KeyPressed(IN_ATTACK) and self.Weapon:Clip1() > 0 and self:CanClip1Attack()  then
	-- When the left click is pressed, then
		self.ViewModelFlip = true
	end

	if self.Owner:KeyPressed(IN_ATTACK2) and self.Weapon:Clip1() > 0 and self:CanClip2Attack() then
	-- When the right click is pressed, then
		self.ViewModelFlip = false
	end
end

/*---------------------------------------------------------
PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()


	if not self:CanClip1Attack() or not self:CanPrimaryAttack() or self.Owner:WaterLevel() > 2 then return end
	-- If your gun have a problem or if you are under water, you'll not be able to fire

	self.Reloadaftershoot = CurTime() + self.Primary.Delay
	-- Set the reload after shoot to be not able to reload when firering

	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	-- Set next secondary fire after your fire delay

	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay - 0.1)
	-- Set next secondary fire after your fire delay

	self.Weapon:EmitSound(self.Primary.Sound)
	-- Emit the gun sound when you fire

	self:RecoilPower()

	clip1 = clip1 - 1
	-- Take 1 ammo in your clip

	if clip1 >= 0 then
		self:TakePrimaryAmmo(1)
		-- Take 1 ammo in you clip
	end

	if ((SinglePlayer() and SERVER) or CLIENT) then
		self.Weapon:SetNetworkedFloat("LastShootTime", CurTime())
	end
end

/*---------------------------------------------------------
SecondaryAttack
---------------------------------------------------------*/

function SWEP:SecondaryAttack()


	if not self:CanClip2Attack() or not self:CanPrimaryAttack() or self.Owner:WaterLevel() > 2 then return end
	-- If your gun have a problem or if you are under water, you'll not be able to fire

	self.Reloadaftershoot = CurTime() + self.Primary.Delay
	-- Set the reload after shoot to be not able to reload when firering

	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay - 0.1)
	-- Set next secondary fire after your fire delay

	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	-- Set next secondary fire after your fire delay

	self.Weapon:EmitSound(self.Primary.Sound)
	-- Emit the gun sound when you fire

	self:RecoilPower()

	clip2 = clip2 - 1
	-- Take 1 ammo in your clip

	if clip2 >= 0 then
		self:TakePrimaryAmmo(1)
		-- Take 1 ammo in you clip
	end

	if ((SinglePlayer() and SERVER) or CLIENT) then
		self.Weapon:SetNetworkedFloat("LastShootTime", CurTime())
	end
end

/*---------------------------------------------------------
Reload
---------------------------------------------------------*/
function SWEP:Reload()

	if ( self.Reloadaftershoot > CurTime() ) then return end 
	-- If you're firering, you can't reload
if ( self.Weapon:Clip1() >= self.Primary.ClipSize ) then return end

	self.Weapon:DefaultReload(ACT_VM_RELOAD) 
self.Weapon:EmitSound("weapons/mac11/magrel2.wav")
	-- Animation when you're reloading

	if ( self.Weapon:Clip1() < self.Primary.ClipSize ) and self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then

		timer.Simple(2, function()
			clip1 = 16
			clip2 = 16
		end)
	end
end

/*---------------------------------------------------------
Deploy
---------------------------------------------------------*/
function SWEP:Deploy()

	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	-- Set the deploy animation when deploying

	self.Weapon:SetNextPrimaryFire(CurTime() + 1)
	-- Set the next primary fire to 1 second after deploying

	self.Weapon:SetNextSecondaryFire(CurTime() + 1)
	-- Set the next primary fire to 1 second after deploying

	if ( self.Weapon:Clip1() == 16 ) then
		clip1 = 16
		clip2 = 16
	end

	return true
end



/*---------------------------------------------------------
CanClip1Attack
---------------------------------------------------------*/
function SWEP:CanClip1Attack()
	if clip1 <= 0 and self.Primary.ClipSize > -1 then
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
		self.Weapon:EmitSound("Weapons/ClipEmpty_Pistol.wav")
		clip1 = 0
		return false
	end

	return true
end

/*---------------------------------------------------------
CanClip2Attack
---------------------------------------------------------*/
function SWEP:CanClip2Attack()
	if clip2 <= 0 and self.Primary.ClipSize > -1 then
		self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)
		self.Weapon:EmitSound("Weapons/ClipEmpty_Pistol.wav")
		clip2 = 0
		return false
	end

	return true
end
