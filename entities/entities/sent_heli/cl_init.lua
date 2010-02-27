include('shared.lua')

local font = "TestFont12"
surface.CreateFont("default",10,400,false,false,font)
local function gettextsize(text,width,height)  
    local w,h,n = 0,0,0  
    for i = 50,20,-1 do  
        n = i  
        surface.CreateFont("coolvetica", i, 400, true, false, "bb"..i )  
        surface.SetFont("bb"..i)  
        w,h = surface.GetTextSize(text)  
        if not (w and h) then  
            error("wtf?",w,h,n)  
        end  
        if w < width - 5 then  
            break  
        end  
    end  
    return w,h,n  
end  

function ENT:Draw()
	self:DrawModel()
	
	//local font = {gettextsize(
	local pos,ang =self.Entity:GetPos() + self:GetForward() * 157 + self:GetRight() * -30 + self:GetUp() * 87, Angle(0,270,90)
	cam.Start3D2D(pos ,ang , 1)
		draw.DrawText("HELLO", font, 0, 0, color_white, 0 )
	cam.End3D2D()
	
	cam.Start3D2D(pos,Angle(0,180 + ang.yaw,90) , 1)
		draw.DrawText("HELLO",font, 0, 0, color_white, 0 )
	cam.End3D2D()
end

function ENT:Initialize()
	/*usermessage.Hook("ta-calcview",function(u)
		if u:ReadShort() != self:EntIndex() then return end
		if u:ReadBool() then
			hook.Add("CalcView",self:EntIndex().."calcview",function(pl,pos,ang,fov)
				local view = {}
				view.origin = pos + Vector(0,0,100)
				view.angles = ang
				view.fov = fov
				return view
			end)
		else
			hook.Remove("CalcView",self:EntIndex().."calcview")
		end
	end)*/
end

