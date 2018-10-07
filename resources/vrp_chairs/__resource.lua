-- Source https://github.com/Sighmir/vrp_chairs

resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description "vrp_chairs"

dependency 'vrp'

client_scripts {
	'lib/Proxy.lua',
	'@vrp/client/Tunnel.lua',
	'cfg/chairs.lua',
	'client.lua',
}

server_scripts {
    '@vrp/lib/utils.lua',
	'server.lua',
}
