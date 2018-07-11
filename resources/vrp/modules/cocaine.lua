local Log = module("lib/Log")

function tvRP.hasCocaPasteIngredients()
	local task = TUNNEL_DELAYED()
	local user_id = vRP.getUserId(source)
	if vRP.getInventoryItemAmount(user_id,"cement") > 0 and vRP.getInventoryItemAmount(user_id,"coca_leaves") > 0 then
		task({true})
	end
	task({false})
end

function tvRP.mixCocaPasteIngredients()
	local user_id = vRP.getUserId(source)
	local player = vRP.getUserSource(user_id)
	if vRP.tryGetInventoryItem(user_id,"cement",1,false) and vRP.tryGetInventoryItem(user_id,"coca_leaves",1,false) then
		vRP.giveInventoryItem(user_id,"coca_paste",1,true)
	end
end

function tvRP.hasCocaPaste()
	local task = TUNNEL_DELAYED()
	local user_id = vRP.getUserId(source)
	local player = vRP.getUserSource(user_id)
	if vRP.tryGetInventoryItem(user_id,"coca_paste",1,false) then
		task({true})
	end
end

function tvRP.giveCocaine(quality,quantity)
	local user_id = vRP.getUserId(source)
	vRP.giveInventoryItem(user_id,quality,quantity)
end
