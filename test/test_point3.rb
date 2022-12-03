require_relative "test_helper"

class TestPoint3 < MiniTest::Test
  def test_basic
    # ctors
    assert_equal([0, 0, 0], Point3.new.to_a)
    assert_equal([1, 2, 3], Point3.new(1, 2, 3).to_a)
    assert_equal([1, 2, 3], Point3.new([1, 2, 3]).to_a)
    assert_equal([1, 2, 3], Point3.new(Point3.new(1, 2, 3)).to_a)

    a = Point3.new(1, 2, 3)
    assert_equal(6, a.neighbors6.length)
    assert_equal(26, a.neighbors26.length)

    assert(Point3.new == Point3.new(0, 0, 0))
    assert(Point3.new < Point3.new(1, 0, 0))
    assert(Point3.new < Point3.new(0, 1, 0))
    assert(Point3.new < Point3.new(0, 0, 1))
  end
end
