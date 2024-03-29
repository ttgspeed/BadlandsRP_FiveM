local cfg = module("vrp","cfg/emotes")

local emotes = cfg.emotes
local chatEmotes = cfg.chatEmotes

local walkStyles = {
	["toughm"] = "MOVE_M@TOUGH_GUY@",
	["toughf"] = "MOVE_F@TOUGH_GUY@",
	["poshm"] = "MOVE_M@POSH@",
	["poshf"] = "MOVE_F@POSH@",
	["gangsterm"] = "MOVE_M@GANGSTER@NG",
	["gangsterf"] = "MOVE_F@GANGSTER@NG",
	["femmem"] = "MOVE_M@FEMME@",
	["femmef"] = "MOVE_F@FEMME@",
	["jog"] = "move_m@JOG@",
	["fire"] = "move_m@fire",
	["casual"] = "move_m@casual@d",
	["brave"] = "move_m@brave",
	["sexy"] = "move_f@sexy@a",
	["scared"] = "move_f@scared",
	["flee"] = "move_f@flee@a",

	--["injuredf"] = "move_f@injured",
	--["injuredm"] = "move_m@injured",
	["maneater"] = "move_f@maneater",
	["depressedf"] = "move_f@depressed@a",
	["depressedm"] = "move_m@depressed@a",
	["businessf"] = "move_f@business@a",
	["businessm"] = "move_m@business@a",
	["arrogantf"] = "move_f@arrogant@a",
	["arrogantm"] = "move_m@arrogant@a",
	--[""] = "",

}

local validEmoteKeys = {
	"f1", "f2", "f3", "f5", "f6", "f7", "f9", "f10", "f11"
}

-- Example of how to toggle weather. Added basic chat command.
AddEventHandler('chatMessage', function(from,name,message)
	if(string.sub(message,1,1) == "/") then

		local args = splitString(message)
		local cmd = args[1]

		if(cmd == "/walk")then
			CancelEvent()

			local walkStyle = string.lower(tostring(args[2]))
			if(walkStyle == nil)then
				TriggerClientEvent('sendPlayerMesage', -1, from, {
						template = '<div class="chat-bubble" style="background-color: rgba(230, 0, 115, 0.6);"><i class="fas fa-question-circle"></i> {0}</div>',
						args = { "Usage: /walk list"}
				})
				return
			end
			if walkStyle == "list" then
				local first = true
				for k,v in pairs(walkStyles) do
					if first then
						first = false
						msg = "["..k
					else
						msg = msg..", "..k
					end
				end
				msg = msg.."]"
				TriggerClientEvent('sendPlayerMesage', -1, from, {
						template = '<div class="chat-bubble" style="background-color: rgba(230, 0, 115, 0.6);"><i class="fas fa-question-circle"></i> {0}</div>',
						args = { msg}
				})
				return
			end
			if walkStyle == "clear" then
				TriggerClientEvent('walkstyle',from,"clear")
				return
			end
			local style = walkStyles[walkStyle]
			if style then
				TriggerClientEvent('walkstyle',from,style)
			else
				TriggerClientEvent('sendPlayerMesage', -1, from, {
						template = '<div class="chat-bubble" style="background-color: rgba(230, 0, 115, 0.6);"><i class="fas fa-question-circle"></i> {0}</div>',
						args = { "Walk style not found. Usage: /walk list"}
				})
			end
		elseif cmd == "/cardoor" then
			CancelEvent()
			local action = string.lower(tostring(args[2]))
			local param = (tonumber(args[3]))
			if param ~= nil and action ~= nil then
				TriggerClientEvent("CustomScripts:ToggleDoor", from, action, param)
			end
		elseif cmd == "/carmod" then
			CancelEvent()
			local extra = (tonumber(args[2]))
			local toggle = (tonumber(args[3]))
			if extra ~= nil and toggle ~= nil then
				TriggerClientEvent("vRP:CarExtra", from, extra, toggle)
			end
		elseif cmd == "/carlivery" then
			CancelEvent()
			local value = (tonumber(args[2]))
			if value ~= nil then
				TriggerClientEvent("vRP:CarLivery", from, value)
			end
		elseif cmd == "/headgear" or cmd == "/hg" then
			CancelEvent()
			local value = (tonumber(args[2]))
			local texture = (tonumber(args[3]))
			if value ~= nil then
				TriggerClientEvent("vRP:setHeadGear", from, value, texture)
			end
		elseif cmd == "/race" then
			CancelEvent()
			local bet = (tonumber(args[2]))
			local random = (tonumber(args[3]))
			TriggerClientEvent("vRP:initiateRace", from, bet, random)
		elseif cmd == "/racequit" then
			CancelEvent()
			TriggerClientEvent("vRP:quitRace", from)
		elseif cmd == "/bars" then
			CancelEvent()
			TriggerClientEvent("CustomScripts:Immersion", from)
		elseif cmd == "/stethoscope" then
			CancelEvent()
			local color = (tonumber(args[2]))
			if color >= 0 or color <= 5 then
				TriggerClientEvent("vRP:ChangeStethoscopeColor", from, color)
			end
		elseif cmd == "/setemote" then
			CancelEvent()
			local key = string.lower(tostring(args[2]))
			local keyTrue = false
			for k,v in pairs(validEmoteKeys) do
				if key == v then
					keyTrue = true
					break
				end
			end
			local name = (tostring(args[3]))
			if name ~= nil then
				emote = emotes[name] or chatEmotes[name]
			end
			if keyTrue and emote ~= nil then
				TriggerClientEvent("vRP:setemote", from, key, emote)
			end
		end
	end
end)

RegisterServerEvent('CustomScripts:needsSyncSV')
AddEventHandler('CustomScripts:needsSyncSV', function(player, need, gender)
    TriggerClientEvent('CustomScripts:needsSyncCL', -1, player, need, gender)
end)

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
