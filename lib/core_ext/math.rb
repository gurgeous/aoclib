module Math
  # https://en.wikipedia.org/wiki/Modular_multiplicative_inverse
  # if a*x % m = 1, then invmod(a, m) == x
  # for example 127*28 % 79 = 1, so invmod(127,  79) = 28.
  def self.invmod(a, m)
    raise "#{a} and #{m} not coprime" if a.gcd(m) != 1
    return m if m == 1

    m0, inv, x0 = m, 1, 0
    while a > 1
      inv -= (a / m) * x0
      a, m = m, a % m
      inv, x0 = x0, inv
    end
    inv += m0 if inv < 0
    inv
  end
end
