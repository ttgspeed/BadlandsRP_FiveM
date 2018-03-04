-- this module define the emotes menu

local cfg = module("cfg/emotes")
local lang = vRP.lang

local emotes = cfg.emotes
local chatEmotes = cfg.chatEmotes

local function ch_emote(player,choice)
  local emote = emotes[choice]
  if emote then
    vRPclient.getActionLock(player, {},function(locked)
      if not locked then
        vRPclient.playAnim(player,{emote[1],emote[2],emote[3]})
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
        TriggerClientEvent('chatMessage', from, "Emotes", {200,0,0} , "Usage: /em list")
        return
      end
      if emoteNic == "list" then
        TriggerClientEvent('chatMessage', from, "Emotes", {200,0,0} , "[beggar, bumslumped, bumstanding, bumwash, camera, cheer, clipboard, coffee, cop, crowdcontrol, dance, damn, diggit, drill, drink, film, flex, flipoff, gangsign1, gangsign2, grabcrotch, guard, hammer, handsup, hangout, hiker, hoe, hoe2, impatient, investigate, janitor, jog, leafblower, lean, kneel, mechanic, mobile, musician, no, notepad, parkingmeter, peacesign, party, plant, puffpuff, pushups, rock, salute, sit, sitchair, situps, statue, sunbath, sunbath2, tendtodead, titsqueeze, tourist, traffic, upyours, wank, washwindows, weld, yoga]")
        return
      end
      local emote = chatEmotes[emoteNic]
      if emote then
        vRPclient.getActionLock(from, {},function(locked)
          if not locked then
            vRPclient.playAnim(from,{emote[1],emote[2],emote[3]})
          end
        end)
      else
        TriggerClientEvent('chatMessage', from, "Error", {200,0,0} , "Emote not found. Usage: /em list")
      end
    end
  end
end)
