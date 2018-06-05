local holdingup = false
local store = ""
local secondsRemaining = 0

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

local stores = {
	["paleto_twentyfourseven"] = {
		position = { x = 1734.82250976563, y = 6420.0400390625, z = 35.0372276306152 },
		reward = 10000,
		nameofstore = "Twenty Four Seven. (Paleto Bay)",
		lastrobbed = 0,
		timetorob = 8
	},
	["grapeseed_twentyfoursever"] = {
		position = { x = 1706.8193359375, y = 4920.0903320313, z = 42.063671112061 },
		reward = 8000,
		nameofstore = "Twenty Four Seven. (Grapeseed)",
		lastrobbed = 0,
		timetorob = 6
	},
	["sandyshores_twentyfoursever"] = {
		position = { x = 1959.357421875, y = 3748.55346679688, z = 32.3437461853027 },
		reward = 7000,
		nameofstore = "Twenty Four Seven. (Sandy Shores)",
		lastrobbed = 0,
		timetorob = 6
	},
	["bar_one"] = {
		position = { x = 1982.78100585938, y = 3052.92529296875, z = 47.2150535583496 },
		reward = 7000,
		nameofstore = "Yellow Jack. (Sandy Shores)",
		lastrobbed = 0,
		timetorob = 5
	},
	["routesixtyeight_twentyfoursever"] = {
		position = { x = 546.11102294922, y = 2663.4409179688, z = 42.156536102295 },
		reward = 8000,
		nameofstore = "Twenty Four Seven. (Route 68)",
		lastrobbed = 0,
		timetorob = 5,
	},
	["chumash_twentyfoursever"] = {
		position = { x = -3249.4548339844, y = 1004.3596191406, z = 12.830714225769 },
		reward = 7000,
		nameofstore = "Twenty Four Seven. (Chumash)",
		lastrobbed = 0,
		timetorob = 5,
	},
	["littleseoul_twentyfourseven"] = {
		position = { x = -709.17022705078, y = -904.21722412109, z = 19.215591430664 },
		reward = 5000,
		nameofstore = "Twenty Four Seven. (Little Seoul)",
		lastrobbed = 0,
		timetorob = 5
	},
	["mirrorpark_twentyfourseven"] = {
		position = { x = 1160.5590820313, y = -314.16375732422, z = 69.205055236816 },
		reward = 5000,
		nameofstore = "Twenty Four Seven. (Mirror Park)",
		lastrobbed = 0,
		timetorob = 5
	},
}

RegisterNetEvent('379dfd77-3ace-4ef9-b260-a305df349dc6')
AddEventHandler('379dfd77-3ace-4ef9-b260-a305df349dc6', function(robb)
	holdingup = true
	store = robb
	secondsRemaining = stores[store].timetorob*60
end)

RegisterNetEvent('1e7b9376-b99f-4474-8d70-15700b4866f9')
AddEventHandler('1e7b9376-b99f-4474-8d70-15700b4866f9', function(robb)
	holdingup = false
	TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "The robbery was cancelled, you will receive nothing.")
	robbingName = ""
	secondsRemaining = 0
	incircle = false
end)


RegisterNetEvent('a95bd4a8-f28f-42d8-bc25-cb41acd17a20')
AddEventHandler('a95bd4a8-f28f-42d8-bc25-cb41acd17a20', function(robb)
	holdingup = false
	TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Robbery done, you received: ^2" .. stores[store].reward)
	store = ""
	secondsRemaining = 0
	incircle = false
end)

Citizen.CreateThread(function()
	while true do
		if holdingup then
			Citizen.Wait(1000)
			if(secondsRemaining > 0)then
				secondsRemaining = secondsRemaining - 1
			end
		end

		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	for k,v in pairs(stores)do
		local ve = v.position

		local blip = AddBlipForCoord(ve.x, ve.y, ve.z)
		SetBlipSprite(blip, 52)
		SetBlipScale(blip, 0.8)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Robbable Store")
		EndTextCommandSetBlipName(blip)
	end
end)
incircle = false

Citizen.CreateThread(function()
	while true do
		local pos = GetEntityCoords(GetPlayerPed(-1), true)

		for k,v in pairs(stores)do
			local pos2 = v.position

			if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 15.0)then
				if not holdingup then
					DrawMarker(23, v.position.x, v.position.y, v.position.z - 0.97, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 1555, 0, 0,255, 0, 0, 0,0)

					if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 1.0)then
						if (incircle == false) then
							DisplayHelpText("Press ~INPUT_CONTEXT~ to rob ~b~" .. v.nameofstore .. "~w~ beware, the police will be alerted!")
						end
						incircle = true
						if(IsControlJustReleased(1, 51))then
							TriggerServerEvent('a59a4248-7ff4-4b4d-8290-07cd985c15e4', k)
						end
					elseif(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) > 1.0)then
						incircle = false
					end
				end
			end
		end

		if holdingup then

			tvRP.missionText("Robbing store: ~r~" .. secondsRemaining .. "~w~ seconds remaining")

			local pos2 = stores[store].position

			if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) > 10)then
				TriggerServerEvent('7a4e838f-22d5-42cd-ad2b-2f39225781c1', store)
			end
			if tvRP.isInComa() or tvRP.isHandcuffed() then
				TriggerServerEvent('4d8c4da1-3c89-466a-b39f-2bd74515066b', store)
			end
		end

		Citizen.Wait(0)
	end
end)
