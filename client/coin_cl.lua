ESX = exports['es_extended']:getSharedObject()

local CurrentTime = 0
local CoinTime = Config.CoinTimer
local RemainingMinutes = CoinTime
local hasLoadedTime = false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    ESX.TriggerServerCallback('GMD_Rewards:getOldTime', function(currentTimer)
        debugprint(currentTimer)
        if currentTimer then
            local currentTimeValue = tonumber(currentTimer)

            if currentTimeValue and currentTimeValue ~= 0 then
                CurrentTime = currentTimeValue * 60
                RemainingMinutes = math.floor(CurrentTime / 60)
                hasLoadedTime = true

                debugprint('Spawned')
                debugprint('Current Time:', currentTimeValue)
            else
                CurrentTime = CoinTime * 60
                RemainingMinutes = CoinTime
                hasLoadedTime = true
            end
        else
            CurrentTime = CoinTime * 60
            RemainingMinutes = CoinTime
            hasLoadedTime = true
        end
    end)
    Wait(500)
    PlayerLoaded = true
end)

CreateThread(function()
    while true do
        Wait(1000)
        if hasLoadedTime then
            if CurrentTime <= 0 then
                CurrentTime = CoinTime * 60
                RemainingMinutes = CoinTime

                TriggerServerEvent('GMD_Rewards:giveCoins')
            else
                CurrentTime = CurrentTime - 1
                debugprint(CurrentTime)

                if CurrentTime % 60 == 0 then
                    RemainingMinutes = math.floor(CurrentTime / 60)

                    TriggerServerEvent('GMD_Rewards:updateTimeServer', RemainingMinutes)
                end
            end
        end
    end
end)

RegisterNetEvent('GMD_Rewards:ShowCoins')
AddEventHandler('GMD_Rewards:ShowCoins', function(coins)
    if coins > 0 then
        ESX.ShowNotification(ConfigLocal.CoinLocals['hasCoins'], 3500)
    else
        ESX.ShowNotification(ConfigLocal.CoinLocals['has0Coins'], 3500)
    end
end)

RegisterCommand('getmycoins', function()
    TriggerServerEvent('GMD_Rewards:ShowCoins')
end, false)
