--[[
Source:https://forum.fivem.net/t/release-izone-v1-2/23233
]]--

dependency 'mysql-async'
dependency 'vrp'

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'izone_server.lua'
}

client_scripts {
	"@vrp/client/Tunnel.lua",
	"@vrp/client/Proxy.lua",
  'izone_client.lua'
}
