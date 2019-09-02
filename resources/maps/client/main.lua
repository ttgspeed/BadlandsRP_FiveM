local Interior = GetInteriorAtCoords(440.84, -983.14, 30.69)

LoadInterior(Interior)

Citizen.CreateThread(function()
    while (true) do
      Citizen.Wait(0)
      local pedCoord = GetEntityCoords(GetPlayerPed(-1),true)
      if #(vector3(pedCoord.x, pedCoord.y, pedCoord.z)-vector3(342.44, -587.00, 27.79)) < 75 then
        ClearAreaOfPeds(342.44, -587.00, 27.79, 50.0, 1) -- clear peds of pilbox hospital
      elseif #(vector3(pedCoord.x, pedCoord.y, pedCoord.z)-vector3(470.64236450195,-990.66455078125,24.914754867554)) < 40 then
        ClearAreaOfPeds(470.64236450195,-990.66455078125,24.914754867554, 25.0, 1) -- clear peds of mission row
      elseif #(vector3(pedCoord.x, pedCoord.y, pedCoord.z)-vector3(977.07971191406,-117.21520996094,74.251129150391)) < 50 then
        ClearAreaOfPeds(977.07971191406,-117.21520996094,74.251129150391, 40.0, 1) -- clear peds of lost mc
      elseif #(vector3(pedCoord.x, pedCoord.y, pedCoord.z)-vector3(464.11099243164,-3229.8449707031,6.0695352554321)) < 165 then
        ClearAreaOfPeds(464.11099243164,-3229.8449707031,6.0695352554321, 155.0, 1) -- clear paramil at killhouse docks
      elseif #(vector3(pedCoord.x, pedCoord.y, pedCoord.z)-vector3(1856.10,3679.10,33.7)) < 70 then
        ClearAreaOfPeds(1856.10,3679.10,33.7, 58.0, 1) -- sandy pd
      end
    end
end)
