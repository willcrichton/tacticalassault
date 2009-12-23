if (SERVER) then
	AddCSLuaFile("shared.lua")
	
	SWEP.Weight = 1
	SWEP.HoldType = "slam"
end

if (CLIENT) then

	SWEP.PrintName = "Resupply"
	SWEP.Slot = 4
	SWEP.SlotPos = 2
	SWEP.DrawAmmo = false

end

 SWEP.Author = "Entoros"; 
 SWEP.Contact = ""; 
 SWEP.Purpose = "Replenish ammo"; 
 SWEP.Instructions = "Primary: Give to target\nSecondary: Give to self";
 
 SWEP.Spawnable = false
 SWEP.AdminSpawnable = true;
   
 SWEP.ViewModel = "models/weapons/v_c4.mdl"
 SWEP.WorldModel = "models/weapons/w_c4.mdl"

 SWEP.Primary.ClipSize = -1; 
 SWEP.Primary.DefaultClip = -1; 
 SWEP.Primary.Automatic = false; 
 SWEP.Primary.Ammo = "none";
 
 SWEP.Secondary.Ammo = "none";
 SWEP.Primary.SelfGive		= Sound("buttons/weapon_confirm.wav")
SWEP.Primary.PlyGive        = Sound("weapons/c4/c4_disarm.wav")
 SWEP.Delay = 10
   
 function SWEP:PrimaryAttack()
	
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Delay )
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Delay )
	
	local ent = self.Owner:GetEyeTrace().Entity
	
	if not ent:IsPlayer() or ent:GetPos():Distance(self.Owner:GetPos()) > 100  then return false end

	self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
	self.Weapon:EmitSound(self.Primary.PlyGive)
	ent:GiveAmmo(ent:GetActiveWeapon():GetPrimaryAmmoType(),90)
	
end

function SWEP:Deploy()
	
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	
	return true
	
end

function SWEP:SecondaryAttack()
	
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Delay )
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Delay )
	
	self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
	if CLIENT then return end
	
	self.Weapon:EmitSound(self.Primary.SelfGive)
	self.Owner:GiveAmmo(table.Random(self.Owner:GetWeapons()):GetPrimaryAmmoType(),90)
	
end