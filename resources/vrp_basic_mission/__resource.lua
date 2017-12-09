resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description "vRP basic mission"
--ui_page "ui/index.html"

dependency "vrp"

server_script "@vrp/lib/utils.lua"
server_script "server.lua"
