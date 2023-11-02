ESX = exports["es_extended"]:getSharedObject()

local inMission = false
local ped
local blips = {}

local cache = {
    idList = {},
    remaining = 0,
    textStatus = false,
    prop = nil
}

local MakeEntityFaceEntity = function(entity1, entity2)
    local p1 = GetEntityCoords(entity1, true)
    local p2 = GetEntityCoords(entity2, true)

    local dx = p2.x - p1.x
    local dy = p2.y - p1.y

    local heading = GetHeadingFromVector_2d(dx, dy)
    SetEntityHeading(entity1, heading)
end

local endMission = function()
    
if cache.remaining ~= 0 and #cache.idList > 0 then return end

ESX.ShowNotification(Config.Locales.questCompleted)

DeleteObject(cache.prop)
inMission = false
blips = {}
cache = {
    idList = {},
    remaining = 0,
    textStatus = false,
    prop = nil
}
TriggerServerEvent('Just-TrickOrTreat:pay')

end

local TrickOrTreat = function(playerPed)
    CreateThread(function()
        repeat 
            Wait(0)
    local pedCoords = GetEntityCoords(playerPed)
    ESX.ShowFloatingHelpNotification(Config.TrickOrTreat, vec3(pedCoords.x, pedCoords.y, pedCoords.z + 1))
    until not cache.textStatus
    end)
end



local collectCandy = function(index)
    if cache.idList[index] == nil then return end
    local id = cache.idList[index]
    cache.idList[index] = nil
    exports.ox_target:removeZone(id)
    cache.remaining -= 1
    RemoveBlip(blips[index])
    local playerPed = PlayerPedId()
    cache.textStatus = true
    TrickOrTreat(playerPed)
    lib.requestAnimDict('timetable@jimmy@doorknock@', 3000)
        TaskPlayAnim(playerPed, 'timetable@jimmy@doorknock@', 'knockdoor_idle', 8.0, 8.0, -1, 3, 0, false, false, false)
        FreezeEntityPosition(PlayerPedId(), true)
        Wait(3000)
        local randomPed = Config.Peds[math.random(1,#Config.Peds)]
        lib.requestModel(randomPed, 3000)
        lib.requestAnimDict('mp_common', 3000)
        ClearPedTasks(playerPed)
        local coords = GetOffsetFromEntityInWorldCoords(playerPed, 0.2, 0.0, 0.0)
        local heading = GetEntityHeading(playerPed)
        cache.textStatus = false
        local tempPed = CreatePed(28, randomPed, coords.x+1, coords.y, coords.z-0.9, heading*2, false, false)
        SetEntityInvincible(tempPed, true)
        ClearPedTasks(tempPed)
        SetBlockingOfNonTemporaryEvents(tempPed, true)
        MakeEntityFaceEntity(PlayerPedId(), tempPed)
        MakeEntityFaceEntity(tempPed, PlayerPedId())
        TaskPlayAnim(tempPed,"mp_common","givetake1_a", 8.0, 0.0, -1, 1, 0, false, false, false)
        Wait(2000)
        ClearPedTasks(tempPed)
        Wait(1000)
        DeletePed(tempPed)
        RemoveAnimDict('timetable@jimmy@doorknock@')
        RemoveAnimDict('mp_common')
        SetModelAsNoLongerNeeded(randomPed)
        FreezeEntityPosition(PlayerPedId(), false)
end

local spawnBucket = function()
    local ped = PlayerPedId()
    lib.requestModel('jsd_prop_pumpkin', 100)
        local hash = 'jsd_prop_pumpkin'
        local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(ped,0.0,3.0,0.5))
        cache.prop = CreateObjectNoOffset(hash, x, y, z, true, false, false)
        SetModelAsNoLongerNeeded(hash)
        SetCurrentPedWeapon(ped, 'WEAPON_UNARMED', false)
        AttachEntityToEntity(cache.prop, ped, GetPedBoneIndex(ped, 18905), 0.4, -0.02, 0.09, 28.79, -79.4, -95.07, true, true, false, true, 1, true)
end

local startMission = function()
    ESX.ShowNotification(Config.Locales.questStarted)
    spawnBucket()
    inMission = true
    local index = math.random(1, #Config.Zones)
    CreateThread(function()

        for i = 1, #Config.Zones[index] do
                cache.remaining += 1
            local id = exports["ox_target"]:addBoxZone{
                coords = vec3(Config.Zones[index][i].coords.x,
                              Config.Zones[index][i].coords.y,
                              Config.Zones[index][i].coords.z),
                size = vec3(2, 2, 2),
                rotation = Config.Zones[index][i].coords.w,
                debug = Config.Debug,
                drawSprite = true,
                distance = 1.5,
                options = {
                    {
                        name = "enter",
                        icon = "fa-solid fa-hat-wizard",
                        label = Config.Locales.pukpuk,
                        distance = 1.5,
                        onSelect = function(data)
                            collectCandy(i)
                        end

                    }
                }
            }
            cache.idList[i] = id
            local blip = AddBlipForCoord(Config.Zones[index][i].coords.x, Config.Zones[index][i].coords.y, Config.Zones[index][i].coords.z)
            SetBlipSprite(blip, Config.Blip.id)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 0.5)
            SetBlipColour(blip, Config.Blip.colour)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(Config.Blip.title)
            EndTextCommandSetBlipName(blip)
            blips[i] = blip
        end
        print(json.encode(cache))
    end)

end

local dialog = function(kwestie, ped, koordy, camera, onEnd)
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", camera[1], camera[2],
                              camera[3] + 0.5, 0.0, 0.0, camera[4], 90.0)
    CreateThread(function()
        step = 1
        menu = false
        stop = false
        repeat
            SetCamActive(cam, true)
            RenderScriptCams(true, 0, 1, 1, 0)
            FreezeEntityPosition(GetPlayerPed(-1), true)

            ESX.ShowHelpNotification(
                Config.Locales.skipDialog)
            SetEntityVisible(PlayerPedId(), false)
            if IsControlJustPressed(0, 38) then step = step + 1 end
            for i = 1, #kwestie do
                RequestAnimDict(kwestie[i].animation.lib)

                if step == i then
                    ESX.ShowFloatingHelpNotification(kwestie[i].desc, vector3(
                                                         koordy[1], koordy[2],
                                                         koordy[3] + 2))

                    if kwestie[i].animation.played == nil and kwestie[i].animation ~=
                        nil then
                        TaskPlayAnim(ped, kwestie[i].animation.lib,
                                     kwestie[i].animation.anim, 1.0, -1.0, 5000,
                                     0, 1, true, true, true)
                        kwestie[i].animation.played = true
                    end
                end
            end
            if step > #kwestie then
                FreezeEntityPosition(GetPlayerPed(-1), false)
                RenderScriptCams(false, true, 0, true, true)
                DestroyCam(cam, false)
                SetEntityVisible(PlayerPedId(), true)
                onEnd()
                cam = nil
                stop = true
            end

            Wait(0)
        until stop
    end)
end

Citizen.CreateThread(function()
    RequestModel(GetHashKey(Config.Model))

    while not HasModelLoaded(GetHashKey(Config.Model)) do Wait(155) end
    while CreatePed == nil do Citizen.Wait(100) end
    ped = CreatePed(4, GetHashKey(Config.Model), Config.PedCoords, false,
                          true)

    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)

    local options = {
        {
            icon = "fa-regular fa-comment",
            label = Config.Locales.startDialog,
            distance = 3.5,
            onSelect = function()
                if not inMission then
                    dialog(Config.Dialog, ped, {
                        Config.PedCoords.x, Config.PedCoords.y,
                        Config.PedCoords.z
                    }, {1133.7860, -665.7882, 57.0826, 275.3216}, startMission)

                end
            end,
            canInteract = function()
                if not inMission then return true else return end
            end
        },
        {
            icon = "fa-solid fa-hand",
            label = Config.Locales.returnToBenek,
            distance = 3.5,
            onSelect = function()
                if inMission then
                endMission()
                end
            end,
            canInteract = function()
               if inMission then return cache.remaining == 0 else return end
            end
        }
    }

    exports.ox_target:addLocalEntity(ped, options)
    Wait(1000)
    lib.requestModel('jsd_prop_pumpkin', 500)
    local hash = 'jsd_prop_pumpkin'
    local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(ped, 0.0, 3.0,
                                                                  0.5))
    pObj = CreateObjectNoOffset(hash, x, y, z, true, false, false)
    SetModelAsNoLongerNeeded(hash)
    SetCurrentPedWeapon(ped, WEAPON_UNARMED, false)
    AttachEntityToEntity(pObj, ped, GetPedBoneIndex(ped, 57005), 0.4, -0.02,
                         0.09, 28.79, -79.4, -95.07, true, true, false, true, 1,
                         true)
                         
end)
