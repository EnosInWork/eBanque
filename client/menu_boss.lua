ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(0)
    end
    while ESX.GetPlayerData().job == nil do
        Wait(10)
    end
    ESX.PlayerData = ESX.GetPlayerData()
end)

function RefreshBankingMoney()
    if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' then
        ESX.TriggerServerCallback('eBanking:getSocietyMoney', function(money)
            UpdateBankingMoney(money)
        end, ESX.PlayerData.job2.name)
    end
end

function UpdateBankingMoney(money)
    BankingMoneyAccount = ESX.Math.GroupDigits(money)
end

function menudubuigboss()
    local main = RageUI.CreateMenu("", "Actions Patron")

        RageUI.Visible(main, not RageUI.Visible(main))
            while main do
            Citizen.Wait(0)
            RageUI.IsVisible(main, true, true, true, function()

            RageUI.Line()
            if BankingMoneyAccount ~= nil then
                RageUI.Separator("Argent de société : "..BankingMoneyAccount.."$")
            end
            RageUI.Line()

            RageUI.ButtonWithStyle("Retirer de l'argent",nil, {RightLabel = "→→"}, not cooldown, function(Hovered, Active, Selected)
                if Selected then
                    local amount = KeyboardInput("Montant", "", "", 10)
                    amount = tonumber(amount)
                    if amount == nil then
                        RageUI.Popup({message = "[~r~Problème~s~]\nMontant invalide"})
                    else
                        TriggerServerEvent("eBanking:retraitentreprise", amount)
                        RefreshBankingMoney()
                    end
                end
            end)

            RageUI.ButtonWithStyle("Déposer de l'argent",nil, {RightLabel = "→→"}, not cooldown, function(Hovered, Active, Selected)
                if Selected then
                    local amount = KeyboardInput("Montant", "", "", 10)
                    amount = tonumber(amount)
                    if amount == nil then
                        RageUI.Popup({message = "[~r~Problème~s~]\nMontant invalide"})
                    else
                        TriggerServerEvent("eBanking:depotentreprise", amount)
                        RefreshBankingMoney()
                    end
                end
            end) 

            RageUI.ButtonWithStyle("Recruter", nil, {RightLabel = "→→"}, not cooldown, function(Hovered, Active, Selected)
                if (Selected) then   
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    if closestPlayer ~= -1 and closestDistance <= 3.0 then
                        TriggerServerEvent('eBanking:recruter', GetPlayerServerId(closestPlayer))
                    else
                        RageUI.Popup({message = "[~r~Problème~s~]\nAucun joueur à proximité"})
                    end 
                end
            end)

                RageUI.ButtonWithStyle("Promouvoir", nil, {RightLabel = "→→"}, not cooldown, function(Hovered, Active, Selected)
                if (Selected) then   
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    if closestPlayer ~= -1 and closestDistance <= 3.0 then
                        TriggerServerEvent('eBanking:promouvoir', GetPlayerServerId(closestPlayer))
                    else
                        RageUI.Popup({message = "[~r~Problème~s~]\nAucun joueur à proximité"})
                    end 
                end
            end)

                RageUI.ButtonWithStyle("Rétrograder", nil, {RightLabel = "→→"}, not cooldown, function(Hovered, Active, Selected)
                if (Selected) then   
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    if closestPlayer ~= -1 and closestDistance <= 3.0 then
                        TriggerServerEvent('eBanking:descendre', GetPlayerServerId(closestPlayer))
                    else
                        RageUI.Popup({message = "[~r~Problème~s~]\nAucun joueur à proximité"})
                    end 
                end
            end)

                RageUI.ButtonWithStyle("Virer", nil, {RightLabel = "→→"}, not cooldown, function(Hovered, Active, Selected)
                if (Selected) then   
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    if closestPlayer ~= -1 and closestDistance <= 3.0 then
                        TriggerServerEvent('eBanking:virer', GetPlayerServerId(closestPlayer))
                    else
                        RageUI.Popup({message = "[~r~Problème~s~]\nAucun joueur à proximité"})
                    end 
                end
            end)

            RageUI.Line()

            end, function()
            end)

            if not RageUI.Visible(main) then
            main = RMenu:DeleteType(main, true)
        end
    end
end

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        local plyPos = GetEntityCoords(PlayerPedId())
        local dist = #(plyPos-Config.Boss)
        if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.JobName then
				if dist <= Config.Marker.DrawDistance then
				Timer = 0
				DrawMarker(Config.Marker.Type, Config.Boss, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, Config.Marker.Color.H)
				end
				if dist <= Config.Marker.DrawInteract then
					Timer = 0
                    RageUI.Text({ message = "Appuyez sur ~g~[E]~s~ pour ouvrir →→ ~g~Actions Patron", time_display = 1 })
					if IsControlJustPressed(1,51) then
                        RefreshBankingMoney()
                        menudubuigboss()
					end
				end
			end
		Citizen.Wait(Timer)
	end
end)
