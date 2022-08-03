local currentToken = ""

function _TriggerServerEvent(eventName, ...)
    TriggerServerEvent(eventName, currentToken, ...)
end

RegisterNetEvent("eBanking:OnRequestToken")
AddEventHandler("eBanking:OnRequestToken", function(newToken)
    currentToken = newToken
end)

Citizen.CreateThread(function()
    TriggerServerEvent("eBanking:RequestToken")
end)

ShowHelpNotification = function(text)
	AddTextEntry("HelpNotification", text)
    DisplayHelpTextThisFrame("HelpNotification", false)
end

ShowNotification = function(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

cartebleu = function(cb)
    ESX.TriggerServerCallback('eBanking:GetItemCard', function(quantite)
        cb(quantite > 0)
    end, 'cartebanque')
end

StartAnimation = function(animDict, animName, duration)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do Citizen.Wait(0) end
	TaskPlayAnim(PlayerPedId(), animDict, animName, 1.0, -1.0, duration, 49, 1, false, false, false)
	RemoveAnimDict(animDict)
end

KeyboardInput = function(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Citizen.Wait(0)
    end
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult() 
        Citizen.Wait(500) 
        blockinput = false
        return result 
    else
        Citizen.Wait(500) 
        blockinput = false 
        return nil 
    end
end