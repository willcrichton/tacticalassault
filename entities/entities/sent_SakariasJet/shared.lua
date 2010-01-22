
ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.PrintName		= "F35"
ENT.Author			= "Sakarias88"
ENT.Category 		= "Air Vehicles"
ENT.Contact    		= ""
ENT.Purpose 		= ""
ENT.Instructions 	= "" 

ENT.Spawnable			= false
ENT.AdminSpawnable		= true
ENT.crap = 0;

if(CLIENT)then

	local function LockOnTargetEffect(victim)

		local victim = LocalPlayer()
		local hasTarget = victim:GetNetworkedInt("HasLockedOnTarget")
		local weaponType = victim:GetNetworkedInt("JetWeaponType")

	
		if hasTarget == 1 && weaponType == 3 then		
			local targetPos = victim:GetNetworkedVector("LockTargetPos")
			local pos = targetPos:ToScreen()
		
			surface.SetDrawColor( 0, 255, 0, 200 )
			surface.DrawOutlinedRect( pos.x - 20, pos.y - 20, 40, 40)	
		end
		
		if hasTarget == 0 && weaponType == 3 then		
			local targetPos = victim:GetNetworkedVector("LockTargetPos")
			local pos = targetPos:ToScreen()
		
			surface.SetDrawColor( 0, 255, 0, 200 )
		--	surface.DrawOutlinedRect( pos.x - 20, pos.y - 20, 40, 40)	
			
			surface.DrawLine( pos.x + 20, pos.y + 20 , pos.x + 15 , pos.y + 20 )
			surface.DrawLine( pos.x + 20, pos.y + 20 , pos.x + 20 , pos.y + 15 )
			
			surface.DrawLine( pos.x - 20, pos.y + 20 , pos.x - 15 , pos.y + 20 )
			surface.DrawLine( pos.x - 20, pos.y + 20 , pos.x - 20 , pos.y + 15 )

			surface.DrawLine( pos.x - 20, pos.y - 20 , pos.x - 15 , pos.y - 20 )
			surface.DrawLine( pos.x - 20, pos.y - 20 , pos.x - 20 , pos.y - 15 )

			surface.DrawLine( pos.x + 20, pos.y - 20 , pos.x + 15 , pos.y - 20 )
			surface.DrawLine( pos.x + 20, pos.y - 20 , pos.x + 20 , pos.y - 15 )			
		end
		
		if weaponType == 2 then
			local targetPos = victim:GetNetworkedVector("LockTargetPos")
			local posOne = targetPos:ToScreen()
			targetPos = victim:GetNetworkedVector("LockTargetPosTwo")
			local posTwo = targetPos:ToScreen()
			
			surface.SetDrawColor( 0, 255, 0, 200 )
			surface.DrawLine( posOne.x + 20, posOne.y, posOne.x + 5 , posOne.y )
			surface.DrawLine( posOne.x - 20, posOne.y, posOne.x - 5 , posOne.y )			
			surface.DrawLine( posOne.x ,posOne.y + 20, posOne.x, posOne.y + 5 )		
			surface.DrawLine( posOne.x ,posOne.y - 20, posOne.x, posOne.y - 5 )		
			
			surface.DrawLine( posTwo.x + 20, posTwo.y, posTwo.x + 5 , posTwo.y )
			surface.DrawLine( posTwo.x - 20, posTwo.y, posTwo.x - 5 , posTwo.y )			
			surface.DrawLine( posTwo.x ,posTwo.y + 20, posTwo.x, posTwo.y + 5 )		
			surface.DrawLine( posTwo.x ,posTwo.y - 20, posTwo.x, posTwo.y - 5 )				
		end
		
		if weaponType == 1 then
			local targetPos = victim:GetNetworkedVector("LockTargetPos")
			local pos = targetPos:ToScreen()
			
			surface.SetDrawColor( 0, 255, 0, 200 )
			surface.DrawLine( pos.x + 20, pos.y, pos.x + 5 , pos.y )
			surface.DrawLine( pos.x - 20, pos.y, pos.x - 5 , pos.y )			
			surface.DrawLine( pos.x ,pos.y + 20, pos.x, pos.y + 5 )		
			surface.DrawLine( pos.x ,pos.y - 20, pos.x, pos.y - 5 )				
		end
		

	end
	
	hook.Add("HUDPaint", "LockOnTargetEffect", LockOnTargetEffect)	
	
	
end
