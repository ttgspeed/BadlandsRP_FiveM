local globalids = {
	xtc = 5,
	acid = 4,
	weed = 1,
	cocaine = 2,
	meth = 3
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
local globalNormalizationSell = {
	xtc = 1000,
	acid = 700,
	weed = 700,
	cocaine = 1100,
	meth = 1200,
}
local globalNormalizationBuy = {
	xtc = 800,
	acid = 500,
	weed = 500,
	cocaine = 900,
	meth = 1000,
}
local DrugDealers = {
	['matthew'] = {
		ped = { ['heading'] = 20.0, ['model'] = 0xE497BBEF --[[s_m_y_dealer_01]] },
		pos = { ['x'] = 227.153757, ['y'] = -871.66656, ['z'] = 30.492092 }, --pos = { ['x'] = 1640.7264404297, ['y'] = 3730.9936523438, ['z'] = 34.067134857178 },
		name = "Matthew",
		buys = globalbuys,
		sells = globalsells,
		prefferedBuy = "",
		prefferedSell = "",
		RatesSell = globalRatesSell,
		RatesBuy = globalRatesBuy,
		NormalizationSell = globalNormalizationSell,
		NormalizationBuy = globalNormalizationBuy,
	},
	['nick'] = {
		ped = { ['heading'] = 330.0, ['model'] = 0xE497BBEF --[[s_m_y_dealer_01]] },
		pos = { ['x'] = 1177.1647949219, ['y'] = 2722.220703125, ['z'] = 38.004173278809 },
		name = "Nick",
		buys = globalbuys,
		sells = globalsells,
		prefferedBuy = "weed",
		prefferedSell = "cocaine",
		RatesSell = globalRatesSell,
		RatesBuy = globalRatesBuy,
		NormalizationSell = globalNormalizationSell,
		NormalizationBuy = globalNormalizationBuy,
	},
	['alexanderkuhta'] = {
		ped = { ['heading'] = 20.0, ['model'] = 0x46521A32 --[[cs_russiandrunk]] },
		pos = { ['x'] = -1724.7882080078, ['y'] = 234.66094970703, ['z'] = 58.471710205078 },
		name = "A. Kuhta",
		buys = globalbuys,
		sells = globalsells,
		prefferedBuy = "cocaine",
		prefferedSell = "meth",
		RatesSell = globalRatesSell,
		RatesBuy = globalRatesBuy,
		NormalizationSell = globalNormalizationSell,
		NormalizationBuy = globalNormalizationBuy,
	},
	['varent'] = {
		ped = { ['heading'] = 0.0, ['model'] = 0x54DBEE1F --[[a_m_m_bevhills_01]] },
		pos = { ['x'] = -761.85791015625, ['y'] = 351.92532348633, ['z'] = 86.998001098633 },
		name = "T. Varent",
		buys = globalbuys,
		sells = globalsells,
		prefferedBuy = "cocaine",
		prefferedSell = "acid",
		RatesSell = globalRatesSell,
		RatesBuy = globalRatesBuy,
		NormalizationSell = globalNormalizationSell,
		NormalizationBuy = globalNormalizationBuy,
	},
	['0x420'] = {
		ped = { ['heading'] = 280.0, ['model'] = 0x23B88069 --[[g_f_y_ballas_01]] },
		pos = { ['x'] = 77.885513305664, ['y'] = -1948.2086181641, ['z'] = 20.174139022827 },
		name = "T. Varent",
		buys = globalbuys,
		sells = globalsells,
		prefferedBuy = "cocaine",
		prefferedSell = "acid",
		RatesSell = globalRatesSell,
		RatesBuy = globalRatesBuy,
		NormalizationSell = globalNormalizationSell,
		NormalizationBuy = globalNormalizationBuy,
	},
	['marythomas'] = {
		ped = { ['heading'] = 200.0, ['model'] = 0x4E0CE5D3 --[[g_f_y_ballas_01]] },
		pos = { ['x'] = -224.3656463623, ['y'] = -1667.0147705078, ['z'] = 36.636913299561 },
		name = "M. Thomas",
		buys = globalbuys,
		sells = globalsells,
		prefferedBuy = "cocaine",
		prefferedSell = "acid",
		RatesSell = globalRatesSell,
		RatesBuy = globalRatesBuy,
		NormalizationSell = globalNormalizationSell,
		NormalizationBuy = globalNormalizationBuy,
	},
	['alicia'] = {
		ped = { ['heading'] = 280.0, ['model'] = 0x5D71A46F --[[s_f_y_airhostess_01]] },
		pos = { ['x'] = -979.21936035156, ['y'] = -2679.1882324219, ['z'] = 35.604850769043 },
		name = "Alicia",
		buys = globalbuys,
		sells = globalsells,
		prefferedBuy = "cocaine",
		prefferedSell = "acid",
		RatesSell = globalRatesSell,
		RatesBuy = globalRatesBuy,
		NormalizationSell = globalNormalizationSell,
		NormalizationBuy = globalNormalizationBuy,
	},
	['kanersps'] = {
		ped = { ['heading'] = 100.0, ['model'] = 0xF1E823A2 --[[s_f_y_airhostess_01]] },
		pos = { ['x'] = 1222.0125732422, ['y'] = -2920.1618652344, ['z'] = 4.8660640716553 },
		name = "Kane M.",
		buys = globalbuys,
		sells = globalsells,
		prefferedBuy = "cocaine",
		prefferedSell = "acid",
		RatesSell = globalRatesSell,
		RatesBuy = globalRatesBuy,
		NormalizationSell = globalNormalizationSell,
		NormalizationBuy = globalNormalizationBuy,
	},
	['liam'] = {
		ped = { ['heading'] = 40.0, ['model'] = 0xF1E823A2 --[[s_f_y_airhostess_01]] },
		pos = { ['x'] = 1302.6696777344, ['y'] = 4226.1025390625, ['z'] = 32.908679962158 },
		name = "Liam",
		buys = globalbuys,
		sells = globalsells,
		prefferedBuy = "cocaine",
		prefferedSell = "acid",
		RatesSell = globalRatesSell,
		RatesBuy = globalRatesBuy,
		NormalizationSell = globalNormalizationSell,
		NormalizationBuy = globalNormalizationBuy,
	}
}

local DrugNames = {weed = "Weed", cocaine = "Cocaine", meth = "Meth", acid = "Acid", xtc = "Ecstasy"}

function returnIndexesInTable(t)
	local i = 0;
	for _,v in pairs(t)do
 		i = i + 1
	end
	return i;
end

function normalizationPrices()
	SetTimeout(15000000, function()
		TriggerClientEvent("chatMessage", -1, "DEALERS", {255, 0, 0}, "Dealer prices will be normalized in: ^25 minutes.")

		SetTimeout(300000, function()
			for k,v in pairs(DrugDealers) do
				DrugDealers[k].RatesBuy = v.NormalizationBuy
				DrugDealers[k].RatesSell = v.NormalizationSell


				TriggerClientEvent("es_miscstores:setDrugRatesAll", -1, k)
			end

			TriggerClientEvent("chatMessage", -1, "DEALERS", {255, 0, 0}, "Supply & Demand of all dealers have been normalized.")

			normalizationPrices()
		end)
	end)
end
normalizationPrices()

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

					if(math.ceil(DrugDealers[dealer].RatesBuy[drug] - (DrugDealers[dealer].RatesBuy[drug] * 0.01)) > DrugDealers[dealer].NormalizationBuy[drug])then
						DrugDealers[dealer].RatesBuy[drug] = math.ceil(DrugDealers[dealer].RatesBuy[drug] - (DrugDealers[dealer].RatesBuy[drug] * 0.01))
					else
						DrugDealers[dealer].RatesBuy[drug] = DrugDealers[dealer].NormalizationBuy[drug]
					end

					if(math.ceil(DrugDealers[dealer].RatesSell[drug] - (DrugDealers[dealer].RatesSell[drug] * 0.02)) > DrugDealers[dealer].NormalizationSell[drug])then
						DrugDealers[dealer].RatesSell[drug] = math.ceil(DrugDealers[dealer].RatesSell[drug] - (DrugDealers[dealer].RatesSell[drug] * 0.02))
					else
						DrugDealers[dealer].RatesSell[drug] = DrugDealers[dealer].NormalizationSell[drug]
					end

					TriggerClientEvent("chatMessage", source, "" .. DrugDealers[dealer].name, {255, 0, 0}, "You sold ^2" .. DrugNames[drug] .. "^0 for ^2" .. sellPrice)
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

				TriggerClientEvent("chatMessage", source, "" .. DrugDealers[dealer].name, {255, 0, 0}, "You bought ^2" .. DrugNames[drug] .. "^0 for ^2" .. buyPrice)
			else
				TriggerClientEvent("chatMessage", source, "" .. DrugDealers[dealer].name, {255, 0, 0}, "You don't have enough money to buy ^2" .. DrugNames[drug] .. "^0 for ^2" .. buyPrice)
			end
		end
	end)
end)
