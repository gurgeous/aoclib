#
# Add numpy-style helpers to Array. 2d only.
#

class Array
  # raise if not 2d
  def d2!
    raise 'not a 2d array' if !first.is_a?(Array)
  end

  # verify points are in the right order and in range.
  def valid_range!(r1, c1, r2, c2)
    if !includes_pt?(r1, c1) || !includes_pt?(r2, c2) || r1 > r2 || c1 > c2
      raise ArgumentError, "must be in bounds. 0 < #{r1} < #{r2} < #{first.length} and 0 < #{c1} < #{c2} < #{length}"
    end
  end

  def includes_pt?(r, c)
    r >= 0 && c >= 0 && c < self[0].length && r < length
  end

  # add up all the values
  def sum_2d
    sum(&:sum)
  end

  # what is the shape?
  def shape
    d2!
    [length, first.length]
  end

  # rotate left (CCW)
  def rot90
    d2!
    transpose.reverse
  end

  # flip rows
  def flipud
    d2!
    reverse
  end

  # flip cols
  def fliplr
    d2!
    map(&:reverse)
  end

  # return array with new shape
  def reshape(rows, cols)
    d2!
    values = flatten
    if values.length != rows * cols
      raise "invalid reshape (#{values.length} != #{rows}*#{cols}"
    end

    values.each_slice(cols).map(&:to_a)
  end

  # roll (rotate) rows or cols to the right
  def roll(shift, axis: 0)
    d2!
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

  # set the passed value to all cells in the specified region
  def fill(r1, c1, r2, c2, value)
    valid_range!(r1, c1, r2, c2)
    r1.upto(r2) { |r| c1.upto(c2) { |c| self[r][c] = value } }

    self
  end

  # set the cells starting at the specified coordinates with the contents of the passed array
  def paste(r, c, other)
    if r < 0 || c < 0 || c + other.first.length >= first.length || r + other.length >= length
      raise ArgumentError, 'must be in bounds'
    end

    other.each_with_index { |row, r2| row.each_index { |c2| self[r2 + r][c2 + c] = other[r2][c2] } }

    self
  end

  # add the passed difference to all values in the specified region
  def inc(r1, c1, r2, c2, n = 1)
    valid_range!(r1, c1, r2, c2)

    r1.upto(r2) { |r| c1.upto(c2) { |c| self[r][c] += n } }

    self
  end

  # create new array from specified region
  def slice(r1, c1, r2, c2)
    valid_range!(r1, c1, r2, c2)

    Array.zeros(r2 - r1 + 1, c2 - c1 + 1).tap do |new_array|
      r1.upto(r2) { |r| c1.upto(c2) { |c| new_array[r - r1][c - c1] = self[r][c] } }
    end
  end

  # invert values in the specified region (true => false, false => true, nonzero => 0, and 0 => 1)
  def not!(r1, c1, r2, c2)
    valid_range!(r1, c1, r2, c2)

    r1.upto(r2) do |r|
      c1.upto(c2) do |c|
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

  # create 2d array filled with this value
  def self.full(rows, cols, value)
    Array.new(rows, value).map { Array.new(cols, value) }
  end

  # create 2d array filled with zeros
  def self.zeros(rows, cols)
    full(rows, cols, 0)
  end

  # create 2d array filled with sequence (range)
  def self.arange(rows, cols)
    zeros(rows, cols).tap do |x|
      (0...rows).each do |r|
        (0...cols).each do |c|
          x[r][c] = r * cols + c
        end
      end
    end
  end

  # concat two arrays
  def self.concatenate(x, y, axis: 0)
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
