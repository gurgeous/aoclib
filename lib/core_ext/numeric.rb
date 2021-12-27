class Numeric
  # wrapper around Math.log
  def log
    Math.log(self)
  end

  # wrapper around Math.sqrt
  def sqrt
    Math.sqrt(self)
  end

  # positive, negative, or zero?
  def sign
    case
    when self > 0 then 1
    when self < 0 then -1
    else 0
    end
  end
end
