// Runner Class
local CLASS = {}

CLASS.Base = "BaseClass"
CLASS.DisplayName = "Runner"
CLASS.Description = "Run twice as fast! \nPrimary: SMG \nSecondary: Pistol"
CLASS.WalkSpeed = 400
CLASS.RunSpeed = 600
CLASS.MaxHealth = 75
CLASS.StartHealth = 75

function CLASS:Loadout( pl )
	pl:Give("weapon_smg1")
	pl:Give("weapon_pistol")
	
	self.BaseClass.Loadout(self,pl)
end

player_class.Register( "Runner", CLASS )



// Assault Class
local CLASS = {}

CLASS.Base = "BaseClass"
CLASS.DisplayName = "Assault"
CLASS.Description = "Outlast your enemies! \nPrimary: Heavy Machine Gun \nSecondary: Shotgun \nTertiary: Resupply"
CLASS.WalkSpeed = 200
CLASS.RunSpeed = 320
CLASS.MaxHealth = 150
CLASS.StartHealth = 150

function CLASS:Loadout( pl )
	pl:Give("weapon_smg1")
	pl:Give("kermite_shotgun")
	pl:Give("weapon_resupply")
	
	self.BaseClass.Loadout(self,pl)
end

player_class.Register( "Assault", CLASS )



// Sniper Class
local CLASS = {}

CLASS.Base = "BaseClass"
CLASS.DisplayName = "Sniper"
CLASS.Description = "Get 'em long range! \nPrimary: Sniper \nSecondary: Pistol"

function CLASS:Loadout( pl )
	pl:Give("weapon_crossbow")
	pl:Give("weapon_pistol")
	
	self.BaseClass.Loadout(self,pl)
end

player_class.Register( "Sniper", CLASS )



// Cavlary Class
local CLASS = {}

CLASS.Base = "BaseClass"
CLASS.DisplayName = "Cavalry"
CLASS.Description = "Attack, defend, support. \nPrimary: Assault Rifle \nSecondary: Pistol"

function CLASS:Loadout( pl )
	pl:Give("weapon_ar2")
	pl:Give("weapon_357")
	
	self.BaseClass.Loadout(self,pl)
end

player_class.Register( "Cavalry", CLASS )



// Artillery Class
local CLASS = {}

CLASS.Base = "BaseClass"
CLASS.DisplayName = "Artillery"
CLASS.Description = "Bring in the big guns. \nPrimary: Bazooka \nSecondary: Shotgun"

function CLASS:Loadout( pl )
	pl:Give("weapon_shotgun")
	//pl:Give("weapon_bazooka")
	
	self.BaseClass.Loadout(self,pl)
end

player_class.Register( "Artillery", CLASS )



// Medic Class
local CLASS= {}

CLASS.Base = "BaseClass"
CLASS.DisplayName = "Medic"
CLASS.Description = "Backbone of the team. \nPrimary: Pistol \nSecondary: Medic Kit"

function CLASS:Loadout( pl )
	pl:Give("weapon_pistol")
	//pl:Give("weapon_medkit")
	
	self.BaseClass.Loadout(self,pl)
end

player_class.Register( "Medic", CLASS)

