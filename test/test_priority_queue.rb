require_relative "test_helper"

class TestPriorityQueue < Minitest::Test
  def test_all
    q = PriorityQueue.new
    [3, 1, 5].each { q << _1 }
    [1, 3, 5].each { assert_equal(_1, q.shift) }
  end
end
