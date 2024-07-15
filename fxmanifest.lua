fx_version 'cerulean'
game 'gta5'

author 'Frisky'
description 'Boat Rentals for FiveM'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}
client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
	'client/main.lua'
}
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

ui_page "web/index.html"
files {
	'web/index.html',
	'web/app.js'
}

lua54 'yes'