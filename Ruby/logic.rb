require 'test/unit'
include Test::Unit::Assertions

## Logic and Codes


#  P46 (**) Truth tables for logical expressions.
#  Define predicates and/2, or/2, nand/2, nor/2, xor/2, impl/2 and equ/2 (for logical equivalence) which succeed or fail according to the result of their respective operations; e.g. and(A,B) will succeed, if and only if both A and B succeed. Note that A and B can be Prolog goals (not only the constants true and fail).
#  A logical expression in two variables can then be written in prefix notation, as in the following example: and(or(A,B),nand(A,B)).
#
#  Now, write a predicate table/3 which prints the truth table of a given logical expression in two variables.
#
#  Example:
#  * table(A,B,and(A,or(A,B))).
#  true true true
#  true fail true
#  fail true fail
#  fail fail fail
#

ID  = ->(a) { a }

NOT = ->(a) {
  case a
  when true then false
  else           true
  end
}

AND = ->(a, b) {
  case [a, b]
  when [true, true] then  true
  else                    false
  end
}

OR   = ->(a, b) { NOT[AND[NOT[a], NOT[b]]] }
XOR  = ->(a, b) { OR[AND[a, NOT[b]], AND[NOT[a], b]] }
NAND = ->(a, b) { NOT[AND[a, b]] }
NOR  = ->(a, b) { NOT[OR[a, b]] }
EQU  = ->(a, b) { OR[AND[a, b], NOT[OR[a,b]]] }
IMPL = ->(a, b) { OR[NOT[a], b] }

def ttable(&block)
  n = block.arity
  trow = ->(args) { [*args, block.call(*args)]  }
  bool_permutations(n).map(&trow)
end

def bool_permutations(n)
  return [[]] if n == 0
  sub = bool_permutations(n - 1)
  [false, true].flat_map do |v|
    sub.map { |s| [v] + s }
  end
end

assert_equal bool_permutations(2), [
  [false, false],
  [false, true],
  [true,  false],
  [true,  true],
]

assert_equal ttable(&ID), [
  [false, false],
  [true,  true],
]

assert_equal ttable(&NOT), [
  [false, true],
  [true,  false],
]

assert_equal ttable(&AND), [
  [false, false, false],
  [false, true,  false],
  [true,  false, false],
  [true,  true,   true],
]

assert_equal ttable(&OR), [
  [false, false, false],
  [false, true,  true],
  [true,  false, true],
  [true,  true,  true],
]

assert_equal ttable(&XOR), [
  [false, false, false],
  [false, true,  true],
  [true,  false, true],
  [true,  true,  false],
]

assert_equal ttable(&EQU), [
  [false, false, true],
  [false, true,  false],
  [true,  false, false],
  [true,  true,  true],
]

assert_equal ttable(&IMPL), [
  [false, false, true],
  [false, true,  true],
  [true,  false, false],
  [true,  true,  true],
]

assert_equal ttable(& exp = ->(a, b) { AND[a, OR[a, b]] }), [
  [false, false, false],
  [false, true,  false],
  [true,  false, true],
  [true,  true,  true]
]


#
#
#  P47 (*) Truth tables for logical expressions (2).
#  Continue problem P46 by defining and/2, or/2, etc as being operators.
#  This allows to write the logical expression in the more natural way, as in the example: A and (A or not B).
#  Define operator precedence as usual; i.e. as in Java.
#  Example:
#  * table(A,B, A and (A or not B)).
#  true true true
#  true fail true
#  fail true fail
#  fail fail fail
#

module P47

  def and(other)
    AND[self, other]
  end

  def or(other)
    OR[self, other]
  end

  def equ(other)
    EQU[self, other]
  end
end

class TrueClass
  include P47
end

class FalseClass
  include P47
end

assert_equal ttable(& exp = ->(a, b) { a.and (a.or b)}), [
  [false, false, false],
  [false, true,  false],
  [true,  false, true],
  [true,  true,  true]
]

#
#
#  P48 (**) Truth tables for logical expressions (3).
#  Generalize problem P47 in such a way that the logical expression may contain any number of logical variables.
#  Define table/2 in a way that table(List,Expr) prints the truth table for the expression Expr, which contains the logical variables enumerated in List.
#  Example:
#  * table([A,B,C], A and (B or C) equ A and B or A and C).
#  true true true true
#  true true fail true
#  true fail true true
#  true fail fail true
#  fail true true true
#  fail true fail true
#  fail fail true true
#  fail fail fail true

assert_equal ttable(& exp = ->(a, b, c) { (a.and (b.or c)).equ a.and b.or a.and c}), [
  [true,  true,  true,  true], 
  [true,  true,  false, true],
  [true,  false, true,  true],
  [true,  false, false, true],
  [false, true,  true,  true],
  [false, true,  false, true],
  [false, false, true,  true],
  [false, false, false, true],
].reverse


#
#
#  P49 (**) Gray code.
#  An n-bit Gray code is a sequence of n-bit strings constructed according to certain rules. For example,
#  n = 1: C(1) = ['0','1'].
#  n = 2: C(2) = ['00','01','11','10'].
#  n = 3: C(3) = ['000','001','011','010',´110´,´111´,´101´,´100´].
#
#  Find out the construction rules and write a predicate with the following specification:
#
#  % gray(N,C) :- C is the N-bit Gray code
#
#  Can you apply the method of "result caching" in order to make the predicate more efficient, when it is to be used repeatedly?

def gray_code(n)
  return [[]] if n == 0
  sub = gray_code(n - 1)
  (sub.map { |s| [0] + s }) + (sub.reverse.map { |s| [1] + s })
end


assert_equal gray_code(2), [[0, 0], [0, 1], [1, 1], [1, 0]]
assert_equal gray_code(3), [[0, 0, 0], [0, 0, 1], [0, 1, 1], [0, 1, 0], [1, 1, 0], [1, 1, 1], [1, 0, 1], [1, 0, 0]]

#
#
#  P50 (***) Huffman code.
#  First of all, consult a good book on discrete mathematics or algorithms for a detailed description of Huffman codes!
#
#  We suppose a set of symbols with their frequencies, given as a list of fr(S,F) terms. 
#  Example: [fr(a,45),fr(b,13),fr(c,12),fr(d,16),fr(e,9),fr(f,5)]. 
#  Our objective is to construct a list hc(S,C) terms, where C is the Huffman code word for the symbol S. 
#  In our example, the result could be Hs = [hc(a,'0'), hc(b,'101'), hc(c,'100'), hc(d,'111'), hc(e,'1101'), hc(f,'1100')] [hc(a,'01'),...etc.].
#  The task shall be performed by the predicate huffman/2 defined as follows: 
#
#  % huffman(Fs,Hs) :- Hs is the Huffman code table for the frequency table Fs
