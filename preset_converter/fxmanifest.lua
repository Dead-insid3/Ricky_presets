fx_version 'cerulean'
game 'gta5'

author 'D34D.1NS1D3R'
description 'Conversor de Presets de Aparência para Illenium Appearance'
version '1.2.1'
ui_page 'html/ui.html'

shared_script 'config.lua'
shared_script 'shared_utils.lua'

client_script 'client.lua'
server_script 'server.lua'

server_script '@oxmysql/lib/MySQL.lua'

files {
    'html/ui.html',
    'html/script.js',
    'html/style.css'
}