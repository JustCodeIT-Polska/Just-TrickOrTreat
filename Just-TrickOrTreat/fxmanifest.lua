fx_version("cerulean")

game("gta5")
author("Jacux from JustCodeIT ")
shared_script 'config.lua'
client_scripts {'client.lua'}

lua54("yes")
server_scripts {"@oxmysql/lib/MySQL.lua", "server.lua"}

shared_scripts {"@ox_lib/init.lua"}
data_file 'DLC_ITYP_REQUEST' 'stream/jsd_prop_pumpkin.ytyp'
