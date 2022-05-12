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
    '@oxmysql/lib/MySQL.lua',
    'server/utils.lua',
    'server/stealveh_sv.lua',
}

client_scripts {
    "@RageUI/RageUI.lua",
    "@RageUI/Menu.lua",
    "@RageUI/MenuController.lua",
    "@RageUI/components/Audio.lua",
    "@RageUI/components/Graphics.lua",
    "@RageUI/components/Keys.lua",
    "@RageUI/components/Util.lua",
    "@RageUI/components/Visual.lua",
    "@RageUI/elements/ItemsBadge.lua",
    "@RageUI/elements/ItemsColour.lua",
    "@RageUI/elements/PanelColour.lua",
    "@RageUI/items/Items.lua",
    "@RageUI/items/Panels.lua",


    'client/stealveh_cl.lua',
    'client/menu.lua',
}

dependencies {
    'es_extended',
    'ox_lib',
    'RageUI',
}
