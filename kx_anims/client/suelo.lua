local ragdoll = false
function setRagdoll(flag)
  ragdoll = flag
end
Citizen.CreateThread(function()
  while true do
    local wait = 500
    if ragdoll then
      wait = 0
      SetPedToRagdoll(GetPlayerPed(-1), 1000, 1000, 0, 0, 0, 0)
    end

    Wait(wait)
  end
end)

ragdol = true
RegisterNetEvent("Ragdoll")
AddEventHandler("Ragdoll", function()
	if ( ragdol ) then
		setRagdoll(true)
		ragdol = false
	else
		setRagdoll(false)
		ragdol = true
	end
end)

RegisterCommand("suelo", function(source, args, raw) --
    TriggerEvent("Ragdoll")
end, false) --

RegisterKeyMapping('suelo', 'suelo', 'keyboard', 'U')