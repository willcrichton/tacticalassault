include('shared.lua')

SWEP.PrintName			= "Tactical Assault Weapon Base"	
SWEP.Slot				= 0							// Slot in the weapon selection menu
SWEP.SlotPos			= 1							// Position in the slot
SWEP.DrawAmmo			= true						// Should draw the default HL2 ammo counter?
SWEP.DrawCrosshair		= false 						// Should draw the default crosshair?
SWEP.DrawWeaponInfoBox		= true						// Should draw the weapon info box?
SWEP.BounceWeaponIcon   	= false						// Should the weapon icon bounce?
SWEP.SwayScale			= 1.0							// The scale of the viewmodel sway
SWEP.BobScale			= 1.0							// The scale of the viewmodel bob

SWEP.RenderGroup 			= RENDERGROUP_OPAQUE

local curpos = Vector(0,0,0)
local curang = Angle(0,0,0)

local mul = 2

function SWEP:GetViewModelPosition(pos, ang)
	
	local iron = true
	
	if (self.Owner:KeyDown(IN_SPEED)) then
		curpos.z = math.Approach(curpos.z,5,mul/3)
		curang.pitch = math.Approach(curang.pitch,15,mul)
	else
		curpos.z = math.Approach(curpos.z,0,mul/3)
		curang.pitch = math.Approach(curang.pitch,0,mul)
	end
	
	pos = pos + curpos
	ang = ang + curang
	
	if iron == true then
	
		pos = pos + self.IronSightsPos
		ang = ang + self.IronSightsAng
		
	end
	
	return pos, ang
end
