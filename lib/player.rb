require 'behavior'
require 'walking'
require 'jumping'
require 'shooting'

class Player

  ABILITIES = [ Walking, Jumping, Shooting ]

  attr_accessor :world

  LEFT  = 1.0
  RIGHT = -1.0

  def initialize
    @w = 0.50
    @h = 2.00
    @y = 0.0
    @x = 0.0
    @direction = LEFT
    @instructions = Set.new
    @abilities = ABILITIES.map { |ab| ab.new(self) }
  end

  attr_accessor :x, :y, :direction
  attr_reader :w, :h

  def turn_left
    @direction = LEFT
  end

  def turn_right
    @direction = RIGHT
  end

  def draw

    @abilities.each do |ability|
      ability.handle_instructions(@instructions)
      ability.handle
    end
    @instructions.clear

    glColor(1.0, 0.0, 0.0)
    glBegin(GL_POLYGON)

    glVertex(x, y)
    glVertex(x, y + h)
    glVertex(x + w, y + h)
    glVertex(x + w, y)

    glEnd
    aim_dot

    center_camera
  end

  def aim_dot
    x = (world.mouse_x / 600.0 - 0.5) * world.camera.distance * 0.9
    y = (world.mouse_y / 600.0 - 0.75) * world.camera.distance * -0.9
    #puts "x:y #{x}:#{y}"

    glBegin(GL_LINES)
    glColor(1,1,1)
    glVertex(0,0,0)
    glVertex(x + @x,y + @y + @h,0)
    glEnd
  end

  def to(action)
    @instructions << action
    self
  end
  alias_method :and, :to

  def center_camera
    world.camera.center(@x)
  end

  def current_time
    Time.now.to_f * 100
  end

end
