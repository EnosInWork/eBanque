fx_version 'adamant'

game 'gta5'

shared_scripts {
    "shared/*.lua"
}

client_scripts {
    "RageUI-X/RMenu.lua",
    "RageUI-X/menu/RageUI.lua",
    "RageUI-X/menu/Menu.lua",
    "RageUI-X/menu/MenuController.lua",
    "RageUI-X/components/*.lua",
    "RageUI-X/menu/elements/*.lua",
    "RageUI-X/menu/items/*.lua",
    "RageUI-X/menu/panels/*.lua",
    "RageUI-X/menu/panels/*.lua",
    "RageUI-X/menu/windows/*.lua",
    "client/*.lua",
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    "server/*.lua",
}