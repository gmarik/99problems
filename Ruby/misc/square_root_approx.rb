# what's the value of sqrt(2)?
# without using math functions approximation is pretty straightforward
# given:
#      _
# x = V2
# then
# x^2 = 2
# function
#
# f(x) = x^2-2
#  _
# V2 is a root of the f(x).
# 
# using intermediate value theorem
# If f(x) is a function that is continuous for all x 
# in the closed interval [a, b] and d is between f (a) and f (b), 
# then there is a number c in [a, b] such that f (c) = d.
#                                                                  _
# so the x value is between [1,2] as 0( the value of f(x) for x = V2) is between [-1;2]
# 1 < x < 2 as -1 < f(x)=0 < 2

F = lambda {|x|  x*x - 2.0 } 

def approx(l=1.0, r=2.0, e = 0.001)
  x = (l + r) / 2.0
  fx = F[x]
  p [x, l, r, fx]

  return if (r - l) < e

  if    fx == 0.0 then puts fx
  elsif fx < 0.0  then approx(x, r)
  else approx(l, x)
  end
end

approx()

# [1.5, 1.0, 2.0, 0.25]
# [1.25, 1.0, 1.5, -0.4375]
# [1.375, 1.25, 1.5, -0.109375]
# [1.4375, 1.375, 1.5, 0.06640625]
# [1.40625, 1.375, 1.4375, -0.0224609375]
# [1.421875, 1.40625, 1.4375, 0.021728515625]
# [1.4140625, 1.40625, 1.421875, -0.00042724609375]
# [1.41796875, 1.4140625, 1.421875, 0.0106353759765625]
# [1.416015625, 1.4140625, 1.41796875, 0.005100250244140625]
# [1.4150390625, 1.4140625, 1.416015625, 0.0023355484008789062]
# [1.41455078125, 1.4140625, 1.4150390625, 0.0009539127349853516]
