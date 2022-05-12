local ESX = exports.es_extended:getSharedObject()
local mybreak = false

AddEventHandler('onResourceStart', function(rsrc)
    if (rsrc == GetCurrentResourceName()) then
        ped, netPed = StarCPed(StealVehicles.pedOptions.pedHash, vector4(StealVehicles.coords.x, StealVehicles.coords.y, StealVehicles.coords.z, StealVehicles.pedOptions.pedHeading))
        GlobalState.netIDPed = netPed
    end
end)

AddEventHandler('onResourceStop', function(resource) -- if someone restart the resource, going to delete the old ped.
    if resource == GetCurrentResourceName() then
        if DoesEntityExist(ped) then
            DeleteEntity(ped)
        end
end
end)


trackedPeds = {}

local function deleteEnnemies()
    for i = 1, #trackedPeds do
        if DoesEntityExist(trackedPeds[i]) then
            DeleteEntity(trackedPeds[i])
        end
    end
    table.wipe(trackedPeds)
end

RegisterNetEvent('securoserv:space::cancelMission', function()
    -- TODO: need to do some checks
    GlobalState.vehicleNetId = nil
    GlobalState.randomLock = nil
    deleteEnnemies()
end)

local function ennemiesLaunch(player, mission)
    local radius = 5.0
    local count = mission.pedOptions.pedCount
    repeat
        count = count - 1
        local x = mission.missionsOptions.coords.x + math.random(-radius, radius)
        local y = mission.missionsOptions.coords.y + math.random(-radius, radius)
        local ennemyPed, netIDPed = StarCPed(mission.pedOptions.pedHash, vector4(x, y, mission.missionsOptions.coords.z, 100.0))
        trackedPeds[#trackedPeds+1] = ennemyPed
        GiveWeaponToPed(ennemyPed, GetHashKey(mission.pedOptions.weapon), mission.pedOptions.ammoGive, false, mission.pedOptions.forceinHand)
        TriggerClientEvent('space:ped::relationships', player, netIDPed)
        TaskCombatPed(ennemyPed, GetPlayerPed(player), 0, 16)
    until count == 0
end

RegisterNetEvent('securoserv:space::startMission', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    if not (StealVehicles.blacklistJobs[xPlayer.getJob().name]) then
        math.randomseed(GetGameTimer())
        mission = StealVehicles.Missions[math.random(1, #StealVehicles.Missions)]
        mission.missionsOptions.coords = StealVehicles.vehiclesCoords[math.random(1, #StealVehicles.vehiclesCoords)] -- going to select a random coords in vehicleCoords.
        VehToSteal, NetVeh = StarCVehicle(mission.vehToSteal, mission.missionsOptions.coords)
        if mission.pedOptions.enable then
            ennemiesLaunch(xPlayer.source, mission)
        end
        SetVehicleDoorsLocked(VehToSteal, 2)
        GlobalState.vehicleNetId = NetVeh
        GlobalState.randomLock = mission.missionsOptions.luckLockVehicle
        TriggerClientEvent('esx::securoserv::notify', xPlayer.source, StealVehicles.Langs.nameNotif, StealVehicles.Langs.descriptionNotif, StealVehicles.Langs.introduceMission .. mission.vehToSteal)
        if (mission.missionsOptions.warnPolice) then
            SetTimeout(mission.missionsOptions.timeWarnPolice, function()
                for _,jobs in pairs(mission.missionsOptions.warnJobs) do
                    if (StealVehicles.esxLegacy) then
                        local warnPlayers = ESX.GetExtendedPlayers('job', jobs)
                        for __, player in pairs(warnPlayers) do
                            TriggerClientEvent('esx:showNotification', player.source, StealVehicles.Langs.policeAlert)
                            mybreak = true
                            break
                        end
                        if (mybreak) then break end
                    else
                        local warnPlayers = ESX.GetPlayers()
                        for _, player in pairs(warnPlayers) do
                            local xPlayer = ESX.GetPlayerFromId(player)
                            if xPlayer.getJob().name == jobs then
                                TriggerClientEvent('esx:showNotification', xPlayer.source, StealVehicles.Langs.policeAlert)
                                mybreak = true
                                break
                            end
                            if (mybreak) then break end
                        end
                    end
                end
            end)
        end
        TriggerClientEvent('space:blip:securoserv', xPlayer.source, mission.missionsOptions.coords)
    end
end)

RegisterNetEvent('securoserv:space::giveReward', function()
    deleteEnnemies()
    local xPlayer = ESX.GetPlayerFromId(source)
    local player = GetPlayerPed(source)
    if not xPlayer or not player then return end
    local veh = GetVehiclePedIsIn(player, false)
    if not (StealVehicles.blacklistJobs[xPlayer.getJob().name]) then
        if #(GetEntityCoords(GetPlayerPed(source)) - StealVehicles.coordsEnd) < 15.0 then
            if (veh == VehToSteal) then
                if (mission.missionsOptions.typeGive.type == "item") then
                    if xPlayer.canCarryItem(mission.missionsOptions.typeGive.name_item, mission.missionsOptions.typeGive.count) then
                        xPlayer.addInventoryItem(mission.missionsOptions.typeGive.name_item, mission.missionsOptions.typeGive.count)
                        TriggerClientEvent('space:scaleform:mission:success', xPlayer.source)
                        DeleteEntity(VehToSteal)
                        GlobalState.vehicleNetId = nil
                    end
                elseif (mission.missionsOptions.typeGive.name_item == "price") then
                    xPlayer.addAccountMoney(mission.missionsOptions.typeGive.type, mission.missionsOptions.typeGive.count)
                    TriggerClientEvent('space:scaleform:mission:success', xPlayer.source)
                    DeleteEntity(VehToSteal)
                    GlobalState.vehicleNetId = nil
                end
            end
        end
    end
end)
