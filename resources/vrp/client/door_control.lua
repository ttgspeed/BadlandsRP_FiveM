-- [[-----------------------------------------------------------------------

    -- dRdoors - Open/Close doors at Mission Row PD
    -- Script By Darklandz version 1.0

    -- Main Client file

  -- https://gitlab.com/Darklandz/dRdoors/

-- ---------------------------------------------------------------------]]--

function DrawText3d(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    if onScreen then
        SetTextScale(0.2, 0.2)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 55)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

Citizen.CreateThread(function()
    while true do
        for i = 1, #doorList do
            local playerCoords = GetEntityCoords( GetPlayerPed(-1) )
            local closeDoor = GetClosestObjectOfType(doorList[i]["x"], doorList[i]["y"], doorList[i]["z"], 1.0, GetHashKey(doorList[i]["objName"]), false, false, false)

            local objectCoordsDraw = GetEntityCoords( closeDoor )
            local playerDistance = GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, doorList[i]["x"], doorList[i]["y"], doorList[i]["z"], true)

            if(playerDistance < 1) then

                if doorList[i]["locked"] == true then
                    DrawText3d(doorList[i]["txtX"], doorList[i]["txtY"], doorList[i]["txtZ"], "[E] to unlock door")
                else
                    DrawText3d(doorList[i]["txtX"], doorList[i]["txtY"], doorList[i]["txtZ"], "[E] to lock door")
                end

                if IsControlJustPressed(1,51) and tvRP.isCop() then
                    if doorList[i]["locked"] == true then
                        FreezeEntityPosition(closeDoor, false)
                        if(i==7 or i==8) then
                            doorList[7]["locked"] = false
                            doorList[8]["locked"] = false
                            vRPserver.updateDoorState({7,false})
                            vRPserver.updateDoorState({8,false})
                        else
                            doorList[i]["locked"] = false
                            vRPserver.updateDoorState({i,false})
                        end
                    else
                        FreezeEntityPosition(closeDoor, true)
                        if(i==7 or i==8) then
                            doorList[7]["locked"] = true
                            doorList[8]["locked"] = true
                            vRPserver.updateDoorState({7,true})
                            vRPserver.updateDoorState({8,true})
                        else
                            doorList[i]["locked"] = true
                            vRPserver.updateDoorState({i,true})
                        end
                    end
                    tvRP.playAnim(true,{{"missheistfbisetup1","unlock_enter_janitor",1}},false)
                end
            else
                FreezeEntityPosition(closeDoor, doorList[i]["locked"])
            end
        end

        Citizen.Wait(0)
    end
end)

doorList = {
    -- Mission Row To locker room & roof
    --[1] = { ["objName"] = "v_ilev_ph_gendoor004", ["x"]= 449.69815063477, ["y"]= -986.46911621094,["z"]= 30.689594268799,["locked"]= true,["txtX"]=450.104,["txtY"]=-986.388,["txtZ"]=31.739},
    -- Mission Row Armory out
    [1] = { ["objName"] = "v_ilev_arm_secdoor", ["x"]= 452.61877441406, ["y"]= -982.7021484375,["z"]= 30.689598083496,["locked"]= true,["txtX"]=453.079,["txtY"]=-982.600,["txtZ"]=31.739},
    -- Mission Row Armory in
    [2] = { ["objName"] = "v_ilev_arm_secdoor", ["x"]= 453.57894897461, ["y"]= -982.49829101563,["z"]= 30.689605712891,["locked"]= true,["txtX"]=453.079,["txtY"]=-982.600,["txtZ"]=31.739},
    -- Mission Row Main cells
    [3] = { ["objName"] = "v_ilev_ph_cellgate", ["x"]= 463.95562744141, ["y"]= -992.5693359375,["z"]= 24.91487121582,["locked"]= true,["txtX"]=463.465,["txtY"]=-992.664,["txtZ"]=25.064},
    -- Mission Row Cell 1
    [4] = { ["objName"] = "v_ilev_ph_cellgate", ["x"]= 462.381, ["y"]= -993.651,["z"]= 24.9149,["locked"]= true,["txtX"]=461.806,["txtY"]=-993.308,["txtZ"]=25.064},
    -- Mission Row Cell 2
    [5] = { ["objName"] = "v_ilev_ph_cellgate", ["x"]= 462.331, ["y"]= -998.152,["z"]= 24.9149,["locked"]= true,["txtX"]=461.806,["txtY"]=-998.800,["txtZ"]=25.064},
    -- Mission Row Cell 3
    [6] = { ["objName"] = "v_ilev_ph_cellgate", ["x"]= 462.704, ["y"]= -1001.92,["z"]= 24.9149,["locked"]= true,["txtX"]=461.806,["txtY"]=-1002.450,["txtZ"]=25.064},
    -- Mission Row Backdoor in
    [7] = { ["objName"] = "v_ilev_gtdoor", ["x"]= 464.126, ["y"]= -1002.78,["z"]= 24.9149,["locked"]= true,["txtX"]=464.100,["txtY"]=-1003.538,["txtZ"]=26.064},
    -- Mission Row Backdoor out
    [8] = { ["objName"] = "v_ilev_gtdoor", ["x"]= 464.18, ["y"]= -1004.31,["z"]= 24.9152,["locked"]= true,["txtX"]=464.100,["txtY"]=-1003.538,["txtZ"]=26.064},
    -- Mission Row Rooftop In
    --[12] = { ["objName"] = "v_ilev_gtdoor02", ["x"]= 465.467, ["y"]= -983.446,["z"]= 43.6918,["locked"]= true,["txtX"]=464.361,["txtY"]=-984.050,["txtZ"]=44.834},
    -- Mission Row Rooftop Out
    --[13] = { ["objName"] = "v_ilev_gtdoor02", ["x"]= 462.979, ["y"]= -984.163,["z"]= 43.6919,["locked"]= true,["txtX"]=464.361,["txtY"]=-984.050,["txtZ"]=44.834},
    -- Mission Row Captain Office
    [9] = { ["objName"] = "v_ilev_ph_gendoor002", ["x"]= 447.29971313477, ["y"]= -980.03033447266,["z"]= 30.689582824707,["locked"]= true,["txtX"]=447.200,["txtY"]=-980.010,["txtZ"]=31.739},
    -- Mission Row To downstairs right
    [10] = { ["objName"] = "v_ilev_ph_gendoor005", ["x"]= 444.19161987305, ["y"]= -989.48022460938,["z"]= 30.689605712891,["locked"]= true,["txtX"]=444.020,["txtY"]=-989.445,["txtZ"]=31.739},
    -- Mission Row To downstairs left
    [11] = { ["objName"] = "v_ilev_ph_gendoor005", ["x"]= 445.30233764648, ["y"]= -989.42022705078,["z"]= 30.689582824707,["locked"]= true,["txtX"]=445.350,["txtY"]=-989.445,["txtZ"]=31.739},
}

function tvRP.syncDoorState(doorNum,state)
    doorList[doorNum]["locked"] = state
    local closeDoor = GetClosestObjectOfType(doorList[doorNum]["x"], doorList[doorNum]["y"], doorList[doorNum]["z"], 1.0, GetHashKey(doorList[doorNum]["objName"]), false, false, false)
    if state == true then
        FreezeEntityPosition(closeDoor, true)
        if(doorNum==1 or doorNum==2) then
            doorList[1]["locked"] = true
            doorList[2]["locked"] = true
        elseif(doorNum==7 or doorNum==8) then
            doorList[7]["locked"] = true
            doorList[8]["locked"] = true
        else
            doorList[doorNum]["locked"] = true
        end
    else
        FreezeEntityPosition(closeDoor, false)
        if(doorNum==1 or doorNum==2) then
            doorList[1]["locked"] = false
            doorList[2]["locked"] = false
        elseif(doorNum==7 or doorNum==8) then
            doorList[7]["locked"] = false
            doorList[8]["locked"] = false
        else
            doorList[doorNum]["locked"] = false
        end
    end
end
