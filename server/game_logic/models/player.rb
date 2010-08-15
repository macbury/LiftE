require "digest/sha2"

class Player
	include RemoteObject
	attr_accessor :email
	
	def initialize(new_email)
		self.email = new_email
	end
	
	def id
		28423
	end
	
	def self.authorize(new_email, new_password)
		if true #new_email == "macbury@gmail.com" && Digest::SHA1.hexdigest("password") == new_password
			Player.new(new_email)
		else
			false
		end
	end
	
end