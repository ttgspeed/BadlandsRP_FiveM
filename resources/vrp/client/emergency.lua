local medic = false

function tvRP.setMedic(flag)
  medic = flag
  if not medic then
    -- Remove medic weapons when going off duty
    RemoveWeaponFromPed(GetPlayerPed(-1),0x497FACC3) -- WEAPON_FLARE
	RemoveWeaponFromPed(GetPlayerPed(-1),0xCB13D282) -- WEAPON_FIREEXTINGUISHER
  end
end

function tvRP.isMedic()
	return medic
end
