
-- this file is used to define additional static blips and markers to the map

local cfg = {}

-- list of blips
-- {x,y,z,idtype,idcolor,text}
cfg.blips = {
  {-2176.01196289063,-37.3997116088867,70.1904525756836,85,47,"Peach Field"},
  {-1188.50390625,-1487.4139404296,4.3796682357788,85,47,"Peach Merchant"},
  {-742.129760742188,2067.0029296875,106.176864624023,85,5,"Gold Mine"},
  --{-75.9527359008789,6495.42919921875,31.4908847808838,85,5,"Gold Treatment"},
  {1088.7426757812,-2000.430053711,30.87661933899,85,5,"Gold Refinement"},
  {-139.963653564453,-823.515258789063,31.4466247558594,85,5,"Gold Merchant"},
  --{2225.00927734375,5577.3154296875,53.8353805541992,140,1,"Marijuana Field"},
  --{2219.9333496094,5609.048828125,54.732719421387,140,1,"Weed Processor"},
  {166.024078369141,2229.79077148438,89.7329788208008,403,1,"Weed Processor"}, -- Old processor location
  --{65.3316345214844,3716.21728515625,38.754467010498,140,1,"Ephedrine Field"},
  {71.386817932128,3710.556640625,39.754932403564,403,1,"Ephedrine Drop"},
  -- {1391.11328125,3608.18896484375,37.94189453125,403,1,"Meth Processing Lab"},
  --{166.024078369141,2229.79077148438,89.7329788208008,140,1,"Diethylamine Field"},
  --{2515.3354492187,3792.3996582031,52.1224937438965,403,1,"LSD Processing Lab"},
  --{3856.02709960938,4459.1904296875,0.84976637363434,140,1,"Safrole Field"},
  --{-1145.96435546875,4940.06689453125,221.268676757813,403,1,"MDMA Processing Lab"},
  --{380.24658203125,2882.4543457032,49.08724975586,89,1,"Cement Works"},
  --{-1000.9919433594,4852.5268554688,274.61571289062,403,1,"Cocaine Processing Lab"},
  --{77.885513305664,-1948.2086181641,19.174139022827,439,1,"Weed Dealer"},
  {-252.41233825684,-2419.8056640625,6.000636100769,439,1,"Cocaine Dealer"},
  --{-1724.7882080078,234.66094970703,57.471710205078,439,1,"Meth Dealer"},
  --{-1724.7882080078,234.66094970703,57.471710205078,439,1,"LSD Dealer"},
  --{1302.6696777344,4226.1025390625,31.908679962158,439,1,"MDMA Dealer"},
	--{-1814.4682617188,2187.1625976562,99.39575958252,237,47,"Vineyard"},
	--{-1892.6599121094,2076.7019042968,140.9974822998,93,47,"Wine Supplier"},
  {-1424.05676269531,-712.087829589844,23.8108673095703,88,47,"Fish Trader"}
  --{-1202.96252441406,-1566.14086914063,4.61040639877319,311,17,"Body training"} -- not implemented yet
}

-- list of markers
-- {x,y,z,sx,sy,sz,r,g,b,a,visible_distance}
cfg.markers = {
}

return cfg
