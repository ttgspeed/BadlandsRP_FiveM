function tvRP.shareCarCrashEvent(passengerList)
  if passengerList ~= nil then
    for k,v in pairs(passengerList) do
      if k ~= nil and k ~= -1 then
        vRPclient.sendCarCrashEvent(k,{})
      end
    end
  end
end
