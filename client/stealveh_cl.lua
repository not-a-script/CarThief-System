local ESX = exports.es_extended:getSharedObject()
local myCfg = StealVehicles
local finishedFirstPart
local tryout = 0
local disabledUI = false

RegisterNetEvent('esx:playerLoaded') -- Store the players data
AddEventHandler('esx:playerLoaded', function(xPlayer, isNew)
    ESX.PlayerData = xPlayer
    ESX.PlayerLoaded = true
end)

RegisterNetEvent('esx:playerLogout') -- When a player logs out (multicharacter), reset their data
AddEventHandler('esx:playerLogout', function()
    ESX.PlayerLoaded = false
    ESX.PlayerData = {}
end)

-- These two functions can perform the same task
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

RegisterNetEvent('space:scaleform:mission:success', function()
    ESX.Scaleform.ShowFreemodeMessage(StealVehicles.Langs.successMission, StealVehicles.Langs.descriptionSuccessMission, 5)
end)



RegisterNetEvent('space:ped::relationships', function(ped)
    myPed = NetToPed(ped)
    AddRelationshipGroup('team1')
    AddRelationshipGroup('team2')
    SetRelationshipBetweenGroups(5, 'team1', 'team2')
	SetRelationshipBetweenGroups(5, 'team2', 'team1')
    NetworkSetFriendlyFireOption(false)
    SetPedRelationshipGroupHash(GetHashKey("PLAYER"), 'team2')
    SetPedRelationshipGroupHash(myPed, 'team1')
    SetEntityAsMissionEntity(myPed, true, true)
    SetEntityAsNoLongerNeeded(myPed)
end)


local function launchAnim()
    lib.requestAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@") -- on charge l'anim
    TaskPlayAnim(cache.ped, 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@' , 'machinic_loop_mechandplayer' ,8.0, -8.0, -1, 1, 0, false, false, false)
    Wait(5000)
    ClearPedTasks(cache.ped)
end

local function hasUnlockedSuccess()
    local netVeh = NetToVeh(GlobalState.vehicleNetId)
    SetVehicleDoorsLocked(netVeh, 0)
    NotifyMission(StealVehicles.Langs.nameNotif, StealVehicles.Langs.descriptionNotif, StealVehicles.Langs.subjectNotif)
end 

local function createBlip(coords)
    tryout = tryout + 1
    if (tryout > 1) then return end
    blip = nil
    blip = AddBlipForCoord(coords)
    SetBlipRoute(blip, true)
end

local function CooldownMission()
    isOnMission = true
    Citizen.SetTimeout(5000, function()
        isOnMission = false
    end)
end

RegisterNetEvent('space:blip:securoserv', function(coords)
    finishedFirstPart = false
    disabledUI = false
    vehBlip = AddBlipForRadius(coords.x, coords.y, coords.z, 100.0)
    SetBlipColour(vehBlip, 1)
    SetBlipAlpha(vehBlip, 128)
    CreateThread(function()
        local entityDist, finishedDist, sleep
        while (true) do
            sleep = 2000
            entityDist = #(GetEntityCoords(cache.ped) - vector3(coords.x, coords.y, coords.z))
            if (entityDist < 10.0) then
                sleep = 0
                RemoveBlip(vehBlip)
                finishedFirstPart = true
                if (entityDist < 2.0) then
                    sleep = 0
                    if not (disabledUI) then
                        lib.showTextUI(StealVehicles.Langs.keylockPickVehicle, {
                            position = "top-center",
                            icon = 'lock',
                        })
                        if IsControlJustReleased(0, 38) then
                            math.randomseed(GetGameTimer())
                            local openLuck = math.random(GlobalState.randomLock[1], GlobalState.randomLock[2])
                            launchAnim()
                            if (openLuck == 2) then
                                disabledUI = true
                                lib.hideTextUI()
                                hasUnlockedSuccess()
                                createBlip(StealVehicles.coordsEnd)
                            else
                                ESX.ShowNotification(StealVehicles.Langs.retryLockpick, false, false, 140)
                            end
                        end
                    end
                end
            end
            if (entityDist > 5.0) then
                lib.hideTextUI()
            end
            if (finishedFirstPart) then
                finishedDist = #(GetEntityCoords(cache.ped) - StealVehicles.coordsEnd)
                if (finishedDist < 5.0) then
                    SetBlipRoute(blip, false)
                    RemoveBlip(blip)
                    TriggerServerEvent('securoserv:space::giveReward')
                    isOnMission = false
                    CooldownMission()
                    break
                end
            end
            if IsPedDeadOrDying(cache.ped, true) and isOnMission then
                TriggerServerEvent('securoserv:space::cancelMission')
                if DoesBlipExist(blip) then
                    SetBlipRoute(blip, false)
                    RemoveBlip(blip) 
                    ClearAllBlipRoutes()
                end
                if DoesBlipExist(vehBlip) then
                    RemoveBlip(vehBlip)
                end
                if (GlobalState.vehicleNetId ~= nil) then
                    local vehicle = NetToVeh(GlobalState.vehicleNetId)
                    TaskLeaveVehicle(cache.ped, vehicle, 1)
                    SetVehicleDoorsLocked(vehicle, 2)
                    if (StealVehicles.deleteVehicleCancelMission) then
                        Wait(60000)
                        DeleteEntity(vehicle)
                    end
                end
                isOnMission = false
                CooldownMission()
                return NotifyMission(StealVehicles.Langs.nameNotif, StealVehicles.Langs.descriptionNotif, StealVehicles.Langs.canceledMission)
            end
            Wait(sleep)
        end
    end)
end)


local startMissionPoint = lib.points.new(StealVehicles.coords, StealVehicles.distance, {
    space = 'test',
})

function startMissionPoint:onEnter()
    local netPedTask = NetToPed(GlobalState.netIDPed)
    repeat
        Wait(0)
    until DoesEntityExist(netPedTask)
    SetEntityInvincible(netPedTask, true)
    FreezeEntityPosition(netPedTask, true)
    TaskSetBlockingOfNonTemporaryEvents(netPedTask, true)
end

function startMissionPoint:nearby()
    if (self.currentDistance < 2.0 and not myCfg.blacklistJobs[ESX.PlayerData.job.name]) then
        if IsControlJustReleased(0, 38) then
            RageUI.Visible(StealVehiclesMenu, not RageUI.Visible(StealVehiclesMenu))
        end
    end
end

function startMissionPoint:onExit()
    RageUI.Visible(StealVehiclesMenu, false) -- force to leave the menu when the player leave the zone. 
end