local isIdlePlaying = false
local lastActionTime = 0
local idleTimeout = 30000 

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()

        if DoesEntityExist(playerPed) and not IsEntityDead(playerPed) then
            if IsControlPressed(0, 32) or IsControlPressed(0, 33) or IsControlPressed(0, 34) or IsControlPressed(0, 35) then
                lastActionTime = GetGameTimer()
            end
            
            if GetGameTimer() - lastActionTime > idleTimeout then
                if not isIdlePlaying and not exports["rpemotes"]:IsPlayerInAnim() and not IsPedUsingAnyScenario(playerPed) then
                    local model = GetEntityModel(playerPed)
                    local animDict = "move_m@generic_idles@std"

                    -- Verificar si el personaje es femenino o masculino
                    if model == GetHashKey("mp_f_freemode_01") then
                        -- Animación de mujer
                        animDict = "move_f@generic_idles@std"
                    end

                    RequestAnimDict(animDict)
                    while not HasAnimDictLoaded(animDict) do
                        Citizen.Wait(100)
                    end

                    TaskPlayAnim(playerPed, animDict, "idle", 8.0, -8, -1, 49, 0, false, false, false)
                    isIdlePlaying = true
                end
            else
                if isIdlePlaying then
                    ClearPedTasks(playerPed)
                    isIdlePlaying = false
                end
            end
        end
    end
end)
