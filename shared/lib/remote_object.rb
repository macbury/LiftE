require "yaml"
require 'base64'

module RemoteObject
	
	def method_missing(method, *args, &block)
		if method =~ /client_/i || method =~ /server_/i
			command = []
			command << self.class.name.upcase.gsub(/controller/i, '')
			command << method.to_s.gsub(/client_/i, '').gsub(/server_/i, '').upcase

			args.each do |arg|
				if arg.class == Array || arg.class == Hash
					new_arg = arg.to_yaml
				elsif arg.respond_to?(:to_remote_data)
					new_arg = arg.to_remote_data
				else
					new_arg = arg
				end
				
				command << Base64.encode64(new_arg.to_s).strip
			end
			
			command << "END"
			
			return command.join("|")
		else
			super(method, *args, &block)
		end
	end
	
end