local lang = vRP.lang
local Log = module("lib/Log")

function vRP.getCharacterById(user_id, char_id, cbr)
    local task = Task(cbr)
	MySQL.Async.fetchAll('SELECT * FROM characters WHERE id = @id and identifier = @user_id', {id = char_id, user_id = user_id}, function(rows)
		task({rows[1]})
	end)
end

function vRP.deleteCharacterById(user_id, char_id)
	MySQL.Async.execute('DELETE FROM characters WHERE id = @id and identifier = @user_id', {id = char_id, user_id = user_id}, function(rowsChanged) end)
end

function vRP.selectCharacter(user_id, char_id)
    local user_id = user_id
    vRP.getCharacterById(user_id, char_id, function(character)
        if character ~= nil then
            MySQL.Async.execute("UPDATE `vrp_user_identities` SET `firstname` = @firstname, `name` = @lastname, `registration` = @registration, `phone` = @phone, `active_character` = @charNumber, `age` = @age WHERE user_id = @identifier",
            {
                ['@identifier']		= user_id,
                ['@firstname']		= character.firstname,
                ['@lastname']		= character.lastname,
                ['@registration']		= character.registration,
                ['@phone']		= character.phone,
                ['@charNumber']		= character.id,
                ['@age']		= character.dateofbirth,
            }, function(done)
                local sourcePlayer = vRP.getUserSource(user_id)
                if sourcePlayer ~= nil then
                    local tmp = vRP.getUserTmpTable(user_id)
                    tmp.spawns = 0
                    vRPclient.setRegistrationNumber(sourcePlayer,{character.registration})
                    vRPclient.configurePlayer(sourcePlayer,{character.id})
                    TriggerClientEvent('chat:playerInfo',sourcePlayer,user_id,""..character.firstname.." "..character.lastname)
                end
            end)
        end
    end)
end

RegisterServerEvent("vrp:getCharacters")
AddEventHandler("vrp:getCharacters", function()
    local user_id = vRP.getUserId(source)
	local player = source
	MySQL.Async.fetchAll('SELECT * FROM characters WHERE identifier = @user_id', {user_id = user_id}, function(rows)
		TriggerClientEvent('disclaimer:getCharacters_cb',player,json.encode(rows))
	end)
end)

RegisterServerEvent("vrp:updateIdentity")
AddEventHandler("vrp:updateIdentity", function(char_id)
	local sourcePlayer = tonumber(source)
	local user_id = vRP.getUserId(sourcePlayer)
    if char_id ~= nil then
        vRP.selectCharacter(user_id, char_id)
    end
end)

RegisterServerEvent("vrp:deleteChar")
AddEventHandler("vrp:deleteChar", function(char_id)
	local sourcePlayer = tonumber(source)
	local user_id = vRP.getUserId(sourcePlayer)
    if char_id ~= nil then
        vRP.deleteCharacterById(user_id, char_id)
    end
end)

RegisterServerEvent("vrp:createChar")
AddEventHandler("vrp:createChar", function(data)
	local sourcePlayer = tonumber(source)
	local user_id = vRP.getUserId(sourcePlayer)
    local data = data
	vRP.generateRegistrationNumber(function(registration)
		vRP.generatePhoneNumber(function(phone)
			MySQL.Async.execute(
			'INSERT INTO characters (identifier, firstname, lastname, dateofbirth, sex, height, registration, phone) VALUES (@identifier, @firstname, @lastname, @dateofbirth, @sex, @height, @registration, @phone)',
			{
				['@identifier']		= user_id,
				['@firstname']		= data.firstname,
				['@lastname']		= data.lastname,
				['@dateofbirth']	= data.dateofbirth,
				['@sex']			= data.sex,
				['@height']			= data.height,
				['@registration']	= registration,
				['@phone']			= phone
			}, function(changed)
                MySQL.Async.fetchAll('SELECT id FROM characters WHERE identifier = @user_id ORDER BY id DESC LIMIT 1', {user_id = user_id}, function(id)
                    vRP.selectCharacter(user_id, id[1].id)
            	end)
            end)
		end)
	end)
end)
