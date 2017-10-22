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
  -- if garage == "police" then
  --   if vRP.hasPermission(player,"police.vehicle") then
  --     -- Rank 6 +
  --     if (string.lower(vehicle) == "fbicharger") and not (vRP.hasPermission(player,"police.rank6") or vRP.hasPermission(player,"police.rank7")) then
  --       vRPclient.notify(source,{"You do not meet the rank requirement."})
  --       return false
  --     end
  --   end
  -- end
  purchaseLicense(source, license)
  return true
end)

function purchaseLicense(player, license)
  local user_id = vRP.getUserId(player)

  if license then
    -- buy vehicle
    local license_info = licenses[license]
    local license_owned = playerLicenses.getPlayerLicense(user_id, license)
    if license_owned == 1 then
      vRPclient.notify(player,{"You already have a "..license_info[1]})
    elseif license_info then
      vRP.request(player, "Do you want to buy "..license_info[1].." for $"..license_info[2], 15, function(player,ok)
        if ok and vRP.tryFullPayment(user_id,license_info[2]) then
          MySQL.Async.execute('UPDATE vrp_user_identities SET '..license_info[3]..' = 1 WHERE user_id = @user_id', {user_id = user_id}, function(rowsChanged) end)
          vRPclient.notify(player,{"The state has issued you a "..license_info[1].." for $"..license_info[2]})
          Log.write(user_id, "Purchased "..license_info[1].." for "..license_info[2], Log.log_type.purchase)
        end
      end)
    else
      vRPclient.notify(player,{lang.money.not_enough()})
    end
  end
end

function playerLicenses.getPlayerLicenses(user_id, cbr)
  local task = Task(cbr,{false})
  local _plicenses = {}
  MySQL.Async.fetchAll('SELECT driverlicense,firearmlicense,pilotlicense FROM vrp_user_identities WHERE user_id = @user_id', {user_id = user_id}, function(_plicenses)
    task({_plicenses[1]})
  end)
end

function playerLicenses.getPlayerLicense(user_id, license, cbr)
  local task = Task(cbr,{false})

  playerLicenses.getPlayerLicenses(user_id, function(licenses)
    for k,v in pairs(licenses) do
      if k == license then
        task({tonumber(v)})
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
