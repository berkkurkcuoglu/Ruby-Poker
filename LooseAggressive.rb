require_relative "Style"

class LooseAggressive < Style

	def playWithStyle(odds,bankroll,num_players) #loose aggresive play style always plays 1/10 of his total balance
		#todo
		#puts "looseaggressive"
		if(bankroll/10 < 1)	#if 1/10 of bankroll is less than 1 return 1 instead
			return 1
		else
			return bankroll/10
		end
	end
	
	
end