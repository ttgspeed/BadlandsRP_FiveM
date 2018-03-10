local Tunnel = module("lib/Tunnel")
local Log = module("lib/Log")

local htmlEntities = module("lib/htmlEntities")

local cfg = module("cfg/licenses")
local lang = vRP.lang

local licenses = cfg.licenses

local sanitizes = module("cfg/sanitizes")

playerLicenses = {} -- you can add function to playerGarage later in other server scripts
ownedLicenses = {}
Tunnel.bindInterface("playerLicenses",playerLicenses)
clientaccess = Tunnel.getInterface("playerLicenses","playerLicenses") -- the second argument is a unique id for this tunnel access, the current resource name is a good choice

-- this module describe the license system
-- api

RegisterServerEvent('vrp:purchaseLicense')
AddEventHandler('vrp:purchaseLicense', function(license)
  purchaseLicense(source, license)
  return true
end)

RegisterServerEvent("vrp:driverSchoolPassed")
AddEventHandler("vrp:driverSchoolPassed", function()
	local user_id = vRP.getUserId(source)
  exports['GHMattiMySQL']:QueryAsync('UPDATE vrp_user_identities SET driverschool = 1 WHERE user_id = @user_id', {["@user_id"] = user_id}, function(rowsChanged) end)
end)

function purchaseLicense(player, license)
  local user_id = vRP.getUserId(player)

  if license then
    -- buy vehicle
    local license_info = licenses[license]
    playerLicenses.getPlayerLicense(user_id, license, function(license_owned)
      if license_owned == -1 then
        vRPclient.notify(player,{"The government has suspended your "..license_info[1].."; you may not obtain a new one."})
      elseif license_owned == 1 then
        vRPclient.notify(player,{"You already have a "..license_info[1]})
      elseif license_owned then
        vRP.request(player, "Do you want to buy "..license_info[1].." for $"..license_info[2], 15, function(player,ok)
          if ok and vRP.tryFullPayment(user_id,license_info[2]) then
            exports['GHMattiMySQL']:QueryAsync('UPDATE vrp_user_identities SET '..license_info[3]..' = 1 WHERE user_id = @user_id', {["@user_id"] = user_id}, function(rowsChanged) end)
            vRPclient.notify(player,{"The state has issued you a "..license_info[1].." for $"..license_info[2]})
            Log.write(user_id, "Purchased "..license_info[1].." for "..license_info[2], Log.log_type.purchase)
          end
        end)
      else
        vRPclient.notify(player,{lang.money.not_enough()})
      end
    end)
  end
end

function playerLicenses.getPlayerLicenses(user_id, cbr)
  local task = Task(cbr,{false})
  local _plicenses = {}
  exports['GHMattiMySQL']:QueryResultAsync('SELECT driverschool,driverlicense,firearmlicense,pilotlicense,towlicense FROM vrp_user_identities WHERE user_id = @user_id', {["@user_id"] = user_id}, function(_plicenses)
    if #_plicenses > 0 then  -- found
      task({_plicenses[1]})
    else -- not found
      task()
    end

  end)
end

function playerLicenses.getPlayerLicense(user_id, license, cbr)
  local task = Task(cbr,{false})

  playerLicenses.getPlayerLicenses(user_id, function(licenses)
    if licenses ~= nil then
      for k,v in pairs(licenses) do
        if k == license then
          task({tonumber(v)})
        end
      end
    end
  end)
end

function playerLicenses.getPlayerLicenses_client(message)
  local user_id = vRP.getUserId(source)
  playerLicenses.getPlayerLicenses(user_id)
end

function playerLicenses.getPlayerLicense_client(license)
  local task = TUNNEL_DELAYED()
  local user_id = vRP.getUserId(source)

  playerLicenses.getPlayerLicense(user_id, license, function(has_license)
    task({has_license})
  end)
end

vRP.playerLicenses = playerLicenses
