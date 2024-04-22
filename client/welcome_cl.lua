ESX = exports['es_extended']:getSharedObject()

RegisterCommand(Config.CommanName, function(source, args)
    ESX.TriggerServerCallback('GMD_Rewards:itsPlayerNew',function(itsNew)

        debugprint('cl new')
        debugprint(itsNew)

        if itsNew then
            TriggerServerEvent('GMD_Rewards:giveWelcomeGift')
        else
            ESX.ShowNotification(ConfigLocal.WelcomeLocals['hasWelcomeGift'])
        end
    end)
end, false)

RegisterNetEvent('GMD_Rewards:giveNotify')
AddEventHandler('GMD_Rewards:giveNotify', function(dataToSend)
    local player = PlayerId()
    local notificationText = ConfigLocal.WelcomeLocals['welcomeNotifyText']

    debugprint(ESX.DumpTable(dataToSend))

    if dataToSend["vehicle"] then

        debugprint(dataToSend["vehicle"])

        local vehicleName = dataToSend["vehicle"]
        local parkingGarage = dataToSend["parkingGarage"]
        local firstLetter = string.upper(string.sub(vehicleName, 1, 1))
        local restOfName = string.sub(vehicleName, 2)
        local formattedVehicleName = firstLetter .. restOfName

        notificationText = notificationText .. ConfigLocal.WelcomeLocals['welcomeVehicleNotifyText']:format(formattedVehicleName, parkingGarage)
    end

    if dataToSend["items"] and next(dataToSend["items"]) ~= nil then
        notificationText = notificationText .. ConfigLocal.WelcomeLocals['welcomeItemNotifyTitle']
        for itemName, amount in pairs(dataToSend["items"]) do
            notificationText = notificationText .. ConfigLocal.WelcomeLocals['welcomeItemNotifyText']:format(amount, itemName)
        end
    end

    if dataToSend["money"] then
        notificationText = notificationText .. ConfigLocal.WelcomeLocals['welcomeMoneyNotifyText']:format(dataToSend["money"])
    end

    local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId())
    ESX.ShowAdvancedNotification(ConfigLocal.WelcomeLocals['welcomeNotifyTitle'], GetPlayerName(player), notificationText, mugshotStr, 1)
    UnregisterPedheadshot(mugshot)
end)