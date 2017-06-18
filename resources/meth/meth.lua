vRP = Proxy.getInterface("vRP")
vRPserver = Tunnel.getInterface("vRP","meth")
methServer = Tunnel.getInterface("methServer","methClient")

meth = {}
Tunnel.bindInterface("methClient",meth)

methLabs = {
	"camper",
	"taco",
	"journey"
}

activeMethLabs = {}

local Keys = {
	["E"] = 38
}

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

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

--tells the client that a vehicle is a meth lab
function meth.addMethLab(vehicleId)
	activeMethLabs[vehicleId] = true
end

--tells the client that a vehicle is no longer a meth lab
function meth.removeMethLab(vehicleId)
	activeMethLabs[vehicleId] = nil
end

local smokes = {}
function meth.addSmoke(vehicleId,x,y,z)
	if smokes[vehicleId] ~= nil then return end
	if not HasNamedPtfxAssetLoaded("core") then
		RequestNamedPtfxAsset("core")
		while not HasNamedPtfxAssetLoaded("core") do
			Wait(1)
		end
	end

	SetPtfxAssetNextCall("core")
	local part = StartParticleFxLoopedAtCoord("ent_amb_smoke_foundry", x, y, z+2, 0.0,0.0,0.0,1.0, false, false, false)
	smokes[vehicleId] = part
end

function meth.removeSmoke(vehicleId)
	RemoveParticleFx(smokes[vehicleId])
	smokes[vehicleId] = nil
end

local currentMethLab = nil
local cookingMeth = false

--Thread
Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(1000)
		local ped = GetPlayerPed(-1)
		local car = GetVehiclePedIsIn(ped, false)
		
		if car then
			if car ~= 0 and GetEntitySpeed(car) < 1 then 
				local carModel = GetEntityModel(car)
				if isCarMethLab(carModel) then 
					startLabOption()
				end
			end
		end
	end
end)

--gives player the option to start the meth lab
function startLabOption()
	while true do
		Citizen.Wait(10)
		local ped = GetPlayerPed(-1)
		local car = GetVehiclePedIsIn(ped, false)
		local vehicleId = NetworkGetNetworkIdFromEntity(car)
		isMethLab = false
		for k,v in pairs(activeMethLabs) do 
			if k == vehicleId then isMethLab = true end
		end
		if car == 0 or GetEntitySpeed(car) > 1 or not isMethLab then break end
		DisplayHelpText("Press ~g~E~s~ to start cooking")
		if IsControlJustReleased(1, Keys['E']) then 
			local carModel = GetEntityModel(car)
			local carName = getCarName(carModel)
			currentMethLab = vehicleId
			methServer.enterMethLab({vehicleId,carModel,carName})
			local x,y,z = table.unpack(GetEntityCoords(car,true))
			methServer.syncSmoke({vehicleId,true,x,y,z})
			startCooking()
			break				
		end
	end
end

function startCooking()
	cookingMeth = true
	while cookingMeth do 
		Citizen.Wait(10)
		local ped = GetPlayerPed(-1)
		local car = GetVehiclePedIsIn(ped, false)
		if car == 0 or GetEntitySpeed(car) > 1 then cookingMeth = false end
	end
	methServer.syncSmoke({currentMethLab,false})
	currentMethLab = nil
end