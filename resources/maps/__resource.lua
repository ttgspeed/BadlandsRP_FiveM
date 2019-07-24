resource_manifest_version "05cfa83c-a124-4cfa-a768-c24a5811d8f9"

this_is_a_map 'yes'

files {
  'stream/hostpital_props/hoint_medical.ytyp',
  'stream/hostpital_props/_manifest.ymf'
}

data_file 'DLC_ITYP_REQUEST' 'stream/hostpital_props/int_medical.ytyp'

client_scripts {
    "client/main.lua"
}
