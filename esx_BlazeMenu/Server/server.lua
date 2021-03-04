ESX = nil



TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)





RegisterServerEvent('exploitername:onoma')

AddEventHandler('exploitername:onoma', function(exploit)

	local _source = Source

	local xPlayer = ESX.GetPlayerFromId()

	local playerName1 = xPlayer.getName()

    PerformHttpRequest(Blaze.ExploitWebhook, function(err, text, headers) end, 'POST', json.encode({embeds={{title="Exploit Menu Logs",description="╬á╧ü╬┐╧â╧Ç╬¼╬╕╬╖╧â╬╡ ╬╜╬▒ ╬║╬¼╬╜╬╡╬╣ exploit ╧ä╬┐ Menu \nO: "..playerName1.."",color= 16711680}}}), { ['Content-Type'] = 'application/json' })

end)



ESX.RegisterServerCallback('esx_BlazeMenu:CanOpen', function(source, cb)

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getGroup() == "admin" then

		cb(true)

    elseif xPlayer.getGroup() == "superadmin" then

		cb(true)

    elseif xPlayer.getGroup() == "mod" then

        print("A Moderator tried to open Blaze Menu")

    elseif xPlayer.getGroup() == "user" then

        print("A User tried to open BlazeMenu")

    else

        cb(false)

    end

end)



RegisterServerEvent("esx_BlazeMenu:BlackMoney")

AddEventHandler("esx_BlazeMenu:BlackMoney", function(id, money)

    local source

    local xPlayer = ESX.GetPlayerFromId(id)

    if xPlayer.getGroup() ~= 'user' then

        if id == (nil) or id == "" or id == 0 then

            source = source

        else

            source = id

        end

        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer ~= (nil) then

            xPlayer.addAccountMoney('black_money', money)

        end

    else

        DropPlayer(id, '[Blaze Menu]: Lua Injection')

    end 

end)



RegisterServerEvent("esx_BlazeMenu:clearblack")

AddEventHandler("esx_BlazeMenu:clearblack", function(id, money)

    local source

    local xPlayer = ESX.GetPlayerFromId(id)

    if xPlayer.getGroup() ~= 'user' then

        if id == (nil) or id == "" or id == 0 then

            source = source

        else

            source = id

        end

        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer ~= (nil) then

            xPlayer.setAccountMoney('black_money', 0)

        end

    else

        DropPlayer(id, '[Blaze Menu]: Lua Injection')

    end

end)



RegisterServerEvent("esx_BlazeMenu:spawncash")

AddEventHandler("esx_BlazeMenu:spawncash", function(id, money)

    local xPlayer = ESX.GetPlayerFromId(id)

    if xPlayer.getGroup() ~= 'user' then

        xPlayer.addMoney(money)

    else

        DropPlayer(id, '[Blaze Menu]: Lua Injection')

    end

end)



RegisterServerEvent("esx_BlazeMenu:clearcash")

AddEventHandler("esx_BlazeMenu:clearcash", function(id, money)

    local source

    local xPlayer = ESX.GetPlayerFromId(id)

    if xPlayer.getGroup ~= 'user' then

        if id == nil or id == ""or id == 0 then

            source = source

        else

            source = id

        end

        local xPlayer = ESX.GetPlayerFromId(id)

        if xPlayer ~= nil then

            xPlayer.setMoney(0)

        end

    else

        DropPlayer(id, '[Blaze Menu]: Lua Injection')

    end

end)



RegisterServerEvent("esx_BlazeMenu:clearbank")

AddEventHandler("esx_BlazeMenu:clearbank", function(id, money)

    local source

    local xPlayer = ESX.GetPlayerFromId(id)

    if xPlayer.getGroup() ~= 'user' then

        if id == (nil) or id == "" or id == 0 then

            source = source

        else

            source = id

        end

        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer ~= (nil) then

            xPlayer.setAccountMoney('bank', 0)

        end

    else

        DropPlayer(id, '[Blaze Menu]: Lua Injection')

    end

end)



RegisterServerEvent("esx_BlazeMenu:giveCarToPlayer")

AddEventHandler("esx_BlazeMenu:giveCarToPlaryer", function(vehicleProps, PlayerID)

    local __source = source

	local _source = playerID

	local xPlayer = ESX.GetPlayerFromId(_source)



	--print(vehicleProps.model)



	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, stored) VALUES (@owner, @plate, @vehicle, @stored)',

	{

		['@owner']   = xPlayer.identifier,

		['@plate']   = vehicleProps.plate,

		['@vehicle'] = json.encode({model = vehicleProps.model, plate = vehicleProps.plate}),

		['@stored']  = 1

	}, function(result)

		if Blaze.ReceiveMsg then

			TriggerClientEvent('esx:showNotification', _source, _U('received_car', string.upper(vehicleProps.plate)))

		end

	end)

end)



RegisterServerEvent('esx_BlazeMenu:getgarage')

AddEventHandler('esx_BlazeMenu:getgarage',function(id)

	local src = source

	local xPlayer = ESX.GetPlayerFromId(_source)

	local amaxia = {}

	local pinakida = {}

	local counter = 1

	MySQL.Async.fetchAll("SELECT vehicle,plate FROM owned_vehicles WHERE owner=@owner",{['@owner'] = GetPlayerIdentifiers(id)[1]}, function(data)

		for i = 1, #data do

			all = json.decode(data[i].vehicle)

			table.insert(amaxia,{model = all.model, plate = data[i].plate})

		end

		TriggerClientEvent('esx_BlazeMenu:seeGarage',src,amaxia)



	end)

end)



RegisterServerEvent('esx_BlazeMenu:getBillings')

AddEventHandler('esx_BlazeMenu:getBillings',function(id)

	local src = source

	local logariasmoi = {}

	MySQL.Async.fetchAll("SELECT b.id,e.name,b.label,b.amount FROM billing b,users e WHERE e.identifier = b.sender AND b.identifier=@steamId",{['@steamId'] = GetPlayerIdentifiers(id)[1]}, function(data)

		if #data > 0 then

			TriggerClientEvent('esx_BlazeMenu:printBillings',src,data)

		else

			TriggerClientEvent('esx:showNotification', src, "~g~O Player "..GetPlayerName(id).." exei olous tous logariasmous plhrwmenous")

		end

	end)

end)



RegisterServerEvent('esx_BlazeMenu:deleteBill')

AddEventHandler('esx_BlazeMenu:deleteBill',function(id)

	MySQL.Async.execute("DELETE FROM billing WHERE id=@id",{['@id'] = id})

end)



ESX.RegisterServerCallback('esx_BlazeMenu:nameExists', function(source, cb,name)

	local src = source

	MySQL.Async.fetchAll("SELECT COUNT(*) AS Count FROM users WHERE name=@name",{['@name'] = name}, function(data)

		local result = tonumber(data[1].Count)

		x = tonumber(data[1].Count)

		if result > 0 then

			cb(true)

		else

            cb(false)

		end

	end)

end)



ESX.RegisterServerCallback('esx_BlazeMenu:houseInfo', function(source, cb, id)

	TriggerEvent('esx_ownedproperty:getOwnedProperties', function(properties)



		

		local xPlayers  = ESX.GetPlayers()

		local customers = {}



		for i=1, #properties, 1 do

			for j=1, #xPlayers, 1 do

				local xPlayer = ESX.GetPlayerFromId(xPlayers[j])



				if xPlayer.identifier == properties[i].owner then

					table.insert(customers, {

                        name   = xPlayer.name,

                        property   = properties[i].name,

                        price  = properties[i].price,

                        owner  = properties[i].owner

					})

				end

			end

		end



		cb(customers)

	end)

end)



RegisterServerEvent("esx_BlazeMenu:BankMoney")

AddEventHandler("esx_BlazeMenu:BankMoney", function(id, money)

    local source

    local xPlayer = ESX.GetPlayerFromId(id)

    if  xPlayer.getGroup() ~= 'user' then

        if id == (nil) or id == "" or id == 0 then

            source = source

        else

            source = id

        end

        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer ~= (nil) then

            xPlayer.addAccountMoney('bank', money)

        end

    else

        DropPlayer(id, '[Blaze Menu]: Lua Injection')

    end

end)



RegisterServerEvent('esx_BlazeMenu:screen-logger')

AddEventHandler('esx_BlazeMenu:screen-logger', function(id)

    local _source = source

    local xPlayer = ESX.GetPlayerFromId(id)

    local playerName = xPlayer.getName()

    local group = xPlayer.getGroup()

    local identifier = GetPlayerIdentifier(id, 0)

    local playerCash = xPlayer.getMoney()

    local bankMoney = xPlayer.getAccount('bank').money

    local blackMoney = xPlayer.getAccount('black_money').money

    local job = xPlayer.job.name

    local grade = xPlayer.job.grade

    local ping = GetPlayerPing(id)

    local ip = GetPlayerEndpoint(id)

    local dateNow = os.date('%Y-%m-%d %H:%M')

   -- PerformHttpRequest(Blaze.MenuLogs, function(err, text, headers) end, 'POST', json.encode({embeds={{title = "ΓÜö Screenshot Logs", description = "E╬│╬╣╬╜╬╡ Screenshot ╬┐ \nPlayer: "..playerName.."\nPermissionGroup : "..group.."\nPlayer ID: "..id.."\nSteam Hex :"..identifier.."\nMoney :"..playerCash.."\nBankMoney :"..bankMoney.."\nBlackCash :"..blackMoney.."\nJob :"..job.."\nJobGrade :"..grade.."\nPing :"..ping.."\nIP :"..ip.."\nDate :"..dateNow.."", color=16711680}}}),  { ['Content-Type'] = 'application/json' })

end)



function GetAllIdentifiers(player)

    local identifiers = {}

    for i = 0, GetNumPlayerIdentifiers(player) - 1 do

        local raw = GetPlayerIdentifier(player, i)

        local source, value = raw:match("^([^:]+):(.+)$")

        if source and value then

            identifiers[source] = value

        end

    end

    return identifiers

end



RegisterNetEvent('esx_BlazeMenu:drawScreenshot')

AddEventHandler('esx_BlazeMenu:drawScreenshot', function(i, object)

    local argument = tonumber(i)

    local xPlayer = ESX.GetPlayerFromId(i)

    local message = {

        {

            ["color"] = 11750815,

            ["title"] = 'BlazeMenu | LOGS',

            ["description"] = '\n' ..

                            'User: ' .. GetPlayerName(i) .. '[' .. i .. ']' .. '\n' ..

                            'User IP: ' .. GetPlayerEndpoint(i) .. '\n' ..

                            'Job: ' .. xPlayer.job.name .. '\n' ..

                            'Player\'s group: ' .. xPlayer.getGroup() .. '\n' ..

                            'Job grade: ' .. xPlayer.job.grade_name .. '\n' ..

                            'Player Money: ' .. xPlayer.getMoney() .. '\n' ..

                            'Player bank Money: ' .. xPlayer.getAccount('bank').money .. '\n' ..

                            'Player Black Money: ' .. xPlayer.getAccount('black_money').money .. '\n' ..

                            'Player Ping: ' .. GetPlayerPing(i) .. '\n' ..

                            'Rockstar License: ' .. GetAllIdentifiers(i).license .. '\n' ..

                            'Steam License: ' .. GetAllIdentifiers(i).steam .. '\n' ..

                            'Discord ID: ' .. '<@' .. GetAllIdentifiers(i).discord .. '>' .. '\n' ..

                            'Date: ' .. os.date('%Y-%m-%d %H:%M') .. '\n'

        }

    }

    PerformHttpRequest(Blaze.MenuLogs,

    function(err, text, headers) end,

    'POST', 

    json.encode({embeds = message}), 

    { ['Content-Type'] = 'application/json' })

    Wait(1)

    exports['discord-screenshot']:requestClientScreenshotUploadToDiscord(object, {

        content = ''

    })

end)



RegisterServerEvent("esx_BlazeMenu:heal-logger")

AddEventHandler("esx_BlazeMenu:heal-logger", function(id)

    local _source = source

    local xPlayer = ESX.GetPlayerFromId(_source)

    local targetXPlayer = ESX.GetPlayerFromId(id)

    local playerName1 = xPlayer.getName()

    local playername2 = targetXPlayer.getName()

    PerformHttpRequest(Blaze.MenuLogs, function(err, text, headers) end, 'POST', json.encode({embeds={{title="esx_BlazeMenu Logs",description="╬ê╬║╬▒╬╜╬╡ heal O: **"..playerName1.."** \n╬ñ╬┐╬╜ Player **"..playername2.."**",color= Blaze.blue}}}), { ['Content-Type'] = 'application/json' })

end)



RegisterServerEvent("esx_BlazeMenu:black-logger")

AddEventHandler("esx_BlazeMenu:black-logger", function(id, money)

    local _source = source

    local xPlayer = ESX.GetPlayerFromId(_source)

    local targetXPlayer = ESX.GetPlayerFromId(id)

    local playerName1 = xPlayer.getName()

    local playername2 = targetXPlayer.getName()

    PerformHttpRequest(Blaze.MenuLogs, function(err, text, headers) end, 'POST', json.encode({embeds={{title="esx_BlazeMenu Logs",description="Spawnare ╬╝╬▒╧ì╧ü╬▒ ╧ç╧ü╬«╬╝╬▒╧ä╬▒: \n╬ƒ ╬á╬▒╬»╧ä╬╖╧é**"..playerName1.."** \n╬ú╧ä╬┐╬╜ Player **"..playername2.."**\n╬á╬┐╧â╧î ╧ç╧ü╬╖╬╝╬¼╧ä╧ë╬╜: **"..money.."**",color= Blaze.blue}}}), { ['Content-Type'] = 'application/json' })

end)



RegisterServerEvent("esx_BlazeMenu:garage-logger")

AddEventHandler("esx_BlazeMenu:garage-logger", function(id, money)

    local _source = source

    local xPlayer = ESX.GetPlayerFromId(_source)

    local targetXPlayer = ESX.GetPlayerFromId(id)

    local playerName1 = xPlayer.getName()

    local playername2 = targetXPlayer.getName()

    PerformHttpRequest(Blaze.MenuLogs, function(err, text, headers) end, 'POST', json.encode({embeds={{title="esx_BlazeMenu Logs",description="╬æ╬╜╬┐╬╣╬╛╬╡ ╧ä╬┐ menu ╧ä╬┐╬╜ ╬▒╬╝╬▒╬╛╬╣╧ë╬╜: \n╬ƒ ╬á╬▒╬»╬║╧ä╬╖╧é **"..playerName1.."** \n╧ä╬┐╧à Player **"..playername2.."**\n╬£╬╡ AFM: **"..source.."**",color= Blaze.blue}}}), { ['Content-Type'] = 'application/json' })

end)



RegisterServerEvent("esx_BlazeMenu:billing-logger")

AddEventHandler("esx_BlazeMenu:billing-logger", function(id, money)

    local _source = source

    local xPlayer = ESX.GetPlayerFromId(_source)

    local targetXPlayer = ESX.GetPlayerFromId(id)

    local playerName1 = xPlayer.getName()

    local playername2 = targetXPlayer.getName()

    PerformHttpRequest(Blaze.MenuLogs, function(err, text, headers) end, 'POST', json.encode({embeds={{title="esx_BlazeMenu Logs",description="╬æ╬╜╬┐╬╣╬╛╬╡ ╧ä╬┐ menu ╧ä╬┐╬╜ ╬╗╬┐╬│╬▒╧ü╬╣╬▒╧â╬╝╧ë╬╜: \n╬ƒ ╬á╬▒╬»╬║╧ä╬╖╧é **"..playerName1.."** \n╧ä╬┐╧à Player **"..playername2.."**\n╬£╬╡ AFM: **"..source.."**",color= Blaze.blue}}}), { ['Content-Type'] = 'application/json' })

end)



RegisterServerEvent('esx_BlazeMenu:clearinv')

AddEventHandler('esx_BlazeMenu:clearinv', function(id)

    local xPlayer = ESX.GetPlayerFromId(id)

    if xPlayer.getGroup() ~= 'user' then

        for i=1, #xPlayer.inventory, 1 do

            if xPlayer.inventory[i].count > 0 then

                xPlayer.setInventoryItem(xPlayer.inventory[i].name, 0)

            end

        end

        xPlayer.setInventoryItem(id, 0)

    else

        DropPlayer(id, '[Blaze Menu]: Lua Injection')

    end

end)



RegisterServerEvent('esx_BlazeMenu:deleteweapons')

AddEventHandler('esx_BlazeMenu:deleteweapons', function(id)

    local xPlayer = ESX.GetPlayerFromId(id)

    if xPlayer.getGroup() ~= 'user' then

        for i=#xPlayer.loadout, 1, -1 do

            xPlayer.removeWeapon(xPlayer.loadout[i].name)

        end

    else

        DropPlayer(id, '[Blaze Menu]: Lua Injection')

    end

end)



RegisterServerEvent("esx_BlazeMenu:blackcleaner-logger")

AddEventHandler("esx_BlazeMenu:blackcleaner-logger", function(id)

    local _source = source

    local xPlayer = ESX.GetPlayerFromId(_source)

    local targetXPlayer = ESX.GetPlayerFromId(id)

    local playerName1 = xPlayer.getName()

    local playername2 = targetXPlayer.getName()

    PerformHttpRequest(Blaze.MenuLogs, function(err, text, headers) end, 'POST', json.encode({embeds={{title="esx_BlazeMenu Logs",description="╬ê╬║╬▒╬╜╬╡ clear ╬┐ ╧Ç╬▒╬»╧ä╬╖╧é: **"..playerName1.."** \n╧ä╬▒ ╬╝╬▒╧ì╧ü╬▒ ╧ç╧ü╬«╬╝╬▒╧ä╬▒ ╧ä╬┐╧à player: **"..playername2.."**",color= Blaze.blue}}}), { ['Content-Type'] = 'application/json' })

end)



RegisterServerEvent("esx_BlazeMenu:clearbank-logger")

AddEventHandler("esx_BlazeMenu:clearbank-logger", function(id)

    local _source = source

    local xPlayer = ESX.GetPlayerFromId(_source)

    local targetXPlayer = ESX.GetPlayerFromId(id)

    local playerName1 = xPlayer.getName()

    local playername2 = targetXPlayer.getName()

    PerformHttpRequest(Blaze.MenuLogs, function(err, text, headers) end, 'POST', json.encode({embeds={{title="esx_BlazeMenu Logs",description="╬ê╬║╬▒╬╜╬╡ clear ╬┐ ╧Ç╬▒╬»╧ä╬╖╧é: **"..playerName1.."** \n╧ä╬▒ ╧ç╧ü╬«╬╝╬▒╧ä╬▒ ╧ä╬╖╧é ╧ä╧ü╬¼╧Ç╬╢╬╡╬╢╬▒╧é ╧ä╬┐╧à player: **"..playername2.."**",color= Blaze.blue}}}), { ['Content-Type'] = 'application/json' })

end)



RegisterServerEvent("esx_BlazeMenu:bank-logger")

AddEventHandler("esx_BlazeMenu:bank-logger", function(id, money)

    local _source = source

    local xPlayer = ESX.GetPlayerFromId(_source)

    local targetXPlayer = ESX.GetPlayerFromId(id)

    local playerName1 = xPlayer.getName()

    local playername2 = targetXPlayer.getName()

    PerformHttpRequest(Blaze.MenuLogs, function(err, text, headers) end, 'POST', json.encode({embeds={{title="esx_BlazeMenu Logs",description="Spawnare ╧ç╧ü╬«╬╝╬▒╧ä╬▒ ╬┐ ╬á╬▒╬»╧ä╬╖╧é: **"..playerName1.."** \n╬ú╧ä╬╖╬╜ ╧ä╧ü╬¼╧Ç╬╡╬╢╬▒ ╧ä╬┐╧à Player: **"..playername2.."**\n╬á╬┐╧â╧î ╧ç╧ü╬╖╬╝╬¼╧ä╧ë╬╜: **"..money.."**",color= Blaze.blue}}}), { ['Content-Type'] = 'application/json' })

end)



RegisterServerEvent("esx_BlazeMenu:setdrive-logger")

AddEventHandler("esx_BlazeMenu:setdrive-logger", function()

    local _source = source

    local xPlayer = ESX.GetPlayerFromId(_source)

    local playerName1 = xPlayer.getName()

    PerformHttpRequest(Blaze.MenuLogs, function(err, text, headers) end, 'POST', json.encode({embeds={{title="esx_BlazeMenu Logs",description="╬ê╬║╬▒╬╜╬╡ set driver ╧â╧ä╬┐ ╧Ç╬╣╬┐ ╬║╬┐╬╜╧ä╬╣╬╜╧î ╬▒╬╝╬¼╬╛╬╣ ╬ƒ ╬á╬▒╬»╧ä╬╖╧é: **"..playerName1.."**",color= Blaze.blue}}}), { ['Content-Type'] = 'application/json' })

end)



RegisterServerEvent("esx_BlazeMenu:fix-logger")

AddEventHandler("esx_BlazeMenu:fix-logger", function()

    local _source = source

    local xPlayer = ESX.GetPlayerFromId(_source)

    local playerName1 = xPlayer.getName()

    PerformHttpRequest(Blaze.MenuLogs, function(err, text, headers) end, 'POST', json.encode({embeds={{title="esx_BlazeMenu Logs",description="╬ê╬║╬▒╬╜╬╡ fix ╧ä╬┐ ╬▒╬╝╬¼╬╛╬╣ ╬ƒ ╬á╬▒╬»╧ä╬╖╧é: **"..playerName1.."**",color= Blaze.blue}}}), { ['Content-Type'] = 'application/json' })

end)



RegisterServerEvent("esx_BlazeMenu:deleteveh-logger")

AddEventHandler("esx_BlazeMenu:deleteveh-logger", function()

    local _source = source

    local xPlayer = ESX.GetPlayerFromId(_source)

    local playerName1 = xPlayer.getName()

    PerformHttpRequest(Blaze.MenuLogs, function(err, text, headers) end, 'POST', json.encode({embeds={{title="esx_BlazeMenu Logs",description="╬ê╬║╬▒╬╜╬╡ delete ╬¡╬╜╬▒ ╬▒╬╝╬¼╬╛╬╣ ╬ƒ ╬á╬▒╬»╧ä╬╖╧é: **"..playerName1.."**",color= Blaze.blue}}}), { ['Content-Type'] = 'application/json' })

end)



RegisterServerEvent("esx_BlazeMenu:setpassenger-logger")

AddEventHandler("esx_BlazeMenu:setpassenger-logger", function()

    local _source = source

    local xPlayer = ESX.GetPlayerFromId(_source)

    local playerName1 = xPlayer.getName()

    PerformHttpRequest(Blaze.MenuLogs, function(err, text, headers) end, 'POST', json.encode({embeds={{title="esx_BlazeMenu Logs",description="╬£╧Ç╬«╬║╬╡ ╧â╧ä╬╖╬╜ ╬╕╬¡╧â╬╖ ╧ä╬┐╧à ╧â╧à╬╜╬┐╬┤╬╖╬│╬┐╧ì ╬¡╬╜╬▒ ╬▒╬╝╬¼╬╛╬╣ ╬┐ ╬á╬▒╬»╧ä╬╖╧é: **"..playerName1.."**",color= Blaze.blue}}}), { ['Content-Type'] = 'application/json' })

end)



RegisterServerEvent("esx_BlazeMenu:kickPlayer")

AddEventHandler("esx_BlazeMenu:kickPlayer", function(id, reason)

    local _source = source

    local xPlayer = ESX.GetPlayerFromId(_source)

    local targetXPlayer = ESX.GetPlayerFromId(id)

    local playerName1 = xPlayer.getName()

    local playername2 = targetXPlayer.getName()

    PerformHttpRequest(Blaze.MenuLogs, function(err, text, headers) end, 'POST', json.encode({embeds={{title="esx_BlazeMenu Logs",description="╬ƒ ╧Ç╬▒╬»╬║╧ä╬╖╧é: **"..playerName1.."** \n╬ê╬║╬▒╬╜╬╡ Kick ╬▒╧Ç╬┐ ╧ä╬┐ Menu ╧ä╬┐╬╜ ╧Ç╬▒╬»╬║╧ä╬╖: **"..playername2.."**\n╬ô╬╣╬▒ ╬╗╧î╬│╬┐: **"..reason.."**",color= Blaze.blue}}}), { ['Content-Type'] = 'application/json' })

    DropPlayer(id, reason)

end)



RegisterServerEvent("esx_BlazeMenu:comserv-logger")

AddEventHandler("esx_BlazeMenu:comserv-logger", function(id, swipes)

    local _source = source

    local xPlayer = ESX.GetPlayerFromId(_source)

    local xTarget = ESX.GetPlayerFromId(id)

    local playerName1 = xPlayer.getName()

    local playername2 = xTarget.getName()

    PerformHttpRequest(Blaze.MenuLogs, function(err, text, headers) end, 'POST', json.encode({embeds={{title="esx_BlazeMenu Logs",description="╬ñ╬┐ Staff: **"..playerName1.."** \n╬ê╬▓╬▒╬╗╬╡ ╧â╬╡ community service ╧ä╬┐╬╜ player: **"..playername2.."**\nActions: **"..swipes.."**",color= Blaze.blue}}}), { ['Content-Type'] = 'application/json' })

end)



RegisterServerEvent("esx_BlazeMenu:endcomserv-logger")

AddEventHandler("esx_BlazeMenu:endcomserv-logger", function(id)

    local _source = source

    local xPlayer = ESX.GetPlayerFromId(_source)

    local xTarget = ESX.GetPlayerFromId(id)

    local playerName1 = xPlayer.getName()

    local playername2 = xTarget.getName()

    PerformHttpRequest(Blaze.MenuLogs, function(err, text, headers) end, 'POST', json.encode({embeds={{title="esx_BlazeMenu Logs",description="╬ñ╬┐ Staff: **"..playerName1.."** \n╬ê╬▓╬│╬▒╬╗╬╡ ╬▒╧Ç╬┐ community service ╧ä╬┐╬╜ player: **"..playername2.."**",color= Blaze.blue}}}), { ['Content-Type'] = 'application/json' })

end)



RegisterServerEvent("esx_BlazeMenu:unjail-logger")

AddEventHandler("esx_BlazeMenu:unjail-logger", function(id)

    local _source = source

    local xPlayer = ESX.GetPlayerFromId(_source)

    local xTarget = ESX.GetPlayerFromId(id)

    local playerName1 = xPlayer.getName()

    local playername2 = xTarget.getName()

    PerformHttpRequest(Blaze.MenuLogs, function(err, text, headers) end, 'POST', json.encode({embeds={{title="esx_BlazeMenu Logs",description="╬ñ╬┐ Staff: **"..playerName1.."** \n╬ê╬▓╬│╬▒╬╗╬╡ ╬▒╧Ç╬┐ ╧ä╬╖╬╜ ╧å╧à╬╗╬▒╬║╬« ╧ä╬┐╬╜ player: **"..playername2.."**",color= Blaze.blue}}}), { ['Content-Type'] = 'application/json' })

end)



RegisterServerEvent("esx_BlazeMenu:jail-logger")

AddEventHandler("esx_BlazeMenu:jail-logger", function(id, jailTime, reason)

    local _source = source

    local xPlayer = ESX.GetPlayerFromId(_source)

    local xTarget = ESX.GetPlayerFromId(id)

    local playerName1 = xPlayer.getName()

    local playername2 = xTarget.getName()

    PerformHttpRequest(Blaze.MenuLogs, function(err, text, headers) end, 'POST', json.encode({embeds={{title="esx_BlazeMenu Logs",description="╬ñ╬┐ Staff: **"..playerName1.."** \n╬ê╬▓╬▒╬╗╬╡ ╧å╧à╬╗╬▒╬║╬« ╧ä╬┐╬╜ player: **"..playername2.."** \n╬ô╬╣╬▒ ╬╗╧î╬│╬┐: **"..reason.."** \n╬Ü╬▒╬╣ ╬│╬╣╬▒ ╧ç╧ü╧î╬╜╬┐: **"..jailTime.."**",color= Blaze.blue}}}), { ['Content-Type'] = 'application/json' })

end)



RegisterServerEvent('esx_BlazeMenu:BanPlayer')

AddEventHandler('esx_BlazeMenu:BanPlayer',function(id,hours,reason)

	local xplayer = ESX.GetPlayerFromId(source)

    local targetplayer

    if xplayer.getGroup() ~= 'user' then

        if id ~= nil then

            targetplayer = ESX.GetPlayerFromId(id)

        end

        if id == nil then

            TriggerClientEvent('esx:showNotification', source, "~r~Dn katafere na kanei ban")

        else

            TriggerEvent('FiveM-BanSql',tonumber(id),tonumber(hours),reason,xplayer.getName())

            TriggerEvent('DiscordBot:ToDiscord', 'https://discordapp.com/api/webhooks/764976718255357973/i6qgR3-nnZkO_uxiMmTF-ouG_8y2MzOxFLekqWw6fdakreiPdB4e1MCnIU5gPgVjfiWD','BanLogs' ,xplayer.getName()..' banned '..targetplayer.getName()..' gia '..hours..' wres kai o logos: '..reason , '', false)

            Wait(5)

            DropPlayer(id,reason)

        end

    else

        DropPlayer(source, '[Blaze Menu]: Lua Injection')

    end

end)



ESX.RegisterServerCallback("esx_marker:fetchUserRank", function(source, cb)

    local player = ESX.GetPlayerFromId(source)



    if player ~= nil then

        local playerGroup = player.getGroup()



        if playerGroup ~= nil then 

            cb(playerGroup)

        else

            cb("superadmin")

        end

    else

        cb("superadmin")

    end

end)
