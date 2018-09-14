local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local Log = module("vrp", "lib/Log")

vRPts = {}
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","esx_identity")
--TSclient = Tunnel.getInterface("vrp_phone","vrp_phone")
--Tunnel.bindInterface("vrp_phone",vRPts)

function getIdentity(source, callback)
	local sourcePlayer = tonumber(source)
	local user_id = vRP.getUserId({source})

	MySQL.Async.fetchAll("SELECT * FROM `vrp_user_identities` WHERE `user_id` = @identifier",
	{
		['@identifier'] = user_id
	}, function(result)
		if result[1].firstname ~= nil then
			local data = {
				identifier	= result[1].user_id,
				firstname	= result[1].firstname,
				lastname	= result[1].name,
				registration = result[1].registration,
				phone = result[1].phone,
				dateofbirth	= '',
				sex			= '',
				height		= ''
			}
			callback(data)
		else
			local data = {
				identifier	= '',
				firstname	= '',
				lastname	= '',
				registration = '',
				phone = '',
				dateofbirth	= '',
				sex			= '',
				height		= ''
			}

			callback(data)
		end
	end)
end

function getCharacters(source, callback)
	local sourcePlayer = tonumber(source)
	local user_id = vRP.getUserId({source})

	MySQL.Async.fetchAll("SELECT * FROM `characters` WHERE `identifier` = @identifier",
	{
		['@identifier'] = user_id
	}, function(result)
		if result[1] and result[2] and result[3] then
			local data = {
				identifier		= result[1].identifier,
				firstname1		= result[1].firstname,
				lastname1		= result[1].lastname,
				registration1 = result[1].registration,
				phone1 = result[1].phone,
				dateofbirth1	= result[1].dateofbirth,
				sex1			= result[1].sex,
				height1			= result[1].height,
				firstname2		= result[2].firstname,
				lastname2		= result[2].lastname,
				registration2 = result[2].registration,
				phone2 = result[2].phone,
				dateofbirth2	= result[2].dateofbirth,
				sex2			= result[2].sex,
				height2			= result[2].height,
				firstname3		= result[3].firstname,
				lastname3		= result[3].lastname,
				registration3 = result[3].registration,
				phone3 = result[3].phone,
				dateofbirth3	= result[3].dateofbirth,
				sex3			= result[3].sex,
				height3			= result[3].height
			}

			callback(data)
		elseif result[1] and result[2] and not result[3] then
			local data = {
				identifier		= result[1].identifier,
				firstname1		= result[1].firstname,
				lastname1		= result[1].lastname,
				registration1 = result[1].registration,
				phone1 = result[1].phone,
				dateofbirth1	= result[1].dateofbirth,
				sex1			= result[1].sex,
				height1			= result[1].height,
				firstname2		= result[2].firstname,
				lastname2		= result[2].lastname,
				registration2 = result[2].registration,
				phone2 = result[2].phone,
				dateofbirth2	= result[2].dateofbirth,
				sex2			= result[2].sex,
				height2			= result[2].height,
				firstname3		= '',
				lastname3		= '',
				registration3 = '',
				phone3 = '',
				dateofbirth3	= '',
				sex3			= '',
				height3			= ''
			}

			callback(data)
		elseif result[1] and not result[2] and not result[3] then
			local data = {
				identifier		= result[1].identifier,
				firstname1		= result[1].firstname,
				lastname1		= result[1].lastname,
				registration1 = result[1].registration,
				phone1 = result[1].phone,
				dateofbirth1	= result[1].dateofbirth,
				sex1			= result[1].sex,
				height1			= result[1].height,
				firstname2		= '',
				lastname2		= '',
				registration2 = '',
				phone2 = '',
				dateofbirth2	= '',
				sex2			= '',
				height2			= '',
				firstname3		= '',
				lastname3		= '',
				registration3 = '',
				phone3 = '',
				dateofbirth3	= '',
				sex3			= '',
				height3			= ''
			}

			callback(data)
		else
			local data = {
				identifier		= '',
				firstname1		= '',
				lastname1		= '',
				registration1 = '',
				phone1 = '',
				dateofbirth1	= '',
				sex1			= '',
				height1			= '',
				firstname2		= '',
				lastname2		= '',
				registration2 = '',
				phone2 = '',
				dateofbirth2	= '',
				sex2			= '',
				height2			= '',
				firstname3		= '',
				lastname3		= '',
				registration3 = '',
				phone3 = '',
				dateofbirth3	= '',
				sex3			= '',
				height3			= ''
			}

			callback(data)
		end
	end)
end

function setIdentity(source, data, callback)
	local sourcePlayer = tonumber(source)
	local user_id = vRP.getUserId({sourcePlayer})
	vRP.generateRegistrationNumber({function(registration)
		vRP.generatePhoneNumber({function(phone)

			MySQL.Async.execute("UPDATE `vrp_user_identities` SET `firstname` = @firstname, `name` = @lastname, `registration` = @registration, `phone` = @phone WHERE user_id = @identifier",
			{
				['@identifier']		= user_id,
				['@firstname']		= data.firstname,
				['@lastname']		= data.lastname,
				['@registration']		= registration,
				['@phone']		= phone,
			}, function(done)
				if callback then
					callback(true)
				end
			end)

			MySQL.Async.execute(
			'INSERT INTO characters (identifier, firstname, lastname, dateofbirth, sex, height, registration, phone) VALUES (@identifier, @firstname, @lastname, @dateofbirth, @sex, @height, @registration, @phone)',
			{
				['@identifier']		= user_id,
				['@firstname']		= data.firstname,
				['@lastname']		= data.lastname,
				['@dateofbirth']	= data.dateofbirth,
				['@sex']			= data.sex,
				['@height']			= data.height,
				['@registration']			= registration,
				['@phone']			= phone
			})
		end})
	end})
end

function updateIdentity(source, data, charNumber, callback)
	local sourcePlayer = tonumber(source)
	local user_id = vRP.getUserId({sourcePlayer})
	MySQL.Async.execute("UPDATE `vrp_user_identities` SET `firstname` = @firstname, `name` = @lastname, `registration` = @registration, `phone` = @phone, `active_character` = @charNumber WHERE user_id = @identifier",
	{
		['@identifier']		= user_id,
		['@firstname']		= data.firstname,
		['@lastname']		= data.lastname,
		['@registration']		= data.registration,
		['@phone']		= data.phone,
		['@charNumber']		= charNumber,
	}, function(done)
		vRPclient.setRegistrationNumber(sourcePlayer,{registration})
		TriggerClientEvent('chat:playerInfo',sourcePlayer,user_id,""..data.firstname.." "..data.lastname)
		if callback then
			callback(true)
		end
	end)
end

function deleteIdentity(source, data, callback)
	local sourcePlayer = tonumber(source)
	local user_id = vRP.getUserId({sourcePlayer})
	MySQL.Async.execute("DELETE FROM `characters` WHERE identifier = @identifier AND firstname = @firstname AND lastname = @lastname AND dateofbirth = @dateofbirth AND sex = @sex AND height = @height",
	{
		['@identifier']		= user_id,
		['@firstname']		= data.firstname,
		['@lastname']		= data.lastname,
		['@dateofbirth']	= data.dateofbirth,
		['@sex']			= data.sex,
		['@height']			= data.height
	}, function(done)
		if callback then
			callback(true)
		end
	end)
end

RegisterServerEvent('esx_identity:setIdentity')
AddEventHandler('esx_identity:setIdentity', function(data, myIdentifiers)
	setIdentity(source, data, function(callback)
		if callback then
			TriggerClientEvent('esx_identity:identityCheck', myIdentifiers.playerid, true)
		else
			TriggerClientEvent('chat:addMessage', source, { args = { '^[IDENTITY]', 'Failed to set character, try again later or contact the server admin!' } })
		end
	end)
end)

AddEventHandler('es:playerLoaded', function(source)
	local myID = {
		steamid = GetPlayerIdentifiers(source)[1],
		playerid = source
	}

	TriggerClientEvent('esx_identity:saveID', source, myID)
	getIdentity(source, function(data)
		if data.firstname == '' then
			TriggerClientEvent('esx_identity:identityCheck', source, false)
			TriggerClientEvent('esx_identity:showRegisterIdentity', source)
		else
			TriggerClientEvent('esx_identity:identityCheck', source, true)
		end
	end)
end)

--[[
AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.Wait(3000)

		-- Set all the client side variables for connected users one new time
		local xPlayers = ESX.GetPlayers()
		for i=1, #xPlayers, 1 do

			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

			local myID = {
				steamid  = xPlayer.identifier,
				playerid = xPlayer.source
			}

			TriggerClientEvent('esx_identity:saveID', xPlayer.source, myID)

			getIdentity(xPlayer.source, function(data)
				if data.firstname == '' then
					TriggerClientEvent('esx_identity:identityCheck', xPlayer.source, false)
					TriggerClientEvent('esx_identity:showRegisterIdentity', xPlayer.source)
				else
					TriggerClientEvent('esx_identity:identityCheck', xPlayer.source, true)
				end
			end)
		end
	end
end)
]]--

AddEventHandler('chatMessage', function(from,name,message)
	if(string.sub(message,1,1) == "/") then

		local args = splitString(message)
		local cmd = args[1]
		local source = from
		local user_id = vRP.getUserId({source})
		local data = vRP.getUserDataTable({user_id})

		if cmd == "/register" then
			getCharacters(source, function(data)
				if data.firstname3 ~= '' then
					vRPclient.notify(source,{"[IDENTITY] You can only have 3 registered characters. Use the /chardel  command in order to delete existing characters."})
				else
					TriggerClientEvent('esx_identity:showRegisterIdentity', source, {})
				end
			end)

		elseif cmd == "/char" then
			getIdentity(source, function(data)
				if data.firstname == '' then
					vRPclient.notify(source,{'[IDENTITY] You do not have an active character!' })
				else
					vRPclient.notify(source,{'[IDENTITY] Active character: ' .. data.firstname .. ' ' .. data.lastname })
				end
			end)
		elseif cmd == "/charlist" then
			getCharacters(source, function(data)
				if data.firstname1 ~= '' then
					vRPclient.notify(source,{'[IDENTITY] Character 1:'..data.firstname1 .. ' ' .. data.lastname1 })

					if data.firstname2 ~= '' then
						vRPclient.notify(source,{'[IDENTITY] Character 2:'..data.firstname2 .. ' ' .. data.lastname2 })

						if data.firstname3 ~= '' then
							vRPclient.notify(source,{'[IDENTITY] Character 3:'..data.firstname3 .. ' ' .. data.lastname3 })
						end
					end
				else
					vRPclient.notify(source,{'[IDENTITY] You have no registered characters. Use the /register command to register a character.'})
				end
			end)
		elseif cmd == "/charselect" then
			local charNumber = tonumber(args[2])

			if charNumber == nil or charNumber > 3 or charNumber < 1 then
				vRPclient.notify(source,{"[IDENTITY] That's an invalid character!"})
				return
			end

			getCharacters(source, function(data)
				if charNumber == 1 then
					local data = {
						identifier	= data.identifier,
						firstname	= data.firstname1,
						lastname	= data.lastname1,
						registration = data.registration1,
						phone = data.phone1,
						dateofbirth	= data.dateofbirth1,
						sex			= data.sex1,
						height		= data.height1
					}

					if data.firstname ~= '' then
						updateIdentity(source, data, charNumber, function(callback)
							if callback then
								vRPclient.notify(source,{'[IDENTITY] Updated your active character to ' .. data.firstname .. ' ' .. data.lastname })
							else
								vRPclient.notify(source,{'[IDENTITY] Failed to update your identity, try again later or contact the server admin!' })
							end
						end)
					else
						vRPclient.notify(source,{"[IDENTITY] You don't have a character in slot 1!"})
					end
				elseif charNumber == 2 then

					local data = {
						identifier	= data.identifier,
						firstname	= data.firstname2,
						lastname	= data.lastname2,
						registration = data.registration2,
						phone = data.phone2,
						dateofbirth	= data.dateofbirth2,
						sex			= data.sex2,
						height		= data.height2
					}

					if data.firstname ~= '' then
						updateIdentity(source, data, charNumber, function(callback)

							if callback then
								vRPclient.notify(source,{'^1[IDENTITY] Updated your active character to ' .. data.firstname .. ' ' .. data.lastname })
							else
								vRPclient.notify(source,{'^1[IDENTITY] Failed to update your identity, try again later or contact the server admin!' })
							end
						end)
					else
						vRPclient.notify(source,{'^1[IDENTITY] You don\'t have a character in slot 2!' })
					end
				elseif charNumber == 3 then

					local data = {
						identifier	= data.identifier,
						firstname	= data.firstname3,
						lastname	= data.lastname3,
						registration = data.registration3,
						phone = data.phone3,
						dateofbirth	= data.dateofbirth3,
						sex			= data.sex3,
						height		= data.height3
					}

					if data.firstname ~= '' then
						updateIdentity(source, data, charNumber, function(callback)
							if callback then
								vRPclient.notify(source,{'[IDENTITY] Updated your active character to ^2' .. data.firstname .. ' ' .. data.lastname })
							else
								vRPclient.notify(source,{'[IDENTITY] Failed to update your identity, try again later or contact the server admin!'})
							end
						end)
					else
						vRPclient.notify(source,{'[IDENTITY] You don\'t have a character in slot 3!'})
					end
				else
					vRPclient.notify(source,{'[IDENTITY] Failed to update your identity, try again later or contact the server admin!'})
				end
			end)
		elseif cmd == "/chardel" then
			local charNumber = tonumber(args[2])

			if charNumber == nil or charNumber > 3 or charNumber < 1 then
				vRPclient.notify(source,{'[IDENTITY] That\'s an invalid character!'})
				return
			end

			getCharacters(source, function(data)

				if charNumber == 1 then

					local data = {
						identifier	= data.identifier,
						firstname	= data.firstname1,
						lastname	= data.lastname1,
						dateofbirth	= data.dateofbirth1,
						sex			= data.sex1,
						height		= data.height1
					}

					if data.firstname ~= '' then
						deleteIdentity(source, data, function(callback)
							if callback then
								vRPclient.notify(source,{'[IDENTITY] You have deleted ' .. data.firstname .. ' ' .. data.lastname })
							else
								vRPclient.notify(source,{'[IDENTITY] Failed to delete the character, try again later or contact the server admin!'})
							end
						end)
					else
						vRPclient.notify(source,{'[IDENTITY] You don\'t have a character in slot 1!' })
					end

				elseif charNumber == 2 then

					local data = {
						identifier	= data.identifier,
						firstname	= data.firstname2,
						lastname	= data.lastname2,
						dateofbirth	= data.dateofbirth2,
						sex 		= data.sex2,
						height		= data.height2
					}

					if data.firstname ~= '' then
						deleteIdentity(source, data, function(callback)
							if callback then
								vRPclient.notify(source,{'[IDENTITY] You have deleted ^1' .. data.firstname .. ' ' .. data.lastname })
							else
								vRPclient.notify(source,{'[IDENTITY] Failed to delete the character, try again later or contact the server admin!' })
							end
						end)
					else
						vRPclient.notify(source,{'[IDENTITY] You don\'t have a character in slot 2!'})
					end

				elseif charNumber == 3 then

					local data = {
						identifier	= data.identifier,
						firstname	= data.firstname3,
						lastname	= data.lastname3,
						dateofbirth	= data.dateofbirth3,
						sex			= data.sex3,
						height		= data.height3
					}

					if data.firstname ~= '' then
						deleteIdentity(source, data, function(callback)
							if callback then
								vRPclient.notify(source,{'[IDENTITY] You have deleted ' .. data.firstname .. ' ' .. data.lastname })
							else
								vRPclient.notify(source,{'[IDENTITY] Failed to delete the character, try again later or contact the server admin!' })
							end
						end)
					else
						vRPclient.notify(source,{'[IDENTITY] You don\'t have a character in slot 3!'})
					end
				else
					vRPclient.notify(source,{'[IDENTITY] Failed to delete the character, try again!'})
				end
			end)
		end
	end
end)

function splitString(str, sep)
  if sep == nil then sep = "%s" end

  local t={}
  local i=1

  for str in string.gmatch(str, "([^"..sep.."]+)") do
    t[i] = str
    i = i + 1
  end

  return t
end
--[[
TriggerEvent('es:addCommand', 'register', function(source, args, user)
	getCharacters(source, function(data)
		if data.firstname3 ~= '' then
			TriggerClientEvent('chat:addMessage', source, { args = { '^[IDENTITY]', 'You can only have 3 registered characters. Use the ^3/chardel^0  command in order to delete existing characters.' } })
		else
			TriggerClientEvent('esx_identity:showRegisterIdentity', source, {})
		end
	end)
end, {help = "Register a new character"})

TriggerEvent('es:addGroupCommand', 'char', 'user', function(source, args, user)
	getIdentity(source, function(data)
		if data.firstname == '' then
			TriggerClientEvent('chat:addMessage', source, { args = { '^1[IDENTITY]', 'You do not have an active character!' } })
		else
			TriggerClientEvent('chat:addMessage', source, { args = { '^1[IDENTITY]', 'Active character: ^2' .. data.firstname .. ' ' .. data.lastname } })
		end
	end)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient permissions!' } })
end, {help = "List your current character"})

TriggerEvent('es:addGroupCommand', 'charlist', 'user', function(source, args, user)
	getCharacters(source, function(data)
		if data.firstname1 ~= '' then
			TriggerClientEvent('chat:addMessage', source, { args = { '^1[IDENTITY] Character 1:', data.firstname1 .. ' ' .. data.lastname1 } })

			if data.firstname2 ~= '' then
				TriggerClientEvent('chat:addMessage', source, { args = { '^1[IDENTITY] Character 2:', data.firstname2 .. ' ' .. data.lastname2 } })

				if data.firstname3 ~= '' then
					TriggerClientEvent('chat:addMessage', source, { args = { '^1[IDENTITY] Character 3:', data.firstname3 .. ' ' .. data.lastname3 } })
				end
			end
		else
			TriggerClientEvent('chat:addMessage', source, { args = { '^[IDENTITY]', 'You have no registered characters. Use the ^3/register^0 command to register a character.' } })
		end
	end)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient permissions!' } })
end, {help = "List all your registered characters"})

TriggerEvent('es:addGroupCommand', 'charselect', 'user', function(source, args, user)
	local charNumber = tonumber(args[1])

	if charNumber == nil or charNumber > 3 or charNumber < 1 then
		TriggerClientEvent('chat:addMessage', source, { args = { '^[IDENTITY]', 'That\'s an invalid character!' } })
		return
	end

	getCharacters(source, function(data)
		if charNumber == 1 then
			local data = {
				identifier	= data.identifier,
				firstname	= data.firstname1,
				lastname	= data.lastname1,
				dateofbirth	= data.dateofbirth1,
				sex			= data.sex1,
				height		= data.height1
			}

			if data.firstname ~= '' then
				updateIdentity(source, data, function(callback)
					if callback then
						TriggerClientEvent('chat:addMessage', source, { args = { '^1[IDENTITY]', 'Updated your active character to ^2' .. data.firstname .. ' ' .. data.lastname } })
					else
						TriggerClientEvent('chat:addMessage', source, { args = { '^1[IDENTITY]', 'Failed to update your identity, try again later or contact the server admin!' } })
					end
				end)
			else
				TriggerClientEvent('chat:addMessage', source, { args = { '^1[IDENTITY]', 'You don\'t have a character in slot 1!' } })
			end
		elseif charNumber == 2 then

			local data = {
				identifier	= data.identifier,
				firstname	= data.firstname2,
				lastname	= data.lastname2,
				dateofbirth	= data.dateofbirth2,
				sex			= data.sex2,
				height		= data.height2
			}

			if data.firstname ~= '' then
				updateIdentity(source, data, function(callback)

					if callback then
						TriggerClientEvent('chat:addMessage', source, { args = { '^1[IDENTITY]', 'Updated your active character to ^2' .. data.firstname .. ' ' .. data.lastname } })
					else
						TriggerClientEvent('chat:addMessage', source, { args = { '^1[IDENTITY]', 'Failed to update your identity, try again later or contact the server admin!' } })
					end
				end)
			else
				TriggerClientEvent('chat:addMessage', source, { args = { '^1[IDENTITY]', 'You don\'t have a character in slot 2!' } })
			end
		elseif charNumber == 3 then

			local data = {
				identifier	= data.identifier,
				firstname	= data.firstname3,
				lastname	= data.lastname3,
				dateofbirth	= data.dateofbirth3,
				sex			= data.sex3,
				height		= data.height3
			}

			if data.firstname ~= '' then
				updateIdentity(source, data, function(callback)
					if callback then
						TriggerClientEvent('chat:addMessage', source, { args = { '^1[IDENTITY]', 'Updated your active character to ^2' .. data.firstname .. ' ' .. data.lastname } })
					else
						TriggerClientEvent('chat:addMessage', source, { args = { '^1[IDENTITY]', 'Failed to update your identity, try again later or contact the server admin!' } })
					end
				end)
			else
				TriggerClientEvent('chat:addMessage', source, { args = { '^1[IDENTITY]', 'You don\'t have a character in slot 3!' } })
			end
		else
			TriggerClientEvent('chat:addMessage', source, { args = { '^1[IDENTITY]', 'Failed to update your identity, try again later or contact the server admin!' } })
		end

	end)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient permissions!' } })
end, {help = "Switch between character", params = {{name = "char", help = "the character id, ranges from 1-3"}}})

TriggerEvent('es:addGroupCommand', 'chardel', 'user', function(source, args, user)
	local charNumber = tonumber(args[1])

	if charNumber == nil or charNumber > 3 or charNumber < 1 then
		TriggerClientEvent('chat:addMessage', source, { args = { '^[IDENTITY]', 'That\'s an invalid character!' } })
		return
	end

	getCharacters(source, function(data)

		if charNumber == 1 then

			local data = {
				identifier	= data.identifier,
				firstname	= data.firstname1,
				lastname	= data.lastname1,
				dateofbirth	= data.dateofbirth1,
				sex			= data.sex1,
				height		= data.height1
			}

			if data.firstname ~= '' then
				deleteIdentity(source, data, function(callback)
					if callback then
						TriggerClientEvent('chat:addMessage', source, { args = { '^1[IDENTITY]', 'You have deleted ^1' .. data.firstname .. ' ' .. data.lastname } })
					else
						TriggerClientEvent('chat:addMessage', source, { args = { '^1[IDENTITY]', 'Failed to delete the character, try again later or contact the server admin!' } })
					end
				end)
			else
				TriggerClientEvent('chat:addMessage', source, { args = { '^1[IDENTITY]', 'You don\'t have a character in slot 1!' } })
			end

		elseif charNumber == 2 then

			local data = {
				identifier	= data.identifier,
				firstname	= data.firstname2,
				lastname	= data.lastname2,
				dateofbirth	= data.dateofbirth2,
				sex 		= data.sex2,
				height		= data.height2
			}

			if data.firstname ~= '' then
				deleteIdentity(source, data, function(callback)
					if callback then
						TriggerClientEvent('chat:addMessage', source, { args = { '^1[IDENTITY]', 'You have deleted ^1' .. data.firstname .. ' ' .. data.lastname } })
					else
						TriggerClientEvent('chat:addMessage', source, { args = { '^1[IDENTITY]', 'Failed to delete the character, try again later or contact the server admin!' } })
					end
				end)
			else
				TriggerClientEvent('chat:addMessage', source, { args = { '^1[IDENTITY]', 'You don\'t have a character in slot 2!' } })
			end

		elseif charNumber == 3 then

			local data = {
				identifier	= data.identifier,
				firstname	= data.firstname3,
				lastname	= data.lastname3,
				dateofbirth	= data.dateofbirth3,
				sex			= data.sex3,
				height		= data.height3
			}

			if data.firstname ~= '' then
				deleteIdentity(source, data, function(callback)
					if callback then
						TriggerClientEvent('chat:addMessage', source, { args = { '^1[IDENTITY]', 'You have deleted ^1' .. data.firstname .. ' ' .. data.lastname } })
					else
						TriggerClientEvent('chat:addMessage', source, { args = { '^1[IDENTITY]', 'Failed to delete the character, try again later or contact the server admin!' } })
					end
				end)
			else
				TriggerClientEvent('chat:addMessage', source, { args = { '^1[IDENTITY]', 'You don\'t have a character in slot 3!' } })
			end
		else
			TriggerClientEvent('chat:addMessage', source, { args = { '^1[IDENTITY]', 'Failed to delete the character, try again!' } })
		end
	end)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient permissions!' } })
end, {help = "Delete a registered character", params = {{name = "char", help = "the character id, ranges from 1-3"}}})
]]--
