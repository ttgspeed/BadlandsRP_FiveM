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

RegisterNetEvent('es_raid:currentlyrobbing')
AddEventHandler('es_raid:currentlyrobbing', function(store_k,store_v)
	holdingup = true
	store = store_v
	store_key = store_k
	secondsRemaining = store.timetorob*60
end)

RegisterNetEvent('es_raid:toofarlocal')
AddEventHandler('es_raid:toofarlocal', function()
	holdingup = false
	TriggerEvent('chat:addMessage', {
			template = '<div style="padding: 0.25vw; margin: 0.1vw; display: inline-block; background-color: rgba(230, 0, 115, 0.6); border-radius: 3px;"><i class="fas fa-exclamation-circle"></i> {0}</div>',
			args = { "The raid was cancelled, the shop is still in business." }
	})
	robbingName = ""
	secondsRemaining = 0
end)


RegisterNetEvent('es_raid:robberycomplete')
AddEventHandler('es_raid:robberycomplete', function(reward)
	holdingup = false
	TriggerEvent('chat:addMessage', {
			template = '<div style="padding: 0.25vw; margin: 0.1vw; display: inline-block; background-color: rgba(230, 0, 115, 0.6); border-radius: 3px;"><i class="fas fa-exclamation-circle"></i> {0}</div>',
			args = { "Raid completed, this shop has been shut down!" }
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
		end

		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		local pos = GetEntityCoords(GetPlayerPed(-1), true)

		if holdingup then
			tvRP.missionText("Raiding store: ~r~" .. secondsRemaining .. "~w~ seconds remaining")

			local pos2 = store.safe_pos

			if(Vdist(pos.x, pos.y, pos.z, pos2[1], pos2[2], pos2[3]) > 10)then
				TriggerServerEvent('es_raid:toofar', store_key)
			end
			if tvRP.isInComa() or tvRP.isHandcuffed() then
				TriggerServerEvent('es_raid:cancel', store_key)
			end
		end

		Citizen.Wait(0)
	end
end)
