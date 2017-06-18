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

local smokeRunning = false
function startParticles(car)
	if smokeRunning then return end
	if not HasNamedPtfxAssetLoaded("core") then
		RequestNamedPtfxAsset("core")
		while not HasNamedPtfxAssetLoaded("core") do
			Wait(1)
		end
	end

	SetPtfxAssetNextCall("core")
	local part = StartParticleFxLoopedOnEntity("ent_amb_smoke_foundry", car, 0.0, 0.0, 2.0, 0.0,0.0,0.0,1.0, false, false, false)
	smokeRunning = true
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
				startParticles(car)
				Citizen.Trace("DEBUG: Entering meth Lab")
			end
		end
	end
end)