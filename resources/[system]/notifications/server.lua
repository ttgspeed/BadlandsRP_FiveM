notify = {}

local restartTimes = {
  [2] = true,
  [8] = true,
  [14] = true,
  [20] = true
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
      TriggerClientEvent('chat:addMessage', -1, {
          template = '<div class="chat-bubble" style="background-color: rgba(230, 0, 115, 0.6);"><i class="fas fa-server"></i> {0}</div>',
          args = { "The server will restart in "..th.." minutes."}
      })
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
