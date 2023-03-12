local OPA = false

Citizen.CreateThread( function()
        while true do 
            Citizen.Wait( 1 )

            local ped = GetPlayerPed( -1 )

            if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then 
                DisableControlAction( 0, 36, true )

                if ( not IsPauseMenuActive() ) then 
                    if ( IsDisabledControlJustPressed( 0, 36 ) ) then 
                        RequestAnimSet( "move_ped_crouched" )

                        while ( not HasAnimSetLoaded( "move_ped_crouched" ) ) do 
                            Citizen.Wait( 100 )
                        end 

                        if ( OPA == true ) then 
                            ResetPedMovementClipset( ped, 0 )
                            OPA = false 
                        elseif ( OPA == false ) then
                            SetPedMovementClipset( ped, "move_ped_crouched", 0.25 )
                            OPA = true 
                        end 
                    end
                end 
            end 
        end
    end 
) 