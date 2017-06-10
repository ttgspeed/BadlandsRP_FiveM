local civPay = 800
local copPay = 1200
local medicPay = 1200
local paycheck = 0

RegisterServerEvent('vRP:salary')
AddEventHandler('vRP:salary', function()
  	local user_id = vRP.getUserId(source)
  	if user_id ~= nil then
		if vRP.hasPermission(user_id,"police.paycheck") then
			paycheck = copPay
		elseif vRP.hasPermission(user_id,"emergency.paycheck") then
			paycheck = medicPay
		elseif vRP.hasPermission(user_id,"citizen.paycheck") then
			paycheck = civPay
		else
			paycheck = 0
		end
		vRP.giveMoney(user_id,paycheck)
		TriggerClientEvent("pNotify:SendNotification", -1, {text = "You received your paycheck of $"..paycheck.."." , type = "success", layout = "centerLeft", queue = "left", timeout = math.random(1000, 10000)})
	end
end)
