class Card

	attr_reader :value, :suit	
	
	def initialize #class for cards holding value and suit
		@suit
		@value
	end

	def initialize(suit,value)
		@suit = suit
		@value = value
	end
	
	def assignSuit(suit)
		@suit = suit
	end
	
	def assignValue(value)
		@value = value
	end	
	
	def show()		#return card as a string
		return "#{@value}#{@suit}"
	end
	
end
