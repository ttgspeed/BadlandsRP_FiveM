-- define a module to build a language access with a dictionary

local Log = {}

Log.log_type = {
  default = "LOG",
  purchase = "PURCHASE",
  action = "ACTION",
  transaction = "TRANSACTION",
  anticheat = "ANTICHEAT",
  connection = "CONNECTION_STATE",
  sms = "SMS",
  setmoney = "SETMONEY",
  setbankmoney = "SETBANKMONEY",
  sync = "SYNC",
  garage = "GARAGE",
  death = "DEATH",
  admin = "ADMIN",
}

function Log.write(id, log, log_type)
  line = {
    ["datetime"] = os.date("%H:%M:%S %d/%m/%Y"),
    ["id"] = id,
    ["log_type"] = log_type or Log.log_type.default,
    ["log"] = log
  }

  file = io.open("player.log", "a")
  if file ~= nil then
    file:write(json.encode(line), "\n")
    file:close()
  end
end

function Log.write_table(player, table)
  -- Probably need to flesh this out for sync logs
end

function Log.new(dict)
  return setmetatable({}, { __index = function(t,k) return resolve_path(dict,"",t,k) end })
end

return Log

-- usage
-- [SERVER-SIDE]
-- local Log = require("resources/vrp/lib/Log")
--
-- Log.write([user_id], [log], **[Log.log_type])
-- Log.write(user_id, "This is a logged message")
-- Log.write(user_id, "User purchased something for a lot of money", Log.log_type.purchase)
--
-- [CLIENT-SIDE]
-- Coming soon
