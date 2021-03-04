resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'Staff Menu |'

author ""

version '1.0'

dependencies {
    'NativeUI',
}

shared_scripts {
	'config.lua'
}

client_script {
	'@NativeUI/NativeUI.lua',
	'Client/client.lua',
	'sc_client.lua',
}

server_script {
	"@mysql-async/lib/MySQL.lua",
	'Server/server.lua',
	'sc_server.lua',
}