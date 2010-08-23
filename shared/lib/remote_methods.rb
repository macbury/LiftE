module RemoteMethods
	

	
	def exec_command(request_string, player=nil)
		arg = request_string.split("|")
		arg.delete_at(0)
		method = arg[0].downcase
		arg.delete_at(0)
		arg.pop if arg.last =~ /END/i
		
		arg = arg.map { |raw_arg| Base64.decode64(raw_arg).strip }
		arg.insert(0, player) unless player.nil?
		
		method_is_avaliable = false
		
		server_methods.each do |sm|
			if method =~ /#{sm.to_s}/i
				method_is_avaliable = true
				method = sm
				break
			end
		end
		
		if method_is_avaliable && respond_to?(method)
			$logger.info "Executing method: #{method} for class #{self.class.name} with arguments: #{arg.map{|a| a.inspect }.join(", ")}" if DEV_MODE
			self.send(method, *arg)
		else
			$logger.info "Undefined method: #{method} for class #{self.class.name} and arguments: #{arg.map{|a| a.inspect }.join(", ")}"  if DEV_MODE 
		end
	end
	
	def server_methods
		[]
	end
	
end