resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
description "vrp_tattoos"
--ui_page "ui/index.html"

dependency "vrp"

client_scripts{
  "lib/Proxy.lua",
  "lib/Tunnel.lua",
  "client.lua"
}

server_scripts{
  "@vrp/lib/utils.lua",
  "server.lua"
}
