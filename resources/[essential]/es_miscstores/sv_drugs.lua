local globalids = {
	xtc = 5,
	acid = 4,
	weed = 1,
	cocaine = 2,
	meth = 3,
	cannabis = 6,
	coca = 7,
	dieth = 8,
	pseudo = 9,
	safrole = 10
}
local globalbuys = {
	xtc = true,
	acid = true,
	weed = true,
	cocaine = true,
	meth = true
}
local globalsells = {
	xtc = true,
	acid = true,
	weed = true,
	cocaine = true,
	meth = true
}
local globalRatesSell = {
	xtc = 1000,
	acid = 700,
	weed = 700,
	cocaine = 1100,
	meth = 1200,
}
local globalRatesBuy = {
	xtc = 800,
	acid = 500,
	weed = 500,
	cocaine = 900,
	meth = 1000,
}

local DrugDealers = {
	['matthew'] = {
		ped = { ['heading'] = 20.0, ['model'] = 0xE497BBEF --[[s_m_y_dealer_01]] },
		pos = { ['x'] = 227.153757, ['y'] = -871.66656, ['z'] = 29.492092 }, --pos = { ['x'] = 1640.7264404297, ['y'] = 3730.9936523438, ['z'] = 34.067134857178 },
		name = "Drug Lord",
		icon = 439,
		processor = false,
		buys = globalbuys,
		sells = globalsells,
		RatesSell = globalRatesSell,
		RatesBuy = globalRatesBuy,
	},
	['nick'] = {
		ped = { ['heading'] = 330.0, ['model'] = 0xE497BBEF --[[s_m_y_dealer_01]] },
		pos = { ['x'] = 1177.1647949219, ['y'] = 2722.220703125, ['z'] = 37.004173278809 },
		name = "Drug Lord",
		icon = 439,
		processor = false,
		buys = globalbuys,
		sells = globalsells,
		RatesSell = globalRatesSell,
		RatesBuy = globalRatesBuy,
	},
	['alexanderkuhta'] = { --relocate
		ped = { ['heading'] = 20.0, ['model'] = 0x46521A32 --[[cs_russiandrunk]] },
		pos = { ['x'] = -1724.7882080078, ['y'] = 234.66094970703, ['z'] = 57.471710205078 },
		name = "Drug Lord",
		icon = 439,
		processor = false,
		buys = globalbuys,
		sells = globalsells,
		RatesSell = globalRatesSell,
		RatesBuy = globalRatesBuy,
	},
	['varent'] = {
		ped = { ['heading'] = 0.0, ['model'] = 0x54DBEE1F --[[a_m_m_bevhills_01]] },
		pos = { ['x'] = -761.85791015625, ['y'] = 351.92532348633, ['z'] = 85.998001098633 },
		name = "Drug Lord",
		icon = 439,
		processor = false,
		buys = globalbuys,
		sells = globalsells,
		RatesSell = globalRatesSell,
		RatesBuy = globalRatesBuy,
	},
	['0x420'] = {
		ped = { ['heading'] = 280.0, ['model'] = 0x23B88069 --[[g_f_y_ballas_01]] },
		pos = { ['x'] = 77.885513305664, ['y'] = -1948.2086181641, ['z'] = 19.174139022827 },
		name = "Drug Lord",
		icon = 439,
		processor = false,
		buys = globalbuys,
		sells = globalsells,
		RatesSell = globalRatesSell,
		RatesBuy = globalRatesBuy,
	},
	['marythomas'] = {
		ped = { ['heading'] = 200.0, ['model'] = 0x4E0CE5D3 --[[g_f_y_ballas_01]] },
		pos = { ['x'] = -224.3656463623, ['y'] = -1667.0147705078, ['z'] = 35.636913299561 },
		name = "Drug Lord",
		icon = 439,
		processor = false,
		buys = globalbuys,
		sells = globalsells,
		RatesSell = globalRatesSell,
		RatesBuy = globalRatesBuy,
	},
	['alicia'] = {
		ped = { ['heading'] = 280.0, ['model'] = 0x5D71A46F --[[s_f_y_airhostess_01]] },
		pos = { ['x'] = -979.21936035156, ['y'] = -2679.1882324219, ['z'] = 34.604850769043 },
		name = "Drug Lord",
		icon = 439,
		processor = false,
		buys = globalbuys,
		sells = globalsells,
		RatesSell = globalRatesSell,
		RatesBuy = globalRatesBuy,
	},
	['kanersps'] = {
		ped = { ['heading'] = 100.0, ['model'] = 0xF1E823A2 --[[s_f_y_airhostess_01]] },
		pos = { ['x'] = 1222.0125732422, ['y'] = -2920.1618652344, ['z'] = 3.8660640716553 },
		name = "Drug Lord",
		icon = 439,
		processor = false,
		buys = globalbuys,
		sells = globalsells,
		RatesSell = globalRatesSell,
		RatesBuy = globalRatesBuy,
	},
	['liam'] = {
		ped = { ['heading'] = 40.0, ['model'] = 0xF1E823A2 --[[s_f_y_airhostess_01]] },
		pos = { ['x'] = 1302.6696777344, ['y'] = 4226.1025390625, ['z'] = 31.908679962158 },
		name = "Drug Lord",
		icon = 439,
		processor = false,
		buys = globalbuys,
		sells = globalsells,
		RatesSell = globalRatesSell,
		RatesBuy = globalRatesBuy,
	},
	['cannabis'] = {
		ped = { ['heading'] = 40.0, ['model'] = 0x94562DD7 --[[a_m_m_farmer_01]] },
		pos = { ['x'] = 2213.0224609375, ['y'] = 5577.65380859375, ['z'] = 52.7998313903809 },
		name = "Cannabis Dealer",
		icon = 140,
		processor = false,
		buys = {
			cannabis = true,
		},
		sells = {
			cannabis = true,
		},
		RatesSell = {
			cannabis = 50,
		},
		RatesBuy = {
			cannabis = 30,
		},
	},
	['pseudo'] = {
		ped = { ['heading'] = 40.0, ['model'] = 0x696BE0A9 --[[a_m_y_methhead_01]] },
		pos = { ['x'] = 65.3316345214844, ['y'] = 3716.21728515625, ['z'] = 38.754467010498 },
		name = "Ephedrine Dealer",
		icon = 140,
		processor = false,
		buys = {
			pseudo = true,
		},
		sells = {
			pseudo = true,
		},
		RatesSell = {
			pseudo = 100,
		},
		RatesBuy = {
			pseudo = 80,
		},
	},
	['coca'] = {
		ped = { ['heading'] = 40.0, ['model'] = 0x6C9B2849 --[[a_m_m_hillbilly_01]] },
		pos = { ['x'] = -553.635620117188, ['y'] = 5324.27734375, ['z'] = 72.5996704101563 },
		name = "Coca Dealer",
		icon = 140,
		processor = false,
		buys = {
			coca = true,
		},
		sells = {
			coca = true,
		},
		RatesSell = {
			coca = 50,
		},
		RatesBuy = {
			coca = 30,
		},
	},
	['die'] = {
		ped = { ['heading'] = 40.0, ['model'] = 0x1475B827 --[[a_f_y_hippie_01]] },
		pos = { ['x'] = 166.024078369141, ['y'] = 2229.79077148438, ['z'] = 89.7329788208008 },
		name = "Diethylamine Dealer",
		icon = 140,
		processor = false,
		buys = {
			dieth = true,
		},
		sells = {
			dieth = true,
		},
		RatesSell = {
			dieth = 50,
		},
		RatesBuy = {
			dieth = 30,
		},
	},
	['saf'] = {
		ped = { ['heading'] = 40.0, ['model'] = 0x14D506EE --[[a_m_y_hipster_02]] },
		pos = { ['x'] = 3856.02709960938, ['y'] = 4459.1904296875, ['z'] = 0.84976637363434 },
		name = "Safrole Dealer",
		icon = 140,
		processor = false,
		buys = {
			safrole = true,
		},
		sells = {
			safrole = true,
		},
		RatesSell = {
			safrole = 80,
		},
		RatesBuy = {
			safrole = 60,
		},
	},
	--Drug processors
	['cannabisp'] = {
		ped = { ['heading'] = 20.0, ['model'] = 0xE497BBEF --[[s_m_y_dealer_01]] },
		pos = { ['x'] = -1840.15637207031, ['y'] = 2152.9907226563, ['z'] = 115.324966430664 }, --pos = { ['x'] = 1640.7264404297, ['y'] = 3730.9936523438, ['z'] = 34.067134857178 },
		name = "Cannabis Processor",
		icon = 403,
		processor = true,
		precursor = "cannabis",
		drug = "weed",
	},
	['cocap'] = {
		ped = { ['heading'] = 20.0, ['model'] = 0xE497BBEF --[[s_m_y_dealer_01]] },
		pos = { ['x'] = 2434.9562988281, ['y'] = 4968.6137695312, ['z'] = 41.3476028442383 }, --pos = { ['x'] = 1640.7264404297, ['y'] = 3730.9936523438, ['z'] = 34.067134857178 },
		name = "Coca Processor",
		icon = 403,
		processor = true,
		precursor = "coca",
		drug = "cocaine",
	},
	['pseudop'] = {
		ped = { ['heading'] = 20.0, ['model'] = 0xE497BBEF --[[s_m_y_dealer_01]] },
		pos = { ['x'] = 1391.11328125, ['y'] = 3608.18896484375, ['z'] = 37.94189453125 }, --pos = { ['x'] = 1640.7264404297, ['y'] = 3730.9936523438, ['z'] = 34.067134857178 },
		name = "Ephedrine Processor",
		icon = 403,
		processor = true,
		precursor = "pseudo",
		drug = "meth",
	},
	['diep'] = {
		ped = { ['heading'] = 20.0, ['model'] = 0xE497BBEF --[[s_m_y_dealer_01]] },
		pos = { ['x'] = 2515.3354492187, ['y'] = 3792.3996582031, ['z'] = 52.1224937438965 }, --pos = { ['x'] = 1640.7264404297, ['y'] = 3730.9936523438, ['z'] = 34.067134857178 },
		name = "Diethylamine Processor",
		icon = 403,
		processor = true,
		precursor = "dieth",
		drug = "acid",
	},
	['safp'] = {
		ped = { ['heading'] = 20.0, ['model'] = 0xE497BBEF --[[s_m_y_dealer_01]] },
		pos = { ['x'] = -1145.96435546875, ['y'] = 4940.06689453125, ['z'] = 221.268676757813 }, --pos = { ['x'] = 1640.7264404297, ['y'] = 3730.9936523438, ['z'] = 34.067134857178 },
		name = "Safrole Processor",
		icon = 403,
		processor = true,
		precursor = "safrole",
		drug = "xtc",
	},
}

local DrugNames = {weed = "Weed", cocaine = "Cocaine", meth = "Meth", acid = "Acid", xtc = "Ecstasy", cannabis = "Cannabis", pseudo = "Ephedrine", coca = "Coca", dieth = "Diethylamine", safrole = "Safrole"}

function returnIndexesInTable(t)
	local i = 0;
	for _,v in pairs(t)do
 		i = i + 1
	end
	return i;
end

function get3DDistance(x1, y1, z1, x2, y2, z2)
	return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2) + math.pow(z1 - z2, 2))
end


local tHandle = type
RegisterServerEvent("es_miscstores:buySellDrug")
AddEventHandler("es_miscstores:buySellDrug", function(dealer, type, drug, id)

	if(DrugDealers[dealer] == nil)then
		return
	end

	if(type == "buy")then
		if(DrugDealers[dealer].sells[drug] == nil)then
			return
		end
	elseif(type == "sell")then
		if(DrugDealers[dealer].buys[drug] == nil)then
			return
		end
	else
		return
	end

	TriggerEvent("es:getPlayerFromId", source, function(user)
		local dPos = DrugDealers[dealer].pos
		if(get3DDistance(user.coords.x, user.coords.y, user.coords.z, dPos.x, dPos.y, dPos.z) > 10.0)then
			return
		end

		if(type == "sell")then
			if(user:getSessionVar("items:" .. drug))then
				if(user:getSessionVar("items:"  .. drug) > 0)then
					local sellPrice = DrugDealers[dealer].RatesBuy[drug]

					TriggerClientEvent("chatMessage", source, "" .. DrugDealers[dealer].name, {255, 0, 0}, "You sold ^2" .. DrugNames[drug] .. "^0 for ^2$" .. sellPrice)
					TriggerClientEvent("es_miscstores:setDrugRates", -1, dealer, DrugDealers[dealer].RatesBuy, DrugDealers[dealer].RatesSell)
					TriggerClientEvent("es_miscstores:updateInventory", source, drug, user:getSessionVar("items:" .. drug) - 1)

					user:setSessionVar("items:" .. drug, user:getSessionVar("items:" .. drug) - 1)
					TriggerClientEvent('player:removeItem', source, id, 1)

					user:addMoney(sellPrice, function() end)
				else
					TriggerClientEvent("chatMessage", source, "" .. DrugDealers[dealer].name, {255, 0, 0}, "You do not have ^2" .. DrugNames[drug] .. "^0 in your inventory.")
				end
			else
				TriggerClientEvent("chatMessage", source, "" .. DrugDealers[dealer].name, {255, 0, 0}, "You do not have ^2" .. DrugNames[drug] .. "^0 in your inventory.")
			end
		else
			local buyPrice = DrugDealers[dealer].RatesSell[drug]

			if(user.money + 0.0 > buyPrice)then
				user:removeMoney(buyPrice, function() end)

				DrugDealers[dealer].RatesBuy[drug] = math.ceil(DrugDealers[dealer].RatesBuy[drug] * 1.008)
				DrugDealers[dealer].RatesSell[drug] = math.ceil(DrugDealers[dealer].RatesSell[drug] * 1.010)

				TriggerClientEvent("es_miscstores:setDrugRates", -1, dealer, DrugDealers[dealer].RatesBuy, DrugDealers[dealer].RatesSell)

				if(user:getSessionVar("items:" .. drug))then
					user:setSessionVar("items:" .. drug, user:getSessionVar("items:" .. drug) + 1)
					TriggerClientEvent('player:addItem', source, id, 1)
				else
					user:setSessionVar("items:" .. drug, 1)
					TriggerClientEvent('player:addItem', source, id, 1)
				end

				TriggerClientEvent("es_miscstores:updateInventory", source, drug, user:getSessionVar("items:" .. drug))

				TriggerClientEvent("chatMessage", source, "" .. DrugDealers[dealer].name, {255, 0, 0}, "You bought ^2" .. DrugNames[drug] .. "^0 for ^2$" .. buyPrice)
			else
				TriggerClientEvent("chatMessage", source, "" .. DrugDealers[dealer].name, {255, 0, 0}, "You don't have enough money to buy ^2" .. DrugNames[drug] .. "^0 for ^2$" .. buyPrice)
			end
		end
	end)
end)

RegisterServerEvent("es_miscstores:processDrug")
AddEventHandler("es_miscstores:processDrug", function(dealer, precursor, drug, processingCompleted)

	if(DrugDealers[dealer] == nil)then
		return
	end

	TriggerEvent("es:getPlayerFromId", source, function(user)
		local dPos = DrugDealers[dealer].pos
		if(get3DDistance(user.coords.x, user.coords.y, user.coords.z, dPos.x, dPos.y, dPos.z) > 10.0)then
			return
		end

		if(user:getSessionVar("items:" .. precursor))then
			if(user:getSessionVar("items:" .. precursor) > 0)then
				if(processingCompleted) then
					local processAmount = user:getSessionVar("items:" .. precursor)
					local existingAmount = user:getSessionVar("items:" .. drug)
					local totalAmount = processAmount + existingAmount

					--remove the precursors
					user:setSessionVar("items:" .. precursor, 0)
					TriggerClientEvent('player:removeItem', source, globalids[precursor], processAmount)
					TriggerClientEvent("es_miscstores:updateInventory", source, precursor, 0)
					--add the drugs
					user:setSessionVar("items:" .. drug, totalAmount)
					TriggerClientEvent('player:addItem', source, globalids[drug], processAmount)
					TriggerClientEvent("es_miscstores:updateInventory", source, drug, totalAmount)

					TriggerClientEvent("chatMessage", source, "" .. DrugDealers[dealer].name, {255, 0, 0}, "You have processed " .. processAmount .. " ^2" .. DrugNames[precursor] .. "^0 into ^2" .. DrugNames[drug])
				end
			else
				TriggerClientEvent("chatMessage", source, "" .. DrugDealers[dealer].name, {255, 0, 0}, "You do not have ^2" .. DrugNames[precursor] .. "^0 in your inventory.")
				TriggerClientEvent("es_miscstores:cancelProcessing", source)
			end
		else
			TriggerClientEvent("chatMessage", source, "" .. DrugDealers[dealer].name, {255, 0, 0}, "You do not have ^2" .. DrugNames[precursor] .. "^0 in your inventory.")
			TriggerClientEvent("es_miscstores:cancelProcessing", source)
		end
	end)
end)
