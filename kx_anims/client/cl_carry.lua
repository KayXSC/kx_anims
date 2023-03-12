local function Notify(msg)
	ESX.ShowNotification(msg)
end

local state = {
	InProgress = false,
	targetSrc = -1,
	type = "",
	mode = 'carry1'
}


local carrytypes = {
	['carry1'] = {
		me = 'Le carga al hombro',
		personCarrying = {
			animDict = "missfinale_c2mcs_1",
			anim = "fin_c2_mcs_1_camman",
			flag = 49,
		},
		personCarried = {
			animDict = "nm",
			anim = "firemans_carry",
			attachX = 0.27,
			attachY = 0.15,
			attachZ = 0.63,
			flag = 33,
			attatchXrot = 0.5,
			attatchYrot = 0.5,
			attatchZrot = 180,
		}
	},
	['piggyback'] = {
		me = 'Le carga a caballito',
		personCarrying = {
			animDict = "anim@arena@celeb@flat@paired@no_props@",
			anim = "piggyback_c_player_a",
			flag = 49,
		},
		personCarried = {
			animDict = "anim@arena@celeb@flat@paired@no_props@",
			anim = "piggyback_c_player_b",
			attachX = 0.0,
			attachY = -0.07,
			attachZ = 0.45,
			flag = 33,
			attatchXrot = 0.5,
			attatchYrot = 0.5,
			attatchZrot = 180,
		}
	},
	['hombros'] = {
		me = 'Le carga a los hombros',
		personCarrying = {
			animDict = "amb@world_human_hiker_standing@male@base",
			anim = "base",
			flag = 49,
		},
		personCarried = {
			animDict = "anim@amb@business@cfm@cfm_machine_no_work@",
			anim = "transition_sleep_v2_operator",
			attachX = 0.0,
			attachY = 0.17,
			attachZ = 1.0,
			flag = 33,
			attatchXrot = 0.5,
			attatchYrot = 0.5,
			attatchZrot = 180,
		}
	},
	['hombros2'] = {
		me = 'Le carga a los hombros',
		personCarrying = {
			animDict = "couplepose3pack1anim2@animation",
			anim = "couplepose3pack1anim2_clip",
			flag = 49,
		},
		personCarried = {
			animDict = "couplepose3pack1anim1@animation",
			anim = "couplepose3pack1anim1_clip",
			attachX = -0.2120,
			attachY = -0.5400,
			attachZ = -0.1000,
			flag = 33,
			attatchXrot = 0.0,
			attatchYrot = 0.0,
			attatchZrot = 0.0,
		}
	},
	['pecho'] = {
		me = 'Le carga',
		personCarrying = {
			animDict = "couplepose1cmg@animation",
			anim = "couplepose1cmg_clip",
			flag = 49,
		},
		personCarried = {
			animDict = "couplepose2cmg@animation",
			anim = "couplepose2cmg_clip",
			attachX = 0.01,
			attachY = 0.344,
			attachZ = -0.01,
			flag = 33,
			attatchXrot = 0.0,
			attatchYrot = 0.0,
			attatchZrot = -180.0,
		}
	},
	['espalda'] = {
		me = 'Le carga en la espalda',
		personCarrying = {
			animDict = "mx@piggypack_a",
			anim = "mxclip_a",
			flag = 49,
		},
		personCarried = {
			animDict = "mx@piggypack_b",
			anim = "mxanim_b",
			attachX = 0.0200,
			attachY = -0.4399,
			attachZ = 0.4200,
			flag = 33,
			attatchXrot = 0.5,
			attatchYrot = 0.5,
			attatchZrot = 180,
		}
	},
	['brazos'] = {
		me = 'Le carga en brazos',
		personCarrying = {
			animDict = "amnilka@photopose@couple@couplefirst",
			anim = "amnilka_couple_mal_002",
			flag = 49,
		},
		personCarried = {
			animDict = "amnilka@photopose@couple@couplefirst",
			anim = "amnilka_couple_fem_002",
			attachX = 0.0,
			attachY = 0,
			attachZ = 0,
			flag = 33,
			attatchXrot = 0.5,
			attatchYrot = 0.5,
			attatchZrot = 180,
		}
	},
	['pecho2'] = {
		me = 'Le carga en brazos',
		personCarrying = {
			animDict = "tigerle@custom@couple@standcuddle_a",
			anim = "tigerle_couple_standcuddle_a",
			flag = 49,
		},
		personCarried = {
			animDict = "tigerle@custom@couple@standcuddle_b",
			anim = "tigerle_couple_standcuddle_b",
			attachX = 0.0,
			attachY = 0.40,
			attachZ = 0,
			flag = 33,
			attatchXrot = 0.0,
			attatchYrot = 0.0,
			attatchZrot = -180.0,
		}
	},
}

local function GetClosestPlayer(radius)
    local players = GetActivePlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    for _,playerId in ipairs(players) do
        local targetPed = GetPlayerPed(playerId)
        if targetPed ~= playerPed then
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(targetCoords-playerCoords)
            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = playerId
                closestDistance = distance
            end
        end
    end
	if closestDistance ~= -1 and closestDistance <= radius then
		return closestPlayer
	else
		return nil
	end
end

local function ensureAnimDict(animDict)
    if not HasAnimDictLoaded(animDict) then
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(0)
        end        
    end
    return animDict
end

local function EnsureAnims()
	local pPed = PlayerPedId()
	while state.InProgress do
        if state.type == "beingcarried" then
            if not IsEntityPlayingAnim(pPed, carrytypes[state.mode].personCarried.animDict, carrytypes[state.mode].personCarried.anim, 3) then
                TaskPlayAnim(pPed, carrytypes[state.mode].personCarried.animDict, carrytypes[state.mode].personCarried.anim, 8.0, 8.0, 100000, carrytypes[state.mode].personCarried.flag, 0, false, false, false)
            end
        elseif state.type == "carrying" then
            if not IsEntityPlayingAnim(pPed, carrytypes[state.mode].personCarrying.animDict, carrytypes[state.mode].personCarrying.anim, 3) then
                TaskPlayAnim(pPed, carrytypes[state.mode].personCarrying.animDict, carrytypes[state.mode].personCarrying.anim, 8.0, 8.0, 100000, carrytypes[state.mode].personCarrying.flag, 0, false, false, false)
            end
        end

		if state.mode == 'takehostage' and state.type == 'carrying' then 
			DisableControlAction(0,24,true) -- disable attack
			DisableControlAction(0,25,true) -- disable aim
			DisableControlAction(0,47,true) -- disable weapon
			DisableControlAction(0,58,true) -- disable weapon
			DisableControlAction(0,21,true) -- disable sprint
			DisablePlayerFiring(pPed,true)
		
		elseif state.mode == 'takehostage' and state.type == 'hostage' then 
			DisableControlAction(0,21,true) -- disable sprint
			DisableControlAction(0,24,true) -- disable attack
			DisableControlAction(0,25,true) -- disable aim
			DisableControlAction(0,47,true) -- disable weapon
			DisableControlAction(0,58,true) -- disable weapon
			DisableControlAction(0,263,true) -- disable melee
			DisableControlAction(0,264,true) -- disable melee
			DisableControlAction(0,257,true) -- disable melee
			DisableControlAction(0,140,true) -- disable melee
			DisableControlAction(0,141,true) -- disable melee
			DisableControlAction(0,142,true) -- disable melee
			DisableControlAction(0,143,true) -- disable melee
			DisableControlAction(0,75,true) -- disable exit vehicle
			DisableControlAction(27,75,true) -- disable exit vehicle  
			DisableControlAction(0,22,true) -- disable jump
			DisableControlAction(0,32,true) -- disable move up
			DisableControlAction(0,268,true)
			DisableControlAction(0,33,true) -- disable move down
			DisableControlAction(0,269,true)
			DisableControlAction(0,34,true) -- disable move left
			DisableControlAction(0,270,true)
			DisableControlAction(0,35,true) -- disable move right
			DisableControlAction(0,271,true)
		end
		Wait(0)
	end
end

local function doCarry(mode)
	if not state.InProgress then
		local closestPlayer = GetClosestPlayer(3)
		if closestPlayer then
			local targetSrc = GetPlayerServerId(closestPlayer)
			ExecuteCommand('me ' .. carrytypes[mode].me)
			if targetSrc ~= -1 then
				state.InProgress = true
				state.targetSrc = targetSrc
				state.mode = mode
				TriggerServerEvent("CarryPeople:sync", targetSrc, mode)
				ensureAnimDict(carrytypes[mode].personCarrying.animDict)
				state.type = "carrying"
                CreateThread(EnsureAnims)
			else
				Notify("~r~No hay nadie cerca.")
			end
		else
			Notify("~r~No hay nadie cerca.")
		end
	else
		state.InProgress = false
		ClearPedSecondaryTask(PlayerPedId())
		DetachEntity(PlayerPedId(), true, false)
		TriggerServerEvent("CarryPeople:stop", state.targetSrc)
		state.targetSrc = 0
		ExecuteCommand('me Le suelta')
	end
end


RegisterCommand("carry", function(source, args)
	doCarry('carry1')
end, false)

RegisterCommand("carry2", function(source, args)
	doCarry('hombros')
end, false)

RegisterCommand("caballito", function(source, args)
	doCarry('piggyback')
end, false)

RegisterCommand("brazos", function(source, args)
	doCarry('brazos')
end, false)

RegisterCommand("espalda", function(source, args)
	doCarry('espalda')
end, false)

RegisterCommand("hombros", function(source, args)
	doCarry('hombros2')
end, false)

RegisterCommand("pecho", function(source, args)
	doCarry('pecho')
end, false)

RegisterCommand("pecho2", function(source, args)
	doCarry('pecho2')
end, false)

RegisterNetEvent("CarryPeople:syncTarget", function(targetSrc, mode)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(targetSrc))
	state.mode = mode
	state.InProgress = true
	ensureAnimDict(carrytypes[mode].personCarried.animDict)
	AttachEntityToEntity(PlayerPedId(), targetPed, 0, carrytypes[mode].personCarried.attachX, carrytypes[mode].personCarried.attachY, carrytypes[mode].personCarried.attachZ, carrytypes[mode].personCarried.attatchXrot, carrytypes[mode].personCarried.attatchYrot, carrytypes[mode].personCarried.attatchZrot, false, false, false, false, 2, false)
	state.type = "beingcarried"
    CreateThread(EnsureAnims)
end)

RegisterNetEvent("CarryPeople:cl_stop", function()
	state.InProgress = false
	ClearPedSecondaryTask(PlayerPedId())
	DetachEntity(PlayerPedId(), true, false)
end)

RegisterNetEvent("TakeHostage:releaseHostage", function()
	state.InProgress = false 
	state.type = ""
	DetachEntity(PlayerPedId(), true, false)
	ensureAnimDict("reaction@shove")
	TaskPlayAnim(PlayerPedId(), "reaction@shove", "shoved_back", 8.0, -8.0, -1, 0, 0, false, false, false)
	Wait(250)
	ClearPedSecondaryTask(PlayerPedId())
end)

RegisterNetEvent("TakeHostage:killHostage", function()
	state.InProgress = false 
	state.type = ""
	SetEntityHealth(PlayerPedId(),0)
	DetachEntity(PlayerPedId(), true, false)
	ensureAnimDict("anim@gangops@hostage@")
	TaskPlayAnim(PlayerPedId(), "anim@gangops@hostage@", "victim_fail", 8.0, -8.0, -1, 168, 0, false, false, false)
end)

--- CAMBIOS:

-- Separado el loop EnsureAnims y activado solo cuando es necesario. 0.0ms en reposo, 0.2ms en uso.
-- Unidos piggyback y carry y takehostage. Eliminado código redundante, facilidad de añadir nuevos típos de carry o anclajes entre personajes.
-- Añadida animación de cargar a los hombros.
-- Añadido soporte para cargar NPCS.




-- RegisterCommand('pr', function()
-- 	local animDict1 = 'anim@heists@prison_heistig_2_p1_exit_bus'
-- 	RequestAnimDict(animDict1)
-- 	while not HasAnimDictLoaded(animDict1) do
--         Citizen.Wait(100)
--     end

-- 	local targetPosition, targetRotation = vec3(1694.1234, 2605.4087, 45.8214), vec3(0.0, 0.0, 20.0)
-- 	local animPos, targetHeading = GetAnimInitialOffsetPosition(animDict, "exit_bus_cam", targetPosition, targetRotation, 0, 2), 52.8159

-- 	dale = CreatePed(0, modelHash, pCoords.x, pCoords.y, pCoords.z, 5.0, true, false)
	
--     Citizen.Wait(1000)
--     local netScene = NetworkCreateSynchronisedScene(targetPosition, targetRotation, 2, false, false, 1065353216, 0, 1065353216)
--     NetworkAddPedToSynchronisedScene(ped, netScene, animDict, "switch_01", 1.0, -4.0, 157, 92, 1148846080, 0)
--     NetworkForceLocalUseOfSyncedSceneCamera(netScene, animDict, "switch_01_cam")
--     NetworkStartSynchronisedScene(netScene)
--     DoScreenFadeIn(250)

--     Citizen.Wait(7000)
--     NetworkStopSynchronisedScene(netScene)
--     RemoveAnimDict(animDict)


--     local animDict = "switch@franklin@exit_building"
    
-- 	local ped = PlayerPedId()
--     RequestAnimDict(animDict)

--     while not HasAnimDictLoaded(animDict) do
--         Citizen.Wait(100)
--     end

--     local targetPosition, targetRotation = vec3(1722.86, 2508.3, 45.56), vec3(0.0, 0.0, 20.0)

--     local animPos, targetHeading = GetAnimInitialOffsetPosition(animDict, "switch_01", targetPosition, targetRotation, 0, 2), 52.8159

--     Citizen.Wait(1000)
--     local netScene = NetworkCreateSynchronisedScene(targetPosition, targetRotation, 2, false, false, 1065353216, 0, 1065353216)
--     NetworkAddPedToSynchronisedScene(ped, netScene, animDict, "switch_01", 1.0, -4.0, 157, 92, 1148846080, 0)
--     NetworkForceLocalUseOfSyncedSceneCamera(netScene, animDict, "switch_01_cam")
--     NetworkStartSynchronisedScene(netScene)
--     DoScreenFadeIn(250)

--     Citizen.Wait(7000)
--     NetworkStopSynchronisedScene(netScene)
--     RemoveAnimDict(animDict)

-- end)





-- RegisterCommand('throw', function()
-- 	local animDict = 'switch@trevor@bridge'

-- 	RequestAnimDict(animDict)
-- 	while not HasAnimDictLoaded(animDict) do Wait(100) end

-- 	local pPed = PlayerPedId()
-- 	local pCoords = GetEntityCoords(pPed)
-- 	local netScene = NetworkCreateSynchronisedScene(pCoords.x, pCoords.y, pCoords.z, 0.0, 0.0, 0.0, 1.0, false, false, 1065353216, 10.0, 1.3)
-- 	NetworkAddPedToSynchronisedScene(pPed, netScene, animDict, "throw_exit_trevor", 1.5, -4.0, 1, 16, 1148846080, 0)

-- 	if not HasModelLoaded(modelHash) then
-- 		RequestModel(modelHash);
-- 		while not HasModelLoaded(modelHash) do 
-- 			Citizen.Wait(1); 
-- 		end  
-- 	end

-- 	local dale = CreatePed(0, modelHash, pCoords.x, pCoords.y, pCoords.z, 5.0, true, false)

-- 	NetworkAddPedToSynchronisedScene(dale, netScene, animDict, "throw_exit_victim", 1.5, -4.0, 1, 16, 1148846080, 0)
-- 	SetModelAsNoLongerNeeded(modelHash) 

-- 	NetworkStartSynchronisedScene(netScene)
-- end)