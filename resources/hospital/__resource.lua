-- Author: Damen57

resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'Mythic Framework Hospital & Damage System'

version '1.0.0'

dependencies {
	'vrp',
	'CustomScripts',
	'mythic_notify',
}

client_scripts{
	"@vrp/lib/utils.lua",
	"@vrp/client/Tunnel.lua",
	"@vrp/client/Proxy.lua",
	"config.lua",
  "client.lua",
	'mythic/client/wound.lua',
	'mythic/client/main.lua',
	'mythic/client/items.lua',
}

server_scripts{
  "@vrp/lib/utils.lua",
  "server.lua",
	'mythic/server/wound.lua',
	'mythic/server/main.lua',
}

files {
	"mythic/cfg/config.lua"
}

exports {
    'IsInjuredOrBleeding',
}

server_exports {
    'GetCharsInjuries',
}
