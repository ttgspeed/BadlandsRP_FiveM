function tvRP.shareCarCrashEvent(passengerList)
  if passengerList ~= nil then
    for k,v in pairs(passengerList) do
      vRPclient.sendCarCrashEvent(v,{})
    end
  end
end
