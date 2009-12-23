include('shared.lua')

local curteam = 0

surface.CreateFont("Army",70,600,true,false,"TestFont2")
function ENT:Draw()
	self.Entity:DrawModel()
	
	local ang = EyeAngles()
	cam.Start3D2D(self.Entity:GetPos() + Vector(0,0,150), Angle(0,ang.yaw,ang.roll) + Angle(0,-90,90), 1)
		
		local col,cap,str = color_white, self.Entity:GetNWInt("HasCapped"),"no team"
		//if cap == 1 then col = team.GetColor(1) elseif cap == 2 then col = team.GetColor(2) end
		if cap == 1 then col,str = Color(255,0,0),"Red" elseif cap == 2 then col,str = Color(0,0,255),"Blue" end
	
		draw.SimpleTextOutlined(str, "TestFont2", 0, 0, col, 1, 1, 2, Color(0,0,0,255))
	cam.End3D2D()
end
