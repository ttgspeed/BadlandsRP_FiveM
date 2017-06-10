RegisterServerEvent('vRP:salary')
AddEventHandler('vRP:salary', function()
  	local user_id = vRP.getUserId(source)
  	if user_id ~= nil then
		if vRP.hasPermission(user_id,"police.paycheck") then
			vRP.giveMoney(user_id,1200)
			vRPclient.notify(source,{"PAYDAY: $1200"})
		elseif vRP.hasPermission(user_id,"emergency.paycheck") then
			vRP.giveMoney(user_id,1200)
			vRPclient.notify(source,{"PAYDAY: $1200"})
		elseif vRP.hasPermission(user_id,"citizen.paycheck") then
			vRP.giveMoney(user_id,800)
			vRPclient.notify(source,{"PAYDAY: $800"})
		end
	end
end)
