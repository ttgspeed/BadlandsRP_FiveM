vRP = Proxy.getInterface("vRP")
vRPserver = Tunnel.getInterface("vRP","meth")
methServer = Tunnel.getInterface("methServer","methClient")

-- meth = {}
-- Tunnel.bindInterface("methClient",meth)

methLabs = {
	"camper",
	"taco",
	"journey"
}

--check if a given car is a meth lab
function isCarMethLab(carModel)
	for i,v in ipairs(methLabs) do
		if carModel == GetHashKey(v) then return true end
	end
	return false
end

--returns the car name
function getCarName(carModel)
	for i,v in ipairs(methLabs) do
		if carModel == GetHashKey(v) then return v end
	end
	return nil
end

--Thread
Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(1000)
		local ped = GetPlayerPed(-1)
		local car = GetVehiclePedIsIn(ped, false)
		
		if car then
			local carModel = GetEntityModel(car)
			local carName = getCarName(carModel)
			if isCarMethLab(carModel) then 
				methServer.enterMethLab({car,carModel,carName})
				Citizen.Trace("DEBUG: Entering meth Lab")
			end
		end
	end
end)