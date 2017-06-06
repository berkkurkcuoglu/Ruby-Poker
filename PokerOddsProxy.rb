require_relative "APIProxy"
require_relative "Hand"

class PokerOddsProxy < APIProxy	

	def createObject		#gets odds and hand from api result and creates, returns poker hand
		@poker_hand = Hand.new(@object['cards'][0..3])		#gets first 2 cards from api result as they are forming the winning hand
		@poker_hand.odds = @object['odds']
		return @poker_hand
	end
	
	def makeURL(cards,num_players,board)	#create url using cards,players num and board cards
		@url = "http://stevenamoore.me/projects/holdemapi?cards=#{cards}&board=#{board}&num_players=#{num_players}"
		#puts(@url)
	end
	
	def winURL(cards,board)		#create url for determining the winner,gets all cards and cards on board
		@url = "http://stevenamoore.me/projects/holdemapi?cards=#{cards}&board=#{board}"
		puts "Determining winner..."
		#puts(@url)
	end
end

