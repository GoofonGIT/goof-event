ESX = exports["es_extended"]:getSharedObject()
local deelnemers = {}
local eventCoords = nil  


RegisterCommand('event', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    if xPlayer.job2 and xPlayer.job2.name == 'eventteam' then
        TriggerClientEvent('event:toggleHesje', source)
    else
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Eventteam',
            description = 'Je hebt geen toestemming om dit command te gebruiken.',
            type = 'error'
        })
    end
end, false)

RegisterCommand('maakevent', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    if xPlayer.job2 and xPlayer.job2.name == 'eventteam' then
        TriggerClientEvent('event:openEventUI', source)
    else
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Eventteam',
            description = 'Je hebt geen toestemming om dit command te gebruiken.',
            type = 'error'
        })
    end
end, false)

RegisterCommand('eventauto', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    if xPlayer.job2 and xPlayer.job2.name == 'eventteam' then
        TriggerClientEvent('event:spawnPbus', source)
    else
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Eventteam',
            description = 'Je hebt geen toestemming om dit command te gebruiken.',
            type = 'error'
        })
    end
end, false)




RegisterCommand('joinevent', function(source)
    if source == 0 then return end

    if not eventCoords then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Event',
            description = 'Er is momenteel geen event actief.',
            type = 'error'
        })
        return
    end

    if not deelnemers[source] then
        deelnemers[source] = true
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Event',
            description = 'Je wordt geteleporteerd naar het event!',
            type = 'success'
        })
        TriggerClientEvent('event:teleporteer', source, eventCoords)
    else
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Event',
            description = 'Je bent al aangemeld voor het event.',
            type = 'error'
        })
    end
end, false)


RegisterNetEvent('event:setCoords')
AddEventHandler('event:setCoords', function(coords)
    eventCoords = coords
    print(("Event coords zijn gezet: x=%.2f y=%.2f z=%.2f"):format(coords.x, coords.y, coords.z))
end)
