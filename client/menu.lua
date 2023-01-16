StealVehiclesMenu = RageUI.CreateMenu(StealVehicles.Langs.nameMenu, StealVehicles.Langs.descriptionMenu, 0, 0, "commonmenu", "interaction_bgd", 183, 21, 64,1.0);

isOnMission = false


function RageUI.PoolMenus:SpaceSecuroServVehicles()
    StealVehiclesMenu:IsVisible(function(Items)
        Items:AddButton(StealVehicles.Langs.startMission, StealVehicles.Langs.descriptionStartMission, {
            IsDisabled = isOnMission,
            RightBadge = RageUI.BadgeStyle.GoldMedal,
            Color = {
                HightLightColor = RageUI.ItemsColour.PureWhite,
                BackgroundColor = RageUI.ItemsColour.Black
            }}, function(onSelected, onActive)
            if (onSelected) then
                isOnMission = true
                TriggerServerEvent('securoserv:space::startMission')
            end
            end)
    end, function() end)
end

--[[
    WIP: Need to recreate the menu with ox_lib
]]