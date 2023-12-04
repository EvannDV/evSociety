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




function OpenCoffreBl()
    local coffreBl = RageUI.CreateMenu("Coffre", "intéractions")

    RageUI.Visible(coffreBl, not RageUI.Visible(coffreBl))

    while coffreBl do
        
        Citizen.Wait(0)

        RageUI.IsVisible(coffreBl,true,true,true,function()
			FreezeEntityPosition(GetPlayerPed(-1), true)

            RageUI.Separator("↓     Stockage     ↓")
        
            RageUI.ButtonWithStyle("~g~Deposer",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if Selected then    
                    OpenDeposerEvSheriffJob()
                    RageUI.CloseAll()
                end
            end)  

            

            RageUI.ButtonWithStyle("~r~Prendre",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    OpenPrendreEvSheriffJob()
                    RageUI.CloseAll()   
                end
            end)  

        
        end, function()
        end)

        if not RageUI.Visible(coffreBl) then
            coffreBl=RMenu:DeleteType("coffreBl", true)
			FreezeEntityPosition(GetPlayerPed(-1), false)
        end

    end

end



Citizen.CreateThread(function()
    while true do
		local wait = 750
			if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.EntrepriseName then
				for k in pairs {Config.Coffre2} do
				local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
				local pos = Config.Coffre2
				local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

				if dist <= 6 then
					wait = 0
					DrawMarker(6, Config.CoffreX,Config.CoffreY,Config.CoffreZ-0.99, 0.0, 0.0, 0.0, -90, 0.0, 0.0, 0.7, 0.7, 0.7, 255, 255, 255, 170, 0, 1, 2, 0, nil, nil, 0)   
				end

				if dist <= 1.0 then
					wait = 0
					
					AddTextEntry("HELP", "Appuyez sur ~INPUT_CONTEXT~ ~s~pour ouvrir le Coffre")
                    DisplayHelpTextThisFrame("HELP", false)
					if IsControlJustPressed(1,51) then
						OpenCoffreBl()
					end
				end
			end
		end
    Citizen.Wait(wait)
    end
end)

-- fonction --
function OpenPrendreEvSheriffJob()
	ESX.TriggerServerCallback('evblanchisseur:prendreitem', function(items)
		local elements = {}

		for i=1, #items, 1 do
            table.insert(elements, {
                label = 'x' .. items[i].count .. ' ' .. items[i].label,
                value = items[i].name
            })
        end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
            css      = 'LTD',
			title    = 'stockage',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
                css      = 'LTD',
				title = 'quantité'
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if not count then
					ESX.ShowNotification('quantité invalide')
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('evblanchisseur:prendreitems', itemName, count)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenDeposerEvSheriffJob()
	ESX.TriggerServerCallback('evblanchisseur:inventairejoueur', function(inventory)
		local elements = {}

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type = 'item_standard',
					value = item.name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
            css      = 'police',
			title    = 'inventaire',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
                css      = 'police',
				title = 'quantité'
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if not count then
					ESX.ShowNotification('quantité invalide')
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('evblanchisseur:stockitem', itemName, count)

					Citizen.Wait(300)
					OpenDeposerEvJob()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end