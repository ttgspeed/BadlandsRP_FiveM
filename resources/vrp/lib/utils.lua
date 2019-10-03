local modules = {}
function module(rsc, path) -- load a LUA resource file as module
  if path == nil then -- shortcut for vrp, can omit the resource parameter
    path = rsc
    rsc = "vrp"
  end

  local key = rsc..path

  if modules[key] then -- cached module
    return table.unpack(modules[key])
  else
    local f,err = load(LoadResourceFile(rsc, path..".lua"))
    if f then
      local ar = {pcall(f)}
      if ar[1] then
        table.remove(ar,1)
        modules[key] = ar
        return table.unpack(ar)
      else
        modules[key] = nil
        print("[vRP] error loading module "..rsc.."/"..path..":"..ar[2])
      end
    else
      print("[vRP] error parsing module "..rsc.."/"..path..":"..err)
    end
  end
end

-- generate a task metatable (helper to return delayed values with timeout)
--- dparams: default params in case of timeout or empty cbr()
--- timeout: milliseconds, default 5000
function Task(callback, dparams, timeout)
  if timeout == nil then timeout = 5000 end

  local r = {}
  r.done = false

  local finish = function(params)
    if not r.done then
      if params == nil then params = dparams or {} end
      r.done = true
      callback(table.unpack(params))
    end
  end

  setmetatable(r, {__call = function(t,params) finish(params) end })
  SetTimeout(timeout, function() finish(dparams) end)

  return r
end

function parseInt(v)
--  return cast(int,tonumber(v))
  local n = tonumber(v)
  if n == nil then
    return 0
  else
    return math.floor(n)
  end
end

function parseDouble(v)
--  return cast(double,tonumber(v))
  local n = tonumber(v)
  if n == nil then n = 0 end
  return n
end

function parseFloat(v)
  return parseDouble(v)
end

-- will remove chars not allowed/disabled by strchars
-- if allow_policy is true, will allow all strchars, if false, will allow everything except the strchars
local sanitize_tmp = {}
function sanitizeString(str, strchars, allow_policy)
  local r = ""

  -- get/prepare index table
  local chars = sanitize_tmp[strchars]
  if chars == nil then
    chars = {}
    local size = string.len(strchars)
    for i=1,size do
      local char = string.sub(strchars,i,i)
      chars[char] = true
    end

    sanitize_tmp[strchars] = chars
  end

  -- sanitize
  size = string.len(str)
  for i=1,size do
    local char = string.sub(str,i,i)
    if (allow_policy and chars[char]) or (not allow_policy and not chars[char]) then
      r = r..char
    end
  end

  return r
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

function joinStrings(list, sep)
  if sep == nil then sep = "" end

  local str = ""
  local count = 0
  local size = #list
  for k,v in pairs(list) do
    count = count+1
    str = str..v
    if count < size then str = str..sep end
  end

  return str
end

function GetClosestPed(radius)
    local closestPed = 0

    for ped in EnumeratePeds() do
        local distanceCheck = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(ped), true)
        if distanceCheck <= radius+.000001 and ped ~= GetPlayerPed(-1) then
            closestPed = ped
            break
        end
    end

    return closestPed
end

function GetClosestVehicle(radius)
    local closestVeh = 0

    for veh in EnumerateVehicles() do
        local distanceCheck = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(veh), true)
        if distanceCheck <= radius+.000001 then
            closestVeh = veh
            break
        end
    end

    return closestVeh
end

function GetClosestParkedVehicles(radius, maxQty)
	local closestVehicles = {}
	local count = 0
	for veh in EnumerateVehicles() do
		local distanceCheck = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(veh), true)
		local popType = GetEntityPopulationType(veh)
		if distanceCheck <= radius+.000001 and popType == 2 then
			count = count + 1
			table.insert(closestVehicles, veh)
		end
		if count == maxQty then
			break
		end
	end
	return closestVehicles
end

local entityEnumerator = {
  __gc = function(enum)
    if enum.destructor and enum.handle then
      enum.destructor(enum.handle)
    end
    enum.destructor = nil
    enum.handle = nil
  end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
  return coroutine.wrap(function()
    local iter, id = initFunc()
    if not id or id == 0 then
      disposeFunc(iter)
      return
    end

    local enum = {handle = iter, destructor = disposeFunc}
    setmetatable(enum, entityEnumerator)

    local next = true
    repeat
      coroutine.yield(id)
      next, id = moveFunc(iter)
    until not next

    enum.destructor, enum.handle = nil, nil
    disposeFunc(iter)
  end)
end

function EnumerateObjects()
  return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function EnumeratePeds()
  return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
  return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumeratePickups()
  return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end
