maxErrors = 5 -- Change the amount of Errors allowed for the player to pass the driver test, any number above this will result in a failed test

local options = {
    x = 0.1,
    y = 0.2,
    width = 0.2,
    height = 0.04,
    scale = 0.4,
    font = 0,
    menu_title = "NPC",
    menu_subtitle = "Categories",
    color_r = 0,
    color_g = 128,
    color_b = 255,
}

local dmvped = {
  {type=4, hash=0xc99f21c4, x=239.471, y=-1380.96, z=32.74176, a=3374176},
}

local dmvpedpos = {
	{ ['x'] = 239.471, ['y'] = -1380.96, ['z'] = 33.74176 },
}

--[[Locals]]--

local dmvschool_location = {232.054, -1389.98, 29.4812}

local VehSpeed = 0

local speed_limit_resi =25
local speed_limit_town = 55
local speed_limit_freeway = 75

local introduction_open = false

--[[Events]]--

AddEventHandler("playerSpawned", function()
	TriggerServerEvent('dmv:LicenseStatus')
end)

--[[Functions]]--

function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function DrawMissionText2(m_text, showtime)
    ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(showtime, 1)
end

function LocalPed()
	return GetPlayerPed(-1)
end

function GetCar()
	return GetVehiclePedIsIn(GetPlayerPed(-1),false)
end

function Chat(debugg)
    TriggerEvent("chatMessage", '', { 0, 0x99, 255 }, tostring(debugg))
end

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end

--[[Arrays]]--
test_stage = 0
driving_test_stage = 0
theory_test = 0
in_test_vehicle = 0
SpeedControl = 0
error_points = 0

function startintro()
		--DIntro()
    if test_stage == 0 then
      test_stage = 1
    end
end

function startttest()
    if test_stage == 0 then
			DrawMissionText2("~r~You must complete the DMV Introduction first.", 5000)
		else
			TriggerServerEvent('dmv:ttcharge')
			openGui()
			Menu.hidden = not Menu.hidden
		end
end

function startptest()
    if test_stage < 2 then
			DrawMissionText2("~r~You must complete the DMV Introduction and Practical Test first.", 5000)
		else
		  TriggerServerEvent('dmv:dtcharge')
			onTestBlipp = AddBlipForCoord(255.13990783691,-1400.7319335938,30.5374584198)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
		  driving_test_stage = 1
			SpeedControl = 1
			DTut()
		end
end

function EndDTest()
    if error_points >= maxErrors then
      teleport(218.07736206054,-1388.276977539,30.587490081788)
			drawNotification("You failed your driving test. Please try again.\nYou accumulated too many ~r~Error Points")
			EndTestTasks()
		else
			drawNotification("You have passed Driving School!\nYou accumulated ".. error_points.." ~r~Error Points")
      TriggerServerEvent('vrp:driverSchoolPassed')
			EndTestTasks()
		end
end

function EndTestTasks()
		onTestBlipp = nil
		driving_test_stage = 0
		in_test_vehicle = 0
		error_points = 0
		TaskLeaveVehicle(GetPlayerPed(-1), veh, 0)
		Wait(1000)
		CarTargetForLock = GetPlayersLastVehicle(GetPlayerPed(-1))
		lockStatus = GetVehicleDoorLockStatus(CarTargetForLock)
		SetEntityAsMissionEntity(CarTargetForLock, true, true)
		Wait(2000)
		Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( CarTargetForLock ) )
end

function teleport(x,y,z)
    local ped = GetPlayerPed(-1)
    Citizen.CreateThread(function()
        PED_hasBeenTeleported = true

        DoScreenFadeOut(1000)
        while IsScreenFadingOut() do Citizen.Wait(0) end
        SetEntityCoords(ped, x, y, y, 1, 0, 0, 1)
        DoScreenFadeIn(1000)
        while IsScreenFadingIn() do Citizen.Wait(0)	end

        Citizen.Wait(500)
        PED_hasBeenTeleported = false
    end)
end

function SpawnTestCar()
	Citizen.Wait(0)
	local myPed = GetPlayerPed(-1)
	local player = PlayerId()
	local vehicle = GetHashKey('dilettante')

  RequestModel(vehicle)

  while not HasModelLoaded(vehicle) do
  	Wait(1)
  end
  colors = table.pack(GetVehicleColours(veh))
  extra_colors = table.pack(GetVehicleExtraColours(veh))
  plate = math.random(100, 900)
  local spawned_car = CreateVehicle(vehicle, 249.40971374512,-1407.2303466797,30.409454345703, true, false)
  SetVehicleColours(spawned_car,4,5)
  SetVehicleExtraColours(spawned_car,extra_colors[1],extra_colors[2])
  SetEntityHeading(spawned_car, 317.64)
  SetVehicleOnGroundProperly(spawned_car)
  SetPedIntoVehicle(myPed, spawned_car, - 1)
  SetModelAsNoLongerNeeded(vehicle)
  Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(spawned_car))
  SetEntityVisible(myPed, true)
  FreezeEntityPosition(myPed, false)
  in_test_vehicle = 1
end

function DIntro()
	Citizen.Wait(0)
	local myPed = GetPlayerPed(-1)
	introduction_open = true
		SetEntityCoords(myPed,173.01181030273, -1391.4141845703, 29.408880233765,true, false, false,true)
		TriggerEvent("pNotify:SendNotification",{
            text = "<b style='color:#1E90FF'>DMV Introduction</b> <br /><br />Theory and practice are both important elements of driving instruction.<br />This introduction will cover the basics and ensure you are prepared with enough information and knowledge for your test.<br /><br />The information from your theory lessons combined with the experience from your practical lesson are vital for negotiating the situations and dilemmas you will face on the road.<br /><br />Sit back and enjoy the ride as we start. It is highly recommended that you pay attention to every detail, most of these questions can be existent under your theory test.",
            type = "alert",
            timeout = (15000),
            layout = "center",
            queue = "global"
        })
		Citizen.Wait(16500)
		SetEntityCoords(myPed,-428.49026489258, -993.306640625, 46.008815765381,true, false, false,true)
		TriggerEvent("pNotify:SendNotification",{
            text = "<b style='color:#1E90FF'>Accidents, incidents and environmental concerns</b><br /><br /><b style='color:#87CEFA'>Duty to yield</b><br />All drivers have a duty to obey the rules of the road in order to avoid foreseeable harm to others. Failure to yield the right of way when required by law can lead to liability for any resulting accidents.<br /><br /> When you hear a siren coming, you should yield to the emergency vehicle, simply pull over to your right.<br />You must always stop when a traffic officer tells you to.<br /><br /><b style='color:#87CEFA'>Aggressive Driving</b><br />A car that endangers or is likely to endanger people or property is considered to be aggressive driving.<br />However, aggressive driving, can lead to tragic accidents. It is far wiser to drive defensively and to always be on the lookout for the potential risk of crashes.<br />",
            type = "alert",
            timeout = (15000),
            layout = "center",
            queue = "global"
        })
		Citizen.Wait(16500)
		SetEntityCoords(myPed,-282.55557250977, -282.55557250977, 31.633310317993,true, false, false,true)
		TriggerEvent("pNotify:SendNotification",{
            text = "<b style='color:#1E90FF'>Residential Area</b> <br /><br /> Maintain an appropriate speed - Never faster than the posted limit, slower if traffic is heavy.<br /><br />Stay centered in your lane. Never drive in the area reserved for parked cars.<br /><br />Maintain a safe following distance - an least 1 car length for every 10 mph.<br /><br />The speed limit in a Residential Area is 50 km/h.<br />",
            type = "alert",
            timeout = (15000),
            layout = "center",
            queue = "global"
        })
		Citizen.Wait(16500)
		SetEntityCoords(myPed,246.35220336914, -1204.3403320313, 43.669715881348,true, false, false,true)
		TriggerEvent("pNotify:SendNotification",{
            text = "<b style='color:#1E90FF'>Built-Up Areas/Towns</b> <br /><br />The 80 km/h limit usually applies to all traffic on all roads with street lighting unless otherwise specified.<br />Driving at speeds too fast for the road and driving conditions can be dangerous.<br /><br />You should always reduce your speed when:<br /><br />&bull; Sharing the road with pedestrians<br />&bull; Driving at night, as it is more difficult to see other road users<br />&bull; Weather conditions make it safer to do so<br /><br />Remember, large vehicles and motorcycles need a greater distance to stop<br />",
            type = "alert",
            timeout = (15000),
            layout = "center",
            queue = "global"
        })
		Citizen.Wait(16500)
		SetEntityCoords(myPed,-138.413, -2498.53, 52.2765,true, false, false,true)
		TriggerEvent("pNotify:SendNotification",{
            text = "<b style='color:#1E90FF'>Freeways/Motorways</b> <br /><br />Traffic on motorways usually travels faster than on other roads, so you have less time to react.<br />It is especially important to use your sences earlier and look much further ahead than you would on other roads.<br /><br />Check the traffic on the motorway and match your speed to fit safely into the traffic flow in the left-hand lane.<br /><br />The speed limit in a Freeway/Motorway Area is 120 km/h.<br />",
            type = "alert",
            timeout = (15000),
            layout = "center",
            queue = "global"
        })
		Citizen.Wait(16500)
		SetEntityCoords(myPed,187.465, -1428.82, 43.9302,true, false, false,true)
		TriggerEvent("pNotify:SendNotification",{
            text = "<b style='color:#1E90FF'>Alcohol</b> <br /><br />Drinking while driving is very dangerous, alcohol and/or drugs impair your judgment. Impaired judgment affects how you react to sounds and what you see. However, the DMV allows a certain amount of alcohol concentration for those driving with a valid drivers license.<br /><br />0.08% is the the legal limit for a driver's blood alcohol concentration (BAC)<br />",
            type = "alert",
            timeout = (15000),
            layout = "center",
            queue = "global"
        })
		Citizen.Wait(16500)
		SetEntityCoords(myPed,238.756, -1381.65, 32.743,true, false, false,true)
		SetEntityVisible(myPed, true)
		FreezeEntityPosition(myPed, false)
		introduction_open = false
end

function DTut()
	Citizen.Wait(0)
	local myPed = GetPlayerPed(-1)
	introduction_open = true
		SetEntityCoords(myPed,238.70791625977, -1394.7208251953, -1394.7208251953,true, false, false,true)
	    SetEntityHeading(myPed, 314.39)
		TriggerEvent("pNotify:SendNotification",{
            text = "<b style='color:#1E90FF'>DMV Instructor:</b> <br /><br /> We are currently preparing your vehicle for the test, meanwhile you should read a few important lines.<br /><br /><b style='color:#87CEFA'>Speed limit:</b><br />- Pay attention to the traffic, and stay under the <b style='color:#A52A2A'>speed</b> limit<br /><br />- By now, you should know the basics, however we will try to remind you whenever you <b style='color:#DAA520'>enter/exit</b> an area with a posted speed limit",
            type = "alert",
            timeout = (15000),
            layout = "center",
            queue = "global"
        })
		Citizen.Wait(16500)
		TriggerEvent("pNotify:SendNotification",{
            text = "<b style='color:#1E90FF'>DMV Instructor:</b> <br /><br /> Use the <b style='color:#DAA520'>Cruise Control</b> feature to avoid <b style='color:#87CEFA'>speeding</b>, activate this during the test by pressing the <b style='color:#20B2AA'>X</b> button on your keyboard.<br /><br /><b style='color:#87CEFA'>Evaluation:</b><br />- Try not to crash the vehicle or go over the posted speed limit. You will receive <b style='color:#A52A2A'>Error Points</b> whenever you fail to follow these rules<br /><br />- Too many <b style='color:#A52A2A'>Error Points</b> accumulated will result in a <b style='color:#A52A2A'>Failed</b> test",
            type = "alert",
            timeout = (15000),
            layout = "center",
            queue = "global"
        })
		Citizen.Wait(16500)
		SpawnTestCar()
		introduction_open = false
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)

    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped, false)

		if HasEntityCollidedWithAnything(veh) and in_test_vehicle == 1 then
	    TriggerEvent("pNotify:SendNotification",{
          text = "The vehicle was <b style='color:#B22222'>damaged!</b><br /><br />Watch it!",
          type = "alert",
          timeout = (2000),
          layout = "bottomCenter",
          queue = "global"
      })
			Citizen.Wait(1000)
			error_points = error_points + 1
		end
    if(veh == 0 and in_test_vehicle == 1) then
			error_points = 10
    end
    if error_points >= maxErrors then
      EndDTest()
    end

  	if driving_test_stage == 1 then
  		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 255.13990783691,-1400.7319335938,29.5374584198, true) > 4.0001 then
  		   DrawMarker(1,255.13990783691,-1400.7319335938,29.5374584198,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
  		else
  		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
  				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
  		    end
  			onTestBlipp = AddBlipForCoord(271.8747253418,-1370.5744628906,31.932783126831)
  			N_0x80ead8e2e1d5d52e(onTestBlipp)
  		    DrawMissionText2("Head to the next point !", 5000)
          drawNotification("~s~Error Points: ~y~".. error_points.."/"..maxErrors)
  			driving_test_stage = 2
  		end
  	end

	if driving_test_stage == 2 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),271.8747253418,-1370.5744628906,30.932783126831, true) > 4.0001 then
		   DrawMarker(1,271.8747253418,-1370.5744628906,30.932783126831,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(234.90780639648,-1345.3854980469, 30.542045593262)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
		    DrawMissionText2("Head over to the next point!", 5000)
        drawNotification("~s~Error Points: ~y~".. error_points.."/"..maxErrors)
			driving_test_stage = 3
		end
	end

	if driving_test_stage == 3 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),234.90780639648,-1345.3854980469, 29.542045593262, true) > 4.0001 then
		   DrawMarker(1,234.90780639648,-1345.3854980469, 29.542045593262,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(217.82102966309,-1410.5201416016,29.292112350464)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
		  DrawMissionText2("Make a quick ~r~stop~s~ for pedastrian ~y~crossings", 5000)
      drawNotification("~s~Error Points: ~y~".. error_points.."/"..maxErrors)
			driving_test_stage = 4
		end
	end

		if driving_test_stage == 4 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),217.82102966309,-1410.5201416016,28.292112350464, true) > 4.0001 then
		   DrawMarker(1,217.82102966309,-1410.5201416016,28.292112350464,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(178.55052185059,-1401.7551269531,28.725154876709)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
		  DrawMissionText2("Make a quick ~r~stop~s~ and watch your ~y~LEFT~s~ before entering traffic", 5000)
			drawNotification("Area: ~y~Town\n~s~Speed limit: ~y~55mph\n~s~Error Points: ~y~".. error_points.."/"..maxErrors)
			SpeedControl = 2
			driving_test_stage = 5
			Citizen.Wait(4000)
		end
	end

		if driving_test_stage == 5 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),178.55052185059,-1401.7551269531,27.725154876709, true) > 4.0001 then
		   DrawMarker(1,178.55052185059,-1401.7551269531,27.725154876709,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(113.16044616699,-1365.2762451172,28.725179672241)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
		    DrawMissionText2("Watch the traffic ~y~lights~s~ !", 5000)
        drawNotification("~s~Error Points: ~y~".. error_points.."/"..maxErrors)
			driving_test_stage = 6
		end
	end

		if driving_test_stage == 6 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),113.16044616699,-1365.2762451172,27.725179672241, true) > 4.0001 then
		   DrawMarker(1,113.16044616699,-1365.2762451172,27.725179672241,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(-73.542953491211,-1364.3355712891,27.789325714111)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
      drawNotification("~s~Error Points: ~y~".. error_points.."/"..maxErrors)
			driving_test_stage = 7
		end
	end


		if driving_test_stage == 7 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),-73.542953491211,-1364.3355712891,27.789325714111, true) > 4.0001 then
		   DrawMarker(1,-73.542953491211,-1364.3355712891,27.789325714111,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(-355.14373779297,-1420.2822265625,27.868143081665)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
		    DrawMissionText2("Make sure to stop for passing vehicles !", 5000)
        drawNotification("~s~Error Points: ~y~".. error_points.."/"..maxErrors)
			driving_test_stage = 8
		end
	end

		if driving_test_stage == 8 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),-355.14373779297,-1420.2822265625,27.868143081665, true) > 4.0001 then
		   DrawMarker(1,-355.14373779297,-1420.2822265625,27.868143081665,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(-439.14846801758,-1417.1004638672,27.704095840454)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
      drawNotification("~s~Error Points: ~y~".. error_points.."/"..maxErrors)
			driving_test_stage = 9
		end
	end

		if driving_test_stage == 9 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),-439.14846801758,-1417.1004638672,27.704095840454, true) > 4.0001 then
		   DrawMarker(1,-439.14846801758,-1417.1004638672,27.704095840454,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(-453.79092407227,-1444.7265625,27.665870666504)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
      drawNotification("~s~Error Points: ~y~".. error_points.."/"..maxErrors)
			driving_test_stage = 10
		end
	end

		if driving_test_stage == 10 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),-453.79092407227,-1444.7265625,27.665870666504, true) > 4.0001 then
		   DrawMarker(1,-453.79092407227,-1444.7265625,27.665870666504,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(-647.94396972656,-1696.5717773438,36.433769226074)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
		  DrawMissionText2("Time to hit the road, watch your speed and dont crash !", 5000)
			PlaySound(-1, "RACE_PLACED", "HUD_AWARDS", 0, 0, 1)
			drawNotification("Area: ~y~Freeway\n~s~Speed limit: ~y~75mph\n~s~Error Points: ~y~".. error_points.."/"..maxErrors)
      drawNotification("~s~Error Points: ~y~".. error_points.."/"..maxErrors)
			driving_test_stage = 11
			SpeedControl = 3
			Citizen.Wait(4000)
		end
	end

		if driving_test_stage == 11 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),-647.94396972656,-1696.5717773438,36.433769226074, true) > 4.0001 then
		   DrawMarker(1,-647.94396972656,-1696.5717773438,36.433769226074,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(-730.2935180664,-1618.8310546875,23.501211166382)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
      drawNotification("~s~Error Points: ~y~".. error_points.."/"..maxErrors)
			driving_test_stage = 12
		end
	end

		if driving_test_stage == 12 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),-730.2935180664,-1618.8310546875,23.501211166382, true) > 4.0001 then
		   DrawMarker(1,-730.2935180664,-1618.8310546875,23.501211166382,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(-424.75967407226,-1768.2161865234,19.651624679566)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
      DrawMissionText2("Entering town, watch your speed!", 5000)
			drawNotification("~s~Area: ~y~Town\n~s~Speed limit: ~y~55mph\n~s~Error Points: ~y~".. error_points.."/"..maxErrors)
      SpeedControl = 2
			driving_test_stage = 13
		end
	end

		if driving_test_stage == 13 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),-424.75967407226,-1768.2161865234,19.651624679566, true) > 4.0001 then
		   DrawMarker(1,-424.75967407226,-1768.2161865234,19.651624679566,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(-267.35586547852,-1452.8591308594,30.308126449584)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
      drawNotification("~s~Error Points: ~y~".. error_points.."/"..maxErrors)
			driving_test_stage = 14
		end
	end

		if driving_test_stage == 14 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),-267.35586547852,-1452.8591308594,30.308126449584, true) > 4.0001 then
		   DrawMarker(1,-267.35586547852,-1452.8591308594,30.308126449584,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(67.406066894532,-1374.6027832032,28.29290008545)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
      drawNotification("~s~Error Points: ~y~".. error_points.."/"..maxErrors)
			driving_test_stage = 15
		end
	end

		if driving_test_stage == 15 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),67.406066894532,-1374.6027832032,28.29290008545, true) > 4.0001 then
		   DrawMarker(1,67.406066894532,-1374.6027832032,28.29290008545,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(235.28327941895,-1398.3292236328,28.921098709106)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
			PlaySound(-1, "RACE_PLACED", "HUD_AWARDS", 0, 0, 1)
		  DrawMissionText2("Good job, now lets head back!", 5000)
			drawNotification("Area: ~y~Town\n~s~Speed limit: ~y~55mph\n~s~Error Points: ~y~".. error_points.."/"..maxErrors)
			SpeedControl = 2
			driving_test_stage = 16
		end
	end

		if driving_test_stage == 16 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),235.28327941895,-1398.3292236328,28.921098709106, true) > 4.0001 then
		   DrawMarker(1,235.28327941895,-1398.3292236328,28.921098709106,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			EndDTest()
		end
	end
end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
		    CarSpeed = GetEntitySpeed(GetCar()) * 2.236936
        if(IsPedInAnyVehicle(GetPlayerPed(-1), false)) and SpeedControl == 1 and CarSpeed >= speed_limit_resi then
		    TriggerEvent("pNotify:SendNotification",{
            text = "You are speeding! <b style='color:#B22222'>Slow down!</b><br /><br />You are driving in a <b style='color:#DAA520'>25mph</b> zone!",
            type = "alert",
            timeout = (2000),
            layout = "bottomCenter",
            queue = "global"
        })
			error_points = error_points + 1
			Citizen.Wait(10000)
		elseif(IsPedInAnyVehicle(GetPlayerPed(-1), false)) and SpeedControl == 2 and CarSpeed >= speed_limit_town then
		TriggerEvent("pNotify:SendNotification",{
            text = "You are speeding! <b style='color:#B22222'>Slow down!</b><br /><br />You are driving in a <b style='color:#DAA520'>55mph</b> zone!",
            type = "alert",
            timeout = (2000),
            layout = "bottomCenter",
            queue = "global"
        })
			error_points = error_points + 1
			Citizen.Wait(10000)
		elseif(IsPedInAnyVehicle(GetPlayerPed(-1), false)) and SpeedControl == 3 and CarSpeed >= speed_limit_freeway then
		TriggerEvent("pNotify:SendNotification",{
            text = "You are speeding! <b style='color:#B22222'>Slow down!</b><br /><br />You are driving in a <b style='color:#DAA520'>75mph</b> zone!",
            type = "alert",
            timeout = (2000),
            layout = "bottomCenter",
            queue = "global"
        })
			error_points = error_points + 1
			Citizen.Wait(10000)
		end
	end
end)


local speedLimit = 0
----Theory Test NUI Operator

-- ***************** Open Gui and Focus NUI
function openGui()
  theory_test = 1
  SetNuiFocus(true)
  SendNUIMessage({openQuestion = true})
end

-- ***************** Close Gui and disable NUI
function closeGui()
  SetNuiFocus(false)
  SendNUIMessage({openQuestion = false})
end

-- ***************** Disable controls while GUI open
Citizen.CreateThread(function()
  while true do
    if theory_test == 1 then
      local ply = GetPlayerPed(-1)
      local active = true
      DisableControlAction(0, 1, active) -- LookLeftRight
      DisableControlAction(0, 2, active) -- LookUpDown
      DisablePlayerFiring(ply, true) -- Disable weapon firing
      DisableControlAction(0, 142, active) -- MeleeAttackAlternate
      DisableControlAction(0, 106, active) -- VehicleMouseControlOverride
      if IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
        SendNUIMessage({type = "click"})
      end
    end
    Citizen.Wait(0)
  end
end)

Citizen.CreateThread(function()
  while true do
    if introduction_open then
      local ply = GetPlayerPed(-1)
      local active = true
	  SetEntityVisible(ply, false)
	  FreezeEntityPosition(ply, true)
      DisableControlAction(0, 1, active) -- LookLeftRight
      DisableControlAction(0, 2, active) -- LookUpDown
      DisablePlayerFiring(ply, true) -- Disable weapon firing
      DisableControlAction(0, 142, active) -- MeleeAttackAlternate
      DisableControlAction(0, 106, active) -- VehicleMouseControlOverride
    end
    Citizen.Wait(0)
  end
end)

-- ***************** Disable controls while GUI open
Citizen.CreateThread(function()
  while true do
    if theory_test == 1 then
      if IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
        SendNUIMessage({type = "click"})
      end
    end
    Citizen.Wait(0)
  end
end)

-- ***************** NUI Callback Methods
-- Callbacks pages opening
RegisterNUICallback('question', function(data, cb)
  SendNUIMessage({openSection = "question"})
  cb('ok')
end)

-- Callback actions triggering server events
RegisterNUICallback('close', function(data, cb)
  -- if question success
  closeGui()
  cb('ok')
  TriggerServerEvent('dmv:success')
  DrawMissionText2("~b~Test passed, you can now proceed to the driving test", 2000)
  if test_stage == 1 then
    test_stage = 2
  end
  theory_test = 0
end)

RegisterNUICallback('kick', function(data, cb)
    closeGui()
    cb('ok')
    DrawMissionText2("~r~You failed the test, please try again.", 2000)
    theory_test = 0
end)

---------------------------------- DMV PED ----------------------------------

Citizen.CreateThread(function()

  RequestModel(GetHashKey("a_m_y_business_01"))
  while not HasModelLoaded(GetHashKey("a_m_y_business_01")) do
    Wait(1)
  end

  RequestAnimDict("mini@strip_club@idles@bouncer@base")
  while not HasAnimDictLoaded("mini@strip_club@idles@bouncer@base") do
    Wait(1)
  end

 	    -- Spawn the DMV Ped
  for _, item in pairs(dmvped) do
    dmvmainped =  CreatePed(item.type, item.hash, item.x, item.y, item.z, item.a, false, true)
    SetEntityHeading(dmvmainped, 137.71)
    FreezeEntityPosition(dmvmainped, true)
	SetEntityInvincible(dmvmainped, true)
	SetBlockingOfNonTemporaryEvents(dmvmainped, true)
    TaskPlayAnim(dmvmainped,"mini@strip_club@idles@bouncer@base","base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
    end
end)

local talktodmvped = true
--DMV Ped interaction
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local pos = GetEntityCoords(GetPlayerPed(-1), false)
		for k,v in ipairs(dmvpedpos) do
			if(Vdist(v.x, v.y, v.z, pos.x, pos.y, pos.z) < 1.0)then
				DisplayHelpText("Press ~INPUT_CONTEXT~ to interact with ~y~NPC")
				if(IsControlJustReleased(1, 38))then
						if talktodmvped then
						    Notify("~b~Welcome to the ~h~DMV School!")
						    Citizen.Wait(500)
							DMVMenu()
							Menu.hidden = false
							talktodmvped = false
						else
							talktodmvped = true
						end
				end
				Menu.renderGUI(options)
			end
		end
	end
end)

------------
------------ DRAW MENUS
------------
function DMVMenu()
	ClearMenu()
    options.menu_title = "DMV School"
	Menu.addButton("Obtain a drivers license","VehLicenseMenu",nil)
    Menu.addButton("Close","CloseMenu",nil)
end

function VehLicenseMenu()
    ClearMenu()
    options.menu_title = "Vehicle License"
	Menu.addButton("Introduction","startintro",nil)
	Menu.addButton("Theory test","startttest",nil)
	Menu.addButton("Practical test","startptest",nil)
    Menu.addButton("Return","DMVMenu",nil)
end

function CloseMenu()
		Menu.hidden = true
end

function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
end

function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(true, true)
end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

----------------
----------------blip
----------------



Citizen.CreateThread(function()
	pos = dmvschool_location
	local blip = AddBlipForCoord(pos[1],pos[2],pos[3])
	SetBlipSprite(blip,408)
	SetBlipColour(blip,11)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('DMV School')
	EndTextCommandSetBlipName(blip)
	SetBlipAsShortRange(blip,true)
	SetBlipAsMissionCreatorBlip(blip,true)
end)
