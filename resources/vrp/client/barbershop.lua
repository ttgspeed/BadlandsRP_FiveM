local hair_color = nil
local hair_highlight = nil

function tvRP.setOverlay(custom,spawn)
  if custom then
    local ped = GetPlayerPed(-1)
    local hashMaleMPSkin = GetHashKey("mp_m_freemode_01")
    local hashFemaleMPSkin = GetHashKey("mp_f_freemode_01")
    if  custom["-1"][1] == 255 then
      if (GetEntityModel(ped) == hashMaleMPSkin) then
        custom["-1"] = {0,0,0}
      elseif (GetEntityModel(ped) == hashFemaleMPSkin) then
        custom["-1"] = {21,0,0}
      end
    end
    if spawn then
      SetPedHeadBlendData(ped,custom["-1"][1],custom["-1"][1],custom["-1"][1],custom["-1"][1],custom["-1"][2],custom["-1"][3],1.0,0.0,0.0,false)
    end
    -- parts
    for k,v in pairs(custom) do
      if tonumber(k) == 12 then
        SetPedComponentVariation(ped, 2, v[1], 0, 1)
        if hair_highlight ~= nil or (custom[13] ~= nil and custom[13][3] ~= nil) then
          if hair_highlight ~= nil then
            SetPedHairColor(ped, v[3], hair_highlight)
          else
            SetPedHairColor(ped, v[3], custom[13][3])
          end
        else
          SetPedHairColor(ped, v[3], v[3])
          hair_color = v[3]
        end
      elseif tonumber(k) == 13 then
        if hair_color ~= nil or (custom[12] ~= nil and custom[12][3] ~= nil) then
          if hair_color ~= nil then
            SetPedHairColor(ped, v[3], hair_color)
          else
            SetPedHairColor(ped, custom[12][3], v[3])
          end
        else
          SetPedHairColor(ped, v[3], v[3])
          hair_highlight = v[3]
        end
      elseif tonumber(k) == -1 then
        SetPedHeadBlendData(ped,v[1],v[1],v[1],v[1],v[2],v[3],1.0,0.0,0.0,false)
      else
        SetPedHeadOverlay(ped, tonumber(k), v[1], 1.0)
        SetPedHeadOverlayColor(ped, tonumber(k), v[2], v[3], v[3])
      end
    end
    vRPserver.updateOverlay({custom})
  end
end
-- SetPedHeadBlendData(GetPlayerPed(-1),12,12,12,12,0,2,1.0,0.0,0.0,false) -- Face {12,0,2}

function tvRP.getDrawablesBarber(part)
  if part == 12 then
    return tonumber(GetNumberOfPedDrawableVariations(GetPlayerPed(-1),2))
  elseif part == 13 then
    return 0
  elseif part == -1 then
    return tonumber(GetNumberOfPedDrawableVariations(GetPlayerPed(-1),0))
  else
    return tonumber(GetNumHeadOverlayValues(part))
  end
end

function tvRP.getTextures()
  return tonumber(GetNumHairColors())
end
