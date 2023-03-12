ESX = exports['es_extended']:getSharedObject()

RegisterNetEvent("resetskin:resetSkin")
AddEventHandler("resetskin:resetSkin", function()
    local uniforms = {
        male = {
            ["tshirt_1"] = 15,
            ["tshirt_2"] = 0,
            ["torso_1"] = 260,
            ["torso_2"] = 23,
            ["decals_1"] = 0,
            ["decals_2"] = 0,
            ["arms"] = 11,
            ["pants_1"] = 26,
            ["pants_2"] = 6,
            ["shoes_1"] = 1,
            ["shoes_2"] = 0,
            ["chain_1"] = 0,
            ["chain_2"] = 0,
            ["helmet_1"] = -1,
            ["helmet_2"] = 0,
            ["glasses_1"] = 0,
            ["glasses_2"] = 0
        },
        female = {
            ["tshirt_1"] = 14,
            ["tshirt_2"] = 0,
            ["torso_1"] = 269,
            ["torso_2"] = 23,
            ["decals_1"] = 0,
            ["decals_2"] = 0,
            ["arms"] = 9,
            ["pants_1"] = 0,
            ["pants_2"] = 8,
            ["shoes_1"] = 1,
            ["shoes_2"] = 1,
            ["chain_1"] = 0,
            ["chain_2"] = 0,
            ["helmet_1"] = -1,
            ["helmet_2"] = 0,
            ["glasses_1"] = 0,
            ["glasses_2"] = 0
        }
    }

    local playerPed = PlayerPedId()
    local lastHealth = GetEntityHealth(playerPed)
    local defaultModel = GetHashKey("a_m_y_stbla_02")
    SetEntityVisible(PlayerPedId(), false)
    RequestModel(defaultModel)

    while not HasModelLoaded(defaultModel) do
        Wait(0)
    end

    SetPlayerModel(PlayerId(), defaultModel)
    SetPedDefaultComponentVariation(PlayerPedId())
    SetPedRandomComponentVariation(PlayerPedId(), true)
    SetModelAsNoLongerNeeded(defaultModel)
    FreezeEntityPosition(PlayerPedId(), false)

    Wait(0)

    TriggerEvent("skinchanger:getSkin", function(skin)
        skin["sex"] = changeSex(skin["sex"]) --cambiamos sexo
        TriggerEvent("skinchanger:loadSkin", skin)
        Citizen.Wait(0)
        skin["sex"] = changeSex(skin["sex"])
        TriggerEvent("skinchanger:loadSkin", skin)
        ESX.ShowNotification('Skin Recargada ~b~Correctamente')
    end)

    Wait(0)

    TriggerEvent("skinchanger:getSkin", function(skin)
        if skin.sex == 0 then
            if uniforms.male ~= nil then
                TriggerEvent("skinchanger:loadClothes", skin, uniforms.male)
            else
                ESX.ShowNotification('~r~La skin no se pudo recargar')
            end
        else
            if uniforms.female ~= nil then
                TriggerEvent("skinchanger:loadClothes", skin, uniforms.female)
            else
                ESX.ShowNotification('~r~La skin no se pudo recargar')
            end
        end
    end)

    Wait(0)

    ESX.TriggerServerCallback("esx_skin:getPlayerSkin", function(skin)
        TriggerEvent("skinchanger:loadSkin", skin)
    end)

    Wait(500)

    SetEntityHealth(PlayerPedId(), lastHealth)
    SetEntityVisible(PlayerPedId(), true)
    ClearPedTasksImmediately(playerPed)

    TriggerEvent("esx_tattooshop:cleanPlayer")
    TriggerServerEvent("esfer-rskin:recargararmas", source)
end)

RegisterCommand('vida', function()
    SetEntityHealth(PlayerPedId(), 130)
    print(GetEntityHealth(PlayerPedId()))
end)

function changeSex(sex)
    if sex == 0 then
        sex = 1
    else
        sex = 0
    end
    return sex
end

local cooldown = false

RegisterCommand("fixpj", function(source, args, rawCommand)
    if not cooldown then
        cooldown = true
        TriggerEvent("resetskin:resetSkin")

        Citizen.SetTimeout(5000, function()
            cooldown = false
        end)
    else
        ESX.ShowNotification("Debes esperar ~b~5 segundos~w~ para volver a usar este comando")
    end
end,false)