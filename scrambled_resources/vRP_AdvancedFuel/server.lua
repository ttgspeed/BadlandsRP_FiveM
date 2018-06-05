local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_fuel")

local players = {}
local serverEssenceArray = {}
local StationsPrice = {}

RegisterServerEvent('2f2dcffa-6569-4161-b6fe-d5c1580dd6f8')
AddEventHandler('2f2dcffa-6569-4161-b6fe-d5c1580dd6f8', function()
	local _source = source
	TriggerClientEvent('b4519fa4-62a2-488d-9152-98720782c8a7', source, StationsPrice)
	table.insert(players,_source)
end)

AddEventHandler('playerDropped', function(reason)
	local _source = source
	local newPlayers = {}

	for _,k in pairs(players) do
		if(k~=_source) then
			table.insert(newPlayers, k)
		end
	end

	players = {}
	players = newPlayers
end)

RegisterServerEvent('2958eb37-77ed-4594-8537-43a007c984c0')
AddEventHandler('2958eb37-77ed-4594-8537-43a007c984c0', function()
	local _source = source
	SetTimeout(2000, function()
		TriggerClientEvent('b4519fa4-62a2-488d-9152-98720782c8a7', _source, StationsPrice)
		TriggerClientEvent('3e39c868-d45e-4424-80f0-e12a23baf619', _source, serverEssenceArray)
	end)
end)


RegisterServerEvent('c8b8ee00-9dee-421c-8ef6-9826e10d8cd6')
AddEventHandler('c8b8ee00-9dee-421c-8ef6-9826e10d8cd6', function(essence, vplate, vmodel)
	local _source = source
	local bool, ind = searchByModelAndPlate(vplate, vmodel)
	if(bool and ind ~= nil) then
		serverEssenceArray[ind].es = essence
	else
		if(vplate ~=nil and vmodel~=nil and essence ~=nil) then
			table.insert(serverEssenceArray,{plate=vplate,model=vmodel,es=essence})
		end
	end

	TriggerClientEvent('a5715a46-8625-4fc4-9dee-e4d2a29f5cdc', -1, essence, vplate, vmodel)
end)

RegisterServerEvent('c6249963-4a92-489c-b6d6-78898eb875ec')
AddEventHandler('c6249963-4a92-489c-b6d6-78898eb875ec', function(amount, index,e)
	local _source = source

	local price = StationsPrice[index]

	if(e) then
		price = index
	end

	local toPay = round(amount*price,0)
	local user_id = vRP.getUserId({_source})
	if(vRP.tryDebitedPayment({user_id,toPay})) then
		TriggerClientEvent('91b6527a-f043-4422-8390-12a6d2ee7a18', _source, amount)
	else
		TriggerClientEvent('a5b59dfd-f41a-49ce-991b-05754b5959d4', _source, "You don't have enought money.")
	end

end)

RegisterServerEvent('4d6af728-ee7f-484f-9293-25ddaff90f59')
AddEventHandler('4d6af728-ee7f-484f-9293-25ddaff90f59',function()
	TriggerClientEvent('b4519fa4-62a2-488d-9152-98720782c8a7', source, StationsPrice)
end)


RegisterServerEvent('6f40b6c3-cd15-471b-8202-b66f3ae01983')
AddEventHandler('6f40b6c3-cd15-471b-8202-b66f3ae01983', function(plate,model)
	local _source = source
	local bool, ind = searchByModelAndPlate(plate, model)

	if(bool) then
		TriggerClientEvent('6e39669c-8337-45fa-a31b-886eee026916', _source, 1, serverEssenceArray[ind].es)
	else
		TriggerClientEvent('6e39669c-8337-45fa-a31b-886eee026916', _source, 0, 0)
	end
end)

RegisterServerEvent('ec9f4d04-2224-459b-bfa1-bc2653cadc6e')
AddEventHandler('ec9f4d04-2224-459b-bfa1-bc2653cadc6e', function(percent, vplate, vmodel)
	local bool, ind = searchByModelAndPlate(vplate, vmodel)

	local percentToEs = (percent/100)*0.142

	if(bool) then
		serverEssenceArray[ind].es = percentToEs
	else
		table.insert(serverEssenceArray,{plate=vplate,model=vmodel,es=percentToEs})
	end
end)

RegisterServerEvent('243c48bc-0755-4b5c-84f0-0200a1f667c1')
AddEventHandler('243c48bc-0755-4b5c-84f0-0200a1f667c1', function()
	local _source = source

	local toPay = petrolCanPrice
	local user_id = vRP.getUserId({_source})
	if(vRP.tryDebitedPayment({user_id,toPay})) then
		TriggerClientEvent('8770cbf7-c829-4381-b440-9ef136898919', _source)
	else
		TriggerClientEvent('a5b59dfd-f41a-49ce-991b-05754b5959d4', _source, "You don't have enought money.")
	end
end)

function round(num, dec)
  local mult = 10^(dec or 0)
  return math.floor(num * mult + 0.5) / mult
end

function renderPrice()
    for i=0,34 do
        if(randomPrice) then
            StationsPrice[i] = math.random(75,190)/100
        else
        	StationsPrice[i] = price
        end
    end

    --print("launched")
end

renderPrice()

function searchByModelAndPlate(plate, model)

	for i,k in pairs(serverEssenceArray) do
		if(k.plate == plate and k.model == model) then
			return true, i
		end
	end

	return false, -1
end
