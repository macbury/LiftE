class GameObject
  attr_accessor :image, :position, :center_position, :zorder
  attr_reader :center, :height, :width
      
  def initialize(options = {})
    super(options)
    
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
    @zorder = options[:zorder] || 4

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
  
	def snap_to_grid
		self.position.snap
	end

	def snap_to_x_grid
		self.position.tile_x = self.position.tile_x
	end

	def snap_to_y_grid
		self.position.tile_y = self.position.tile_y
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
    @image.draw(@position.screen_x, @position.screen_y, 3) if @image && @visible
  end
	
	def to_id
		"game_object_#{self.id}".to_sym
	end
end  
