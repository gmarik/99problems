module PerfectSquare

  # row/col increments
  DX = [
    [0, 1],   # horizontal to the right
    [1, 0],   # vertical to the bottom
    [0, -1],  # horizontal to the left
    [-1, 0],  # vertical to the top
  ]

  def perfect_square(n)
    to_2d(linearize(calculate(n)), sqrti(n))
  end

  def calculate(n)
    s = sqrti(n)
    c, i, j = if n.odd? then [2, s - 1, s - 1] else [0, 0, 0] end
    iterate(n, n + 1 - s, c, i, j)
  end

  # num  - current state
  # t    - next turn
  # c    - current di, dj pair's index
  # i, j - current row, col
  #
  # returns an array of [num, i, j] tuples
  def iterate(num, t, c, i, j,  acc = [])
    if num == 0
      acc
    else
      nt, nc = if num == t then [next_turn(t), (c + 1) % 4] else [t, c] end
      di, dj = DX[nc]
      iterate(num - 1, nt, nc, i + di, j + dj,  acc.push([num, i, j]))
    end
  end


  # buils a list with numbers positioned according to "perfect square" rule
  def linearize(arr)
    s = sqrti(arr.size)
    arr.inject(Array.new(arr.size)) do |acc, tuple|
      num, i, j = tuple
      idx = i * s + j
      acc[idx] = num
      acc
    end
  end

  # turns list into a matrix
  def to_2d(arr, s,  acc = [])
    if arr.empty? then acc
    else to_2d(arr.drop(s), s, acc.push(arr.take(s)))
    end
  end

  # constructs a string representation of a matrix
  def fmt(arr)
    return [] if arr.empty?
    n = arr.size * arr.first.size
    s = n.to_s.size
    f = "%#{s + 1}d"
    arr.map{|row| row.map {|v| f % v } }.map(&:join).join("\n")
  end

  def sqrt(n)
    n ** 0.5
  end

  def sqrti(n)
    sqrt(n).to_i
  end

  def next_turn(num)
    num - sqrti(num)
  end

  def perfect_square?(n)
    (sqrt(n) % 1.0).zero?
  end

end

if $0 == __FILE__ && !ENV['TEST']

  if ARGV.empty?
    abort "Use: #{$0} <number>"
  end

  extend PerfectSquare

  N = ARGV[0].to_i

  perfect_square?(N) or abort "#{N} isn't a perfect square"
  puts fmt(perfect_square(N))

  exit 0
end

if $0 == __FILE__ && ENV['TEST']

  extend PerfectSquare

  require 'test/unit'
  include Test::Unit::Assertions

  assert perfect_square(16) == [
    [16, 15, 14, 13],
    [5,   4,  3, 12],
    [6,   1,  2, 11],
    [7,   8,  9, 10]
  ]

  assert perfect_square(9) == [
    [5, 4, 3],
    [6, 1, 2],
    [7, 8, 9]]

  assert perfect_square(1) == [ [1] ]

  assert calculate(9) == [[9, 2, 2], [8, 2, 1], [7, 2, 0], [6, 1, 0], [5, 0, 0], [4, 0, 1], [3, 0, 2], [2, 1, 2], [1, 1, 1]]
  assert linearize(calculate(9)) == [5, 4, 3, 6, 1, 2, 7, 8, 9]

  assert [26, 21, 17, 13, 10, 7, 5, 3, 2, 1].map(&method(:next_turn)) == [21, 17, 13, 10, 7, 5, 3, 2, 1, 0]

  assert fmt(perfect_square(1)) == " 1"
  assert fmt(perfect_square(4)) == " 4 3\n 1 2"

  assert sqrti(16.5) == 4
  assert perfect_square?(4)
  assert !perfect_square?(6)
  assert !perfect_square?(5)
end
