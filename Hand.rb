class Hand
	
	attr_accessor :odds
	
	def initialize(cards)	#holds cards
		@cards = cards
		@odds
	end
	
	def showHand		#returns cards
		return @cards
	end

end
