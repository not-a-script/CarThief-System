fx_version 'cerulean'
author 'SpaceV'
lua54 'yes'
game { 'gta5' }

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'shared/config.lua',
}

server_scripts {
    'server/utils.lua',
    'server/stealveh_sv.lua',
}

client_scripts {
    'client/stealveh_cl.lua',
    'client/menu.lua',
}

dependencies {
    'es_extended',
    'ox_lib',
    'RageUI',
}
