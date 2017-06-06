require_relative "Table"
require_relative "Deck"
require_relative "Player"
require_relative "Hand"
require_relative "PokerOddsProxy"
require_relative "UserDataProxy"
require_relative "Database"
require_relative "LooseAggressive"
require_relative "LoosePassive"
require_relative "TightAggressive"
require_relative "TightPassive"

def main 

	table = Table.new()	#create table
	deck = Deck.new()	#create empty deck
	deck.autoFill()		#fill deck with cards
	deck.shuffle()		#shuffle deck
	odds_proxy = PokerOddsProxy.new()	#create odds proxy
	user_proxy = UserDataProxy.new()	#create user data proxy
	database = Database.new()		#create database
	styles = []		#store style in an array and create on instance of each one
	styles << LooseAggressive.new()
	styles << LoosePassive.new()
	styles << TightAggressive.new()
	styles << TightPassive.new()	
	hands = ""		#string to collect all players hand at the end of each game to determine winner (folded ones not included)
	pot = 0		#value in pot initially 0
	
	puts "How many people should sit at the table?"		#get number of players
	num_players = gets().chomp().to_i()
	while(!(num_players >= 1) && !(num_players <= 8))
		puts("Please enter a number between 2 and 8.")
		num_players = gets().chomp().to_i()
	end
	
	puts("Please enter a starting chip amount:")	#get starting chip amount
	start_chips = gets().chomp().to_i()	
	
	puts("Please enter your name:")			#get name from user and create a new player with that name
	user_name = gets.chomp
	table.addPlayer(Player.new(user_name,nil,start_chips))	

	for num in 1...num_players		#create bot players using random user api proxy
		#create random player				
		user_proxy.makeRequest()
		table.addPlayer(user_proxy.createObject(styles[(num % 4)-1],start_chips))#choose style with mod of 4 to equally distribute playing styles		
		#table.addPlayer(Player.new(num,hand,styles[(num % 4)-1],100))
	end
	
	folds = Array.new(num_players,0)		#folds array to store num of folds
	wins = Array.new(num_players,0)			#wins array to store num of folds
	loses = Array.new(num_players,0)		#loses array to store num of loses
	total_games = Array.new(num_players,0)	#total_games array to store num of total_games
	
	table.each_with_index do |player,index|		#check database for user info get if there is one, else create user record in database 
		info = database.getInfo(player.name)
		if(info != nil)	#if info exists
			folds[index] = info[0]
			wins[index] = info[1]
			loses[index] = info[2]
			total_games[index] = info[3]
		else	#if no info exists
			database.save(player.name,folds[index],wins[index],loses[index])	
		end
	end
	
	while(!table.checkEnd) do		#while there are more than 2 players continue playing
		deck.autoFill()		#fill deck every game
		deck.shuffle()		#shuffle before starting
		table.board = "#{deck.pop.show}#{deck.pop.show}#{deck.pop.show}" #deal cards to board
		
		table.each do |p|		#deal cards to players
			hand = Hand.new("#{deck.pop.show}#{deck.pop.show}")
			p.changeHand(hand)	#change player hand
		end
		
		table.players_folded = Array.new(num_players,false) #set folded array to false
		table.checkEnd()	#if someone has 0 balance set their status to folded
		table.high_bet = 0	#set bet to 0 at the beginning
		
		while table.board.length <= 8 do	#while there are less than 4 cards on board
			puts "Board: #{table.board}"		#print vards on board
			table.each_with_index do |player,index|	#loop through players at table
				if(table.players_folded[index] != true)	#if not folded make a move
						if(index != 0)	#if it is not the user playing
							puts "#{player.name} playing..."					
							odds_proxy.makeURL(player.hand.showHand,num_players,table.board)
							odds_proxy.makeRequest
							player.hand = odds_proxy.createObject()	#get hand from api call
							move = player.play_style.playWithStyle(player.hand.odds,player.bankroll,num_players) #get move from style class returns either a bett amount or fold string
							if(move == "fold")	
								puts "#{player.name} folded"
								table.players_folded[index] = true	#set folded true for player
								folds[index] += 1		#increment fold amount
							elsif(player.bankroll < move)		#if player has not enough bankroll to raise bet check or allin
								puts "#{player.name} checks-(allin)"
							else		
								if(move <= table.high_bet)	#if move is less than high bet set move to high bet
									move = table.high_bet								
								else
									table.high_bet += move	#if move is greater set high bet to move
								end
								if((player.bankroll < move))		#if player does'nt have enough money fold
									puts "#{player.name} folded"
									table.players_folded[index] = true
									folds[index] += 1
								else
									puts "#{player.name} bet #{move}"		#bet 
									puts "High bet => #{table.high_bet}"
									pot += move
									table.bets[index] = move
									player.bankroll -= move									
								end
							end
							#puts player.hand.odds						
						else
							puts "Your hand: #{player.hand.showHand}  Your balance: #{player.bankroll}"
							puts "Would you like to bet, check or fold? B--> Bet C--> Check F--> Fold"
							choice = gets.chomp	#get user choice of action and act so
							if(choice == 'B')
								puts "Enter an amount to raise bet"
								move = gets.chomp.to_i
								if(move <= table.high_bet)
									move = table.high_bet								
								else
									table.high_bet += move
								end
								if((player.bankroll < move))
									puts "#{player.name} folded"
									table.players_folded[index] = true
									folds[index] += 1
								else
									puts "#{player.name} bet #{move}"
									puts "High bet => #{table.high_bet}"
									pot += move
									table.bets[index] = move
									player.bankroll -= move	
								end	
							elsif(choice == 'C')
								puts "#{player.name} checks"
							elsif(choice == 'F')
								puts "#{player.name} folded"
								table.players_folded[index] = true
								folds[index] += 1
							else
								redo
							end
						end
				end
			end
			table.checkBets()		#check bets at the end of the round to force everyone to reach high_bet
			table.board << "#{deck.pop.show}"			#add a card to board
		end
		
		puts "Board: #{table.board}"	#print cards on board
		hands = ""
		table.each_with_index do |player,index|		#get hands of each player who has not yet folded at the end of the round
				if(table.players_folded[index] != true)
					puts "#{player.name}: #{player.hand.showHand}"
					hands << player.hand.showHand
				end
		end
		
		odds_proxy.winURL(hands,table.board)		#create winner url
		odds_proxy.makeRequest
		winning_hand = odds_proxy.createObject()	#get winning hand
		table.each_with_index do |player,index|			#determine winner by checking every players hand 		
			if(table.players_folded[index] != true)	#if not folded
				if(player.hand.showHand == winning_hand.showHand)
					puts "!!! #{player.name} WINS!!!"
					player.bankroll += pot	#winner gets the pot
					pot = 0
					wins[index] += 1		#increment win amount			
				else
					loses[index] += 1	#increment loss amount	
				end
			else
				loses[index] += 1	#increment loss amount	
			end	
			total_games[index] = wins[index] + loses[index] #set total games played
		end
		table.printBanks()	#print each player at table bankroll
		puts "Player Stats:"		#print player statistics so far combined with database values as they were read in at the beginning
		table.each_with_index do |player,index|	
			print "#{player.name}:"
			print " Folds: #{folds[index]}"
			print " Wins: #{wins[index]}"
			print " Loses: #{loses[index]}"
			print " Total Games:#{total_games[index]}"
			puts
		end
		
	end
	
	all_data = []		#create an array to send to save method
	table.each_with_index do |player,index|			#get statistics of all players and add them to an array
		data_array = []
		data_array << player.name
		data_array << folds[index]
		data_array << wins[index]
		data_array << loses[index]
		data_array << total_games[index]
		all_data << data_array		#add created array to all_data array
	end
	
	database.saveAll(all_data)		#send all data to saveAll method to save to database
	
end

main