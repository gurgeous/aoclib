# Simple immutable 3d point class. Handy for compass operations.
class Point3
  attr_reader :x, :y, :z

  # Init with three values, an array, another Point3, or nothing.
  def initialize(*args)
    case
    when args.empty?
      @x, @y, @z = 0, 0, 0
    when args.length == 1
      other = args.first
      case other
      when Array
        if other.length != 3
          raise ArgumentError, "expected array of length 3, not #{other.inspect}"
        end

        @x, @y, @z = *other
      when Point3
        @x, @y, @z = other.x, other.y, other.z
      else
        raise ArgumentError, "point3 init unexpected #{other.class}"
      end
    when args.length == 3
      @x, @y, @z = *args
    else
      raise ArgumentError, "expected 0, 1 or 3 arguments, got #{args.length}"
    end

    raise "#{x} is not a number" if !x.is_a?(Numeric)
    raise "#{y} is not a number" if !y.is_a?(Numeric)
    raise "#{z} is not a number" if !z.is_a?(Numeric)
  end

  # get x/y/z by index
  def [](index)
    case index
    when 0 then x
    when 1 then y
    when 2 then z
    else
      raise IndexError, "invalid index #{index}"
    end
  end

  # x
  def first
    x
  end

  # y
  def second
    y
  end

  # z
  def last
    z
  end
  alias_method :third, :last

  #
  # math
  #

  # add two points
  def +(other)
    self.class.new(x + other.x, y + other.y, z + other.z)
  end

  # subtract two points
  def -(other)
    self.class.new(x - other.x, y - other.y, z + other.z)
  end

  # return manhattan distance between two points
  def man(other)
    (x - other.x).abs + (y - other.y).abs + (z - other.z).abs
  end

  #
  # compass
  #

  # return point to the north (same z)
  def n
    self.class.new(x, y - 1, 0)
  end

  # return point to the east (same z)
  def e
    self.class.new(x + 1, y, 0)
  end

  # return point to the south (same z)
  def s
    self.class.new(x, y + 1, 0)
  end

  # return point to the west (same z)
  def w
    self.class.new(x - 1, y, 0)
  end

  # return point above
  def u
    self.class.new(x, y, z + 1)
  end

  # return point below
  def d
    self.class.new(x, y, z - 1)
  end

  # return n/e/s/w and u/d
  def neighbors6
    [n, e, s, w, u, d]
  end

  # return the 26 neighbors around this point
  def neighbors26
    [].tap do |neighbors|
      (-1..1).each do |dx|
        (-1..1).each do |dy|
          (-1..1).each do |dz|
            next if dx == 0 && dy == 0 && dz == 0

            neighbors << self.class.new(x + dx, y + dy, z + dz)
          end
        end
      end
    end
  end

  #
  # misc
  #

  def eql?(other)
    instance_of?(other.class) && (self <=> other) == 0
  end
  alias_method :==, :eql?

  def <(other)
    (self <=> other) == -1
  end

  def >(other)
    (self <=> other) == 1
  end

  def <=>(other)
    c = (x <=> other.x)
    c = (y <=> other.y) if c == 0
    c = (z <=> other.z) if c == 0
    c
  end

  def hash
    (x * 7897951) + (y * 7546381) + z
  end

  def dup
    self.class.new(x, y, z)
  end

  def inspect
    to_s
  end

  def to_a
    [x, y, z]
  end

  def to_s
    "(#{x}, #{y}, #{z})"
  end
end
