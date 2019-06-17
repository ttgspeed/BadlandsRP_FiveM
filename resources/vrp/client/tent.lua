local function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

local active_tents = {}

function tvRP.addTent(id,pos)
	active_tents[id] = {
		['pos'] = pos,
		['active'] = true
	}
end

function tvRP.getForwardPosition()
	local ped = GetPlayerPed(-1)
	local pedCoord = GetEntityCoords(ped)

		local rot = GetEntityHeading(ped)
		local x, y, z = table.unpack(GetEntityCoords(ped, true))
		local fx,fy,fz = table.unpack(GetEntityForwardVector(ped))
		x = x+(fx*2.0)
		y = y+(fy*2.0)
		_,z = GetGroundZFor_3dCoord(x,y,z)

		return x,y,z
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		local ped = GetPlayerPed(i)
		local x,y,z = table.unpack(GetEntityCoords(ped,true))
		for k,v in pairs(active_tents) do
			local tx,ty,tz = table.unpack(v.pos)
			if GetDistanceBetweenCoords(x,y,z,tx,ty,tz,true) < 25.0 then
				if DoesObjectOfTypeExistAtCoords(tx,ty,tz, 2.0, GetHashKey("prop_skid_tent_cloth"), true) then
					if not v.active then
						--delete
					end
				else
					if v.active then
						tent_model = GetHashKey("prop_skid_tent_cloth")

						RequestModel(tent_model)
						while not HasModelLoaded(tent_model) do
							Citizen.Wait(1)
						end

						local object = CreateObject(tent_model, tx, ty, tz, false, true, false)
						PlaceObjectOnGroundProperly(object)
					end
				end
			end
		end
	end
end)
