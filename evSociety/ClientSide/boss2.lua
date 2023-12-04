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









function OpenMenuBossEvJob()

    local menuBossSheriff = RageUI.CreateMenu(Config.EntrepriseName,"boss")

    RageUI.Visible(menuBossSheriff, not RageUI.Visible(menuBossSheriff))

    while menuBossSheriff do
        
        Citizen.Wait(0)

        RageUI.IsVisible(menuBossSheriff,true,true,true,function()
            FreezeEntityPosition(GetPlayerPed(-1), true)


            RageUI.Separator("↓ ~r~  Argent total de la sociétée ~s~↓")
            RefreshemsMoney()

            if societytestmoney ~= nil then
                RageUI.ButtonWithStyle("Argent de societé :", nil, {RightLabel = "~b~$" .. societytestmoney}, true, function()
                end)
            end


            RageUI.Separator("↓     ~y~Gestion de l'entreprise     ~s~↓")
        
            
            RageUI.ButtonWithStyle("Actions Patron", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    aboss()
                    RageUI.CloseAll()    
                end
            end)

        
        end, function()
        end)

        if not RageUI.Visible(menuBossSheriff) then
            menuBossSheriff=RMenu:DeleteType("Delete", true)
            FreezeEntityPosition(GetPlayerPed(-1), false)
        end

    end

end














function aboss()
    TriggerEvent('esx_society:openBossMenu', Config.EntrepriseName, function(data, menu)
        menu.close()
    end, {wash = false})
end

Citizen.CreateThread(function()
    while true do
        local wait = 750
        if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.EntrepriseName and ESX.PlayerData.job.grade_name == 'boss' then
            for k in pairs {Config.CoffreBoss2} do
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local pos = Config.CoffreBoss2
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

                if dist <= 6 then
                    wait = 0
                    DrawMarker(6, Config.CoffreBossX,Config.CoffreBossY,Config.CoffreBossZ-0.99, 0.0, 0.0, 0.0, -90, 0.0, 0.0, 0.7, 0.7, 0.7, 255, 255, 255, 170, 0, 1, 2, 0, nil, nil, 0)  
                    if dist <= 1.0 then
                        wait = 0


                        AddTextEntry("HELP", "Appuyez sur ~INPUT_CONTEXT~ ~s~pour accéder aux actions patrons")
                        DisplayHelpTextThisFrame("HELP", false)
                        if IsControlJustPressed(1,51) then
                            OpenMenuBossEvJob()
                        end
                    end
                end
            end
        end
    Wait(wait)
    end
end)

-------------Kaito :) thx

function RefreshemsMoney()
    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
        ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
            Updatesocietytestmoney(money)
        end, ESX.PlayerData.job.name)
    end
end

function Updatesocietytestmoney(money)
    societytestmoney = ESX.Math.GroupDigits(money)
end

