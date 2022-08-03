ESX = nil

TriggerEvent(Config.Shared, function(obj) ESX = obj end)

function eLogsDiscord(message,url)
    local DiscordWebHook = url
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({username = Config.logs.NameLogs, content = message}), { ['Content-Type'] = 'application/json' })
end

local Token = math.random(999, 9999).."-BANQUE-"..math.random(999, 9999).."-FIVEDEV-"..math.random(999, 9999)

RegisterServerEvent('eBanking:RequestToken')
AddEventHandler('eBanking:RequestToken', function()
	local source = source
    TriggerClientEvent('eBanking:OnRequestToken', source, Token)
end)

ESX.RegisterServerCallback('eBanking:GetItemCard', function(source, cb, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local items = xPlayer.getInventoryItem(item)
    if items == nil then
        cb(0)
    else
        cb(items.count)
    end
end)

RegisterServerEvent('eBanking:GiveCard')
AddEventHandler('eBanking:GiveCard', function(tk, item, price)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if (Token ~= tk) then
		DropPlayer(xPlayer.source, "Cheat")
		return
	end
    xPlayer.addInventoryItem(item, 1)
    xPlayer.removeMoney(price)
	eLogsDiscord("[Achat-Carte-Bancaire] "..xPlayer.getName().." a payé "..price.."$ pour acheter sa carte de banque", Config.logs.GiveCard)	
    TriggerClientEvent('esx:showAdvancedNotification', source, "~g~Banque", "Création de carte", "~g~Merci de votre achat\n~s~Vous pouvez désormais accéder à votre compte en banque", "CHAR_BANK", 10)
end)

RegisterServerEvent("eBanking:deposer")
AddEventHandler("eBanking:deposer", function(tk, money)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local total = money
    local xMoney = xPlayer.getMoney()
	if (Token ~= tk) then
		DropPlayer(xPlayer.source, "Cheat")
		return
	end
    if xMoney >= total then
        xPlayer.addAccountMoney('bank', total)
        xPlayer.removeMoney(total)
		eLogsDiscord("[Dépot-Bancaire] "..xPlayer.getName().." a déposer "..total.."$ dans sont compte en banque", Config.logs.DepotBank)	
        TriggerClientEvent('esx:showAdvancedNotification', source, 'Banque', '~g~Banque', "Vous avez deposé ~g~"..total.."$~s~ à la banque !", 'CHAR_BANK', 10)
    else
        TriggerClientEvent('esx:showNotification', source, "Vous n'avez pas assez ~r~d\'argent~s~ !")
    end    
end) 

RegisterServerEvent("eBanking:retirer")
AddEventHandler("eBanking:retirer", function(tk, money)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local total = money
    local xMoney = xPlayer.getAccount('bank').money
	if (Token ~= tk) then
		DropPlayer(xPlayer.source, "Cheat")
		return
	end
    if xMoney >= total then
        xPlayer.removeAccountMoney('bank', total)
        xPlayer.addMoney(total)
		eLogsDiscord("[Retrait-Bancaire] "..xPlayer.getName().." a retirer "..total.."$ de sont compte en banque", Config.logs.RetraitBank)	
        TriggerClientEvent('esx:showAdvancedNotification', source, 'Banque', '~g~Banque', "Vous avez retiré ~g~"..total.."$~s~ de la banque !", 'CHAR_BANK', 10)
    else
        TriggerClientEvent('esx:showNotification', source, "Vous n'avez pas assez ~r~d\'argent~s~ !")
    end    
end)


RegisterServerEvent("eBanking:solde") 
AddEventHandler("eBanking:solde", function(tk, action, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerMoney = xPlayer.getAccount('bank').money
	if (Token ~= tk) then
		DropPlayer(xPlayer.source, "Cheat")
		return
	end
    TriggerClientEvent("solde:argent", source, playerMoney)
end)


RegisterServerEvent('eBanking:transfer')
AddEventHandler('eBanking:transfer', function(tk, to, amountt)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local zPlayer = ESX.GetPlayerFromId(to)
	local balance = 0
	if (Token ~= tk) then
		DropPlayer(xPlayer.source, "Cheat")
		return
	end
	if(zPlayer == nil or zPlayer == -1) then
		TriggerClientEvent('esx:showAdvancedNotification', _source, "Problème", '~g~Banque', "Ce destinataire n'existe pas.", 'CHAR_BANK', 10)
	else
		balance = xPlayer.getAccount('bank').money
		zbalance = zPlayer.getAccount('bank').money
		
		if tonumber(_source) == tonumber(to) then
			TriggerClientEvent('esx:showAdvancedNotification', _source, "Problème", '~g~Banque', "Vous ne pouvez pas transférer d'argent à vous-même.", 'CHAR_BANK', 10)
		else
			if balance <= 0 or balance < tonumber(amountt) or tonumber(amountt) <= 0 then
				TriggerClientEvent('esx:showAdvancedNotification', _source, '~g~Banque', "Problème", "Vous n'avez pas assez d'argent en banque.", 'CHAR_BANK', 10)
			else
				xPlayer.removeAccountMoney('bank', tonumber(amountt))
				zPlayer.addAccountMoney('bank', tonumber(amountt))
				eLogsDiscord("[Transfert-Bancaire] "..xPlayer.getName().." a transferer "..amountt.."$ à "..zPlayer.getName(), Config.logs.TransferBank)	
                TriggerClientEvent('esx:showAdvancedNotification', _source, "Succès", '~g~Banque', "Transfert réussi vous avez envoyé "..tonumber(amountt).." $ à "..zPlayer.getName(), 'CHAR_BANK', 10)
                TriggerClientEvent('esx:showAdvancedNotification', to, "Banque", '~g~Banque', "Vous avez recu "..tonumber(amountt).." $ de la part de "..xPlayer.getName(), 'CHAR_BANK', 10)
			end
		end
	end
end)

RegisterServerEvent('eBanking:Annonce')
AddEventHandler('eBanking:Annonce', function(tk, open, close, pause, dispolivre, nodispolivre)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	if (Token ~= tk) then
		DropPlayer(xPlayer.source, "Cheat")
		return
	end
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if open then
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], '~g~Banque', 'Information', 'La banque est désormais ~g~OUVERTE~s~', 'CHAR_BANK', 8)
		elseif close then
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], '~g~Banque', 'Information', 'La banque est désormais ~r~FERMER~s~', 'CHAR_BANK', 8)
		elseif pause then
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], '~g~Banque', 'Information', 'La banque est désormais en ~o~PAUSE~s~', 'CHAR_BANK', 8)
		end
	end
end)

RegisterCommand('banquier', function(source, args, rawCommand)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.job.name == Config.JobName then
        local src = source
        local msg = rawCommand:sub(9)
        local args = msg
        if player ~= false then
            local name = GetPlayerName(source)
            local xPlayers	= ESX.GetPlayers()
            for i=1, #xPlayers, 1 do
                local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
                TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], '~g~Banque', 'Informations', ''..msg..'', 'CHAR_BANK', 0)
            end
        else
        TriggerClientEvent('esx:showAdvancedNotification', _source, 'Avertisement', 'Erreur' , '~r~Tu n\'est pas banquier pour faire cette commande', 'CHAR_BANK', 0)
        end
    else
        TriggerClientEvent('esx:showAdvancedNotification', _source, 'Avertisement', 'Erreur' , '~r~Tu n\'est pas banquier pour faire cette commande', 'CHAR_BANK', 0)
    end
end, false)

ESX.RegisterServerCallback('eBanking:GetHistorique', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll('SELECT Montant, time, id, type FROM banking_historique WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result) 
		cb(result)
	end)  
end) 


RegisterNetEvent('eBanking:PutHistorique')
AddEventHandler('eBanking:PutHistorique', function(tk, playerId, type, Montant, time)   
	local xPlayer = ESX.GetPlayerFromId(source)  
	if (Token ~= tk) then
		DropPlayer(xPlayer.source, "Cheat")
		return
	end
    local timeShift = 1 * 60 * 60   
		MySQL.Async.execute('INSERT INTO banking_historique (identifier, type, Montant, time) VALUES (@identifier, @type, @Montant, @time)', { 
        ['@identifier'] = xPlayer.identifier,                             
        ['@type'] = type,   
        ['@Montant'] = Montant, 
        ['@time'] = os.date('%d-%m-%Y %H:%M:%S', os.time() + timeShift),
    }, function(rowsChanged)            
    end)   
end)

ESX.RegisterServerCallback('eBanking:getLoanAccounts', function (source, cb)
	local customers = {}
	MySQL.Async.fetchAll('SELECT bank_lent_money.id, bank_lent_money.firstname, bank_lent_money.lastname, bank_lent_money.amount, bank_lent_money.rate, bank_lent_money.remainDeadlines, bank_lent_money.deadlines, bank_lent_money.amountNextDeadline, bank_lent_money.alreadyPaid, bank_lent_money.timeLeft, bank_lent_money.timeBeforeDeadline, bank_lent_money.advisorFirstname, bank_lent_money.advisorLastname, bank_lent_money.status FROM bank_lent_money ORDER BY id ASC',
	{}, function(result)
		local customers = {}
		for i=1, #result, 1 do
			table.insert(customers, {
				identifier = result[i].id,
				firstname = result[i].firstname,
				lastname = result[i].lastname,
				amount = result[i].amount,
				taux = result[i].rate,
				nbEcheances = result[i].remainDeadlines,
				echeancesTot = result[i].deadlines,
				montProchEcheance = result[i].amountNextDeadline,
				montDernEcheance = result[i].alreadyPaid,
				timeleft = result[i].timeLeft,
				timeEcheance = result[i].timeBeforeDeadline,
				giverfirstname = result[i].advisorFirstname,
				giverlastname = result[i].advisorLastname,
				status = result[i].status
			})
		end
		cb(customers)
	end)
end)

RegisterServerEvent('eBanking:makeLoan')
AddEventHandler('eBanking:makeLoan', function (tk, playerId, montant, taux, nbEche, jours)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(playerId)
	local montant2 = montant
	local montant = montant + math.floor((montant * taux) / 100) 
	local taux = taux
	local nbEche = nbEche
	local jours = jours
	local premEche = math.floor(montant/nbEche)
	if (Token ~= tk) then
		DropPlayer(xPlayer.source, "Cheat")
		return
	end
	TriggerEvent('esx_addonaccount:getSharedAccount', Config.SocietyName, function(account)
		if account.money >= montant then
			account.removeMoney(montant)
			xPlayer.addMoney(montant)
			MySQL.Async.execute('INSERT INTO bank_lent_money(bank_lent_money.firstname, bank_lent_money.lastname, bank_lent_money.amount, bank_lent_money.rate, bank_lent_money.remainDeadlines, bank_lent_money.deadlines, bank_lent_money.amountNextDeadline, bank_lent_money.alreadyPaid, bank_lent_money.timeLeft, bank_lent_money.timeBeforeDeadline, bank_lent_money.clientID, bank_lent_money.advisorFirstname, bank_lent_money.advisorLastname, bank_lent_money.status) VALUES((SELECT users.firstname FROM `users` WHERE users.identifier = @playGiven), (SELECT users.lastname FROM `users` WHERE users.identifier = @playGiven), @mont, @taux, @nbEche, @nbEche, @premEche, "0", @jours, @jours, @playGiven, (SELECT users.firstname FROM `users` WHERE users.identifier = @playGiver), (SELECT users.lastname FROM `users` WHERE users.identifier = @playGiver), "Ouvert");', 
			{
				['@mont']   = montant,
				['@taux'] = taux,
				['@nbEche'] = nbEche,
				['@jours'] = jours,
				['@premEche'] = premEche,
				['@playGiven']   = xPlayer.identifier,
				['@playGiver']   = xPlayer.identifier
			},
			function ()
			end)
			TriggerClientEvent('esx:showNotification', xPlayer.source, "Prêt d'une somme de " .. montant2 .. "$ alloué à " .. xPlayer.name)
			eLogsDiscord("[Credit-Bancaire] "..xPlayer.getName().." a fait un crédit de "..montant2.."$ à "..xPlayer.name, Config.logs.CreditBank)	
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, "La banque n'a pas assez d'argent.")
		end	
	end)
end)

RegisterServerEvent('eBanking:closeLoan')
AddEventHandler('eBanking:closeLoan', function (tk, numDoss)
	local xPlayer = ESX.GetPlayerFromId(source)
	local statut = "Clos"
	if (Token ~= tk) then
		DropPlayer(xPlayer.source, "Cheat")
		return
	end
	MySQL.Async.execute('CREATE TABLE new_table LIKE bank_lent_money; INSERT INTO new_table SELECT * FROM bank_lent_money WHERE bank_lent_money.id = @id; UPDATE bank_lent_money SET bank_lent_money.remainDeadlines = "0", bank_lent_money.amountNextDeadline = "0", bank_lent_money.alreadyPaid = (SELECT new_table.amount FROM new_table WHERE new_table.id = @id), bank_lent_money.timeLeft = "0", bank_lent_money.status = @stat WHERE bank_lent_money.id = @id; DROP TABLE new_table;', 
		{
			['@id'] = numDoss,
			['@stat']   = statut
		},
		function ()
	end)
	TriggerClientEvent('esx:showNotification', xPlayer.source, "~g~Vous avez bien clos le dossier")
	eLogsDiscord("[Credit-Bancaire] "..xPlayer.getName().." a clos un crédit, dossier : "..numDoss, Config.logs.CreditBank)	
end)

RegisterServerEvent('eBanking:DeleteLoan')
AddEventHandler('eBanking:DeleteLoan', function (tk, numDoss)
	local xPlayer = ESX.GetPlayerFromId(source)
	local statut = "Clos"
	if (Token ~= tk) then
		DropPlayer(xPlayer.source, "Cheat")
		return
	end
	MySQL.Async.execute('DELETE FROM bank_lent_money WHERE id = @id', 
		{['@id'] = numDoss},
		function()
	end)
	TriggerClientEvent('esx:showNotification', xPlayer.source, "~g~Vous avez bien supprimer le dossier")
	eLogsDiscord("[Credit-Bancaire] "..xPlayer.getName().." a supprimer un crédit, dossier : "..numDoss, Config.logs.CreditBank)	
end)

RegisterServerEvent('eBanking:reopenLoan')
AddEventHandler('eBanking:reopenLoan', function (tk, numDoss)
	local xPlayer = ESX.GetPlayerFromId(source)
	local statut = "Ouvert"
	if (Token ~= tk) then
		DropPlayer(xPlayer.source, "Cheat")
		return
	end
	MySQL.Async.execute('UPDATE bank_lent_money SET bank_lent_money.status = @stat WHERE bank_lent_money.id = @mont', 
	{
		['@mont']   = numDoss,
		['@stat']   = statut
	},
	function ()
	end)
	TriggerClientEvent('esx:showNotification', xPlayer.source, "~g~Vous avez bien re ouvert le dossier")
	eLogsDiscord("[Credit-Bancaire] "..xPlayer.getName().." a re ouvert un crédit, dossier : "..numDoss, Config.logs.CreditBank)	
end)

RegisterServerEvent('eBanking:avEche')
AddEventHandler('eBanking:avEche', function (tk, numDoss)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (Token ~= tk) then
		DropPlayer(xPlayer.source, "Cheat")
		return
	end
	MySQL.Async.execute('CREATE TABLE new_table LIKE bank_lent_money; INSERT INTO new_table SELECT * FROM bank_lent_money WHERE bank_lent_money.id = @id; UPDATE bank_lent_money SET bank_lent_money.remainDeadlines = ((SELECT new_table.remainDeadlines FROM new_table WHERE new_table.id = @id) - 1), bank_lent_money.timeLeft = (SELECT new_table.timeBeforeDeadline FROM new_table WHERE new_table.id = @id), bank_lent_money.alreadyPaid = (SELECT SUM(new_table.alreadyPaid + new_table.amountNextDeadline) FROM new_table WHERE new_table.id = @id), bank_lent_money.status = "Ouvert" WHERE bank_lent_money.id = @id; DROP TABLE new_table;', 
	{
		['@id']   = numDoss
	},
	function ()
	end)
	TriggerClientEvent('esx:showNotification', xPlayer.source, "~g~L'échéance a bien été avancée d'une fois !")
	eLogsDiscord("[Credit-Bancaire] "..xPlayer.getName().." a avancer l'échéance crédit de 1x, dossier : "..numDoss, Config.logs.CreditBank)	
end)

RegisterServerEvent('eBanking:freezeLoan')
AddEventHandler('eBanking:freezeLoan', function (tk, numDoss)
	local xPlayer = ESX.GetPlayerFromId(source)
	local statut = "Gel"
	if (Token ~= tk) then
		DropPlayer(xPlayer.source, "Cheat")
		return
	end
	MySQL.Async.execute('UPDATE bank_lent_money SET bank_lent_money.status = @stat WHERE bank_lent_money.id = @mont', 
	{
		['@mont']   = numDoss,
		['@stat']   = statut
	},
	function ()
	end)
	TriggerClientEvent('esx:showNotification', xPlayer.source, "~g~Vous avez bien gelé le dossier")
	eLogsDiscord("[Credit-Bancaire] "..xPlayer.getName().." a geler le dossier : "..numDoss, Config.logs.CreditBank)	
end)

---------- lIVRET

ESX.RegisterServerCallback('eBanking:getSavingsAccounts', function (source, cb)
	local customers = {}
	MySQL.Async.fetchAll('SELECT bank_savings.id, bank_savings.firstname, bank_savings.lastname, bank_savings.tot, bank_savings.rate, bank_savings.advisorFirstname, bank_savings.advisorLastname FROM bank_savings WHERE bank_savings.status = "Ouvert" ORDER BY id ASC',
	{}, function(result)
		local customers = {}
		for i=1, #result, 1 do
			table.insert(customers, {
				identifier = result[i].id,
				firstname = result[i].firstname,
				lastname = result[i].lastname,
				tot = result[i].tot,
				taux = result[i].rate,
				giverfirstname = result[i].advisorFirstname,
				giverlastname = result[i].advisorLastname
			})
		end
		cb(customers)
	end)
end)

RegisterServerEvent('eBanking:openSavingsAccount')
AddEventHandler('eBanking:openSavingsAccount', function (tk, montant, taux, nom, prenom)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (Token ~= tk) then
		DropPlayer(xPlayer.source, "Cheat")
		return
	end
	if xPlayer.getMoney() >= montant then
		xPlayer.removeMoney(montant)
		MySQL.Async.execute('INSERT INTO bank_savings(bank_savings.firstname, bank_savings.lastname, bank_savings.tot, bank_savings.rate, bank_savings.advisorFirstname, bank_savings.advisorLastname, bank_savings.status) VALUES(@prenom, @nom, @mont, @taux, (SELECT users.firstname FROM `users` WHERE users.identifier = @playGiver), (SELECT users.lastname FROM `users` WHERE users.identifier = @playGiver), "Ouvert");', 
		{
			['@mont']   = montant,
			['@taux'] = taux,
			['@nom']   = nom,
			['@prenom'] = prenom,
			['@playGiver']   = xPlayer.identifier
		},
		function ()
		end)
		TriggerClientEvent('esx:showNotification', xPlayer.source, "Livret ouvert pour " .. prenom .. " " .. nom .. ", montant déposé : " .. montant .. " $")
		eLogsDiscord("[Livret-Bancaire] "..xPlayer.getName().." a ouvert un livret pour " .. prenom .. " " .. nom .. ", montant déposé : " .. montant .. " $", Config.logs.LivretBank)	
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous n'avez pas assez d'argent pour ouvrir le livret")
	end	
end)

RegisterServerEvent('eBanking:depositMoneySavingsAccount')
AddEventHandler('eBanking:depositMoneySavingsAccount', function (tk, livretID, montant)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (Token ~= tk) then
		DropPlayer(xPlayer.source, "Cheat")
		return
	end
	MySQL.Async.fetchScalar('SELECT COUNT(*) FROM bank_savings WHERE bank_savings.id = @livretID and bank_savings.status = "Ouvert"', 
	{
		['@livretID']   = livretID
	}, function(compte)
		if compte > 0 then
			if xPlayer.getMoney() >= montant then
				xPlayer.removeMoney(montant)
				MySQL.Async.fetchScalar('SELECT bank_savings.tot FROM bank_savings WHERE bank_savings.id = @livretID', 
				{
					['@livretID']   = livretID
				}, function(result)
					montajout = math.floor(result + montant)
					MySQL.Async.execute('UPDATE bank_savings set bank_savings.tot = @mont WHERE bank_savings.id = @livretID', 
					{
						['@mont']   = montajout,
						['@livretID'] = livretID
					},
					function ()
					end)
					TriggerClientEvent('esx:showNotification', xPlayer.source, "La somme de " .. montant .. "$ a été ajoutée au livret, montant total : " .. montajout .. " $")
					eLogsDiscord("[Livret-Bancaire] "..xPlayer.getName().." a ajouté "..montant.." au livret  montant total : " .. montajout .. " $", Config.logs.LivretBank)	
				end)
			else
				TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous n'avez pas assez d'argent")
			end
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Le dossier n'existe pas ou est clos !")
		end
	end)
end)

RegisterServerEvent('eBanking:changeSavingsAccountRate')
AddEventHandler('eBanking:changeSavingsAccountRate', function (tk, livretID, taux)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (Token ~= tk) then
		DropPlayer(xPlayer.source, "Cheat")
		return
	end
	MySQL.Async.fetchScalar('SELECT COUNT(*) FROM bank_savings WHERE bank_savings.id = @livretID and bank_savings.status = "Ouvert"', 
		{
			['@livretID']   = livretID
		}, function(compte)
			if compte > 0 then
				MySQL.Async.execute('UPDATE bank_savings set bank_savings.rate = @taux WHERE bank_savings.id = @livretID', 
					{
						['@livretID'] = livretID,
						['@taux'] = taux
					},
				function ()
				end)
				TriggerClientEvent('esx:showNotification', xPlayer.source, "Le taux du Livret a été modifié à : " .. taux .. " %")
				eLogsDiscord("[Livret-Bancaire] "..xPlayer.getName().." a modifier le taux du livret à "..taux.." %", Config.logs.LivretBank)	
			else
				TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Le dossier n'existe pas ou est clos !")
			end
	end)
end)

RegisterServerEvent('eBanking:withdrawSavings')
AddEventHandler('eBanking:withdrawSavings', function (tk, livretID, montant)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (Token ~= tk) then
		DropPlayer(xPlayer.source, "Cheat")
		return
	end
	MySQL.Async.fetchScalar('SELECT COUNT(*) FROM bank_savings WHERE bank_savings.id = @livretID and bank_savings.status = "Ouvert"', 
		{
			['@livretID']   = livretID
		}, function(compte)
			if compte > 0 then
				MySQL.Async.fetchScalar('SELECT bank_savings.tot FROM bank_savings WHERE bank_savings.id = @livretID ', 
				{
					['@livretID']   = livretID

			}, function(result)
					if result >= montant then
						montretire = math.floor(result - montant)
						MySQL.Async.execute('UPDATE bank_savings set bank_savings.tot = @mont WHERE bank_savings.id = @livretID', 
						{
							['@mont']   = montretire,
							['@livretID'] = livretID
						},
						function ()
						end)
						xPlayer.addMoney(montant)
						TriggerClientEvent('esx:showNotification', xPlayer.source, "La somme de " .. montant .. "$ a été retirée du livret, montant total restant : " .. montretire .. " $")
						eLogsDiscord("[Livret-Bancaire] "..xPlayer.getName().." a retirer du livret " .. montant .. "$, montant total restant : " .. montretire .. " $", Config.logs.LivretBank)	

					else
						TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous n'avez pas assez d'argent")
					end
				end)
			else
				TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Le dossier n'existe pas ou est clos !")
			end
	end)
end)

RegisterServerEvent('eBanking:closeSavingsAccount')
AddEventHandler('eBanking:closeSavingsAccount', function (tk, livretID)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (Token ~= tk) then
		DropPlayer(xPlayer.source, "Cheat")
		return
	end
	MySQL.Async.fetchScalar('SELECT COUNT(*) FROM bank_savings WHERE bank_savings.id = @livretID and bank_savings.status = "Ouvert"', 
		{
			['@livretID']   = livretID
		}, function(compte)
			if compte > 0 then
				MySQL.Async.fetchScalar('SELECT bank_savings.tot FROM bank_savings WHERE bank_savings.id = @livretID', 
				{
					['@livretID']   = livretID
				}, function(result)
					MySQL.Async.execute('UPDATE bank_savings set bank_savings.status = "Clos", bank_savings.tot = "0" WHERE bank_savings.id = @livretID', 
					{
						['@livretID'] = livretID
					},
					function ()
					end)
					xPlayer.addMoney(result)
					TriggerClientEvent('esx:showNotification', xPlayer.source, "La somme de " .. result .. "$ a été retirée du livret, dossier CLOS")
					eLogsDiscord("[Livret-Bancaire] "..xPlayer.getName().." a supprimer un livret", Config.logs.LivretBank)	
				end)
			else
				TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Le dossier n'existe pas ou est clos !")
			end
	end)
end)

ESX.RegisterServerCallback('eBanking:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb({items = items})
end)

ESX.RegisterServerCallback('eBanking:GetStock', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', Config.SocietyName, function(inventory)
		cb(inventory.items)
	end)
end)


RegisterNetEvent('eBanking:GetStockI')
AddEventHandler('eBanking:GetStockI', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerEvent('esx_addoninventory:getSharedInventory', Config.SocietyName, function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and inventoryItem.count >= count then
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', _source, 'Objet retirer', count, inventoryItem.label)
				eLogsDiscord("[Coffre-Banquier] "..xPlayer.getName().." a retiré "..count.." "..inventoryItem.label.." du coffre banquier", Config.logs.Coffre)
		else
            TriggerClientEvent('esx:showNotification', xPlayer.source, "[~r~Problème~s~]\nQuantité invalide")
		end
	end)
end)

RegisterNetEvent('eBanking:putStockItems')
AddEventHandler('eBanking:putStockItems', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', Config.SocietyName, function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- does the player have enough of the item?
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showNotification', _source, "Objet déposer "..count.." "..inventoryItem.label.."")
			eLogsDiscord("[Coffre-Banquier] "..xPlayer.getName().." a déposé "..count.." "..inventoryItem.label.." dans le coffre banquier", Config.logs.Coffre)
		else
            TriggerClientEvent('esx:showNotification', xPlayer.source, "[~r~Problème~s~]\nQuantité invalide")
		end
	end)
end)

ESX.RegisterServerCallback('eBanking:getArmoryWeapons', function(source, cb)
	TriggerEvent('esx_datastore:getSharedDataStore', Config.SocietyName, function(store)
		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end
		cb(weapons)
	end)
end)

ESX.RegisterServerCallback('eBanking:ddArmoryWeapon', function(source, cb, weaponName, removeWeapon)
	local xPlayer = ESX.GetPlayerFromId(source)

	if removeWeapon then
		xPlayer.removeWeapon(weaponName)
		eLogsDiscord("[Coffre-Banquier] "..xPlayer.getName().." a déposé "..weaponName.." du coffre banquier", Config.logs.Coffre)
	end

	TriggerEvent('esx_datastore:getSharedDataStore', Config.SocietyName, function(store)
		local weapons = store.get('weapons') or {}
		local foundWeapon = false

		for i=1, #weapons, 1 do
			if weapons[i].name == weaponName then
				weapons[i].count = weapons[i].count + 1
				foundWeapon = true
				break
			end
		end

		if not foundWeapon then
			table.insert(weapons, {
				name  = weaponName,
				count = 1
			})
		end

		store.set('weapons', weapons)
		cb()
	end)
end)

ESX.RegisterServerCallback('eBanking:removeArmoryWeapon', function(source, cb, weaponName)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addWeapon(weaponName, 0)
	eLogsDiscord("[Coffre-Banquier] "..xPlayer.getName().." a retiré "..weaponName.." du coffre banquier", Config.logs.Coffre)

	TriggerEvent('esx_datastore:getSharedDataStore', Config.SocietyName, function(store)
		local weapons = store.get('weapons') or {}

		local foundWeapon = false

		for i=1, #weapons, 1 do
			if weapons[i].name == weaponName then
				weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
				foundWeapon = true
				break
			end
		end

		if not foundWeapon then
			table.insert(weapons, {
				name = weaponName,
				count = 0
			})
		end

		store.set('weapons', weapons)
		cb()
	end)
end)

RegisterServerEvent('eBanking:recruter')
AddEventHandler('eBanking:recruter', function(target)

  local xPlayer = ESX.GetPlayerFromId(source)
  local xTarget = ESX.GetPlayerFromId(target)

  
  if job2 == false then
  	if xPlayer.job.grade_name == 'boss' then
  	xTarget.setJob(Config.OrgaName, 0)
  	TriggerClientEvent('esx:showNotification', xPlayer.source, "~g~Le joueur a bien été recruté")
  	TriggerClientEvent('esx:showNotification', target, "<C>Bienvenue!")
	  eLogsDiscord("[Actions-Patron] **"..xPlayer.getName().."** a recruté **"..xTarget.getName().."**", Config.logs.Boss)
  	else
        TriggerClientEvent('esx:showNotification', xPlayer.source, "[~r~Problème~s~]\nVous n'êtes pas patron")
end
  else
  	if xPlayer.job2.grade_name == 'boss' then
  	xTarget.setJob2(Config.OrgaName, 0)
  	TriggerClientEvent('esx:showNotification', xPlayer.source, "~g~Le joueur a bien été recruté")
      TriggerClientEvent('esx:showNotification', target, "<C>Bienvenue!")
	  eLogsDiscord("[Actions-Patron] **"..xPlayer.getName().."** a recruté **"..xTarget.getName().."**", Config.logs.Boss)
  	else
        TriggerClientEvent('esx:showNotification', xPlayer.source, "[~r~Problème~s~]\nVous n'êtes pas patron")
end
  end
end)

RegisterServerEvent('eBanking:promouvoir')
AddEventHandler('eBanking:promouvoir', function(target)

  local xPlayer = ESX.GetPlayerFromId(source)
  local xTarget = ESX.GetPlayerFromId(target)

  
  if job2 == false then
  	if xPlayer.job.grade_name == 'boss' and xPlayer.job.name == xTarget.job.name then
  	xTarget.setJob(Config.OrgaName, tonumber(xTarget.job.grade) + 1)
  	TriggerClientEvent('esx:showNotification', xPlayer.source, "~g~Le joueur a bien été promu")
  	TriggerClientEvent('esx:showNotification', target, "~g~Vous avez été promu!")
	  eLogsDiscord("[Actions-Patron] **"..xPlayer.getName().."** a promu **"..xTarget.getName().."**", Config.logs.Boss)
  	else
        TriggerClientEvent('esx:showNotification', xPlayer.source, "[~r~Problème~s~]\nVous n'êtes pas patron ou le joueur ne peux être promu")
end
  else
  	if xPlayer.job2.grade_name == 'boss' and xPlayer.job2.name == xTarget.job2.name then
  	xTarget.setJob2(Config.OrgaName, tonumber(xTarget.job2.grade) + 1)
  	TriggerClientEvent('esx:showNotification', xPlayer.source, "~g~Le joueur a bien été promu")
  	TriggerClientEvent('esx:showNotification', target, "~g~Vous avez été promu!")
	  eLogsDiscord("[Actions-Patron] **"..xPlayer.getName().."** a promu **"..xTarget.getName().."**", Config.logs.Boss)
  	else
        TriggerClientEvent('esx:showNotification', xPlayer.source, "[~r~Problème~s~]\nVous n'êtes pas patron ou le joueur ne peux être promu")
end
  end
end)

RegisterServerEvent('eBanking:descendre')
AddEventHandler('eBanking:descendre', function(target)

  local xPlayer = ESX.GetPlayerFromId(source)
  local xTarget = ESX.GetPlayerFromId(target)

  
  if job2 == false then
  	if xPlayer.job.grade_name == 'boss' and xPlayer.job.name == xTarget.job.name then
  	xTarget.setJob(Config.OrgaName, tonumber(xTarget.job.grade) - 1)
  	TriggerClientEvent('esx:showNotification', xPlayer.source, "~o~Le joueur a bien été rétrograder")
  	TriggerClientEvent('esx:showNotification', target, "~o~Vous avez été rétrogradé!")
	  eLogsDiscord("[Actions-Patron] **"..xPlayer.getName().."** a rétrogradé **"..xTarget.getName().."**", Config.logs.Boss)
  	else
        TriggerClientEvent('esx:showNotification', xPlayer.source, "[~r~Problème~s~]\nVous n'êtes pas patron ou le joueur ne peux être descendu plus")
end
  else
  	if xPlayer.job2.grade_name == 'boss' and xPlayer.job2.name == xTarget.job2.name then
  	xTarget.setJob2(Config.OrgaName, tonumber(xTarget.job2.grade) - 1)
  	TriggerClientEvent('esx:showNotification', xPlayer.source, "~o~Le joueur a bien été rétrograder")
  	TriggerClientEvent('esx:showNotification', target, "~o~Vous avez été rétrogradé!")
	  eLogsDiscord("[Actions-Patron] **"..xPlayer.getName().."** a rétrogradé **"..xTarget.getName().."**", Config.logs.Boss)
  	else
        TriggerClientEvent('esx:showNotification', xPlayer.source, "[~r~Problème~s~]\nVous n'êtes pas patron ou le joueur ne peux être descendu plus")
    end
  end
end)

RegisterServerEvent('eBanking:virer')
AddEventHandler('eBanking:virer', function(target)
  local xPlayer = ESX.GetPlayerFromId(source)
  local xTarget = ESX.GetPlayerFromId(target)
  
  if job2 == false then
        if xPlayer.job.grade_name == 'boss' and xPlayer.job.name == xTarget.job.name then
            xTarget.setJob("unemployed", 0)
            TriggerClientEvent('esx:showNotification', xPlayer.source, "~o~Le joueur a bien été destituer")
            TriggerClientEvent('esx:showNotification', target, "Vous avez été viré!")
            eLogsDiscord("[Actions-Patron] **"..xPlayer.getName().."** a viré **"..xTarget.getName().."**", Config.logs.Boss)
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, "[~r~Problème~s~]\nVous n'êtes pas patron ou le joueur ne peux être destituer")
        end
    else
        if xPlayer.job2.grade_name == 'boss' and xPlayer.job2.name == xTarget.job2.name then
            xTarget.setJob2("unemployed2", 0)
            TriggerClientEvent('esx:showNotification', xPlayer.source, "~o~Le joueur a bien été destituer")
            TriggerClientEvent('esx:showNotification', target, "Vous avez été viré!")
            eLogsDiscord("[Actions-Patron] **"..xPlayer.getName().."** a viré **"..xTarget.getName().."**", Config.logs.Boss)
  	    else
	        TriggerClientEvent('esx:showNotification', xPlayer.source, "[~r~Problème~s~]\nVous n'êtes pas patron ou le joueur ne peux être destituer")
        end
    end
end)

RegisterServerEvent("eBanking:retraitentreprise")
AddEventHandler("eBanking:retraitentreprise", function(money)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local total = money
	local xMoney = xPlayer.getAccount("bank").money

    TriggerEvent('esx_addonaccount:getSharedAccount', Config.SocietyName, function (account)
		if account.money >= total then
			account.removeMoney(total)
			xPlayer.addAccountMoney('bank', total)
			TriggerClientEvent('esx:showAdvancedNotification', source, '~g~Banque', 'Information', "~g~Vous avez retiré "..total.." $", 'CHAR_BANK', 8)
            eLogsDiscord("[Actions-Patron] **"..xPlayer.getName().."** a retirer **"..total.."** de l'entreprise", Config.logs.Boss)
		else
            TriggerClientEvent('esx:showNotification', source, "[~r~Problème~s~]\nVous n'avez pas assez d'argent dans votre entreprise")
		end
	end)
end) 
  
RegisterServerEvent("eBanking:depotentreprise")
AddEventHandler("eBanking:depotentreprise", function(money)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local total = money
    local xMoney = xPlayer.getMoney()
    
    TriggerEvent('esx_addonaccount:getSharedAccount', Config.SocietyName, function (account)
        if xMoney >= total then
            account.addMoney(total)
            xPlayer.removeAccountMoney('bank', total)
			TriggerClientEvent('esx:showAdvancedNotification', source, '~g~Banque', 'Information', "~g~Vous avez déposé "..total.." $", 'CHAR_BANK', 8)
            eLogsDiscord("[Actions-Patron] **"..xPlayer.getName().."** a déposer **"..total.."** de l'entreprise", Config.logs.Boss)
        else
            TriggerClientEvent('esx:showNotification', source, "[~r~Problème~s~]\nVous n'avez pas assez d'argent")
        end
    end)   
end)

ESX.RegisterServerCallback('eBanking:getSocietyMoney', function(source, cb, societyName)
	if societyName ~= nil then
	  local society = Config.SocietyName
	  TriggerEvent('esx_addonaccount:getSharedAccount', Config.SocietyName, function(account)
		cb(account.money)
	  end)
	else
	  cb(0)
	end
end)