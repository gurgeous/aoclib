require_relative 'test_helper'

class TestDeque < Minitest::Test
  #
  # accessors
  #

  def test_empty
    q = Deque.new
    assert(q.empty?)
    assert_nil(q.first)
    assert_nil(q.last)
    assert_nil(q.shift)
    assert_nil(q.pop)
  end

  def test_length
    q = Deque.new.tap { _1.push('a', 'b', 'c') }
    assert_equal(3, q.length)
    assert_equal('a', q.shift)
    assert_equal(2, q.length)
    assert_equal('c', q.pop)
    assert_equal(1, q.length)
    assert_equal('b', q.shift)
    assert_equal(0, q.length)
  end

  def test_subscript_get
    array = %w[a b c d]
    q = Deque.new.tap { _1.push(*array) }
    (-array.length - 1..array.length + 1).each do
      if array[_1]
        assert_equal(array[_1], q[_1])
      else
        assert_nil(q[_1])
      end
    end
  end

  def test_subscript_set
    q = Deque.new.tap { _1.push('a', 'b', 'c') }
    q[0], q[-1] = 0, 9
    assert_equal('0,b,9', q.join(','))
  end

  #
  # shift/unshift/push/pop
  #

  def test_uno
    q = Deque.new.tap { _1 << 'a' }
    assert(!q.empty?)
    assert_equal('a', q.first)
    assert_equal('a', q.last)

    # shift/unshift
    q.unshift('b')
    assert_equal('b', q.shift)
    assert_equal('a', q.shift)

    # push/pop
    q = Deque.new.tap { _1 << 'a' }
    q << 'b'
    assert_equal('b', q.pop)
    assert_equal('a', q.pop)
  end

  def test_all
    q = Deque.new.tap { _1.push('a', 'b', 'c') }
    assert_equal('a', q.shift)
    assert_equal('c', q.pop)
    assert_equal('b', q.shift)
    assert(q.empty?)
  end

  #
  # insert/delete/clear
  #

  def test_insert
    q = Deque.new.tap { _1 << 'f' }
    q.insert(0, 'a', 'e')
    q.insert(1, 'b', 'c', 'd')
    q.insert(6, 'g')

    assert_equal('a', q.first)
    assert_equal('g', q.last)
    assert_equal('a,b,c,d,e,f,g', q.join(','))
  end

  def test_delete
    q = Deque.new.push('a', 'b', 'b', 'a')
    assert_equal('b,b', q.dup.tap { _1.delete('a') }.join(','))
    assert_equal('a,a', q.dup.tap { _1.delete('b') }.join(','))
    assert_equal('a,b,b,a', q.dup.tap { _1.delete('zz') }.join(','))
  end

  def test_clear
    q = Deque.new.push('a', 'b', 'b', 'a')
    q.clear
    assert(q.empty?)
  end

  #
  # index
  #

  def test_index
    q = Deque.new.tap { _1.push('a', 'b', 'c') }
    assert_equal(0, q.index('a'))
    assert_equal(2, q.index('c'))
    assert_nil(q.index('zz'))
  end

  #
  # rotate
  #

  def test_rotate
    q = Deque.new.tap { _1.push('a', 'b', 'c') }
    q.rotate(1)
    assert_equal('c,a,b', q.join(','))
    q.rotate(-1)
    assert_equal('a,b,c', q.join(','))
  end

  #
  # misc
  #

  def test_dup
    q = Deque.new.tap { _1.push('a', 'b', 'c') }
    assert_equal('a,b,c', q.dup.join(','))
  end

  def test_eq
    q = Deque.new.tap { _1.push('a', 'b', 'c') }
    assert_equal(q, q.dup)
    assert(q != 'x')
    assert(q != q.dup.tap { _1[0] = 'x' })
  end

  def test_hash
    q = Deque.new.tap { _1.push('a', 'b', 'c') }
    assert_equal(q.hash, q.dup.hash)
  end
end
