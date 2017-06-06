require_relative "Player"

class Table

	attr_accessor :board,:players_folded,:bets,:high_bet
	include Enumerable
	
	def initialize		
		@board			#cards on board, initially none
		@players = []	#players at table
		@players_folded = []	#players folded in round
		@bets = []			#bets for the round
		@dealer 		#dealer
		@high_bet = 0	#highest bet for the round
	end
	
	def each(&block)		#each method to loop through table as a part of enumrable module
		@players.each(&block)
	end
	
	def addPlayer(player)		#add players to the table
		@players << player
		@players_folded << false
	end
	
	def setDealer(player)		#sets the dealer
		@dealer = player
	end

	def checkBets()		#checks everyones bets at the end of a round and forces everyone to reach highest bet
		@players.each_with_index do |player,index|
			if(@players_folded[index] != true)
				if (@bets[index] < @high_bet)
					if(@high_bet-@bets[index] > @players[index].bankroll)
						#@players_folded[index] = true
						puts "#{@players[index].name} all in."
					else
						@players[index].bankroll -= @high_bet-@bets[index]
						@bets[index] = @high_bet
						puts "#{@players[index].name} has raised his/her bet to #{high_bet}"
					end
				end
			end
		end
	end
	
	def checkEnd()		#checks if there are more than 2 players with a bankroll over 0 to be able to play the game
		count = 0
		@players.each_with_index do |player,index|
			if(player.bankroll > 0)
				count += 1
			else
				players_folded[index] = true
			end
		end
		
		return count < 2
	end
	
	def printBanks()		#prints every players balance
		puts "Player Bankrolls:"
		@players.each do |player|
			puts "#{player.name} has #{player.bankroll}"
		end
	end	
		
	
end