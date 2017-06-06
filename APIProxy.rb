require 'json'
require 'open-uri'



class APIProxy

	def initialize()		#url to reach apis
		@url
	end
	
	def createObject		#abstract method to create the required object
		raise NoMethodError	
	end
	
	def makeRequest			#api call with exception handling
		begin
			result = open(@url).read		
			@object = JSON.parse(result)
			#puts 'success'
		rescue
			retry
		end
	end

end
