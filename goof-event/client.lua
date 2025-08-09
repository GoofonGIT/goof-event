ESX = nil
local heeftHesjeAan = false
local origineleHesje = nil
local origineleHesjeTexture = nil
local playerGrade = 0

Citizen.CreateThread(function()
    while ESX == nil do
        ESX = exports["es_extended"]:getSharedObject()
        Citizen.Wait(100)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end

    local playerData = ESX.GetPlayerData()
    if playerData.job2 and playerData.job2.grade then
        playerGrade = playerData.job2.grade
    else
        playerGrade = 0
    end
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
    if job2 and job2.grade then
        playerGrade = job2.grade
    else
        playerGrade = 0
    end
end)

RegisterNetEvent('event:openEventUI')
AddEventHandler('event:openEventUI', function()
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'show' })
end)

RegisterNetEvent('event:spawnPbus')
AddEventHandler('event:spawnPbus', function()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    local vehicleModel = GetHashKey('pbus')


    RequestModel(vehicleModel)
    while not HasModelLoaded(vehicleModel) do
        Citizen.Wait(0)
    end

    local vehicle = CreateVehicle(vehicleModel, playerCoords.x + 5, playerCoords.y + 5, playerCoords.z, GetEntityHeading(playerPed), true, false)
 
    TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
    

    SetModelAsNoLongerNeeded(vehicleModel)
end)


RegisterNetEvent('event:closeEventUI')
AddEventHandler('event:closeEventUI', function()
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'hide' })
end)

local function playAnim(dict, name, duration)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(10)
    end
    TaskPlayAnim(PlayerPedId(), dict, name, 8.0, -8.0, duration, 49, 0, false, false, false)
    Citizen.Wait(duration)
    ClearPedTasks(PlayerPedId())
end

RegisterNetEvent('event:toggleHesje')
AddEventHandler('event:toggleHesje', function()
    local playerPed = PlayerPedId()

    if not heeftHesjeAan then
        playAnim("clothingtie", "try_tie_positive_a", 3500)

        lokaleHesje = GetPedDrawableVariation(playerPed, 9)
        lokaleTexture = GetPedTextureVariation(playerPed, 9)
        origineleHesje = lokaleHesje
        origineleHesjeTexture = lokaleTexture

        Citizen.Wait(100)

        local texture = 0
        if playerGrade == 1 then
            texture = 1
        end

        SetPedComponentVariation(playerPed, 9, 10, texture, 2)

        heeftHesjeAan = true

        lib.notify({
            title = 'Eventteam',
            description = 'Je hebt het event hesje aangetrokken.',
            type = 'success'
        })
    else
        playAnim("clothingtie", "try_tie_negative_a", 3500)

        Citizen.Wait(100)

        if origineleHesje then
            SetPedComponentVariation(playerPed, 9, origineleHesje, origineleHesjeTexture, 2)
        end

        heeftHesjeAan = false

        lib.notify({
            title = 'Eventteam',
            description = 'Je hebt het event hesje uitgedaan.',
            type = 'error'
        })
    end
end)

RegisterNUICallback('setCoords', function(data, cb)
    local x, y, z = data.x, data.y, data.z
    if x and y and z then
        TriggerServerEvent('event:setCoords', { x = x, y = y, z = z })
    else
        lib.notify({
            title = 'Event',
            description = 'Ongeldige coördinaten ontvangen.',
            type = 'error'
        })
    end

    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'hide' })
    cb('ok')
end)

RegisterNUICallback('closeUI', function(data, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'hide' })
    cb('ok')
end)

RegisterNetEvent('event:teleporteer')
AddEventHandler('event:teleporteer', function(coords)
    local playerPed = PlayerPedId()
    if DoesEntityExist(playerPed) and not IsEntityDead(playerPed) then
        DoScreenFadeOut(1000)
        Citizen.Wait(1000)
        SetEntityCoords(playerPed, coords.x, coords.y, coords.z, false, false, false, true)
        DoScreenFadeIn(1000)
        lib.notify({
            title = 'Event',
            description = 'Je bent geteleporteerd naar het event!',
            type = 'success'
        })
    end
end)
