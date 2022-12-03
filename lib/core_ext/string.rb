require "digest"

class String
  # scan string for all float values
  def floats
    scan(/-?\d+(?:\.\d+)?/).map(&:to_f)
  end

  # scan string for all int values
  def ints
    scan(/-?\d+/).map(&:to_i)
  end

  # calculate md5 of string
  def md5
    Digest::MD5.hexdigest(self)
  end
end
