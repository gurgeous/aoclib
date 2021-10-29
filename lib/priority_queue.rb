require 'forwardable'

# A simple sorted queue. Typically used for A* searching. Elements are inserted
# into the underyling array using bsearch_index and each element must respond to
# the > operator. Arrays are a good choice for elements.
class PriorityQueue
  extend Forwardable

  attr_reader :array

  %i[clear each empty? length map shift].each do
    def_delegator :@array, _1
  end

  def initialize
    @array = []
  end

  def push(value)
    ii = @array.bsearch_index { _1 > value }
    @array.insert(ii || @array.length, value)
  end
  alias << push

  def inspect
    "<PriorityQueue: #{@array.length} items>"
  end

  def to_s
    inspect
  end
end
