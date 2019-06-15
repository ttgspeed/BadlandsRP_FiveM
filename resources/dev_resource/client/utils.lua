-- https://gist.github.com/IllidanS4/9865ed17f60576425369fc1da70259b2
--[[The MIT License (MIT)

Copyright (c) 2017 IllidanS4

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
]]

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

--[[Usage:
for ped in EnumeratePeds() do
  <do something with 'ped'>
end
]]

function DrawCrosshair(r, g, b, a)
  local resX, resY = GetActiveScreenResolution()
  local lineW, lineH = 4, 16

  local scaleXW = lineW / resX
  local scaleYW = lineH / resY
  local scaleXH = lineH / resX
  local scaleYH = lineW / resY

  DrawRect(0.5, 0.5 - scaleYW, scaleXW, scaleYW, 255, 255, 255, a)
  DrawRect(0.5, 0.5 + scaleYW, scaleXW, scaleYW, 255, 255, 255, a)

  DrawRect(0.5 - scaleXH, 0.5, scaleXH, scaleYH, 255, 255, 255, a)
  DrawRect(0.5 + scaleXH, 0.5, scaleXH, scaleYH, 255, 255, 255, a)

  DrawRect(0.5, 0.5, scaleXW, scaleYH, r, g, b, a)
end

--------------------------------------------------------------------------------

function DrawEntityAxis(entity, length)
  local center = GetEntityCoords(entity)

  local offX = vector3(length, 0, 0)
  local offY = vector3(0, length, 0)
  local offZ = vector3(0, 0, length)

  local posX = GetOffsetFromEntityInWorldCoords(entity, offX)
  local posY = GetOffsetFromEntityInWorldCoords(entity, offY)
  local posZ = GetOffsetFromEntityInWorldCoords(entity, offZ)

  DrawLine(center, posX, 255, 0, 0, 255)
  DrawLine(center, posY, 0, 255, 0, 255)
  DrawLine(center, posZ, 0, 0, 255, 255)
end

--------------------------------------------------------------------------------

function DrawEdgeMatrix(lines, r, g, b, a)
  for line in values(lines) do
    local x1, y1, z1 = table.unpack(line[1])
    local x2, y2, z2 = table.unpack(line[2])

    DrawLine(x1, y1, z1, x2, y2, z2, r, g, b, a)
  end
end

function DrawPolyMatrix(polies, r, g, b, a)
  for poly in values(polies) do
    local x1, y1, z1 = table.unpack(poly[1])
    local x2, y2, z2 = table.unpack(poly[2])
    local x3, y3, z3 = table.unpack(poly[3])

    DrawPoly(x1, y1, z1, x2, y2, z2, x3, y3, z3, r, g, b, a)
  end
end

function DrawBoundingBox(box, r, g, b, a)
  local polyMatrix = GetBoundingBoxPolyMatrix(box)
  local edgeMatrix = GetBoundingBoxEdgeMatrix(box)

  DrawPolyMatrix(polyMatrix,   r,   g,   b,   a)
  DrawEdgeMatrix(edgeMatrix, 255, 255, 255, 255)
end

function DrawVirtualBoundingBox(pos, r, g, b, a)
  local p1 = pos - 0.25
  local p2 = pos + 0.25

  local box = GetBoundingBox(p1, p2)
  return DrawBoundingBox(box, r, g, b, a)
end

function DrawEntityBoundingBox(entity, r, g, b, a)
  local box = GetEntityBoundingBox(entity)
  return DrawBoundingBox(box, r, g, b, a)
end

--------------------------------------------------------------------------------

function DrawDebugText(x, y, text)
  SetTextFont(0)
  SetTextProportional(0)
  SetTextScale(0.5, 0.5)
  SetTextColour(255, 255, 255, 255)
  SetTextDropShadow(0, 0, 0, 0, 255)
  SetTextEdge(1, 0, 0, 0, 255)
  SetTextDropShadow()
  SetTextOutline()
  SetTextEntry('STRING')
  AddTextComponentString(text)
  DrawText(x, y)
end

function ApplyEntityPosition(entity, posX, posY, posZ, relativeToWorld)
  if posX == 0.0 and posY == 0.0 and posZ == 0.0 then
    return
  end

  local offset = vector3(posX, posY, posZ)

  if relativeToWorld then
    local position = GetEntityCoords(entity) + offset
    SetEntityCoordsNoOffset(entity, position)
  else
    local position = GetOffsetFromEntityInWorldCoords(entity, offset)
    SetEntityCoordsNoOffset(entity, position)
  end
end

function ApplyEntityRotation(entity, rotX, rotY, rotZ, relativeToWorld)
  if rotX == 0.0 and rotY == 0.0 and rotZ == 0.0 then
    return
  end

  local qx, qy, qz, qw = GetEntityQuaternion(entity)
  local inQuat = quat(qw, qx, qy, qz)

  local vecX = vector3(1, 0, 0)
  local vecY = vector3(0, 1, 0)
  local vecZ = vector3(0, 0, 1)

  if relativeToWorld then
    inQuat = quat(rotX, vecX) * inQuat
    inQuat = quat(rotY, vecY) * inQuat
    inQuat = quat(rotZ, vecZ) * inQuat
  else
    inQuat = inQuat * quat(rotX, vecX)
    inQuat = inQuat * quat(rotY, vecY)
    inQuat = inQuat * quat(rotZ, vecZ)
  end

  -- Unfortunately, setting a quaternion seems to be broken in GTAV at certain
  -- angles. But fortunately (and perhaps, surprisingly), converting the
  -- quaternion to euler angles works fine.
  -- Problem with quaternions: https://streamable.com/ujpdg
  local rot = QuaternionToEuler(inQuat.w, inQuat.x, inQuat.y, inQuat.z)
  SetEntityRotation(entity, rot)
end

function GetBoundingBox(min, max, pad)
  local pad = pad or 0.001

  return {
    -- Bottom
    vector3(min.x - pad, min.y - pad, min.z - pad), -- back right
    vector3(max.x + pad, min.y - pad, min.z - pad), -- back left
    vector3(max.x + pad, max.y + pad, min.z - pad), -- front left
    vector3(min.x - pad, max.y + pad, min.z - pad), -- front right

    -- Top
    vector3(min.x - pad, min.y - pad, max.z + pad), -- back right
    vector3(max.x + pad, min.y - pad, max.z + pad), -- back left
    vector3(max.x + pad, max.y + pad, max.z + pad), -- front left
    vector3(min.x - pad, max.y + pad, max.z + pad), -- front right
  }
end

function GetBoundingBoxEdgeMatrix(box)
  return {
    -- Bottom
    { box[1], box[2] },
    { box[2], box[3] },
    { box[3], box[4] },
    { box[4], box[1] },

    -- Top
    { box[5], box[6] },
    { box[6], box[7] },
    { box[7], box[8] },
    { box[8], box[5] },

    -- Sides
    { box[1], box[5] },
    { box[2], box[6] },
    { box[3], box[7] },
    { box[4], box[8] },
  }
end

function GetBoundingBoxPolyMatrix(box)
  return {
    -- Bottom
    { box[3], box[2], box[1] },
    { box[4], box[3], box[1] },

    -- Top
    { box[5], box[6], box[7] },
    { box[5], box[7], box[8] },

    -- Front
    { box[3], box[4], box[7] },
    { box[8], box[7], box[4] },

    -- Back
    { box[1], box[2], box[5] },
    { box[6], box[5], box[2] },

    -- Left
    { box[2], box[3], box[6] },
    { box[3], box[7], box[6] },

    -- Right
    { box[5], box[8], box[4] },
    { box[5], box[4], box[1] },
  }
end

function GetModelBoundingBox(model)
  local min, max = GetModelDimensions(model)
  return GetBoundingBox(min, max)
end

function GetEntityBoundingBox(entity)
  local model = GetEntityModel(entity)
  local box = GetModelBoundingBox(model)

  return map(box, function (corner)
    return GetOffsetFromEntityInWorldCoords(entity, corner)
  end)
end

--------------------------------------------------------------------------------

function Clamp(x, min, max)
  return math.min(math.max(x, min), max)
end

function SnapAngle(angle, snap)
  return math.floor(angle / 360 * snap + 0.5) % snap * (360 / snap)
end

function EulerToQuaternion(rotX, rotY, rotZ)
  local radX = math.rad(rotX) * 0.5
  local radY = math.rad(rotY) * 0.5
  local radZ = math.rad(rotZ) * 0.5

  local cosX = math.cos(radX)
  local sinX = math.sin(radX)
  local cosY = math.cos(radY)
  local sinY = math.sin(radY)
  local cosZ = math.cos(radZ)
  local sinZ = math.sin(radZ)

  local w = cosZ * cosX * cosY + sinZ * sinX * sinY
  local x = cosZ * sinX * cosY - sinZ * cosX * sinY
  local y = cosZ * cosX * sinY + sinZ * sinX * cosY
  local z = sinZ * cosX * cosY - cosZ * sinX * sinY

  return quat(w, x, y, z);
end

function QuaternionToEuler(w, x, y, z)
  local sinX = 2.0 * (w * x + y * z)
  local cosX = 1.0 - 2.0 * (x * x + y * y)
  local rotX = math.deg(math.atan(sinX, cosX))

  local sinY = 2.0 * (w * y - z * x)
  local fixY = Clamp(sinY, -1.0, 1.0)
  local rotY = math.deg(math.asin(fixY))

  local sinZ = 2.0 * (w * z + x * y)
  local cosZ = 1.0 - 2.0 * (y * y + z * z)
  local rotZ = math.deg(math.atan(sinZ, cosZ))

  return vector3(rotX, rotY, rotZ)
end

--------------------------------------------------------------------------------

function GetVisibleEntities()
  local entities = {}
  local iterators = {
    EnumerateObjects,
    EnumeratePeds,
    EnumerateVehicles,
    EnumeratePickups
  }

  for Enumerate in values(iterators) do
    for entity in Enumerate() do
      table.insert(entities, entity)
    end
  end

  return entities
end

function IsEntityModelBlacklisted(entity)
  local model = GetEntityModel(entity)
  local blacklist = {
     -- https://i.gyazo.com/099abb816415bda4e1c6bf99c58ac3a2.jpg
    [GetHashKey('prop_sprink_park_01')] = true
  }

  return blacklist[model] or false
end

function CanEntityReturnModel(entity)
  return
    IsEntityAnObject(entity) or
    IsEntityAVehicle(entity) or
    IsEntityAPed(entity) or
    DoesEntityHaveDrawable(entity)
end

function IsEntityTargetable(entity)
  return
    CanEntityReturnModel(entity) and
    not IsEntityModelBlacklisted(entity)
end

function GetDisabledControlNormalBetween(inputGroup, control1, control2)
  local normal1 = math.abs(GetDisabledControlNormal(inputGroup, control1))
  local normal2 = math.abs(GetDisabledControlNormal(inputGroup, control2))
  return normal1 - normal2
end

function DoesLineIntersectAABB(p1, p2, min, max)
  if p1.x > min.x and p1.x < max.x and
     p1.y > min.y and p1.y < max.y and
     p1.z > min.z and p1.z < max.z then
    return false
  end

  for a in values({ 'x', 'y', 'z' }) do
    if (p1[a] < min[a] and p2[a] < min[a]) or
       (p1[a] > max[a] and p2[a] > max[a]) then
      return false
    end
  end

  for p in values({ min, max }) do
    for a, o in pairs({ x={'y','z'}, y={'x','z'}, z={'x','y'} }) do
      local h = p1 + (p1[a] - p[a]) / (p1[a] - p2[a]) * (p2 - p1)
      local o1, o2 = o[1], o[2]

      if h[o1] >= min[o1] and h[o1] <= max[o1] and
         h[o2] >= min[o2] and h[o2] <= max[o2] then
        return true
      end
    end
  end

  return false
end

function DoesLineIntersectEntityBoundingBox(p1, p2, entity)
  local model = GetEntityModel(entity)
  local min, max = GetModelDimensions(model)

  local l1 = GetOffsetFromEntityGivenWorldCoords(entity, p1)
  local l2 = GetOffsetFromEntityGivenWorldCoords(entity, p2)

  return DoesLineIntersectAABB(l1, l2, min, max)
end

--------------------------------------------------------------------------------

function RaytraceBoundingBox(p1, p2, ignoredEntity)
  local entities = GetVisibleEntities()
  local matches = filter(entities, function (entity)
    if entity == ignoredEntity then return false end
    if not IsEntityOnScreen(entity) then return false end
    if not IsEntityTargetable(entity) then return false end
    return DoesLineIntersectEntityBoundingBox(p1, p2, entity)
  end)

  table.sort(matches, function (a, b)
    local h1 = GetEntityCoords(a)
    local h2 = GetEntityCoords(b)
    return #(p1 - h1) < #(p1 - h2)
  end)

  if matches[1] then
    local pos = GetEntityCoords(matches[1])
    return pos, matches[1]
  end

  return nil, nil
end

function RaytraceShapeTest(p1, p2, ignoredEntity)
  local flags = 1 | 2 | 4 | 16 | 256
  local ray = StartShapeTestRay(p1, p2, flags, ignoredEntity, 7)
  local result, hit, pos, normal, entity = GetShapeTestResult(ray)

  if hit == 0 then
    return nil, nil
  end

  if not IsEntityTargetable(entity) then
    return pos, nil
  end

  return pos, entity
end

function Raytrace(p1, p2, ignoredEntity, checkBoundingBox, checkWater)
  if checkWater then
    local hit, pos = TestProbeAgainstWater(p1, p2)
    if hit then
      p2 = pos
    end
  end

  if checkBoundingBox then
    local pos1, entity1 = RaytraceShapeTest(p1, p2, ignoredEntity)
    local pos2, entity2 = RaytraceBoundingBox(p1, p2, ignoredEntity)

    if pos1 and not pos2 then return pos1, entity1 end
    if pos2 and not pos1 then return pos2, entity2 end
    if pos1 and pos2 then
      if #(p1 - pos1) < #(p1 - pos2) then
        return pos1, entity1
      else
        return pos2, entity2
      end
    end

    return p2, nil
  end

  local pos, entity = RaytraceShapeTest(p1, p2, ignoredEntity)
  return pos or p2, entity
end

function values(xs)
  local i = 0
  return function()
    i = i + 1;
    return xs[i]
  end
end

function map(xs, fn)
  local t = {}
  for i,v in ipairs(xs) do
    local r = fn(v, i, xs)
    table.insert(t, r)
  end
  return t
end

function filter(xs, fn)
  local t = {}
  for i,v in ipairs(xs) do
    if fn(v, i, xs) then
      table.insert(t, v)
    end
  end
  return t
end

local _TestProbeAgainstWater = TestProbeAgainstWater
function TestProbeAgainstWater(p1, p2)
  return _TestProbeAgainstWater(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z)
end
