require_relative "Style"

class LoosePassive < Style

	def playWithStyle(odds,bankroll,num_players)
		#todo
		#puts "loosepassive"
		#puts odds
		#puts (1.0/num_players)
		if(odds <= (1.0/num_players))		#if odds are less than 1/num_players then fold
			return "fold"
		elsif(bankroll/10 < 1)			#if 1/10 of bankroll is less than 1 return 1 instead
			return 1
		else 
			return bankroll/10			#bet 1/10 of total bankroll
		end
	end
	
	
end