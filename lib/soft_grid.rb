require "forwardable"

# A "soft" grid that can expand to any size. Keys are always row major, of the
# form (r, c). Calculations like "number of rows" can be complicated since the
# grid is soft.
class SoftGrid
  extend Forwardable

  attr_reader :hash

  %i[count each empty? key key? keys values].each do
    def_delegator :@hash, _1
  end
  alias_method :find, :key

  # initialize with an optional starting size
  def initialize(rows = 0, cols = 0, default: " ")
    @hash = Hash.new(default)

    # populate
    if rows > 0 && cols > 0
      (0...rows).each do |r|
        (0...cols).each do |c|
          self[[r, c]] = default
        end
      end
    end
  end

  # dup
  def initialize_dup(other)
    @hash = other.hash.dup
  end

  #
  # accessors
  #

  # get value at pt
  def [](pt)
    @hash[pt.to_a]
  end

  # set value at pt
  def []=(pt, value)
    @hash[pt.to_a] = value
  end

  # how many rows are in this grid? calculated fresh each time
  def rows
    row_range&.size || 0
  end

  # how many cols are in this grid? calculated fresh each time
  def cols
    col_range&.size || 0
  end

  # what is the size of this grid? calculated fresh each time
  def shape
    [rows, cols]
  end

  # range for iterating rows. calculated fresh each time
  def row_range
    return if empty?

    Range.new(*keys.map(&:first).minmax)
  end

  # range for iterating cols. calculated fresh each time
  def col_range
    return if empty?

    Range.new(*keys.map(&:second).minmax)
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
        next if self[nxt] == "#" || seen.include?(nxt)

        seen << nxt
        queue << nxt
        yield(pt, nxt)
      end
    end
  end

  # what is the shortest path from initial to goal?
  def shortest_path(initial, goal)
    parent = {initial => nil}
    bfs(initial, goal) { parent[_2] = _1 }
    return if !parent.key?(goal)

    # build path
    path = [goal]
    path << parent[path.last] while path.last != initial
    path.reverse
  end

  # what is the length of the shortest path between these two points?
  def shortest_path_length(initial, goal)
    cost_so_far = {initial => 0}
    bfs(initial, goal) { cost_so_far[_2] = cost_so_far[_1] + 1 }
    cost_so_far[goal]
  end

  #
  # conversions
  #

  def to_a
    col_range = self.col_range
    row_range.map do |r|
      col_range.map { |c| self[[r, c]] }
    end
  end

  def to_s
    inspect
  end

  def inspect
    "<SoftGrid #{rows}x#{cols}>"
  end

  #
  # dump
  #

  def dump(header: false)
    return "<Grid empty>" if empty?

    row_range, col_range = self.row_range, self.col_range
    if row_range.size > 1000 || col_range.size > 1000
      raise "too large to dump"
    end

    if header
      puts("   #{col_range.map(&:tens).join}")
      puts("   #{col_range.map(&:ones).join}")
    end

    row_range.each do |r|
      s = []
      s += [r.tens, r.ones, " "] if header
      s += col_range.map { |c| self[[r, c]] }
      s += [" ", r.tens, r.ones] if header
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
  def self.from_string(str, default: " ")
    # strip newlines from front and end
    str = str.gsub(/\A\n+|\n+\z/, "")

    # sanity check
    lines = str.split("\n")
    if !lines.map(&:length).identical?
      raise "rows are not all the same length"
    end

    SoftGrid.new(default: default).tap do |grid|
      lines.each.with_index do |line, r|
        line.each_char.with_index do |ch, c|
          grid[[r, c]] = ch
        end
      end
    end
  end
end
