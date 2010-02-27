include('shared.lua')

function ENT:Initialize()
	hook.Add("RenderScreenspaceEffects","ShowDebug"..self:EntIndex(),function()
		local center = self:GetPos() + self:OBBMins()
		//debugoverlay.Cross( self:GetPos() +  Vector(-15,-37,19), 10, 0.04, color_white, true )
		//debugoverlay.Cross( center + self:OBBMins(), 10, 0.04, color_white, true )
		//debugoverlay.Cross( center + self:OBBMaxs(), 10, 0.04, color_white, true  )
	end)
end

function ENT:OnRemove()
	hook.Remove("RenderScreenspaceEffects","ShowDebug"..self:EntIndex())
end

function ENT:Draw()
	self.Entity:DrawModel()
end

