require 'prime'

class Integer
  # find prime factors of a number
  def prime_factors
    prime_division.map(&:first)
  end

  # return prime factorization (product is this number)
  def prime_factorization
    prime_division.flat_map { [_1] * _2 }
  end

  # return the factorial of an int
  def factorial
    (1..self).multiply
  end

  #
  # digits
  #

  def ones
    abs % 10
  end

  def tens
    (abs / 10) % 10
  end

  def hundreds
    (abs / 100) % 10
  end

  # "concat" two numbers are though they were strings
  def concat(num)
    "#{self}#{num}".to_i
  end

  # reverse the digits of a number
  def reverse
    digits.join.to_i
  end
end
