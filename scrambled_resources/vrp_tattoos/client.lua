vRPts = {}
Tunnel.bindInterface("vrp_tattoos",vRPts)
TSserver = Tunnel.getInterface("vrp_tattoos","vrp_tattoos")

function vRPts.cleanPlayer()
	ClearPedDecorations(GetPlayerPed(-1))
	PlaySoundFrontend(-1, "Tattooing_Oneshot_Remove", "TATTOOIST_SOUNDS", 1)
end

function vRPts.drawTattoo(tattoo,tattooshop)
	SetPedDecoration(GetPlayerPed(-1), GetHashKey(tattooshop), GetHashKey(tattoo))
	PlaySoundFrontend(-1, "Tattooing_Oneshot", "TATTOOIST_SOUNDS", 1)
end
