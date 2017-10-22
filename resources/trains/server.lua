
PlayerCount = 0
list = {}


RegisterServerEvent("trains:playerActivated")
RegisterServerEvent("playerDropped")

function ActivateTrain ()
	if (PlayerCount) == 1 then
		TriggerClientEvent('StartTrain', GetHostId())
	else
		SetTimeout(15000,ActivateTrain)
	end
end
--snippet from hardcap to make PlayerCount work

-- yes i know i'm lazy
AddEventHandler('trains:playerActivated', function(source)
  if not list[source] then
    PlayerCount = PlayerCount + 1
    list[source] = true
		if (PlayerCount) == 1 then -- new session?
			SetTimeout(15000,ActivateTrain)
		end
  end
end)

AddEventHandler('playerDropped', function()
  if list[source] then
    PlayerCount = PlayerCount - 1
    list[source] = nil
  end
end)


