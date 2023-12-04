ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
TriggerEvent('esx_phone:registerNumber', Config.EntrepriseName, (Config.EntrepriseName), true, true)
TriggerEvent('esx_society:registerSociety', Config.EntrepriseName, Config.EntrepriseName, Config.SocietyName, Config.SocietyName, Config.SocietyName, {type = 'private'})

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)
















-------------Coffre


RegisterServerEvent('evblanchisseur:prendreitems')
AddEventHandler('evblanchisseur:prendreitems', function(itemName, count)
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', Config.SocietyName, function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		if count > 0 and inventoryItem.count >= count then

			if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', _src, "quantité invalide")
			else
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', _src, 'Objet retiré', count, inventoryItem.label)
			end
		else
			TriggerClientEvent('esx:showNotification', _src, "quantité invalide")
		end
	end)
end)


RegisterNetEvent('evblanchisseur:stockitem')
AddEventHandler('evblanchisseur:stockitem', function(itemName, count)
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', Config.SocietyName, function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- does the player have enough of the item?
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showNotification', _src, "Objet déposé "..count..""..inventoryItem.label.."")
		else
			TriggerClientEvent('esx:showNotification', _src, "quantité invalide")
		end
	end)
end)


ESX.RegisterServerCallback('evblanchisseur:inventairejoueur', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb({items = items})
end)

ESX.RegisterServerCallback('evblanchisseur:prendreitem', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', Config.SocietyName, function(inventory)
		cb(inventory.items)
	end)
end)






----------------Annonces


RegisterServerEvent('evJob:AnnonceOuverture')
AddEventHandler('evJob:AnnonceOuverture', function()
	local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], Config.EntrepriseName, '~g~En ville', 'Passer nous voir !', 'CHAR_ACTING_UP', 1)
    end
end)

RegisterServerEvent('evJob:AnnonceFermeture')
AddEventHandler('evJob:AnnonceFermeture', function()
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do 
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], Config.EntrepriseName, '~r~Indisponible', 'Nous fermons nos portes', 'CHAR_ACTING_UP', 1)
    end
end)




----------- Start dont touch :)





RegisterServerEvent("ev:letsstarted")
AddEventHandler("ev:letsstarted", function()
    local source = source
    local playerD = GetPlayerName(source)

	MySQL.Async.fetchAll("SELECT * FROM addon_account WHERE name = @name", {['name'] = Config.SocietyName }, function(result)
		if result[1] then
			print("[^2BDD^0] Ok 1")
		else
			MySQL.Async.execute('INSERT INTO addon_account (name, label, shared) VALUES (@name, @label, @shared)', {
				['@name']   = Config.SocietyName,
				['@label']   = Config.EntrepriseName,
				['@shared'] = 1
			}, function(rowsChange)
			end)
		end
	end)

	MySQL.Async.fetchAll("SELECT * FROM addon_inventory WHERE name = @name", {['name'] = Config.SocietyName }, function(result)
		if result[1] then
			print("[^2BDD^0] Ok 2")
		else
			MySQL.Async.execute('INSERT INTO addon_inventory (name, label, shared) VALUES (@name, @label, @shared)', {
				['@name']   = Config.SocietyName,
				['@label']   = Config.EntrepriseName,
				['@shared'] = 1
			}, function(rowsChange)
			end)
		end
	end)

	MySQL.Async.fetchAll("SELECT * FROM datastore WHERE name = @name", {['name'] = Config.SocietyName }, function(result)
		if result[1] then
			print("[^2BDD^0] Ok 3")
		else
			MySQL.Async.execute('INSERT INTO datastore (name, label, shared) VALUES (@name, @label, @shared)', {
				['@name']   = Config.SocietyName,
				['@label']   = Config.EntrepriseName,
				['@shared'] = 1
			}, function(rowsChange)
			end)
		end
	end)

	MySQL.Async.fetchAll("SELECT * FROM jobs WHERE name = @name", {['name'] = Config.EntrepriseName }, function(result)
		if result[1] then
			print("[^2BDD^0] Ok 4")
		else
			MySQL.Async.execute('INSERT INTO jobs (name, label) VALUES (@name, @label)', {
				['@name']   = Config.EntrepriseName,
				['@label']   = Config.EntrepriseName
			}, function(rowsChange)
			end)
		end
	end)

	MySQL.Async.fetchAll("SELECT * FROM job_grades WHERE job_name = @job_name", {['job_name'] = Config.EntrepriseName }, function(result)
		if result[1] then
			print("[^2BDD^0] Ok 5")
		else
			MySQL.Async.execute('INSERT INTO job_grades (job_name, grade, name, label, salary, skin_male, skin_female) VALUES (@job_name, @grade, @name, @label, @salary, @skin_male, @skin_female)', {
				['@job_name']   = Config.EntrepriseName,
				['@grade']   = 0,
				['@name'] = "recrue",
				['@label'] = "Recrue",
				['@salary'] = 12,
				['@skin_male'] = '{}',
				['@skin_female'] = '{}'
			}, function(rowsChange)
			end)
			MySQL.Async.execute('INSERT INTO job_grades (job_name, grade, name, label, salary, skin_male, skin_female) VALUES (@job_name, @grade, @name, @label, @salary, @skin_male, @skin_female)', {
				['@job_name']   = Config.EntrepriseName,
				['@grade']   = 1,
				['@name'] = "intermitant",
				['@label'] = "Intermitant",
				['@salary'] = 24,
				['@skin_male'] = '{}',
				['@skin_female'] = '{}'
			}, function(rowsChange)
			end)
		
			MySQL.Async.execute('INSERT INTO job_grades (job_name, grade, name, label, salary, skin_male, skin_female) VALUES (@job_name, @grade, @name, @label, @salary, @skin_male, @skin_female)', {
				['@job_name']   = Config.EntrepriseName,
				['@grade']   = 2,
				['@name'] = "co",
				['@label'] = "Chef Operation",
				['@salary'] = 48,
				['@skin_male'] = '{}',
				['@skin_female'] = '{}'
			}, function(rowsChange)
			end)
		
			MySQL.Async.execute('INSERT INTO job_grades (job_name, grade, name, label, salary, skin_male, skin_female) VALUES (@job_name, @grade, @name, @label, @salary, @skin_male, @skin_female)', {
				['@job_name']   = Config.EntrepriseName,
				['@grade']   = 3,
				['@name'] = "boss",
				['@label'] = "Patron",
				['@salary'] = 92,
				['@skin_male'] = '{}',
				['@skin_female'] = '{}'
			}, function(rowsChange)
			end)
		end
	end)



end)

