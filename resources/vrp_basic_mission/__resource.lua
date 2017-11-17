resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

description "vRP basic mission"
--ui_page "ui/index.html"

dependency "vrp"

server_script "@vrp/lib/utils.lua"
server_script "server.lua"
