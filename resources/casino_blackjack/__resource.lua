resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

dependency "vrp"

ui_page 'index.html'
files {
  'index.html',
	'cursor.webp',
	'default.css',
  'graphics/cardback.gif',
  'graphics/jack.gif',
	'graphics/king.gif',
	'graphics/queen.gif',
}

server_script "@vrp/lib/utils.lua"
server_script "server.lua"
client_script "client.lua"
