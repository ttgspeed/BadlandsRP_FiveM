local Interior = GetInteriorAtCoords(440.84, -983.14, 30.69)

LoadInterior(Interior)

Citizen.CreateThread(function()
    while (true) do
        ClearAreaOfPeds(342.44, -587.00, 27.79, 50.0, 1) -- clear peds of pilbox hospital
        Citizen.Wait(0)
    end
end)
