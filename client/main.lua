local vehiclesSpawned = false -- Controleer lokaal of voertuigen al gespawned zijn
local spawnedVehicles = {} -- Houd een lijst bij van gespawned voertuigen

RegisterNetEvent('carshow:spawnVehicles')
AddEventHandler('carshow:spawnVehicles', function(vehicleData)
    if vehiclesSpawned then
        print('Voertuigen zijn al gespawned!')
        return
    end

    for _, vehicle in ipairs(vehicleData) do
        local model = GetHashKey(vehicle.model)
        local coords = vehicle.coords

        -- Laad het voertuigmodel
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(0)
        end

        -- Maak het voertuig aan
        local spawnedVehicle = CreateVehicle(model, coords.x, coords.y, coords.z, coords.w, false, false)
        SetVehicleOnGroundProperly(spawnedVehicle)
        SetEntityAsMissionEntity(spawnedVehicle, true, true)

        -- Bescherm het voertuig
        ProtectVehicle(spawnedVehicle)

        -- Voeg het voertuig toe aan de lijst
        table.insert(spawnedVehicles, spawnedVehicle)
    end

    vehiclesSpawned = true
end)

-- Bescherm het voertuig tegen diefstal en schade
function ProtectVehicle(vehicle)
    -- Vergrendel het voertuig
    SetVehicleDoorsLocked(vehicle, 2) -- Vergrendelt alle deuren
    SetVehicleDoorsLockedForAllPlayers(vehicle, true)

    -- Bevries positie
    FreezeEntityPosition(vehicle, true)

    -- Schakel interacties uit
    SetEntityInvincible(vehicle, true)
    SetVehicleCanBreak(vehicle, false)
    SetVehicleExplodesOnHighExplosionDamage(vehicle, false)
end

-- Command om voertuigen te spawnen
RegisterCommand('carshowspawn', function()
    TriggerServerEvent('carshow:requestVehicles')
end, false)
