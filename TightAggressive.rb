require_relative "Style"

class TightAggressive < Style

	def playWithStyle(odds,bankroll,num_players)
		#todo
		#puts "tightaggressive"
		if(bankroll/5 < 1)	#if 1/5 of bankroll is less than 1 return 1 instead
			return 1
		else
			return bankroll/5  #play 1/5 of total bankroll because tight style
		end
	end
	
	
end