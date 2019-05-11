
local cfg = {}

-- start wallet/bank values
cfg.open_wallet = 200
cfg.open_bank = 1000

cfg.lawyerPayRate = 1000 -- per minute
cfg.lawyerPayMax = 30000

-- money display css
cfg.display_css = [[
.div_money{
  font-family: pcdown !important;
  position: absolute;
  top: 100px;
  right: 20px;
  font-size: 35px;
  font-weight: 700;
  color: white;
  text-shadow:
		   -1px -1px 0 #000,
			1px -1px 0 #000,
			-1px 1px 0 #000,
			 1px 1px 0 #000;
}

.div_money .symbol{
  color: rgb(0, 125, 0);
}
]]

return cfg
