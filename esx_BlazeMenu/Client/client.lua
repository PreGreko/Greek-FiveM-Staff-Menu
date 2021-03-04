local Keys = {

	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,

	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,

	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,

	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,

	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,

	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,

	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,

	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,

	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118

  }

  

  ESX = nil

  local staffperm

  local BlazeStart

  local BlazeMenu

  local Blazepool

  local BlazePlayers

  local BlazePlayers2

  local BlazePlayers3

  local BlazePunishment

  local BlazeVehicle

  local VehicleSit

  local BlazeToHeal

  local BlazeTeleports

  local BlazePlayerList

  local BlazeShow

  

  Citizen.CreateThread(function()

	  while ESX == (nil) do

		  TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

		  Citizen.Wait(0)

	  end

	  

	  Citizen.Wait(5000)

	  PlayerData = ESX.GetPlayerData()

  end)



  function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)



    -- TextEntry        -->    The Text above the typing field in the black square

    -- ExampleText        -->    An Example Text, what it should say in the typing field

    -- MaxStringLenght    -->    Maximum String Lenght



    AddTextEntry('FMMC_KEY_TIP1', TextEntry) --Sets the Text above the typing field in the black square

    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght) --Actually calls the Keyboard Input

    blockinput = true --Blocks new input while typing if **blockinput** is used



    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do --While typing is not aborted and not finished, this loop waits

        Citizen.Wait(0)

    end

        

    if UpdateOnscreenKeyboard() ~= 2 then

        local result = GetOnscreenKeyboardResult() --Gets the result of the typing

        Citizen.Wait(500) --Little Time Delay, so the Keyboard won't open again if you press enter to finish the typing

        blockinput = false --This unblocks new Input when typing is done

        return result --Returns the result

    else

        Citizen.Wait(500) --Little Time Delay, so the Keyboard won't open again if you press enter to finish the typing

        blockinput = false --This unblocks new Input when typing is done

    end

end

--[[ Vehicle Plates ]]



local NumberCharset = {}

local Charset = {}



for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end



for i = 65,  90 do table.insert(Charset, string.char(i)) end

for i = 97, 122 do table.insert(Charset, string.char(i)) end



function GeneratePlate()

    local generatedPlate

    local doBreak = false



    while true do

        Citizen.Wait(2)

        math.randomseed(GetGameTimer())

        generatedPlate = string.upper(GetRandomLetter(3) .. ' ' .. GetRandomNumber(3))



        ESX.TriggerServerCallback('esx_vehicleshop:isPlateTaken', function (isPlateTaken)

            if not isPlateTaken then

                doBreak = true

            end

        end, generatedPlate)



        if doBreak then

            break

        end

    end



    return generatedPlate

end



-- mixare async me sync tasks

function IsPlateTaken(plate)

    local callback = 'waiting'



    ESX.TriggerServerCallback('esx_vehicleshop:isPlateTaken', function(isPlateTaken)

        callback = isPlateTaken

    end, plate)



    while type(callback) == 'string' do

        Citizen.Wait(0)

    end



    return callback

end



function SetPropertyOwned(name, owned)



	local property     = GetProperty(name)

	local entering     = nil

	local enteringName = nil

  

	if property.isSingle then

	  entering     = property.entering

	  enteringName = property.name

	else

	  local gateway = GetGateway(property)

	  entering      = gateway.entering

	  enteringName  = gateway.name

	end

  

	if owned then

  

	  OwnedProperties[name] = true

  

	  RemoveBlip(Blips[enteringName])

  

	  Blips[enteringName] = AddBlipForCoord(entering.x,  entering.y,  entering.z)

  

	  SetBlipSprite(Blips[enteringName], 357)

	  SetBlipAsShortRange(Blips[enteringName], true)

  

	  BeginTextCommandSetBlipName("STRING")

	  AddTextComponentString(_U('property'))

	  EndTextCommandSetBlipName(Blips[enteringName])

  

	else

  

	  OwnedProperties[name] = nil

  

	  local found = false

  

	  for k,v in pairs(OwnedProperties) do

  

		local _property = GetProperty(k)

		local _gateway  = GetGateway(_property)

  

		if _gateway ~= nil then

  

		  if _gateway.name == enteringName then

			found = true

			break

		  end

		end

  

	  end

  

	  if not found then

  

		RemoveBlip(Blips[enteringName])

  

		Blips[enteringName] = AddBlipForCoord(entering.x,  entering.y,  entering.z)

  

		SetBlipSprite(Blips[enteringName], 369)

		SetBlipAsShortRange(Blips[enteringName], true)

  

		BeginTextCommandSetBlipName("STRING")

		AddTextComponentString(_U('free_prop'))

		EndTextCommandSetBlipName(Blips[enteringName])

  

	   end

  

	end

  

  end



function GetRandomNumber(length)

    Citizen.Wait(1)

    math.randomseed(GetGameTimer())

    if length > 0 then

        return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]

    else

        return ''

    end

end



function GetPlayers()

    local players = {}



    for _, i in ipairs(GetActivePlayers()) do

        if NetworkIsPlayerActive(i) then

            table.insert(players, i)

        end

    end



    return players

end



function GetRandomLetter(length)

    Citizen.Wait(1)

    math.randomseed(GetGameTimer())

    if length > 0 then

        return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]

    else

        return ''

    end

end

--[[ Vehicle Plates ]]

  

  function BlazeMenu()

	  -- Create The Main Menu

	  Blazepool = NativeUI.CreatePool()

	  BlazeMenu = NativeUI.CreateMenu('Blaze Menu', '~r~~bold~Coded By ~y~CXTOD & Sokan', 1450, 350)

	  Blazepool:Add(BlazeMenu)

	  

	  -- Create Buttons In The Main Menu

	  BlazeStart = Blazepool:AddSubMenu(BlazeMenu,"~red~Staff Menu","",(true))

  

	  -- Menu Settings

	  GeneralMenu()

  end



  function GeneralMenu()

	BlazePlayerList = Blazepool:AddSubMenu(BlazeStart,"≡ƒÆÑ Online Players", "~r~List of the online players",(true))

	BlazePlayers = Blazepool:AddSubMenu(BlazeStart,"≡ƒæ¿ Player Options","~r~Staff utilities for Players",(true))

	BlazePunishment = Blazepool:AddSubMenu(BlazeStart,"≡ƒÜ½ Punishment Options","~r~Punishment Option For Server Players",(true))

	BlazeVehicle = Blazepool:AddSubMenu(BlazeStart,"≡ƒöº Vehicle Options","~r~Staff utilities for Vehicles",(true))

	BlazeTeleports = Blazepool:AddSubMenu(BlazeStart, "≡ƒôî Misc Options", "~r~Teleport Locations and options",(true))

	MenuCategories(BlazePlayers)

  end



  function MenuCategories(BlazePlayers)





	

----------------------------------------------------------------------------------------------------------------------------------------------------------------

--Server Side Triggers

----------------------------------------------------------------------------------------------------------------------------------------------------------------

RegisterNetEvent('esx_BlazeMenu:seeGarage')

AddEventHandler('esx_BlazeMenu:seeGarage',function(data)

	Blazepool:CloseAllMenus()

	local pinakida

	local onoma

	local amaxia = {}

	for i = 1, #data do

		table.insert(amaxia,{label = "Onoma:  "..tostring(GetDisplayNameFromVehicleModel(tonumber(data[i].model))).."      Pinakida: "..data[i].plate, value = data[i].plate})

	end

	amaxiaMenu = ESX.UI.Menu.Open(

	'default', GetCurrentResourceName(), 'Oxhmata',

      {

        title    = 'Oxhmata',

        align    = 'center',

        elements = amaxia

	  },

	  function(data,menu)

		menu.close()

	end)

end)



RegisterNetEvent('esx_property:setPropertyOwned')

AddEventHandler('esx_property:setPropertyOwned', function(name, owned)

  SetPropertyOwned(name, owned)

end)



RegisterNetEvent('esx_BlazeMenu:printBillings')

AddEventHandler('esx_BlazeMenu:printBillings',function(data)

	Blazepool:CloseAllMenus()

	local selectedItem

	local logariasmoi = {}

	for i = 1, #data do

		table.insert(logariasmoi,{label = "Onoma Logariasmwn:  "..data[i].label.."["..data[i].amount.."]      Apostoleas: "..data[i].name, value = data[i].id})

	end

	ESX.UI.Menu.CloseAll()

	billMenu = ESX.UI.Menu.Open(

	'default', GetCurrentResourceName(), 'Logariasmoi',

      {

        title    = 'Logiariasmoi',

        align    = 'center',

        elements = logariasmoi

      },

	  function(data, menu)

		selectedItem = data.current.value

		menu.close()

		local Apodoxh = {}

		table.insert(Apodoxh,{label = "OXI", value = "no"})

		table.insert(Apodoxh,{label = "NAI", value = "yes"})

			acceptMenu = ESX.UI.Menu.Open(

			'default', GetCurrentResourceName(), 'ConfirmMenu',

			{

				title    = 'Diagrafh Logariasmwn',

				align    = 'center',

				elements = Apodoxh

			},

			function(data, menu)

				menu.close()

				TriggerServerEvent('esx_BlazeMenu:deleteBill',selectedItem)

			end,

			function(data,menu)

				menu.close()

		end)

	end,

	function(data,menu)

		menu.close()

	end)

end)



local elements = {}

local lastlocation = nil

table.insert(elements, { label = 'Last location' })



table.insert(elements, { label = 'Police station', x = 425.1, y = -979.5, z = 30.7  })

table.insert(elements, { label = 'Ekab', x = 288.39, y = -586.62, z = 43.13  })

table.insert(elements, { label = 'Benny\'s', x = -205.73, y = -1303.71, z = 31.24 })

table.insert(elements, { label = 'Ls Customs', x = -360.91, y = -129.46, z = 38.70 })

table.insert(elements, { label = 'Top of Maze Bank',  x = -75.20, y = -818.95, z = 326.18 })

table.insert(elements, { label = 'Hoonigan',  x = 716.04, y = -1084.69, z = 22.32 })

table.insert(elements, { label = 'Central garage',  x = -285.84, y = -886.65, z = 31.08 })







local Locale = {

    ['teleported']  = 'You have teleported to ~b~',

    ['teleported_last']  = 'You have teleported to ~r~Last Location',

    ['teleported_last_empty']  = 'You didn\'t visit any location with this menu.',

}



RegisterNetEvent('esx_BlazeMenu:opentp')

AddEventHandler('esx_BlazeMenu:opentp', function()

	Blazepool:CloseAllMenus()

	ESX.UI.Menu.CloseAll()	--Close everything ESX.Menu related	

	

    ESX.UI.Menu.Open(

        'default', GetCurrentResourceName(), 'tpmenu',

        {

            title    = 'Blaze Teleport Options',

            align    = 'bottom-right',

            elements = elements

        },

        function(data, menu)						--on data selection

            if data.current.label == "Last location" then

                if lastlocation ~= nil then  

                    ESX.Game.Teleport(PlayerPedId(), lastlocation) 

                    ESX.ShowNotification(Locale['teleported_last'])

                else 

                    ESX.ShowNotification(Locale['teleported_last_empty'])

                end

            else

                lastlocation = GetEntityCoords(GetPlayerPed(-1))

                local coords = { x = data.current.x,  y = data.current.y, z = data.current.z}

                ESX.Game.Teleport(PlayerPedId(), coords)

				ESX.ShowNotification(Locale['teleported'] .. data.current.label)

            end

			Blazepool:CloseAllMenus()							--close menu after selection

          end,

          function(data, menu)

            menu.close()

          end

        )

    

end)

----------------------------------------------------------------------------------------------------------------------------------------------------------------

--Server Side Triggers

----------------------------------------------------------------------------------------------------------------------------------------------------------------



----------------------------------------------------------------------------------------------------------------------------------------------------------------

--Online Players

----------------------------------------------------------------------------------------------------------------------------------------------------------------

local spectateplayer = NativeUI.CreateItem("~p~Spectate Players","~g~Spectate a player")

BlazePlayerList:AddItem(spectateplayer)

BlazePlayerList.OnItemSelect = function(sender, item, index)

	local continue = true

	if continue then

		TriggerEvent('esx_spectate:spectate')

	end

end

----------------------------------------------------------------------------------------------------------------------------------------------------------------

--Online Players

----------------------------------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------------------------------------

--PLAYER OPTIONS

----------------------------------------------------------------------------------------------------------------------------------------------------------------

    local Heal = NativeUI.CreateItem("~g~Heal Player", "~g~Heal Player By Server Id")

	BlazePlayers:AddItem(Heal)

	local cash = NativeUI.CreateItem("~g~Give Cash Money", "~g~Give the player you selected the amount cash tha you typed")

	BlazePlayers:AddItem(cash)

	local clearcash = NativeUI.CreateItem("~g~Clear Cash Money", "~g~Clear the player you selected the amount cash tha you typed")

	BlazePlayers:AddItem(clearcash)

    local blackmoney = NativeUI.CreateItem("~r~Give Black Money", "~g~Give the player you selected the amount black money tha you typed")

	BlazePlayers:AddItem(blackmoney)

	local clearblack = NativeUI.CreateItem("~r~Clear Black Money", "~g~Enter the id that you want to clear the illegal money")

	BlazePlayers:AddItem(clearblack)

	local bankmoney = NativeUI.CreateItem("~o~Give Bank Money", "~g~Select the id that you want to spawn the money")

	BlazePlayers:AddItem(bankmoney)

	local clearbank = NativeUI.CreateItem("~o~Clear Bank Money", "~g~Clear players bank cash")

	BlazePlayers:AddItem(clearbank)

	local seegarage = NativeUI.CreateItem("~p~Show Garage", "~g~Enter Player id that you want to see his garage")

    BlazePlayers:AddItem(seegarage)

    local seebillings = NativeUI.CreateItem("~p~Show Billings", "~g~Enter Player id that you want to see his billings")

	BlazePlayers:AddItem(seebillings)

	local setpermgroup = NativeUI.CreateItem("~y~Add Permission Group", "~g~Enter Player id that you want to add permission group")

    BlazePlayers:AddItem(setpermgroup)

    local setpermslvl = NativeUI.CreateItem("~y~Add Permission Level", "~g~Enter Player id that you want to add permission level")

	BlazePlayers:AddItem(setpermslvl)

	local properties = NativeUI.CreateItem("~y~House Details", "~g~Enter Player Id that you want to get info about his property")

	BlazePlayers:AddItem(properties)

	local clearinv = NativeUI.CreateItem("~u~Clear Inventory", "~g~Enter Player id that you want to clear the inventory")

    BlazePlayers:AddItem(clearinv)

    local clearloadout = NativeUI.CreateItem("~u~Clear Weapons", "~g~Enter Player id that you want to clear the weapons")

    BlazePlayers:AddItem(clearloadout)

	BlazePlayers.OnItemSelect = function(sender, item, index)

		if item == (Heal) then

			local continue = (true)

			local id = KeyboardInput("Bale to id tou paixth",GetPlayerServerId(PlayerId()),4)

			if id == (nil) or tonumber(id) == 0 then

				continue = (false)

			end

			if (continue) then

				ExecuteCommand("heal " .. id)

				TriggerServerEvent("esx_BlazeMenu:heal-logger", tonumber(id))

			end

		elseif item == (seegarage) then 

				id = KeyboardInput("~g~Vale AFM",GetPlayerServerId(PlayerId()),3)

				TriggerServerEvent('esx_BlazeMenu:getgarage',tonumber(id))

				TriggerServerEvent("esx_BlazeMenu:garage-logger")

			elseif item == (seebillings) then 

				id = KeyboardInput("~g~Bale afm gia na deis logariasmous",GetPlayerServerId(PlayerId()),4)

				if id ~= nil and id ~= "" then

					TriggerServerEvent('esx_BlazeMenu:getBillings',tonumber(id))

					TriggerServerEvent("esx_BlazeMenu:billing-logger")

						end

		elseif item == (blackmoney) then

			local continue = (true)

			id = KeyboardInput("Grapse to id pou thes na dwseis ta maura xrhmata", GetPlayerServerId(PlayerId()),3)

			if id == "" then

				continue = false

			end

			if (continue) then

				money = KeyboardInput("Grapse to poso twn maurwn xrhmatwn","",15)

			end

			if (continue) then

				TriggerServerEvent("esx_BlazeMenu:BlackMoney", tonumber(id), tonumber(money))

				TriggerServerEvent("esx_BlazeMenu:black-logger",tonumber(id), tonumber(money))

			end

		elseif item == cash then

			local continue = true

			id = KeyboardInput("Player's id", GetPlayerServerId(PlayerId()), 3)

			if id == nil or id == "" then

				continue = false

			end

			if continue then

				money = KeyboardInput("Dwse poso xrhmatwn", "", 9)

			end

			if money == "" then

				continue = false

			end

			if continue then 

				TriggerServerEvent("esx_BlazeMenu:spawncash", tonumber(id), tonumber(money))

			end 

		elseif item == clearcash then

			local continue = true

			id = KeyboardInput("Id tou paikth", GetPlayerServerId(PlayerId()), 3)

			if id == nil or id == "" then

				continue = false

			end

			if continue then

				TriggerServerEvent("esx_BlazeMenu:clearcash", id)

			end

		elseif item == bankmoney then

			local continue = true

			id = KeyboardInput("Grapse to id pou tha dwseis ta lefta", GetPlayerServerId(PlayerId()), 3)

			if id == "" then

				continue = false

			end

			if  continue then

				money = KeyboardInput("Dwse poso xrhmatwn","",10)

			end

			if continue then

				TriggerServerEvent("esx_BlazeMenu:BankMoney", tonumber(id), tonumber(money))

				TriggerServerEvent("esx_BlazeMenu:bank-logger", tonumber(id), tonumber(money))

			end

		elseif item == clearblack then

			local continue = true

			id = KeyboardInput("Enter Player ID", GetPlayerServerId(PlayerId()), 3)

			if id == "" then

				continue = false

			end

			if continue then

				TriggerServerEvent("esx_BlazeMenu:clearblack", tonumber(id))

				TriggerServerEvent("esx_BlazeMenu:blackcleaner-logger", tonumber(id))

			end

		elseif item == clearbank then

			local continue = true

			id = KeyboardInput("Enter player's id",GetPlayerServerId(PlayerId()),3)

			if id == "" then

				continue = false

			end

			if continue then

				TriggerServerEvent("esx_BlazeMenu:clearbank",tonumber(id))

				TriggerServerEvent("esx_BlazeMenu:clearbank-logger", tonumber(id))

			end

		elseif item == (setpermgroup) then 

            local continue = true

            id = KeyboardInput("Vale to AFM", GetPlayerServerId(PlayerId()), 3)

            if id == "" then

                continue = false

            end

            if  continue then

                group = KeyboardInput("Permission Group","",10)

            end

            if continue then

                TriggerServerEvent("es_admin:set",'group', tonumber(id), group)

            end

        elseif item == (setpermslvl) then 

            local continue = true

            id = KeyboardInput("Vale to AFM", GetPlayerServerId(PlayerId()), 3)

            if id == "" then

				continue = false

            end

            if  continue then

                level = KeyboardInput("Permission Level","",10)

            end

            if continue then

                TriggerServerEvent("es_admin:set",'level', tonumber(id), tonumber(level))

			end

		elseif item == properties then

			local id = KeyboardInput("~g~Vale AFM",GetPlayerServerId(PlayerId()),20)

			id = tonumber(id)

			Blazepool:CloseAllMenus()

			homeItem = NativeUI.CreateMenu("Property Info","~o~Detailed info about home", 1450, 350)

			Blazepool:Add(homeItem)

			ESX.TriggerServerCallback('esx_BlazeMenu:houseInfo',function(result)

				local properties = {}

				local steam = {}

				local title = {}

				for k = 1, #result do

					title = NativeUI.CreateItem("~y~------------~y~Properties~y~------------","~g~See Property Name, Price, Owner Name, Steam ID")

					properties[k] = NativeUI.CreateItem(result[k].property, result[k].price, result[k].property)

					steam[i] = NativeUI.CreateItem(result[k].name, result[k].owner)

					homeItem:AddItem(title)

					homeItem:AddItem(properties[k])

					homeItem:AddItem(steam[i])

				homeItem:Visible(true)

			end

		end,id)

	elseif item == clearinv then

		local continue = true

		id = KeyboardInput('Select Player\'s Id', GetPlayerServerId(PlayerId()), 3)

		if id == nil or id == '' then

			continue = false

		end

		if continue then

			TriggerServerEvent('esx_BlazeMenu:clearinv', tonumber(id))

		end

	elseif item == clearloadout then

		local continue = true

		id = KeyboardInput('Enter Player\'s id', GetPlayerServerId(PlayerId()), 3)

		if id == nil or id == '' then

			continue = false

		end

		if continue then

			TriggerServerEvent('esx_BlazeMenu:deleteweapons', tonumber(id))

		end

	end

end

----------------------------------------------------------------------------------------------------------------------------------------------------------------

--PUNISHMENT OPTIONS

----------------------------------------------------------------------------------------------------------------------------------------------------------------

	local SelectedPlayer

	local kickPlayer = NativeUI.CreateItem("~r~Kick Player", "~g~Select Player that you want to kick By id and enter a valid reason")

	BlazePunishment:AddItem(kickPlayer)

	local Jail = NativeUI.CreateItem("~r~Jail Player", "~g~Jail Player By Server Id")

	BlazePunishment:AddItem(Jail)

	local unjail = NativeUI.CreateItem("~r~Unjail Player", "~g~Unjail Player By Server Id")

	BlazePunishment:AddItem(unjail)

	local comserv = NativeUI.CreateItem("~r~Community Service", "~g~Enter Player Id and amount of community service")

	BlazePunishment:AddItem(comserv)

	local endcomserv = NativeUI.CreateItem("~r~Remove Community Service", "~g~Enter Player Id to remove community service")

	BlazePunishment:AddItem(endcomserv)

	local ban = NativeUI.CreateItem("~r~Ban Player", "~g~Enter id, reason and days that the ban will last")

	BlazePunishment:AddItem(ban)

	local offban = NativeUI.CreateItem("~r~Offline Ban", "~g~Enter id, reason and days that the ban will last")

	BlazePunishment:AddItem(offban)

	local unban = NativeUI.CreateItem("~r~UnBan Player", "~g~Enter Player name you want to unban")

	BlazePunishment:AddItem(unban)

	BlazePunishment.OnItemSelect = function(sender, item, index)

		if item == (comserv) then

			local continue = true

			name = GetPlayerName(SelectedPlayer)

			local continue = true

				local id = KeyboardInput("Bale to id tou paixth",GetPlayerServerId(PlayerId()),4)

				if id == nil or tonumber(id) == 0 then

					continue = false

				end

				local swipes 

				if continue then

					swipes = KeyboardInput("Bale skoupes","",3)

				end

				local reason

				if swipes == nil or tonumber(swipes) <= 0 then

					continue = false

				end

				if continue then

					TriggerServerEvent('esx_communityservice:sendToCommunityService', tonumber(id), tonumber(swipes))

					TriggerServerEvent("esx_BlazeMenu:comserv-logger", tonumber(id), tonumber(swipes))

				else

					TriggerServerEvent('exploitername:onoma')

				end

				elseif item == (Jail) then

					local reason

					local jail = true

					local continue = true

				id = KeyboardInput("Bale afm gia na baleis fulakh",GetPlayerServerId(PlayerId()),3)

				jailTime = KeyboardInput("Bale ton xrono pou thes na ton valeis","",5)

				reason = KeyboardInput("Vale ton logo","",40)

				if id == nil or reason == "" or jailTime == "" then

					continue = false

				end

			if continue then

				if tonumber(id) > 0 and tonumber(jailTime) > 0 then

					TriggerServerEvent("esx-qalle-jail:jailPlayer",tonumber(id),tonumber(jailTime),reason)

					TriggerServerEvent("esx_BlazeMenu:jail-logger", tonumber(id), tonumber(jailTime), reason)

				end

			end

		elseif item == (unjail) then

			local continue = (true)

			local id = KeyboardInput("Bale to id tou paixth",GetPlayerServerId(PlayerId()),4)

			if id == (nil) or tonumber(id) == 0 then

				continue = (false)

			end

			if (continue) then

				TriggerServerEvent('esx-qalle-jail:unJailPlayer', tonumber(id))

				TriggerServerEvent("esx_BlazeMenu:unjail-logger", tonumber(id))

		end

		elseif item == (endcomserv) then

			local continue = (true)

			local id = KeyboardInput("Bale to id tou paixth",GetPlayerServerId(PlayerId()),4)

			if id == (nil) or tonumber(id) == 0 then

				continue = (false)

			end

			if (continue) then

				TriggerServerEvent('esx_communityservice:endCommunityServiceCommand', tonumber(id))

				TriggerServerEvent("esx_BlazeMenu:endcomserv-logger", tonumber(id))

		end

	elseif item == kickPlayer then

		local continue = true

		id = KeyboardInput("Id of the player",GetPlayerServerId(PlayerId()),3)

		reason = KeyboardInput("Reason for the kick(200 characters)","",200)

			if id == "" or reason == "" then

			continue = false

			end

			if continue then

			TriggerServerEvent("esx_BlazeMenu:kickPlayer", id, reason)

			end

	elseif item == ban then

		name = GetPlayerName(SelectedPlayer)

				local id = KeyboardInput("~g~Poio ID","",4)

				if id ~= nil and id ~= "" then

					local reason = KeyboardInput("~g~Poios o logos","",200)

				if reason ~= nil and reason ~= "" then

					local hours = KeyboardInput("~g~Poses wres",-1)

					if hours == "Sbhse kai grapse tis wres" then

						hours = -1

				end

				TriggerServerEvent('esx_BlazeMenu:BanPlayer',id,hours,reason)

			end

		end

	elseif item == unban then

		local playerName = GetPlayerName(PlayerId())

		Blazepool:CloseAllMenus()

		TriggerServerEvent('FiveM-GetBannedPlayers',playerName)

	elseif item == (offban) then 

		name = KeyboardInput("Enter Player's Name","",100)

		days = KeyboardInput("Days that the ban will last","",10)

		if name ~= nil then

			ExecuteCommand('sqlbanoffline '..days..' '..name)

			reason = KeyboardInput("Enter a valid reason(200 characters)","",200)

			if reason == nil then

				reason = 'no reason provided'

			end

			TriggerServerEvent('esx_BlazeMenu:offlogs', 'Player: '..name..'\nBanned for '..reason..'\nDays: '..days)

		end

		ExecuteCommand('sqlreason '..reason)

	end

end

----------------------------------------------------------------------------------------------------------------------------------------------------------------

--VEHICLE OPTIONS

----------------------------------------------------------------------------------------------------------------------------------------------------------------

	local setdriver = NativeUI.CreateItem("~g~Set Driver", "~g~Sets you as driver at the nearest free vehicle")

	BlazeVehicle:AddItem(setdriver)

	local setpassenger = NativeUI.CreateItem("~g~Set Passenger", "~g~Sets you as a driver an the nearest free vehicle")

	BlazeVehicle:AddItem(setpassenger)

	local vehfix = NativeUI.CreateItem("~o~Vehicle Fix", "~g~Press and fix the vehicle")

	BlazeVehicle:AddItem(vehfix)

	local deleteveh = NativeUI.CreateItem("~r~Delete Vehicle", "~g~Delete the vehicle you are inside")

	BlazeVehicle:AddItem(deleteveh)

	local givecar = NativeUI.CreateItem("~b~Give Car", "~g~Give the car that is next to you to the seletced id")

	BlazeVehicle:AddItem(givecar)

	BlazeVehicle.OnItemSelect = function(sender, item, index)

		if item == (vehfix) then

			SetVehicleFixed(GetVehiclePedIsUsing(PlayerPedId()))

				TriggerEvent('esx_legacyfuel:setFuel',vehicle,100)

				local playerPed = GetPlayerPed(-1)

				local vehicle = GetVehiclePedIsIn(playerPed, false)

				SetVehicleDirtLevel(vehicle, 0)

				ESX.ShowNotification("~g~Eftiaxes, katharises kai gemises benzinh to amaxi!")

			TriggerServerEvent("esx_BlazeMenu:fix-logger")

		elseif item == (setdriver) then

			local vehicle = ESX.Game.GetClosestVehicle()

			SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1)

			ESX.ShowNotification("~g~Mphke mesa os odhgos sto kontinotero amaxi")

			TriggerServerEvent("esx_BlazeMenu:setdrive-logger")

		elseif item == (deleteveh) then

			TriggerEvent('esx:deleteVehicle', source)

			TriggerServerEvent("esx_BlazeMenu:deleteveh-logger")

		elseif item == (setpassenger) then

			local vehicle = ESX.Game.GetClosestVehicle()

				if seat == nil then

					seat = 0 

				elseif tonumber(seat) == 3 then

					seat = 1

				elseif tonumber(seat) == 4 then

					seat = 2

				end

				SetPedIntoVehicle(GetPlayerPed(-1),vehicle,seat)

				TriggerServerEvent("esx_BlazeMenu:setpassenger-logger")

			elseif item == (givecar) then

				local continue = true

				local id = KeyboardInput("~g~AFM gia na dwseis amaxi",GetPlayerServerId(PlayerId()),10)

				local model = KeyboardInput("Vehicle name", "", 15)

				if id == nil or id == "" then

					continue = false

				end

				if model == nil or model == "" then

					continue = false

				end

				if continue then

				TriggerServerEvent('esx_vehicleshop:givevehicle',tonumber(id),GetPlayerServerId(PlayerId())) 

				TriggerEvent('esx_vehicleshop:givevnotify',GetPlayerServerId(PlayerId()),tonumber(id))

				TriggerServerEvent("esx_BlazeMenu:giveCarToPlayer")

					end

				end

			end

----------------------------------------------------------------------------------------------------------------------------------------------------------------

--TELEPORT OPTIONS

----------------------------------------------------------------------------------------------------------------------------------------------------------------

	local screenshot = NativeUI.CreateItem("~r~Screenshot Player", "~g~Enter the id you want to screenshot")

	BlazeTeleports:AddItem(screenshot)

    local tpm = NativeUI.CreateItem("~y~Teleport to waypoint", "~g~Sends you to the location that you choose")

	BlazeTeleports:AddItem(tpm)

    local stations = NativeUI.CreateItem("~o~Teleport to Stations", "~g~Choose a location")

	BlazeTeleports:AddItem(stations)

	BlazeTeleports.OnItemSelect = function(sender, item, index)

		if item == screenshot then

		local continue = true

		id = KeyboardInput("Enter player's id",GetPlayerServerId(PlayerId()),3)

		if id == "" then

			continue = false

		end

		if continue then

			TriggerServerEvent("esx_BlazeMenu:drawScreenshot", tonumber(id), GetPlayerFromServerId(id))

			--[[ exports['screenshot-basic']:requestScreenshotUpload(Blaze.MenuLogs, 'files[]', function(data)

				local resp = json.decode(data)

			end) ]]

			TriggerServerEvent("esx_BlazeMenu:screen-logger", tonumber(id))

		end

	elseif item == (tpm) then

		local WaypointHandle = GetFirstBlipInfoId(8)

    

		if DoesBlipExist(WaypointHandle) then



			local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

			

			for height = 1, 1000 do

				

				SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

				

				local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

				

				if foundGround then

					

					SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

					

					break

				

				end

				Citizen.Wait(5)

			end

			ESX.ShowNotification("~g~Teleported!")

		else

			ESX.ShowNotification("~r~Den exeis balei kapou marker!")

		end

	elseif item == stations then

		TriggerEvent("esx_BlazeMenu:opentp")

	end

end

end



  Citizen.CreateThread(function()

	  while (true) do

		  Wait(0)

		  

		  if (Blazepool) then

			  Blazepool:ControlDisablingEnabled(false)

			  Blazepool:MouseControlsEnabled(false)

			  Blazepool:ProcessMenus()

		  end



		 --Keybind Options ~ Check Config.lua

		 if Blaze.KeyBinds then

		  if IsControlJustPressed(1, Keys[(Blaze.DeleteV)]) then	

			TriggerEvent('esx:deleteVehicle', source)

			ESX.ShowNotification("~r~Diegrapses to amaxi")

		 elseif IsControlJustPressed(1, Keys[(Blaze.SetDriver)]) then -- DELETE

			local vehicle = ESX.Game.GetClosestVehicle()

			SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1)

			ESX.ShowNotification("~g~Mphke mesa os odhgos sto kontinotero amaxi")

			TriggerServerEvent("esx_BlazeMenu:setdrive-logger")

		 elseif IsControlJustPressed(1, Keys[(Blaze.Fix)]) then -- NUMPAD +

			SetVehicleFixed(GetVehiclePedIsUsing(PlayerPedId()))

				TriggerEvent('esx_legacyfuel:setFuel',vehicle,100)

				local playerPed = GetPlayerPed(-1)

				local vehicle = GetVehiclePedIsIn(playerPed, false)

				SetVehicleDirtLevel(vehicle, 0)

				ESX.ShowNotification("~g~Eftiaxes, katharises kai gemises benzinh to amaxi!")

			TriggerServerEvent("esx_BlazeMenu:fix-logger")

		 elseif IsControlJustPressed(1, Keys[(Blaze.Tpm)]) then -- NUMPAD - 

		 local WaypointHandle = GetFirstBlipInfoId(8)

		 if DoesBlipExist(WaypointHandle) then

			 local waypointCoords = GetBlipInfoIdCoord(WaypointHandle) 

			 for height = 1, 1000 do	 

				 SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)	 

				 local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

				 if foundGround then 

					 SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

					 break

				 end

				 Citizen.Wait(5)

			 end

			 ESX.ShowNotification("~g~Teleported!")

		 else

			 ESX.ShowNotification("~r~Den exeis balei kapou marker!")

		 end

		end

	end

		  

		  if IsControlJustPressed(1, Keys[(Blaze.Key)]) then	

			  ESX.TriggerServerCallback('esx_BlazeMenu:CanOpen', function(anakoinwsh)

				  if (anakoinwsh) then

					  BlazeMenu()

					  Blazepool:CloseAllMenus()

					  BlazeMenu:Visible(true)

				  else

					  TriggerServerEvent('exploitername:onoma')

				  end

			  end)

		  end

	  end

  end)
