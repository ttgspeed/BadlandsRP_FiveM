
-- define all language properties

local lang = {
  common = {
    welcome = "Welcome. Press M to use the menu.",
    no_player_near = "No player near you.",
    invalid_value = "Invalid value.",
    invalid_name = "Invalid name.",
    not_found = "Not found.",
    request_refused = "Request refused.",
    wearing_uniform = "Be careful, you are wearing a uniform.",
    not_allowed = "~r~Not allowed."
  },
  survival = {
    starving = "Starving",
    thirsty = "Thirsty"
  },
  wallet = {
    title = "Wallet",
    description = "Open your wallet",
    money = {
      title = "Your Money",
      info = "<em>Cash: </em>${1}<br /><em>Bank: </em>${2}"
    }
  },
  money = {
    display = "{1} <span class=\"symbol\">$</span>",
    given = "Removed ${1}.",
    received = "Received {1}$.",
    not_enough = "Not enough money.",
    paid = "Paid {1}$.",
    give = {
      title = "Give money",
      description = "Give money to the nearest player.",
      prompt = "Amount to give:"
    }
  },
  inventory = {
    title = "Inventory",
    description = "Open the inventory.",
    iteminfo = "({1})<br /><br />{2}<br /><em>{3} kg</em>",
    info_weight = "weight {1}/{2} kg",
    give = {
      title = "Give",
      description = "Give items to the nearest player.",
      prompt = "Amount to give (max {1}):",
      given = "Removed {2} {1}.",
      received = "Received {2} {1}.",
    },
    trash = {
      title = "Trash",
      description = "Destroy items.",
      prompt = "Amount to trash (max {1}):",
      done = "Trashed {1} {2}."
    },
    missing = "Missing {2} {1}.",
    full = "Inventory full.",
    chest = {
      title = "Chest",
      already_opened = "This chest is already opened by someone else.",
      full = "Chest full.",
      take = {
        title = "Take",
        prompt = "Amount to take (max {1}):"
      },
      put = {
        title = "Put",
        prompt = "Amount to put (max {1}):"
      }
    }
  },
  atm = {
    title = "ATM",
    info = {
      title = "Info",
      bank = "bank: {1} $"
    },
    deposit = {
      title = "Deposit",
      description = "wallet to bank",
      prompt = "Enter amount of money for deposit:",
      deposited = "{1}$ deposited."
    },
    withdraw = {
      title = "Withdraw",
      description = "bank to wallet",
      prompt = "Enter amount of money to withdraw:",
      withdrawn = "{1}$ withdrawn.",
      not_enough = "You don't have enough money in bank."
    }
  },
  business = {
    title = "Chamber of Commerce",
    directory = {
      title = "Directory",
      description = "Business directory.",
      dprev = "> Prev",
      dnext = "> Next",
      info = "<em>capital: </em>{1} $<br /><em>owner: </em>{2} {3}<br /><em>registration: </em>{4}<br /><em>phone: </em>{5}"
    },
    info = {
      title = "Business info",
      info = "<em>name: </em>{1}<br /><em>capital: </em>{2} $<br /><em>capital transfer: </em>{3} $<br /><br/>Capital transfer is the amount of money transfered for a business economic period, the maximum is the business capital."
    },
    addcapital = {
      title = "Add capital",
      description = "Add capital to your business.",
      prompt = "Amount to add to the business capital:",
      added = "{1}$ added to the business capital."
    },
    launder = {
      title = "Money laundering",
      description = "Use your business to launder dirty money.",
      prompt = "Amount of dirty money to launder (max {1} $): ",
      laundered = "{1}$ laundered.",
      not_enough = "Not enough dirty money."
    },
    open = {
      title = "Open business",
      description = "Open your business, minimum capital is {1} $.",
      prompt_name = "Business name (can't change after, max {1} chars):",
      prompt_capital = "Initial capital (min {1})",
      created = "Business created."

    }
  },
  cityhall = {
    title = "City Hall",
    identity = {
      title = "New identity",
      description = "Create a new identity, cost = {1} $.",
      prompt_firstname = "Enter your first name:",
      prompt_name = "Enter your last name:",
      prompt_age = "Enter your age:",
    },
    menu = {
      title = "Your Identity Card",
      info = "<em>Name: </em>{1}<br /><em>First name: </em>{2}<br /><em>Age: </em>{3}<br /><em>Registration: </em>{4}<br /><em>Phone: </em>{5}<br /><em>Address: </em>{7}, {6}<br /><em>Firearm License: </em>{8}<br /><em>Driver License: </em>{9}<br /><em>Pilot License: </em>{10}<br /><em>Bar Certification: </em>{11}"
    }
  },
  police = {
    title = "Police",
    wanted = "Wanted rank {1}",
    not_handcuffed = "Not handcuffed",
    cloakroom = {
      title = "Cloakroom",
      uniform = {
        title = "Uniform",
        description = "Put uniform."
      }
    },
    pc = {
      title = "PC",
      searchreg = {
        title = "Registration search",
        description = "Search identity by registration.",
        prompt = "Enter registration number:"
      },
      closebusiness = {
        title = "Close business",
        description = "Close business of the nearest player.",
        request = "Are you sure to close the business {3} owned by {1} {2} ?",
        closed = "~g~Business closed."
      },
      trackveh = {
        title = "Track vehicle",
        description = "Track a vehicle by its registration number.",
        prompt_reg = "Enter registration number:",
        prompt_note = "Enter a tracking note/reason:",
        tracking = "Tracking started.",
        track_failed = "Tracking of {1} ({2}) Failed.",
        tracked = "Tracked {1} ({2})"
      },
      records = {
        show = {
          title = "Show records",
          description = "Show police records by registration number."
        },
        delete = {
          title = "Clear records",
          description = "Clear police records by registration number.",
          deleted = "Police records deleted"
        }
      }
    },
    menu = {
      handcuff = {
        title = "Handcuff",
        description = "Handcuff/unhandcuff nearest player."
      },
      shackle = {
        title = "Shackle",
        description = "Shackle/unshackle nearest player in handcuffs."
      },
      putinveh = {
        title = "Put in vehicle",
        description = "Put the nearest handcuffed player in the nearest owned vehicle, as passenger."
      },
      pulloutveh = {
        title = "Pull out of vehicle",
        description = "Pull the nearest player out of the nearest vehicle."
      },
      getoutveh = {
        title = "Get out vehicle",
        description = "Get out of vehicle the nearest handcuffed player."
      },
      impoundveh = {
        title = "Impound vehicle",
        description = "Impound the nearest vehicle."
      },
      askid = {
        title = "Ask player for ID",
        description = "Ask for the ID card of the nearest player.",
        request = "Do you want to give your ID card ?",
        request_hide = "Hide the ID card.",
        asked = "Asking ID..."
      },
      check = {
        title = "Check player",
        description = "Check money, inventory and weapons of the nearest player.",
        request_hide = "Hide the check report.",
        info = "<em>Money: </em>{1} $<br /><br /><em>Inventory: </em>{2}<br /><br /><em>Weapons: </em>{3}<br /><br /><em>Shared Key Chain: </em>{4}",
        checked = "You have been checked."
      },
      check_vehicle = {
        title = "Search Vehicle",
        description = "Search the nearest player owned vehicle.",
        request_hide = "Hide the vehicle report.",
        info = "<em>inventory: </em>{1}"
      },
      seize = {
        seized = "Seized {2} {1}",
        weapons = {
          title = "Seize weapons",
          description = "Seize nearest player weapons",
          seized = "Your weapons have been seized."
        },
        items = {
          title = "Seize illegals",
          description = "Seize illegal items",
          seized = "Your illegal stuff has been seized."
        }
      },
      jail = {
        title = "Jail",
        description = "Jail/UnJail nearest player in/from the nearest jail.",
        not_found = "No jail found.",
        jailed = "Jailed.",
        unjailed = "Unjailed.",
        notify_jailed = "You have been jailed.",
        notify_unjailed = "You have been unjailed."
      },
      escort = {
        title = "Escort",
        description = "Escort/Un-Escort the nearest player.",
        escorted = "Escorting.",
        unescorted = "Stopped Escorting."
      },
      fine = {
        title = "Fine",
        description = "Fine the nearest player.",
        fined = "Fined ${1}.",
        notify_fined = "You have been fined  ${1}.",
        record = "[Fine] ${2} for {1}",
        prompt_pay = "Pay fine in the amount of ${1}.",
        prompt_amount = "Enter fine amount."
      },
      store_weapons = {
        title = "Store weapons",
        description = "Store your weapons in your inventory."
      },
      prison = {
        title = "Send to prison",
        prompt = "Time in minutes to send player to prison (max = 45)",
        description = "Send the nearest jailed player to prison. Can also release from prison.",
        imprisoned = "Imprisoned.",
        released = "Release.",
        notify_prison = "You have been sent to prison.",
        notify_unprison = "You have been release from prison."
      },
      seize_vehicle = {
        title = "Seize Vehicle",
        description = "Seize the nearest player's vehicle. Be sure to make sure the vehicle's owner is the nearest player to you!!"
      },
      seize_driverlicense = {
        title = "Revoke Driver License",
        description = "Revoke the nearest player's Driver License."
      },
      seize_firearmlicense = {
        title = "Revoke Firearm License",
        description = "Revoke the nearest player's Firearm License."
      },
    },
    identity = {
      info = "<em>Name: </em>{1}<br /><em>First name: </em>{2}<br /><em>Age: </em>{3}<br /><em>Registration: </em>{4}<br /><em>Phone: </em>{5}<br /><em>Business: </em>{6}<br /><em>Address: </em>{9}, {8}<br /><em>Firearm License: </em>{10}<br /><em>Driver License: </em>{11}<br /><em>Pilot License: </em>{12}<br /><em>Bar Certified: </em>{13}"
    },
    prison = {
      info = "<em>Confirm your paperwork before sending to prison</em><br /><br /><em>Prison Time (minutes): </em>{1}<br /><em>Mandatory Fine: </em>${2}<br />"
    }
  },
  emergency = {
    menu = {
      revive = {
        title = "Reanimate",
        description = "Reanimate the nearest player.",
        not_in_coma = "Not in coma."
      }
    }
  },
  phone = {
    title = "Phone",
    directory = {
      title = "Directory",
      description = "Open the phone directory.",
      add = {
        title = "> Add",
        prompt_number = "Enter the phone number to add:",
        prompt_name = "Enter the entry name:",
        added = "Entry added."
      },
      sendsms = {
        title = "Send SMS",
        prompt = "Enter the message (max {1} chars):",
        sent = "Sent to {1}.",
        not_sent = "{1} is unavailable."
      },
      sendpos = {
        title = "Send position",
      },
      remove = {
        title = "Remove"
      }
    },
    sms = {
      title = "SMS History",
      description = "Received SMS history.",
      info = "<em>{1}</em><br /><br />{2}",
      notify = "SMS {1}: {2}"
    },
    smspos = {
      notify = "SMS-Position  {1}"
    },
    service = {
      title = "Service",
      description = "Call a service or an emergency number.",
      prompt = "If needed, enter a message for the service:",
      ask_call = "Received {1} call, do you take it ? <em>{2}</em>",
      taken = "This call is already taken."
    },
    announce = {
      title = "Announcement",
      description = "Post an announcement visible to everyone for a few seconds.",
      item_desc = "{1} $<br /><br/>{2}",
      prompt = "Announcement content (10-1000 chars): "
    },
  },
  emotes = {
    title = "Emotes",
    clear = {
      title = "> Clear",
      description = "Clear all running emotes."
    }
  },
  home = {
    buy = {
      title = "Buy",
      description = "Buy an apartment for ${1}.",
      bought = "You have purchased a new apartment!",
      full = "The place is full.",
      have_home = "You already have a home."
    },
    sell = {
      title = "Sell",
      description = "Sell your apartment for ${1}",
      sold = "You have sold your apartment.",
      no_home = "You don't have a home here."
    },
    intercom = {
      title = "Intercom",
      description = "Use the intercom to enter a home.",
      prompt = "Apartment Number:",
      not_available = "The home owner is not available.",
      refused = "Refused to enter.",
      prompt_who = "Say who you are:",
      asked = "Asking...",
      request = "Someone wants to open your home door: <em>{1}</em>"
    },
    slot = {
      leave = {
        title = "Leave"
      },
      ejectall = {
        title = "Eject all",
        description = "Eject all home visitors, including you, and close the home."
      }
    },
    wardrobe = {
      title = "Wardrobe",
      save = {
        title = "> Save",
        prompt = "Save name:"
      }
    },
    gametable = {
      title = "Game table",
      bet = {
        title = "Start bet",
        description = "Start a bet with players near you, the winner will be randomly selected.",
        prompt = "Bet amount:",
        request = "[BET] Do you want to bet ${1}?",
        started = "Bet started."
      }
    }
  },
	business = {
		buy = {
			title = "Buy",
			description = "Start a business for ${1}.",
			bought = "You have started a new business!",
			full = "The place is full.",
			have_home = "You already own a business."
		},
		sell = {
			title = "Sell",
			description = "Sell your business for ${1}",
			sold = "You have sold your business.",
			no_home = "You don't own a business."
		},
		intercom = {
			title = "Intercom",
			description = "Use the intercom to enter an office.",
			prompt = "Office Number:",
			not_available = "This business is not open.",
			refused = "Refused to enter.",
			prompt_who = "Say who you are:",
			asked = "Asking...",
			request = "Someone wants to enter your office: <em>{1}</em>"
		},
		slot = {
			leave = {
				title = "Leave"
			},
			ejectall = {
				title = "Eject all",
				description = "Eject all office visitors, including you, and close the office."
			}
		},
		wardrobe = {
			title = "Wardrobe",
			save = {
				title = "> Save",
				prompt = "Save name:"
			}
		},
		gametable = {
			title = "Game table",
			bet = {
				title = "Start bet",
				description = "Start a bet with players near you, the winner will be randomly selected.",
				prompt = "Bet amount:",
				request = "[BET] Do you want to bet ${1}?",
				started = "Bet started."
			}
		},
		management = {
			title = "Business Management",
			hire = {
				title = "Hire an employee",
				hireprompt = "Player ID:",
				prompt = "Company {1} has sent you a job offer. Do you accept it?"
			},
			fire = {
				title = "Fire an employee",
				fireprompt = "Employee ID:",
				prompt = "Are you sure you wish to fire employee {1}?"
			},
			list = {
				title = "Employee List",
				info = "{1}"
			},
			order = "Order supplies",
			money = "Business financials"
		}
	},
  garage = {
    title = "Garage ({1})",
    owned = {
      title = "Owned",
      description = "Owned vehicles."
    },
    buy = {
      title = "Buy",
      description = "Buy vehicles.",
      info = "{1} $<br /><br />{2}"
    },
    sell = {
      title = "Sell",
      description = "Sell vehicles."
    },
    rent = {
      title = "Rent",
      description = "Rent a vehicle for the session (until you disconnect)."
    },
    store = {
      title = "Store",
      description = "Put your current vehicle in the garage."
    }
  },
  vehicle = {
    title = "Vehicle",
    no_owned_near = "No owned vehicle near.",
    trunk = {
      title = "Trunk",
      description = "Open the vehicle trunk."
    },
    detach_trailer = {
      title = "Detach trailer",
      description = "Detach trailer."
    },
    detach_towtruck = {
      title = "Detach tow truck",
      description = "Detach tow truck."
    },
    detach_cargobob = {
      title = "Detach cargobob",
      description = "Detach cargobob."
    },
    lock = {
      title = "Lock/unlock",
      description = "Lock or unlock the vehicle."
    },
    engine = {
      title = "Engine on/off",
      description = "Start or stop the engine."
    },
    asktrunk = {
      title = "Ask open trunk",
      asked = "Asking...",
      request = "Do you want to open the trunk ?"
    },
    replace = {
      title = "Replace vehicle",
      description = "Replace on ground the nearest vehicle."
    },
    repair = {
      title = "Repair vehicle",
      description = "Repair the nearest vehicle."
    }
  },
  gunshop = {
    title = "Gunshop ({1})",
    prompt_ammo = "Amount of ammo to buy for the {1}:",
    info = "<em>body: </em> {1} $<br /><em>ammo: </em> {2} $/u<br /><br />{3}"
  },
  market = {
    title = "Market ({1})",
    prompt = "Amount of {1} to buy:",
    prompt_sell = "Amount of {1} to sell:",
    info = "{1} $<br /><br />{2}"
  },
  skinshop = {
    title = "Skinshop"
  },
  cloakroom = {
    title = "Cloakroom ({1})",
    undress = {
      title = "> Undress"
    }
  },
  itemtr = {
    informer = {
      title = "Illegal Informer",
      description = "{1} $",
      bought = "Position sent to your GPS."
    }
  },
  mission = {
    blip = "Mission ({1}) {2}/{3}",
    display = "<span class=\"name\">{1}</span> <span class=\"step\">{2}/{3}</span><br /><br />{4}",
    cancel = {
      title = "Cancel mission"
    }
  },
  aptitude = {
    title = "Aptitudes",
    description = "Show/Hide aptitudes.",
    lose_exp = "Aptitude {1}/{2} -{3} exp.",
    earn_exp = "Aptitude {1}/{2} +{3} exp.",
    level_down = "Aptitude {1}/{2} lose level ({3}).",
    level_up = "Aptitude {1}/{2} level up ({3}).",
    display = {
      group = "{1}: ",
      aptitude = "{1} LVL {3} EXP {2}"
    }
  }
}

return lang
