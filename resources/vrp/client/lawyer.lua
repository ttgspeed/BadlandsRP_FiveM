local threadRunning = false
local startTime = 0
local totalTime = 0
local labels = {}
labels["mrpd"] = "Mission Row PD"
labels["spd"] = "Sandy Shores PD"
labels["ppd"] = "Paleto PD"

function tvRP.lawyerThread(toggle,time)
  if toggle then
    tvRP.notify("You have been signed into PD")
    if not threadRunning then
      TriggerEvent("izone:isPlayerInZoneList", {"mrpd", "spd", "ppd"}, function(cb,zone)
        if cb and zone ~= nil then
          startTime = time
          totalTime = 0
          Citizen.CreateThread(function()
            threadRunning = true
            tvRP.setFiringPinState(false)
          	while threadRunning do
          		Citizen.Wait(1000)
              totalTime = totalTime + 1
              TriggerEvent("izone:isPlayerInZone", zone, function(cb)
                if cb ~= nil and not cb then
                  threadRunning = false
                  tvRP.notify("You moved too far from "..labels[zone]..". You have been signed out of PD.")
                  tvRP.setFiringPinState(true)
                  vRPserver.lawyerPayment({startTime})
                  print("Time spent "..totalTime)
                  startTime = 0
                end
              end)
            end
          end)
        end
      end)
    end
  else
    threadRunning = false
    tvRP.setFiringPinState(true)
    tvRP.notify("You have been signed out of PD")
    vRPserver.lawyerPayment({startTime})
    startTime = 0
  end
end

function tvRP.isActiveLawyer()
  return threadRunning
end
