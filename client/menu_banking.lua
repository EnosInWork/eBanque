local PlayerMoney = 0

Citizen.CreateThread(function()
    for i=1, #Config.ATM, 1 do
        local blip = AddBlipForCoord(Config.ATM[i].x, Config.ATM[i].y, Config.ATM[i].z)
        SetBlipSprite(blip, 500)
        SetBlipColour(blip, 69)
        SetBlipAsShortRange(blip, true)
        SetBlipScale(blip, 0.20)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("ATM")
        EndTextCommandSetBlipName(blip)
    end
    for i=1, #Config.Banque, 1 do
        local blip = AddBlipForCoord(Config.Banque[i].x, Config.Banque[i].y, Config.Banque[i].z)
        SetBlipSprite(blip, 207)
        SetBlipColour(blip, 69)
        SetBlipAsShortRange(blip, true)
        SetBlipScale(blip, 0.65)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("Banque")
        EndTextCommandSetBlipName(blip)
    end
end)

RegisterNetEvent("solde:argent")
AddEventHandler("solde:argent", function(money, cash)
    PlayerMoney = tonumber(money)
end)


function RetraitArgent()
    local amount = KeyboardInput("Montant du retrait", "", 15)

    if amount ~= nil then
        amount = tonumber(amount)

        if type(amount) == 'number' then
            _TriggerServerEvent('eBanking:retirer', amount)
            _TriggerServerEvent('eBanking:PutHistorique', GetPlayerServerId(playerPed), "Retrait", amount, "ATM") 
            Wait(10)
            _TriggerServerEvent("eBanking:solde", action)
            GetBankingTransac()
        else
            ShowNotification("Vous n'avez pas saisi un montant")
        end
    end
end

function DepotArgent()
    local amount = KeyboardInput("Montant du dépot", "", 15)

    if amount ~= nil then
        amount = tonumber(amount)

        if type(amount) == 'number' then
            _TriggerServerEvent('eBanking:deposer', amount)
            _TriggerServerEvent('eBanking:PutHistorique', GetPlayerServerId(playerPed), "Dépot", amount, "ATM") 

            Wait(10)
            _TriggerServerEvent("eBanking:solde", action)
            GetBankingTransac()
        else
            ShowNotification("Vous n'avez pas saisi un montant")
        end
    end
end

function TransferArgent()
    local to = KeyboardInput("Quelle est l'ID de la personne", "", 5)
    local amountt = KeyboardInput("Combien d'argent vous voulez lui donner", "", 30)
    _TriggerServerEvent('eBanking:transfer', to, amountt)
    Wait(10)
    _TriggerServerEvent("eBanking:solde", action)
end

function GetBankingTransac()
    BankingTransac = {}   
    ESX.TriggerServerCallback("eBanking:GetHistorique", function(result) 
        for k,v in pairs(result) do   
            table.insert(BankingTransac, {
                name = v.type.."~s~ de "..v.Montant.."$ - Le : "..v.time.."", 
            })
        end   
    end)  
end

function OpenMyInformations()

    local main = RageUI.CreateMenu('', 'Los Santos Banking')
    local sub = RageUI.CreateSubMenu(main, '', 'Los Santos Banking')
        RageUI.Visible(main, not RageUI.Visible(main))
            while main do
            Citizen.Wait(0)
            RageUI.IsVisible(main, true, true, true, function()
            RageUI.Info("↓ ~g~Informations Bancaire ~s~↓", {"", "Propriétaire du Compte : ~b~"..GetPlayerName(PlayerId()).."~s~", "","Etat du compte : ~g~Actif"}, {"", "", "","" })
            RageUI.Line()
            RageUI.Separator('~g~Bienvenue '..GetPlayerName(PlayerId()))
            RageUI.Separator("Votre RIB : ~g~"..GetPlayerServerId(NetworkGetEntityOwner(GetPlayerPed(-1))).."~s~")
            RageUI.Separator("Solde du compte : ~g~"..PlayerMoney.."$~s~")
            RageUI.Line()

            RageUI.ButtonWithStyle("Déposer de l'argent", nil,  {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                if Selected then 
                    DepotArgent()
                end
            end)
            RageUI.ButtonWithStyle("Retirer de l'argent", nil,  {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                if Selected then 
                    RetraitArgent()
                end
            end)
            RageUI.ButtonWithStyle("Effectuer un virement", nil, {RightLabel = "→→"},true, function(Hovered, Active, Selected)
                if (Selected) then
                    TransferArgent()
                end
            end)

            RageUI.ButtonWithStyle("Historique de vos transactions", nil, {RightLabel = "→→"},true, function(Hovered, Active, Selected)
            end, sub)

            RageUI.Line()

            end, function() end)

            RageUI.IsVisible(sub, true, true, true, function()

                RageUI.Line()
                for k,v in pairs(BankingTransac) do 
                    RageUI.ButtonWithStyle(v.name, nil, {RightLabel = ""},true, function(Hovered, Active, Selected)
                    end, sub)
                end
                RageUI.Line()

            end, function() end)

            if not RageUI.Visible(main) and not RageUI.Visible(sub) then
            main = RMenu:DeleteType(main, true)
        end
    end
end

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        local plyCoords = GetEntityCoords(PlayerPedId(), false)

        for k in pairs(Config.Banque) do

            local Distance_Bank = Vdist2(plyCoords.x, plyCoords.y, plyCoords.z, Config.Banque[k].x, Config.Banque[k].y, Config.Banque[k].z)

            if Distance_Bank <= 15 then
                Timer = 0
                DrawMarker(22, Config.Banque[k].x, Config.Banque[k].y, Config.Banque[k].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 41, 190, 223, 55555, false, true, 2, false, false, false, false)
            end

            if Distance_Bank <= 1.5 then
                Timer = 0
                ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour parler avec le banquier")
                if IsControlJustPressed(1,38) then
                    cartebleu(function(cb)
                        if cb then
                            StartAnimation('mp_common', 'givetake2_a', 2500)
                            Wait(2500)
                            _TriggerServerEvent("eBanking:solde", action)
                            GetBankingTransac()
                            OpenMyInformations()
                        else
                            ShowNotification("[~r~Erreur~s~]\n~r~Vous n'avez pas de carte bancaire ! ", 2500)
                        end
                    end)
				end
            end
            
        end

        for k in pairs(Config.ATM) do

            local Distance_ATM = Vdist2(plyCoords.x, plyCoords.y, plyCoords.z, Config.ATM[k].x, Config.ATM[k].y, Config.ATM[k].z)

            if Distance_ATM <= 1.5 then
                Timer = 0
                ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour insérer votre carte bleu dans l'ATM")
                if IsControlJustPressed(1,38) then
                    cartebleu(function(cb)
                        if cb then
                            StartAnimation('mp_common', 'givetake2_a', 2500)
                            Wait(2500)
                            _TriggerServerEvent("eBanking:solde", action)
                            GetBankingTransac()
                            OpenMyInformations()
                        else
                            ShowNotification("[~r~Erreur~s~]\n~r~Vous n'avez pas de carte bancaire ! ", 2500)
                        end
                    end)
				end
            end

        end

        for k,v in pairs(Config.ShopForCard) do

            local Distance_AchatCarte = Vdist2(plyCoords.x, plyCoords.y, plyCoords.z, v.pos)

            if Distance_AchatCarte <= 15 then
                Timer = 0
                DrawMarker(22, v.pos, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 255, 0, 255, 55555, false, true, 2, false, false, false, false)
            end

            if Distance_AchatCarte <= 1.5 then
                Timer = 0
                ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour acheter une carte bancaire (~g~50$~s~)")
                if IsControlJustPressed(1,38) then
                    cartebleu(function(cb)
                        if cb then
                            ShowNotification("[~r~Erreur~s~]\n~r~Vous avez déjà une carte bancaire ! ", 2500)
                        else
                            _TriggerServerEvent("eBanking:GiveCard", "cartebanque", 50)
                        end
                    end)
                end
            end

        end

        Citizen.Wait(Timer)
    end
end)