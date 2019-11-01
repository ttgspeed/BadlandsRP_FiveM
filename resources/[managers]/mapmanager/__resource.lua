client_scripts {
    "mapmanager_client.lua",
    "mapmanager_shared.lua"
}

server_scripts {
    "mapmanager_server.lua",
    "mapmanager_shared.lua"
}

resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

server_export "getCurrentGameType"
server_export "getCurrentMap"
server_export "changeGameType"
server_export "changeMap"
server_export "doesMapSupportGameType"
server_export "getMaps"
