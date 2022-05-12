StealVehicles = {
    esxLegacy = true, -- if you are using esx-legacy put this to true pls.
    distance = 5.0,
    coords = vector3(-58.428, -1105.737, 26.436), -- coords where player going to start a mission.
    coordsEnd = vector3(1204.825, -3117.991, 5.91), -- coords where the player need to depose the vehicle
    blacklistJobs = {["police"] = true, ["sheriff"] = true}, -- jobs who can't use the system
    intervalBlock = 300000, -- need to wait 5 minutes before the player can relaunch a mission.
    deleteVehicleCancelMission = true, -- delete the vehicle if the mission is canceled (player died or logout)
    pedOptions = {
        pedType = 4, -- http://www.kronzky.info/fivemwiki/index.php/Ped_Types
        pedHash = "s_m_m_cntrybar_01",
        pedHeading = 152.199,
    }
}

StealVehicles.vehiclesCoords = { -- coords where the vehicle going to spawn
    vector4(-25.407, -1241.756, 28.923, 269.053),
}

math.randomseed(GetGameTimer()) -- Don't touch to this, must be here for the math.random


StealVehicles.Missions = {
    {
        vehToSteal = "adder",
        missionsOptions = {
            --typeGive = {type = "item", name_item = "water", count = 1},
            typeGive = {type = "money", name_item = "price", count = 100000}, -- going to give 100k money (money, bank, dirty_money)
            luckLockVehicle = {1, 4}, -- chance to unlock the vehicle (bigger are the numbers, lowers are the chance !)
            warnPolice = true, -- do you want to warn police if someone start a mission ?
            warnJobs = {"police", "sheriff"}, -- jobs to warn !
            timeWarnPolice = 60000, -- how much time (after the mission started) do you want to warn police ? (time is in milliseconds !!)
        },
        pedOptions = { -- Correspond to ennemies peds who defend the car
            enable = true,
            pedCount = 5, -- how much peds
            pedHash = "s_m_m_security_01",
            weapon = "WEAPON_ASSAULTRIFLE",
            ammoGive = 500,
            forceinHand = true
        },
    }
}

StealVehicles.Langs = {
    ["nameMenu"] = "Siméon / Thief",
    ["descriptionMenu"] = "Steal vehicles for Simeon",
    ["startMission"] = "Start a Mission",
    ["descriptionStartMission"] = "Start a mission and steal a vehicle for Simeon",
    ["successMission"] = "~g~ Successful mission",
    ["descriptionSuccessMission"] = "Mission completed",
    ['nameNotif'] = 'Simeon',
    ['descriptionNotif'] = 'vehicle theft',
    ['subjectNotif'] = 'Nice, bring me the vehicle now',
    ['keylockPickVehicle'] = '[E] - Lockpick the vehicle',
    ['retryLockpick'] = 'Shit, retry to lockpick the vehicle',
    ['canceledMission'] = '~r~Mission cancelled',
    ['introduceMission'] = 'I don\'t have the exact position, but I know the vehicle it\'s a ', -- leave a space at the end
    ['policeAlert'] = 'A vehicle theft has been detected',
}


-- Do not touch this if you don't know what are u doing.
function NotifyMission(title, subject, msg)
    ESX.ShowAdvancedNotification(title, subject, msg, 'CHAR_SIMEON', 1, false, true, 140)
end

RegisterNetEvent('esx::securoserv::notify', function(title, subject, msg)
    NotifyMission(title, subject, msg)
end)
