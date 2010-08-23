require "digest/sha2"

class Player
	include RemoteObject
	include RemoteId
	include NPC::Locomotion
	
	attr_accessor :email, :position, :map, :id, :connection, :field_of_view
	
	def initialize(new_email, client=nil)
		self.email = new_email
		self.connection = client
		self.position = Point.new_tile(5,4)
		self.map = "MAP00001"
		self.field_of_view = 22
		self.id = (rand * 999999).round
		setup_locomotion
	end
	
	def update(deltaTime=0)
		move_using_waypoints(deltaTime)
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