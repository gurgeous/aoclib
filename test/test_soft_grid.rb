require_relative 'test_helper'

class TestSoftGrid < MiniTest::Test
  def test_all
    str = "\nabcd\n1234\n"
    g = SoftGrid.from_string(str)
    assert_equal([2, 4], g.shape)
    assert_equal([%w[a b c d], %w[1 2 3 4]], g.to_a)

    g = SoftGrid.new(10, 8, default: '.')
    g[[2, 3]] = '#'
    assert_output(/#/) { g.dump }
    assert_output(/#/) { g.dump(header: true) }
    assert([2, 3], g.find('#'))
  end
end
