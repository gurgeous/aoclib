class Object
  # when converted to a string, is this a palindrome?
  def palindrome?
    to_s == to_s.reverse
  end
end
