fx_version 'cerulean'
game 'gta5'

description 'event tool'
author 'Goof'

shared_scripts {
    '@ox_lib/init.lua'
}

server_scripts {
    '@es_extended/imports.lua',
    'server.lua'
}

client_scripts {
    'client.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}
