local keys = {}

function tvRP.giveKey(vehicleName, vehiclePlate)
  if vehicleName ~= nil and vehiclePlate ~= nil then
    table.insert(keys, {name = string.lower(vehicleName), plate = string.lower(vehiclePlate)})
    tvRP.notify("You received keys to a "..vehicleName.." with plate "..vehiclePlate)
  end
end

function tvRP.hasKey(vehicleName, vehiclePlate)
  if vehicleName ~= nil and vehiclePlate ~= nil then
    if #keys > 0 then
      for i=1,#keys do
        if keys[i].name == string.lower(vehicleName) and keys[i].plate == string.lower(vehiclePlate) then
          return true
        end
      end
    end
  end
  return false
end

function tvRP.clearKeys()
  keys = {}
end
