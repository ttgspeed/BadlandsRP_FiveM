local menu_state = {}

-- pause
AddEventHandler("vRP:pauseChange", function(paused)
  SendNUIMessage({act="pause_change", paused=paused})
end)

-- MENU

function tvRP.openMenuData(menudata)
  if not tvRP.isMenuOpen() then
    controlThread("up")
    controlThread("down")
  end
  SendNUIMessage({act="open_menu", menudata = menudata})
end

function tvRP.closeMenu()
  SendNUIMessage({act="close_menu"})
end

function tvRP.isMenuOpen()
  return menu_state.opened
end

-- PROMPT

function tvRP.prompt(title,default_text)
  SendNUIMessage({act="prompt",title=title,text=tostring(default_text)})
  SetNuiFocus(true)
end

-- REQUEST

function tvRP.request(id,text,time)
  SendNUIMessage({act="request",id=id,text=tostring(text),time = time})
  tvRP.playSound("HUD_MINI_GAME_SOUNDSET","5_SEC_WARNING")
end

function tvRP.requestCoordRange(id,text,time,coordx, coordy, coordz,range)
  if IsEntityAtCoord(GetPlayerPed(-1), coordx, coordy, coordz, 15.0, 15.0, 10.0, 0, 1, 0) then
    SendNUIMessage({act="request",id=id,text=tostring(text),time = time})
    tvRP.playSound("HUD_MINI_GAME_SOUNDSET","5_SEC_WARNING")
  end
end

-- gui menu events
RegisterNUICallback("menu",function(data,cb)
  if data.act == "close" then
    vRPserver.closeMenu({data.id})
  elseif data.act == "valid" then
    vRPserver.validMenuChoice({data.id,data.choice,data.mod})
  end
end)

RegisterNUICallback("menu_state",function(data,cb)
  menu_state = data
end)

-- gui prompt event
RegisterNUICallback("prompt",function(data,cb)
  if data.act == "close" then
    SetNuiFocus(false)
    SetNuiFocus(false)
    vRPserver.promptResult({data.result})
  end
end)

-- gui request event
RegisterNUICallback("request",function(data,cb)
  if data.act == "response" then
    vRPserver.requestResult({data.id,data.ok})
  end
end)

-- ANNOUNCE

-- add an announce to the queue
-- background: image url (800x150)
-- content: announce html content
function tvRP.announce(background,content)
  SendNUIMessage({act="announce",background=background,content=content})
end

-- cfg
RegisterNUICallback("cfg",function(data,cb) -- if NUI loaded after
  SendNUIMessage({act="cfg",cfg=cfg.gui})
end)
SendNUIMessage({act="cfg",cfg=cfg.gui}) -- if NUI loaded before

-- try to fix missing cfg issue (cf: https://github.com/ImagicTheCat/vRP/issues/89)
for i=1,5 do
  SetTimeout(5000*i, function() SendNUIMessage({act="cfg",cfg=cfg.gui}) end)
end

-- PROGRESS BAR

-- create/update a progress bar
function tvRP.setProgressBar(name,anchor,text,r,g,b,value)
  local pbar = {name=name,anchor=anchor,text=text,r=r,g=g,b=b,value=value}

  -- default values
  if pbar.value == nil then pbar.value = 0 end

  SendNUIMessage({act="set_pbar",pbar = pbar})
end

-- set progress bar value in percent
function tvRP.setProgressBarValue(name,value)
  SendNUIMessage({act="set_pbar_val", name = name, value = value})
end

-- set progress bar text
function tvRP.setProgressBarText(name,text)
  SendNUIMessage({act="set_pbar_text", name = name, text = text})
end

-- remove a progress bar
function tvRP.removeProgressBar(name)
  SendNUIMessage({act="remove_pbar", name = name})
end

-- DIV

-- set a div
-- css: plain global css, the div class is "div_name"
-- content: html content of the div
function tvRP.setDiv(name,css,content)
  SendNUIMessage({act="set_div", name = name, css = css, content = content})
end

-- set the div css
function tvRP.setDivCss(name,css)
  SendNUIMessage({act="set_div_css", name = name, css = css})
end

-- set the div content
function tvRP.setDivContent(name,content)
  SendNUIMessage({act="set_div_content", name = name, content = content})
end

-- execute js for the div
-- js variables: this is the div
function tvRP.divExecuteJS(name,js)
  SendNUIMessage({act="div_execjs", name = name, js = js})
end

-- remove the div
function tvRP.removeDiv(name)
  SendNUIMessage({act="remove_div", name = name})
end

-- CONTROLS/GUI

local paused = false

function tvRP.isPaused()
  return paused
end

--This function is to make sure the player is still near the vehicle while vehicle GUI is open
function tvRP.vehicleMenuProximity(vtype,name,plate)
  Citizen.CreateThread(function()
    Citizen.Wait(0)
    local timer = 0

    --timeout if menu doens't open
    while not tvRP.isMenuOpen() and timer < 100 do
      timer = timer + 10
      Citizen.Wait(10)
    end

    while tvRP.isMenuOpen() do
      Citizen.Wait(100)
      local ok,nvtype,nname,nplate = tvRP.getNearestOwnedVehiclePlate(5)
      if not ok or nvtype ~= vtype or nname ~= name or nplate ~= plate then
        tvRP.closeMenu()
      end
    end
  end)
end

--Up control
function controlThread(direction)
  Citizen.CreateThread(function()
    local timer = 0
    local controlReleased = false
    local control = nil
    local message = nil

    if direction == "up" then
      control = cfg.controls.phone.up
      message = {act="event",event="UP"}
    elseif direction == "down" then
      control = cfg.controls.phone.down
      message = {act="event",event="DOWN"}
    end

    --Wait until the menu is open or timeout
    while not tvRP.isMenuOpen() and timer < 100 do
      Citizen.Wait(10)
      timer = timer + 10
    end

    --Keep running while the menu is open
    while tvRP.isMenuOpen() do
      Citizen.Wait(0)

      if IsControlJustPressed(table.unpack(control)) then
        SendNUIMessage(message)

        --Basically wait 200ms and make sure the player is still holding the button
        timer = 0
        controlReleased = false
        while timer < 200 and not controlReleased do
          Citizen.Wait(10)
          timer = timer + 10
          if not IsControlPressed(table.unpack(control)) then controlReleased = true end
        end

        --If you're still holding the button after all of that then keep scrolling
        if not controlReleased then
          while IsControlPressed(table.unpack(control)) do
            SendNUIMessage(message)
            Citizen.Wait(100)
          end
        end

      end
    end   --end thread loop
  end)  --end thread
end

-- gui controls (from cellphone)
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    -- menu controls
    if IsControlJustPressed(table.unpack(cfg.controls.phone.left)) then
      while IsControlPressed(table.unpack(cfg.controls.phone.left)) do
        SendNUIMessage({act="event",event="LEFT"})
        Citizen.Wait(250)
      end
    end
    if IsControlJustPressed(table.unpack(cfg.controls.phone.right)) then
      while IsControlPressed(table.unpack(cfg.controls.phone.right)) do
        SendNUIMessage({act="event",event="RIGHT"})
        Citizen.Wait(250)
      end
    end

    if IsControlJustPressed(table.unpack(cfg.controls.phone.select)) then SendNUIMessage({act="event",event="SELECT"}) end
    if IsControlJustPressed(table.unpack(cfg.controls.phone.cancel)) then SendNUIMessage({act="event",event="CANCEL"}) end

    -- open general menu
    if IsControlJustPressed(table.unpack(cfg.controls.phone.open)) and (tvRP.isAdmin() or ((not tvRP.isInComa() or not cfg.coma_disable_menu) and (not tvRP.isHandcuffed() or not cfg.handcuff_disable_menu))) and not menu_state.opened then vRPserver.openMainMenu({}) end

    -- F1,F2
    if IsControlJustPressed(table.unpack(cfg.controls.request.yes)) then SendNUIMessage({act="event",event="F1"}) end
    if IsControlJustPressed(table.unpack(cfg.controls.request.no)) then SendNUIMessage({act="event",event="F2"}) end

    -- pause events
    local pause_menu = IsPauseMenuActive()
    if pause_menu and not paused then
      paused = true
      tvRP.closeMenu()
    elseif not pause_menu and paused then
      paused = false
    end
  end
end)
