fx_version 'cerulean'
game 'gta5'
author 'GMD-Scripts'
description 'GMD_Rewards - A complete reward system'

lua54 'yes'

client_scripts {
    'client/*.lua'
}

server_scripts { 
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}

shared_scripts {
	'config.lua',
    'config_locals.lua',
    '@es_extended/imports.lua',
	'@ox_lib/init.lua'
}