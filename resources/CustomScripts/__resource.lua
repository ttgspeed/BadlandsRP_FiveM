resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

dependency "vrp"

-- client scripts
client_scripts{
	"@vrp/client/Tunnel.lua",
	"@vrp/client/Proxy.lua",
	"client/missiontext-client.lua",
	"client/client.lua",
	"client/parachutes.lua",
	"client/binoculars.lua",
	"client/recoil.lua",
	"client/selfie_camera.lua",
	--"client/vehicle_functions.lua",
	"client/carhud.lua",
	"client/GunDraw.lua",
	"client/carwash.lua",
	"RealisticVehicleFailure/config.lua",
	"RealisticVehicleFailure/client.lua",
}
server_scripts{
	'@mysql-async/lib/MySQL.lua',
	"server/server.lua",	
}
