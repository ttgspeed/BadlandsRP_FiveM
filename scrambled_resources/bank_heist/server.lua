local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","bankHeist")

local bankHeistInProgress = false
local heistParticipants = {}
local bagCarriers = {}
local heistTimer = 300
local heistCooldown = false
local cooldownTimer = 10*60

--client events

--Join the heist
--Event triggered from client when heist is activated, gun is fired in the heist area, or too much time is spent in the heist area
--Adds the player to the list of heist participants, sets wanted level, and activates the first stage, once the first stage is past players can no longer join the heist
RegisterServerEvent('c0ca6dd9-4d53-40eb-8696-2abbe01ebdcb')
AddEventHandler('c0ca6dd9-4d53-40eb-8696-2abbe01ebdcb',function()
	if not heistCooldown then
		heistParticipants[source] = true
		TriggerClientEvent('39626b4c-686b-4d9a-b8f3-261d532bfc73',source)
		if not bankHeistInProgress then
			bankHeistStarted()
		else
			TriggerClientEvent('bf6f6300-8ea3-4b3a-8df9-876e967879a8',source,heistTimer)
		end
	else
		vRPclient.notify(source,{"Bank heist is on cooldown."})
	end
end)

--Event triggered from the client when a player currently in the heist has died or entered a coma
--Removes the player from the list of heist participants and ends the heist if no more participants are left
RegisterServerEvent('d01cffcf-9a85-4228-9b9b-89948ea18978')
AddEventHandler('d01cffcf-9a85-4228-9b9b-89948ea18978',function()
	heistParticipants[source] = nil
	if next(heistParticipants) == nil then --last heist member has exited
		bankHeistInProgress = false
		TriggerClientEvent('d31295f7-7b31-4ba2-b116-5258daa80aa8',-1,bankHeistInProgress)
		setCooldown()
	end
end)

--Event triggered from the client when a player has dropped connection
--Removes player from the list of heist participants and ends the heist if no participants are left
RegisterServerEvent('playerDropped')
AddEventHandler('playerDropped', function()
    heistParticipants[source] = nil
	if next(heistParticipants) == nil then --last heist member has exited
		bankHeistInProgress = false
		TriggerClientEvent('d31295f7-7b31-4ba2-b116-5258daa80aa8',-1,bankHeistInProgress)
		setCooldown()
	end
end)

--Event triggered from the client when a player has picked up a heist bag from the bank
--Adds the player to the list of bag carriers
RegisterServerEvent('4edd5c40-f4d8-49c0-b5d8-df3826d48ff3')
AddEventHandler('4edd5c40-f4d8-49c0-b5d8-df3826d48ff3',function()
	bagCarriers[source] = true
end)


--Event triggered from the client when the player has completed the heist. i.e. player has broken the vault, collected a heist bag and brought it to the safehouse.
--Checks if the player is in the list of bag carriers and if so, pays out the money. Then removes the player form the list of heist participants and bag carriers, ending the heist if no participants are left.
RegisterServerEvent('fa57f4cb-d5ca-45c1-bd83-32e8f38461c9')
AddEventHandler('fa57f4cb-d5ca-45c1-bd83-32e8f38461c9',function()
	vRP.getUserId({source},function(user_id)
		if user_id ~= nil and bagCarriers[source] ~= nil then
			vRP.giveMoney({user_id,30000})
			--vRP.giveInventoryItem({user_id,"dirty_money",50000}) -- Temp change to cash until business start up is lower priced
		end
		heistParticipants[source] = nil
		bagCarriers[source] = nil
		if next(heistParticipants) == nil then --last heist member has exited
			bankHeistInProgress = false
			TriggerClientEvent('d31295f7-7b31-4ba2-b116-5258daa80aa8',-1,bankHeistInProgress)
			setCooldown()
		end
	end)
end)

--server functions

--Starts the bank heist
--Broadcasts to all players that heist is in progress, and starts stage 1
function bankHeistStarted()
	if not heistCooldown then
		bankHeistInProgress = true
		TriggerClientEvent('d31295f7-7b31-4ba2-b116-5258daa80aa8',-1,bankHeistInProgress)
		for k,v in pairs(heistParticipants) do
			TriggerClientEvent('bf6f6300-8ea3-4b3a-8df9-876e967879a8',k,heistTimer)
		end
		heistStage1()
	end
end

--Heist stage 1
--Decrement the timer ever second, if the timer is less than or equal to zero move to stage 2
function heistStage1()
	if heistTimer <= 0 then
		heistStage2()
	else
		heistTimer = heistTimer - 1
		SetTimeout(1000,heistStage1)
	end
end

--Heist stage 2
--Broadcasts to all heist participants that stage 2 has begun. Stage 2 is get the heist bag and take it to the safehouse, all done client side.
function heistStage2()
	for k,v in pairs(heistParticipants) do
		TriggerClientEvent('c372f95b-020a-473d-af4d-d540b1dcd1f3',k)
	end
end

--Sets the cooldown of the heist
--Decrement the cooldown timer and reset the heist when the timer is up
function setCooldown()
	heistCooldown = true
	cooldownTimer = cooldownTimer - 1
	if cooldownTimer < 0 then
		resetHeist()
	else
		SetTimeout(1000,setCooldown)
	end
end

--Resets the hiest
--Initializes all variables to their default state. The heist is now ready to be started again.
function resetHeist()
	bankHeistInProgress = false
	heistParticipants = {}
	bagCarriers = {}
	heistTimer = 300
	heistCooldown = false
	cooldownTimer = 10*60
end
