resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

name 'Mythic Framework Apartments'
description 'Instanced Apartments For Mythic Framework'
author 'Alzar - https://github.com/Alzar'
version 'v1.0.0'
url 'https://github.com/mythicrp/'

ui_page 'html/index.html'

client_scripts {
	"client/main.lua",
}

server_scripts {
	'server/main.lua',
}

files {
    'html/index.html',
    'html/js/app.js',
    'html/door_open.wav',
    'html/door_close.wav',
}
