require_relative 'test_helper'

class TestNumpy < MiniTest::Test
  def test_concatenate
    x = [[1, 2], [3, 4]]
    y = [[5, 6]]

    assert_equal([[1, 2], [3, 4], [5, 6]], Array.concatenate(x, y))
    assert_equal([[1, 2, 5], [3, 4, 6]], Array.concatenate(x, y.transpose, axis: 1))
  end

  def test_reshape
    x = Array.arange(1, 6).reshape(3, 2)
    assert_equal([[0, 1], [2, 3], [4, 5]], x)
  end

  def test_ctors
    assert_equal([[1, 1, 1], [1, 1, 1]], Array.full(2, 3, 1))
    assert_equal([[0, 0, 0], [0, 0, 0]], Array.zeros(2, 3))
    assert_equal([[0, 1, 2], [3, 4, 5]], Array.arange(2, 3))
  end

  def test_roll
    x = Array.arange(2, 5)
    assert_equal([[5, 6, 7, 8, 9], [0, 1, 2, 3, 4]], x.roll(1))
    assert_equal([[4, 0, 1, 2, 3], [9, 5, 6, 7, 8]], x.roll(1, axis: 1))
  end

  def test_rot_flip
    x = [[1, 2], [3, 4]]
    assert_equal([[2, 4], [1, 3]], x.rot90)
    assert_equal([[3, 4], [1, 2]], x.flipud)
    assert_equal([[2, 1], [4, 3]], x.fliplr)
  end

  def test_full
    x = Array.zeros(4, 4)
    x.full(0, 0, 3, 3, 2)
    x.full(1, 1, 2, 2, 5)
    assert_equal(x, [[2, 2, 2, 2], [2, 5, 5, 2], [2, 5, 5, 2], [2, 2, 2, 2]])
  end

  def test_not
    x = Array.zeros(4, 4)
    x.not!(0, 0, 2, 2)
    x.not!(1, 1, 3, 3)
    assert_equal(x, [[1, 1, 1, 0], [1, 0, 0, 1], [1, 0, 0, 1], [0, 1, 1, 1]])

    x = Array.full(4, 4, false)
    x.not!(0, 0, 2, 2)
    x.not!(1, 1, 3, 3)
    assert_equal(x, [[true, true, true, false], [true, false, false, true], [true, false, false, true], [false, true, true, true]])
  end

  def test_add
    x = Array.zeros(3, 3)
    x.add(0, 0, 1, 1, 2)
    x.add(1, 1, 2, 2, -1)
    assert_equal(x, [[2, 2, 0], [2, 1, -1], [0, -1, -1]])
  end

  def test_copy
    a = Array.arange(4, 4)
    b = a.copy(1, 1, 2, 2)
    assert_equal(b, [[5, 6], [9, 10]])
  end

  def test_paste
    x = Array.zeros(4, 4)
    y = [[4, 5], [6, 7]]
    x.paste(1, 1, y)
    assert_equal(x, [[0, 0, 0, 0], [0, 4, 5, 0], [0, 6, 7, 0], [0, 0, 0, 0]])
  end

  def test_bounds_checks
    x = Array.zeros(4, 4)
    assert_raises { x.invert(0, 0, 4, 4) }
    assert_raises { x.invert(-1, 0, 1, 1) }
    assert_raises { x.invert(2, 1, 1, 2) }
  end
end
