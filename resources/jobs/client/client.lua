vRPjobs = {}
Tunnel.bindInterface("jobs",vRPjobs)
Proxy.addInterface("jobs",vRPjobs)
vRP = Proxy.getInterface("vRP")
vRPserver = Tunnel.getInterface("vRP","jobs")
vRPjs = Tunnel.getInterface("jobs","jobs") -- client to jobs server
