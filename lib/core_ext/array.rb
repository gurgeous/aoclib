class Array
  #
  # handy accessors
  #

  def second
    self[1]
  end

  def third
    self[2]
  end

  def fourth
    self[3]
  end

  def index_subarray(sub)
    0.upto(length - sub.length) do
      return _1 if sub == self[_1, sub.length]
    end
    nil
  end

  # manhattan distance between two arrays
  def man(other)
    # fast
    if length == 2
      return (self[0] - other[0]).abs + (self[1] - other[1]).abs
    end

    # slow
    each_index.sum { (self[_1] - other[_1]).abs }
  end

  #
  # comparison operators for PriorityQueue, which relies on bsearch, which uses
  # these
  #

  def <(other)
    (self <=> other) == -1
  end

  def >(other)
    (self <=> other) == 1
  end

  #
  # compass helpers
  #

  # coord to the north
  def n
    [self[0], self[1] - 1].freeze
  end

  # coord to the east
  def e
    [self[0] + 1, self[1]].freeze
  end

  # coord to the south
  def s
    [self[0], self[1] + 1].freeze
  end

  # coord to the west
  def w
    [self[0] - 1, self[1]].freeze
  end

  # directional aliases for NESW
  alias up n
  alias right e
  alias down s
  alias left w

  # NESW neighors
  def neighbors4
    [n, e, s, w]
  end

  # NW N NE E SE S SW W neighbors
  def neighbors8
    [].tap do |neighbors|
      (-1..1).each do |dx|
        (-1..1).each do |dy|
          next if dx == 0 && dy == 0

          neighbors << [self[0] + dx, self[1] + dy].freeze
        end
      end
    end
  end

  # rotate around the origin to the left (CCW)
  def turnl
    [second, -first].freeze
  end

  # rotate around the origin to the right (CW)
  def turnr
    [-second, first].freeze
  end
end
