module Enumerable
  # are all elements the same?
  def identical?
    all? { _1 == first }
  end

  # what is the most common element?
  def most_common
    counts = tally
    max_by { counts[_1] }
  end

  # multiply all numerics in here
  def multiply
    inject(:*)
  end
end
