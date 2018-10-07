--
-- Panopticon
--
local panopticon = {}
local charset = {}
local startup_time = os.date("*t").hour

-- qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890
for i = 48,  57 do table.insert(charset, string.char(i)) end
for i = 65,  90 do table.insert(charset, string.char(i)) end
for i = 97, 122 do table.insert(charset, string.char(i)) end

function string.random(length)
	math.randomseed(startup_time * 1e6)
  if length > 0 then
    return string.random(length - 1) .. charset[math.random(1, #charset)]
  else
    return ""
  end
end

function panopticon.generate_token(len)
	return string.random(len)
end

return panopticon
