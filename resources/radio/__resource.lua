resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

-- Example custom radios
supersede_radio "RADIO_02_POP" { url = "http://revolutionradio.ru/live.ogg", volume = 0.2 }
supersede_radio "RADIO_03_HIPHOP_NEW" { url = "http://stream2.harder.fm:8000/live.ogg", volume = 0.2 }

files {
	"index.html"
}

ui_page "index.html"

client_scripts {
	"client.lua",
	"data.js",
	"client.js"
}
