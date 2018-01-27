local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local parachute_locations = {
	{-1671.8541259766,-3109.4973144532,13.990571022034},
  {1744.6905517578,3301.0944824218,41.22346496582}
}

function drawText(message)
	SetTextComponentFormat("STRING")
	AddTextComponentString(message)
	DisplayHelpTextFromStringLabel(0, 0, 1, - 1)
end

Citizen.CreateThread(function()
  while true do
     Wait(0)
     local ped = GetPlayerPed(-1)
     local pos = GetEntityCoords(ped, true)
     for k,v in ipairs(parachute_locations) do
       if(Vdist(pos.x, pos.y, pos.z, v[1], v[2], v[3]) < 100.0)then
         DrawMarker(1, v[1], v[2], v[3] - 1, 0, 0, 0, 0, 0, 0, 3.0001, 3.0001, 1.5001, 255, 165, 0,165, 0, 0, 0,0)
         if(Vdist(pos.x, pos.y, pos.z, v[1], v[2], v[3]) < 2.0)then
           drawText("Press ~g~ E ~s~ to claim a parachute")
           if(IsControlJustReleased(1, Keys["E"])) then
             if not IsPedSittingInAnyVehicle(ped) then
               TriggerEvent("pNotify:SendNotification", {text = "You grab a dusty old parachute from the hangar floor. Surely it's up to regulation." , type = "alert", timeout = 5000})
               GiveWeaponToPed(ped, GetHashKey("gadget_parachute"), 1, false, false)
             end
           end
         end
       end
     end
  end
end)
