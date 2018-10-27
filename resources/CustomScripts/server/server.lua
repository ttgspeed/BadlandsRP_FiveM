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


-- Example of how to toggle weather. Added basic chat command.
AddEventHandler('chatMessage', function(from,name,message)
	if(string.sub(message,1,1) == "/") then

		local args = splitString(message)
		local cmd = args[1]

		if(cmd == "/walk")then
			CancelEvent()

			local walkStyle = string.lower(tostring(args[2]))
			if(walkStyle == nil)then
				TriggerClientEvent('chatMessage', from, "Walk Style", {200,0,0} , "Usage: /walk list")
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
				TriggerClientEvent('chatMessage', from, "Walk Style", {200,0,0} , msg)
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
				TriggerClientEvent('chatMessage', from, "Error", {200,0,0} , "Walk style not found. Usage: /walk list")
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
		elseif cmd == "/headgear" then
			CancelEvent()
			local value = (tonumber(args[2]))
			local texture = (tonumber(args[3]))
			if value ~= nil then
				TriggerClientEvent("vRP:setHeadGear", from, value, texture)
			end
		end
	end
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
