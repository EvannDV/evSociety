fx_version 'cerulean'

game 'gta5'

author 'evann™'
shared_script('shared/config.lua');

-- RageUI V2

client_scripts {
    "src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",
    "src/components/*.lua",
    "src/menu/elements/*.lua",
    "src/menu/items/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/windows/*.lua"
}

----Client Side

client_scripts {
    "ClientSide/cl_main.lua",
    "ClientSide/vehicules.lua",
    "ClientSide/coffre.lua",
    "ClientSide/boss2.lua",
}

----Serveur Side

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'ServeurSide/server.lua',
}

dependencies {
	'mysql-async'
}






