local cfg = {}
-- define garage types with their associated vehicles
-- (vehicle list: https://wiki.fivem.net/wiki/Vehicles)

-- each garage type is an associated list of veh_name/veh_definition
-- they need a _config property to define the blip and the vehicle type for the garage (each vtype allow one vehicle to be spawned at a time, the default vtype is "default")
-- this is used to let the player spawn a boat AND a car at the same time for example, and only despawn it in the correct garage
-- _config: vtype, blipid, blipcolor, permission (optional, only users with the permission will have access to the shop)

cfg.licenses = {
		["driverlicense"] = {"Driver License", 5000, "driverlicense"},
		["firearmlicense"] = {"Firearm License", 20000, "firearmlicense"},
		["pilotlicense"] = {"Pilot License", 200000, "pilotlicense"},
		["towlicense"] = {"Tow Truck License", 5000, "towlicense"},
		["lawyerlicense"] = {"Lawyer's Bar Certification", 50000, "lawyerlicense"},
}

return cfg
