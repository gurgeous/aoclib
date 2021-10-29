require_relative 'test_helper'

class TestDeepDup < Minitest::Test
  def test_all
    # atomics
    x = [false, nil, 1, (1..3), /11/, '11', :a, true]
    assert_equal([false, nil, 1, (1..3), /11/, '11', :a, true], x.deep_dup)

    # string
    x = '11'
    x.deep_dup.tap { _1 << 'xyzzy' }
    assert_equal('11', x)

    # array
    x = [1, 1]
    x.deep_dup.tap { _1 << :xyzzy }
    assert_equal([1, 1], x)

    # array nested
    x = [[1, 1]]
    x.deep_dup.tap { _1[0] << :xyzzy }
    assert_equal([1, 1], x[0])

    # hash
    x = { a: [1, 1] }
    x.deep_dup.tap { _1[:a] << :xyzzy }
    assert_equal([1, 1], x[:a])

    # ostruct
    x = OpenStruct.new(a: [1, 1])
    x.deep_dup.tap { _1.a << :xyzzy }
    assert_equal([1, 1], x.a)

    # set
    x = [1, 1].to_set
    x.deep_dup.tap { _1 << :xyzzy }
    assert_equal([1, 1].to_set, x)
  end
end
