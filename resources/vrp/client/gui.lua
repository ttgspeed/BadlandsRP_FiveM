-- MENU

function tvRP.openMenuData(menudata)
  SendNUIMessage({act="open_menu", menudata = menudata})
end

function tvRP.closeMenu()
  SendNUIMessage({act="close_menu"})
end

-- PROMPT

function tvRP.prompt(title,default_text)
  SendNUIMessage({act="prompt",title=title,text=tostring(default_text)})
  SetNuiFocus(true)
end

-- REQUEST

function tvRP.request(id,text,time)
  SendNUIMessage({act="request",id=id,text=tostring(text),time = time})
end

-- gui menu events
RegisterNUICallback("menu",function(data,cb)
  if data.act == "close" then
    vRPserver.closeMenu({data.id})
  elseif data.act == "valid" then
    vRPserver.validMenuChoice({data.id,data.choice})
  end
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

-- cfg
RegisterNUICallback("cfg",function(data,cb) -- if NUI loaded after
  SendNUIMessage({act="cfg",cfg=cfg.gui})
end)
SendNUIMessage({act="cfg",cfg=cfg.gui}) -- if NUI loaded before

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

-- execute js for the div in a simple sandbox (useful to optimize data change using functions)
-- you can attach objects or functions to the div element for later calls
-- js variables: div (the div element), document (the document)
function tvRP.divExecuteJS(name,js)
  SendNUIMessage({act="div_execjs", name = name, js = js})
end

-- remove the div
function tvRP.removeDiv(name)
  SendNUIMessage({act="remove_div", name = name})
end

-- CONTROLS

-- gui controls (from cellphone)
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    -- PHONE CONTROLS
    if IsControlJustPressed(3,172) then SendNUIMessage({act="event",event="UP"}) end
    if IsControlJustPressed(3,173) then SendNUIMessage({act="event",event="DOWN"}) end
    if IsControlJustPressed(3,174) then SendNUIMessage({act="event",event="LEFT"}) end
    if IsControlJustPressed(3,175) then SendNUIMessage({act="event",event="RIGHT"}) end
    if IsControlJustPressed(3,176) then SendNUIMessage({act="event",event="SELECT"}) end
    if IsControlJustPressed(3,177) then SendNUIMessage({act="event",event="CANCEL"}) end

    -- INPUT_PHONE, open general menu
    if IsControlJustPressed(0,311) and (not tvRP.isInComa() or not cfg.coma_disable_menu) and (not tvRP.isHandcuffed() or not cfg.handcuff_disable_menu) then vRPserver.openMainMenu({}) end

    -- F5,F6 (control michael, control franklin)
    if IsControlJustPressed(1,166) then SendNUIMessage({act="event",event="F5"}) end
    if IsControlJustPressed(1,167) then SendNUIMessage({act="event",event="F6"}) end

  end
end)

