ESX = exports['es_extended']:getSharedObject()

ESX.RegisterServerCallback('GMD_Rewards:itsPlayerNew', function(src, cb, data)
    local xPlayer = ESX.GetPlayerFromId(src)

    MySQL.Async.fetchScalar('SELECT rewards_itsNew FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        debugprint(result)
        if result then
            debugprint("old player")

            cb(false)
        else
            debugprint("new player")

            -- MySQL.Async.execute('UPDATE users SET rewards_itsNew = @newValue WHERE identifier = @identifier', {
            --     ['@newValue'] = 1,
            --     ['@identifier'] = xPlayer.identifier
            -- }, function(rowsChanged)
            --     cb(true)
            -- end)

            cb(true)
        end
    end)
end)


RegisterServerEvent('GMD_Rewards:giveWelcomeGift')
AddEventHandler('GMD_Rewards:giveWelcomeGift', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local vehicleName = nil
    local itemNames = {}
    local moneyAmount = nil
    local dataToSend = {}

    if Config.GiveVehicle then
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

        local vehicleName = Config.VehicleName
        local parkingGarage = Config.ParkingGarageName
        dataToSend["vehicle"] = vehicleName
        dataToSend["parkingGarage"] = parkingGarage

        debugprint(dataToSend["vehicle"])
    end

    if Config.GiveItems then
        for k, v in ipairs(Config.Items) do
            xPlayer.addInventoryItem(v[1], v[3])
            itemNames[v[2]] = v[3]
            debugprint(ESX.DumpTable(itemNames))
        end
        debugprint(ESX.DumpTable(itemNames))
        dataToSend["items"] = itemNames
    end

    if Config.GiveMoney then
        xPlayer.addAccountMoney(Config.MoneyAccount, Config.MoneyValue)
        moneyAmount = Config.MoneyValue
        dataToSend["money"] = moneyAmount
    end

    debugprint(ESX.DumpTable(dataToSend))

    TriggerClientEvent('GMD_Rewards:giveNotify', source, dataToSend)
end)

function GeneratePlate()
    local plateText = ""
    local randomChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    math.randomseed(os.time())

    repeat
        plateText = ""
        for i = 1, 6 do
            local randIndex = math.random(1, string.len(randomChars))
            local randChar = string.sub(randomChars, randIndex, randIndex)
            plateText = plateText .. randChar
            randomChars = string.sub(randomChars, 1, randIndex - 1) .. string.sub(randomChars, randIndex + 1)
        end
    until not doesPlateExistSync(plateText)

    Wait(5)

    return plateText
end

function doesPlateExistSync(plate)
    local exists = false
    MySQL.query.await('SELECT COUNT(*) FROM owned_vehicles WHERE plate = ?', {plate}, function(result)
        if result and tonumber(result) > 0 then
            exists = true
        end
    end)
    Wait(5)
    return exists
end

CreateThread(function()
    MySQL.query("SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'users' AND COLUMN_NAME = 'rewards_itsNew';", {}, function(response)
        if next(response) == nil then
            local SQLStatemant = [[
                ALTER TABLE users
                ADD COLUMN rewards_itsNew TINYINT(1) NOT NULL DEFAULT 0,
                ADD COLUMN rewards_coins INT(100) NOT NULL DEFAULT 0,
                ADD COLUMN rewards_currenttime VARCHAR(60) NOT NULL DEFAULT 0;
            ]]
            MySQL.query(SQLStatemant, {}, function(response)
            end)
        end
    end)
end)