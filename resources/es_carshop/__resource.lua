-- Manifest
resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

dependency "vrp"

client_script {
	"@vrp/client/Tunnel.lua",
	"@vrp/client/Proxy.lua",
	'Tunnel.lua',
	'garages.lua',
	'carshop.lua'
}
server_script 'sv_carshop.lua'

ui_page 'carshop.html'

files {
	'carshop.html',
	'css/bootstrap.css',
	'css/bootstrap.min.css',
	'css/shop-homepage.css',
	'fonts/glyphicons-halflings-regular.eot',
	'fonts/glyphicons-halflings-regular.svg',
	'fonts/glyphicons-halflings-regular.ttf',
	'fonts/glyphicons-halflings-regular.woff',
	'fonts/glyphicons-halflings-regular.woff2',
	'js/bootstrap.js',
	'js/bootstrap.min.js',
	'js/jquery.js',
	'logo.jpg',
	'cursor.webp',
}
