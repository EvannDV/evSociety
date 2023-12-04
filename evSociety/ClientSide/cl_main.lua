ESX = nil

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

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
    ESX.PlayerData.job2 = job2
end)

print(Config.CommandOpen)

RegisterCommand(Config.CommandOpen,function()
    if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.EntrepriseName then
        OpenF6Menu()
    end

end)

--Keys.Register("F7", 'blanchisseur', 'Open menu', function()
    --if ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'blanchisseur' then
        --OpenF6Menu()
    --end
--end)

RegisterKeyMapping(Config.CommandOpen, 'Open', 'keyboard', 'F6')



TriggerServerEvent('ev:letsstarted')



-- Menu --


function OpenF6Menu()
    local F6ev = RageUI.CreateMenu(Config.EntrepriseName, "intéractions")

    RageUI.Visible(F6ev, not RageUI.Visible(F6ev))

    while F6ev do
        
        Citizen.Wait(0)

        RageUI.IsVisible(F6ev,true,true,true,function()


                RageUI.Separator("↓     Intéractions     ↓")
                
                RageUI.ButtonWithStyle("~r~Facture",nil, {RightLabel = "→→"}, not cooldown, function(Hovered,Active,Selected)
                    local player, distance = ESX.Game.GetClosestPlayer()
                    if Selected then
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
                                            TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), Config.SocietyName, (Config.EntrepriseName), montant)
                                            TriggerEvent('esx:showAdvancedNotification', 'Fl~g~ee~s~ca ~g~Bank', 'Facture envoyée : ', 'Vous avez envoyé une facture d\'un montant de : ~g~'..montant.. '$ ~s~pour cette raison : ~b~' ..raison.. '', 'CHAR_BANK_FLEECA', 9)
                                        else
                                            RageUI.Popup({message = "~r~Probleme~s~: Aucuns joueurs proche"})
                                        end
                                    end
                                end
                            end
                        end
                        cooldown = true
                        Citizen.SetTimeout(5000,function()
                          cooldown = false
                        end)
                      end
                  end)

                  RageUI.Separator("↓ ~y~ Annonces~s~  ↓")

                  RageUI.ButtonWithStyle("Annonce ~g~Disponible", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                      TriggerServerEvent("evJob:AnnonceOuverture")
                      RageUI.CloseAll()    
                    end
                end)

                RageUI.ButtonWithStyle("Annonce ~g~Indisponible", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                      TriggerServerEvent("evJob:AnnonceFermeture")
                      RageUI.CloseAll()    
                    end
                end)

                  


             
            


        
        end, function()
        end)

        if not RageUI.Visible(F6ev) then
            F6ev=RMenu:DeleteType("F6ev", true)
        end

    end

end




