local Tunnel = require("resources/vrp/lib/Tunnel")
local Proxy = require("resources/vrp/lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","notification")
notify = {}

local restartTimes = {
  [2] = true,
  [6] = true,
  [10] = true,
  [14] = true,
  [18] = true,
  [22] = true
}
local restartWarnings = {
  [30] = false,
  [15] = false,
  [10] = false,
  [5] = false,
  [1] = false
}

function notify.serverTime()
  local time = os.date("*t")
  if restartTimes[time.hour+1] ~= nil then
    local th = 60 - time.min
    if restartWarnings[th] == false then
      if th == 1 then
        TriggerClientEvent('notifications:1mWarning', -1)
      end

      TriggerClientEvent('chatMessage', -1, 'SYSTEM', { 0, 0, 0 }, "^2* The server will restart in "..th.." minutes.")
      restartWarnings[th] = true
    end
  end
end

function notify.run()
  SetTimeout(1000, function()
    notify.serverTime()
    notify.run()
  end)
end

notify.run()
