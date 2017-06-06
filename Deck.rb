require_relative "Card"

class Deck

	include Enumerable
	
	def initialize		#class holding cards
		@cards = []
	end
	
	def each(&block)	#define each for deck to loop in main as a part of enumarable module
		@cards.each(&block)
	end
	
	def addCard(card)	#add cards to the deck
		@cards << card
	end
	
	def pop()			#pop a card from deck
		@cards.pop
	end	
	
	def autoFill()  #generate a new deck with 52 cards
		@cards = []
		suits = ['d','c','s','h']
		values = ['2','3','4','5','6','7','8','9','T','J','Q','K','A']
		#generate all 52 cards
		suits.each do |suit|
			values.each do |value|
				addCard(Card.new(suit,value))
			end
		end
	end
	
	def shuffle()		#shuffle the deck
		@cards.shuffle!
	end
	
end