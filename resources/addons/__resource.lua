-- the current manifest version level (2016-12-30)
resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

-- add the files to be sent to the client
files {
	'vehicles.meta',
	'carvariations.meta',
	'carcols.meta',
	'handling.meta',
	'vehicleaihandlinginfo.meta',
	'weapons.meta',
	'weaponanimations.meta',
	--'damages.meta',
	--'combatbehaviour.meta',
	'results.meta',
	'pedaccuracy.meta',
	'weaponsnowball.meta',
	'weaponrevolver.meta',
	'weapons_pistol_mk2.meta',
	'weapons_doubleaction.meta',
	'weaponheavypistol.meta',
	'weaponsnspistol.meta',
	'weaponvintagepistol.meta',
	'weaponbattleaxe.meta',
	'weaponbottle.meta',
	'weapondagger.meta',
	'weaponflashlight.meta',
	'weaponhatchet.meta',
	'weaponknuckle.meta',
	'weaponpoolcue.meta',
	'weaponswitchblade.meta',
	'weaponwrench.meta'
}

-- specify data file entries to be added
-- these entries are the same as content.xml in a DLC pack
data_file 'HANDLING_FILE' 'handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'vehicles.meta'
data_file 'CARCOLS_FILE' 'carcols.meta'
data_file 'VEHICLE_VARIATION_FILE' 'carvariations.meta'
data_file 'HANDLING_FILE' 'vehicleaihandlinginfo.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weaponsnowball.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weaponrevolver.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons_pistol_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons_doubleaction.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weaponheavypistol.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weaponsnspistol.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weaponvintagepistol.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weaponbattleaxe.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weaponbottle.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapondagger.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weaponflashlight.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weaponhatchet.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weaponknuckle.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weaponpoolcue.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weaponswitchblade.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weaponwrench.meta'
data_file 'WEAPON_ANIMATIONS_FILE' 'weaponanimations.meta'
--data_file 'PED_DAMAGE_APPEND_FILE' 'damages.meta'
--data_file 'FIVEM_LOVES_YOU_1424B0DA6F9BC846' 'combatbehaviour.meta'
data_file 'PED_DAMAGE_APPEND_FILE' 'results.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'pedaccuracy.meta'
