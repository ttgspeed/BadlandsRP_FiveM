local Interior = GetInteriorAtCoords(440.84, -983.14, 30.69)

LoadInterior(Interior)

Citizen.CreateThread(function()
    while (true) do
      Citizen.Wait(0)
      ClearAreaOfPeds(342.44, -587.00, 27.79, 50.0, 1) -- clear peds of pilbox hospital
      ClearAreaOfPeds(470.64236450195,-990.66455078125,24.914754867554, 25.0, 1) -- clear peds of mission row
    end
end)
