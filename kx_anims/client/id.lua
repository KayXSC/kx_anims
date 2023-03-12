local a = 8
bEnabled = true
playerDistances = {}
Citizen.CreateThread(
    function()
        Citizen.Wait(1000)
        while true do
            -- if IsControlJustReleased(1, 19) then
            --     bEnabled = not bEnabled
            -- end
            local msec = 1000
            if bEnabled then
                local b = GetPlayerPed(-1)
                for c = 0, 255 do
                    if NetworkIsPlayerActive(c) then
                        local d = GetPlayerPed(c)
                        if d ~= b then
                            if playerDistances[c] < a and IsEntityVisible(d) then
                                x2, y2, z2 = table.unpack(GetEntityCoords(d, true))
                                msec = 0
                                if NetworkIsPlayerTalking(c) then
                                    DrawText3D(x2, y2, z2 + 1, GetPlayerServerId(c), 56, 218, 175)
                                else
                                    DrawText3D(x2, y2, z2 + 1, GetPlayerServerId(c), 255, 255, 255)
                                end
                            end
                        end
                    end
                end
            end
            Citizen.Wait(msec)
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            if bEnabled then
                local b = GetPlayerPed(-1)
                for c = 0, 255 do
                    local d = GetPlayerPed(c)
                    if d ~= b then
                        x1, y1, z1 = table.unpack(GetEntityCoords(b, true))
                        x2, y2, z2 = table.unpack(GetEntityCoords(d, true))
                        distance = math.floor(GetDistanceBetweenCoords(x1, y1, z1, x2, y2, z2, true))
                        playerDistances[c] = distance
                    end
                end
            end
            Citizen.Wait(1500)
        end
    end
)

RegisterCommand('ids', function() -- KNARIO TE LO HACE Y TE LO HACE BB
    bEnabled = not bEnabled
end)

function DrawText3D(e, f, g, h, i, j, k)
    local l, m, n = World3dToScreen2d(e, f, g)
    local o, p, q = table.unpack(GetGameplayCamCoords())
    local r = GetDistanceBetweenCoords(o, p, q, e, f, g, 1)
    local s = 1 / r * 2
    local t = 1 / GetGameplayCamFov() * 100
    local s = s * t
    if l then
        SetTextScale(0.0 * s, 0.55 * s)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(i, j, k, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(h)
        DrawText(m, n)
    end
end