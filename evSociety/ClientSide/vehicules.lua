ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
     PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)  
	PlayerData.job = job  
	Citizen.Wait(5000) 
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then

		ESX.PlayerData = ESX.GetPlayerData()

    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)










-------------Menu




function GarageMenu()
    local vehEv = RageUI.CreateMenu("Vehicules", "intéractions")

    RageUI.Visible(vehEv, not RageUI.Visible(vehEv))

    while vehEv do
        
        Citizen.Wait(0)

        RageUI.IsVisible(vehEv,true,true,true,function()
			FreezeEntityPosition(GetPlayerPed(-1), true)

            RageUI.Separator("↓     ~r~Rangement~s~     ↓")


			RageUI.ButtonWithStyle("Ranger le véhcule", nil, {RightLabel = "→→"}, true,function(h,a,s)
                if s then
					local Vehicle = GetVehiclePedIsUsing(PlayerPedId())
					ESX.Game.DeleteVehicle(Vehicle)
                    

                end
        
            end)

			RageUI.Separator("↓     ~g~Voitures~s~     ↓")

            RageUI.ButtonWithStyle(Config.Vehicule1Label, nil, {RightLabel = "→→"}, true,function(h,a,s)
                if s then
					local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                    local model = GetHashKey(Config.Vehicule1Name)
                    RequestModel(model)
                    while not HasModelLoaded(model) do Citizen.Wait(10) end
                    local pos = GetEntityCoords(PlayerPedId())
                    local vehicle = CreateVehicle(model, plyCoords.x, plyCoords.y, plyCoords.z, 230.0, true, false)
                    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                    

                end
        
            end)


			RageUI.ButtonWithStyle(Config.Vehicule2Label, nil, {RightLabel = "→→"}, true,function(h,a,s)
                if s then
					local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                    local model = GetHashKey(Config.Vehicule2Name)
                    RequestModel(model)
                    while not HasModelLoaded(model) do Citizen.Wait(10) end
                    local pos = GetEntityCoords(PlayerPedId())
                    local vehicle = CreateVehicle(model, plyCoords.x, plyCoords.y, plyCoords.z, 230.0, true, false)
                    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                    

                end
        
            end)


			RageUI.ButtonWithStyle(Config.Vehicule3Label, nil, {RightLabel = "→→"}, true,function(h,a,s)
                if s then
					local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                    local model = GetHashKey(Config.Vehicule3Name)
                    RequestModel(model)
                    while not HasModelLoaded(model) do Citizen.Wait(10) end
                    local pos = GetEntityCoords(PlayerPedId())
                    local vehicle = CreateVehicle(model, plyCoords.x, plyCoords.y, plyCoords.z, 230.0, true, false)
                    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                    

                end
        
            end)
 

            



        
        end, function()
        end)

        if not RageUI.Visible(vehEv) then
            vehEv=RMenu:DeleteType("vehEv", true)
			FreezeEntityPosition(GetPlayerPed(-1), false)
        end

    end

end




Citizen.CreateThread(function()
    while true do
		local wait = 750
			if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.EntrepriseName then
				for k in pairs {Config.CoffreVeh2} do
				local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
				local pos = Config.CoffreVeh2
				local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

				if dist <= 6 then
					wait = 0
					DrawMarker(6, Config.CoffreVehX,Config.CoffreVehY,Config.CoffreVehZ-0.99, 0.0, 0.0, 0.0, -90, 0.0, 0.0, 0.7, 0.7, 0.7, 255, 255, 255, 170, 0, 1, 2, 0, nil, nil, 0)  
				end

				if dist <= 1.0 then
					wait = 0
					
					AddTextEntry("HELP", "Appuyez sur ~INPUT_CONTEXT~ ~s~accéder aux options")
                    DisplayHelpTextThisFrame("HELP", false)
					if IsControlJustPressed(1,51) then
						GarageMenu()
					end
				end
			end
		end
    Citizen.Wait(wait)
    end
end)