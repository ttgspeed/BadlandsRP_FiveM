--- Source https://github.com/TomGrobbe/vSync

resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

dependency "vrp"

server_scripts {
	"@vrp/lib/utils.lua",
	"server/time.lua",
	"server/weather.lua",
}

client_scripts {
	"@vrp/client/Tunnel.lua",
	"@vrp/client/Proxy.lua",
	"client/time.lua",
	"client/weather.lua",
}
