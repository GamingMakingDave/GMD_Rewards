ESX = exports['es_extended']:getSharedObject()

RegisterNetEvent('GMD_Rewards:GiveItem')
AddEventHandler('GMD_Rewards:GiveItem', function(itemName, itemDisplayName, itemCost)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local result = MySQL.Sync.fetchScalar('SELECT rewards_coins FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    })

    if result then
        local playerCoins = tonumber(result)

        if playerCoins >= itemCost then
            xPlayer.addInventoryItem(itemName, 1)
            RemovePlayerCoins(source, itemCost)

            TriggerClientEvent('esx:showNotification', source, ConfigLocal.ShopLocals['buyNotify']:format(itemDisplayName, itemCost))
        else
            TriggerClientEvent('esx:showNotification', source, ConfigLocal.ShopLocals['notEnoughCoins'])
        end
    else
        debugprint("Error retrieving player coins from the database.")
    end
end)

RegisterNetEvent('GMD_Rewards:GiveMoney')
AddEventHandler('GMD_Rewards:GiveMoney', function(account, amount, moneyCost)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local result = MySQL.Sync.fetchScalar('SELECT rewards_coins FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    })

    if result then
        local playerCoins = tonumber(result)

        if playerCoins >= moneyCost then
            xPlayer.addAccountMoney(account, amount)
            RemovePlayerCoins(source, moneyCost)

            TriggerClientEvent('esx:showNotification', source, ConfigLocal.ShopLocals['buyNotify']:format(amount, moneyCost))
        else
            TriggerClientEvent('esx:showNotification', source, ConfigLocal.ShopLocals['notEnoughCoins'])
        end
    else
        debugprint("Error retrieving player coins from the database.")
    end
end)


RegisterNetEvent('GMD_Rewards:GiveWeapon')
AddEventHandler('GMD_Rewards:GiveWeapon',function(weaponName, weaponDisplayName, weaponCost)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local result = MySQL.Sync.fetchScalar('SELECT rewards_coins FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    })

    if result then
        local playerCoins = tonumber(result)

        if playerCoins >= weaponCost then
            xPlayer.addWeapon(weaponName, 30)
            RemovePlayerCoins(source, weaponCost)

            TriggerClientEvent('esx:showNotification', source, ConfigLocal.ShopLocals['buyNotify']:format(weaponDisplayName, weaponCost))
        else
            TriggerClientEvent('esx:showNotification', source, ConfigLocal.ShopLocals['notEnoughCoins'])
        end
    else
        debugprint("Error retrieving player coins from the database.")
    end
end)

RegisterNetEvent('GMD_Rewards:GiveVehicle')
AddEventHandler('GMD_Rewards:GiveVehicle',function(vehicleName, vehicleDisplayName, vehicleCost)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local result = MySQL.Sync.fetchScalar('SELECT rewards_coins FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    })

    if result then
        local playerCoins = tonumber(result)

        if playerCoins >= vehicleCost then
            local plate = GeneratePlate()
            local model = GetHashKey(Config.VehicleName)

            MySQL.insert('INSERT INTO owned_vehicles (owner, plate, stored, parking, vehicle) VALUES (?, ?, ?, ?, ?)',
            {
                xPlayer.identifier,
                plate,
                1,
                Config.ParkingGarageName,
                json.encode({model = model, plate = plate})

            }, function(rowsChanged)
                if rowsChanged then
                    debugprint("IN GARAGE")
                end
            end)

            RemovePlayerCoins(source, vehicleCost)
            TriggerClientEvent('esx:showNotification', source, ConfigLocal.ShopLocals['buyVehicleNotify']:format(vehicleDisplayName, vehicleCost, Config.ParkingGarageName))
        else
            TriggerClientEvent('esx:showNotification', source, ConfigLocal.ShopLocals['notEnoughCoins'])
        end
    else
        debugprint("Error retrieving player coins from the database.")
    end
end)

function RemovePlayerCoins(source, amount)
    local xPlayer = ESX.GetPlayerFromId(source)

    local result = MySQL.Sync.fetchScalar('SELECT rewards_coins FROM users WHERE identifier = @identifier', {['@identifier'] = xPlayer.identifier})

    if result then
        local newCoinAmount = result - amount

        debugprint(newCoinAmount)

        MySQL.Sync.execute('UPDATE users SET rewards_coins = @rewards_coins WHERE identifier = @identifier', {['@rewards_coins'] = newCoinAmount, ['@identifier'] = xPlayer.identifier})

        debugprint('The coins have been updated, and '..amount..' coins have been deducted from player ' .. xPlayer.identifier.."'s account. "..newCoinAmount..' is their new balance.')
    end
end