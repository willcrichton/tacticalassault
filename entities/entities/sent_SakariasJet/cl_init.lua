ENT.Spawnable			= true
ENT.AdminSpawnable		= true

include('shared.lua')

local matPlasma			= Material( "effects/strider_muzzle" )

ENT.RenderGroup 		= RENDERGROUP_BOTH


function ENT:Initialize()

	self.ShouldDraw = 1
	self.NextSmokeEffect = 0
	
	// Make the render bounds a bigger so the effect doesn't get snipped off
	local mx, mn = self.Entity:GetRenderBounds()
	self.Entity:SetRenderBounds( mn + Vector(0,0,128), mx, 0 )
	
	self.Seed = math.Rand( 0, 10000 )
	
end

function ENT:Draw()
	self.BaseClass.Draw( self )		
end

function ENT:DrawTranslucent()
		
	local EffectThink = self[ "EffectDraw_blasma" ]
	EffectThink( self )
	
end

function ENT:Think()
end


function ENT:OnRestore()
end


function ENT:EffectDraw_blasma()

		local vOffset = (self.Entity:GetPos() + self.Entity:GetForward() * -320 + self.Entity:GetUp() * -8)

		
		local scroll = CurTime() * -20
			
		render.SetMaterial( matPlasma )
		
		local thrust = 	self.Entity:GetNetworkedInt("jetThrottle")
		
		if thrust != 0 then
			thrust = thrust - 6000
			thrust = (thrust / 44000) * 0.5 + 0.2
			
			if thrust < 0 then
				thrust = 0
			end	
			
			scroll = scroll * 0.9
			
			
				local vNormal = self.Entity:GetForward() * ((1 + thrust) * -1)
			

			local color1 = Color( (((1 - thrust) * 200) + 50) , ((1 - thrust) * 150) , thrust * 255,0 )
			local color2 = Color( (((1 - thrust) * 200) + 50) , ((1 - thrust) * 150) , thrust * 255, 255 )		
			local color3 = Color( (((1 - thrust) * 200) + 50) , ((1 - thrust) * 50) , thrust * 255, 0 )				
			
			render.StartBeam( 3 )
				render.AddBeam( vOffset, 40, scroll, color1  )
				render.AddBeam( vOffset + vNormal * 8, 40, scroll + 0.01, color2 )
				render.AddBeam( vOffset + vNormal * 64, 40, scroll + 0.02, color3 )
			render.EndBeam()
			
			scroll = scroll * 0.9
			
			render.StartBeam( 3 )
				render.AddBeam( vOffset, 40, scroll, color1 )
				render.AddBeam( vOffset + vNormal * 8, 40, scroll + 0.01, color2	 )
				render.AddBeam( vOffset + vNormal * 64, 40, scroll + 0.02, color3 )
			render.EndBeam()
			
			scroll = scroll * 0.9
			
			render.StartBeam( 3 )
				render.AddBeam( vOffset, 40, scroll, color1 )
				render.AddBeam( vOffset + vNormal * 8, 40, scroll + 0.01, color2)
				render.AddBeam( vOffset + vNormal * 64, 40, scroll + 0.02, color3 )
			render.EndBeam()
			
		end
end

