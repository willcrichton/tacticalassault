`if (SERVER) then
	AddCSLuaFile("shared.lua")
	AddCSLuaFile("cl_init.lua")
	
	SWEP.Weight = 1
	SWEP.HoldType = "slam"
end

if (CLIENT) then

	SWEP.PrintName = "Binoculars"
	SWEP.Slot = 0
	SWEP.SlotPos = 3
	SWEP.DrawAmmo = false

end

 SWEP.Author = "Entoros"; 
 SWEP.Contact = ""; 
 SWEP.Purpose = "Check out your surroundings"; 
 SWEP.Instructions = "Primary: Look in\nReload: view squad leaders (general only)\nSecondary: switch persons (general only)";
 SWEP.Base = "weapon_ta_base";
 
 SWEP.Spawnable = false
 SWEP.AdminSpawnable = true;
   
SWEP.ViewModel		= "models/weapons/v_binoculars.mdl"
SWEP.WorldModel		= "models/weapons/w_binoculars.mdl"
SWEP.AutoSwitchTo = false

 SWEP.Primary.ClipSize = -1; 
 SWEP.Primary.DefaultClip = -1; 
 SWEP.Primary.Automatic = false; 
 SWEP.Primary.Ammo = "none";
 SWEP.Secondary.Ammo = "none";
 
 SWEP.ZoomIn = Sound("ta/binoculars/binoculars_zoomin.wav")
 SWEP.ZoomOut = Sound("ta/binoculars/binoculars_zoomout.wav")
 SWEP.ZoomFOV = 10
 SWEP.DefaultFOV = 75
 SWEP.FOVTime = 1.1
 
 SWEP.RunAng = Angle(30,0,0)
 SWEP.RunPos = Vector(0,0,4)
 
 SWEP.CurSquad = 1
 
 function SWEP:Initialize()
 
	if CLIENT then return end
	
	self.Weapon:SetNWEntity("ViewEnt",self.Owner)
	self.ZoomedMain = false
	timer.Simple(0.1,function() if self.Owner and self.Owner:IsValid() then self.DefaultFOV = self.Owner:GetFOV()  end end)
end
   
function SWEP:Think()

	if !self.Owner:GetNWBool("General") then return end

	local bool = self.Weapon:GetNWBool("IsLooking")
	
	if !bool and self.Owner:KeyDown(IN_RELOAD) then self.Weapon:SetNWBool("IsLooking",true)
	elseif bool and not self.Owner:KeyDown(IN_RELOAD) then self.Weapon:SetNWBool("IsLooking",false) end
end

function SWEP:Holster()

	if self.ZoomedMain then
	
		self.Owner:DrawViewModel(true)
		self.Owner:SetFOV(self.DefaultFOV,self.FOVTime)
		self:EmitSound( self.ZoomOut )
		self.Owner:ConCommand("pp_mat_overlay 0");
	
	end
	
	return true
end

function SWEP:PrimaryAttack()
	
	if !self:CanPrimaryAttack() then return end
	
	self.ZoomedMain = !self.ZoomedMain
	
	if self.ZoomedMain && self.Owner:GetActiveWeapon() == self.Weapon then
	
		self.Owner:SetFOV(self.ZoomFOV,self.FOVTime)
		self.Owner:DrawViewModel(false)
		self:EmitSound( self.ZoomIn )
		self.Owner:ConCommand("pp_mat_overlay_texture effects/combine_binocoverlay.vmt");
		self.Owner:ConCommand("pp_mat_overlay 1");
		
	else
	
		self.Owner:DrawViewModel(true)
		self.Owner:SetFOV(self.DefaultFOV,self.FOVTime)
		self:EmitSound( self.ZoomOut )
		self.Owner:ConCommand("pp_mat_overlay 0");
		
	end
	
end
	

function SWEP:SecondaryAttack()

	if !self.Owner:GetNWBool("General") || CLIENT then return end
	
	self.CurSquad = self.CurSquad + 1
	if self.CurSquad > #GAMEMODE.Squads.red then self.CurSquad = 1 end
	
	local t = self.Owner:Team()
	if t == 1 then self.Weapon:SetNWEntity("ViewEnt",GAMEMODE.Squads.red[self.CurSquad].leader)
	else self.Weapon:SetNWEntity("ViewEnt",GAMEMODE.Squads.blu[self.CurSquad].leader) end
		
	self.Weapon:SetNWInt("ChangeView",self.Weapon:GetNWInt("ChangeView") + 1)

end