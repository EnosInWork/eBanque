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

local function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    blockinput = true
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Wait(0)
    end 
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end

function CoffreBanquier()
    local main_coffre_Banquier = RageUI.CreateMenu("", "Coffre")

        RageUI.Visible(main_coffre_Banquier, not RageUI.Visible(main_coffre_Banquier))
            while main_coffre_Banquier do
            Citizen.Wait(0)
            RageUI.IsVisible(main_coffre_Banquier, true, true, true, function()

                RageUI.Separator("↓ ~b~Objet(s)~s~ ↓")

                    RageUI.ButtonWithStyle("Retirer Objet(s)",nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            RetraitCoffreBendeur()
                            RageUI.CloseAll()
                        end
                    end)
                    
                    RageUI.ButtonWithStyle("Déposer Objet(s)",nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            DepotCoffreBanquier()
                            RageUI.CloseAll()
                        end
                    end)

					RageUI.Separator("↓ ~b~Arme(s)~s~ ↓")


                    RageUI.ButtonWithStyle("Prendre Arme(s)",nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            CoffreRetraitBanquier()
                            RageUI.CloseAll()
                        end
                    end)

                    
                    RageUI.ButtonWithStyle("Déposer Arme(s)",nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            CoffreDepotWeaponBanquier()
                            RageUI.CloseAll()
                        end
                    end)

                end, function()
                end)

            if not RageUI.Visible(main_coffre_Banquier) then
            main_coffre_Banquier = RMenu:DeleteType("Coffre", true)
        end
    end
end

---------------------------------------------------------------------------------------------------------------------------------------

itemstock = {}
function RetraitCoffreBendeur()
    local Stockpolice = RageUI.CreateMenu("", "Coffre")

    ESX.TriggerServerCallback('eBanking:GetStock', function(items) 
    itemstock = items
   
    RageUI.Visible(Stockpolice, not RageUI.Visible(Stockpolice))
        while Stockpolice do
            Citizen.Wait(0)
                RageUI.IsVisible(Stockpolice, true, true, true, function()
                        for k,v in pairs(itemstock) do 
                            if v.count > 0 then
                            RageUI.ButtonWithStyle(v.label, nil, {RightLabel = v.count}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local count = KeyboardInput("Combien ?", "", 2)
                                    TriggerServerEvent('eBanking:GetStockI', v.name, tonumber(count))
                                    RetraitCoffreBendeur()
                                end
                            end)
                        end
                    end
                end, function()
                end)
            if not RageUI.Visible(Stockpolice) then
            Stockpolice = RMenu:DeleteType("Coffre", true)
        end
    end
     end)
end

local PlayersItem = {}
function DepotCoffreBanquier()
    local StockPlayer = RageUI.CreateMenu("", "Coffre")

    ESX.TriggerServerCallback('eBanking:getPlayerInventory', function(inventory)
        RageUI.Visible(StockPlayer, not RageUI.Visible(StockPlayer))
    while StockPlayer do
        Citizen.Wait(0)
            RageUI.IsVisible(StockPlayer, true, true, true, function()
                for i=1, #inventory.items, 1 do
                    if inventory ~= nil then
                         local item = inventory.items[i]
                            if item.count > 0 then
                                        RageUI.ButtonWithStyle(item.label, nil, {RightLabel = item.count}, true, function(Hovered, Active, Selected)
                                            if Selected then
                                            local count = KeyboardInput("Combien ?", '' , 8)
                                            TriggerServerEvent('eBanking:putStockItems', item.name, tonumber(count))
                                            DepotCoffreBanquier()
                                        end
                                    end)
                                end
                            else
                                RageUI.Separator('Chargement en cours')
                            end
                        end
                    end, function()
                    end)
                if not RageUI.Visible(StockPlayer) then
                StockPlayer = RMenu:DeleteType("Coffre", true)
            end
        end
    end)
end


Weaponstock = {}
function CoffreRetraitBanquier()
    local StockCoffreWeapon = RageUI.CreateMenu("", 'Coffre')
    ESX.TriggerServerCallback('eBanking:getArmoryWeapons', function(weapons)
    Weaponstock = weapons
    RageUI.Visible(StockCoffreWeapon, not RageUI.Visible(StockCoffreWeapon))
        while StockCoffreWeapon do
            Citizen.Wait(0)
                RageUI.IsVisible(StockCoffreWeapon, true, true, true, function()
                        for k,v in pairs(Weaponstock) do 
                            if v.count > 0 then
                            RageUI.ButtonWithStyle("~r~→~s~ "..ESX.GetWeaponLabel(v.name), nil, {RightLabel = v.count}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    ESX.TriggerServerCallback('eBanking:removeArmoryWeapon', function()
                                        CoffreRetraitBanquier()
                                    end, v.name)
                                end
                            end)
                        end
                    end
                end, function()
                end)
            if not RageUI.Visible(StockCoffreWeapon) then
            StockCoffreWeapon = RMenu:DeleteType("Coffre", true)
        end
    end
    end)
end

function CoffreDepotWeaponBanquier()
    local StockPlayerWeapon = RageUI.CreateMenu("", "Coffre")
        RageUI.Visible(StockPlayerWeapon, not RageUI.Visible(StockPlayerWeapon))
    while StockPlayerWeapon do
        Citizen.Wait(0)
            RageUI.IsVisible(StockPlayerWeapon, true, true, true, function()
                
                local weaponList = ESX.GetWeaponList()

                for i=1, #weaponList, 1 do
                    local weaponHash = GetHashKey(weaponList[i].name)
                    if HasPedGotWeapon(PlayerPedId(), weaponHash, false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
                    RageUI.ButtonWithStyle("~r~→~s~ "..weaponList[i].label, nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                        ESX.TriggerServerCallback('eBanking:ddArmoryWeapon', function()
                            CoffreDepotWeaponBanquier()
                        end, weaponList[i].name, true)
                    end
                end)
            end
            end
            end, function()
            end)
            if not RageUI.Visible(StockPlayerWeapon) then
            StockPlayerWeapon = RMenu:DeleteType("Coffre", true)
        end
    end
end

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        local plyPos = GetEntityCoords(PlayerPedId())
        local dist = #(plyPos-Config.Coffre)
        if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.JobName then
				if dist <= Config.Marker.DrawDistance then
				Timer = 0
				DrawMarker(Config.Marker.Type, Config.Coffre, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, Config.Marker.Color.H)
				end
				if dist <= Config.Marker.DrawInteract then
					Timer = 0
                    RageUI.Text({ message = "Appuyez sur ~g~[E]~s~ pour ouvrir →→ ~g~Coffre", time_display = 1 })
					if IsControlJustPressed(1,51) then
						CoffreBanquier()
					end
				end
			end
		Citizen.Wait(Timer)
	end
end)