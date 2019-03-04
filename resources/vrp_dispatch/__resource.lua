resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

dependencies {
	'vrp',
}

server_script '@mysql-async/lib/MySQL.lua'

ui_page 'html/ui.html'
files {
	'html/ui.html',
	'html/taximeter.ttf',
	'html/cursor.png',
	'html/styles.css',
	'html/scripts.js',
	'html/debounce.min.js'
}

client_scripts{ 
	"@vrp/client/Tunnel.lua",
	"@vrp/client/Proxy.lua",
	"client.lua"
}
server_scripts{
	"@vrp/lib/utils.lua",
	"server.lua"
}

