resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

server_scripts {
		"@vrp/lib/utils.lua",
		"server/taxi.lua",
		"server/trucker.lua",
		"server/ems_transport.lua",
}

client_scripts {
		"client/taxi.lua",
		"client/trucker.lua",
		"client/ems_transport.lua",
}
