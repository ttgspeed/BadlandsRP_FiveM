resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

client_script {
	--"@vrp/client/Tunnel.lua",
	--"@vrp/client/Proxy.lua",
  "config.lua",
  "radialmenu.lua",
  "client.lua",
}

ui_page "html/menu.html"

files {
  "html/menu.html",
  "html/raphael.min.js",
  "html/wheelnav.min.js",
  "html/doors.png",
  "html/engine.png",
  "html/hood.png",
  "html/key.png",
  "html/trunk.png"
}
