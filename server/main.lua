local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('blk-rentals:server:rentBoat', function(boat, coords)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveMoney('cash', boat.price, 'boat-rental') then
        TriggerClientEvent('blk-rentals:client:spawnBoat', src, boat, coords)
    else
        TriggerClientEvent('ox_lib:notify', src, {
            description = 'You do not have enough money!',
            type = 'error',
            position = 'center-right'
        })
    end
end)

RegisterNetEvent('blk-rentals:server:returnBoat', function(boat)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if boat.price then
        Player.Functions.AddMoney('cash', boat.price, 'boat-rental-return') -- Refund based on price
        TriggerClientEvent('ox_lib:notify', src, {
            description = 'You have received your refund of $' .. boat.price .. ' back.',
            type = 'success',
            position = 'center-right'
        })
    else
        TriggerClientEvent('ox_lib:notify', src, {
            description = 'Error: Boat price not found.',
            type = 'error',
            position = 'center-right'
        })
    end
end)
