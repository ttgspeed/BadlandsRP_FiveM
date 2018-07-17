Tunnel = module("vrp", "lib/Tunnel")
Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")

vRPclient = Tunnel.getInterface("vRP", "vrp_pets_server")

local pets = {
	["chien"] = {
		name = "Dog",
		price = 10000
	},
	["chat"] = {
		name = "Cat",
		price = 10000
	},
	["loup"] = {
		name = "Wolf",
		price = 10000
	},
	["lapin"] = {
		name = "Rabbit",
		price = 10000
	},
	["husky"] = {
		name = "Husky",
		price = 10000
	},
	["cochon"] = {
		name = "Pig",
		price = 10000
	},
	["caniche"] = {
		name = "Poodle",
		price = 10000
	},
	["carlin"] = {
		name = "Pug",
		price = 10000
	},
	["retriever"] = {
		name = "Retriever",
		price = 10000
	},
	["berger"] = {
		name = "Shepherd",
		price = 10000
	},
	["westie"] = {
		name = "Westie",
		price = 10000
	}
}

RegisterServerEvent("vrp_pets:animalname")
AddEventHandler("vrp_pets:animalname", function (source, method)
	local _source = source
	local user_id = vRP.getUserId({_source})
	MySQL.Async.fetchAll('SELECT * FROM vrp_user_pets WHERE user_id = @user_id', {['@user_id'] = user_id}, function(result)
		if method == "callPet" then
			TriggerClientEvent("vrp_pets:callPet", _source, result[1].pet)
		elseif method == "orders" then
			TriggerClientEvent("vrp_pets:orders", _source, result[1].pet)
		end
	end)
end)

RegisterServerEvent("vrp_pets:dead")
AddEventHandler("vrp_pets:dead", function()
	local _source = source
	local user_id = vRP.getUserId({_source})

	MySQL.Async.execute('UPDATE vrp_user_pets SET pet = NULL WHERE user_id = @user_id', {['@user_id'] = user_id})
end)

RegisterServerEvent('vrp_pets:startHarvest')
AddEventHandler('vrp_pets:startHarvest', function()
	local _source = source
	local user_id = vRP.getUserId({_source})
	vRP.tryGetInventoryItem({user_id, 'scooby_snacks', 1})
end)

RegisterServerEvent('vrp_pets:takeanimal')
AddEventHandler('vrp_pets:takeanimal', function (source, petid, price)
	local _source = source
	local user_id = vRP.getUserId({_source})
	local playerMoney = vRP.getMoney({user_id})

	if playerMoney >= price then
		vRP.tryPayment({user_id, price})
		MySQL.Async.execute('UPDATE vrp_user_pets SET pet = @pet WHERE user_id = @user_id', {['@user_id'] = user_id, ['@pet'] = petid})
		vRPclient.notify(_source, {"You got a " .. pets[petid].name .. " for $" .. price})
	else
		vRPclient.notify(_source, {"Insufficient Funds"})
	end
end)

RegisterServerEvent("vrp_pets:buypet")
AddEventHandler("vrp_pets:buypet", function ()
	local _source = source
	local menudata = {}

	menudata.name = "Pet Shop"
	menudata.css = "align = 'top-left'"

	for k, v in pairs(pets) do
		menudata[v.name] = {function (choice)
			TriggerEvent("vrp_pets:takeanimal", _source, k, v.price)
			vRP.closeMenu({_source})
		end, "$" .. v.price}
	end

	vRP.openMenu({_source, menudata})
end)

RegisterServerEvent("vrp_pets:petMenu")
AddEventHandler("vrp_pets:petMenu", function (status, come, isInVehicle)
	local _source = source
	local user_id = vRP.getUserId({_source})
	local menudata = {}

	menudata.name = "Pet Management"
	menudata.css = {align = 'top-left'}

	if come == 1 then
		menudata["Give food"] = {function (choice)
			local data = vRP.getUserDataTable({user_id})
			TriggerClientEvent("vrp_pets:givefood", _source, data.inventory)
			vRP.closeMenu({_source})
		end, "Hunger :" .. status .. "%"}
		--[[
		menudata["Attach/detach your pet"] = {function (choice)
			TriggerClientEvent("vrp_pets:attachdetach", _source)
			vRP.closeMenu({_source})
		end}
		]]--
		if isInVehicle then
			menudata["Get Out of Vehicle"] = {function (choice)
				TriggerClientEvent("vrp_pets:enterleaveveh", _source)
				vRP.closeMenu({_source})
			end}
		else
			menudata["Get In Vehicle"] = {function (choice)
				TriggerClientEvent("vrp_pets:enterleaveveh", _source)
				vRP.closeMenu({_source})
			end}
		end

		menudata["Give an order"] = {function (choice)
			TriggerEvent("vrp_pets:animalname", _source, "orders")
			vRP.closeMenu({_source})
		end}
	else
		menudata["Call your pet"] = {function (choice)
			if come == 0 then
				TriggerEvent("vrp_pets:animalname", _source, "callPet")
				vRP.closeMenu({_source})
			end
		end}
	end

	vRP.openMenu({_source, menudata})
end)

RegisterServerEvent("vrp_pets:ordersMenu")
AddEventHandler("vrp_pets:ordersMenu", function (data, model, inanimation)
	local _source = source
	local menudata = {}

	menudata.name = "Pet Orders"
	menudata.css = {align = 'top-left'}

	if not inanimation then
		--[[
		if model ~= 1462895032 then
			menudata["Search for the ball"] = {function (choice) -- balle
				TriggerClientEvent("vrp_pets:findball", _source)
				vRP.closeMenu({_source})
			end}
		end
		]]--
		menudata["Follow Me"] = {function (choice) -- pied
			TriggerClientEvent("vrp_pets:followme", _source)
			vRP.closeMenu({_source})
		end}
		menudata["Send pet home"] = {function (choice) -- niche
			TriggerClientEvent("vrp_pets:goHome", _source)
			vRP.closeMenu({_source})
		end}

		if (data == "chien") then
			menudata["Sit"] = {function (choice) -- assis
				TriggerClientEvent("vrp_pets:seat", _source, 1)
				vRP.closeMenu({_source})
			end}
			menudata["Lie Down"] = {function (choice) -- coucher
				TriggerClientEvent("vrp_pets:laydown", _source, 1)
				vRP.closeMenu({_source})
			end}
		end
		if (data == "chat") then
			menudata["Lie Down"] = {function (choice) -- coucher2
				TriggerClientEvent("vrp_pets:laydown", _source, 2)
				vRP.closeMenu({_source})
			end}
		end
		if (data == "loup") then
			menudata["Lie Down"] = {function (choice) -- coucher3
				TriggerClientEvent("vrp_pets:laydown", _source, 3)
				vRP.closeMenu({_source})
			end}
		end
		if (data == "carlin") then
			menudata["Sit"] = {function (choice) -- assis2
				TriggerClientEvent("vrp_pets:seat", _source, 2)
				vRP.closeMenu({_source})
			end}
		end
		if (data == "retriever") then
			menudata["Sit"] = {function (choice) -- assis3
				TriggerClientEvent("vrp_pets:seat", _source, 3)
				vRP.closeMenu({_source})
			end}
		end
	else
		menudata["Stand Up"] = {function (choice) -- debout
			TriggerClientEvent("vrp_pets:standup", _source)
			vRP.closeMenu({_source})
		end}
	end

	vRP.openMenu({_source, menudata})
end)
