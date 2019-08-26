local Interior = GetInteriorAtCoords(440.84, -983.14, 30.69)

LoadInterior(Interior)

--[[
Citizen.CreateThread(function()
    while (true) do
      Citizen.Wait(0)
      ClearAreaOfPeds(342.44, -587.00, 27.79, 50.0, 1) -- clear peds of pilbox hospital
      ClearAreaOfPeds(470.64236450195,-990.66455078125,24.914754867554, 25.0, 1) -- clear peds of mission row
      ClearAreaOfPeds(977.07971191406,-117.21520996094,74.251129150391, 40.0, 1) -- clear peds of lost mc
      ClearAreaOfPeds(464.11099243164,-3229.8449707031,6.0695352554321, 155.0, 1) -- clear paramil at killhouse docks
    end
end)
]]--
