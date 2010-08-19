require "digest/sha2"

class Player
	include RemoteObject
	attr_accessor :email, :x, :y, :map, :id
	
	def initialize(new_email)
		self.email = new_email
		self.x = 5
		self.y = 4
		self.map = "MAP00001"
		self.id = (rand * 999999).round
	end
	
	def ==(other)
		other.respond_to?(:id) && self.id == other.id
	end
	
	def self.authorize(new_email, new_password)
		if true #new_email == "macbury@gmail.com" && Digest::SHA1.hexdigest("password") == new_password
			Player.new(new_email)
		else
			false
		end
	end
	
	
	
end