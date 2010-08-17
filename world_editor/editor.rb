class Editor < Sinatra::Base
	set :static, true
	set :public, File.join([FILE_ROOT, '/public'])
	
  get '/' do
		chipsets_directory = File.join([FILE_ROOT, "../", "client", "assets", "graphics", "chipsets", "/*.lec"])
		@chipsets = {}
		Dir[chipsets_directory].each do |file|
			chipset_json = ""
			
			File::open(file, "r+").each do |line|
				chipset_json += line
			end
			
			@chipsets[File.basename(file, ".lec")] = JSON.parse(chipset_json)
		end
	
    erb :index
  end
	
	get	"/chipset_image/:chipset_name" do
		chipset_directory = File.join([FILE_ROOT, "../", "client", "assets", "graphics", "chipsets", params[:chipset_name]])
		send_file(chipset_directory)
	end
	
	get '/map_list' do
		map_directory = File.join([FILE_ROOT, "../", "client", "assets", "maps", "/*.lem"])
		@files = []
		Dir[map_directory].each do |file|
			@files << File.basename(file)
		end
		
		return @files.to_json
	end
	
	get "/load_map/:map_name" do
		map_directory = File.join([FILE_ROOT, "../", "client", "assets", "maps", params[:map_name]])
		output = ""
		File::open(map_directory, "r+").each do |line|
			output += line
		end
		
		output
	end
end