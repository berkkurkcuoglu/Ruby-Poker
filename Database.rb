require 'json'

class Database

	def save(name,folds,wins,loses)			#save a player's stats to the database file
		temp_hash = { :name=>name, :folds=>folds, :wins=>wins, :loses=>loses, :total_games=>wins+loses }			
		File.open("data.json","w") do |f|			
				f.write(temp_hash.to_json)
				f.puts
		end
	end
	
	def saveAll(data_array)				#save all player's stats to the database using array of player stats
		File.open("data.json","w") do |f|	
			data_array.each do |data|
				temp_hash = { :name=>data[0], :folds=>data[1], :wins=>data[2], :loses=>data[3], :total_games=>data[4] }	
				f.write(temp_hash.to_json)
				f.puts
			end
		end
	end
	
	def printData			#print all user statistics in database file
		data_file = File.open("data.json", "r")
		data_file.each_line do |line|			
			data_array = JSON.parse(line)
			name = data_array['name']
			folds = data_array['folds']
			wins = data_array['wins']
			loses = data_array['loses']
			total_games = data_array['total_games']			
			#data_array.each do |data|
			#	print " #{data}"
			#end
			print "#{name}:"
			print " Folds: #{folds}"
			print " Wins: #{wins}"
			print " Loses: #{loses}"
			print " Total Games:#{total_games}"			
		end
	end
	
	def getInfo(name)			#get info of a player from database returns array of stats if available, nil otherwise
		data_file = File.open("data.json", "r")
		if(data_file)
			data_file.each_line do |line|			
				data_array = JSON.parse(line)			#parse JSON data
				if(data_array['name'] == name)
					temp_array = []			#create stats array
					temp_array << data_array['folds']
					temp_array << data_array['wins']
					temp_array << data_array['loses']
					temp_array << data_array['total_games']	
					return temp_array
				end
			end
		end
		return nil # return nil if no result was found
	end
	
end