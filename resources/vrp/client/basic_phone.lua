function tvRP.usePhoneEvent()
	tvRP.playAnim(false, {task="WORLD_HUMAN_STAND_MOBILE"}, false)
	SetTimeout(5 * 1000, function()
		tvRP.stopAnim(false)
	end)
end
