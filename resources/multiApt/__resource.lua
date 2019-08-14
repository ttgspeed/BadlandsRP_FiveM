-- Source https://forum.fivem.net/t/solved-question-duplicatiing-interiors-instacing/653922/26
-- author: Alzar (not confirmed)

resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

this_is_a_map 'yes'

files {
  'stream/playerhouse_tier1/playerhouse_tier1.ytyp',
  'stream/playerhouse_tier3/playerhouse_tier3.ytyp'
}

data_file 'DLC_ITYP_REQUEST' 'stream/playerhouse_tier1/playerhouse_tier1.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/playerhouse_tier3/playerhouse_tier3.ytyp'

client_scripts {
    "script.lua"
}
