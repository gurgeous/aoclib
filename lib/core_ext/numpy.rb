#
# Add numpy-style helpers to Array. 2d only.
#

class Array
  #
  # accessors
  #

  # what is the shape of this 2d array?
  def shape
    [rows, cols]
  end

  # how many rows in this 2d array
  def rows
    length
  end

  # how many cols in this 2d array
  def cols
    first.length
  end

  #
  # numpy - these methods return new arrays
  #

  # add up all the values in this 2d array
  def sum_2d
    must_be_2d!
    sum(&:sum)
  end

  # rotate left (CCW)
  def rot90_2d
    must_be_2d!
    transpose.reverse
  end

  # flip rows
  def flipud_2d
    must_be_2d!
    reverse
  end

  # flip cols
  def fliplr_2d
    must_be_2d!
    map(&:reverse)
  end

  # return array with new shape
  def reshape_2d(rows, cols)
    must_be_2d!
    values = flatten
    if values.length != rows * cols
      raise "invalid reshape (#{values.length} != #{rows}*#{cols}"
    end

    values.each_slice(cols).map(&:to_a)
  end

  # roll (rotate) rows or cols to the right
  def roll_2d(shift, axis: 0)
    must_be_2d!
    if axis != 0 && axis != 1
      raise ArgumentError, 'axis must be 0 or 1'
    end

    if axis == 0
      # rotate rows
      rotate(-shift)
    else
      # rotate cols each row
      map { _1.rotate(-shift) }
    end
  end

  #
  # region methods (always INCLUSIVE for r2/c2)
  #

  # create new array from region
  def get_2d(r1, c1, r2, c2)
    Array.zeros_2d(r2 - r1 + 1, c2 - c1 + 1).tap do |new_array|
      each_region_2d(r1, c1, r2, c2) { new_array[_1 - r1][_2 - c1] = self[_1][_2] }
    end
  end

  # set region from another array
  def set_2d!(r, c, other)
    tap do
      r1, c1, r2, c2 = r, c, r + other.rows - 1, c + other.cols - 1
      each_region_2d(r1, c1, r2, c2) { self[_1][_2] = other[_1 - r1][_2 - c1] }
    end
  end

  # fill region with value
  def fill_2d!(r1, c1, r2, c2, value)
    tap do
      each_region_2d(r1, c1, r2, c2) { self[_1][_2] = value }
    end
  end

  # add n to region
  def inc_2d!(r1, c1, r2, c2, n = 1)
    tap do
      each_region_2d(r1, c1, r2, c2) { self[_1][_2] += n }
    end
  end

  # toggle values in region (true => false, false => true, nonzero => 0, and 0 => 1)
  def toggle_2d!(r1, c1, r2, c2)
    tap do
      each_region_2d(r1, c1, r2, c2) do
        self[_1][_2] = case self[_1][_2]
        when true then false
        when false then true
        when 0 then 1
        when 1 then 0
        else raise ArgumentError, "can't toggle self[{#{_1}}][{#{_2}}] = #{self[_1][_2].inspect}"
        end
      end
    end
  end

  #
  # other helpers
  #

  # helper for iterating a region
  def each_region_2d(r1, c1, r2, c2, &block)
    must_be_2d!

    if !include_2d?(r1, c1) || !include_2d?(r2, c2) || r1 > r2 || c1 > c2
      raise ArgumentError, "out of bounds, 0 < #{r1} < #{r2} < #{rows} and 0 < #{c1} < #{c2} < #{cols}"
    end

    (r1..r2).each do |r|
      (c1..c2).each do |c|
        block.call(r, c)
      end
    end
  end

  # dump a 2d array. I left off the _2d so this would match the grid classes.
  def dump
    must_be_2d!

    widths = transpose.map { |col| col.map { _1.inspect.length }.max }
    each.with_index do |row, ii|
      s = []
      s << (ii == 0 ? '[[' : ' [')
      row.each.with_index do
        s << _1.inspect.rjust(widths[_2])
        s << ', ' if _2 != row.length - 1
      end
      s << (ii == length - 1 ? ']]' : '],')
      puts(s.join)
    end
    nil
  end

  #
  # sanity checks
  #

  # raise if not 2d
  def must_be_2d!
    raise 'not a 2d array' if !first.is_a?(Array)
  end

  # is this point in the array?
  def include_2d?(r, c)
    r >= 0 && r < rows && c >= 0 && c < cols
  end

  #
  # ctors
  #

  # create 2d array filled with this value
  def self.full_2d(rows, cols, value)
    Array.new(rows, value).map { Array.new(cols, value) }
  end

  # create 2d array filled with zeros
  def self.zeros_2d(rows, cols)
    full_2d(rows, cols, 0)
  end

  # create 2d array filled with sequence (range)
  def self.arange_2d(rows, cols)
    zeros_2d(rows, cols).tap do |x|
      (0...rows).each do |r|
        (0...cols).each do |c|
          x[r][c] = r * cols + c
        end
      end
    end
  end

  # concat two arrays
  def self.concatenate_2d(x, y, axis: 0)
    xs, ys = x.shape, y.shape
    if axis != 0 && axis != 1
      raise ArgumentError, 'axis must be 0 or 1'
    end
    if xs[1 - axis] != ys[1 - axis]
      raise ArgumentError, "shapes not compatible (#{xs[1 - axis]} != #{ys[1 - axis]})"
    end

    if axis == 0
      # concat rows
      x + y
    else
      # concat cols
      x.map.with_index { _1 + y[_2] }
    end
  end
end
