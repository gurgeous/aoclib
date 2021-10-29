#
# Add numpy-style helpers to Array. 2d only.
#

class Array
  # raise if not 2d
  def d2!
    raise 'not a 2d array' if !first.is_a?(Array)
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

  # dump an array with optional headers
  def dump(header: false)
    return '<Array empty>' if empty?

    d2!
    rows, cols = (0...length), (0...first.length)
    if rows.size > 1000 || cols.size > 1000
      raise 'too large to dump'
    end

    if header
      puts("   #{rows.map(&:tens).join}")
      puts("   #{rows.map(&:ones).join}")
    end

    rows.each do |r|
      s = []
      s += [r.tens, r.ones, ' '] if header
      s += cols.map { |c| self[r][c] }
      puts(s.join)
    end

    nil
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
