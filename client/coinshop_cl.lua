ESX = exports['es_extended']:getSharedObject()

CreateThread(function()
    if Config.UsePed then
        SpawnCoinShopNPC()
    end

    if Config.UseShopBlip then
        CreateBlip()
    end
end)

if Config.DebugMode then
    RegisterCommand('debugmenu', function(source, args)
        OpenCoinShop()
    end, false)
end

CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)


        local distance = #(playerCoords - Config.CoinShopCoords)

        if distance <= Config.RangeLoadToShop then
            if Config.UseShopMarker then
                DrawMarker(Config.ShopMarkerType, Config.CoinShopCoords, 0, 0, 0, 0, 0, 0, Config.ShopMarkerSprite, Config.ShopMarkerSprite, Config.ShopMarkerHight, Config.MarkerColorR, Config.MarkerColorG, Config.MarkerColorB, Config.MarkerColorA, false, true, 2, nil, nil, false, false)
            end

            if distance <= 2.5 then
                ShowHelpNotification(ConfigLocal.MenuLocals['showHelpText'])
    
                if IsControlJustPressed(0, 38) then
                    OpenCoinShop()
                end
            end
        else 
            Wait(250)
        end 
    end
end)

function ShowHelpNotification(msg)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

function SpawnCoinShopNPC()
    local modelHash = Config.NPCModel

    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(200)
    end

    coinShopNPC = CreatePed(5, modelHash, Config.NPCShopCoords, false, false)

    SetEntityInvincible(coinShopNPC, true)
    SetEntityHeading(coinShopNPC, Config.NPCShopHeading)
    FreezeEntityPosition(coinShopNPC, true)
    SetPedCanBeTargetted(coinShopNPC, false)
    SetEntityInvincible(coinShopNPC, true)
    SetBlockingOfNonTemporaryEvents(coinShopNPC, true)
    SetEveryoneIgnorePlayer(PlayerPedId(), true)
    SetPedCanBeTargettedByPlayer(coinShopNPC, PlayerPedId(), false)
    SetPedCombatAttributes(coinShopNPC, 46, true)
    SetPedCombatAttributes(coinShopNPC, 17, true)
    SetPedCombatAttributes(coinShopNPC, 5, true)
    SetPedCombatAttributes(coinShopNPC, 20, true)
    SetPedCombatAttributes(coinShopNPC, 52, true)
    SetPedFleeAttributes(coinShopNPC, 0, false)
    SetPedFleeAttributes(coinShopNPC, 128, false)
    SetPedAccuracy(coinShopNPC, 70)
    SetPedDropsWeaponsWhenDead(coinShopNPC, false)

    TaskStartScenarioInPlace(coinShopNPC, Config.NPCScenarioName, 0, true)
end

local EnterAudio = false

CreateThread(function()
    while Config.NPCAudioCall do
        Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local distance = #(playerCoords - Config.NPCShopCoords)

        if distance <= 2.5 then
            if not EnterAudio then
                PlayPedAmbientSpeechNative(coinShopNPC, Config.AudioCore, Config.AudioSpeech, 1)
                EnterAudio = true
            end
        else
            EnterAudio = false
            Wait(250)
        end
    end
end)

function CreateBlip()
    local blip = AddBlipForCoord(Config.CoinShopCoords)

    SetBlipSprite(blip, Config.BlipType)
    SetBlipDisplay(blip, 2)
    SetBlipScale(blip, Config.BlipScale)
    SetBlipColour(blip, Config.BlipColor)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(ConfigLocal.MenuLocals['blipName'])
    EndTextCommandSetBlipName(blip)
end

function OpenCoinShop()
    lib.registerContext({
        id = 'CoinShop',
        title = ConfigLocal.MenuLocals['coinShopName'],
        options = GetCoinShopItems()
    })

    lib.showContext('CoinShop')
end

function GetCoinShopItems()
    local ItemList = {}

    if Config.ShowVehicle then
        local vehicle = {
            title = ConfigLocal.MenuLocals['vehicleTitle'],
            description = ConfigLocal.MenuLocals['vehicleDescription'],
            icon = 'car',
            arrow = true,
            onSelect = function()
                ShowVehicleList()
            end,
        }

        table.insert(ItemList, vehicle)
    end

    if Config.ShowItem then
        local items = {
            title = ConfigLocal.MenuLocals['itemTitle'],
            description = ConfigLocal.MenuLocals['itemDescription'],
            icon = 'fa-solid fa-object-group',
            arrow = true,
            onSelect = function()
                ShowItemList()
            end,
        }

        table.insert(ItemList, items)
    end

    if Config.ShowMoney then
        local money = {
            title = ConfigLocal.MenuLocals['moneyTitle'],
            description = ConfigLocal.MenuLocals['moneyDescription'],
            icon = 'fa-solid fa-sack-dollar',
            arrow = true,
            onSelect = function()
                ShowMoneyList()
            end,
        }

        table.insert(ItemList, money)
    end

    if Config.ShowWeapon then
        local weapon = {
            title = ConfigLocal.MenuLocals['weaponTitle'],
            description = ConfigLocal.MenuLocals['weaponDescription'],
            icon = 'fa-solid fa-gun',
            arrow = true,
            onSelect = function()
                ShowWeaponList()
            end,
        }

        table.insert(ItemList, weapon)
    end

    return ItemList
end

function ShowVehicleList()
    local List = {}

    for k, v in ipairs(Config.RewardsShopTable['vehicle']) do
        local vehicleName = v[1]
        local vehicleDisplayName = v[2]
        local vehicleCost = v.Coins

        local costAsString = tostring(vehicleCost)

        local TmpTable = {
            title = vehicleDisplayName,
            icon = 'car',
            arrow = true,
            onSelect = function()
                TriggerServerEvent('GMD_Rewards:GiveVehicle', vehicleName, vehicleDisplayName, vehicleCost)
            end,
            metadata = {Coast = costAsString}
        }

        table.insert(List, TmpTable)
    end

    while #List == 0 do
        Wait(1)
    end

    lib.registerContext({
        id = 'VehicleList',
        title = ConfigLocal.MenuLocals['vehicleTitle'],
        options = List
    })

    lib.showContext('VehicleList')
end

function ShowItemList()
    local List = {}

    for k, v in ipairs(Config.RewardsShopTable['items']) do
        local itemName = v[1]
        local itemDisplayName = v[2]
        local itemCost = v.Coins

        local costAsString = tostring(itemCost)

        local TmpTable = {
            title = itemDisplayName,
            icon = 'fa-solid fa-object-group',
            arrow = true,
            onSelect = function()
                TriggerServerEvent('GMD_Rewards:GiveItem', itemName, itemDisplayName, itemCost)
            end,
            metadata = {Coast = costAsString}
        }

        table.insert(List, TmpTable)
    end

    while #List == 0 do
        Wait(1)
    end

    lib.registerContext({
        id = 'ItemList',
        title = ConfigLocal.MenuLocals['itemTitle'],
        options = List
    })

    lib.showContext('ItemList')
end

function ShowMoneyList()
    local List = {}

    for k, v in ipairs(Config.RewardsShopTable['money']) do
        local moneyValue = v[1]
        local moneyAccount = v[2]
        local MoneyDisplayName = v[3]
        local moneyCost = v.Coins

        local costAsString = tostring(moneyCost)

        local TmpTable = {
            title = MoneyDisplayName,
            icon = 'fa-solid fa-object-group',
            arrow = true,
            onSelect = function()
                TriggerServerEvent('GMD_Rewards:GiveMoney', moneyAccount, moneyValue, moneyCost)
            end,
            metadata = {Coast = costAsString}
        }

        table.insert(List, TmpTable)
    end

    while #List == 0 do
        Wait(1)
    end

    lib.registerContext({
        id = 'MoneyList',
        title = ConfigLocal.MenuLocals['moneyTitle'],
        options = List
    })

    lib.showContext('MoneyList')
end

function ShowWeaponList()
    local List = {}

    for k, v in ipairs(Config.RewardsShopTable['weapons']) do
        local weaponName = v[1]
        local weaponDisplayName = v[2]
        local weaponCost = v.Coins

        local costAsString = tostring(weaponCost)

        local TmpTable = {
            title = weaponDisplayName,
            icon = 'fa-solid fa-object-group',
            arrow = true,
            onSelect = function()
                TriggerServerEvent('GMD_Rewards:GiveWeapon', weaponName, weaponDisplayName, weaponCost)
            end,
            metadata = {Coast = costAsString}
        }

        table.insert(List, TmpTable)
    end

    while #List == 0 do
        Wait(1)
    end

    lib.registerContext({
        id = 'WeaponList',
        title = ConfigLocal.MenuLocals['weaponTitle'],
        options = List
    })

    lib.showContext('WeaponList')
end