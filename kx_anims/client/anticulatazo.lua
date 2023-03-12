Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        SetPlayerTargetingMode(3)
        if IsPedArmed(PlayerPedId(), 6) then
            if IsPlayerFreeAiming(PlayerId()) then
                DisableControlAction(1, 141, true)
                DisableControlAction(1, 142, true)
            end
        else
            Citizen.Wait(999)
        end
    end
end)