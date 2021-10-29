class Range
  # grow the beginning and end of the range by n
  def grow(n = 1)
    Range.new(self.begin - n, self.end + n, exclude_end?)
  end

  # shrink the beginning and end of the range by n
  def shrink(n = 1)
    grow(-n)
  end
end
