local threadRunning = false
local totalTime = 0

function tvRP.lawyerThread(toggle)
  if toggle then
    tvRP.notify("You have been signed into PD")
    if not threadRunning then
      totalTime = 0
      Citizen.CreateThread(function()
        threadRunning = true
        tvRP.setFiringPinState(false)
      	while threadRunning do
      		Citizen.Wait(1000)
          totalTime = totalTime + 1
          TriggerEvent("izone:isPlayerInZone", "mrpd", function(cb)
            if cb ~= nil and not cb then
              threadRunning = false
              tvRP.notify("You moved too far from Mission Row PD. You have been signed out of PD.")
              tvRP.setFiringPinState(true)
              vRPserver.lawyerPayment({totalTime})
              print("Time spent "..totalTime)
            end
          end)
        end
      end)
    end
  else
    threadRunning = false
    tvRP.setFiringPinState(true)
    tvRP.notify("You have been signed out of PD")
    vRPserver.lawyerPayment({totalTime})
    print("Time spent "..totalTime)
  end
end

function tvRP.isActiveLawyer()
  return threadRunning
end
