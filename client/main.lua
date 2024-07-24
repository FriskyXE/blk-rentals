local QBCore = exports['qb-core']:GetCoreObject()
local rentedBoats = {}
local inReturnZone = false
local spawnedNPCs = {}

-- Utility functions
local function loadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1)
    end
end

local function createNPC(npc)
    loadModel(npc.model)
    local ped = CreatePed(4, npc.model, npc.coords.x, npc.coords.y, npc.coords.z, npc.heading, false, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
	TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CLIPBOARD", 0, true)

    exports['qb-target']:AddTargetEntity(ped, {
        options = {
            {
                event = "blk-rentals:client:openMenu",
                icon = "fas fa-ship",
                label = "Rent a Boat",
            }
        },
        distance = 2.5,
    })

    if npc.blip then
        local blip = AddBlipForCoord(npc.coords.x, npc.coords.y, npc.coords.z)
        SetBlipSprite(blip, npc.blip.sprite)
        SetBlipScale(blip, npc.blip.scale)
        SetBlipColour(blip, npc.blip.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(npc.blip.label)
        EndTextCommandSetBlipName(blip)
    end

    table.insert(spawnedNPCs, ped)
end

local function deleteNPCs()
    for _, ped in ipairs(spawnedNPCs) do
        if DoesEntityExist(ped) then
            DeleteEntity(ped)
        end
    end
    spawnedNPCs = {}
end

-- Initialization
CreateThread(function()
    for _, npc in pairs(Config.NPC) do
        createNPC(npc)
    end
end)

-- Clean up NPCs on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        deleteNPCs()
    end
end)

-- Client events
RegisterNetEvent('blk-rentals:client:openMenu', function()
    local boats = Config.Boats
    SetNuiFocus(true, true)
	TriggerScreenblurFadeIn(1200)
    SendNUIMessage({
        type = 'openMenu',
        boats = boats
    })
end)

RegisterNUICallback('rentBoat', function(data, cb)
    local boat = nil
    for _, b in pairs(Config.Boats) do
        if b.model == data.model then
            boat = b
            break
        end
    end
    if boat then
        local spawnCoords = Config.NPC[1].spawnCoords
        TriggerServerEvent('blk-rentals:server:rentBoat', boat, spawnCoords)
    end
    SetNuiFocus(false, false)
	TriggerScreenblurFadeOut(1200)
    SendNUIMessage({ type = 'closeMenu' })
    cb('ok')
end)

RegisterNUICallback('closeMenu', function(data, cb)
    SetNuiFocus(false, false)
	TriggerScreenblurFadeOut(1200)
    SendNUIMessage({ type = 'closeMenu' })
    cb('ok')
end)

RegisterNetEvent('blk-rentals:client:spawnBoat', function(boat, coords)
    local model = GetHashKey(boat.model)
    loadModel(model)
    local boatEntity = CreateVehicle(model, coords.x, coords.y, coords.z, coords.w, true, false)
		exports['LegacyFuel']:SetFuel(veh, 100.0)
    TriggerEvent('vehiclekeys:client:SetOwner', GetVehicleNumberPlateText(boatEntity))
    SetPedIntoVehicle(PlayerPedId(), boatEntity, -1)
    table.insert(rentedBoats, boatEntity)
end)

-- Return Zone
CreateThread(function()
    for _, returnZoneConfig in ipairs(Config.ReturnZones) do
        local returnZone = CircleZone:Create(returnZoneConfig.coords, returnZoneConfig.radius, {
            name = "boat_return_zone",
            debugPoly = false
        })

        returnZone:onPlayerInOut(function(isPointInside)
            inReturnZone = isPointInside
            if inReturnZone then
                local playerPed = PlayerPedId()
                if IsPedInAnyBoat(playerPed) then
                    lib.showTextUI('[E] to return the boat', { position = 'left-center' })
                end
            else    
                lib.hideTextUI()
            end
        end)
    end
end)

-- Return Boat Handler
CreateThread(function()
    while true do
        Wait(0)
        if inReturnZone and IsControlJustPressed(0, 38) then -- 38 is the E key
            local playerPed = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(playerPed, false)

            if vehicle and IsPedInAnyBoat(playerPed) then
                local boatModel = GetEntityModel(vehicle)
                local boatPrice = nil

                -- Find the boat in the Config.Boats table to get its price
                for _, configBoat in pairs(Config.Boats) do
                    if GetHashKey(configBoat.model) == boatModel then
                        boatPrice = configBoat.price
                        break
                    end
                end

                if boatPrice then
                    DeleteVehicle(vehicle)
                    TriggerServerEvent('blk-rentals:server:returnBoat', {model = boatModel, price = boatPrice})
                    lib.hideTextUI()
                else
                    lib.notify({
                        description = 'Boat price not found!',
                        type = 'error',
                        position = 'center-right'
                    })
                end
            else
                lib.notify({
                    description = 'You are not in a boat!',
                    type = 'error',
                    position = 'center-right'
                })
            end
        end
    end
end)
