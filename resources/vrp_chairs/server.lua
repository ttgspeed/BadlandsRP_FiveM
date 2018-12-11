local Tunnel = module("vrp", "panopticon/sv_pano_tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRPch = {}
Tunnel.bindInterface("vrp_chairs",vRPch)
Tunnel.initiateProxy()
local occupied = {}

function vRPch.occupyObj(object)
	table.insert(occupied, object)
end

function vRPch.unoccupyObj(object)
	for k,v in pairs(occupied) do
		if v == object then
			table.remove(occupied, k)
		end
	end
end


function vRPch.getOccupied()
	return occupied
end
