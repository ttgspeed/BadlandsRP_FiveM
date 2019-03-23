resource_manifest_version "05cfa83c-a124-4cfa-a768-c24a5811d8f9"

file 'stream/hospital_props/int_medical.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/hospital_props/int_medical.ytyp'

this_is_a_map 'yes'

client_scripts {
    "client/main.lua"
}