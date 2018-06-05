local plugin_data = {}
local vehicle_data = {}
local plates = {}

function get3DDistance(x1, y1, z1, x2, y2, z2)
	return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2) + math.pow(z1 - z2, 2))
end

local plates = {}
local plate_possibilities = {"Expired license",	"Stolen vehicle",	"Unregistered plate", "Warrant for owner"}

local carshops = {
	--{['x'] = 1696.66, ['y'] = 3607.99, ['z'] = 35.36},
	{['x'] = -796.17, ['y'] = 300.94, ['z'] = 85.70},
	{['x'] = -673.44, ['y'] = -2390.78, ['z'] = 13.89},
	{['x'] = -15.20, ['y'] = -1082.81, ['z'] = 26.67},
	{['x'] = -28.65, ['y'] = -1680.18, ['z'] = 29.45},
	--{['x'] = 1181.78, ['y'] = 2655.33, ['z'] = 37.82},
	{['x'] = -1212.95, ['y'] = -364.35, ['z'] = 37.28},
	{['x'] = -1080.71	, ['y'] = -1252.78, ['z'] = 5.41},
	{ ['x'] = 248.57885742188, ['y'] = -3062.1379394531, ['z'] = 5.7798938751221 },
	{ ['x'] = 348.42904663086, ['y'] = 350.54934692383, ['z'] = 105.10478210449 },
	{ ['x'] = -2173.6982421875, ['y'] = -411.58480834961, ['z'] = 13.279825210571 },
	{ ['x'] = 893.73767089844, ['y'] = -68.683937072754, ['z'] = 78.764297485352 },
	--{ ['x'] = -94.009635925293, ['y'] = 89.803314208984, ['z'] = 71.803337097168 },
	{ ['x'] = 2665.8696289063, ['y'] = 1671.4300537109, ['z'] = 24.487155914307 },
	{ ['x'] = 1983.103515625, ['y'] = 3773.9240722656, ['z'] = 32.180919647217 },
	--{ ['x'] = 124.32480621338, ['y'] = 6613.2944335938, ['z'] = 31.855966567993 },
	{ ['x'] = -242.36260986328, ['y'] = 6196.7661132813, ['z'] = 31.489208221436 },
	--{ ['x'] = 130.98764038086, ['y'] = 6369.3666992188, ['z'] = 31.297519683838 },
	{ ['x'] = 233.69268798828, ['y'] = -788.97814941406, ['z'] = 30.605836868286 },
	{ ['x'] = 1224.59680175781, ['y'] = 2719.73803710938, ['z'] = 38.0048179626465 },
	--{ ['x'] = -1115.3034667969, ['y'] = -2004.0853271484, ['z'] = 13.171050071716 },
	-- police and emergency
	{ ['x'] = 454.4, ['y'] = -1017.6, ['z'] = 28.4 },
	{ ['x'] = 1871.0380859375, ['y'] = 3692.90258789063, ['z'] = 33.5941047668457 },
	{ ['x'] = -1119.01953125, ['y'] = -858.455627441406, ['z'] = 13.5303745269775 },
	{ ['x'] = 1842.67443847656, ['y'] = 3666.43383789063, ['z'] = 33.7249450683594 },
	{ ['x'] = -492.08544921875, ['y'] = -336.749206542969, ['z'] = 34.3731842041016 }
}

local carshop_vehicles = {
	['dominator'] = 50000,
	['mule'] = 2000,
	['police2'] = 2000,
	['ninef'] = 250000,
	['ninef2'] = 300000,
	['prairie'] = 15000,
	['gauntlet'] = 55000,
	['voodoo2'] = 15000,
	['bfinjection'] = 25000,
	['rebel'] = 25000,
	['cognoscenti'] = 200000,
	['emperor'] = 18000,
	['ingot'] = 19000,
	['rancherxl'] = 20000,
	['alpha'] = 500000,
	['banshee'] = 300000,
	['blista2'] = 17000,
	['comet2'] = 200000,
	['elegy2'] = 150000,
	['schwarzer'] = 110000,
	['tornado2'] = 16000,
	['ztype'] = 6000000,
	['adder'] = 8000000,
	['fmj'] = 10000000,
	['baller3'] = 120000,
}

local spawned_vehicles = {}

TriggerEvent('d6926dd4-a51b-49c1-be31-0a6c82673277', 'deletevehicle', function(source, args, user)
	TriggerClientEvent('56dd05b4-1213-4d00-9291-cfcf6d80b458', source)
end)

function deletePlate(pl)
	plates[pl] = nil
end

AddEventHandler('playerDropped', function()
	spawned_vehicles[source] = nil
end)

local spawned_vehicles = {}

local limiter = {}

-- Util function stuff
function stringsplit(self, delimiter)
  local a = self:Split(delimiter)
  local t = {}

  for i = 0, #a - 1 do
     table.insert(t, a[i])
  end

  return t
end

local charset = {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","1","2","3","4","5","6","7","8","9"}

function generatePlate(length)
  if length > 0 then
    return generatePlate(length - 1) .. charset[math.random(1, #charset)]
  else
    return ""
  end
end
