local medic = false

function tvRP.setMedic(flag)
  medic = flag
  if medic then
  	vRPserver.addPlayerToActiveEMS({})
  else
    -- Remove medic weapons when going off duty
    RemoveWeaponFromPed(GetPlayerPed(-1),0x497FACC3) -- WEAPON_FLARE
    RemoveWeaponFromPed(GetPlayerPed(-1),0xCB13D282) -- WEAPON_FIREEXTINGUISHER
    vRPserver.removePlayerToActiveEMS({})
  end
end

function tvRP.isMedic()
	return medic
end
