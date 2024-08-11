local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('blk-rentals:server:rentBoat', function(boat, coords)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	if Player.Functions.RemoveMoney('cash', boat.price, 'boat-rental') then
		TriggerClientEvent('blk-rentals:client:spawnBoat', src, boat, coords)
    else
		Config.Notify(src, 'You do not have enough money!', 'error', 'center-right')
    end
end)

RegisterNetEvent('blk-rentals:server:returnBoat', function(boat)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if boat.price then
        Player.Functions.AddMoney('cash', boat.price, 'boat-rental-return') -- Refund based on price
		Config.Notify(src, 'You have received your refund of $' .. boat.price .. ' back.', 'success', 'center-right')
    else
		Config.Notify(src, 'Error: Boat price not found.', 'error', 'center-right')
    end
end)
