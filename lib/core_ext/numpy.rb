#
# Add numpy-style helpers to Array. 2d only.
#

class Array
  # raise if not 2d
  def d2!
    raise 'not a 2d array' if !first.is_a?(Array)
  end

  def pts!(x1, y1, x2, y2)
    if x1 < 0 || y1 < 0 || x2 >= self[0].length || y2 >= length
      raise ArgumentError, "must be in bounds. 0 < #{x1} < #{x2} < #{first.length} and 0 < #{y1} < #{y2} < #{length}"
    end

    if x1 > x2 || y1 > y2
      raise ArgumentError, 'first point must be before the second point'
    end
  end

  def sum_all
    sum { |row| row.sum }
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

  def assign(x1, y1, x2, y2, value)

    x1.upto(x2) { |x| y1.upto(y2) { |y| self[y][x] = value } }

    self
  end

  def paste(x, y, other)
    raise ArgumentError, 'must be in bounds' if x < 0 || y < 0 || x + other.first.length >= first.length || y + other.length >= length

    other.each.with_index { |row, y2| row.each.with_index { |_val, x2| self[y2 + y][x2 + x] = other[y2][x2] } }

    self
  end

  def adjust(x1, y1, x2, y2, difference)
    pts!(x1, y1, x2, y2)

    x1.upto(x2) { |x| y1.upto(y2) { |y| self[y][x] += difference } }

    self
  end

  def clip(x1, y1, x2, y2)
    pts!(x1, y1, x2, y2)

    new_array = Array.new(y2 - y1 + 1).map { Array.new(x2 - x1 + 1) }
    x1.upto(x2) { |x| y1.upto(y2) { |y| new_array[y - y1][x - x1] = self[y][x] } }

    new_array
  end

  def invert(x1, y1, x2, y2)
    pts!(x1, y1, x2, y2)

    x1.upto(x2) { |x| y1.upto(y2) { |y| self[y][x] = self[y][x] == 0 ? 1 : 0 } }
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
