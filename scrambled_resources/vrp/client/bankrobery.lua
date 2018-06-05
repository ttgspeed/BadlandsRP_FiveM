local robbing = false
local bank = ""
local secondsRemaining = 0

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

local banks = {
	["fleeca"] = {
		position = { x = 147.04908752441, y = -1044.9448242188, z = 29.36802482605 },
		reward = 50000,
		nameofbank = "Fleeca Bank",
		lastrobbed = 0
	},
	["fleeca2"] = {
		position = { x = -2957.6674804688, y = 481.45776367188, z = 15.697026252747 },
		reward = 20000,
		nameofbank = "Fleeca Bank (Highway)",
		lastrobbed = 0
	},
	["blainecounty"] = {
		position = { x = -107.06505584717, y = 6474.8012695313, z = 31.62670135498 },
		reward = 20000,
		nameofbank = "Blaine County Savings",
		lastrobbed = 0
	}
}

RegisterNetEvent('ea4229ab-923a-4da0-b525-53298d777395')
AddEventHandler('ea4229ab-923a-4da0-b525-53298d777395', function(robb)
	robbing = true
	bank = robb
	secondsRemaining = 300
end)

RegisterNetEvent('4ad70126-462d-4a21-8ba7-00eea4100ae3')
AddEventHandler('4ad70126-462d-4a21-8ba7-00eea4100ae3', function(robb)
	robbing = false
	TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "The robbery was cancelled, you will receive nothing.")
	robbingName = ""
	secondsRemaining = 0
	incircle = false
end)


RegisterNetEvent('2f9eb93b-a404-44d4-b72d-80282ae3788e')
AddEventHandler('2f9eb93b-a404-44d4-b72d-80282ae3788e', function(robb)
	robbing = false
	TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Robbery done, you received: ^2" .. banks[bank].reward)
	bank = ""
	secondsRemaining = 0
	incircle = false
end)

--DISABLED UNTIL A DEPOSIT COOLDOWN IS IN PLACE
--[[
Citizen.CreateThread(function()
	while true do
		if robbing then
			Citizen.Wait(1000)
			if(secondsRemaining > 0)then
				secondsRemaining = secondsRemaining - 1
			end
		end

		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	for k,v in pairs(banks)do
		local ve = v.position

		local blip = AddBlipForCoord(ve.x, ve.y, ve.z)
		SetBlipSprite(blip, 500)
		SetBlipScale(blip, 0.8)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Robbable Bank")
		EndTextCommandSetBlipName(blip)
	end
end)
incircle = false

Citizen.CreateThread(function()
	while true do
		local pos = GetEntityCoords(GetPlayerPed(-1), true)

		for k,v in pairs(banks)do
			local pos2 = v.position

			if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 15.0)then
				if not robbing then
					DrawMarker(1, v.position.x, v.position.y, v.position.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 1555, 0, 0,255, 0, 0, 0,0)

					if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 1.0)then
						if (incircle == false) then
							DisplayHelpText("Press ~INPUT_CONTEXT~ to rob ~b~" .. v.nameofbank .. "~w~ beware, the police will be alerted!")
						end
						incircle = true
						if(IsControlJustReleased(1, 51))then
							TriggerServerEvent('e687bd0d-46b5-48f2-8bd8-5c7f31deb2ae', k)
						end
					elseif(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) > 1.0)then
						incircle = false
					end
				end
			end
		end

		if robbing then

			tvRP.missionText("Robbing bank: ~r~" .. secondsRemaining .. "~w~ seconds remaining")

			local pos2 = banks[bank].position

			if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) > 7.5)then
				TriggerServerEvent('e4530be0-0f13-4174-aeb0-8a68252eab44', bank)
			end
		end

		Citizen.Wait(0)
	end
end)
]]--
