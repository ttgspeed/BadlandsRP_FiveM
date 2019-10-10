-- Menu configuration, array of menus to display
local isCop = false
local isMedic = false
local isTowDriver = false

RegisterNetEvent("menu:setCop")
AddEventHandler("menu:setCop", function(toggle)
  isCop = toggle
end)

RegisterNetEvent("menu:setEms")
AddEventHandler("menu:setEms", function(toggle)
  isMedic = toggle
end)

RegisterNetEvent("menu:setTowDriver")
AddEventHandler("menu:setTowDriver", function(toggle)
  isTowDriver = toggle
end)

menuConfigs = {
    ['civ-out-veh'] = {
        enableMenu = function()                     -- Function to enable/disable menu handling
          if not isTowDriver and not isCop and not isMedic then
            local player = GetPlayerPed(-1)
            return IsPedOnFoot(player)
          end
          return false
        end,
        data = {                                    -- Data that is passed to Javascript
            keybind = "M",                         -- Wheel keybind to use (case sensitive, must match entry in keybindControls table)
            style = {                               -- Wheel style settings
                sizePx = 600,                       -- Wheel size in pixels
                slices = {                          -- Slice style settings
                    default = { ['fill'] = '#000000', ['stroke'] = '#000000', ['stroke-width'] = 2, ['opacity'] = 0.60 },
                    hover = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 2, ['opacity'] = 0.80 },
                    selected = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 2, ['opacity'] = 0.80 }
                },
                titles = {                          -- Text style settings
                    default = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    hover = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    selected = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' }
                },
                icons = {
                    width = 64,
                    height = 64
                }
            },
            wheels = {                              -- Array of wheels to display
                {
                    navAngle = 270,                 -- Oritentation of wheel
                    minRadiusPercent = 0.3,         -- Minimum radius of wheel in percentage
                    maxRadiusPercent = 0.6,         -- Maximum radius of wheel in percentage
                    labels = {"INVENTORY", "WALLET", "EMOTES", "APTITUDES", "VEHICLE"},
                    commands = {"none", "walletSubMenu", "emoteSubMenu", "none", "externalVehSubMenu"},
                    triggers = {"openInventory", "none", "none", "viewAptitudes", "none" }
                },
                --{
                --    navAngle = 285,                 -- Oritentation of wheel
                --    minRadiusPercent = 0.6,         -- Minimum radius of wheel in percentage
                --    maxRadiusPercent = 0.9,         -- Maximum radius of wheel in percentage
                --    labels = {"SALUTE", "FINGER", "PEACE", "FACEPALM", "DAMN", "FAIL", "DEAD", "GANG1", "GANG2", "COP", "HOLSTER", "CROWDS"},
                --    commands = {"e salute", "e finger", "e peace", "e palm", "e damn", "e fail", "e dead", "e gang1", "e gang2", "e copidle", "e holster", "e copcrowd2"}
                --}
            }
        }
    },
    ['tow-out-veh'] = {
        enableMenu = function()                     -- Function to enable/disable menu handling
          if isTowDriver and not isCop and not isMedic then
            local player = GetPlayerPed(-1)
            return IsPedOnFoot(player)
          end
          return false
        end,
        data = {                                    -- Data that is passed to Javascript
            keybind = "M",                         -- Wheel keybind to use (case sensitive, must match entry in keybindControls table)
            style = {                               -- Wheel style settings
                sizePx = 600,                       -- Wheel size in pixels
                slices = {                          -- Slice style settings
                    default = { ['fill'] = '#000000', ['stroke'] = '#000000', ['stroke-width'] = 2, ['opacity'] = 0.60 },
                    hover = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 2, ['opacity'] = 0.80 },
                    selected = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 2, ['opacity'] = 0.80 }
                },
                titles = {                          -- Text style settings
                    default = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    hover = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    selected = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' }
                },
                icons = {
                    width = 64,
                    height = 64
                }
            },
            wheels = {                              -- Array of wheels to display
                {
                    navAngle = 270,                 -- Oritentation of wheel
                    minRadiusPercent = 0.3,         -- Minimum radius of wheel in percentage
                    maxRadiusPercent = 0.6,         -- Maximum radius of wheel in percentage
                    labels = {"INVENTORY", "WALLET", "EMOTES", "APTITUDES", "VEHICLE", "TOW", "REQUEST JOB"},
                    commands = {"none", "walletTowSubMenu", "emoteSubMenu", "none", "externalTowVehSubMenu", "none", "none"},
                    triggers = {"openInventory", "none", "none", "viewAptitudes", "none", "toggleTow", "findParkedVeh"}
                },
                --{
                --    navAngle = 285,                 -- Oritentation of wheel
                --    minRadiusPercent = 0.6,         -- Minimum radius of wheel in percentage
                --    maxRadiusPercent = 0.9,         -- Maximum radius of wheel in percentage
                --    labels = {"SALUTE", "FINGER", "PEACE", "FACEPALM", "DAMN", "FAIL", "DEAD", "GANG1", "GANG2", "COP", "HOLSTER", "CROWDS"},
                --    commands = {"e salute", "e finger", "e peace", "e palm", "e damn", "e fail", "e dead", "e gang1", "e gang2", "e copidle", "e holster", "e copcrowd2"}
                --}
            }
        }
    },
    ['cop-out-veh'] = {
        enableMenu = function()                     -- Function to enable/disable menu handling
          if not isTowDriver and isCop and not isMedic then
            local player = GetPlayerPed(-1)
            return IsPedOnFoot(player)
          end
          return false
        end,
        data = {                                    -- Data that is passed to Javascript
            keybind = "M",                         -- Wheel keybind to use (case sensitive, must match entry in keybindControls table)
            style = {                               -- Wheel style settings
                sizePx = 600,                       -- Wheel size in pixels
                slices = {                          -- Slice style settings
                    default = { ['fill'] = '#000000', ['stroke'] = '#000000', ['stroke-width'] = 2, ['opacity'] = 0.60 },
                    hover = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 2, ['opacity'] = 0.80 },
                    selected = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 2, ['opacity'] = 0.80 }
                },
                titles = {                          -- Text style settings
                    default = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    hover = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    selected = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' }
                },
                icons = {
                    width = 64,
                    height = 64
                }
            },
            wheels = {                              -- Array of wheels to display
                {
                    navAngle = 270,                 -- Oritentation of wheel
                    minRadiusPercent = 0.3,         -- Minimum radius of wheel in percentage
                    maxRadiusPercent = 0.6,         -- Maximum radius of wheel in percentage
                    labels = {"INVENTORY", "WALLET", "EMOTES", "APTITUDES", "VEHICLE", "POLICE"},
                    commands = {"none", "walletPoliceSubMenu", "emoteSubMenu", "none", "externalCopVehSubMenu", "policeSubMenu"},
                    triggers = {"openInventory", "none", "none", "viewAptitudes", "none", "none" }
                },
                --{
                --    navAngle = 285,                 -- Oritentation of wheel
                --    minRadiusPercent = 0.6,         -- Minimum radius of wheel in percentage
                --    maxRadiusPercent = 0.9,         -- Maximum radius of wheel in percentage
                --    labels = {"SALUTE", "FINGER", "PEACE", "FACEPALM", "DAMN", "FAIL", "DEAD", "GANG1", "GANG2", "COP", "HOLSTER", "CROWDS"},
                --    commands = {"e salute", "e finger", "e peace", "e palm", "e damn", "e fail", "e dead", "e gang1", "e gang2", "e copidle", "e holster", "e copcrowd2"}
                --}
            }
        }
    },
    ['ems-out-veh'] = {
        enableMenu = function()                     -- Function to enable/disable menu handling
          if not isTowDriver and not isCop and isMedic then
            local player = GetPlayerPed(-1)
            return IsPedOnFoot(player)
          end
          return false
        end,
        data = {                                    -- Data that is passed to Javascript
            keybind = "M",                         -- Wheel keybind to use (case sensitive, must match entry in keybindControls table)
            style = {                               -- Wheel style settings
                sizePx = 600,                       -- Wheel size in pixels
                slices = {                          -- Slice style settings
                    default = { ['fill'] = '#000000', ['stroke'] = '#000000', ['stroke-width'] = 2, ['opacity'] = 0.60 },
                    hover = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 2, ['opacity'] = 0.80 },
                    selected = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 2, ['opacity'] = 0.80 }
                },
                titles = {                          -- Text style settings
                    default = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    hover = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    selected = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' }
                },
                icons = {
                    width = 64,
                    height = 64
                }
            },
            wheels = {                              -- Array of wheels to display
                {
                    navAngle = 270,                 -- Oritentation of wheel
                    minRadiusPercent = 0.3,         -- Minimum radius of wheel in percentage
                    maxRadiusPercent = 0.6,         -- Maximum radius of wheel in percentage
                    labels = {"INVENTORY", "WALLET", "EMOTES", "APTITUDES", "VEHICLE", "MEDICAL"},
                    commands = {"none", "walletMedSubMenu", "emoteSubMenu", "none", "externalMedVehSubMenu", "medSubMenu"},
                    triggers = {"openInventory", "none", "none", "viewAptitudes", "none", "none" }
                },
                --{
                --    navAngle = 285,                 -- Oritentation of wheel
                --    minRadiusPercent = 0.6,         -- Minimum radius of wheel in percentage
                --    maxRadiusPercent = 0.9,         -- Maximum radius of wheel in percentage
                --    labels = {"SALUTE", "FINGER", "PEACE", "FACEPALM", "DAMN", "FAIL", "DEAD", "GANG1", "GANG2", "COP", "HOLSTER", "CROWDS"},
                --    commands = {"e salute", "e finger", "e peace", "e palm", "e damn", "e fail", "e dead", "e gang1", "e gang2", "e copidle", "e holster", "e copcrowd2"}
                --}
            }
        }
    },
    ['vehicles-civ'] = {                                -- Example menu for vehicle controls when player is in a vehicle
        enableMenu = function()
          if not isTowDriver and not isCop and not isMedic then                    -- Function to enable/disable menu handling
            local player = GetPlayerPed(-1)
            return IsPedInAnyVehicle(player, false)
          end
          return false
        end,
        data = {                                    -- Data that is passed to Javascript
            keybind = "M",                         -- Wheel keybind to use (case sensitive, must match entry in keybindControls table)
            style = {                               -- Wheel style settings
                sizePx = 400,                       -- Wheel size in pixels
                slices = {                          -- Slice style settings
                    default = { ['fill'] = '#000000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.60 },
                    hover = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 },
                    selected = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 }
                },
                titles = {                          -- Text style settings
                    default = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    hover = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    selected = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' }
                },
                icons = {
                    width = 64,
                    height = 64
                }
            },
            wheels = {                              -- Array of wheels to display
                {
                    navAngle = 270,                 -- Oritentation of wheel
                    minRadiusPercent = 0.4,         -- Minimum radius of wheel in percentage
                    maxRadiusPercent = 0.9,         -- Maximum radius of wheel in percentage
                    labels = {"imgsrc:engine.png", "imgsrc:key.png", "imgsrc:doors.png", "DOME LIGHT", "WINDOWS", "SEATBELT", "INVENTORY"},
                    commands = {"none", "none", "vehDoorSubMenu", "none", "none", "none", "none"},
                    triggers = {"toggleEngine", "togglelock", "none", "toggleDomeLight", "toggleWindows", "toggleSeatBelt", "openInventory"}
                }
            }
        }
    },
    ['vehicles-tow'] = {                                -- Example menu for vehicle controls when player is in a vehicle
        enableMenu = function()
          if isTowDriver and not isCop and not isMedic then                   -- Function to enable/disable menu handling
            local player = GetPlayerPed(-1)
            return IsPedInAnyVehicle(player, false)
          end
          return false
        end,
        data = {                                    -- Data that is passed to Javascript
            keybind = "M",                         -- Wheel keybind to use (case sensitive, must match entry in keybindControls table)
            style = {                               -- Wheel style settings
                sizePx = 400,                       -- Wheel size in pixels
                slices = {                          -- Slice style settings
                    default = { ['fill'] = '#000000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.60 },
                    hover = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 },
                    selected = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 }
                },
                titles = {                          -- Text style settings
                    default = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    hover = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    selected = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' }
                },
                icons = {
                    width = 64,
                    height = 64
                }
            },
            wheels = {                              -- Array of wheels to display
                {
                    navAngle = 270,                 -- Oritentation of wheel
                    minRadiusPercent = 0.4,         -- Minimum radius of wheel in percentage
                    maxRadiusPercent = 0.9,         -- Maximum radius of wheel in percentage
                    labels = {"imgsrc:engine.png", "imgsrc:key.png", "imgsrc:doors.png", "DOME LIGHT", "WINDOWS", "SEATBELT", "INVENTORY", "REQUEST JOB"},
                    commands = {"none", "none", "vehDoorSubMenu", "none", "none", "none", "none", "none"},
                    triggers = {"toggleEngine", "togglelock", "none", "toggleDomeLight", "toggleWindows", "toggleSeatBelt", "openInventory", "findParkedVeh"}
                }
            }
        }
    },
    ['vehicles-cop'] = {                                -- Example menu for vehicle controls when player is in a vehicle
        enableMenu = function()
          if not isTowDriver and isCop and not isMedic then                    -- Function to enable/disable menu handling
            local player = GetPlayerPed(-1)
            return IsPedInAnyVehicle(player, false)
          end
          return false
        end,
        data = {                                    -- Data that is passed to Javascript
            keybind = "M",                         -- Wheel keybind to use (case sensitive, must match entry in keybindControls table)
            style = {                               -- Wheel style settings
                sizePx = 400,                       -- Wheel size in pixels
                slices = {                          -- Slice style settings
                    default = { ['fill'] = '#000000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.60 },
                    hover = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 },
                    selected = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 }
                },
                titles = {                          -- Text style settings
                    default = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    hover = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    selected = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' }
                },
                icons = {
                    width = 64,
                    height = 64
                }
            },
            wheels = {                              -- Array of wheels to display
                {
                    navAngle = 270,                 -- Oritentation of wheel
                    minRadiusPercent = 0.4,         -- Minimum radius of wheel in percentage
                    maxRadiusPercent = 0.9,         -- Maximum radius of wheel in percentage
                    labels = {"imgsrc:engine.png", "imgsrc:key.png", "imgsrc:doors.png", "DOME LIGHT", "WINDOWS", "SEATBELT", "INVENTORY", "MDT"},
                    commands = {"none", "none", "vehDoorPoliceSubMenu", "none", "none", "none", "none", "vehMdtPoliceSubMenu"},
                    triggers = {"toggleEngine", "togglelock", "none", "toggleDomeLight", "toggleWindows", "toggleSeatBelt", "openInventory", "none"}
                }
            }
        }
    },
    ['vehicles-ems'] = {                                -- Example menu for vehicle controls when player is in a vehicle
        enableMenu = function()
          if not isTowDriver and not isCop and isMedic then                    -- Function to enable/disable menu handling
            local player = GetPlayerPed(-1)
            return IsPedInAnyVehicle(player, false)
          end
          return false
        end,
        data = {                                    -- Data that is passed to Javascript
            keybind = "M",                         -- Wheel keybind to use (case sensitive, must match entry in keybindControls table)
            style = {                               -- Wheel style settings
                sizePx = 400,                       -- Wheel size in pixels
                slices = {                          -- Slice style settings
                    default = { ['fill'] = '#000000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.60 },
                    hover = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 },
                    selected = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 }
                },
                titles = {                          -- Text style settings
                    default = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    hover = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    selected = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' }
                },
                icons = {
                    width = 64,
                    height = 64
                }
            },
            wheels = {                              -- Array of wheels to display
                {
                    navAngle = 270,                 -- Oritentation of wheel
                    minRadiusPercent = 0.4,         -- Minimum radius of wheel in percentage
                    maxRadiusPercent = 0.9,         -- Maximum radius of wheel in percentage
                    labels = {"imgsrc:engine.png", "imgsrc:key.png", "imgsrc:doors.png", "DOME LIGHT", "WINDOWS", "SEATBELT", "INVENTORY", "MDT", "DISPATCH JOB"},
                    commands = {"none", "none", "vehDoorMedicalSubMenu", "none", "none", "none", "none", "none", "none"},
                    triggers = {"toggleEngine", "togglelock", "none", "toggleDomeLight", "toggleWindows", "toggleSeatBelt", "openInventory", "emsMobileTerminal", "toggleEmsDispatch"}
                }
            }
        }
    }
}

-- Submenu configuration
subMenuConfigs = {
    ['walletSubMenu'] = {
        data = {
            keybind = "M",
            style = {
                sizePx = 600,
                slices = {
                    default = { ['fill'] = '#000000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.60 },
                    hover = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 },
                    selected = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 }
                },
                titles = {
                    default = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    hover = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    selected = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' }
                },
                icons = {
                    width = 64,
                    height = 64
                }
            },
            wheels = {
                {
                  navAngle = 270,
                  minRadiusPercent = 0.25,
                  maxRadiusPercent = 0.55,
                  labels = {"INVENTORY", "WALLET", "EMOTES", "APTITUDES", "VEHICLE"},
                  commands = {"none", "walletSubMenu", "emoteSubMenu", "none", "externalVehSubMenu"},
                  triggers = {"openInventory", "none", "none", "viewAptitudes", "none" }
                },
                {
                    navAngle = 270,
                    minRadiusPercent = 0.6,
                    maxRadiusPercent = 0.9,
                    labels = {"Give ID", "Give Money", "ID Card"},
                    commands = {"none", "none", "none"},
                    triggers = {"giveId", "giveMoney", "viewOwnID"}
                }
            }
        }
    },
    ['walletTowSubMenu'] = {
        data = {
            keybind = "M",
            style = {
                sizePx = 600,
                slices = {
                    default = { ['fill'] = '#000000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.60 },
                    hover = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 },
                    selected = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 }
                },
                titles = {
                    default = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    hover = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    selected = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' }
                },
                icons = {
                    width = 64,
                    height = 64
                }
            },
            wheels = {
                {
                  navAngle = 270,
                  minRadiusPercent = 0.25,
                  maxRadiusPercent = 0.55,
                  labels = {"INVENTORY", "WALLET", "EMOTES", "APTITUDES", "VEHICLE", "TOW"},
                  commands = {"none", "walletSubMenu", "emoteSubMenu", "none", "externalVehSubMenu", "none"},
                  triggers = {"openInventory", "none", "none", "viewAptitudes", "none", "toggleTow" }
                },
                {
                    navAngle = 270,
                    minRadiusPercent = 0.6,
                    maxRadiusPercent = 0.9,
                    labels = {"Give ID", "Give Money", "ID Card"},
                    commands = {"none", "none", "none"},
                    triggers = {"giveId", "giveMoney", "viewOwnID"}
                }
            }
        }
    },
    ['walletPoliceSubMenu'] = {
        data = {
            keybind = "M",
            style = {
                sizePx = 600,
                slices = {
                    default = { ['fill'] = '#000000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.60 },
                    hover = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 },
                    selected = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 }
                },
                titles = {
                    default = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    hover = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    selected = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' }
                },
                icons = {
                    width = 64,
                    height = 64
                }
            },
            wheels = {
                {
                  navAngle = 270,
                  minRadiusPercent = 0.25,
                  maxRadiusPercent = 0.55,
                  labels = {"INVENTORY", "WALLET", "EMOTES", "APTITUDES", "VEHICLE", "POLICE"},
                  commands = {"none", "walletSubMenu", "emoteSubMenu", "none", "externalCopVehSubMenu", "policeSubMenu"},
                  triggers = {"openInventory", "none", "none", "viewAptitudes", "none", "none" }
                },
                {
                    navAngle = 270,
                    minRadiusPercent = 0.6,
                    maxRadiusPercent = 0.9,
                    labels = {"Give ID", "Give Money", "ID Card"},
                    commands = {"none", "none", "none"},
                    triggers = {"giveId", "giveMoney", "viewOwnID"}
                }
            }
        }
    },
    ['walletMedSubMenu'] = {
        data = {
            keybind = "M",
            style = {
                sizePx = 600,
                slices = {
                    default = { ['fill'] = '#000000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.60 },
                    hover = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 },
                    selected = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 }
                },
                titles = {
                    default = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    hover = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    selected = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' }
                },
                icons = {
                    width = 64,
                    height = 64
                }
            },
            wheels = {
                {
                  navAngle = 270,
                  minRadiusPercent = 0.25,
                  maxRadiusPercent = 0.55,
                  labels = {"INVENTORY", "WALLET", "EMOTES", "APTITUDES", "VEHICLE", "MEDICAL"},
                  commands = {"none", "walletSubMenu", "emoteSubMenu", "none", "externalMedVehSubMenu", "medSubMenu"},
                  triggers = {"openInventory", "none", "none", "viewAptitudes", "none", "none" }
                },
                {
                    navAngle = 270,
                    minRadiusPercent = 0.6,
                    maxRadiusPercent = 0.9,
                    labels = {"Give ID", "Give Money", "ID Card"},
                    commands = {"none", "none", "none"},
                    triggers = {"giveId", "giveMoney", "viewOwnID"}
                }
            }
        }
    },
    ['emoteSubMenu'] = {
        data = {
            keybind = "M",
            style = {
                sizePx = 600,
                slices = {
                    default = { ['fill'] = '#000000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.60 },
                    hover = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 },
                    selected = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 }
                },
                titles = {
                    default = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    hover = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    selected = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' }
                },
                icons = {
                    width = 64,
                    height = 64
                }
            },
            wheels = {
                {
                  navAngle = 270,
                  minRadiusPercent = 0.25,
                  maxRadiusPercent = 0.55,
                  labels = {"INVENTORY", "WALLET", "EMOTES", "APTITUDES", "VEHICLE"},
                  commands = {"none", "walletSubMenu", "emoteSubMenu", "none", "externalVehSubMenu"},
                  triggers = {"openInventory", "none", "none", "viewAptitudes", "none" }
                },
                {
                    navAngle = 270,
                    minRadiusPercent = 0.6,
                    maxRadiusPercent = 0.9,
                    labels = {"Emote 1", "Emote 2", "Emote 3"},
                    commands = {"none", "none", "none"},
                    triggers = {"none", "none", "none"}
                }
            }
        }
    },
    ['externalVehSubMenu'] = {
        data = {
            keybind = "M",
            style = {
                sizePx = 600,
                slices = {
                    default = { ['fill'] = '#000000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.60 },
                    hover = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 },
                    selected = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 }
                },
                titles = {
                    default = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    hover = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    selected = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' }
                },
                icons = {
                    width = 64,
                    height = 64
                }
            },
            wheels = {
                {
                  navAngle = 270,
                  minRadiusPercent = 0.25,
                  maxRadiusPercent = 0.55,
                  labels = {"INVENTORY", "WALLET", "EMOTES", "APTITUDES", "VEHICLE"},
                  commands = {"none", "walletSubMenu", "emoteSubMenu", "none", "externalVehSubMenu"},
                  triggers = {"openInventory", "none", "none", "viewAptitudes", "none" }
                },
                {
                    navAngle = 270,
                    minRadiusPercent = 0.6,
                    maxRadiusPercent = 0.9,
                    labels = {"GIVE KEYS", "TOGGLE LOCKS", "TRUNK", "REPAIR"},
                    commands = {"none", "none", "none", "none"},
                    triggers = {"giveVehicleKeys", "togglelock", "accessTrunk", "repairVehicle"}
                }
            }
        }
    },
    ['externalTowVehSubMenu'] = {
        data = {
            keybind = "M",
            style = {
                sizePx = 600,
                slices = {
                    default = { ['fill'] = '#000000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.60 },
                    hover = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 },
                    selected = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 }
                },
                titles = {
                    default = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    hover = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    selected = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' }
                },
                icons = {
                    width = 64,
                    height = 64
                }
            },
            wheels = {
                {
                  navAngle = 270,
                  minRadiusPercent = 0.25,
                  maxRadiusPercent = 0.55,
                  labels = {"INVENTORY", "WALLET", "EMOTES", "APTITUDES", "VEHICLE", "TOW"},
                  commands = {"none", "walletSubMenu", "emoteSubMenu", "none", "externalTowVehSubMenu", "none"},
                  triggers = {"openInventory", "none", "none", "viewAptitudes", "none", "toggleTow" }
                },
                {
                    navAngle = 270,
                    minRadiusPercent = 0.6,
                    maxRadiusPercent = 0.9,
                    labels = {"GIVE KEYS", "TOGGLE LOCKS", "TRUNK", "REPAIR"},
                    commands = {"none", "none", "none", "none"},
                    triggers = {"giveVehicleKeys", "togglelock", "accessTrunk", "repairVehicle"}
                }
            }
        }
    },
    ['policeSubMenu'] = {
        data = {
            keybind = "M",
            style = {
                sizePx = 600,
                slices = {
                    default = { ['fill'] = '#000000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.60 },
                    hover = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 },
                    selected = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 }
                },
                titles = {
                    default = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    hover = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    selected = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' }
                },
                icons = {
                    width = 64,
                    height = 64
                }
            },
            wheels = {
                {
                  navAngle = 270,
                  minRadiusPercent = 0.25,
                  maxRadiusPercent = 0.55,
                  labels = {"INVENTORY", "WALLET", "EMOTES", "APTITUDES", "VEHICLE", "POLICE"},
                  commands = {"none", "walletPoliceSubMenu", "emoteSubMenu", "none", "externalCopVehSubMenu", "policeSubMenu"},
                  triggers = {"openInventory", "none", "none", "viewAptitudes", "none", "none"}
                },
                {
                    navAngle = 270,
                    minRadiusPercent = 0.6,
                    maxRadiusPercent = 0.9,
                    labels = {"HANDCUFFS", "ESCORT", "PUT IN CAR", "PULL OUT", "SPIKE STRIP", "WEAPON STORAGE", "MDT", "PLAYER ACTIONS", "VEHICLE ACTIONS"},
                    commands = {"none", "none", "none", "none", "none", "weaponStoreSubMenu", "mdtSubMenu", "playerActionSubMenu", "vehicleActionSubMenu"},
                    triggers = {"toggleRestraints", "escortTarget", "copPutInCar", "pullOutVeh", "spikeStrip", "none", "none", "none", "none"}
                }
            }
        }
    },
    ['externalCopVehSubMenu'] = {
        data = {
            keybind = "M",
            style = {
                sizePx = 600,
                slices = {
                    default = { ['fill'] = '#000000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.60 },
                    hover = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 },
                    selected = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 }
                },
                titles = {
                    default = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    hover = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    selected = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' }
                },
                icons = {
                    width = 64,
                    height = 64
                }
            },
            wheels = {
                {
                  navAngle = 270,
                  minRadiusPercent = 0.25,
                  maxRadiusPercent = 0.55,
                  labels = {"INVENTORY", "WALLET", "EMOTES", "APTITUDES", "VEHICLE", "POLICE"},
                  commands = {"none", "walletPoliceSubMenu", "emoteSubMenu", "none", "externalCopVehSubMenu", "policeSubMenu"},
                  triggers = {"openInventory", "none", "none", "viewAptitudes", "none", "none"}
                },
                {
                    navAngle = 270,
                    minRadiusPercent = 0.6,
                    maxRadiusPercent = 0.9,
                    labels = {"GIVE KEYS", "TOGGLE LOCKS", "TRUNK", "REPAIR"},
                    commands = {"none", "none", "none", "none"},
                    triggers = {"giveVehicleKeys", "togglelock", "accessTrunk", "repairVehicle"}
                }
            }
        }
    },
    ['externalMedVehSubMenu'] = {
        data = {
            keybind = "M",
            style = {
                sizePx = 600,
                slices = {
                    default = { ['fill'] = '#000000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.60 },
                    hover = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 },
                    selected = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 }
                },
                titles = {
                    default = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    hover = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    selected = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' }
                },
                icons = {
                    width = 64,
                    height = 64
                }
            },
            wheels = {
                {
                  navAngle = 270,
                  minRadiusPercent = 0.25,
                  maxRadiusPercent = 0.55,
                  labels = {"INVENTORY", "WALLET", "EMOTES", "APTITUDES", "VEHICLE", "MEDICAL"},
                  commands = {"none", "walletMedSubMenu", "emoteSubMenu", "none", "externalCopVehSubMenu", "medSubMenu"},
                  triggers = {"openInventory", "none", "none", "viewAptitudes", "none", "none"}
                },
                {
                    navAngle = 270,
                    minRadiusPercent = 0.6,
                    maxRadiusPercent = 0.9,
                    labels = {"GIVE KEYS", "TOGGLE LOCKS", "TRUNK", "REPAIR"},
                    commands = {"none", "none", "none", "none"},
                    triggers = {"giveVehicleKeys", "togglelock", "accessTrunk", "repairVehicle"}
                }
            }
        }
    },
    ['weaponStoreSubMenu'] = {
        data = {
            keybind = "M",
            style = {
                sizePx = 600,
                slices = {
                    default = { ['fill'] = '#000000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.60 },
                    hover = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 },
                    selected = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 }
                },
                titles = {
                    default = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    hover = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    selected = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' }
                },
                icons = {
                    width = 64,
                    height = 64
                }
            },
            wheels = {
                {
                  navAngle = 270,
                  minRadiusPercent = 0.25,
                  maxRadiusPercent = 0.55,
                  labels = {"INVENTORY", "WALLET", "EMOTES", "APTITUDES", "VEHICLE", "POLICE"},
                  commands = {"none", "walletPoliceSubMenu", "emoteSubMenu", "none", "externalCopVehSubMenu", "policeSubMenu"},
                  triggers = {"openInventory", "none", "none", "viewAptitudes", "none", "none"}
                },
                {
                    navAngle = 270,
                    minRadiusPercent = 0.6,
                    maxRadiusPercent = 0.9,
                    labels = {"SHOTGUN", "SMG"},
                    commands = {"none", "none"},
                    triggers = {"storeGetShotgun", "storeGetSmg"}
                }
            }
        }
    },
    ['mdtSubMenu'] = {
        data = {
            keybind = "M",
            style = {
                sizePx = 600,
                slices = {
                    default = { ['fill'] = '#000000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.60 },
                    hover = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 },
                    selected = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 }
                },
                titles = {
                    default = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    hover = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    selected = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' }
                },
                icons = {
                    width = 64,
                    height = 64
                }
            },
            wheels = {
                {
                  navAngle = 270,
                  minRadiusPercent = 0.25,
                  maxRadiusPercent = 0.55,
                  labels = {"INVENTORY", "WALLET", "EMOTES", "APTITUDES", "VEHICLE", "POLICE"},
                  commands = {"none", "walletPoliceSubMenu", "emoteSubMenu", "none", "externalCopVehSubMenu", "policeSubMenu"},
                  triggers = {"openInventory", "none", "none", "viewAptitudes", "none", "none"}
                },
                {
                    navAngle = 270,
                    minRadiusPercent = 0.6,
                    maxRadiusPercent = 0.9,
                    labels = {"DISPATCH", "WANTED"},
                    commands = {"none", "none"},
                    triggers = {"policeDispatch", "policeWanted"}
                }
            }
        }
    },
    ['playerActionSubMenu'] = {
        data = {
            keybind = "M",
            style = {
                sizePx = 600,
                slices = {
                    default = { ['fill'] = '#000000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.60 },
                    hover = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 },
                    selected = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 }
                },
                titles = {
                    default = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    hover = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    selected = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' }
                },
                icons = {
                    width = 64,
                    height = 64
                }
            },
            wheels = {
                {
                  navAngle = 270,
                  minRadiusPercent = 0.25,
                  maxRadiusPercent = 0.55,
                  labels = {"INVENTORY", "WALLET", "EMOTES", "APTITUDES", "VEHICLE", "POLICE"},
                  commands = {"none", "walletPoliceSubMenu", "emoteSubMenu", "none", "externalCopVehSubMenu", "policeSubMenu"},
                  triggers = {"openInventory", "none", "none", "viewAptitudes", "none", "none"}
                },
                {
                    navAngle = 270,
                    minRadiusPercent = 0.6,
                    maxRadiusPercent = 0.9,
                    labels = {"CHECK ID", "SEARCH PERSON", "GSR TEST", "SEIZE WEAPONS", "SEIZE ITEMS", "GIVE FINE", "JAIL", "PRISON", "REVOKE", "SHACKLES"},
                    commands = {"none", "none", "none", "none", "none", "none", "none", "none", "policeLicenseSubMenu", "none"},
                    triggers = {"checkId", "searchTargetPlayer", "doGsrTest", "seizeWeapons", "seizeItems", "fineTarget", "jailTarget", "prisonTarget", "none", "toggleShackles"}
                }
            }
        }
    },
    ['policeLicenseSubMenu'] = {
        data = {
            keybind = "M",
            style = {
                sizePx = 600,
                slices = {
                    default = { ['fill'] = '#000000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.60 },
                    hover = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 },
                    selected = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 }
                },
                titles = {
                    default = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    hover = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    selected = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' }
                },
                icons = {
                    width = 64,
                    height = 64
                }
            },
            wheels = {
                {
                  navAngle = 270,
                  minRadiusPercent = 0.25,
                  maxRadiusPercent = 0.55,
                  labels = {"INVENTORY", "WALLET", "EMOTES", "APTITUDES", "VEHICLE", "POLICE"},
                  commands = {"none", "walletPoliceSubMenu", "emoteSubMenu", "none", "externalCopVehSubMenu", "policeSubMenu"},
                  triggers = {"openInventory", "none", "none", "viewAptitudes", "none", "none"}
                },
                {
                    navAngle = 270,
                    minRadiusPercent = 0.6,
                    maxRadiusPercent = 0.9,
                    labels = {"REVOKE DRIVER LICENSE", "REVOKE FIREARM LICENSE", "REVOKE KEYS"},
                    commands = {"none", "none", "none"},
                    triggers = {"revokeDriversLicense", "revokeFirearmLicense", "revokeKeys"}
                }
            }
        }
    },
    ['vehicleActionSubMenu'] = {
        data = {
            keybind = "M",
            style = {
                sizePx = 600,
                slices = {
                    default = { ['fill'] = '#000000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.60 },
                    hover = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 },
                    selected = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 }
                },
                titles = {
                    default = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    hover = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    selected = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' }
                },
                icons = {
                    width = 64,
                    height = 64
                }
            },
            wheels = {
                {
                  navAngle = 270,
                  minRadiusPercent = 0.25,
                  maxRadiusPercent = 0.55,
                  labels = {"INVENTORY", "WALLET", "EMOTES", "APTITUDES", "VEHICLE", "POLICE"},
                  commands = {"none", "walletPoliceSubMenu", "emoteSubMenu", "none", "externalCopVehSubMenu", "policeSubMenu"},
                  triggers = {"openInventory", "none", "none", "viewAptitudes", "none" }
                },
                {
                    navAngle = 270,
                    minRadiusPercent = 0.6,
                    maxRadiusPercent = 0.9,
                    labels = {"SEARCH VEHICLE", "SEARCH VIN", "SEIZE ITEMS", "IMPOUND", "SEIZE VEHICLE", "REPAIR ITEMS"},
                    commands = {"none", "none", "none", "none", "none", "none"},
                    triggers = {"searchTargetVehicle", "searchTargetVin", "seizeVehicleItems", "impoundVehicle", "seizeVehicle", "repairCopItems"}
                }
            }
        }
    },
    ['medSubMenu'] = {
        data = {
            keybind = "M",
            style = {
                sizePx = 600,
                slices = {
                    default = { ['fill'] = '#000000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.60 },
                    hover = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 },
                    selected = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 }
                },
                titles = {
                    default = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    hover = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    selected = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' }
                },
                icons = {
                    width = 64,
                    height = 64
                }
            },
            wheels = {
                {
                  navAngle = 270,
                  minRadiusPercent = 0.25,
                  maxRadiusPercent = 0.55,
                  labels = {"INVENTORY", "WALLET", "EMOTES", "APTITUDES", "VEHICLE", "MEDICAL"},
                  commands = {"none", "walletMedSubMenu", "emoteSubMenu", "none", "externalMedVehSubMenu", "medSubMenu"},
                  triggers = {"openInventory", "none", "none", "viewAptitudes", "none", "none"}
                },
                {
                    navAngle = 270,
                    minRadiusPercent = 0.6,
                    maxRadiusPercent = 0.9,
                    labels = {"REVIVE", "ESCORT", "CPR", "TREATMENT", "PUT IN VEHICLE", "PULL OUT", "MDT"},
                    commands = {"none", "none", "none", "medTreatmentSubMenu", "none", "none", "none"},
                    triggers = {"reviveTarget", "emsEscort", "performCpr", "none", "emsPutInVehicle", "pullOutVeh", "emsMobileTerminal"}
                }
            }
        }
    },
    ['medTreatmentSubMenu'] = {
        data = {
            keybind = "M",
            style = {
                sizePx = 600,
                slices = {
                    default = { ['fill'] = '#000000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.60 },
                    hover = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 },
                    selected = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 }
                },
                titles = {
                    default = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    hover = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    selected = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' }
                },
                icons = {
                    width = 64,
                    height = 64
                }
            },
            wheels = {
                {
                  navAngle = 270,
                  minRadiusPercent = 0.25,
                  maxRadiusPercent = 0.55,
                  labels = {"INVENTORY", "WALLET", "EMOTES", "APTITUDES", "VEHICLE", "MEDICAL"},
                  commands = {"none", "walletMedSubMenu", "emoteSubMenu", "none", "externalMedVehSubMenu", "medSubMenu"},
                  triggers = {"openInventory", "none", "none", "viewAptitudes", "none", "none"}
                },
                {
                    navAngle = 270,
                    minRadiusPercent = 0.6,
                    maxRadiusPercent = 0.9,
                    labels = {"FIELD TREATMENT", "TOGGLE BED", "CHECK PULSE", "CHECK INJURIES"},
                    commands = {"none", "none", "none", "none"},
                    triggers = {"fieldTreatment", "toggleBedState", "checkTargetPulse", "checkTargetInjuries"}
                }
            }
        }
    },
    ['vehDoorSubMenu'] = {
        data = {
            keybind = "M",
            style = {
                sizePx = 600,
                slices = {
                    default = { ['fill'] = '#000000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.60 },
                    hover = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 },
                    selected = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 }
                },
                titles = {
                    default = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    hover = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    selected = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' }
                },
                icons = {
                    width = 64,
                    height = 64
                }
            },
            wheels = {
                {
                  navAngle = 270,
                  minRadiusPercent = 0.25,
                  maxRadiusPercent = 0.55,
                  labels = {"imgsrc:engine.png", "imgsrc:key.png", "imgsrc:doors.png", "DOME LIGHT", "WINDOWS", "SEATBELT", "INVENTORY"},
                  commands = {"none", "none", "vehDoorSubMenu", "none", "none", "none", "none"},
                  triggers = {"toggleEngine", "togglelock", "none", "toggleDomeLight", "toggleWindows", "toggleSeatBelt", "openInventory"}
                },
                {
                    navAngle = 270,
                    minRadiusPercent = 0.6,
                    maxRadiusPercent = 0.9,
                    labels = {"FRONT L", "FRONT R", "BACK L", "BACK R", "HOOD", "TRUNK", "BACK", "BACK 2"},
                    commands = {"none", "none", "none", "none", "none", "none", "none"},
                    triggers = {"toggleDoorFL", "toggleDoorFR", "toggleDoorBL", "toggleDoorBR", "toggleDoorHood", "toggleDoorTrunk", "toggleDoorBack", "toggleDoorBack2"}
                }
            }
        }
    },
    ['vehDoorTowSubMenu'] = {
        data = {
            keybind = "M",
            style = {
                sizePx = 600,
                slices = {
                    default = { ['fill'] = '#000000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.60 },
                    hover = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 },
                    selected = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 }
                },
                titles = {
                    default = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    hover = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    selected = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' }
                },
                icons = {
                    width = 64,
                    height = 64
                }
            },
            wheels = {
                {
                  navAngle = 270,
                  minRadiusPercent = 0.25,
                  maxRadiusPercent = 0.55,
                  labels = {"imgsrc:engine.png", "imgsrc:key.png", "imgsrc:doors.png", "DOME LIGHT", "WINDOWS", "SEATBELT", "INVENTORY", "REQUEST JOB"},
                  commands = {"none", "none", "vehDoorSubMenu", "none", "none", "none", "none", "none"},
                  triggers = {"toggleEngine", "togglelock", "none", "toggleDomeLight", "toggleWindows", "toggleSeatBelt", "openInventory", "findParkedVeh"}
                },
                {
                    navAngle = 270,
                    minRadiusPercent = 0.6,
                    maxRadiusPercent = 0.9,
                    labels = {"FRONT L", "FRONT R", "BACK L", "BACK R", "HOOD", "TRUNK", "BACK", "BACK 2"},
                    commands = {"none", "none", "none", "none", "none", "none", "none"},
                    triggers = {"toggleDoorFL", "toggleDoorFR", "toggleDoorBL", "toggleDoorBR", "toggleDoorHood", "toggleDoorTrunk", "toggleDoorBack", "toggleDoorBack2"}
                }
            }
        }
    },
    ['vehDoorPoliceSubMenu'] = {
        data = {
            keybind = "M",
            style = {
                sizePx = 600,
                slices = {
                    default = { ['fill'] = '#000000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.60 },
                    hover = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 },
                    selected = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 }
                },
                titles = {
                    default = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    hover = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    selected = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' }
                },
                icons = {
                    width = 64,
                    height = 64
                }
            },
            wheels = {
                {
                  navAngle = 270,
                  minRadiusPercent = 0.25,
                  maxRadiusPercent = 0.55,
                  labels = {"imgsrc:engine.png", "imgsrc:key.png", "imgsrc:doors.png", "DOME LIGHT", "WINDOWS", "SEATBELT", "INVENTORY", "MDT"},
                  commands = {"none", "none", "vehDoorPoliceSubMenu", "none", "none", "none", "none", "vehMdtPoliceSubMenu"},
                  triggers = {"toggleEngine", "togglelock", "none", "toggleDomeLight", "toggleWindows", "toggleSeatBelt", "openInventory", "none"}
                },
                {
                    navAngle = 270,
                    minRadiusPercent = 0.6,
                    maxRadiusPercent = 0.9,
                    labels = {"FRONT L", "FRONT R", "BACK L", "BACK R", "HOOD", "TRUNK", "BACK", "BACK 2"},
                    commands = {"none", "none", "none", "none", "none", "none", "none"},
                    triggers = {"toggleDoorFL", "toggleDoorFR", "toggleDoorBL", "toggleDoorBR", "toggleDoorHood", "toggleDoorTrunk", "toggleDoorBack", "toggleDoorBack2"}
                }
            }
        }
    },
    ['vehDoorMedicalSubMenu'] = {
        data = {
            keybind = "M",
            style = {
                sizePx = 600,
                slices = {
                    default = { ['fill'] = '#000000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.60 },
                    hover = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 },
                    selected = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 }
                },
                titles = {
                    default = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    hover = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    selected = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' }
                },
                icons = {
                    width = 64,
                    height = 64
                }
            },
            wheels = {
                {
                  navAngle = 270,
                  minRadiusPercent = 0.25,
                  maxRadiusPercent = 0.55,
                  labels = {"imgsrc:engine.png", "imgsrc:key.png", "imgsrc:doors.png", "DOME LIGHT", "WINDOWS", "SEATBELT", "INVENTORY", "MDT", "DISPATCH JOB"},
                  commands = {"none", "none", "vehDoorMedicalSubMenu", "none", "none", "none", "none", "none", "none"},
                  triggers = {"toggleEngine", "togglelock", "none", "toggleDomeLight", "toggleWindows", "toggleSeatBelt", "openInventory", "emsMobileTerminal", "toggleEmsDispatch"}
                },
                {
                    navAngle = 270,
                    minRadiusPercent = 0.6,
                    maxRadiusPercent = 0.9,
                    labels = {"FRONT L", "FRONT R", "BACK L", "BACK R", "HOOD", "TRUNK", "BACK", "BACK 2"},
                    commands = {"none", "none", "none", "none", "none", "none", "none"},
                    triggers = {"toggleDoorFL", "toggleDoorFR", "toggleDoorBL", "toggleDoorBR", "toggleDoorHood", "toggleDoorTrunk", "toggleDoorBack", "toggleDoorBack2"}
                }
            }
        }
    },
    ['vehMdtPoliceSubMenu'] = {
        data = {
            keybind = "M",
            style = {
                sizePx = 600,
                slices = {
                    default = { ['fill'] = '#000000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.60 },
                    hover = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 },
                    selected = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.80 }
                },
                titles = {
                    default = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    hover = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    selected = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' }
                },
                icons = {
                    width = 64,
                    height = 64
                }
            },
            wheels = {
                {
                  navAngle = 270,
                  minRadiusPercent = 0.25,
                  maxRadiusPercent = 0.55,
                  labels = {"imgsrc:engine.png", "imgsrc:key.png", "imgsrc:doors.png", "DOME LIGHT", "WINDOWS", "SEATBELT", "INVENTORY", "MDT"},
                  commands = {"none", "none", "vehDoorSubMenu", "none", "none", "none", "none", "vehMdtPoliceSubMenu"},
                  triggers = {"toggleEngine", "togglelock", "none", "toggleDomeLight", "toggleWindows", "toggleSeatBelt", "openInventory", "none"}
                },
                {
                    navAngle = 270,
                    minRadiusPercent = 0.6,
                    maxRadiusPercent = 0.9,
                    labels = {"DISPATCH", "WANTED"},
                    commands = {"none", "none"},
                    triggers = {"policeDispatch", "policeWanted"}
                }
            }
        }
    },
}
