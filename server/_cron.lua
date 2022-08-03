function CalculateLivretASavings(d, h, m)
	if d == Config.SavingsDay then
		local asyncTasks = {}
		print(os.date ("%c") .. "CRON DEBUT : Calcul des intérêts")
		MySQL.Async.fetchAll('SELECT bank_savings.id, bank_savings.tot, bank_savings.rate FROM bank_savings WHERE bank_savings.status = "Ouvert" ORDER BY bank_savings.id ASC',
		{}, function(result)
			for i=1, #result, 1 do
				if  result[i].rate ~= 0 and result[i].tot ~= 0 and (result[i].tot <= 1000000 or result[i].tot >= 1500000) then
					local montant = result[i].tot + math.floor(math.floor(result[i].tot * result[i].rate) / 100)
					if Config.SavingsAccountRemove then
						TriggerEvent('esx_addonaccount:getSharedAccount', 'society_banker', function(account)
							account.removeMoney(montant)
						end)
					end
					MySQL.Sync.execute('UPDATE bank_savings SET bank_savings.tot = @montant WHERE bank_savings.id = @identifiant', 
					{
						['@montant']   = montant,
						['@identifiant']   = result[i].id
					})
				end
			end
		end)
		print(os.date ("%c") .. "CRON FINISH : Calcul des intérêts")
	end
end
TriggerEvent('cron:runAt', Config.CRONSavingsTime[1], Config.CRONSavingsTime[2], CalculateLivretASavings)



function RemoveDeadlineDay(d, h, m)
	print(os.date ("%c") .. "CRON DEBUT: Décompte d'un jour entre échéances pour chaque dossier de prêt ouvert")
	MySQL.Async.fetchAll('SELECT bank_lent_money.id, bank_lent_money.timeLeft FROM bank_lent_money WHERE bank_lent_money.status = "Ouvert" and bank_lent_money.timeLeft > "0" and bank_lent_money.remainDeadlines > "0" ORDER BY bank_lent_money.id ASC',
	{}, function(result)
		for i=1, #result, 1 do
			MySQL.Sync.execute('UPDATE bank_lent_money SET bank_lent_money.timeLeft = @tempsrestant WHERE bank_lent_money.id = @identifiant', 
			{
				['@tempsrestant']   = result[i].timeLeft - 1,
				['@identifiant']   = result[i].id
			})
		end
	end)
	print(os.date ("%c") .. "CRON TERMINE: Décompte d'un jour entre échéances pour chaque dossier de prêt ouvert")
end
TriggerEvent('cron:runAt', Config.CRONLoanDeadlineTime[1], Config.CRONLoanDeadlineTime[2], RemoveDeadlineDay)


function CheckPretExpire(d, h, m)
	print(os.date ("%c") .. "CRON DEBUT: Paiement des échéances pour les dossiers arrivés à date")
	MySQL.Async.fetchAll('SELECT bank_lent_money.id, bank_lent_money.clientID, bank_lent_money.amount, bank_lent_money.amountNextDeadline, bank_lent_money.alreadyPaid, bank_lent_money.remainDeadlines, bank_lent_money.timeBeforeDeadline, bank_lent_money.deadlines FROM bank_lent_money WHERE bank_lent_money.status = "Ouvert" AND bank_lent_money.timeLeft = "0" AND bank_lent_money.remainDeadlines > "0"',
	{}, function(result) 
		for i=1, #result, 1 do
			MySQL.Async.fetchAll('SELECT users.bank FROM users WHERE users.identifier = @clientID', 
			{['@clientID'] = result[i].clientID}, function(bankmoney) 
				local playerbank = bankmoney[1].bank 
				if result[i].remainDeadlines > 1 then
					--User can pay
					if playerbank > result[i].amountNextDeadline then
						MySQL.Async.execute('UPDATE bank_lent_money SET bank_lent_money.remainDeadlines = @remainingDeadlines, bank_lent_money.alreadyPaid = @alreadyPaid, bank_lent_money.timeLeft = @timeLeft WHERE bank_lent_money.id = @identifiant', 
						{
							['@identifiant']   			= result[i].id,
							['@remainingDeadlines']   	= result[i].remainDeadlines - 1,
							['@alreadyPaid']   			= result[i].alreadyPaid + result[i].amountNextDeadline,
							['@timeLeft']   			= result[i].timeBeforeDeadline	
						})
						MySQL.Async.execute('UPDATE users SET users.bank = @amount WHERE users.identifier = @clientID', 
						{
							['@amount']   				= playerbank - result[i].amountNextDeadline,
							['@clientID']   				= result[i].clientID	
						})
						TriggerEvent('esx_addonaccount:getSharedAccount', 'society_banker', function(account)
								account.addMoney(result[i].amountNextDeadline)
						end)
					-- User cannot pay	
					else
						MySQL.Async.execute('UPDATE bank_lent_money SET bank_lent_money.status = @status WHERE bank_lent_money.id = @identifiant', 
						{
							['@identifiant']   			= result[i].id,
							['@status']					= "Gel - Impayé le " .. os.date ("%c")
						})
					end
				else
					--User can pay
					if playerbank > result[i].amountNextDeadline then
						MySQL.Async.execute('UPDATE bank_lent_money SET bank_lent_money.remainDeadlines = 0, bank_lent_money.alreadyPaid = @alreadyPaid, bank_lent_money.timeLeft = 0, bank_lent_money.status = "Clos" WHERE bank_lent_money.id = @identifiant', 
						{
							['@identifiant']   			= result[i].id,
							['@alreadyPaid']   			= result[i].alreadyPaid + result[i].amountNextDeadline
						})
						MySQL.Async.execute('UPDATE users SET users.bank = @amount WHERE users.identifier = @clientID', 
						{
							['@amount']   				= playerbank - result[i].amountNextDeadline,
							['@clientID']   				= result[i].clientID	
						})
						TriggerEvent('esx_addonaccount:getSharedAccount', 'society_banker', function(account)
							account.addMoney(result[i].amountNextDeadline)
						end)
					-- User cannot pay	
					else
						MySQL.Async.execute('UPDATE bank_lent_money SET bank_lent_money.status = @status WHERE bank_lent_money.id = @identifiant', 
						{
							['@identifiant']   			= result[i].id,
							['@status']					= "Gel - Impayé le " .. os.date ("%c")
						})
					end
				end
			end)
		end
	end)
	print(os.date ("%c") .. "CRON TERMINE: Paiement des échéances pour les dossiers arrivés à date")
end
TriggerEvent('cron:runAt', Config.CRONLoanTime[1], Config.CRONLoanTime[2], CheckPretExpire)

