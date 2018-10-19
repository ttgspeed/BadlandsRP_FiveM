local civPay = 200
local copPay = 800
local medicPay = 900
local paycheck = 0

local function give_paycheck(player)
	local user_id = vRP.getUserId(player)
  if user_id ~= nil then
		if vRP.hasPermission(user_id,"police.paycheck") then
			local bonus = 0
			if vRP.hasPermission(user_id,"police.rank7") then
				bonus = 3200
			elseif vRP.hasPermission(user_id,"police.rank6") then
				bonus = 3200
			elseif vRP.hasPermission(user_id,"police.rank5") then
				bonus = 2200
			elseif vRP.hasPermission(user_id,"police.rank4") then
				bonus = 1900
			elseif vRP.hasPermission(user_id,"police.rank3") then
				bonus = 1400
			elseif vRP.hasPermission(user_id,"police.rank2") then
				bonus = 1000
			elseif vRP.hasPermission(user_id,"police.rank1") then
				bonus = 450
			elseif vRP.hasPermission(user_id,"police.rank0") then
				bonus = 0
			end
			paycheck = copPay + bonus
		elseif vRP.hasPermission(user_id,"emergency.paycheck") then
			local bonus = 0
			if vRP.hasPermission(user_id,"ems.rank5") then
				bonus = 3000
			elseif vRP.hasPermission(user_id,"ems.rank4") then
				bonus = 2000
			elseif vRP.hasPermission(user_id,"ems.rank3") then
				bonus = 1400
			elseif vRP.hasPermission(user_id,"ems.rank2") then
				bonus = 600
			elseif vRP.hasPermission(user_id,"ems.rank1") then
				bonus = 0
			end
			paycheck = medicPay + bonus
		elseif vRP.hasPermission(user_id,"citizen.paycheck") then
			paycheck = civPay
		else
			paycheck = 0
		end
		vRP.giveBankMoney(user_id,paycheck)
		vRPclient.notify(player,{"You received your paycheck of $"..paycheck.."."})
	end
end

Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(300000) -- Every X ms you'll get paid (300000 = 5 min)
		for _,player in pairs(GetPlayers()) do
			vRPclient.isInPrison(player, {}, function(inprison)
				if not inprison then
					give_paycheck(player)
				end
			end)
		end
	end
end)
