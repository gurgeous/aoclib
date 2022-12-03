# Doubly linked list, a bit Like Python's deque. Some methods are slow, beware!
# https://docs.python.org/3/library/collections.html#collections.deque
class Deque
  include Enumerable

  # current length
  attr_reader :length

  def initialize
    @left, @right, @length = nil, nil, 0
  end

  #
  # accessors
  #

  # are we empty?
  def empty?
    @length == 0
  end

  # last value
  def last
    @right&.value
  end

  # get value at index
  def [](index)
    node_at(index)&.value
  end

  # set value at index
  def []=(index, value)
    node_at(index)&.value = value
  end

  #
  # shift/unshift/push/pop
  #

  # shift first value
  def shift
    return if empty?

    @left.value.tap do
      @left = @left&.next
      @left&.prev = nil
      @length -= 1
    end
  end

  # unshift values to front
  def unshift(*values)
    values.each do |value|
      Node.new(value, nil, @left).tap do
        @left&.prev = _1
        @left = _1
        @right ||= _1
        @length += 1
      end
    end
    self
  end

  # push some values to back
  def push(*values)
    values.each do |value|
      Node.new(value, @right, nil).tap do |n|
        @right&.next = n
        @right = n
        @left ||= n
        @length += 1
      end
    end
    self
  end
  alias_method :append, :push
  alias_method :<<, :push

  # pop last value
  def pop
    return if empty?

    @right.value.tap do
      @right = @right&.prev
      @right&.next = nil
      @length -= 1
    end
  end

  #
  # insert/delete/clear
  #

  # insert values at index (slow at the moment)
  def insert(index, *values)
    if index < 0 || index > length
      raise IndexError, "index #{index} out of range"
    end

    rotate(-index)
    values.reverse_each { unshift(_1) }
    rotate(index)
    self
  end

  # delete a value from the deque
  def delete(value)
    ret, node = nil, @left
    while node
      node = node.next.tap do
        if node.value == value
          node.prev&.next = node.next
          node.next&.prev = node.prev

          @left = node.next if node == @left
          @right = node.prev if node == @right
          node.next = node.prev = nil

          @length -= 1
          ret = value
        end
      end
    end
    ret
  end

  # clear the deque
  def clear
    @left = @right = nil
    @length = 0
    self
  end

  #
  # index
  #

  # find first index of value
  def index(value)
    each.with_index { return _2 if _1 == value }
    nil
  end

  #
  # rotate
  #

  # rotate (positive goes right, negative goes left)
  def rotate(n = 1)
    return if length <= 1 || n == 0

    # mod n
    halflen = length / 2
    if n > halflen || n < -halflen
      n %= length
      if n > halflen
        n -= length
      elsif n < -halflen
        n += length
      end
    end

    if n > 0
      n.times { unshift(pop) }
    else
      (-n).times { push(shift) }
    end

    self
  end

  #
  # enumerate
  #

  # iterate values
  def each
    return to_enum(:each) if !block_given?

    n = @left
    while n
      yield(n.value)
      n = n.next
    end
  end

  # join values into a string
  def join(separator = "")
    to_a.join(separator)
  end

  #
  # misc
  #

  # equality
  def ==(other)
    return false if !other.is_a?(Deque)
    return false if length != other.length

    zip(other).all? { _1 == _2 }
  end

  # make a copy
  def dup
    self.class.new.tap do |dup|
      each { dup << _1 }
    end
  end

  # hash, so we can use this as a key in a hash
  def hash
    p, m = 1299029, 1000000009
    inject([].hash) { (_1 + _2.hash * p) % m }
  end

  def to_s
    inspect
  end

  def inspect
    to_a.to_s
  end

  alias_method :size, :length

  Node = Struct.new(:value, :prev, :next) do
    def to_s
      inspect
    end

    def inspect
      "<Node #{value.inspect}>"
    end
  end

  protected

  # internal helper for getting a node by index
  def node_at(index)
    return if index < -length || index >= length

    if index >= 0
      node = @left
      index.times { node = node.next }
    else
      index = -index - 1
      node = @right
      index.times { node = node.prev }
    end

    node
  end
end
