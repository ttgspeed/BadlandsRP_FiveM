resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

name 'Mythic Modules'
author 'Alzar - https://github.com/Alzar'
version 'v1.0.0'

ui_page {
    'html/ui.html',
}

files {
	'html/ui.html',
	'html/js/app.js',
	'html/css/style.css',
  'html/css/bootstrap.min.css',
  'html/door_open.wav',
  'html/door_close.wav',
}

client_scripts {
	'notify/notify_cl.lua',
  'progressbar/progressbar_cl.lua',
  'appartment/appartment_cl.lua',
}

server_scripts {
  'appartment/appartment_sv.lua',
}

exports {
	'DoShortHudText',
	'DoHudText',
	'DoLongHudText',
	'DoCustomHudText',
  'Progress',
  'ProgressWithStartEvent',
  'ProgressWithTickEvent',
  'ProgressWithStartAndTick'
}
