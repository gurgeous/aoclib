require 'ostruct'
require 'set'

#
# Make deep dups of objects. Not all types are supported, but should be enough
# here for AOC.
#

module DeepDup
  def deep_dup
    dup
  end
end

[FalseClass, NilClass, Numeric, Range, Regexp, String, Symbol, TrueClass].each do |klass|
  klass.include(DeepDup)
end

module Enumerable
  def deep_dup
    map(&:deep_dup)
  end
end

class Hash
  def deep_dup
    dup.tap do |hash|
      each_pair { hash[_1.deep_dup] = _2.deep_dup }
    end
  end
end

class OpenStruct
  def deep_dup
    OpenStruct.new(to_h.deep_dup)
  end
end

class Set
  def deep_dup
    map(&:deep_dup).to_set
  end
end
