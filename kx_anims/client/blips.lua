local blips = {
    -- Example {title="", colour=, id=, x=, y=, z=},

     --{title="Mecanico del norte", colour=5, id=446, x = 30.02, y = 6460.42, z = 31.44},
     --{title="Bahamas", colour=27, id=93, x = -1384.32, y = -592.28, z = 30.32},
     --{title="Vanilla", colour=27, id=93, x = 124.07, y = -1287.36, z = 29.26},
     --{title="The Hen-House", colour=27, id=93, x = -300.42, y = 6256.35, z = 31.51},
     --{title="Hospital Norte", colour=2, id=61, x = -245.62, y = 6328.67, z = 32.43},
     --{title="Lavado de coches", colour=3, id=100, x = -699.43, y = -917.48, z = 19.21},
     --{title="Lavado de coches", colour=3, id=100, x = -2.72, y = -1396.64, z = 29.26},
     --{title="Lavado de coches", colour=3, id=100, x = 1361.03, y = 3595.41, z = 34.91},
     --{title="Lavado de coches", colour=3, id=100, x = -70.52, y = 6424.94, z = 31.44},
     --{title="Concesionario VIP", colour=0, id=225, x = -57.4715, y = -1096.51, z = 26.422},
     --{title="Mosley Segunda Mano", colour=1, id=147, x = -52.3887, y = -1688.31, z = 29.491},
     {title="Oasis Cayo Perico", colour=7, id=93, x = 4892.634, y = -4925.33, z = 3.3777},
     --{title="MiniGolf", colour=2, id=738, x = -1739.43, y = -1136.32, z = 13.226},
     {title="Gimnasio", colour=26, id=311, x = -1271.58, y = -359.968, z = 36.959}
  }
      
Citizen.CreateThread(function()

    for _, info in pairs(blips) do
      info.blip = AddBlipForCoord(info.x, info.y, info.z)
      SetBlipSprite(info.blip, info.id)
      SetBlipDisplay(info.blip, 4)
      SetBlipScale(info.blip, 0.7)
      SetBlipColour(info.blip, info.colour)
      SetBlipAsShortRange(info.blip, true)
	  BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(info.title)
      EndTextCommandSetBlipName(info.blip)
    end
end)