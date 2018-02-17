local gymTimeRemaining = 0
local activeWorkout = false
local activeGymMembership = false

cfgGym = module("cfg/aptitudes")

local workouts = cfgGym.workouts

function tvRP.buyGymMemberShip()
	if not activeGymMembership then
		tvRP.startGymSession()
		tvRP.notify("Gym membership purchased. Remember to wipe down the equipment. Your membership while expire in "..cfgGym.membership_duration.." minutes.")
		Citizen.CreateThread(function()
			Citizen.Wait(60000*cfgGym.membership_duration)
			activeGymMembership = false
			tvRP.notify("Your gym membership has expired")
		end)
	end
end

function tvRP.getIsActiveMembership()
	return activeGymMembership
end
function tvRP.startGymSession()
	if not activeGymMembership then
		activeGymMembership = true
		Citizen.CreateThread(function()
		    while activeGymMembership do
		    	Citizen.Wait(1)
		    	for k,v in pairs(cfgGym.gyms) do
		    		local parts,x,y,z = table.unpack(v)
			    	local pos = GetEntityCoords(GetPlayerPed(-1), true)
			    	for k2,v2 in pairs(workouts[parts]) do
			    		local x,y,z,action = table.unpack(v2)
			    		if(Vdist(pos.x, pos.y, pos.z, x, y, z) < 0.5)then
			    			if not activeWorkout and not tvRP.getActionLock() then
			    				DisplayHelpText(cfgGym.excercises[action].text)
			    				if IsControlJustReleased(1, 51) then
			    					startWorkoutTimer(cfgGym.excercises[action].time)
			    					activeWorkout = true
			    					tvRP.playAnim(false,{task = cfgGym.excercises[action].task},false)
			    				end
			    			end
			    		end
			    	end
			    end
		    end
		end)
	end
end

Citizen.CreateThread(function()
	Citizen.Wait(10000)
	while true do
		Citizen.Wait(1)
		for k,v in pairs(cfgGym.gyms) do
    		local parts,x,y,z = table.unpack(v)
	    	local pos = GetEntityCoords(GetPlayerPed(-1), true)
	    	if (Vdist(pos.x, pos.y, pos.z, x, y, z) < 0.5) then
	    		if not activeGymMembership then
	    			DisplayHelpText("Press ~INPUT_CONTEXT~ to purchase membership")
	    			if IsControlJustReleased(1, 51) then
	    				vRPserver.tryBuyGymMemberShip({})
	    			end
	    		end
	    	end
	    end
	end
end)

function startWorkoutTimer(time)
	if not activeWorkout and time ~= nil then
		currentWorkoutTimer = time
		Citizen.CreateThread(function()
			while currentWorkoutTimer > 0 do
				currentWorkoutTimer = currentWorkoutTimer - 1
				Citizen.Wait(1000)
			end
			tvRP.endWorkout()
		end)
	end
end

function tvRP.endWorkout()
	if activeWorkout then
		tvRP.stopAnim(false)
		activeWorkout = false
		currentWorkoutTimer = 0
	end
end
