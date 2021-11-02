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
  # numpy
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

  # set the value to all cells in the region
  def fill_2d!(r1, c1, r2, c2, value)
    must_be_2d!
    includes_range!(r1, c1, r2, c2)

    tap do
      (r1..r2).each do |r|
        (c1..c2).each do |c|
          self[r][c] = value
        end
      end
    end
  end

  # set the cells starting at r, c with the contents of the other 2d array
  def paste_2d!(r, c, other)
    must_be_2d!
    if r < 0 || r + other.rows >= rows || c < 0 || c + other.cols >= cols
      raise ArgumentError, 'out of bounds'
    end

    tap do
      other.each.with_index do |row, r2|
        row.each_index do |c2|
          self[r2 + r][c2 + c] = other[r2][c2]
        end
      end
    end
  end

  # add n to all values in a region
  def inc_2d!(r1, c1, r2, c2, n = 1)
    must_be_2d!
    includes_range!(r1, c1, r2, c2)

    tap do
      (r1..r2).each do |r|
        (c1..c2).each do |c|
          self[r][c] += n
        end
      end
    end
  end

  # invert values in the region (true => false, false => true, nonzero => 0, and 0 => 1)
  def not_2d!(r1, c1, r2, c2)
    must_be_2d!
    includes_range!(r1, c1, r2, c2)

    (r1..r2).each do |r|
      (c1..c2).each do |c|
        self[r][c] = case self[r][c]
        when true then false
        when false then true
        when 0 then 1
        when 1 then 0
        else raise ArgumentError, 'Contents must be true, false, 0, or 1'
        end
      end
    end
  end

  # create new array from region
  def slice_2d(r1, c1, r2, c2)
    must_be_2d!
    includes_range!(r1, c1, r2, c2)

    Array.zeros_2d(r2 - r1 + 1, c2 - c1 + 1).tap do |new_array|
      r1.upto(r2) do |r|
        c1.upto(c2) do |c|
          new_array[r - r1][c - c1] = self[r][c]
        end
      end
    end
  end

  # dump a 2d array
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
  def includes_pt?(r, c)
    r >= 0 && r < rows && c >= 0 && c < cols
  end

  # verify points are in the right order and in range.
  def includes_range!(r1, c1, r2, c2)
    if !includes_pt?(r1, c1) || !includes_pt?(r2, c2) || r1 > r2 || c1 > c2
      raise ArgumentError, "out of bounds, 0 < #{r1} < #{r2} < #{rows} and 0 < #{c1} < #{c2} < #{cols}"
    end
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
