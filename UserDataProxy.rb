require_relative "Player"
require_relative "APIProxy"
require 'net/http'
require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
class UserDataProxy < APIProxy	

	def initialize()		#url is always the same so set it right away
		@url = URI("https://randomuser.me/api/")
	end

	def createObject(play_style,bankroll)				#get name from the api call result and create a new player with that name and return it 
		name = @object['results'][0]['name']['first']
		player = Player.new(name,play_style,bankroll)	
		return player
	end

	def makeRequest		#api call with exception handling overrides APIProxy's makeRequest because open-uri doesn't work with https connections
		begin
			result = Net::HTTP.get(@url)		
			@object = JSON.parse(result)
			#puts 'success'
		rescue
			retry
		end
	end

end