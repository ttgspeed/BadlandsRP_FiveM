-- Source https://github.com/TheSpartaPT/vrp_pets
-- Author https://github.com/TheSpartaPT
-- Original source https://github.com/ESX-PUBLIC/eden_animal

description 'vrp_pets'

dependency "vrp"

client_scripts {
	"@vrp/client/Tunnel.lua",
	"@vrp/client/Proxy.lua",
	'client.lua'
}

server_scripts {
	"@vrp/lib/utils.lua",
	'@mysql-async/lib/MySQL.lua',
	'server.lua'
}
