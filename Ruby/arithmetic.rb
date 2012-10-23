require 'test/unit/assertions'
include Test::Unit::Assertions


#    P31 (**) Determine whether a given integer number is prime.
#    Example:
#    * (is-prime 7)
#    t

def prime?(n, m = n / 2)
  if    (n == 1 || m == 1)  then true
  elsif (0 == n % m)        then false
  else prime?(n, m - 1)
  end
end

assert prime?(1)
assert prime?(2)
assert prime?(3)
assert prime?(5)
assert prime?(7)
assert prime?(11)
assert (not prime?(4))
assert (not prime?(10))

#    P32 (**) Determine the greatest common divisor of two positive integer numbers.
#    Use Euclid's algorithm.
#    Example:
#    * (gcd 36 63)
#    9
def gcd(a, b)
  if (b == 0) then a
  else gcd(b, a % b)
  end
end

assert 9 == gcd(36, 63)
assert 1 == gcd(7, 5)

#
#    P33 (*) Determine whether two positive integer numbers are coprime.
#    Two numbers are coprime if their greatest common divisor equals 1.
#    Example:
#    * (coprime 35 64)
#    T
def coprime(a, b)
  1 == gcd(a, b)
end

assert coprime(35, 64)

#
#    P34 (**) Calculate Euler's totient function phi(m).
#    Euler's so-called totient function phi(m) is defined as the number of positive integers r (1 <= r < m) that are coprime to m.
#    Example: m = 10: r = 1,3,7,9; thus phi(m) = 4. Note the special case: phi(1) = 1.
#    Find out what the value of phi(m) is if m is a prime number. Euler's totient function plays an important role in one of the most widely used public key cryptography methods (RSA). In this exercise you should use the most primitive method to calculate this function (there are smarter ways that we shall discuss later).
#
#    * (totient-phi 10)
#    4

def totient_phi(n, m = n, acc = 1)
  if m == 1 then acc
  else totient_phi(n, m - 1, ( coprime(n, m) ? 1:0 ) + acc)
  end
end

assert 1  == totient_phi(1)
assert 1  == totient_phi(2)
assert 2  == totient_phi(3)
assert 4  == totient_phi(10)
assert 10 == totient_phi(11)

#
#
#
#    P35 (**) Determine the prime factors of a given positive integer.
#    Construct a flat list containing the prime factors in ascending order.
#    Example:
#    * (prime-factors 315)
#    (3 3 5 7)
#

def prime_factors(k, m = k/2, acc = [])


end

assert [3, 3, 5, 7] == prime_factors(315)


#
#
#    P36 (**) Determine the prime factors of a given positive integer (2).
#    Construct a list containing the prime factors and their multiplicity.
#    Hint: The problem is similar to problem P13.
#    Example:
#    * (prime-factors-mult 315)
#    ((3 2) (5 1) (7 1))
#
#
#    P37 (**) Calculate Euler's totient function phi(m) (improved).
#    See problem P34 for the definition of Euler's totient function. If the list of the prime factors of a number m is known in the form of problem P36 then the function phi(m) can be efficiently calculated as follows: Let ((p1 m1) (p2 m2) (p3 m3) ...) be the list of prime factors (and their multiplicities) of a given number m. Then phi(m) can be calculated with the following formula:
#    phi(m) = (p1 - 1) * p1 ** (m1 - 1) + (p2 - 1) * p2 ** (m2 - 1) + (p3 - 1) * p3 ** (m3 - 1) + ...
#
#    Note that a ** b stands for the b'th power of a.
#
#
#    P38 (*) Compare the two methods of calculating Euler's totient function.
#    Use the solutions of problems P34 and P37 to compare the algorithms. Take the number of logical inferences as a measure for efficiency. Try to calculate phi(10090) as an example.
#
#
#    P39 (*) A list of prime numbers.
#    Given a range of integers by its lower and upper limit, construct a list of all prime numbers in that range.
#
#
#    P40 (**) Goldbach's conjecture.
#    Goldbach's conjecture says that every positive even number greater than 2 is the sum of two prime numbers. Example: 28 = 5 + 23. It is one of the most famous facts in number theory that has not been proved to be correct in the general case. It has been numerically confirmed up to very large numbers (much larger than we can go with our Prolog system). Write a predicate to find the two prime numbers that sum up to a given even integer.
#    Example:
#    * (goldbach 28)
#    (5 23)
#
#
#    P41 (**) A list of Goldbach compositions.
#    Given a range of integers by its lower and upper limit, print a list of all even numbers and their Goldbach composition.
#    Example:
#    * (goldbach-list 9 20)
#    10 = 3 + 7
#    12 = 5 + 7
#    14 = 3 + 11
#    16 = 3 + 13
#    18 = 5 + 13
#    20 = 3 + 17
#
#    In most cases, if an even number is written as the sum of two prime numbers, one of them is very small. Very rarely, the primes are both bigger than say 50. Try to find out how many such cases there are in the range 2..3000.
#
#    Example (for a print limit of 50):
#    * (goldbach-list 1 2000 50)
#    992 = 73 + 919
#    1382 = 61 + 1321
#    1856 = 67 + 1789
#    1928 = 61 + 1867
