resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

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
