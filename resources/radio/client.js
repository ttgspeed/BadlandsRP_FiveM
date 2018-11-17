const customRadios = [];
let isPlaying = false;
let index = -1;
let volume = GetProfileSetting(306) / 10;
let previousVolume = volume;

let radio_stations = {
	"RADIO_01_CLASS_ROCK":{ url:"http://revolutionradio.ru/live.ogg", volume:1.0 },  // Los Santos Rock Radio
	"RADIO_02_POP":{ url:"http://revolutionradio.ru/live.ogg", volume:1.0 },         // Non-Stop-Pop FM
	"RADIO_03_HIPHOP_NEW":{ url:"http://revolutionradio.ru/live.ogg", volume:1.0 },  // Radio Los Santos
	"RADIO_04_PUNK":{ url:"http://revolutionradio.ru/live.ogg", volume:1.0 },        // Channel X
	"RADIO_05_TALK_01":{ url:"http://revolutionradio.ru/live.ogg", volume:1.0 },     // West Coast Talk Radio
	"RADIO_06_COUNTRY":{ url:"http://revolutionradio.ru/live.ogg", volume:1.0 },     // Rebel Radio
	"RADIO_07_DANCE_01":{ url:"http://revolutionradio.ru/live.ogg", volume:1.0 },    // Soulwax FM
	"RADIO_08_MEXICAN":{ url:"http://revolutionradio.ru/live.ogg", volume:1.0 },     // East Los FM
	"RADIO_09_HIPHOP_OLD":{ url:"http://revolutionradio.ru/live.ogg", volume:1.0 },  // West Coast Classics
	"RADIO_12_REGGAE":{ url:"http://revolutionradio.ru/live.ogg", volume:1.0 },      // Blue Ark
	"RADIO_13_JAZZ":{ url:"http://revolutionradio.ru/live.ogg", volume:1.0 },        // Worldwide FM
	"RADIO_14_DANCE_02":{ url:"http://revolutionradio.ru/live.ogg", volume:1.0 },    // FlyLo FM
	"RADIO_15_MOTOWN":{ url:"http://revolutionradio.ru/live.ogg", volume:1.0 },      // The Lowdown 91.1
	"RADIO_20_THELAB":{ url:"http://revolutionradio.ru/live.ogg", volume:1.0 },      // The Lab
	"RADIO_16_SILVERLAKE":{ url:"http://revolutionradio.ru/live.ogg", volume:1.0 },  // Radio Mirror Park
	"RADIO_17_FUNK":{ url:"http://revolutionradio.ru/live.ogg", volume:1.0 },        // Space 103.2
	"RADIO_18_90S_ROCK":{ url:"http://revolutionradio.ru/live.ogg", volume:1.0 },    // Vinewood Boulevard Radio
	"RADIO_19_USER":{ url:"http://revolutionradio.ru/live.ogg", volume:1.0 },        // Self Radio
	"RADIO_11_TALK_02":{ url:"http://revolutionradio.ru/live.ogg", volume:1.0 }      // Blaine County Radio
};

for (var station in radio_stations) {
    const radio = station;

    try {
        const data = radio_stations[station];
        if (data !== null) {
            customRadios.push({
                "isPlaying": false,
                "name": radio,
                "data": data
            });
            if (data.name) {
                AddTextEntry(station, data.name);
            }
        } else {
            console.error(`radio: Missing data for ${radio}.`);
        }
    } catch (e) {
        console.error(e);
    }
}

RegisterNuiCallbackType("radio:ready");
on("__cfx_nui:radio:ready", (data, cb) => {
    SendNuiMessage(JSON.stringify({ "type": "create", "radios": customRadios, "volume": volume }));
});
SendNuiMessage(JSON.stringify({ "type": "create", "radios": customRadios, "volume": volume }));

const PlayCustomRadio = (radio) => {
	console.error(JSON.stringify(radio));
  isPlaying = true;
  index = customRadios.indexOf(radio);
  ToggleCustomRadioBehavior(true);
  SendNuiMessage(JSON.stringify({ "type": "play", "radio": radio.name }));
};

const StopCustomRadios = () => {
	console.error("Stopping music");
    isPlaying = false;
    ToggleCustomRadioBehavior(false);
    SendNuiMessage(JSON.stringify({ "type": "stop" }));
};

const ToggleCustomRadioBehavior = (radioOn) => {
    SetFrontendRadioActive(!radioOn);

    if (radioOn) {
        StartAudioScene("DLC_MPHEIST_TRANSITION_TO_APT_FADE_IN_RADIO_SCENE");
    } else {
        StopAudioScene("DLC_MPHEIST_TRANSITION_TO_APT_FADE_IN_RADIO_SCENE");
    }
};

function PlayClubRadio(club){
	console.log("2 "+club);
	let playerRadioStationName = club; //"RADIO_03_HIPHOP_NEW";
	let customRadio = customRadios.find((radio) => {
			return radio.name === playerRadioStationName;
	});

	if (!isPlaying && customRadio) {
		console.error("Playing "+club);
		//StopCustomRadios();
		PlayCustomRadio(customRadio);
	}
	//let local_volume = 0.5*((100-(distance*2))/100);
	SendNuiMessage(JSON.stringify({ "type": "volume", "volume": 0.5 }));
};

setTick(() => {
	let coords = GetEntityCoords(GetPlayerPed(-1));
	//console.error(GetDistanceBetweenCoords(-1387.4630126954,-617.9398803711,30.819576263428,coords[0],coords[1],coords[2]));
	// let distance = GetDistanceBetweenCoords(-1387.4630126954,-617.9398803711,30.819576263428,coords[0],coords[1],coords[2]);
	// if(distance <= 50.001){
	// 	let playerRadioStationName = "RADIO_03_HIPHOP_NEW";
	// 	let customRadio = customRadios.find((radio) => {
	// 			return radio.name === playerRadioStationName;
	// 	});
	//
	// 	if (!isPlaying && customRadio) {
	// 		console.error("Playing bahama mamas music");
	// 		//StopCustomRadios();
	// 		PlayCustomRadio(customRadio);
	// 	}
	// 	let local_volume = 0.5*((100-(distance*2))/100);
	// 	SendNuiMessage(JSON.stringify({ "type": "volume", "volume": local_volume }));
	// }else
	if(IsPlayerVehicleRadioEnabled()) {
      let playerRadioStationName = GetPlayerRadioStationName();

      let customRadio = customRadios.find((radio) => {
          return radio.name === playerRadioStationName;
      });

      if (!isPlaying && customRadio) {
          PlayCustomRadio(customRadio);
      } else if (isPlaying && customRadio && customRadios.indexOf(customRadio) !== index) {
          StopCustomRadios();
          PlayCustomRadio(customRadio);
      } else if (isPlaying && !customRadio) {
          StopCustomRadios();
      }
  } else if (isPlaying) {
      StopCustomRadios();
  }

  volume = GetProfileSetting(306) / 10;
  if (previousVolume !== volume) {
      SendNuiMessage(JSON.stringify({ "type": "volume", "volume": volume }));
      previousVolume = volume;
  }
});
