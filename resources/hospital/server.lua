local Proxy = module("vrp", "lib/Proxy")
local Tunnel = module("vrp", "lib/Tunnel")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","hospital")

isTransfer = false
commands_enabled = true

local bedpos = {
  {347.84378051758,-595.49896240234,28,240.6},
  {353.98980712891,-593.00109863281,28,249},
  {352.16778564453,-597.50714111328,28,60.9}
}

-- HELPER FUNCTIONS
function round(num, numDecimalPlaces)
  local mult = 5^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

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

if commands_enabled then
  AddEventHandler('chatMessage', function(from,name,message)
    if(string.sub(message,1,1) == "/") then

      local args = splitString(message)
      local cmd = args[1]
      local source = from
      local user_id = vRP.getUserId({source})
      local data = vRP.getUserDataTable({user_id})

      if cmd == "/hospital" then
        --Citizen.Trace("GH")
        data.position = {x=347.7,y=-595.03,z=28.95}
        vRPclient.notify(source, {"The doctors are tending to you!"})
        TriggerClientEvent('hospital:PutInBed',from)
      elseif cmd == "/dead" then
        vRPclient.notify(source, {"You dead!"})
        vRPclient.setHealth(source, {2.0})
      end
    end
  end)
end
