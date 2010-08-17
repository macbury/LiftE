class GameObject
  attr_accessor :image, :position, :center_position, :zorder
  attr_reader :center, :height, :width
      
  def initialize(options = {})
    super
    
    if options[:image].is_a?(Gosu::Image)
      @image = options[:image]
    elsif options[:image].is_a? String
      begin
        @image = Gosu::Image.new($window, options[:image])
      rescue
        @image = Gosu::Image[options[:image]]
      end
    end
    @visible = true

		if options[:position]
			@position = options[:position]
		else
			@position = Point.new(options[:x] || 0, options[:y] || 0)
		end
    @zorder = options[:zorder] || 3

		$window.add_game_object(self)
  end
	
	def update(deltaTime=0)

	end
	
  def width
    @image.width.to_f
  end
  
  def height
    @image.height.to_f
  end

  def size
    [self.width, self.height]
  end
    
  def hide!
    @visible = false
  end
  
  def show!
    @visible = true
  end
  
  def visible?
    @visible
  end    

  def inside_window?(x = @position.x, y = @position.y)
    x >= 0 && x <= $window.width && y >= 0 && y <= $window.height
  end

  def outside_window?(x =  @position.x, y =  @position.y)
    not inside_window?(x,y)
  end

  def draw
		load_resources if @image.nil?
    @image.draw(@position.x, @position.y, @zorder, 1, 1) if @image && @visible
  end
 
end  
