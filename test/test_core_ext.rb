require_relative "test_helper"

class TestCoreExt < Minitest::Test
  def test_array
    # second/third
    assert_equal(2, [1, 2, 3, 4].second)
    assert_equal(3, [1, 2, 3, 4].third)
    assert_equal(4, [1, 2, 3, 4].fourth)

    # comparisons
    assert([0, 0] < [0, 1])
    assert([0, 1] > [0, 0])

    # compass
    assert_equal([0, -1], [0, 0].n)
    assert_equal([1, 0], [0, 0].e)
    assert_equal([0, 1], [0, 0].s)
    assert_equal([-1, 0], [0, 0].w)
    assert_equal(4, [0, 0].neighbors4.length)
    assert_equal(8, [0, 0].neighbors8.length)

    # index_subarray
    assert_equal(1, [1, 2, 3, 4].index_subarray([2, 3]))
    assert_nil([1, 2, 3, 4].index_subarray([2, 9]))
    assert_nil([].index_subarray([2, 3]))

    # man
    assert_equal(2, [1, 2].man([2, 1]))
    assert_equal(4, [1, 2, 3].man([3, 2, 1]))

    # dump
    assert_output(/7, 8, 9/) { Array.arange_2d(2, 5).dump }
  end

  def test_enumerable
    assert_nil([].most_common)
    assert_equal(2, [1, 2, 3, 4, 2].most_common)
    assert([2, 2, 2].identical?)
    assert(![2, 2, 3].identical?)
    assert_equal(6, [1, 2, 3].multiply)
    assert_equal(1, 123.sign)
    assert_equal(-1, -123.sign)
    assert_equal(0, 0.sign)
  end

  def test_hash
    assert_equal({a: 2, b: 2}, {b: 2, a: 2}.sort_by_key)
    assert_equal({a: 1, b: 2}, {b: 2, a: 1}.sort_by_value)
    assert_equal({a: 1, b: 2}, {b: 2, a: 1}.reverse)
  end

  def test_integer
    assert_equal([2, 3], 24.prime_factors)
    assert_equal([2, 2, 2, 3], 24.prime_factorization)
    assert_equal(24, 4.factorial)
    assert_equal([3, 2, 1], [123.ones, 123.tens, 123.hundreds])
    assert_equal(1245, 12.concat(45))
    assert_equal(321, 123.reverse)
  end

  def test_math
    assert_equal(28, Math.invmod(127, 79))
  end

  def test_numeric
    assert_equal(3, 9.sqrt)
    assert_equal(Math.log(7), 7.log)
  end

  def test_object
    assert("bub".palindrome?)
    assert(!"xbub".palindrome?)
  end

  def test_range
    assert_equal((0..2), (1..1).grow)
    assert_equal((1..1), (0..2).shrink)
  end

  def test_string
    assert_equal([-123.5, 456], "hi -123.5 there 456".floats)
    assert_equal([-123, 456], "hi -123 there 456".ints)
    assert_equal("ba73632f801ac2c72d78134722f2cb84", "gub".md5)
  end
end
