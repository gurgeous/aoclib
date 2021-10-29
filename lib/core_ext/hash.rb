class Hash
  # return a new hash sorted by key
  def sort_by_key
    hash_sort_by { [_1, _2.to_s.downcase] }
  end

  # return a new hash sorted by value
  def sort_by_value
    hash_sort_by { [_2, _1.to_s.downcase] }
  end

  # return a new hash using a custom sort
  def hash_sort_by(&block)
    sort_by(&block).to_h
  end

  # return a new hash with the key order reversed
  def reverse
    reverse_each.to_h
  end
end
