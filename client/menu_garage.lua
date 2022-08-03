local ESX = nil

Citizen.CreateThread(function()
    TriggerEvent('esx:getSharedObject', function(lib) ESX = lib end)
    while ESX == nil do Citizen.Wait(100) end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)


Citizen.CreateThread(function()
    while true do
        local Timer = 500
        local plyPos = GetEntityCoords(PlayerPedId())
        local dist = #(plyPos-Config.DeleteVeh)
		if IsPedSittingInAnyVehicle(PlayerPedId()) then
        if ESX.PlayerData.job and ESX.PlayerData.job.name == "banquier" then
			if dist <= Config.Marker.DrawDistance then
			Timer = 0
			DrawMarker(Config.Marker.Type, Config.DeleteVeh, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, Config.Marker.Color.H)
			end
			if dist <= Config.Marker.DrawInteract then
				Timer = 0
					RageUI.Text({ message = "Appuyez sur  ~g~[E]~s~ pour ranger votre véhicule", time_display = 1 })
				if IsControlJustPressed(1,51) then
					local veh,dist4 = ESX.Game.GetClosestVehicle(playerCoords)
						if dist4 < 5 then
							DeleteEntity(veh)
							ShowNotification("~g~Véhicule ranger avec succès")
						end 
            		end
         		end
        	end
		end
    	Citizen.Wait(Timer)
 	end
end)

function SpawnCar(car)
    local car = GetHashKey(car)
    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(0)
    end
    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local vehicle = CreateVehicle(car, Config.SpawnVeh, Config.SpawnHeading, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1)
end

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        local plyPos = GetEntityCoords(PlayerPedId())
        local dist = #(plyPos-Config.Garage)
        if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.JobName then
				if dist <= Config.Marker.DrawDistance then
				Timer = 0
				DrawMarker(Config.Marker.Type, Config.Garage, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, Config.Marker.Color.H)
				end
				if dist <= Config.Marker.DrawInteract then
					Timer = 0
					RageUI.Text({ message = "Appuyez sur ~g~[E]~s~ pour ouvrir →→ ~g~Garage", time_display = 1 })
					if IsControlJustPressed(1,51) then
						OpenGarageBanquier()
					end
				end
			end
		Citizen.Wait(Timer)
	end
end)

function OpenGarageBanquier()
	local garage_main = RageUI.CreateMenu("", "Garage")

	RageUI.Visible(garage_main, not RageUI.Visible(garage_main))
		while garage_main do
		Citizen.Wait(0)
		RageUI.IsVisible(garage_main, true, true, true, function()

        RageUI.Line()
		RageUI.Separator("↓ Véhicule(s) disponible ↓")
        RageUI.Line()

		for k,v in pairs(Config.ListVeh) do
				RageUI.ButtonWithStyle(v.nom, nil, {RightLabel = "→"}, not cooldown, function(Hovered, Active, Selected)
				if (Selected) then
					Citizen.Wait(1)  
					SpawnCar(v.model)
					RageUI.CloseAll()
				end
			end)
		end 

        RageUI.Line()

		end, function() 
		end)
		if not RageUI.Visible(garage_main) then
			garage_main = RMenu:DeleteType(garage_main, true)
		end
	end
end