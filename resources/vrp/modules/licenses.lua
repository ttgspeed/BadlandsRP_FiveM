local Log = module("lib/Log")
local cfg = module("cfg/licenses")
local lang = vRP.lang
local licenses = cfg.licenses

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
	vRP.setPlayerLicense(user_id,"driverschool",1)
end)

function purchaseLicense(player, license)
	local user_id = vRP.getUserId(player)

	if license then
		-- buy vehicle
		local license_info = licenses[license]
		vRP.getPlayerLicense(user_id, license, function(licensed,suspended,suspension_count)
			if licensed == -1 then
				vRPclient.notify(player,{"The government has suspended your "..license_info[1].."; you may not obtain a new one."})
			elseif suspended > 0 and ((os.time() - suspended) < 43200) then
				vRPclient.notify(player,{"The government has suspended your "..license_info[1].."; you may purchase a new one in "..math.floor((43200-(os.time()-suspended))/60).." minutes."})
			elseif licensed == 1 then
				vRPclient.notify(player,{"You already have a "..license_info[1]})
			elseif licensed then
				license_price = license_info[2]+math.floor((math.floor(license_info[2])*0.25)*suspension_count)
				vRP.request(player, "Do you want to buy "..license_info[1].." for $"..license_price, 15, function(player,ok)
					if ok and vRP.tryFullPayment(user_id,license_price) then
						vRP.setPlayerLicense(user_id,license_info[3],1)
						vRPclient.notify(player,{"The state has issued you a "..license_info[1].." for $"..license_price})
						Log.write(user_id, "Purchased "..license_info[1].." for "..license_price, Log.log_type.purchase)
					end
				end)
			else
				vRPclient.notify(player,{lang.money.not_enough()})
			end
		end)
	end
end

function vRP.getPlayerLicense(user_id, license, cbr)
	local task = Task(cbr,{false})

	vRP.getUData(user_id, "vRP:licenses", function(licenses)
		licenses = json.decode(licenses)
		if licenses ~= nil then
			task({tonumber(licenses[license].licensed),tonumber(licenses[license].suspended),tonumber(licenses[license].suspension_count)})
		else
			task({nil})
		end
	end)
end

function tvRP.getPlayerLicense_client(license)
	local task = TUNNEL_DELAYED()
	local user_id = vRP.getUserId(source)

	vRP.getPlayerLicense(user_id, license, function(has_license)
		task({has_license})
	end)
end

function vRP.setPlayerLicense(user_id, license, status)
	local task = Task(cbr,{false})

	vRP.getUData(user_id, "vRP:licenses", function(licenses)
		licenses = json.decode(licenses)
		if licenses ~= nil then
			licenses[license].licensed = status
			vRP.setUData(user_id, "vRP:licenses", json.encode(licenses))
		end
	end)
end

function vRP.suspendPlayerLicense(user_id, license)
	local task = Task(cbr,{false})

	vRP.getUData(user_id, "vRP:licenses", function(licenses)
		licenses = json.decode(licenses)
		if licenses ~= nil then
			licenses[license].licensed = 0
			licenses[license].suspended = os.time()
			licenses[license].suspension_count = licenses[license].suspension_count + 1
			vRP.setUData(user_id, "vRP:licenses", json.encode(licenses))
		end
	end)
end

--Handle default new player license data, and migration of old license data to new
AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
	local user_id = user_id
  if first_spawn then
		MySQL.Async.fetchAll('SELECT driverschool,driverlicense,firearmlicense,pilotlicense,licenses_migrated,towlicense FROM vrp_user_identities WHERE user_id = @user_id', {user_id = user_id}, function(rows)
			local license_migration_data = {
				["driverschool"] = {
					["licensed"] = 0,
					["suspended"] = 0,
					["suspension_count"] = 0
				},
				["driverlicense"] = {
					["licensed"] = 0,
					["suspended"] = 0,
					["suspension_count"] = 0
				},
				["firearmlicense"] = {
					["licensed"] = 0,
					["suspended"] = 0,
					["suspension_count"] = 0
				},
				["pilotlicense"] = {
					["licensed"] = 0,
					["suspended"] = 0,
					["suspension_count"] = 0
				},
				["towlicense"] = {
					["licensed"] = 0,
					["suspended"] = 0,
					["suspension_count"] = 0
				}
			}

	    if #rows > 0 then
				local data = rows[1]
				if tonumber(data.licenses_migrated) == 0 then
					license_migration_data.driverschool.licensed = data.driverschool
					license_migration_data.driverlicense.licensed = data.driverlicense
					license_migration_data.firearmlicense.licensed = data.firearmlicense
					license_migration_data.pilotlicense.licensed = data.pilotlicense
					license_migration_data.towlicense.licensed = data.towlicense

					vRP.setUData(user_id, "vRP:licenses", json.encode(license_migration_data))
					MySQL.Async.execute('UPDATE vrp_user_identities SET licenses_migrated = 1 WHERE user_id = @user_id', {user_id = user_id})
				end
	    end
	  end)
  end
end)
