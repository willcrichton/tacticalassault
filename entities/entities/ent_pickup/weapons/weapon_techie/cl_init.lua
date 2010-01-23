include('shared.lua')

usermessage.Hook("Techie-ShowMenu",function()
	
	local f = vgui.Create("DFrame")
	f:SetSize(350,150)
	f:Center()
	f:SetTitle("")
	f:MakePopup()
	
	f.Paint = function()
		draw.RoundedBox(0,0,0,f:GetWide(),f:GetTall(),Color(0,0,0,200))
		draw.DrawText("Construction Menu","ScoreboardText",f:GetWide()/2,4,color_white,1)
	end
	
	local build_list = vgui.Create("DPanelList",f)
	build_list:SetSize(300, f:GetTall() - 50 )
	build_list:SetPos(f:GetWide()/2 - build_list:GetWide() / 2,30)
	build_list:EnableHorizontal(true)
	build_list:SetPadding(10)
	build_list:SetSpacing(25)
	
	local buildings = {
		{"vgui/swepicon","techie_manhacks","Manhacks"},
		{"vgui/swepicon","techie_turret","Turret",},
		{"vgui/swepicon","","Barricades",function() ShowBarriersMenu() f:Close() end},
	}
	
	for _,v in ipairs(buildings) do
		local img = vgui.Create("DImageButton",build_list)
		img:SetSize(75,75)
		img:SetImage(v[1])
		img:SetToolTip(v[3])
		img.DoClick = function() 
			if v[4] then v[4]() return end
			RunConsoleCommand(v[2]) 
		end
		
		
		build_list:AddItem(img)
	end

end)

function ShowBarriersMenu()

	local f = vgui.Create("DFrame")
	f:SetSize(120,300)
	f:Center()
	f:SetTitle("")
	f:MakePopup()
	
	f.Paint = function()
		draw.RoundedBox(0,0,0,f:GetWide(),f:GetTall(),Color(0,0,0,200))
		draw.DrawText("Barriers","ScoreboardText",f:GetWide()/2,4,color_white,1)
	end
	
	local build_list = vgui.Create("DPanelList",f)
	build_list:SetSize(75, f:GetTall() - 60)
	build_list:SetPos(f:GetWide() / 2 - build_list:GetWide()/2,30)
	
	build_list:SetPadding(5)
	build_list:SetSpacing(20)
	
	
	local types = {
	[1] = { 
		model = "models/props_lab/blastdoor001b.mdl",
		health = 150,
		buildtime = 5,
		},
	[2] = {
		model = "models/props_lab/blastdoor001c.mdl",
		health = 250,
		buildtime = 10,
		},
	[3]  = {
		model = "models/props_wasteland/cargo_container01b.mdl",
		health = 500,
		buildtime = 20,
		}
	}
	
	for k,v in ipairs(types) do
		local icon = vgui.Create("SpawnIcon")
		icon:SetModel(v.model)
		icon:SetToolTip("Health: "..v.health.."\nBuildtime: "..v.buildtime)
		icon.OnMousePressed = function()
			RunConsoleCommand("techie_barrier",k)
			icon:KillFocus()
			f:KillFocus()
			gui.EnableScreenClicker(false)
			f:Close() 
		end
		build_list:AddItem(icon)
	end
	
end