Config = {}

Config.DebugMode = false

-- Welcome gift settings
Config.UseCommand = true
Config.CommanName = 'welcomegift'
Config.GetCoinCommanName = 'getmycoins'

Config.ServerName = 'GMD_Scripts'

Config.GiveVehicle = true
Config.VehicleName = 'adder'
Config.ParkingGarageName = 'SanAndreasAvenue'

Config.GiveItems = true
Config.Items = {
    [1] = {'water', 'Wasser', 1}, -- itemname, itemcount
    [2] = {'bread', 'Brot', 5}, -- itemname, itemcount
}

Config.GiveMoney = true
Config.MoneyAccount = 'money'
Config.MoneyValue = 50000

-- Playtime coin settings
Config.CoinTimer = 1 -- in minutes
Config.CoinAmount = 20 -- coin amount after timer

-- NPC settings
Config.UsePed = true
Config.NPCShopCoords = vector3(-915.520, -2038.067, 8.404)
Config.NPCShopHeading = 226.445
Config.NPCModel = 's_m_m_highsec_01'
Config.NPCScenarioName = 'WORLD_HUMAN_AA_SMOKE'
Config.NPCAudioCall = true
Config.AudioCore = 'GENERIC_HI'
Config.AudioSpeech = 'Speech_Params_Force'

-- Coinshop settings
Config.CoinShopCoords = vector3(-915.520, -2038.067, 8.404)
Config.RangeLoadToShop = 10.0

Config.ShowVehicle = true
Config.ShowItem = true
Config.ShowMoney = true
Config.ShowWeapon = true

Config.UseShopMarker = true
Config.ShopMarkerType = 1
Config.ShopMarkerSprite = 2.5
Config.ShopMarkerHight = 0.2
Config.MarkerColorR = 255
Config.MarkerColorG = 138
Config.MarkerColorB = 0
Config.MarkerColorA = 0.5

-- Coinshop marker settings
Config.UseShopBlip = true
Config.BlipType = 431
Config.BlipScale = 1.0
Config.BlipColor = 46

-- Coinshop items settings
Config.RewardsShopTable = {
    ['vehicle'] = {
        {'adder', 'Adder', Coins = 5},
        {'akuma', 'Akuma', Coins = 50}
    },
    ['items'] = {
        {'bread', 'Bread', Coins = 1},
        {'water', 'Water', Coins = 1}
    },
    ['weapons'] = {
        {'WEAPON_PISTOL', 'Pistole', Coins = 19}
    },
    ['money'] = {
        {50000, 'money', '50000 $', Coins = 10}
    }
}