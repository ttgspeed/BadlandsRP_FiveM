
local cfg = {}

-- size of the sms history
cfg.sms_history = 15

-- maximum size of an sms
cfg.sms_size = 500

-- duration of a sms position marker (in seconds)
cfg.smspos_duration = 300

-- define phone services
-- blipid, blipcolor (customize alert blip)
-- alert_time (alert blip display duration in seconds)
-- alert_permission (permission required to receive the alert)
-- alert_notify (notification received when an alert is sent)
-- notify (notification when sending an alert)
cfg.services = {
  ["Police"] = {
    blipid = 304,
    blipcolor = 38,
    alert_time = 300, -- 5 minutes
    alert_permission = "police.service",
    alert_notify = "Police alert:",
    notify = "You requested police assistance.",
    answer_notify = "Police have been dispatched to your location."
  },
  ["EMS/Fire"] = {
    blipid = 153,
    blipcolor = 1,
    alert_time = 300, -- 5 minutes
    alert_permission = "emergency.service",
    alert_notify = "Emergency alert:",
    notify = "You called for EMS/Fire assistance.",
    answer_notify = "EMS is dispatched to your location."
  },
  ["Taxi"] = {
    blipid = 198,
    blipcolor = 5,
    alert_time = 300,
    alert_permission = "taxi.service",
    alert_notify = "Taxi alert:",
    notify = "You called a taxi.",
    answer_notify = "A taxi is coming."
  }--[[,
  ["Mechanic"] = {
    blipid = 446,
    blipcolor = 5,
    alert_time = 300,
    alert_permission = "repair.service",
    alert_notify = "Repair alert: ",
    notify = "You called a mechanic.",
    answer_notify = "A repairer is coming."
  }]]--
}

-- define phone announces
-- image: background image for the announce (800x150 px)
-- price: amount to pay to post the announce
-- description (optional)
-- permission (optional): permission required to post the announce
cfg.announces = {
  ["admin"] = {
    image = "http://i.imgur.com/g3adsLj.png",
    price = 0,
    description = "Admin only.",
    permission = "admin.announce"
  }--[[,
  ["police"] = {
    image = "http://i.imgur.com/DY6DEeV.png",
    price = 0,
    description = "Only for police, ex: wanted advert.",
    permission = "police.announce"
  },
  ["commercial"] = {
    image = "http://i.imgur.com/b2O9WMa.png",
    description = "Commercial stuff (buy, sell, work).",
    price = 5000
  },
  ["party"] = {
    image = "nui://vrp_mod/announce_party.png",
    description = "Organizing a party ? Let everyone know the rendez-vous.",
    price = 5000
  }]]--
}

return cfg
