require 'test/unit/assertions'
include Test::Unit::Assertions

# Ruby 1.9.3+

## USING recursion, and basic FP operations


# 
#     P01 (*) Find the last box of a list.
#     Example:
#     * (my-last '(a b c d))
#     (d)
#
def list_last(list)
  h, *t = list
  if t.empty? then h
  else list_last(t)
  end
end

assert     list_last(%w[a b c d]) == 'd'
assert_nil list_last([])


# 
#     P02 (*) Find the last but one element of a list.
#     Example:
#     * (my-but-last '(a b c d))
#     (c)

def list_plast(list)
  h, h1, *t = list
  if t.empty? then h1 && h
  else list_plast([h1] + t)
  end
end

assert     list_plast(%w[a b c d]) == 'c'
assert_nil list_plast([:a])
assert_nil list_plast([])



# 
#     P03 (*) Find the K'th element of a list.
#     The first element in the list is number 1.
#     Example:
#     * (element-at '(a b c d e) 3)
#     c

def list_at(list, i)
  h, *t = list
  if i == 1 then h
  else list_at(t, i - 1)
  end
end

assert  'c' == list_at(%w[a b c d], 3)




# 
#     P04 (*) Find the number of elements of a list.

def list_len(list, acc = 0)
  h, *t = list
  if list.empty? then acc
  else list_len(t, acc + 1)
  end
end

assert  4 == list_len(%w[a b c d])




# 
#     P05 (*) Reverse a list.

def list_rev(list, acc = [])
  h, *t = list
  if list.empty? then acc
  else list_rev(t, [h] + acc)
  end
end

assert     list_rev(%w[a b c d]) == %w[d c b a]




# 
#     P06 (*) Find out whether a list is a palindrome.
#     A palindrome can be read forward or backward; e.g. (x a m a x).
#

def list_palindrome?(list, acc = [])
  list == list_rev(list)
end

assert   (not list_palindrome?(%w[a b c d]))
assert        list_palindrome?(%w[l o l])


# 
#     P07 (**) Flatten a nested list structure.
#     Transform a list, possibly holding lists as elements into a `flat' list by replacing each list with its elements (recursively).
#     Example:
#     * (my-flatten '(a (b (c d) e)))
#     (a b c d e)
#     Hint: Use the predefined functions list and append.

def list_flatten(list, acc = [] )
  return acc if list.empty?
  h, *t = list
  if h.is_a?(Array)
    list_flatten(h, acc)
  else
    acc << h
  end
  list_flatten(t,acc)
end

e07 = [1, [1, [1]], 2, [3]]
r07 = [1, 1, 1, 2, 3]

assert r07 == e07.flatten
assert r07 == list_flatten(e07)


#     
#     P08 (**) Eliminate consecutive duplicates of list elements.
#     If a list contains repeated elements they should be replaced with a single copy of the element. The order of the elements should not be changed.
#     Example:
#     * (compress '(a a a a b c c a a d e e e e))
#     (a b c a d e)

def list_compress(list, acc = [])
  return acc if list.empty?
  h, *t = list
  acc << h if acc.last != h
  list_compress(t, acc)
end

e08 = %w[a a a a b b b c d e]
r08 = %w[a b c d e]

assert r08 == list_compress(e08)



# 
#     P09 (**) Pack consecutive duplicates of list elements into sublists.
#     If a list contains repeated elements they should be placed in separate sublists.
#     Example:
#     * (pack '(a a a a b c c a a d e e e e))
#     ((a a a a) (b) (c c) (a a) (d) (e e e e))

def list_pack(list, acc = [])
  return acc if list.empty?
  h,*t = list

  if acc.last && acc.last.last == h
    acc.last << h
  else
    acc << [h]
  end

  list_pack(t, acc)
end

e09 = %w[a a a a b b b c d e]
r09 = [%w[a a a a], %w[b b b], %w[c], %w[d], %w[e]]

assert r09 == list_pack(e09)





# 
#     P10 (*) Run-length encoding of a list.
#     Use the result of problem P09 to implement the so-called run-length encoding data compression method. Consecutive duplicates of elements are encoded as lists (N E) where N is the number of duplicates of the element E.
#     Example:
#     * (encode '(a a a a b c c a a d e e e e))
#     ((4 a) (1 b) (2 c) (2 a) (1 d)(4 e))

def list_encode(list, acc = [])
  list_pack(list, acc).map {|a| [a.size, a.first] }
end

e10 = %w[a a a a b b b c d e]
r10 = [[4,'a'], [3,'b'], [1, 'c'], [1, 'd'], [1, 'e']]

assert r10 == list_encode(e10)




#
#     P11 (*) Modified run-length encoding.
#     Modify the result of problem P10 in such a way that if an element has no duplicates it is simply copied into the result list. Only elements with duplicates are transferred as (N E) lists.
#     Example:
#     * (encode-modified '(a a a a b c c a a d e e e e))
#     ((4 a) b (2 c) (2 a) d (4 e))
#
def list_encode_mod(list)
  list_encode(list).map {|e| e[0] == 1 ? e[1] : e}
end

e11 = %w[a a a a b b b c d e]
r11 = [[4,'a'], [3,'b'], 'c', 'd', 'e']

assert r11 == list_encode_mod(e11)




#
#     P12 (**) Decode a run-length encoded list.
#     Given a run-length code list generated as specified in problem P11. Construct its uncompressed version.
#
def list_run_decode(list, acc = [])
  return acc if list.empty?
  h, *t = list

  if h.is_a?(Array)
    n, c = h
  else
    n, c = [1,h]
  end

  n.times {|i| acc << c }

  list_run_decode(t, acc)
end

e11 = [[4,'a'], [3,'b'], 'c', 'd', 'e']
r11 = %w[a a a a b b b c d e]

assert r11 == list_run_decode(e11)



#
#     P13 (**) Run-length encoding of a list (direct solution).
#     Implement the so-called run-length encoding data compression method directly.
#     I.e. don't explicitly create the sublists containing the duplicates, as in problem P09, but only count them.
#     As in problem P11, simplify the result list by replacing the singleton lists (1 X) by X.
#
#     Example:
#     * (encode-direct '(a a a a b c c a a d e e e e))
#     ((4 A) B (2 C) (2 A) D (4 E))


def list_encode_direct(list, acc = [])
  return acc if list.empty?
  h,*t = list

  if acc.last && acc.last.last == h
    acc.last[0] += 1
  else
    acc << [1, h]
  end

  list_encode_direct(t, acc)
end

e13 = %w[a a a a b b b c d e]
r13 = [[4,'a'], [3,'b'], [1, 'c'], [1, 'd'], [1, 'e']]

assert r13 == list_encode_direct(e13)



#
#     P14 (*) Duplicate the elements of a list.
#     Example:
#     * (dupli '(a b c c d))
#     (a a b b c c c c d d)
#

def list_dupli(list, acc = [])
  return acc if list.empty?
  h, *t = list

  acc << h << h

  list_dupli(t, acc)
end

e14 = %w(a b c c d)
r14 = %w(a a b b c c c c d d)

assert r14 = list_dupli(e14)


#     P15 (**) Replicate the elements of a list a given number of times.
#     Example:
#     * (repli '(a b c) 3)
#     (a a a b b b c c c)
#

def list_repli(list, n, acc = [])
  return acc if list.empty?
  h, *t = list

  n.times { acc << h }

  list_repli(t, 3, acc)
end

e15 = %w(a b c c d)
r15 = %w(a a a b b b c c c)

assert r15 = list_repli(e15, 3)


# 
#     P16 (**) Drop every N'th element from a list.
#     Example:
#     * (drop '(a b c d e f g h i k) 3)
#     (a b d e g h k)
#

def list_drop(list, n, c = 1, acc = [])
  return acc if list.empty?

  h, *t = list

  if c == n
    c = 1
  else
    acc << h
    c += 1
  end

  list_drop(t, n, c, acc)
end

e16 = %w(a b c d e f g h i k)
r16 = %w(a b d e g h k)
assert r16 == list_drop(e16, 3)

#
#     P17 (*) Split a list into two parts; the length of the first part is given.
#     Do not use any predefined predicates.
# 
#     Example:
#     * (split '(a b c d e f g h i k) 3)
#     ( (a b c) (d e f g h i k))

def list_split(list, n, acc = [])
  # if n < 0 then n = (list.size + n) end
  return [acc, list] if list.empty? || n == 0
  h, *t = list
  acc << h
  list_split(t, n-1, acc)
end

e17 = %w(a b c d e f g h i k)
r17 = [%w(a b c), %w(d e f g h i k)]
assert r17 == list_split(e17, 3)



#
#     P18 (**) Extract a slice from a list.
#     Given two indices, I and K, the slice is the list containing the elements between the I'th and K'th element of the original list (both limits included). Start counting the elements with 1.
#     Example:
#     * (slice '(a b c d e f g h i k) 3 7)
#     (c d e f g)

def list_slice(list, n, m, acc = [])
  return acc if list.empty?
  h, *t = list

  acc << h if n <= 1 && m >= 1

  list_slice(t, n-1, m-1, acc)
end

e18 = %w(a b c d e f g h i k)
r18 = %w(c d e f g)

assert r18 == list_slice(e18, 3, 7)



#
#     P19 (**) Rotate a list N places to the left.
#     Hint: Use the predefined functions length and append, as well as the result of problem P17.
#     Examples:
#     * (rotate '(a b c d e f g h) 3)
#     (d e f g h a b c)
#     * (rotate '(a b c d e f g h) -2)
#     (g h a b c d e f)

def list_rotate(list, k)
  n = k < 0 ? list.size + k : k

  a,b = list_split(list, n)

  b + a
end
#
e19  = %w(a b c d e f g h)
r19a = %w(d e f g h a b c)
r19b = %w(g h a b c d e f)
assert r19a == list_rotate(e19, 3)
assert r19b == list_rotate(e19, -2)



# 
#
#     P20 (*) Remove the K'th element from a list.
#     Example:
#     * (remove-at '(a b c d) 2)
#     (a c d)

def list_remove_at(list, n, acc = [])
  h, *t = list
  return [h, acc + t] if t.empty? || n == 1
  list_remove_at(t, n - 1, acc << h)
end

e20 = %w(a b c d)
r20 = %w(a c d)

assert ['b', r20] == list_remove_at(e20, 2)
assert [1, []] == list_remove_at([1], 0)


#
#     P21 (*) Insert an element at a given position into a list.
#     Example:
#     * (insert-at 'alfa '(a b c d) 2)
#     (a alfa b c d)

def list_insert_at(list, el, n, acc = [])
  return acc + [el] + list if list.empty? || n==1
  h, *t = list
  acc << h
  list_insert_at(t, el, n - 1, acc)
end

e21 = %w(a b c d)
r21 = %w(a alfa b c d)

assert r21 == list_insert_at(e21, 'alfa', 2)



#
#     P22 (*) Create a list containing all integers within a given range.
#     If first argument is smaller than second, produce a list in decreasing order.
#     Example:
#     * (range 4 9)
#     (4 5 6 7 8 9)

def list_range(n, m, acc = [])
  acc << n
  return acc if n == m

  list_range(n+1, m, acc)
end
r22 = [4, 5, 6, 7, 8, 9]
assert r22 == list_range(4, 9)

#
#     P23 (**) Extract a given number of randomly selected elements from a list.
#     The selected items shall be returned in a list.
#     Hint: Use the built-in random number generator and the result of problem P20.
#     Example:
#     * (rnd-select '(a b c d e f g h) 3)
#     (e d a)
#

def pseudo_rnd(n)
  n / 2 + 1
end

def list_rnd_select(list, count, rand = method(:rand), acc = [])
  return acc if list.empty? || count == 0
  idx = rand.call(list.size - 1) + 1
  el, rest = list_remove_at(list, idx)
  raise ArgumentError unless el
  acc << el
  list_rnd_select(rest, count - 1, rand, acc)
end

e23 = %w(a b c d e f g h)
r23 = %w(e f d)

assert r23 == list_rnd_select(e23, 3, method(:pseudo_rnd))


# 
#     P24 (*) Lotto: Draw N different random numbers from the set 1..M.
#     The selected numbers shall be returned in a list.
#     Example:
#     Hint: Combine the solutions of problems P22 and P23.
#     * (lotto-select 6 49)
#     (23 1 17 33 21 37)

def list_select(n, m, rand = method(:rand), acc = [])
  list_rnd_select(list_range(1, m), n, rand, acc)
end

r24 = [26, 25, 27, 24, 28, 23] # pseudo_rnd selection
assert r24 == list_select(6, 49, method(:pseudo_rnd))


# 
#     P25 (*) Generate a random permutation of the elements of a list.
#     Example:
#     Hint: Use the solution of problem P23.
#     * (rnd-permu '(a b c d e f))
#     (b a d c e f)
#
def list_rand_permu(list, rnd = method(:rand), acc = [])
  return acc if list.empty?
  idx = rnd.call(list.size)
  el, rest = list_remove_at(list, idx)
  acc << el
  list_rand_permu(rest, rnd, acc)
end

e25 = %w(a b c d e f)
r25 = %w[d c e b f a]
assert r25 == list_rand_permu(e25, method(:pseudo_rnd))


# 
#     P26 (**) Generate the combinations of K distinct objects chosen from the N elements of a list
#     In how many ways can a committee of 3 be chosen from a group of 12 people? We all know that there are C(12,3) = 220 possibilities (C(N,K) denotes the well-known binomial coefficients). For pure mathematicians, this result may be great. But we want to really generate all the possibilities in a list.
# 
#     Example:
#     * (combination 3 '(a b c d e f))
#     ((a b c) (a b d) (a b e) ... )
#

def list_comb(list, m, acc = [], q = [])
  return acc if list.empty? || m == 0 || m > list.size

  if m == list.size
    acc << (q + list)
    return acc
  end

  a, *b = list

  acc << q + [a] if m == 1

  acc = list_comb(b, m - 1, acc, q + [a])
  list_comb(b, m, acc, q)
end

r26 = [
  %w[a b c],
  %w[a b d],
  %w[a b e],
  %w[a c d],
  %w[a c e],
  %w[a d e],
  %w[b c d],
  %w[b c e],
  %w[b d e],
  %w[c d e]
]

assert r26 = list_comb(%w[a b c d e], 3)


#     P27 (**) Group the elements of a set into disjoint subsets.
#     a) In how many ways can a group of 9 people work in 3 disjoint subgroups of 2, 3 and 4 persons? Write a function that generates all the possibilities and returns them in a list.
# 
#     Example:
#     * (group3 '(aldo beat carla david evi flip gary hugo ida))
#     ( ( (ALDO BEAT) (CARLA DAVID EVI) (FLIP GARY HUGO IDA) )
#     ... )
# 
#     b) Generalize the above predicate in a way that we can specify a list of group sizes and the predicate will return a list of groups.
# 
#     Example:
#     * (group '(aldo beat carla david evi flip gary hugo ida) '(2 2 5))
#     ( ( (ALDO BEAT) (CARLA DAVID) (EVI FLIP GARY HUGO IDA) )
#     ... )
# 
#     Note that we do not want permutations of the group members; i.e. ((ALDO BEAT) ...) is the same solution as ((BEAT ALDO) ...). However, we make a difference between ((ALDO BEAT) (CARLA DAVID) ...) and ((CARLA DAVID) (ALDO BEAT) ...).
# 
#     You may find more about this combinatorial problem in a good book on discrete mathematics under the term "multinomial coefficients".


def list_gcombo(list, ns, acc = [], q = [], rest = list, qg = [])
  if ns.inject(0,&:+) != list.size && acc.empty?
    p list, ns
    raise ArgumentError, "Invalid groupping #{ns} with #{list}"
  end

  if ns.empty?
    acc << qg
    return acc
  end

  return acc if list.empty?

  n,*nt = ns
  h,*t = list

  return acc if n == 0 || n > list.size

  s = q + [h]

  1 == n &&
    acc = list_gcombo(rest - s, nt, acc, [], rest - s, qg + [ s ])

  acc = list_gcombo(t, [n - 1] + nt, acc, s, rest, qg)
        list_gcombo(t,           ns, acc, q, rest, qg)
end

r27 = [
 [[1, 2], [3, 4], [5]],
 [[1, 2], [3, 5], [4]],
 [[1, 2], [4, 5], [3]],
 [[1, 3], [2, 4], [5]],
 [[1, 3], [2, 5], [4]],
 [[1, 3], [4, 5], [2]],
 [[1, 4], [2, 3], [5]],
 [[1, 4], [2, 5], [3]],
 [[1, 4], [3, 5], [2]],
 [[1, 5], [2, 3], [4]],
 [[1, 5], [2, 4], [3]],
 [[1, 5], [3, 4], [2]],
 [[2, 3], [1, 4], [5]],
 [[2, 3], [1, 5], [4]],
 [[2, 3], [4, 5], [1]],
 [[2, 4], [1, 3], [5]],
 [[2, 4], [1, 5], [3]],
 [[2, 4], [3, 5], [1]],
 [[2, 5], [1, 3], [4]],
 [[2, 5], [1, 4], [3]],
 [[2, 5], [3, 4], [1]],
 [[3, 4], [1, 2], [5]],
 [[3, 4], [1, 5], [2]],
 [[3, 4], [2, 5], [1]],
 [[3, 5], [1, 2], [4]],
 [[3, 5], [1, 4], [2]],
 [[3, 5], [2, 4], [1]],
 [[4, 5], [1, 2], [3]],
 [[4, 5], [1, 3], [2]],
 [[4, 5], [2, 3], [1]]
]


assert r27 = list_gcombo((1..5).to_a, [2,2,1])



#     P28 (**) Sorting a list of lists according to length of sublists
#     a) We suppose that a list contains elements that are lists themselves. The objective is to sort the elements of this list according to their length. E.g. short lists first, longer lists later, or vice versa.
# 
#     Example:
#     * (lsort '((a b c) (d e) (f g h) (d e) (i j k l) (m n) (o)))
#     ((o) (d e) (d e) (m n) (a b c) (f g h) (i j k l))
#
def list_sort(list, &block)
  list_mergesort(list, &block)
end

def list_mergesort(list, &block)
  n = list.size / 2
  if n == 0 then list
  else
    lft, rgt = list[0...n], list[n..-1]
    mergesort_merge(list_mergesort(lft, &block), list_mergesort(rgt, &block), &block)
  end
end

def mergesort_merge(lft, rgt, acc = [], &block)
  if lft.empty? || rgt.empty? then acc + lft + rgt
  else
    h1, *t1 = lft
    h2, *t2 = rgt

    default_comparator = ->(a, b) { a <=> b }

    if (block || default_comparator).(h1, h2) < 0 then mergesort_merge(t1, rgt, acc + [h1], &block)
    else mergesort_merge(lft, t2, acc + [h2], &block)
    end
  end
end

e28_ = [234, 1, 5, 0 , -2]
r28_ = [-2, 0, 1, 5, 234]

assert r28_ == list_sort(e28_)
assert %w[a b c d] == list_sort(%w[d a b c])

e28 = [%w(a b c), %w(d e), %w(f g h), %w(d e), %w(i j k l), %w(m n), %w(o)]
r28 = [%w(o), %w(d e), %w(d e), %w(m n), %w(a b c), %w(f g h), %w(i j k l)]

#idiomatic ruby
len_comparator = lambda do |a, b|
  # order lexicographically 
  if a.length == b.length then a.join <=> b.join
  else a.length <=> b.length
  end
end

# verify with ruby stdlib first
assert r28 == e28.sort(&len_comparator)

# now with our implementation
assert list_sort(e28, &len_comparator)

# 
#     b) Again, we suppose that a list contains elements that are lists themselves. But this time the objective is to sort the elements of this list according to their length frequency; i.e., in the default, where sorting is done ascendingly, lists with rare lengths are placed first, others with a more frequent length come later.
# 
#     Example:
#     * (lfsort '((a b c) (d e) (f g h) (d e) (i j k l) (m n) (o)))
#     ((i j k l) (o) (a b c) (f g h) (d e) (d e) (m n))

r28b = [%w(i j k l), %w(o), %w(a b c), %w(f g h), %w(d e), %w(d e), %w(m n)]

#build frequency
freq = e28.inject(Hash.new(1), &->(acc, el) { acc.merge(el.length => acc[el.length] + 1 ) })

len_freq_comparator = ->(a, b) do
  _a, _b = freq.values_at(a.length, b.length)
  if _a == _b then a.join <=> b.join
  else _a <=> _b
  end
end

# verify using native ruby sort
assert r28b == e28.sort(&len_freq_comparator)

# now with our implementation
assert r28b == list_sort(e28, &len_freq_comparator)

#
#     Note that in the above example, the first two lists in the result have length 4 and 1, both lengths appear just once. The third and forth list have length 3 which appears twice (there are two list of this length). And finally, the last three lists have length 2. This is the most frequent length.

# helper functions

def list_map(list, acc = [], &block)
  h, *t = list
  if list.empty? then acc
  else list_map(t, acc.push(block.(h)), &block)
  end
end
