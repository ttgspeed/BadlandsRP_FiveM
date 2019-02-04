local holdingup = false
local store = ""
local secondsRemaining = 0

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

local store = {}
local store_key = ""

RegisterNetEvent('es_holdup:currentlyrobbing')
AddEventHandler('es_holdup:currentlyrobbing', function(store_k,store_v)
	holdingup = true
	store = store_v
	store_key = store_k
	secondsRemaining = store.timetorob*60
end)

RegisterNetEvent('es_holdup:toofarlocal')
AddEventHandler('es_holdup:toofarlocal', function()
	holdingup = false
	TriggerEvent('chat:addMessage', {
			template = '<div style="padding: 0.25vw; margin: 0.1vw; display: inline-block; background-color: rgba(230, 0, 0, 0.6); border-radius: 3px;"><i class="fas fa-newspaper"></i> {0}</div>',
			args = { "The robbery was cancelled, you received nothing." }
	})
	robbingName = ""
	secondsRemaining = 0
end)


RegisterNetEvent('es_holdup:robberycomplete')
AddEventHandler('es_holdup:robberycomplete', function(reward)
	holdingup = false
	TriggerEvent('chat:addMessage', {
			template = '<div style="padding: 0.25vw; margin: 0.1vw; display: inline-block; background-color: rgba(230, 0, 0, 0.6); border-radius: 3px;"><i class="fas fa-newspaper"></i> {0}</div>',
			args = { "Robbery completed, you received $^2" .. reward }
	})
	store = {}
	secondsRemaining = 0
end)

Citizen.CreateThread(function()
	while true do
		if holdingup then
			Citizen.Wait(1000)
			if(secondsRemaining > 0)then
				secondsRemaining = secondsRemaining - 1
			end
			vRPserver.getInventoryItemAmount({"safe_kit"}, function(count)
				if count < 1 then
					TriggerServerEvent('es_holdup:cancel', store_key)
				end
			end)
		end

		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		local pos = GetEntityCoords(GetPlayerPed(-1), true)

		if holdingup then
			tvRP.missionText("Robbing store: ~r~" .. secondsRemaining .. "~w~ seconds remaining")

			local pos2 = store.safe_pos

			if(Vdist(pos.x, pos.y, pos.z, pos2[1], pos2[2], pos2[3]) > 10)then
				TriggerServerEvent('es_holdup:toofar', store_key)
			end
			if tvRP.isInComa() or tvRP.isHandcuffed() then
				TriggerServerEvent('es_holdup:cancel', store_key)
			end
		end

		Citizen.Wait(0)
	end
end)
