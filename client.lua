local spawnedVehicles = {}
local vehiclesSpawned = false

local function removeSpawnedVehicles()
    for _, vehicle in ipairs(spawnedVehicles) do
        if DoesEntityExist(vehicle) then
            DeleteEntity(vehicle)
        end
    end
    spawnedVehicles = {}
    Citizen.Wait(0)
end

local function spawnVehicles()
    removeSpawnedVehicles()

    for i, vehicleData in ipairs(Config.Vehicles) do
        local carModel = vehicleData.model
        local spawnPos = vehicleData.spawnPos

        RequestModel(carModel)
        while not HasModelLoaded(carModel) do
            Citizen.Wait(0)
        end

        local vehicle = CreateVehicle(GetHashKey(carModel), spawnPos.x, spawnPos.y, spawnPos.z, spawnPos.w, true, false)

        if DoesEntityExist(vehicle) then
            SetEntityAsMissionEntity(vehicle, true, true)
            SetVehicleNumberPlateText(vehicle, "Legacy") -- you can put the name for the license plate here
            SetVehicleDoorsLocked(vehicle, 2)
            SetVehicleDirtLevel(vehicle, 0.0)

            PlaceObjectOnGroundProperly(vehicle)

            spawnedVehicles[i] = vehicle
        end
        FreezeEntityPosition(vehicle, true)
    end
    vehiclesSpawned = true
end

Citizen.CreateThread(function()
    spawnVehicles()
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        removeSpawnedVehicles()
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        removeSpawnedVehicles()
        Citizen.Wait(500)
        spawnVehicles()
    end
end)
