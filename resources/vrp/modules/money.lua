local lang = vRP.lang

-- Money module, wallet/bank API
-- The money is managed with direct SQL requests to prevent most potential value corruptions
-- the wallet empty itself when respawning (after death)

-- load config
local cfg = module("cfg/money")
local Log = module("lib/Log")
local htmlEntities = module("lib/htmlEntities")

-- API

-- get money
-- cbreturn nil if error
function vRP.getMoney(user_id)
  local tmp = vRP.getUserTmpTable(user_id)
  if tmp then
    return tmp.wallet or 0
  else
    return 0
  end
end

-- set money
function vRP.setMoney(user_id,value)
  local tmp = vRP.getUserTmpTable(user_id)
  if tmp then
    tmp.wallet = value
    Log.write(user_id, value, Log.log_type.setmoney)
    if user_id ~= nil and value ~= nil and value > 10000000 then
      if not vRP.hasPermission(user_id,"player.list") then -- exempt admins, lazy method
        local player = vRP.getUserSource(user_id)
        local reason = "Player cash on hand greater than 10mil. Cash = "..value
        Log.write(user_id,"-- ANTI-CHEAT LOG -- ("..user_id.." - "..(GetPlayerEP(player) or '0.0.0.0').." - "..(vRP.getSourceIdKey(player) or 'missing identifier')..") "..(GetPlayerName(player) or 'missing name').." -- "..reason, Log.log_type.anticheat)
        --DropPlayer(player, reason)
        vRP.ban(player, user_id.." Scripting perm (serpickle)", 0)
      end
    end
  end

  -- update client display
  local source = vRP.getUserSource(user_id)
  if source ~= nil then
    TriggerClientEvent('banking:updateCashBalance',source, value)
  end
end

-- try a payment
-- return true or false (debited if true)
function vRP.tryPayment(user_id,amount)
	if amount < 0 then
		Log.write(user_id, "Attempted to make a negative payment: $"..amount, Log.log_type.anticheat)
		vRP.ban(user_id, user_id.." Scripting perm (serpickle)", 0)
		return false
	end

  local money = vRP.getMoney(user_id)
  if money >= amount then
		Log.write(user_id, "tryPayment "..(money-amount), Log.log_type.money)
    vRP.setMoney(user_id,money-amount)
    return true
  else
    return false
  end
end

-- return true or false (debited if true)
function vRP.tryDebitedPayment(user_id,amount)
	if amount < 0 then
		Log.write(user_id, "Attempted to make a negative payment: $"..amount, Log.log_type.anticheat)
		vRP.ban(user_id, user_id.." Scripting perm (serpickle)", 0)
		return false
	end

  local money = vRP.getMoney(user_id)
  local bank = vRP.getBankMoney(user_id)
  if money >= amount then
		Log.write(user_id, "tryDebitedPayment "..(money-amount), Log.log_type.money)
    vRP.setMoney(user_id,money-amount)
    return true
  elseif (money + bank) >= amount then
		Log.write(user_id, "tryDebitedPayment "..(amount-money), Log.log_type.money)
    vRP.setMoney(user_id,0)
    vRP.setBankMoney(user_id,bank-(amount-money))
    return true
  else
    return false
  end
end

function vRP.prisonFinancialPenalty(user_id,amount)
  local money = vRP.getMoney(user_id)
  local bank = vRP.getBankMoney(user_id)
  if money >= amount then
		Log.write(user_id, "prisonFinancialPenalty "..(money-amount), Log.log_type.money)
    vRP.setMoney(user_id,money-amount)
    return true
  elseif (money + bank) >= amount then
		Log.write(user_id, "prisonFinancialPenalty "..(bank-(amount-money)), Log.log_type.money)
    vRP.setMoney(user_id,0)
    vRP.setBankMoney(user_id,bank-(amount-money))
    return true
  else
		Log.write(user_id, "prisonFinancialPenalty 0", Log.log_type.money)
    vRP.setMoney(user_id,0)
    vRP.setBankMoney(user_id,0)
    return true
  end
  return false
end

-- give money
function vRP.giveMoney(user_id,amount)
  local money = vRP.getMoney(user_id)
  vRP.setMoney(user_id,money+amount)
	Log.write(user_id, "giveMoney "..(money+amount), Log.log_type.money)
end

-- get bank money
function vRP.getBankMoney(user_id)
  local tmp = vRP.getUserTmpTable(user_id)
  if tmp then
    return tmp.bank or 0
  else
    return 0
  end
end

-- set bank money
function vRP.setBankMoney(user_id,value)
  local tmp = vRP.getUserTmpTable(user_id)
  if tmp then
    tmp.bank = value
    Log.write(user_id, value, Log.log_type.setbankmoney)

    local source = vRP.getUserSource(user_id)
    if source ~= nil then
      TriggerClientEvent('banking:updateBalance',source, value)
    end
  end
end

-- give bank money
function vRP.giveBankMoney(user_id,amount)
  if amount > 0 then
    local money = vRP.getBankMoney(user_id)
    vRP.setBankMoney(user_id,money+amount)
		Log.write(user_id, "giveBankMoney "..(money+amount), Log.log_type.money)
  end
end

-- try a withdraw
-- return true or false (withdrawn if true)
function vRP.tryWithdraw(user_id,amount)
	if amount < 0 then
		Log.write(user_id, "Attempted to make a negative payment: $"..amount, Log.log_type.anticheat)
		vRP.ban(user_id, user_id.." Scripting perm (serpickle)", 0)
		return false
	end

  local money = vRP.getBankMoney(user_id)
  if amount > 0 and money >= amount then
    vRP.setBankMoney(user_id,money-amount)
    vRP.giveMoney(user_id,amount)
		Log.write(user_id, "tryWithdraw "..(amount), Log.log_type.money)
    return true
  else
    return false
  end
end

-- try a deposit
-- return true or false (deposited if true)
function vRP.tryDeposit(user_id,amount)
	if amount < 0 then
		Log.write(user_id, "Attempted to make a negative payment: $"..amount, Log.log_type.anticheat)
		vRP.ban(user_id, user_id.." Scripting perm (serpickle)", 0)
		return false
	end

  if amount > 0 and vRP.tryPayment(user_id,amount) then
    vRP.giveBankMoney(user_id,amount)
		Log.write(user_id, "tryDeposit "..(amount), Log.log_type.money)
		vRP.ban(user_id, user_id.." Scripting perm (serpickle)", 0)
    return true
  else
    return false
  end
end

-- try full payment (wallet + bank to complete payment)
-- return true or false (debited if true)
function vRP.tryFullPayment(user_id,amount)
	if amount < 0 then
		Log.write(user_id, "Attempted to make a negative payment: $"..amount, Log.log_type.anticheat)
		vRP.ban(user_id, user_id.." Scripting perm (serpickle)", 0)
		return false
	end

  local money = vRP.getMoney(user_id)
  if money >= amount then -- enough, simple payment
    return vRP.tryPayment(user_id, amount)
  else  -- not enough, withdraw -> payment
    if vRP.tryWithdraw(user_id, amount-money) then -- withdraw to complete amount
      return vRP.tryPayment(user_id, amount)
    end
  end

  return false
end

-- events, init user account if doesn't exist at connection
AddEventHandler("vRP:playerJoin",function(user_id,source,name,last_login)
  MySQL.Async.fetchAll('INSERT IGNORE INTO vrp_user_moneys(user_id,wallet,bank) VALUES(@user_id,@wallet,@bank)', {user_id = user_id, wallet = cfg.open_wallet, bank = cfg.open_bank}, function(rows)
    -- load money (wallet,bank)
    local tmp = vRP.getUserTmpTable(user_id)
    if tmp then
      MySQL.Async.fetchAll('SELECT wallet,bank FROM vrp_user_moneys WHERE user_id = @user_id', {user_id = user_id}, function(rows)
        if #rows > 0 then
          tmp.bank = rows[1].bank
          tmp.wallet = rows[1].wallet
        end
      end)
    end
  end)
end)

-- save money on leave
AddEventHandler("vRP:playerLeave",function(user_id,source)
  -- (wallet,bank)
  local tmp = vRP.getUserTmpTable(user_id)
  if tmp then
    if tmp.wallet ~= nil and tmp.bank ~= nil then
      MySQL.Async.execute('UPDATE vrp_user_moneys SET wallet = @wallet, bank = @bank WHERE user_id = @user_id', {user_id = user_id, wallet = tmp.wallet, bank = tmp.bank}, function(rowsChanged) end)
    else
      MySQL.Async.fetchAll('SELECT wallet,bank FROM vrp_user_moneys WHERE user_id = @user_id', {user_id = user_id}, function(rows)
        if #rows > 0 then
          tmp.bank = rows[1].bank
          tmp.wallet = rows[1].wallet
        end
      end)
    end
  end
end)

-- save money (at same time that save datatables)
AddEventHandler("vRP:save", function()
  for k,v in pairs(vRP.user_tmp_tables) do
    if v.wallet ~= nil and v.bank ~= nil then
      MySQL.Async.execute('UPDATE vrp_user_moneys SET wallet = @wallet, bank = @bank WHERE user_id = @user_id', {user_id = k, wallet = v.wallet, bank = v.bank}, function(rowsChanged) end)
    else
      local tmp = vRP.getUserTmpTable(k)
      if tmp then
        MySQL.Async.fetchAll('SELECT wallet,bank FROM vrp_user_moneys WHERE user_id = @user_id', {user_id = k}, function(rows)
          if #rows > 0 then
            tmp.bank = rows[1].bank
            tmp.wallet = rows[1].wallet
          end
        end)
      end
    end
  end
end)

-- money hud
AddEventHandler("vRP:playerSpawn",function(user_id, source, first_spawn)
  if first_spawn then
    -- add money display
    local cash = vRP.getMoney(user_id)
    TriggerClientEvent('banking:updateCashBalance',source, cash)
  end
end)

local function ch_give(player,choice)
  -- get nearest player
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    vRPclient.getNearestPlayer(player,{10},function(nplayer)
      if nplayer ~= nil then
        local nuser_id = vRP.getUserId(nplayer)
        if nuser_id ~= nil then
          -- prompt number
          vRP.prompt(player,lang.money.give.prompt(),"",function(player,amount)
            local amount = parseInt(amount)
            if amount > 0 and vRP.tryPayment(user_id,amount) then
              vRP.giveMoney(nuser_id,amount)
              vRPclient.notify(player,{lang.money.given({amount})})
              vRPclient.notify(nplayer,{lang.money.received({amount})})
              Log.write(user_id,user_id.." gave $"..amount.." to "..nuser_id,Log.log_type.action)
            else
              vRPclient.notify(player,{lang.money.not_enough()})
            end
          end)
        else
          vRPclient.notify(player,{lang.common.no_player_near()})
        end
      else
        vRPclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end

local function ch_reapplyProps(player,choice)
  local user_id = vRP.getUserId(player)
  local data = vRP.getUserDataTable(user_id)
  vRPclient.reapplyProps(player,{data.customization})
  if not vRP.hasPermission(user_id, "emergency.support") then
    vRPclient.setCustomization(player,{data.customization, false})
  end
  vRP.getUData(user_id,"vRP:head:overlay",function(value)
    if value ~= nil then
      custom = json.decode(value)
      vRPclient.setOverlay(player,{custom,true})
    end
  end)
end

-- add player give money to main menu
vRP.registerMenuBuilder("main", function(add, data)
  local user_id = vRP.getUserId(data.player)
  local wallet_menu = {name=lang.wallet.title(),css={top="75px",header_color="rgba(0,125,255,0.75)"}}

  if user_id ~= nil then
    --generate wallet identity card
    vRP.getUserIdentity(user_id, function(identity)

      if identity then
        -- generate identity content
        -- get address
        vRP.getUserAddress(user_id, function(address)
          local home = ""
          local number = ""
          if address then
            home = address.home
            number = address.number
          end

          local content = lang.cityhall.menu.info({
            htmlEntities.encode(identity.name),
            htmlEntities.encode(identity.firstname),
            identity.age,
            identity.registration,
            identity.phone,
            home,
            number,
            identity.firearmlicense,
            identity.driverlicense,
            identity.pilotlicense,
            identity.towlicense,
          })
          wallet_menu[lang.cityhall.menu.title()] = {ch_reapplyProps, content,9} --restore headgear
        end)
      end
    end)

    wallet_menu[lang.money.give.title()] = {ch_give,lang.money.give.description()}
    wallet_menu[lang.police.menu.askid.title()] = vRP.choice_askid

    local choices = {}
    choices[lang.wallet.title()] = {function() vRP.openMenu(data.player,wallet_menu) end,lang.wallet.money.info({
      vRP.getMoney(user_id),
      vRP.getBankMoney(user_id)
    }),5}

    add(choices)
  end
end)
