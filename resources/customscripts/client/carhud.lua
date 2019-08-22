-- ###################################
--
--        C   O   N   F   I   G
--
-- ###################################



-- move all ui
local UI = {
	x =  0.000 ,	-- Base Screen Coords 	+ 	 x
	y = -0.001 ,	-- Base Screen Coords 	+ 	-y
}

-- ###################################
--
--             C   O   D   E
--
-- ###################################
local showUI = true

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		if showUI then
			local MyPed = GetPlayerPed(-1)

			if(IsPedInAnyVehicle(MyPed, -1))then

				if IsPedInAnyHeli(MyPed) or IsPedInAnyPlane(MyPed) then
					local altitude = GetEntityHeightAboveGround(MyPed)
					if(altitude < 200)then
						drawTxt(UI.x + 0.619, UI.y + 1.266, 1.0,1.0,0.45, "~r~" .. math.ceil(altitude).." ~w~m", 240, 200, 80, 255)
					else
						drawTxt(UI.x + 0.619, UI.y + 1.266, 1.0,1.0,0.45, "~w~" .. math.ceil(altitude).." ~w~m", 240, 200, 80, 255)
					end
				end
			end
		end
	end
end)

function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

function drawRct(x,y,width,height,r,g,b,a)
	DrawRect(x + width/2, y + height/2, width, height, r, g, b, a)
end

RegisterNetEvent('camera:hideUI')
AddEventHandler('camera:hideUI', function(toggle)
  if toggle ~= nil then
    showUI = toggle
  end
end)
