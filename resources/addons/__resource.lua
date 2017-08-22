-- the current manifest version level (2016-12-30)
resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

-- add the files to be sent to the client
files {
	'vehicles.meta',
	'carvariations.meta',
	'carcols.meta',
	'handling.meta'
}

-- specify data file entries to be added
-- these entries are the same as content.xml in a DLC pack
data_file 'HANDLING_FILE' 'handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'vehicles.meta'
data_file 'CARCOLS_FILE' 'carcols.meta'
data_file 'VEHICLE_VARIATION_FILE' 'carvariations.meta'

-- and a client script
client_script 'vehicle_names.lua'