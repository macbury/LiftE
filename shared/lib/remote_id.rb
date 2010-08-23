module RemoteId
	
	def to_id
		tmp_id = self.respond_to?(:id) ? self.id.to_s : self.object_id.to_s
		(self.class.name.downcase + '_' + tmp_id).to_sym
	end
	
	def self.to_id(id)
		(self.name.downcase + '_' + id.to_s).to_sym
	end
	
end