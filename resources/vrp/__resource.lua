
description "RP module/framework"

--dependency "vrp_mysql"

ui_page "gui/index.html"

loadscreen "loadingscreen/index.html"

-- server scripts
server_scripts{
  "lib/utils.lua",
  "lib/json.lua",
  "base.lua",
  "modules/gui.lua",
  "modules/group.lua",
  "modules/admin.lua",
  "modules/survival.lua",
  "modules/player_state.lua",
  "modules/map.lua",
  "modules/money.lua",
  "modules/inventory.lua",
  "modules/identity.lua",
  "modules/licenses.lua",
  "modules/business.lua",
  "modules/item_transformer.lua",
  "modules/emotes.lua",
  "modules/police.lua",
  "modules/home.lua",
  "modules/home_components.lua",
  "modules/mission.lua",
  "modules/sr_autoKick.lua",
  "modules/aptitude.lua",
  "modules/meth.lua",
  "modules/emergency.lua",

  -- basic implementations
  "modules/basic_phone.lua",
  "modules/basic_atm.lua",
  "modules/basic_market.lua",
  "modules/basic_gunshop.lua",
  "modules/basic_garage.lua",
  "modules/basic_items.lua",
  "modules/basic_skinshop.lua",
  "modules/cloakroom.lua",
  "modules/paycheck.lua",
  "modules/holdup.lua",
  "modules/bankrobery.lua",
  "modules/barbershop.lua",

  'model-menu/server.lua',

  'anticheat/sv_anticheat.lua',
  'rcon/server.lua'
}
server_script '@mysql-async/lib/MySQL.lua'

-- client scripts
client_scripts{
  "lib/utils.lua",
  "client/Tunnel.lua",
  "client/Proxy.lua",
  "client/base.lua",
  "client/iplloader.lua",
  "client/gui.lua",
  "client/player_state.lua",
  "client/survival.lua",
  "client/map.lua",
  "client/identity.lua",
  "client/basic_garage.lua",
  "client/police.lua",
  "client/admin.lua",
  "client/es_pld.lua",
  "client/voip.lua",
  "client/paycheck.lua",
  "client/emergency.lua",
  "client/cl_autoKick.lua",
  "client/carwash_client.lua",
  "client/holdup.lua",
  "client/bankrobery.lua",
  "client/meth.lua",
  "client/barbershop.lua",
  "client/basic_phone.lua",

  'model-menu/client.lua',
  'model-menu/gui.lua',
  'model-menu/models.lua',
  'model-menu/accessories.lua',

  'anticheat/cl_anticheat.lua',
  'rcon/client.lua'
}

-- client files
files{
  "cfg/client.lua",
  "gui/index.html",
  "gui/design.css",
  "gui/main.js",
  "gui/Menu.js",
  "gui/ProgressBar.js",
  "gui/WPrompt.js",
  "gui/RequestManager.js",
  "gui/Div.js",
  "gui/dynamic_classes.js",
  "gui/pdown.ttf",
  "gui/AnnounceManager.js",
  "loadingscreen/index.html",
  "loadingscreen/js/bootstrap.min.js",
  "loadingscreen/js/jquery.easings.min.js",
  "loadingscreen/js/jquery.mCustomScrollbar.js",
  "loadingscreen/js/jquery.min.js",
  "loadingscreen/js/jquery.mousewheel.js",
  "loadingscreen/js/main.js",
  "loadingscreen/js/modernizr.custom.js",
  "loadingscreen/js/photoswipe-ui-default.js",
  "loadingscreen/js/photoswipe.js",
  "loadingscreen/js/vegas.js",
  "loadingscreen/js/velocity.min.js",
  "loadingscreen/js/velocity.ui.min.js",
  "loadingscreen/css/animate.css",
  "loadingscreen/css/bootstrap.min.css",
  "loadingscreen/css/jquery.mCustomScrollbar.css",
  "loadingscreen/css/photoswipe.css",
  "loadingscreen/css/style.css",
  "loadingscreen/css/vegas.css",
  "loadingscreen/css/default-skin/default-skin.css",
  "loadingscreen/css/default-skin/preloader.gif",
  "loadingscreen/css/default-skin/default-skin.svg",
  "loadingscreen/css/default-skin/default-skin.png",
  "loadingscreen/img/logo.png",
  "loadingscreen/img/slide-1.jpg",
  "loadingscreen/img/slide-2.jpg",
  "loadingscreen/img/slide-3.jpg",
  "loadingscreen/img/slide-square.jpg"
}
