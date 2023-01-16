local Space = {}

function Space:CreateVehicle(model, coords)
    local vehicle = Citizen.InvokeNative(`CREATE_AUTOMOBILE`, GetHashKey(model), coords)
    local timeout = false
    SetTimeout(250, function() timeout = true end)

    repeat
        Wait(0)
        if timeout then return false end
    until DoesEntityExist(vehicle)

    return vehicle, NetworkGetNetworkIdFromEntity(vehicle)
end

function Space:CreatePed(model, coords)
    local ped = CreatePed(0, GetHashKey(model), coords, true, true)
    local timeout = false
    SetTimeout(250, function() timeout = true end)

    repeat
        Wait(0)
        if timeout then return false end
    until DoesEntityExist(ped)

    Wait(100)

    return ped, NetworkGetNetworkIdFromEntity(ped)
end

--[[
    Need to use the news functions from ESX
]]