local function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

local license_exempt_weapons = {}
license_exempt_weapons["WEAPON_KNIFE"] = true
license_exempt_weapons["WEAPON_DAGGER"] = true
license_exempt_weapons["WEAPON_BOTTLE"] = true
license_exempt_weapons["WEAPON_FLASHLIGHT"] = true
license_exempt_weapons["WEAPON_NIGHTSTICK"] = true
license_exempt_weapons["WEAPON_HAMMER"] = true
license_exempt_weapons["WEAPON_BAT"] = true
license_exempt_weapons["WEAPON_GOLFCLUB"] = true
license_exempt_weapons["WEAPON_CROWBAR"] = true
license_exempt_weapons["WEAPON_FIREEXTINGUISHER"] = true
license_exempt_weapons["WEAPON_FLARE"] = true
license_exempt_weapons["WEAPON_SWITCHBLADE"] = true
license_exempt_weapons["WEAPON_BATTLEAXE"] = true
license_exempt_weapons["WEAPON_POOLCUE"] = true
license_exempt_weapons["WEAPON_WRENCH"] = true

local items = {}

items["inv_pack"] = {"Inventory Pack","A government subsidized pack to help your shop get off the ground.",nil,0.5}
items["inv_pack_mini_1"] = {"Drink Pack","A government subsidized pack of drinks. Only to be delivered to shops.",nil,2.0}
items["inv_pack_mini_2"] = {"Food Pack","A government subsidized pack of food. Only to be delivered to shops.",nil,2.0}
items["dirty_money"] = {"Dirty money","Illegally earned money.",nil,0}
items["carrepairkit"] = {"Vehicle Repair Kit","Used to repair your vehicle",nil,0.5}
items["repairkit"] = {"Engineering Tool Kit","Used by engineers to repair satellite dishes and wind turbines.",nil,0.5}
items["safe_kit"] = {"Safe Cracking Kit","Used by bandits (often in black ski masks) to crack safes",nil,2.0}
items["taco_ingredients"] = {"Fresh Premium Taco Meat", "Fresh taco meat.",nil,0.5}

items["medkit"] = {"Medical Kit","Used to reanimate unconscious people.",nil,0.5}

-- parametric weapon items
-- give "wbody|WEAPON_PISTOL" and "wammo|WEAPON_PISTOL" to have pistol body and pistol bullets

local get_wname = function(weapon_id)
  local name = string.gsub(weapon_id,"WEAPON_","")
  name = string.upper(string.sub(name,1,1))..string.lower(string.sub(name,2))
  return name
end

--- weapon body
local wbody_name = function(args)
  return get_wname(args[2]).." body"
end

local wbody_desc = function(args)
  return ""
end

local wbody_choices = function(args)
  local choices = {}
  local fullidname = joinStrings(args,"|")

  choices["Equip"] = {function(player,choice)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil then
      vRP.getPlayerLicense(user_id, "firearmlicense", function(firearmlicense)
        if(firearmlicense == 1) or license_exempt_weapons[args[2]] then
          if vRP.tryGetInventoryItem(user_id, fullidname, 1, true) then -- give weapon body
            local weapons = {}
            weapons[args[2]] = {ammo = 0}
            vRPclient.giveWeapons(player, {weapons})
            vRP.closeMenu(player)
          end
        else
          vRPclient.notify(player, {"You require a Firearms license to equip this item"})
        end
      end)
    end
  end,"",1}

  return choices
end

local wbody_weight = function(args)
  return 0.75
end

items["wbody"] = {wbody_name,wbody_desc,wbody_choices,wbody_weight}

--- weapon ammo
local wammo_name = function(args)
  return get_wname(args[2]).." ammo"
end

local wammo_desc = function(args)
  return ""
end

local wammo_choices = function(args)
  local choices = {}
  local fullidname = joinStrings(args,"|")

  choices["Load"] = {function(player,choice)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil then
      local amount = vRP.getInventoryItemAmount(user_id, fullidname)
      vRP.prompt(player, "Amount to load ? (max "..amount..")", "", function(player,ramount)
        ramount = parseInt(ramount)

        vRPclient.getWeapons(player, {}, function(uweapons)
          if uweapons[args[2]] ~= nil then -- check if the weapon is equiped
            if vRP.tryGetInventoryItem(user_id, fullidname, ramount, true) then -- give weapon ammo
              local weapons = {}
              weapons[args[2]] = {ammo = ramount}
              vRPclient.giveWeapons(player, {weapons,false})
              vRP.closeMenu(player)
            end
          end
        end)
      end)
    end
  end,"",1}

  return choices
end

local wammo_weight = function(args)
  return 0.01
end

local addiction_symptoms = {
	['weed'] = {
		'munchies',
	},
	['cocaine'] = {
		'ventricular tachycardia',
		'hypertension',
		'sinus tachycardia',
		'headaches',
		'sweating',
		'confusion',
		'chills',
		'nausea'
	},
	['meth'] = {
		'anxiety',
		'irregular heartbeat',
		'hallucinations',
		'paranoia',
		'tachypnoea',
		'chest pain',
		'flushed skin'
	},
	['pills'] = {
		'anxiety',
		'euphoria',
		'psychosis',
		'depression',
		'constricted blood vessels',
		'fatigue',
		'breathlessness',
		'nausea'
	}
}
local drugkit_choices = {}
drugkit_choices["Test"] = {function(player,choice)
	vRPclient.getNearestPlayer(player,{5},function(nplayer)
		local user_id = vRP.getUserId(player)
		local nuser_id = vRP.getUserId(nplayer)
		if nuser_id ~= nil then
			vRPclient.playAnim(player,{true,{{"mp_common","givetake2_a",1}},false})
			vRP.getUData(nuser_id,"vRP:addiction"..vRP.getUserCharacter(user_id),function(data)
				local addictions = json.decode(data)
				if addictions == nil then
					addictions = {}
				end

				if tablelength(addictions) > 0 then
					local addiction_count = 0

					for k,v in pairs(addictions) do
						local symptoms = ""
						for symptom = 1,math.random(2,3) do
							symptoms = symptoms..addiction_symptoms[k][math.random(1,tablelength(addiction_symptoms[k]))]..", "
						end
						symptoms = symptoms:sub(1, -3)

						if v.addiction >= 100 then
							--overdose
							vRPclient.notify(player,{"The patient is experiencing severe "..symptoms})
							addiction_count = addiction_count + 1
						elseif v.addiction >= 50 then
							--perks
							vRPclient.notify(player,{"The patient is experiencing "..symptoms})
							addiction_count = addiction_count + 1
						elseif v.addiction > 0 then
							--withdraw
							vRPclient.notify(player,{"The patient has a trace of "..k.." in their system."})
							addiction_count = addiction_count + 1
						end
					end

					if addiction_count == 0 then
						vRPclient.notify(player,{"The patient is not positive for any testable substances."})
					end
				else
					vRPclient.notify(player,{"The patient is not positive for any testable substances."})
				end
			end)
		else
			vRPclient.notify(player,{"You are not close enough to test anyone."})
		end
	end)
end}

-- gen treatment choices as genfunc
-- idname
-- ftype: treat
local function gen(item)
  local fgen = function(args)
    local idname = args[1]
    local choices = {}
    local act = "Administer"
    local name = vRP.getItemName(idname)
		local treatment_table = {
			['lidocaine'] = {'cocaine',1},
			['labetalol'] = {'cocaine',2},
			['bupropion'] = {'meth',1},
			['methylphenidate'] = {'meth',2},
			['naloxone'] = {'pills',1},
		}

    choices[act] = {function(player,choice)
      local user_id = vRP.getUserId(player)
      if user_id ~= nil then
				if vRP.hasPermission(user_id,"emergency.revive") then
					vRPclient.getDistanceFrom(player,{-461.13256835938,-351.00704956054,-186.46617126464},function(distance)
						if distance < 100 then
							vRPclient.getNearestPlayer(player,{5},function(nplayer)
								local nuser_id = vRP.getUserId(nplayer)
								if nuser_id ~= nil then
									vRPclient.playAnim(player,{true,{{"mp_common","givetake2_a",1}},false})
									if vRP.tryGetInventoryItem(user_id,idname,1,false) then
										local treatment = treatment_table[item]
										vRP.treatAddiction(nplayer, treatment[1], treatment[2])
										vRPclient.notify(player,{"You have treated the patient's "..treatment[1].." addiction with "..item})
										vRPclient.notify(nplayer,{"The medic has treated your "..treatment[1].." addiction with "..item})
										vRP.closeMenu(player)
									end
								else
									vRPclient.notify(player,{"There's nobody to treat in this area"})
								end
							end)
						else
							vRPclient.notify(player,{"Controlled substance laws prevent you from administering this medication outside of a hospital."})
						end
					end)
				else
					vRPclient.notify(player,{"Your lack of medical training prevents you from knowing where to stick the pokey part of the healy stick."})
				end
      end
    end}

    return choices
  end

  return fgen
end

items["wammo"] = {wammo_name,wammo_desc,wammo_choices,wammo_weight}

items["drugkit"] = {"Drug Test Kit","Used to determine the concentration of toxins in a patient's blood stream",function(args) return drugkit_choices end,0.5}

items["lidocaine"] = {"Lidocaine","Used to treat ventricular tachycardia and to perform nerve blocks.",gen('lidocaine'),0.5} --cocaine minor
items["labetalol"] = {"Labetalol","Used to treat severe hypertension or sinus tachycardia.",gen('labetalol'),0.5} --cocaine severe

items["bupropion"] = {"Bupropion","Antidepressant used to reduced meth cravings in those with less severe addictions.",gen('bupropion'),0.5} --meth minor
items["methylphenidate"] = {"Methylphenidate"," Psychostimulant commonly used for ADHD or narcolepsy, reduces meth use",gen('methylphenidate'),0.5} --meth severe

items["naloxone"] = {"Naloxone","Used to block the effects of opioids, especially in overdose.",gen('naloxone'),0.5} --pills

return items
