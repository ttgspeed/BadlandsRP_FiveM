doorList = {
    -- Mission Row To locker room & roof
    --[1] = { ["objName"] = "v_ilev_ph_gendoor004", ["x"]= 449.69815063477, ["y"]= -986.46911621094,["z"]= 30.689594268799,["locked"]= true,["txtX"]=450.104,["txtY"]=-986.388,["txtZ"]=31.739},
    -- Mission Row Armory out
    [1] = { ["locked"]= false},
    -- Mission Row Armory in
    [2] = { ["locked"]= false},
    -- Mission Row To downstairs right
    --[4] = { ["objName"] = "v_ilev_ph_gendoor005", ["x"]= 443.97, ["y"]= -989.033,["z"]= 30.6896,["locked"]= true,["txtX"]=444.020,["txtY"]=-989.445,["txtZ"]=31.739},
    -- Mission Row To downstairs left
    --[5] = { ["objName"] = "v_ilev_ph_gendoor005", ["x"]= 445.37, ["y"]= -988.705,["z"]= 30.6896,["locked"]= true,["txtX"]=445.350,["txtY"]=-989.445,["txtZ"]=31.739},
    -- Mission Row Main cells
    [3] = { ["locked"]= false},
    -- Mission Row Cell 1
    [4] = { ["locked"]= false},
    -- Mission Row Cell 2
    [5] = { ["locked"]= false},
    -- Mission Row Cell 3
    [6] = { ["locked"]= false},
    -- Mission Row Backdoor in
    [7] = { ["locked"]= false},
    -- Mission Row Backdoor out
    [8] = { ["locked"]= false},
    -- Mission Row Rooftop In
    --[12] = { ["objName"] = "v_ilev_gtdoor02", ["x"]= 465.467, ["y"]= -983.446,["z"]= 43.6918,["locked"]= true,["txtX"]=464.361,["txtY"]=-984.050,["txtZ"]=44.834},
    -- Mission Row Rooftop Out
    --[13] = { ["objName"] = "v_ilev_gtdoor02", ["x"]= 462.979, ["y"]= -984.163,["z"]= 43.6919,["locked"]= true,["txtX"]=464.361,["txtY"]=-984.050,["txtZ"]=44.834},
    -- Mission Row Captain Office
    [9] = { ["locked"]= false},
    [10] = { ["locked"]= false},
    [11] = { ["locked"]= false},
}

function tvRP.syncAllDoorState(source)
    for i = 1, #doorList do
        vRPclient.syncDoorState(source,{i,doorList[i]["locked"]})
    end
end

function tvRP.updateDoorState(doorNum,state)
    doorList[doorNum]["locked"] = state
    if (doorNum==1 or doorNum==2) then
        vRPclient.syncDoorState(-1,{1,state})
        vRPclient.syncDoorState(-1,{2,state})
    elseif (doorNum==7 or doorNum==8) then
        vRPclient.syncDoorState(-1,{7,state})
        vRPclient.syncDoorState(-1,{8,state})
    else
        vRPclient.syncDoorState(-1,{doorNum,state})
    end
end
