-- this module define the emotes menu

local cfg = module("cfg/emotes")
local lang = vRP.lang

local emotes = cfg.emotes
local chatEmotes = cfg.chatEmotes

local emote_cooldown = 10 --seconds
local cooldown_list = {}

local function ch_emote(player,choice)
	local emote = emotes[choice] or chatEmotes[choice]
	local user_id = vRP.getUserId(player)
	if emote then
		vRPclient.getActionLock(player, {},function(locked)
			if not locked then
				if cooldown_list[user_id] == nil or tonumber(os.time())-cooldown_list[user_id] >= emote_cooldown then
					vRPclient.playAnim(player,{emote[1],emote[2],emote[3]})
					cooldown_list[user_id] = os.time()
				else
					vRPclient.notify(player,{"You can not use another emote so soon."})
				end
			end
		end)
	end
end

-- add emotes menu to main menu

vRP.registerMenuBuilder("main", function(add, data)
	local choices = {}
	choices[lang.emotes.title()] = {function(player, choice)
		-- build emotes menu
		local menu = {name=lang.emotes.title(),css={top="75px",header_color="rgba(0,125,255,0.75)"}}
		local user_id = vRP.getUserId(player)

		if user_id ~= nil then
			-- add emotes to the emote menu
			for k,v in pairs(emotes) do
				if vRP.hasPermissions(user_id, v.permissions or {}) then
					menu[k] = {ch_emote}
				end
			end
		end

		-- clear current emotes
		menu[lang.emotes.clear.title()] = {function(player,choice)
			vRPclient.getActionLock(player, {},function(locked)
				if not locked then
					vRPclient.stopAnim(player,{true}) -- upper
					vRPclient.stopAnim(player,{false}) -- full
				end
			end)
		end, lang.emotes.clear.description()}

		vRP.openMenu(player,menu)
	end,"Emote Menu",6}
	add(choices)
end)



-- Example of how to toggle weather. Added basic chat command.
AddEventHandler('chatMessage', function(from,name,message)
	if(string.sub(message,1,1) == "/") then

		local args = splitString(message)
		local cmd = args[1]

		if(cmd == "/em") or (cmd == "/emote")then
			CancelEvent()

			local emoteNic = string.lower(tostring(args[2]))
			if(emoteNic == nil)then
				TriggerClientEvent('sendPlayerMesage', -1, from, {
						template = '<div style="padding: 0.25vw; margin: 0.25vw; background-color: rgba(230, 0, 115, 0.6); border-radius: 3px;"><i class="fas fa-question-circle"></i> {0}</div>',
						args = { "Usage: /em list"}
				})
				return
			end
			if emoteNic == "list" then
				msg = "[beggar, bumslumped, bumstanding, bumwash, camera, cheer, clipboard, coffee, cop, crowdcontrol, dance, damn, diggit, drill, drink, film, flex, flipoff, gangsign1, gangsign2, grabcrotch, guard, hammer, handsup, hangout, hiker, hoe, hoe2, impatient, investigate, janitor, jog, leafblower, lean, kneel, mechanic, mobile, musician, no, notepad, parkingmeter, peacesign, party, plant, puffpuff, pushups, rock, salute, sit, sitchair, situps, statue, sunbath, sunbath2, tendtodead, titsqueeze, tourist, traffic, upyours, wank, washwindows, weld, yoga]"
				TriggerClientEvent('sendPlayerMesage', -1, from, {
						template = '<div style="padding: 0.25vw; margin: 0.25vw; background-color: rgba(230, 0, 115, 0.6); border-radius: 3px;"><i class="fas fa-question-circle"></i> {0}</div>',
						args = { msg}
				})
				return
			end
			local emote = chatEmotes[emoteNic]
			if emote then
				ch_emote(from,emoteNic)
			else
				TriggerClientEvent('sendPlayerMesage', -1, from, {
						template = '<div style="padding: 0.25vw; margin: 0.25vw; background-color: rgba(230, 0, 115, 0.6); border-radius: 3px;"><i class="fas fa-question-circle"></i> {0}</div>',
						args = { "Emote not found. Usage: /em list"}
				})
			end
		end
	end
end)
