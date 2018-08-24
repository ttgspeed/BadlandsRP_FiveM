resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

dependency "vrp"

server_scripts {
		"@vrp/lib/utils.lua",
		"server/server.lua",
}

client_scripts {
	"@vrp/client/Tunnel.lua",
	"@vrp/client/Proxy.lua",
	"client/client.lua",
	"client/taxi.lua",
	"client/trucker.lua",
	"client/ems_transport.lua",
}
