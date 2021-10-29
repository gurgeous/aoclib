# Simple immutable 2d point class. Handy for compass operations. If you want to
# use this with one of the grid classes, be sure to store points as (r, c) not
# (x, y).
class Point
  attr_reader :x, :y

  # Init with two values, an array, another Point, or nothing.
  def initialize(*args)
    case
    when args.empty?
      @x, @y = 0, 0
    when args.length == 1
      other = args.first
      case other
      when Array
        if other.length != 2
          raise ArgumentError, "expected array of length 2, not #{other.inspect}"
        end

        @x, @y = *other
      when Point
        @x, @y = other.x, other.y
      else
        raise ArgumentError, "unexpected #{other.inspect}"
      end
    when args.length == 2
      @x, @y = *args
    else
      raise ArgumentError, "expected 0, 1 or 2 arguments, got #{args.length}"
    end

    raise "#{@x} is not a number" if !@x.is_a?(Numeric)
    raise "#{@y} is not a number" if !@y.is_a?(Numeric)
  end

  # Access x/y by index.
  def [](index)
    case index
    when 0 then x
    when 1 then y
    else
      raise IndexError, "invalid index #{index}"
    end
  end

  # x
  def first
    x
  end

  # y
  def last
    y
  end
  alias second last

  #
  # math
  #

  # return sum of two points
  def +(other)
    self.class.new(x + other.x, y + other.y)
  end

  # return difference between two points
  def -(other)
    self.class.new(x - other.x, y - other.y)
  end

  # return manhattan distance between two points
  def man(other)
    (x - other.x).abs + (y - other.y).abs
  end

  #
  # compass
  #

  # return point to the north
  def n
    self.class.new(x, y - 1)
  end

  # return point to the east
  def e
    self.class.new(x + 1, y)
  end

  # return point to the south
  def s
    self.class.new(x, y + 1)
  end

  # return point to the west
  def w
    self.class.new(x - 1, y)
  end

  # return point to the nw
  def nw
    self.class.new(x - 1, y - 1)
  end

  # return point to the ne
  def ne
    self.class.new(x + 1, y - 1)
  end

  # return point to the se
  def se
    self.class.new(x + 1, y + 1)
  end

  # return point to the sw
  def sw
    self.class.new(x - 1, y + 1)
  end

  # aliases for directions
  alias up n
  alias right e
  alias down s
  alias left w

  # return NESWE points
  def neighbors4
    [n, e, s, w]
  end

  # return nw n ne e se s sw w points
  def neighbors8
    [].tap do |neighbors|
      (-1..1).each do |dx|
        (-1..1).each do |dy|
          next if dx == 0 && dy == 0

          neighbors << self.class.new(x + dx, y + dy)
        end
      end
    end
  end

  # rotate around the origin to the left (CCW)
  def turnl
    self.class.new(y, -x)
  end

  # rotate around the origin to the right (CW)
  def turnr
    self.class.new(-y, x)
  end

  #
  # housekeeping
  #

  def eql?(other)
    instance_of?(other.class) && (self <=> other) == 0
  end
  alias == eql?

  def <(other)
    (self <=> other) == -1
  end

  def >(other)
    (self <=> other) == 1
  end

  def <=>(other)
    c = (x <=> other.x)
    c = (y <=> other.y) if c == 0
    c
  end

  def hash
    (x * 4534549) + y
  end

  def dup
    self.class.new(x, y)
  end

  def inspect
    to_s
  end

  def to_a
    [x, y]
  end

  def to_s
    "(#{x}, #{y})"
  end
end
