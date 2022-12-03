require_relative "test_helper"

class TestPoint < MiniTest::Test
  def test_all
    # ctors
    assert_equal([0, 0], Point.new.to_a)
    assert_equal([1, 2], Point.new(1, 2).to_a)
    assert_equal([1, 2], Point.new([1, 2]).to_a)
    assert_equal([1, 2], Point.new(Point.new(1, 2)).to_a)

    assert_equal(4, Point.new.neighbors4.length)
    assert_equal(8, Point.new.neighbors8.length)

    assert(Point.new == Point.new(0, 0))
    assert(Point.new < Point.new(1, 0))
    assert(Point.new < Point.new(0, 1))
  end
end
