ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent("Just-TrickOrTreat:pay")
AddEventHandler('Just-TrickOrTreat:pay', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.addMoney(math.random(300, 500))

end)
