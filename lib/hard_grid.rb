require 'forwardable'

# Grid of fixed size. Keys are always row major, of the form (r, c). Uses a hash
# for storage.
class HardGrid
  extend Forwardable

  attr_reader :hash, :rows, :cols

  %i[count each empty? key key? keys values].each do
    def_delegator :@hash, _1
  end
  alias find key

  # Create a new grid of fixed size.
  def initialize(rows, cols, default: ' ')
    @hash, @rows, @cols = Hash.new(default), rows, cols
  end

  # dup
  def initialize_dup(other)
    @hash, @rows, @cols = other.hash, other.rows, other.cols
  end

  #
  # accessors
  #

  # get value
  def [](pt)
    raise IndexError, "out of bounds #{pt}" if !include?(pt)

    @hash[pt.to_a]
  end

  # set value
  def []=(pt, value)
    raise IndexError, "out of bounds #{pt}" if !include?(pt)

    @hash[pt.to_a] = value
  end

  # is this point in the grid?
  def include?(pt)
    r, c = *pt.to_a
    r >= 0 && r < @rows && c >= 0 && c < @cols
  end

  # how big are we?
  def shape
    [rows, cols]
  end

  # range used to iterate rows
  def row_range
    (0...rows)
  end

  # range used to iterate columns
  def col_range
    (0...cols)
  end

  #
  # conversions
  #

  def to_a
    row_range.map do |r|
      col_range.map { |c| self[[r, c]] }
    end
  end

  def to_s
    inspect
  end

  def inspect
    "<HardGrid #{rows}x#{cols}>"
  end

  #
  # bfs
  #

  # simple bfs from initial to goal. Block is called for (pt,nxt) as we iterate.
  def bfs(initial, goal)
    initial, goal = initial.to_a, goal.to_a
    queue, seen = [initial], Set.new([initial])
    while (pt = queue.shift) && (pt != goal)
      pt.neighbors4.each do |nxt|
        next if !include?(nxt) || self[nxt] == '#' || seen.include?(nxt)

        seen << nxt
        queue << nxt
        yield(pt, nxt)
      end
    end
  end

  # what is the shortest path between these two points?
  def shortest_path(initial, goal)
    parent = { initial => nil }
    bfs(initial, goal) { parent[_2] = _1 }
    return if !parent.key?(goal)

    # build path
    path = [goal]
    path << parent[path.last] while path.last != initial
    path.reverse
  end

  # what is the length of the shortest path between these two points?
  def shortest_path_length(initial, goal)
    cost_so_far = { initial => 0 }
    bfs(initial, goal) { cost_so_far[_2] = cost_so_far[_1] + 1 }
    cost_so_far[goal]
  end

  #
  # dump
  #

  def dump(header: false)
    return '<Grid empty>' if empty?

    if rows > 1000 || cols > 1000
      raise 'too large to dump'
    end

    if header
      puts("   #{col_range.map(&:tens).join}")
      puts("   #{col_range.map(&:ones).join}")
    end

    row_range.each do |r|
      s = []
      s += [r.tens, r.ones, ' '] if header
      s += col_range.map { |c| self[[r, c]] }
      s += [' ', r.tens, r.ones] if header
      puts(s.join)
    end

    if header
      puts("   #{col_range.map(&:ones).join}")
      puts("   #{col_range.map(&:tens).join}")
    end

    nil
  end

  #
  # from_string
  #

  # create a grid from a string, AOC-style
  def self.from_string(str, default: ' ')
    # strip newlines from front and end
    str = str.gsub(/\A\n+|\n+\z/, '')

    # sanity check
    lines = str.split("\n")
    if !lines.map(&:length).identical?
      raise 'rows are not all the same length'
    end

    rows, cols = lines.length, lines.first.length

    HardGrid.new(rows, cols, default: default).tap do |grid|
      lines.each.with_index do |line, r|
        line.each_char.with_index do |ch, c|
          grid[[r, c]] = ch
        end
      end
    end
  end
end
