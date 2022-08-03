ESX = nil

Citizen.CreateThread(function ()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end
	ESX.PlayerData = ESX.GetPlayerData()
end)

Citizen.CreateThread(function()
	RegisterNetEvent('esx:playerLoaded')
	AddEventHandler('esx:playerLoaded', function (xPlayer)
		while ESX == nil do
			Citizen.Wait(0)
		end
		ESX.PlayerData = xPlayer
	end)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function (job)
	ESX.PlayerData.job = job
end)

MenuDeOuf = {
    action = {
        'Ouvert',
        'Fermer',
        'Pause',
        'Personnalisée',
    }, list = 1
}

cooldownMenu = function(time)
    cooldown = true
    Citizen.SetTimeout(time,function()
        cooldown = false
    end)
end

function CreateCredit()
    local montant = KeyboardInput("Montant?", "", 10)
    local montant = tonumber(montant)
    if montant == nil then
        RageUI.Popup({message = "[~r~Erreur~s~]\n~r~Saisie incorrect"})
        else
        local taux = KeyboardInput("Taux?", "", 3)
        local taux = tonumber(taux)
        if taux == nil then
            RageUI.Popup({message = "[~r~Erreur~s~]\n~r~Saisie incorrect"})
            else
            local nbEche = KeyboardInput("Nombre d'échéance?", "", 50)
            local nbEche = tonumber(nbEche)
            if nbEche == nil then
                RageUI.Popup({message = "[~r~Erreur~s~]\n~r~Saisie incorrect"})
            else
            local jours = KeyboardInput("Jours entre échéance ?", "", 50)
            local jours = tonumber(jours)
            if jours == nil then
                RageUI.Popup({message = "[~r~Erreur~s~]\n~r~Saisie incorrect"})
                else
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    if closestPlayer == -1 or closestDistance > 5.0 then
                        RageUI.Popup({message = "[~r~Erreur~s~]\n~r~Aucune personne à proximité"})
                    else
                    _TriggerServerEvent('eBanking:makeLoan', GetPlayerServerId(closestPlayer), montant, taux, nbEche, jours)
                    end
                end
            end
        end
    end
end

function RefreshCredit()
    LentList = {}
    ESX.TriggerServerCallback('eBanking:getLoanAccounts', function(customers)
		for k,v in pairs(customers) do
			table.insert(LentList, {
				fullname = v.firstname .. " " .. v.lastname,
                id = v.identifier,
                amount = v.amount,
                taux = v.taux,
                CbProEcheance = v.montProchEcheance,
                NbEche = v.nbEcheances,
                TauxEche = v.echeancesTot,
                CbDerniereEche = v.montDernEcheance,
                timeRest = v.timeleft,
                timeEcheance = v.timeEcheance,
                BanquierFullName = v.giverfirstname .. " " ..v.giverlastname,
                Status = v.status,
			})
		end
	end)
end

function CreateLivret()
    local montant = KeyboardInput("Montant?", "", 10)
    local montant = tonumber(montant)
    if montant == nil then
        RageUI.Popup({message = "[~r~Erreur~s~]\n~r~Saisie incorrect"})
    else
    local taux = KeyboardInput("Taux?", "", 3)
    local taux = tonumber(taux)
        if taux == nil then
            RageUI.Popup({message = "[~r~Erreur~s~]\n~r~Saisie incorrect"})
        else
        local nom = KeyboardInput("Nom?", "", 50)
        local nom = tostring(nom)
            if nom == "nil" then
                RageUI.Popup({message = "[~r~Erreur~s~]\n~r~Saisie incorrect"})
            else
            local prenom = KeyboardInput("Prénom ?", "", 50)
            local prenom = tostring(prenom)
                if prenom == "nil" then
                    RageUI.Popup({message = "[~r~Erreur~s~]\n~r~Saisie incorrect"})
                else
                    _TriggerServerEvent('eBanking:openSavingsAccount', montant, taux, nom, prenom)
                end
            end
        end
    end
end

function RefreshLivret()
    LivList = {}
	ESX.TriggerServerCallback('eBanking:getSavingsAccounts', function(customers)
		for k,v in pairs(customers) do
			table.insert(LivList, {
                id = v.identifier,
                fullname = v.firstname .. " " .. v.lastname,
                to = v.taux .. "%",
                total = v.tot .. "$",
                banquier = v.giverfirstname .. " " .. v.giverlastname,
			})
		end
	end)
end


function OpenBankingJob()
    local main_job = RageUI.CreateMenu("", "Banquier")
    local Credit_MAIN = RageUI.CreateSubMenu(main_job, "", "Gestion des crédits")
    local livret_menu = RageUI.CreateSubMenu(main_job, "", "Gestion des Livrets")
    local credit_load = RageUI.CreateSubMenu(Credit_MAIN, "", "Gestion des crédits")
    local gestion_credit = RageUI.CreateSubMenu(credit_load, "", "Gestion des crédits")
    local livret_load = RageUI.CreateSubMenu(livret_menu, "", "Gestion des Livrets")
    local gestion_livret = RageUI.CreateSubMenu(livret_menu, "", "Gestion des Livrets")

        RageUI.Visible(main_job, not RageUI.Visible(main_job))

        while main_job do

            Citizen.Wait(0)

            RageUI.IsVisible(main_job, true, true, true, function()

                RageUI.Line()
                RageUI.Separator("~b~ "..GetPlayerName(PlayerId()).." ~s~→ ~g~Banquier ~s~→ ~g~"..ESX.PlayerData.job.grade_label.." ~s~")
                RageUI.Line()

                RageUI.List('Vos annonces', MenuDeOuf.action, MenuDeOuf.list, nil, {RightLabel = ""}, not cooldown, function(Hovered, Active, Selected, Index)
                    if (Selected) then
                        if Index == 1 then
                        _TriggerServerEvent('eBanking:Annonce', true, false, false, false, false)
                        cooldownMenu(1500)
                        elseif Index == 2 then
                        _TriggerServerEvent('eBanking:Annonce', false, true, false, false, false)
                        cooldownMenu(1500)
                        elseif Index == 3 then
                        _TriggerServerEvent('eBanking:Annonce', false, false, true, false, false)
                        cooldownMenu(1500)
                        elseif Index == 4 then
                        local anomsg = KeyboardInput("Votre annonce", "", 100)
                        ExecuteCommand("banquier "..anomsg)
                        cooldownMenu(1500)
                        end
                        Wait(5)
                    end
                    MenuDeOuf.list = Index;
                end)

                RageUI.ButtonWithStyle("Facturation",nil, {RightLabel = "→→"}, not cooldown, function(_,_,s)
                    local player, distance = ESX.Game.GetClosestPlayer()
                    if s then
                        local raison = ""
                        local montant = 0
                        AddTextEntry("FMMC_MPM_NA", "Objet de la facture")
                        DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Donnez le motif de la facture :", "", "", "", "", 30)
                        while (UpdateOnscreenKeyboard() == 0) do
                            DisableAllControlActions(0)
                            Wait(0)
                        end
                        if (GetOnscreenKeyboardResult()) then
                            local result = GetOnscreenKeyboardResult()
                            if result then
                                raison = result
                                result = nil
                                AddTextEntry("FMMC_MPM_NA", "Montant de la facture")
                                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Indiquez le montant de la facture :", "", "", "", "", 30)
                                while (UpdateOnscreenKeyboard() == 0) do
                                    DisableAllControlActions(0)
                                    Wait(0)
                                end
                                if (GetOnscreenKeyboardResult()) then
                                    result = GetOnscreenKeyboardResult()
                                    if result then
                                        montant = result
                                        result = nil
                                        if player ~= -1 and distance <= 3.0 then
                                            _TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), Config.SocietyName, ('banquier'), montant)
                                            TriggerEvent('esx:showAdvancedNotification', 'Fl~g~ee~s~ca ~g~Bank', 'Facture envoyée : ', 'Vous avez envoyé une facture d\'un montant de : ~g~'..montant.. '$ ~s~pour cette raison : ~b~' ..raison.. '', 'CHAR_BANK_FLEECA', 9)
                                        else
                                            RageUI.Popup({message = "[~r~Erreur~s~]\n~r~Aucune personne à proximité"})
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)

                RageUI.ButtonWithStyle("Gestion des crédits", nil,  {RightLabel = "→→"}, not cooldown, function(Hovered, Active, Selected)
                end, Credit_MAIN)

                RageUI.ButtonWithStyle("Gestion des livrets", nil,  {RightLabel = "→→"}, not cooldown, function(Hovered, Active, Selected)
                end, livret_menu)

                RageUI.Line()

            end, function() 
            end)

            RageUI.IsVisible(Credit_MAIN, true, true, true, function()
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                RageUI.Line()

                        
                if closestPlayer ~= -1 and closestDistance < 3.0 then
                    RageUI.ButtonWithStyle("Créé un crédit", nil,  {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            CreateCredit()
                        end
                    end)
                else
                    RageUI.ButtonWithStyle("Créé un crédit", "Personne proche de vous",  {RightBadge = RageUI.BadgeStyle.Lock}, false, function(Hovered, Active, Selected)
                    end) 
                end

                RageUI.ButtonWithStyle("Liste des crédits", nil,  {RightLabel = "→→"}, not cooldown, function(Hovered, Active, Selected)
                    if Selected then 
                        RefreshCredit()
                    end
                end, credit_load)

                RageUI.Line()

            end, function() 
            end)

            RageUI.IsVisible(credit_load, true, true, true, function()

                RageUI.Line()

                for k,v in pairs(LentList) do
                    RageUI.ButtonWithStyle("Client : "..v.fullname, nil, {RightLabel = "Montant : ~g~"..v.amount.."$ ~s~→"}, true, function(Hovered, Active, Selected)
                        if Selected then 
                            identifier = v.id
                            fullname = v.fullname
                            Montant = v.amount
                            Taux = v.taux
                            NbEcheance = v.NbEche
                            BizzareLui = v.CbDerniereEche
                            StatusFrero = v.Status
                            banquier = v.BanquierFullName
                            RefreshCredit()
                        end
                    end, gestion_credit)
                    RageUI.Line()
                end

            end, function() 
            end)

            RageUI.IsVisible(gestion_credit, true, true, true, function()

                RageUI.Line()
                RageUI.Separator("~g~Client : "..fullname)
                RageUI.Separator("Montant du crédit : "..Montant.."$ à "..Taux.."%")
                RageUI.Separator("Nombre d'échéance restante : "..NbEcheance)
                RageUI.Separator("~g~Déjà rembourser : "..BizzareLui.."$")
                RageUI.Separator("Conseiller : "..banquier)
                RageUI.Separator("Status du crédit : "..StatusFrero)
                RageUI.Line()

                RageUI.ButtonWithStyle("Geler le crêdit", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                    if Selected then 
                        _TriggerServerEvent('eBanking:freezeLoan', identifier)
                    end
                end, Credit_MAIN)

                RageUI.ButtonWithStyle("Dégeler le crêdit", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                    if Selected then 
                        _TriggerServerEvent('eBanking:reopenLoan', identifier)
                    end
                end, Credit_MAIN)

                RageUI.ButtonWithStyle("Avancer les échéances", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                    if Selected then 
                        _TriggerServerEvent('eBanking:avEche', identifier)
                    end
                end, Credit_MAIN)

                RageUI.ButtonWithStyle("Arrêter le crêdit", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                    if Selected then 
                        _TriggerServerEvent('eBanking:closeLoan', identifier)
                    end
                end, Credit_MAIN)

                RageUI.ButtonWithStyle("Supprimer le crêdit", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                    if Selected then 
                        _TriggerServerEvent('eBanking:DeleteLoan', identifier)
                    end
                end, Credit_MAIN)

                RageUI.Line()


            end, function() 
            end)


            RageUI.IsVisible(livret_menu, true, true, true, function()
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                RageUI.Line()

                if closestPlayer ~= -1 and closestDistance < 3.0 then
                    RageUI.ButtonWithStyle("Créé un livret", nil,  {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            CreateLivret()
                        end
                    end)
                else
                    RageUI.ButtonWithStyle("Créé un livret", "Personne proche de vous",  {RightBadge = RageUI.BadgeStyle.Lock}, false, function(Hovered, Active, Selected)
                    end) 
                end

                RageUI.ButtonWithStyle("Liste des livrets", nil,  {RightLabel = "→→"}, not cooldown, function(Hovered, Active, Selected)
                    if Selected then 
                        RefreshLivret()
                    end
                end, livret_load)

                RageUI.Line()

            end, function() 
            end)

            RageUI.IsVisible(livret_load, true, true, true, function()

                RageUI.Line()

                for k,v in pairs(LivList) do
                    RageUI.ButtonWithStyle("Livret de : "..v.fullname, nil, {RightLabel = "Contient : ~g~"..v.total.."~s~ →"}, true, function(Hovered, Active, Selected)
                        if Selected then 
                            identifier = v.id
                            fullname = v.fullname
                            taux = v.to
                            total = v.total
                            banquier = v.banquier
                        end
                    end, gestion_livret)
                    RageUI.Line()
                end

            end, function() 
            end)

            RageUI.IsVisible(gestion_livret, true, true, true, function()

                RageUI.Line()
                RageUI.Separator("~g~Client : "..fullname)
                RageUI.Separator("Conseiller : "..banquier)
                RageUI.Separator("~g~Contenance : "..total)
                RageUI.Separator("Taux : "..taux)
                RageUI.Line()
                RageUI.ButtonWithStyle("Déposer de l'argent", nil,  {RightLabel = "→→"}, not cooldown, function(Hovered, Active, Selected)
                    if Selected then
                        local montant = KeyboardInput("Montant ?", "", 50)
                        local montant = tonumber(montant)
                        if montant == nil then
                            RageUI.Popup({message = "[~r~Erreur~s~]\n~r~Saisie incorrect"})
                        else
                            _TriggerServerEvent('eBanking:depositMoneySavingsAccount', identifier, montant)
                        end
                    end
                end, livret_menu)

                RageUI.ButtonWithStyle("Retirer de l'argent", nil,  {RightLabel = "→→"}, not cooldown, function(Hovered, Active, Selected)
                    if Selected then 
                        local montant = KeyboardInput("Montant ?", "", 50)
                        local montant = tonumber(montant)
                        if montant == nil then
                            RageUI.Popup({message = "[~r~Erreur~s~]\n~r~Saisie incorrect"})
                        else
                        _TriggerServerEvent('eBanking:withdrawSavings', identifier, montant)
                        end
                    end
                end, livret_menu)

                RageUI.ButtonWithStyle("Modifier le taux du coffre", nil,  {RightLabel = "→→"}, not cooldown, function(Hovered, Active, Selected)
                    if Selected then 
                        local taux = KeyboardInput("Taux ?", "", 50)
                        local taux = tonumber(taux)
                        if taux == nil then
                            RageUI.Popup({message = "[~r~Erreur~s~]\n~r~Saisie incorrect"})
                        else
                        _TriggerServerEvent('eBanking:changeSavingsAccountRate', identifier, taux)
                        end
                    end
                end, livret_menu)

                RageUI.ButtonWithStyle("Supprimer le coffre", nil,  {RightLabel = "→→"}, not cooldown, function(Hovered, Active, Selected)
                    if Selected then 
                        _TriggerServerEvent('eBanking:closeSavingsAccount', identifier)
                    end
                end, livret_menu)

                RageUI.Line()


            end, function() 
            end)

        if not RageUI.Visible(main_job) and not RageUI.Visible(Credit_MAIN) and not RageUI.Visible(livret_menu) and not RageUI.Visible(credit_load) and not RageUI.Visible(gestion_credit) and not RageUI.Visible(livret_load) and not RageUI.Visible(gestion_livret) then
            main_job = RMenu:DeleteType(main_job, true)
        end
    end
end

Keys.Register('F6', 'Banquier', 'Ouvrir le menu Banquier', function()
	if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.JobName then
    	OpenBankingJob()
	end
end)