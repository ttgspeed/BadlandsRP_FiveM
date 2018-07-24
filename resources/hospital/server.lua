local Proxy = module("vrp", "lib/Proxy")
local Tunnel = module("vrp", "lib/Tunnel")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","hospital")
THclient = Tunnel.getInterface("hospital","hospital")
vRPhs = {}
Tunnel.bindInterface("hospital",vRPhs)
Proxy.addInterface("hospital",vRPhs)

isTransfer = false
local commands_enabled = false

local bedfound = false

local cfg = {}

cfg.healdefault = 30 -- adjustable to how long revive takes

local bedpos = {
  ["1"] = {
    position = {x = 347.84378051758, y = -595.49896240234, z = 28, rot = 240.6},
    inuse = 0
  },
  ["2"] = {
    position = { x = 354.38980712891, y = -593.20109863281, z = 28, rot = 72.1},
    inuse = 0
  },
  ["3"] = {
    position = {x = 351.82476806641, y = -597.33819580078, z = 28, rot = 72.1},
    inuse = 0
  }
}

Citizen.CreateThread(function()
	while true do
			Citizen.Wait(1000)
      for k,v in pairs(bedpos)do
        local inuse_ = v.inuse
        if inuse_ ~= 0 and inuse_ ~= nil then
          v.inuse = inuse_ - 1
        end
      end
	end
end)

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

function vRPhs.PutInBedServer(sourcePed, patient)
  print("I got here")
  for k,v in pairs(bedpos)do
    local pos = v.position
    local inuse_ = v.inuse
    if inuse_ == 0 or inuse_ == nil then
      THclient.PutInBed(patient, {pos.x, pos.y, pos.z, pos.rot})
      --TriggerClientEvent('hospital:PutInBed',patient, pos.x, pos.y, pos.z, pos.rot)
      v.inuse = cfg.healdefault
      bedfound = true
      break
    end
  end
  if bedfound == false then
    vRPclient.notify(sourcePed, {"All beds are full, please wait for a bed."})
  else
    vRPclient.notify(sourcePed, {"The doctors are tending to you!"})
    bedfound = false
  end
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
        for k,v in pairs(bedpos)do
          local pos = v.position
          local inuse_ = v.inuse
          if inuse_ == 0 or inuse_ == nil then
            TriggerClientEvent('hospital:PutInBed',source, pos.x, pos.y, pos.z, pos.rot)
            v.inuse = cfg.healdefault
            bedfound = true
            break
          end
        end
        if bedfound == false then
          vRPclient.notify(source, {"All beds are full, please wait for a bed."})
        else
          vRPclient.notify(source, {"The doctors are tending to you!"})
          bedfound = false
        end

      elseif cmd == "/dead" then
        vRPclient.notify(source, {"You dead!"})
        vRPclient.setHealth(source, {2.0})
      elseif cmd == "/resetbeds" then
        for k,v in pairs(bedpos)do
          local pos = v.position
          local inuse_ = v.inuse
            v.inuse = 0
        end
      end
    end
  end)
end
