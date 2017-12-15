
local cfg = {}

-- define each group with a set of permissions
-- _config property:
--- gtype (optional): used to have only one group with the same gtype per player (example: a job gtype to only have one job)
--- onspawn (optional): function(player) (called when the player spawn with the group)
--- onjoin (optional): function(player) (called when the player join the group)
--- onleave (optional): function(player) (called when the player leave the group)
--- (you have direct access to vRP and vRPclient, the tunnel to client, in the config callbacks)

cfg.groups = {
	["superadmin"] = {
		_config = {
			onspawn = function(player)
				vRPclient.setAdmin(player,{true})
			end
		},
		"admin.menu",
		"player.group.add",
		"player.group.remove",
		"player.givemoney",
		"player.giveitem"
	},
	["god"] = {
		_config = {
			onspawn = function(player)
				local user_id = vRP.getUserId(player)
				vRP.removeUserGroup(user_id,"god")
			end
		},
    	"admin.god" -- reset survivals/health periodically
	},
	["admin"] = {
		_config = {
			onspawn = function(player)
				vRPclient.setAdmin(player,{true})
			end
		},
		"admin.menu",
		"admin.tickets",
		"admin.announce",
		"player.list",
		"player.whitelist",
		"player.unwhitelist",
		"player.kick",
		"player.ban",
		"player.unban",
		"player.noclip",
		"player.custom_emote",
		"player.custom_sound",
		"player.display_custom",
		"player.custom_prop",
		"player.coords",
		"player.tptome",
		"player.tpto",
		"player.tptocoord",
		"player.tptowaypoint",
		"player.copWhitelist",
		"player.copUnwhitelist",
		"player.emergencyWhitelist",
		"player.emergencyUnwhitelist"
	},
	["moderator"] = {
		_config = {
			onspawn = function(player)
				vRPclient.setAdmin(player,{true})
			end
		},
		"admin.menu",
		"admin.tickets",
		"admin.announce",
		"player.list",
		"player.kick",
		"player.ban",
		"player.noclip",
		"player.tptowaypoint",
		"player.tpto",
		"player.tptome",
		"player.coords"
	},
  -- the group user is auto added to all logged players
  	["user"] = {
		"player.phone",
		"player.calladmin",
		"police.askid",
		"police.store_weapons",
		"vehicle.repair",
		"police.seizable" -- can be seized
  	},
  	["police"] = {
		_config = {
			gtype = "job",
			name = "Police",
			onjoin = function(player) vRPclient.setCop(player,{true}) end,
			--onspawn = function(player) vRPclient.setCop(player,{true}) end,
			onleave = function(player)
				local user_id = vRP.getUserId(player)
				vRPclient.setCop(player,{false})
				vRP.rollback_idle_custom(player)
				vRPclient.removeNamedBlip(-1, {"vRP:officer:"..vRP.getUserId(player)})  -- remove cop blip (all to prevent phantom blip)
				vRPclient.setArmour(player,{0})
				local i = 1
				while i < 8 do
					vRP.removeUserGroup(user_id,"police_rank"..i)
					i = i + 1
				end
			end,
			clearFirstSpawn = true
		},
		"police.cloakroom",
		"police.pc",
		"police.handcuff",
		"police.escort", --Disable for now. not working
		"police.putinveh",
		"police.pulloutveh",
		"police.getoutveh",
		"police.check",
		"police.service",
		"police.wanted",
		"police.seize.weapons",
		"police.seize.items",
		"police.jail",
		"police.fine",
		"police.vehicle",
		"police.armory",
		"police.shop",
		"police.paycheck",
		"police.informer",
		"police.mapmarkers",
		"safety.mapmarkers",
		"emergency.revive", -- temp
		"emergency.service", -- temp
		"police.announce",
		"-police.store_weapons",
		"-police.seizable", -- negative permission, police can't seize itself, even if another group add the permission
    "police.seize_vehicle",
		"police.seize_driverlicense",
		"police.seize_firearmlicense",
	},
	["police_rank1"] = {  -- recruit/cadet/
		_config = {
			onspawn = function(player)
				local user_id = vRP.getUserId(player)
				vRP.removeUserGroup(user_id,"police_rank1")
			end
		},
		"police.rank1",
	},
	["police_rank2"] = {  -- constable/officer/trooper/deputy
		_config = {
			onspawn = function(player)
				local user_id = vRP.getUserId(player)
				vRP.removeUserGroup(user_id,"police_rank2")
			end
		},
		"police.rank2"
	},
	["police_rank3"] = {  -- corporal/whatever
		_config = {
			onspawn = function(player)
				local user_id = vRP.getUserId(player)
				vRP.removeUserGroup(user_id,"police_rank3")
			end
		},
		"police.rank3",
		"police.spikestrip",
	},
	["police_rank4"] = {  -- sergeant
		_config = {
			onspawn = function(player)
				local user_id = vRP.getUserId(player)
				vRP.removeUserGroup(user_id,"police_rank4")
			end
		},
		"police.rank4",
		"police.spikestrip",
	},
	["police_rank5"] = {  -- lieutenant
		_config = {
			onspawn = function(player)
				local user_id = vRP.getUserId(player)
				vRP.removeUserGroup(user_id,"police_rank5")
			end
		},
		"police.rank5",
		"police.spikestrip",
	},
	["police_rank6"] = {  -- captain/sherrif
		_config = {
			onspawn = function(player)
				local user_id = vRP.getUserId(player)
				vRP.removeUserGroup(user_id,"police_rank6")
			end
		},
		"police.rank6",
		"police.spikestrip",
	},
	["police_rank7"] = {  -- police command
		_config = {
			onspawn = function(player)
				local user_id = vRP.getUserId(player)
				vRP.removeUserGroup(user_id,"police_rank7")
			end
		},
		"police.rank7",
		"police.spikestrip",
	},
	["emergency"] = {
		_config = {
			gtype = "job",
			name = "Medic",
			onjoin = function(player) vRPclient.setMedic(player,{true}) end,
			--onspawn = function(player) vRPclient.setMedic(player,{true}) end,
			onleave = function(player)
				local user_id = vRP.getUserId(player)
				vRPclient.setMedic(player,{false})
				vRP.rollback_idle_custom(player)
				vRPclient.removeNamedBlip(-1, {"vRP:medic:"..vRP.getUserId(player)})  -- remove medic blip (all to prevent phantom blip)
				local i = 1
				while i < 6 do
					vRP.removeUserGroup(user_id,"ems_rank"..i)
					i = i + 1
				end
			end,
			clearFirstSpawn = true
		},
		"emergency.revive",
		"emergency.shop",
		"emergency.service",
		"emergency.cloakroom",
		"emergency.vehicle",
		"emergency.paycheck",
		"emergency.mapmarkers",
		"emergency.cabinet",
		"safety.mapmarkers"
	},
	["ems_rank1"] = {  -- EMT
		_config = {
			onspawn = function(player)
				local user_id = vRP.getUserId(player)
				vRP.removeUserGroup(user_id,"ems_rank1")
			end
		},
		"ems.rank1"
	},
	["ems_rank2"] = {  -- Paramedic
		_config = {
			onspawn = function(player)
				local user_id = vRP.getUserId(player)
				vRP.removeUserGroup(user_id,"ems_rank2")
			end
		},
		"ems.rank2"
	},
	["ems_rank3"] = {  -- Search and Rescue
		_config = {
			onspawn = function(player)
				local user_id = vRP.getUserId(player)
				vRP.removeUserGroup(user_id,"ems_rank3")
			end
		},
		"ems.rank3"
	},
	["ems_rank4"] = {  -- Supervisor
		_config = {
			onspawn = function(player)
				local user_id = vRP.getUserId(player)
				vRP.removeUserGroup(user_id,"ems_rank4")
			end
		},
		"ems.rank4"
	},
	["ems_rank5"] = {  -- Command
		_config = {
			onspawn = function(player)
				local user_id = vRP.getUserId(player)
				vRP.removeUserGroup(user_id,"ems_rank5")
			end
		},
		"ems.rank5"
	},
	["repair"] = {
		_config = { gtype = "job"},
		"vehicle.repair",
		"vehicle.replace",
		"repair.service"
  	},
	["taxi"] = {
		_config = {
			gtype = "job",
			name = "Taxi Driver" ,
			clearFirstSpawn = true
  		},
		"taxi.service",
		"taxi.vehicle",
		"citizen.paycheck"
	},
	["citizen"] = {
		_config = { gtype = "job",name = "Unemployed" },
		"citizen.paycheck"
	},
	["mechanic"] = {
		_config = { gtype = "job",name = "Mechanic", onleave = function(player) vRP.stopMission(player) end },
		"citizen.paycheck",
		"mission.repair.satellite_dishes",
		"mission.repair.wind_turbines",
		--"vehicle.repair",
		--"vehicle.replace",
		--"repair.service"
	},
	["delivery"] = {
		_config = { gtype = "job",name = "Delivery Driver", onleave = function(player) vRP.stopMission(player) end },
		"citizen.paycheck",
		"mission.delivery.food"
	}
}

-- groups are added dynamically using the API or the menu, but you can add group when an user join here
cfg.users = {
	[1] = { -- give superadmin and admin group to the first created user on the database
		"superadmin",
		"admin"
	}
}

-- group selectors
-- _config
--- x,y,z, blipid, blipcolor, permissions (optional)

cfg.selectors = {
	["Job Center"] = {
		_config = {x = -268.363739013672, y = -957.255126953125, z = 31.22313880920410, blipid = 351, blipcolor = 47},
		"taxi",
		"citizen",
		"mechanic",
		"delivery"
	},
	["Police Station (HQ)"] = {
		_config = {x = 437.924987792969,y = -987.974182128906, z = 30.6896076202393 , blipid = 60, blipcolor= 38 },
		"police",
		"citizen"
	},
	["Police Station (Sandy Shores)"] = {
		_config = {x = 1858.4072265625,y = 3688.44921875, z = 34.2670783996582 , blipid = 60, blipcolor= 38 },
		"police",
		"citizen"
	},
	["Police Station (Vespucy Station)"] = {
		_config = {x = -1123.49133300781,y = -838.937622070313, z = 13.3763132095337 , blipid = 60, blipcolor= 38 },
		"police",
		"citizen"
	},
	["Police Station (Paleto Bay Station)"] = {
		_config = {x = -448.81555175781,y = 6017.8203125, z = 31.716371536255 , blipid = 60, blipcolor= 38 },
		"police",
		"citizen"
	},
	["Hospital (Central)"] = {
		--_config = {x=-498.959716796875,y=-335.715148925781,z=34.5017547607422, blipid = 61, blipcolor= 1 }, -- Rockford Hills
		--_config = {x=1151.2241210938,y=-1529.4974365234,z=35.370590209961, blipid = 61, blipcolor= 1 }, -- El Burrought Heights
		_config = {x=307.36294555664,y=-1433.9643554688,z=29.895109176636, blipid = 61, blipcolor= 1 },
		"emergency",
		"citizen"
	},
	["Hospital (Sandy Shores)"] = {
		_config = {x=1692.02416992188,y=3586.02563476563,z=35.6209716796875, blipid = 61, blipcolor= 1 },
		"emergency",
		"citizen"
	},
	["Hospital (Paleto Bay)"] = {
		_config = {x=-380.65612792969,y=6118.9624023438,z=31.630640029907, blipid = 61, blipcolor= 1 },
		"emergency",
		"citizen"
	}
}

return cfg
