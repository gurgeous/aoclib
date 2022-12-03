require_relative "test_helper"

class TestNumpy < MiniTest::Test
  def test_concatenate_2d
    x = [[1, 2], [3, 4]]
    y = [[5, 6]]

    assert_equal([[1, 2], [3, 4], [5, 6]], Array.concatenate_2d(x, y))
    assert_equal([[1, 2, 5], [3, 4, 6]], Array.concatenate_2d(x, y.transpose, axis: 1))
  end

  def test_reshape_2d
    x = Array.arange_2d(1, 6).reshape_2d(3, 2)
    assert_equal([[0, 1], [2, 3], [4, 5]], x)
  end

  def test_ctors
    assert_equal([[1, 1, 1], [1, 1, 1]], Array.full_2d(2, 3, 1))
    assert_equal([[0, 0, 0], [0, 0, 0]], Array.zeros_2d(2, 3))
    assert_equal([[0, 1, 2], [3, 4, 5]], Array.arange_2d(2, 3))
  end

  def test_roll_2d
    x = Array.arange_2d(2, 5)
    assert_equal([[5, 6, 7, 8, 9], [0, 1, 2, 3, 4]], x.roll_2d(1))
    assert_equal([[4, 0, 1, 2, 3], [9, 5, 6, 7, 8]], x.roll_2d(1, axis: 1))
  end

  def test_rot_flip
    x = [[1, 2], [3, 4]]
    assert_equal([[2, 4], [1, 3]], x.rot90_2d)
    assert_equal([[3, 4], [1, 2]], x.flipud_2d)
    assert_equal([[2, 1], [4, 3]], x.fliplr_2d)
  end

  def test_fill_2d!
    x = Array.zeros_2d(4, 4)
    x.fill_2d!(0, 0, 3, 3, 2)
    x.fill_2d!(1, 1, 2, 2, 5)
    assert_equal(x, [[2, 2, 2, 2], [2, 5, 5, 2], [2, 5, 5, 2], [2, 2, 2, 2]])
  end

  def test_toggle_2d!
    x = Array.zeros_2d(4, 4)
    x.toggle_2d!(0, 0, 2, 2)
    x.toggle_2d!(1, 1, 3, 3)
    assert_equal(x, [[1, 1, 1, 0], [1, 0, 0, 1], [1, 0, 0, 1], [0, 1, 1, 1]])

    x = Array.full_2d(4, 4, false)
    x.toggle_2d!(0, 0, 2, 2)
    x.toggle_2d!(1, 1, 3, 3)
    assert_equal(x, [[true, true, true, false], [true, false, false, true], [true, false, false, true], [false, true, true, true]])
  end

  def test_inc_2d!
    x = Array.zeros_2d(3, 3)
    x.inc_2d!(0, 0, 1, 1, 2)
    x.inc_2d!(1, 1, 2, 2, -1)
    assert_equal(x, [[2, 2, 0], [2, 1, -1], [0, -1, -1]])
  end

  def test_get_2d
    a = Array.arange_2d(4, 4)
    b = a.get_2d(1, 1, 2, 2)
    assert_equal(b, [[5, 6], [9, 10]])
  end

  def test_set_2d!
    x = Array.zeros_2d(4, 4)
    y = [[4, 5], [6, 7]]
    x.set_2d!(1, 1, y)
    assert_equal(x, [[0, 0, 0, 0], [0, 4, 5, 0], [0, 6, 7, 0], [0, 0, 0, 0]])
  end

  def test_bounds_checks
    x = Array.zeros_2d(4, 4)
    assert_raises ArgumentError do
      x.toggle_2d!(0, 0, 4, 4)
    end
    assert_raises ArgumentError do
      x.toggle_2d!(-1, 0, 1, 1)
    end
    assert_raises ArgumentError do
      x.toggle_2d!(2, 1, 1, 2)
    end
  end
end
