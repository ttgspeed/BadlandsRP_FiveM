resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

dependency "vrp"

ui_page {
    'html/index.html',
}

client_script {
  "@vrp/client/Tunnel.lua",
	"@vrp/client/Proxy.lua",
  "client.lua",
}

server_script {
  '@mysql-async/lib/MySQL.lua',
  "@vrp/lib/utils.lua",
  "server.lua",
}

files {
	'html/index.html',
  'html/css/sb-admin-2.min.css',
  'html/css/devices.min.css',
  'html/img/undraw_posting_photo.svg',
  'html/js/sb-admin-2.min.js',
  'html/js/script.js',
  'html/vendor/bootstrap/js/bootstrap.bundle.min.js',
  'html/vendor/fontawesome-free/css/all.min.css',
  'html/vendor/jquery/jquery.min.js',
  'html/vendor/jquery-easing/jquery.easing.min.js',
}
