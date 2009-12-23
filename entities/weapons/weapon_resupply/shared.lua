if (SERVER) then
	AddCSLuaFile("shared.lua")
	
	SWEP.Weight = 1
	SWEP.HoldType = "slam"
end

if (CLIENT) then

	SWEP.PrintName = "Resupply"
	SWEP.Slot = 2
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
 SWEP.Primary.SelfGive		= Sound("weapons/c4/c4_disarm.wav")
SWEP.Primary.PlyGive        = Sound("buttons/weapon_confirm.wav") 
 SWEP.Delay = 15
   
 function SWEP:PrimaryAttack()
	
	local ent = self.Owner:GetEyeTrace().Entity
	if not self.Owner:GetEyeTrace().HitNonWorld or not ent:IsPlayer() or ent:GetPos():Distance(self.Owner:GetPos()) > 100  then return false end
	
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Delay )
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Delay )

	self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
	self:AddAmmo(ent,true)
end

function SWEP:Deploy()
	
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	
	return true
	
end

function SWEP:AddAmmo(pl,primary)
	if SERVER then
		if primary then self.Weapon:EmitSound(self.Primary.PlyGive) else self.Weapon:EmitSound(self.Primary.SelfGive) end
		pl:GiveAmmo(90,"smg1",true)
		pl:GiveAmmo(45,"buckshot",true)
	end
	timer.Simple(self.Delay,function()
		self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	end)
end

function SWEP:SecondaryAttack()
	
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Delay )
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Delay )
	
	self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
	self:AddAmmo(self.Owner,false)
end
