function tvRP.shareCarCrashEvent(passengerList)
  if passengerList ~= nil then
    for k,v in pairs(passengerList) do
      if k ~= nil and k ~= -1 then
        vRPclient.sendCarCrashEvent(k,{})
      end
    end
  end
end

function tvRP.saveEmoteBinds(emoteBinding)
  if emoteBinding ~= nil then
    local user_id = vRP.getUserId(source)
    vRP.setUData(user_id, "vRP:emote_keybinds", json.encode(emoteBinding))
  end
end

function vRP.loadEmoteBinds(player)
  if player ~= nil and player ~= -1 then
    local user_id = vRP.getUserId(source)
    vRP.getUData(user_id, "vRP:emote_keybinds", function(content)
      local emoteBinding = json.decode(content)
      if emoteBinding ~= "" and emoteBinding ~= nil and emoteBinding ~= {} then
        vRPclient.syncEmoteBinding(player, {emoteBinding})
      end
  	end)
  end
end
