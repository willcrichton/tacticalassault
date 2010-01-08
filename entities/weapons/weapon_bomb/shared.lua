if (SERVER) then
	AddCSLuaFile("shared.lua")
	
	SWEP.Weight = 1
	SWEP.HoldType = "slam"
end

if (CLIENT) then
	
	SWEP.ViewModelFOV		= 75
	SWEP.ViewModelFlip		= false
	
	SWEP.PrintName = "C4 Explosive"
	SWEP.IconLetter = "H"
	SWEP.Slot = 5
	SWEP.Slotpos = 2

end

 SWEP.Author = "Entoros"; 
 SWEP.Contact = ""; 
 SWEP.Purpose = "Destroy objectives"; 
 SWEP.Instructions = "Primary: Plant bomb";
 
 SWEP.Spawnable = false
 SWEP.AdminSpawnable = true;
   
 SWEP.ViewModel = "models/weapons/v_c4.mdl"
 SWEP.WorldModel = "models/weapons/w_c4.mdl"

 SWEP.Primary.ClipSize = -1; 
 SWEP.Primary.DefaultClip = -1; 
 SWEP.Primary.Automatic = false; 
 SWEP.Primary.Ammo = "none";
 
 SWEP.Secondary.Ammo = "none";
 SWEP.Beep = Sound("weapons/c4/c4_beep1.wav")
   
 function SWEP:PrimaryAttack()

	local tr = self.Owner:GetEyeTrace()
	if !tr.HitNonWorld || tr.Entity:GetClass() != "obj_explode_win" || tr.Entity:GetPos():Distance(self.Owner:GetPos()) > 100 then 
		if SERVER then self.Owner:SendLua("surface.PlaySound(\"common/wpn_denyselect.wav\")") end
		return
	end
 
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	self.Owner:Freeze(true)
	
	if SERVER then
	
		timer.Simple(3.8,function()
			local prop = ents.Create("ent_bomb")
			prop:SetPos(self.Owner:GetEyeTrace().HitPos)
			prop:SetAngles(self.Owner:GetEyeTrace().HitNormal:Angle())
			prop:Spawn()
			prop:Activate()
			prop:TurnOn(self.Owner)
			prop:SetNWInt("Team",self.Owner:Team())
			prop:SetNWEntity("target",tr.Entity)
			tr.Entity:SetNWEntity("bomb",prop)
			tr.Entity:SetNWInt("bomb_team",self.Owner:Team())
			
			self.Owner:Freeze(false)
			self.Owner:SelectWeapon(self.Owner:GetWeapons()[1]:GetClass())
			self.Weapon:Remove()
		end)
		
	end
		
end

function SWEP:Deploy()
	
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	
	return true
	
end