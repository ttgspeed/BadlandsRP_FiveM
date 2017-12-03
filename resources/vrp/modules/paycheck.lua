local civPay = 200
local copPay = 800
local medicPay = 700
local paycheck = 0

RegisterServerEvent('vRP:salary')
AddEventHandler('vRP:salary', function()
  	local user_id = vRP.getUserId(source)
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
				bonus = 1600
			elseif vRP.hasPermission(user_id,"police.rank3") then
				bonus = 1000
			elseif vRP.hasPermission(user_id,"police.rank2") then
				bonus = 450
			elseif vRP.hasPermission(user_id,"police.rank1") then
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
		vRPclient.notify(source,{"You received your paycheck of $"..paycheck.."."})
	end
end)
