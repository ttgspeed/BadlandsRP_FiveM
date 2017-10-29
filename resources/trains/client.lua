Citizen.CreateThread(function()

function LoadTrainModels() -- f*ck your rails, too!
			tempmodel = GetHashKey("freight")
			RequestModel(tempmodel)
			while not HasModelLoaded(tempmodel) do
				RequestModel(tempmodel)
				Citizen.Wait(0)
			end

			tempmodel = GetHashKey("freightcar")
			RequestModel(tempmodel)
			while not HasModelLoaded(tempmodel) do
				RequestModel(tempmodel)
				Citizen.Wait(0)
			end

			tempmodel = GetHashKey("freightgrain")
			RequestModel(tempmodel)
			while not HasModelLoaded(tempmodel) do
				RequestModel(tempmodel)
				Citizen.Wait(0)
			end

			tempmodel = GetHashKey("freightcont1")
			RequestModel(tempmodel)
			while not HasModelLoaded(tempmodel) do
				RequestModel(tempmodel)
				Citizen.Wait(0)
			end

			tempmodel = GetHashKey("freightcont2")
			RequestModel(tempmodel)
			while not HasModelLoaded(tempmodel) do
				RequestModel(tempmodel)
				Citizen.Wait(0)
			end

			tempmodel = GetHashKey("freighttrailer")
			RequestModel(tempmodel)
			while not HasModelLoaded(tempmodel) do
				RequestModel(tempmodel)
				Citizen.Wait(0)
			end

			tempmodel = GetHashKey("tankercar")
			RequestModel(tempmodel)
			while not HasModelLoaded(tempmodel) do
				RequestModel(tempmodel)
				Citizen.Wait(0)
			end

			tempmodel = GetHashKey("metrotrain")
			RequestModel(tempmodel)
			while not HasModelLoaded(tempmodel) do
				RequestModel(tempmodel)
				Citizen.Wait(0)
			end

			tempmodel = GetHashKey("s_m_m_lsmetro_01")
			RequestModel(tempmodel)
			while not HasModelLoaded(tempmodel) do
				RequestModel(tempmodel)
				Citizen.Wait(0)
			end



end

LoadTrainModels()

-- Track 1
TrainLocations = {
	2533.4072265625,2832.7502441406,38.570995330811
}

-- Track 2
TrainLocations2 = {
	2538.73046875,2828.4760742188,38.366275787354
}

RegisterNetEvent("StartTrain")
function StartTrain()
	Citizen.Trace("a train has arrived") -- whee i must be host, lucky me
	DeleteAllTrains()
	Train = CreateMissionTrain(math.random(0,22), TrainLocations[1], TrainLocations[2], TrainLocations[3],true)
	Train2 = CreateMissionTrain(math.random(0,22), TrainLocations2[1], TrainLocations2[2], TrainLocations2[3],true)
	MetroTrain = CreateMissionTrain(24,40.2,-1201.3,31.0,true) -- these ones have pre-defined spawns since they are a pain to set up
	MetroTrain2 = CreateMissionTrain(24,-618.0,-1476.8,16.2,true)
	CreatePedInsideVehicle(Train, 26, GetHashKey("s_m_m_lsmetro_01"), -1, 1, true)
	CreatePedInsideVehicle(Train2, 26, GetHashKey("s_m_m_lsmetro_01"), -1, 1, true)
	CreatePedInsideVehicle(MetroTrain, 26, GetHashKey("s_m_m_lsmetro_01"), -1, 1, true)
	CreatePedInsideVehicle(MetroTrain2, 26, GetHashKey("s_m_m_lsmetro_01"), -1, 1, true) -- create peds for the trains
	SetEntityAsMissionEntity(Train,true,true) -- dunno if this does anything, just throwing it in for good measure
	SetEntityAsMissionEntity(Train2,true,true) -- dunno if this does anything, just throwing it in for good measure
	SetEntityAsMissionEntity(MetroTrain,true,true)
	SetEntityAsMissionEntity(MetroTrain2,true,true)


end
AddEventHandler("StartTrain", StartTrain)

end)
