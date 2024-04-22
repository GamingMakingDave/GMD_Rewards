ESX = exports['es_extended']:getSharedObject()

local playerTimeTable = {}

function GetCoins()
    local src = source
    local identifiers = GetPlayerIdentifiers(src)

    for _, identifier in ipairs(identifiers) do
        local result = MySQL.query.await('SELECT coin FROM users WHERE identifier = @identifier', {['@identifier'] = identifier})

        if not result or #result == 0 then
            return 0
        end

        local playerCoins = result[1].coin
        debugprint(playerCoins)
        return playerCoins
    end
end

exports['GMD_Rewards']:GetCoins()

RegisterServerEvent('GMD_Rewards:updateTimeServer')
AddEventHandler('GMD_Rewards:updateTimeServer', function(rewards_currenttime)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerName = GetPlayerName(source)
    local found = false

    debugprint("Lizenz für Spieler " .. playerName .. ": " .. xPlayer.getIdentifier())

    for _, entry in ipairs(playerTimeTable) do
        if entry.identifier == xPlayer.getIdentifier() then
            debugprint("Zeit aktualisiert")
            entry.time = rewards_currenttime
            found = true
            break
        end
    end

    if not found then
        debugprint("Neuer Spieler")
        table.insert(playerTimeTable, {identifier = xPlayer.getIdentifier(), time = rewards_currenttime})
    end
end)

RegisterServerEvent('GMD_Rewards:giveCoins')
AddEventHandler('GMD_Rewards:giveCoins', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    local result = MySQL.Sync.fetchScalar('SELECT rewards_coins FROM users WHERE identifier = @identifier', {['@identifier'] = xPlayer.identifier})

    if result then
        local newCoinAmount = result + Config.CoinAmount
        debugprint(newCoinAmount)
        MySQL.Sync.execute('UPDATE users SET rewards_coins = @rewards_coins WHERE identifier = @identifier', {['@rewards_coins'] = newCoinAmount, ['@identifier'] = xPlayer.identifier})

        debugprint('A coin has been added for player with ID: ' .. xPlayer.identifier)

        TriggerClientEvent('esx:showNotification', source, 'Danke für deine Spielzeit dir wurden '..Config.CoinAmount..' Coins zu deinem konto hinzugefügt. Dein neuer Kontostand beträgt '..newCoinAmount..' Coins.')
    end
end)


RegisterServerEvent('playerDropped')
AddEventHandler('playerDropped', function (reason)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local rewards_currenttime = 0

    debugprint(ESX.DumpTable(playerTimeTable))
    for _, entry in ipairs(playerTimeTable) do
        if entry.identifier == xPlayer.getIdentifier() then
            debugprint(entry.time)
            rewards_currenttime = entry.time
            break
        end
    end

    debugprint("DB safe")
    debugprint(rewards_currenttime)

    MySQL.Async.execute('UPDATE users SET rewards_currenttime = @rewards_currenttime WHERE identifier = @identifier',
    {
        ['@rewards_currenttime'] = rewards_currenttime,
        ['@identifier'] = xPlayer.getIdentifier()
    }, function(rowsChanged)
        if rowsChanged > 0 then
            debugprint('Updated rewards_currenttime for player with ID: ' .. xPlayer.getIdentifier())
        else
            debugprint('No entry found for player with ID: ' .. xPlayer.getIdentifier())
        end
    end)
end)

ESX.RegisterServerCallback('GMD_Rewards:getOldTime', function(source, cb)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchScalar('SELECT rewards_currenttime FROM users WHERE identifier = @identifier', 
    {
        ['@identifier'] = xPlayer.getIdentifier()
    }, function(result)
        debugprint(ESX.DumpTable(result))

        cb(result)
    end)
end)
