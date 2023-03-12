Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0) -- prevencion de crasheos 

		SetPedDensityMultiplierThisFrame(100.50) -- Densidad de npcs quietos
		SetRandomVehicleDensityMultiplierThisFrame(100.0) -- Vehículos aleatorios  
		SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0) -- Densidad de npcs que caminan por la calle
		SetGarbageTrucks(false) -- Evita que los camiones de basura aparezcan al azar
		SetRandomBoats(false) -- Evita que aparezcan barcos al azar en el agua.
		SetCreateRandomCops(false) -- Deshabilita policías aleatorios caminando / conduciendo.
		SetCreateRandomCopsNotOnScenarios(false) -- Deshabilita a los policías aleatorias que nacen al provocar delitos.
		SetCreateRandomCopsOnScenarios(false) -- Deshabilita a los policías aleatorias que nacen al provocar delitos.
		
		local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
		ClearAreaOfVehicles(x, y, z, 1000, false, false, false, false, false)
		RemoveVehiclesFromGeneratorsInArea(x - 500.0, y - 500.0, z - 500.0, x + 500.0, y + 500.0, z + 500.0);

		-- fix OneSync npcs 
        if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then

            if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1),false),-1) == GetPlayerPed(-1) then
                SetVehicleDensityMultiplierThisFrame(0.1)
                SetParkedVehicleDensityMultiplierThisFrame(0.0)
            else
                SetVehicleDensityMultiplierThisFrame(0.0)
                SetParkedVehicleDensityMultiplierThisFrame(0.1)
            end
        else
          SetParkedVehicleDensityMultiplierThisFrame(0.0)
          SetVehicleDensityMultiplierThisFrame(0.1)
        end
	end
end)


-- SpawnNPC = function(modelo, x,y,z,h)
--     hash = GetHashKey(modelo)
--     RequestModel(hash)
--     while not HasModelLoaded(hash) do
--         Wait(1)
--     end
--     crearNPC = CreatePed(5, hash, x,y,z - 1,h, false, true)
-- end

-- CreateThread(function()
--     SpawnNPC('a_m_m_eastsa_02', 244.615386, 201.243958, 105.188232, 65.196854)
--     SpawnNPC('a_m_m_hillbilly_02', 243.705490, 204.263732, 105.221924, 79.370080)
-- end)