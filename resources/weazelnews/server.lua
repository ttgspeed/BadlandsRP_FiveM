local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local Log = module("vrp", "lib/Log")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","weazelnews")

AddEventHandler('chatMessage', function(from,name,message)
	if(string.sub(message,1,1) == "/") then

		local args = splitString(message)
		local cmd = args[1]
    local user_id = vRP.getUserId({from})
		if(cmd == "/cam")then
			if vRP.hasPermission({user_id,"news.equipement"}) then
        CancelEvent()
        TriggerClientEvent("Cam:ToggleCam", from)
			else
				vRPclient.notify(from, {"You must be signed in to news job."})
			end
    elseif(cmd == "/bmic")then
			if vRP.hasPermission({user_id,"news.equipement"}) then
  			CancelEvent()
  			TriggerClientEvent("Mic:ToggleBMic", from)
			else
				vRPclient.notify(from, {"You must be signed in to news job."})
			end
    elseif(cmd == "/mic")then
			if vRP.hasPermission({user_id,"news.equipement"}) then
    		CancelEvent()
    		TriggerClientEvent("Mic:ToggleMic", from)
			else
				vRPclient.notify(from, {"You must be signed in to news job."})
			end
		end
	end
end)

function splitString(str, sep)
  if sep == nil then sep = "%s" end

  local t={}
  local i=1

  for str in string.gmatch(str, "([^"..sep.."]+)") do
    t[i] = str
    i = i + 1
  end

  return t
end
