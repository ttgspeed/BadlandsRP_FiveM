allZone = {}
ceiledAllTables = {}
actualUserZone = {}

AddEventHandler("onResourceStart", function(resource)
	if resource == "iZone" then
		exports['GHMattiMySQL']:QueryResultAsync("SELECT name,coords,gravityCenter,longestDistance FROM zones",{},function(rows)
			if #rows > 0 then  -- found
				for i = 1, #rows do
					table.insert(allZone,
						{name = rows[i].name,
						coords = json.decode(rows[i].coords),
						gravityCenter = json.decode(rows[i].gravityCenter),
						longestDistance = rows[i].longestDistance}
					)
				end
				TriggerClientEvent("izone:transfertzones", -1, allZone)
			end
		end)
	end
end)

AddEventHandler("vRP:playerSpawn",function(user_id, source, first_spawn)
	if first_spawn then
		TriggerClientEvent("izone:transfertzones", source, allZone)
	end
end)

RegisterServerEvent("givemezone")
AddEventHandler('givemezone', function()
	TriggerClientEvent("izone:transfertzones", source, allZone)
end)

local commands_enabled = false

if commands_enabled then
	AddEventHandler('chatMessage', function(from,name,message)
	  if(string.sub(message,1,1) == "/") then

	    local args = splitString(message)
	    local cmd = args[1]

	    if (cmd == "/start") then
	      	CancelEvent()
	      	TriggerClientEvent("izone:notification", from, "Tu peux ajouter des points avec la touche [L], /mazone stop pour finir", true)
			TriggerClientEvent("izone:okforpoint", from)
			actualUserZone = {}
	    elseif cmd == "/stop" then
	    	CancelEvent()
	    	points = actualUserZone
			if points == nil then
				TriggerClientEvent("izone:notification", from, "Tu as stoppé l'ajout de point mais tu n'avais pas enregistré de points ou initialisé avec /mazone start", false)
				actualUserZone = {}
			else
				TriggerClientEvent("izone:notification", from, "Ton/Tes points sont sauvegardé avec le nom que tu vas entrer.", true)
				TriggerClientEvent("izone:askforname", from)
			end
		elseif cmd == "/tptc" then
			if #args == 4 then
				TriggerClientEvent("izone:notification", source, "TP ok", true)
				TriggerClientEvent("izone:tptc", source, tonumber(args[2]), tonumber(args[3]), tonumber(args[4]))
			else
				TriggerClientEvent("izone:notification", source, "3 arguments necessaires", false)
			end
	    end
	  end
	end)
end

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

TriggerEvent('es:addCommand', 'tptc', function(source, args, user)
	if user.permission_level <= 3 then
		TriggerClientEvent("izone:notification", source, "Tu n'as pas la permision de faire cela", false)
		CancelEvent()
	else
		if #args == 4 then
			TriggerClientEvent("izone:notification", source, "TP ok", true)
			TriggerClientEvent("izone:tptc", source, tonumber(args[2]), tonumber(args[3]), tonumber(args[4]))
		else
			TriggerClientEvent("izone:notification", source, "3 arguments necessaires", false)
		end

	end
end)

RegisterServerEvent("izone:addpoint")
AddEventHandler("izone:addpoint", function(xs, ys, zs)
	local zone = {x = xs, y = ys, z = zs}
	--local actualUserZone = user:getSessionVar("zone")
	table.insert(actualUserZone, zone)
	--user:setSessionVar("zone", actualUserZone)
end)

RegisterServerEvent("izone:savedb")
AddEventHandler("izone:savedb", function(name)
	local userPoints = actualUserZone
	---------------- PARTIE CENTRE DE GRAVITE -------------------------
	local xr, yr = CalculGravityCenter(actualUserZone)
	local resultArray = { x = math.ceil(xr*100)/100, y = math.ceil(yr*100)/100}
	local resultArrayEncoded = json.encode(resultArray)
	--------------------------------------------------------------------
	---------------- RECHERCHE DE LA PLUS LONGUE DISTANCE --------------
	local maxDist = CalculLongest(resultArray, actualUserZone)
	local maxDistCeiled = math.ceil((maxDist*100)/100) + 0.01
	--------------------------------------------------------------------
	local namet = name
	---------------- ADOUCISSEMENT DES VALEURS -------------------------
	local ceiledMaxDist = (math.ceil(maxDist*100)/100) + 0.01 -- +0.01 to prevent the almost InZone
	local ceiledUserPoints = TableCut(actualUserZone, 100)
	--------------------------------------------------------------------

	---------------- Json Encode pour le mettre dans la db--------------
	local encodedCeiledUserPoints = json.encode(ceiledUserPoints)
	--------------------------------------------------------------------
	exports['GHMattiMySQL']:QueryAsync("INSERT INTO zones (`name`, `coords`, `gravityCenter`, `longestDistance`) VALUES (@name, @coords, @gravityCenter, @longestDistance)",
		{['@name'] = namet, ['@coords'] = encodedCeiledUserPoints, ['@gravityCenter'] = resultArrayEncoded, ['@longestDistance'] = maxDistCeiled}, function(rowsChanged)
	end)
end)

RegisterServerEvent("izone:debug")
AddEventHandler("izone:debug", function()
	TriggerClientEvent("izone:senddebug", source, allZone)
end)
function PrintArray(table)
	for k,v in pairs(table) do print(k,v) end
end

function CalculGravityCenter(table)
	local allX = 0
	local allY = 0
	for i=1, #table do
		allX = allX + tonumber(table[i].x)
		allY = allY + tonumber(table[i].y)
	end
	local resultX = allX / #table
	local resultY = allY / #table
	return resultX, resultY
end

function CalculLongest(center, zone)
	local listDist = { }
	for i=1, #zone do
		table.insert(listDist, DistanceFrom(tonumber(center.x), tonumber(center.y), tonumber(zone[i].x), tonumber(zone[i].y)))
	end
	return MaximumNumber(listDist)
end

function MaximumNumber(table)
	local max = 0
	for i=1, #table do
		if table[i] > max then max = table[i] end
	end
	return max
end

function DistanceFrom(x1,y1,x2,y2)
	return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

function TableCut(tabler, precision) -- 100 precision will means 0.01 (1/100)
	local newTable = {}

	for i=1, #tabler do
	table.insert(newTable, {
				x = math.ceil(tonumber(tabler[i].x)*precision)/precision,
				y = math.ceil(tonumber(tabler[i].y)*precision)/precision,
				z = math.ceil(tonumber(tabler[i].z)*precision)/precision
				})
	end
	return newTable
end
