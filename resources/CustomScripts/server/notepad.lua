local savedNotes = {}

TriggerEvent('server:LoadsNote')

RegisterNetEvent("server:open_notepad")
AddEventHandler("server:open_notepad", function(source)
  local _source = source
  TriggerClientEvent('lkrp_notepad:OpenNotepadGui', _source)
  TriggerEvent('server:LoadsNote')
end)


RegisterNetEvent("server:LoadsNote")
AddEventHandler("server:LoadsNote", function()
  TriggerClientEvent('lkrp_notepad:updateNotes', -1, savedNotes)
end)

RegisterNetEvent("server:newNote")
AddEventHandler("server:newNote", function(text, x, y, z)
  local import = {
    ["text"] = ""..text.."",
    ["x"] = x,
    ["y"] = y,
    ["z"] = z,
  }
  table.insert(savedNotes, import)
  TriggerEvent("server:LoadsNote")
end)

RegisterNetEvent("server:updateNote")
AddEventHandler("server:updateNote", function(noteID, text)
  savedNotes[noteID]["text"]=text
  TriggerEvent("server:LoadsNote")
end)

RegisterNetEvent("server:destroyNote")
AddEventHandler("server:destroyNote", function(noteID)
  table.remove(savedNotes, noteID)
  TriggerEvent("server:LoadsNote")
end)
