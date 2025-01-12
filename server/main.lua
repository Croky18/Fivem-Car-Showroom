local spawnedVehicles = false -- Controleer of voertuigen al gespawned zijn

RegisterNetEvent('carshow:requestVehicles')
AddEventHandler('carshow:requestVehicles', function()
    local src = source
    local playerLicense = GetPlayerIdentifierByType(src, 'license')

    -- Controleer of de speler geautoriseerd is
    if playerLicense ~= Config.WhitelistedLicense then
        TriggerClientEvent('chat:addMessage', src, {
            args = {'^1Car Show', 'Je hebt geen toestemming om deze actie uit te voeren!'}
        })
        return
    end

    -- Controleer of voertuigen al gespawned zijn
    if spawnedVehicles then
        TriggerClientEvent('chat:addMessage', src, {
            args = {'^1Car Show', 'De voertuigen zijn al gespawned!'}
        })
        return
    end

    spawnedVehicles = true
    TriggerClientEvent('carshow:spawnVehicles', src, Config.CarShowVehicles)
end)

-- Helper functie om license te krijgen
function GetPlayerIdentifierByType(src, idType)
    for _, id in ipairs(GetPlayerIdentifiers(src)) do
        if id:find(idType) then
            return id
        end
    end
    return nil
end
