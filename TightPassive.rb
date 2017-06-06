require_relative "Style"

class TightPassive < Style

	def playWithStyle(odds,bankroll,num_players)
		#todo
		#puts "tightpassive"
		#puts odds
		#puts (1.0/num_players)
		if(odds <= (1.0/num_players)) #if odds are less than 1/num_players then fold
			return "fold"
		elsif(bankroll/5 < 1)	#if 1/5 of bankroll is less than 1 return 1 instead
			return 1
		else 
			return bankroll/5 #bet 1/5 of total bankroll as playing tight
		end
	end
	
	
end