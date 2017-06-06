class Player

	attr_reader :name,:play_style
	attr_accessor :hand,:bankroll,:folds,:wins,:loses,:total_games
	
	def initialize(name,play_style,bankroll) #player with name,hand,style and bankroll attributes
		@name = name
		@hand = hand
		@play_style = play_style
		@bankroll = bankroll		
	end	

	def changeHand(hand)	#change cards of players called each round while dealing
		@hand = hand
	end	
	
end