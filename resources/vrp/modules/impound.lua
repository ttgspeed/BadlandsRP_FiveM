local Tunnel = module("lib/Tunnel")
local Log = module("lib/Log")
local cfg = module("cfg/impound")
local cfgGarages = module("cfg/garages")
local lang = vRP.lang
local vehicle_groups = cfgGarages.garage_types

local garage_menus = {}
local menu = {
name="Los Santos Impound",
css={top = "75px", header_color="rgba(255,125,0,0.75)"}
}
garage_menus["impound"] = menu

menu["Impound Vehicle"] = {function(player,choice)
	vRPclient.impoundVehicleAtYard(player,{},function(ok,carName,plate)
		-- Successfull impound
		if ok then
			vRP.getUserByRegistration(plate, function(nuser_id)
				allowPay = true -- set to false if bad data to prevent exploits
				if carName == nil then
					carName = "unk"
					allowPay = false
				end
				if nuser_id == nil then
					nuser_id = "unk"
					allowPay = false
				end
				local user_id = vRP.getUserId(player)
				Log.write(user_id, "Impounded a "..carName.." owned by ID "..nuser_id..". Received $"..cfg.impound_pay, Log.log_type.garage)
				if allowPay then
					vRP.giveBankMoney(user_id,cfg.impound_pay)
					vRPclient.notify(player,{"We have transfered $"..cfg.impound_pay.." to your bank account."})
				end
			end)
		end
	end)
end, "Impound the nearest vehicle"}

local function build_client_garages(source)
  local user_id = vRP.getUserId(source)
  if user_id ~= nil then
    for k,v in pairs(cfg.locations) do
      local gtype,x,y,z = table.unpack(v)

      local group = vehicle_groups[gtype]
      if group then
        local gcfg = group._config

        -- enter
        local garage_enter = function(player,area)
          local user_id = vRP.getUserId(source)
          if user_id ~= nil and vRP.hasPermission(user_id,"towtruck.impound") then
            local menu = garage_menus[gtype]
            if menu then
              vRP.openMenu(player,menu)
            end
          end
        end

        -- leave
        local garage_leave = function(player,area)
          vRP.closeMenu(player)
        end

        if gcfg.blipid ~= 0 then
        vRPclient.addBlip(source,{x,y,z,gcfg.blipid,gcfg.blipcolor,lang.garage.title({gtype})})
        end
        vRPclient.addMarker(source,{x,y,z-1,3.5,3.5,0.0,0,255,125,125,150,23})

        vRP.setArea(source,"vRP:impoundTow"..k,x,y,z,3.5,1.5,garage_enter,garage_leave)
      end
    end
  end
end

AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
  if first_spawn then
    -- We dont use vRP garages
    build_client_garages(source)
  end
end)
